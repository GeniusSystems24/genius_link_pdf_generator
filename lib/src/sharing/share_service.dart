import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'share_models.dart';


Future<ShareResult> _shareFiles(
  List<XFile> files, {
  String? subject,
  String? text,
}) =>
    SharePlus.instance.share(
      ShareParams(
        files: files,
        subject: subject,
        text: text,
      ),
    );
/// Unified sharing service for PDF files.
///
/// Provides a single interface for sharing PDFs through various channels:
/// - System share sheet
/// - Email
/// - Bluetooth
/// - Specific apps
/// - Cloud storage
/// - Local storage
///
/// Example:
/// ```dart
/// final service = GeniusShareService.instance;
///
/// // Share via system share sheet
/// final result = await service.share(
///   pdfBytes: bytes,
///   fileName: 'invoice.pdf',
///   target: GeniusShareTarget.system(),
/// );
///
/// // Share via email
/// final emailResult = await service.share(
///   pdfBytes: bytes,
///   fileName: 'report.pdf',
///   target: GeniusShareTarget.email(
///     toAddress: 'client@example.com',
///     subject: 'Monthly Report',
///   ),
/// );
/// ```
class GeniusShareService {
  GeniusShareService._();

  static final GeniusShareService _instance = GeniusShareService._();

  /// Singleton instance.
  static GeniusShareService get instance => _instance;

  /// Configuration.
  GeniusShareConfig _config = GeniusShareConfig.defaults;

  /// Share history.
  final List<GeniusShareHistoryItem> _history = [];

  /// Quick share contacts.
  final List<GeniusQuickShareContact> _contacts = [];

  /// Message templates.
  final List<GeniusShareMessageTemplate> _templates = [];

  /// Whether initialized.
  bool _initialized = false;

  /// Stream controller for share events.
  final _shareEventsController =
      StreamController<GeniusShareResult>.broadcast();

  /// Stream of share events.
  Stream<GeniusShareResult> get shareEvents => _shareEventsController.stream;

  /// Get current configuration.
  GeniusShareConfig get config => _config;

  /// Get share history.
  List<GeniusShareHistoryItem> get history => List.unmodifiable(_history);

  /// Get quick share contacts.
  List<GeniusQuickShareContact> get contacts => List.unmodifiable(_contacts);

  /// Get favorite contacts.
  List<GeniusQuickShareContact> get favoriteContacts =>
      _contacts.where((c) => c.isFavorite).toList();

  /// Get recent contacts (sorted by last used).
  List<GeniusQuickShareContact> get recentContacts {
    final sorted = List<GeniusQuickShareContact>.from(_contacts)
      ..sort((a, b) {
        if (a.lastUsed == null && b.lastUsed == null) return 0;
        if (a.lastUsed == null) return 1;
        if (b.lastUsed == null) return -1;
        return b.lastUsed!.compareTo(a.lastUsed!);
      });
    return sorted.take(10).toList();
  }

  /// Get message templates.
  List<GeniusShareMessageTemplate> get templates =>
      List.unmodifiable(_templates);

  /// Initialize the service.
  Future<void> initialize({GeniusShareConfig? config}) async {
    if (_initialized) return;

    _config = config ?? GeniusShareConfig.defaults;

    // Load persisted data
    await _loadHistory();
    await _loadContacts();
    _loadDefaultTemplates();

    _initialized = true;
  }

  /// Update configuration.
  void updateConfig(GeniusShareConfig config) {
    _config = config;
  }

  /// Share PDF bytes via the specified target.
  ///
  /// Returns a [GeniusShareResult] indicating success or failure.
  Future<GeniusShareResult> share({
    required Uint8List pdfBytes,
    required String fileName,
    required GeniusShareTarget target,
    String? subject,
    String? body,
    void Function(double progress)? onProgress,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      // Validate file size
      if (_config.maxFileSize != null &&
          pdfBytes.length > _config.maxFileSize!) {
        return GeniusShareResult.failure(
          target: target,
          error:
              'File size (${_formatFileSize(pdfBytes.length)}) exceeds maximum allowed (${_formatFileSize(_config.maxFileSize!)})',
        );
      }

      // Save file temporarily
      final tempDir = await getTemporaryDirectory();
      final timestamp = _config.includeTimestamp
          ? '_${DateTime.now().millisecondsSinceEpoch}'
          : '';
      final filePath =
          '${tempDir.path}/${_sanitizeFileName(fileName)}$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      onProgress?.call(0.3);

      // Execute share based on target type
      GeniusShareResult result;
      switch (target.type) {
        case GeniusShareTargetType.system:
          result = await _shareViaSystem(file, target, subject, body);
          break;
        case GeniusShareTargetType.email:
          result = await _shareViaEmail(file, target, subject, body);
          break;
        case GeniusShareTargetType.bluetooth:
          result = await _shareViaBluetooth(file, target);
          break;
        case GeniusShareTargetType.app:
          result = await _shareViaApp(file, target, subject, body);
          break;
        case GeniusShareTargetType.cloud:
          result = await _shareToCloud(file, target, onProgress);
          break;
        case GeniusShareTargetType.local:
          result = await _saveToLocal(file, target, fileName);
          break;
      }

      onProgress?.call(1.0);

      // Record in history
      final historyItem = GeniusShareHistoryItem.fromResult(result, fileName);
      _history.insert(0, historyItem);
      await _saveHistory();

      // Emit event
      _shareEventsController.add(result);

      return result;
    } catch (e) {
      final result = GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
      _shareEventsController.add(result);
      return result;
    }
  }

  /// Quick share to a saved contact.
  Future<GeniusShareResult> quickShare({
    required Uint8List pdfBytes,
    required String fileName,
    required GeniusQuickShareContact contact,
    String? subject,
    String? body,
  }) async {
    final result = await share(
      pdfBytes: pdfBytes,
      fileName: fileName,
      target: contact.target,
      subject: subject,
      body: body,
    );

    // Update contact usage
    if (result.isSuccess) {
      await _updateContactUsage(contact.id);
    }

    return result;
  }

  /// Share with a message template.
  Future<GeniusShareResult> shareWithTemplate({
    required Uint8List pdfBytes,
    required String fileName,
    required GeniusShareTarget target,
    required GeniusShareMessageTemplate template,
    required Map<String, String> variables,
    bool useArabic = false,
  }) async {
    return share(
      pdfBytes: pdfBytes,
      fileName: fileName,
      target: target,
      subject: template.applyToSubject(variables, useArabic: useArabic),
      body: template.applyToBody(variables, useArabic: useArabic),
    );
  }

  // Private sharing methods

  Future<GeniusShareResult> _shareViaSystem(
    File file,
    GeniusShareTarget target,
    String? subject,
    String? body,
  ) async {
    try {
      final result = await _shareFiles(
        [XFile(file.path)],
        subject: subject,
        text: body,
      );

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: target,
          message: 'Shared successfully',
          filePath: file.path,
          fileSize: await file.length(),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(target: target);
      } else {
        return GeniusShareResult.failure(
          target: target,
          error: 'Share was unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  Future<GeniusShareResult> _shareViaEmail(
    File file,
    GeniusShareTarget target,
    String? subject,
    String? body,
  ) async {
    // Use system share with email-specific subject and body
    // The actual email implementation will be in v2.3.1
    try {
      final emailSubject = subject ??
          target.metadata['subject'] as String? ??
          _config.defaultSubject ??
          '';
      final emailBody = body ??
          target.metadata['body'] as String? ??
          _config.defaultBody ??
          '';

      final result = await _shareFiles(
        [XFile(file.path)],
        subject: emailSubject,
        text: emailBody,
      );

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: target,
          message: 'Email prepared successfully',
          filePath: file.path,
          fileSize: await file.length(),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(target: target);
      } else {
        return GeniusShareResult.failure(
          target: target,
          error: 'Email sharing unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  Future<GeniusShareResult> _shareViaBluetooth(
    File file,
    GeniusShareTarget target,
  ) async {
    // Bluetooth sharing will be implemented in v2.3.2
    // For now, use system share
    try {
      final result = await _shareFiles([XFile(file.path)]);

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: target,
          message: 'Ready to share via Bluetooth',
          filePath: file.path,
          fileSize: await file.length(),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(target: target);
      } else {
        return GeniusShareResult.failure(
          target: target,
          error: 'Bluetooth sharing unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  Future<GeniusShareResult> _shareViaApp(
    File file,
    GeniusShareTarget target,
    String? subject,
    String? body,
  ) async {
    // Direct app sharing will be enhanced in v2.3.3
    // For now, use system share
    try {
      final result = await _shareFiles(
        [XFile(file.path)],
        subject: subject,
        text: body,
      );

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: target,
          message: 'Shared to ${target.displayName}',
          filePath: file.path,
          fileSize: await file.length(),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(target: target);
      } else {
        return GeniusShareResult.failure(
          target: target,
          error: 'App sharing unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  Future<GeniusShareResult> _shareToCloud(
    File file,
    GeniusShareTarget target,
    void Function(double progress)? onProgress,
  ) async {
    // Cloud sharing will be implemented in v2.4.0
    // For now, use system share
    try {
      onProgress?.call(0.5);
      final result = await _shareFiles([XFile(file.path)]);
      onProgress?.call(0.9);

      if (result.status == ShareResultStatus.success) {
        return GeniusShareResult.success(
          target: target,
          message: 'Ready to upload to ${target.cloudProvider}',
          filePath: file.path,
          fileSize: await file.length(),
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusShareResult.cancelled(target: target);
      } else {
        return GeniusShareResult.failure(
          target: target,
          error: 'Cloud sharing unavailable',
        );
      }
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  Future<GeniusShareResult> _saveToLocal(
    File file,
    GeniusShareTarget target,
    String fileName,
  ) async {
    try {
      String destinationPath;

      if (target.localPath != null) {
        destinationPath = '${target.localPath}/$fileName.pdf';
      } else {
        // Use documents directory as default
        final docsDir = await getApplicationDocumentsDirectory();
        destinationPath = '${docsDir.path}/$fileName.pdf';
      }

      // Ensure directory exists
      final destFile = File(destinationPath);
      await destFile.parent.create(recursive: true);

      // Copy file
      await file.copy(destinationPath);

      return GeniusShareResult.success(
        target: target,
        message: 'Saved to $destinationPath',
        filePath: destinationPath,
        fileSize: await file.length(),
      );
    } catch (e) {
      return GeniusShareResult.failure(
        target: target,
        error: e.toString(),
      );
    }
  }

  // Contact management

  /// Add a quick share contact.
  Future<void> addContact(GeniusQuickShareContact contact) async {
    _contacts.add(contact);
    await _saveContacts();
  }

  /// Remove a quick share contact.
  Future<void> removeContact(String contactId) async {
    _contacts.removeWhere((c) => c.id == contactId);
    await _saveContacts();
  }

  /// Toggle contact favorite status.
  Future<void> toggleFavorite(String contactId) async {
    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      _contacts[index] = _contacts[index].copyWith(
        isFavorite: !_contacts[index].isFavorite,
      );
      await _saveContacts();
    }
  }

  Future<void> _updateContactUsage(String contactId) async {
    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      _contacts[index] = _contacts[index].copyWith(
        usageCount: _contacts[index].usageCount + 1,
        lastUsed: DateTime.now(),
      );
      await _saveContacts();
    }
  }

  // Template management

  /// Add a custom message template.
  void addTemplate(GeniusShareMessageTemplate template) {
    _templates.add(template);
  }

  /// Get template by ID.
  GeniusShareMessageTemplate? getTemplate(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void _loadDefaultTemplates() {
    _templates.clear();
    _templates.addAll([
      GeniusShareMessageTemplate.invoice(),
      GeniusShareMessageTemplate.report(),
      GeniusShareMessageTemplate.document(),
    ]);
  }

  // History management

  /// Clear share history.
  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
  }

  /// Get history for a specific target type.
  List<GeniusShareHistoryItem> getHistoryForType(GeniusShareTargetType type) {
    return _history.where((h) => h.target.type == type).toList();
  }

  /// Get successful shares.
  List<GeniusShareHistoryItem> get successfulShares {
    return _history
        .where((h) => h.status == GeniusShareStatus.completed)
        .toList();
  }

  // Persistence

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('genius_share_history');
      if (historyJson != null) {
        final List<dynamic> list = jsonDecode(historyJson);
        _history.clear();
        _history.addAll(
          list.map((item) =>
              GeniusShareHistoryItem.fromJson(item as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Keep only last 100 items
      final toSave = _history.take(100).toList();
      await prefs.setString(
        'genius_share_history',
        jsonEncode(toSave.map((h) => h.toJson()).toList()),
      );
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> _loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString('genius_share_contacts');
      if (contactsJson != null) {
        final List<dynamic> list = jsonDecode(contactsJson);
        _contacts.clear();
        for (final item in list) {
          final json = item as Map<String, dynamic>;
          final targetData = json['targetData'] as Map<String, dynamic>?;
          _contacts.add(GeniusQuickShareContact(
            id: json['id'] as String,
            name: json['name'] as String,
            nameAr: json['nameAr'] as String?,
            target: GeniusShareTarget(
              type: GeniusShareTargetType.values.firstWhere(
                (t) => t.name == json['targetType'],
                orElse: () => GeniusShareTargetType.system,
              ),
              appPackageName: targetData?['appPackageName'] as String?,
              emailAddress: targetData?['emailAddress'] as String?,
              bluetoothDeviceId: targetData?['bluetoothDeviceId'] as String?,
              cloudProvider: targetData?['cloudProvider'] as String?,
              localPath: targetData?['localPath'] as String?,
            ),
            usageCount: json['usageCount'] as int? ?? 0,
            lastUsed: json['lastUsed'] != null
                ? DateTime.parse(json['lastUsed'] as String)
                : null,
            isFavorite: json['isFavorite'] as bool? ?? false,
          ));
        }
      }
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> _saveContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'genius_share_contacts',
        jsonEncode(_contacts.map((c) => c.toJson()).toList()),
      );
    } catch (_) {
      // Ignore errors
    }
  }

  // Utilities

  String _sanitizeFileName(String fileName) {
    // Remove extension if present
    var name = fileName;
    if (name.toLowerCase().endsWith('.pdf')) {
      name = name.substring(0, name.length - 4);
    }
    // Replace invalid characters
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Dispose the service.
  void dispose() {
    _shareEventsController.close();
  }
}
