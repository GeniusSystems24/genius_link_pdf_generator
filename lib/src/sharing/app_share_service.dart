import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


/// Known app identifiers for direct sharing.
class GeniusKnownApps {
  GeniusKnownApps._();

  // Android package names
  static const whatsAppAndroid = 'com.whatsapp';
  static const whatsAppBusinessAndroid = 'com.whatsapp.w4b';
  static const telegramAndroid = 'org.telegram.messenger';
  static const signalAndroid = 'org.thoughtcrime.securesms';
  static const viberAndroid = 'com.viber.voip';
  static const lineAndroid = 'jp.naver.line.android';
  static const weChatAndroid = 'com.tencent.mm';
  static const facebookMessengerAndroid = 'com.facebook.orca';
  static const gmailAndroid = 'com.google.android.gm';
  static const outlookAndroid = 'com.microsoft.office.outlook';
  static const slackAndroid = 'com.Slack';
  static const teamsAndroid = 'com.microsoft.teams';
  static const driveAndroid = 'com.google.android.apps.docs';
  static const dropboxAndroid = 'com.dropbox.android';
  static const onedriveAndroid = 'com.microsoft.skydrive';

  // iOS URL schemes
  static const whatsAppIOS = 'whatsapp://';
  static const telegramIOS = 'tg://';
  static const signalIOS = 'sgnl://';
  static const viberIOS = 'viber://';
  static const lineIOS = 'line://';
  static const weChatIOS = 'weixin://';
  static const facebookMessengerIOS = 'fb-messenger://';
}

/// Represents an installed app that supports file sharing.
class GeniusSharableApp {
  /// Creates a sharable app.
  const GeniusSharableApp({
    required this.id,
    required this.name,
    this.nameAr,
    required this.packageName,
    this.iosScheme,
    this.iconData,
    this.category = GeniusAppCategory.messaging,
  });

  /// WhatsApp app.
  factory GeniusSharableApp.whatsApp() => const GeniusSharableApp(
        id: 'whatsapp',
        name: 'WhatsApp',
        nameAr: 'واتساب',
        packageName: GeniusKnownApps.whatsAppAndroid,
        iosScheme: GeniusKnownApps.whatsAppIOS,
        category: GeniusAppCategory.messaging,
      );

  /// WhatsApp Business app.
  factory GeniusSharableApp.whatsAppBusiness() => const GeniusSharableApp(
        id: 'whatsapp_business',
        name: 'WhatsApp Business',
        nameAr: 'واتساب بيزنس',
        packageName: GeniusKnownApps.whatsAppBusinessAndroid,
        iosScheme: GeniusKnownApps.whatsAppIOS,
        category: GeniusAppCategory.messaging,
      );

  /// Telegram app.
  factory GeniusSharableApp.telegram() => const GeniusSharableApp(
        id: 'telegram',
        name: 'Telegram',
        nameAr: 'تيليجرام',
        packageName: GeniusKnownApps.telegramAndroid,
        iosScheme: GeniusKnownApps.telegramIOS,
        category: GeniusAppCategory.messaging,
      );

  /// Signal app.
  factory GeniusSharableApp.signal() => const GeniusSharableApp(
        id: 'signal',
        name: 'Signal',
        nameAr: 'سيجنال',
        packageName: GeniusKnownApps.signalAndroid,
        iosScheme: GeniusKnownApps.signalIOS,
        category: GeniusAppCategory.messaging,
      );

  /// Gmail app.
  factory GeniusSharableApp.gmail() => const GeniusSharableApp(
        id: 'gmail',
        name: 'Gmail',
        nameAr: 'جيميل',
        packageName: GeniusKnownApps.gmailAndroid,
        category: GeniusAppCategory.email,
      );

  /// Outlook app.
  factory GeniusSharableApp.outlook() => const GeniusSharableApp(
        id: 'outlook',
        name: 'Outlook',
        nameAr: 'أوتلوك',
        packageName: GeniusKnownApps.outlookAndroid,
        category: GeniusAppCategory.email,
      );

  /// Google Drive app.
  factory GeniusSharableApp.googleDrive() => const GeniusSharableApp(
        id: 'gdrive',
        name: 'Google Drive',
        nameAr: 'جوجل درايف',
        packageName: GeniusKnownApps.driveAndroid,
        category: GeniusAppCategory.storage,
      );

  /// Dropbox app.
  factory GeniusSharableApp.dropbox() => const GeniusSharableApp(
        id: 'dropbox',
        name: 'Dropbox',
        nameAr: 'دروب بوكس',
        packageName: GeniusKnownApps.dropboxAndroid,
        category: GeniusAppCategory.storage,
      );

  /// OneDrive app.
  factory GeniusSharableApp.oneDrive() => const GeniusSharableApp(
        id: 'onedrive',
        name: 'OneDrive',
        nameAr: 'ون درايف',
        packageName: GeniusKnownApps.onedriveAndroid,
        category: GeniusAppCategory.storage,
      );

  /// Slack app.
  factory GeniusSharableApp.slack() => const GeniusSharableApp(
        id: 'slack',
        name: 'Slack',
        nameAr: 'سلاك',
        packageName: GeniusKnownApps.slackAndroid,
        category: GeniusAppCategory.work,
      );

  /// Microsoft Teams app.
  factory GeniusSharableApp.teams() => const GeniusSharableApp(
        id: 'teams',
        name: 'Microsoft Teams',
        nameAr: 'مايكروسوفت تيمز',
        packageName: GeniusKnownApps.teamsAndroid,
        category: GeniusAppCategory.work,
      );

  /// App identifier.
  final String id;

  /// Display name.
  final String name;

  /// Arabic display name.
  final String? nameAr;

  /// Android package name.
  final String packageName;

  /// iOS URL scheme.
  final String? iosScheme;

  /// Icon data (for custom icons).
  final Uint8List? iconData;

  /// App category.
  final GeniusAppCategory category;
}

/// App category for grouping.
enum GeniusAppCategory {
  /// Messaging apps (WhatsApp, Telegram, etc.)
  messaging('Messaging', 'المراسلة'),

  /// Email apps (Gmail, Outlook, etc.)
  email('Email', 'البريد'),

  /// Cloud storage apps (Drive, Dropbox, etc.)
  storage('Storage', 'التخزين'),

  /// Work/productivity apps (Slack, Teams, etc.)
  work('Work', 'العمل'),

  /// Other apps
  other('Other', 'أخرى');

  const GeniusAppCategory(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Local storage location.
enum GeniusStorageLocation {
  /// Downloads folder
  downloads('Downloads', 'التنزيلات'),

  /// Documents folder
  documents('Documents', 'المستندات'),

  /// Application documents
  appDocuments('App Documents', 'مستندات التطبيق'),

  /// Custom location
  custom('Custom', 'مخصص');

  const GeniusStorageLocation(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Result of app sharing operation.
class GeniusAppShareResult {
  /// Creates an app share result.
  const GeniusAppShareResult({
    required this.success,
    this.app,
    this.message,
    this.error,
    this.filePath,
  });

  /// Factory for success.
  factory GeniusAppShareResult.success({
    GeniusSharableApp? app,
    String? message,
    String? filePath,
  }) {
    return GeniusAppShareResult(
      success: true,
      app: app,
      message: message ?? 'Shared successfully',
      filePath: filePath,
    );
  }

  /// Factory for failure.
  factory GeniusAppShareResult.failure(String error, {GeniusSharableApp? app}) {
    return GeniusAppShareResult(
      success: false,
      app: app,
      error: error,
    );
  }

  /// Whether the operation was successful.
  final bool success;

  /// App involved (if any).
  final GeniusSharableApp? app;

  /// Success message.
  final String? message;

  /// Error message.
  final String? error;

  /// Path to saved file (for local saves).
  final String? filePath;
}

/// App sharing service for PDF documents.
///
/// Provides direct sharing to specific apps and local storage:
/// - Messaging apps (WhatsApp, Telegram, Signal, etc.)
/// - Email apps (Gmail, Outlook)
/// - Cloud storage apps (Drive, Dropbox, OneDrive)
/// - Work apps (Slack, Teams)
/// - Local storage (Downloads, Documents)
///
/// Example:
/// ```dart
/// final service = GeniusAppShareService.instance;
///
/// // Check available apps
/// final apps = await service.getAvailableApps();
///
/// // Share to WhatsApp
/// final result = await service.shareToApp(
///   pdfBytes: pdfBytes,
///   fileName: 'document.pdf',
///   app: GeniusSharableApp.whatsApp(),
/// );
///
/// // Save to Downloads
/// final saveResult = await service.saveToLocal(
///   pdfBytes: pdfBytes,
///   fileName: 'document.pdf',
///   location: GeniusStorageLocation.downloads,
/// );
/// ```
class GeniusAppShareService {
  GeniusAppShareService._();

  static final GeniusAppShareService _instance = GeniusAppShareService._();

  /// Singleton instance.
  static GeniusAppShareService get instance => _instance;

  /// All known apps.
  final List<GeniusSharableApp> _knownApps = [
    GeniusSharableApp.whatsApp(),
    GeniusSharableApp.whatsAppBusiness(),
    GeniusSharableApp.telegram(),
    GeniusSharableApp.signal(),
    GeniusSharableApp.gmail(),
    GeniusSharableApp.outlook(),
    GeniusSharableApp.googleDrive(),
    GeniusSharableApp.dropbox(),
    GeniusSharableApp.oneDrive(),
    GeniusSharableApp.slack(),
    GeniusSharableApp.teams(),
  ];

  /// Get all known apps.
  List<GeniusSharableApp> get knownApps => List.unmodifiable(_knownApps);

  /// Get apps by category.
  List<GeniusSharableApp> getAppsByCategory(GeniusAppCategory category) {
    return _knownApps.where((app) => app.category == category).toList();
  }

  /// Get messaging apps.
  List<GeniusSharableApp> get messagingApps =>
      getAppsByCategory(GeniusAppCategory.messaging);

  /// Get email apps.
  List<GeniusSharableApp> get emailApps =>
      getAppsByCategory(GeniusAppCategory.email);

  /// Get storage apps.
  List<GeniusSharableApp> get storageApps =>
      getAppsByCategory(GeniusAppCategory.storage);

  /// Get work apps.
  List<GeniusSharableApp> get workApps =>
      getAppsByCategory(GeniusAppCategory.work);

  /// Check if an app is available on this device.
  Future<bool> isAppAvailable(GeniusSharableApp app) async {
    if (Platform.isAndroid) {
      // On Android, try to check if package is installed
      // This is a simplified check - real implementation would use
      // package_info or platform channels
      return true; // Assume available, share_plus will handle
    } else if (Platform.isIOS && app.iosScheme != null) {
      final uri = Uri.parse(app.iosScheme!);
      return canLaunchUrl(uri);
    }
    return false;
  }

  /// Get list of available apps on this device.
  Future<List<GeniusSharableApp>> getAvailableApps() async {
    final available = <GeniusSharableApp>[];
    for (final app in _knownApps) {
      if (await isAppAvailable(app)) {
        available.add(app);
      }
    }
    return available;
  }

  /// Share PDF to a specific app.
  ///
  /// Note: Due to platform limitations, this may open the system
  /// share sheet with the target app pre-selected (if supported)
  /// or filtered to show only the target app.
  Future<GeniusAppShareResult> shareToApp({
    required Uint8List pdfBytes,
    required String fileName,
    required GeniusSharableApp app,
    String? message,
  }) async {
    try {
      // Save file to temp
      final tempDir = await getTemporaryDirectory();
      final safeName = _sanitizeFileName(fileName);
      final filePath = '${tempDir.path}/$safeName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Try to share using share_plus
      // On some platforms this may allow specifying the target app
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
      );

      if (result.status == ShareResultStatus.success) {
        return GeniusAppShareResult.success(
          app: app,
          message: 'Shared to ${app.name}',
          filePath: filePath,
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusAppShareResult.failure('Share cancelled', app: app);
      } else {
        return GeniusAppShareResult.failure('Share unavailable', app: app);
      }
    } catch (e) {
      return GeniusAppShareResult.failure(e.toString(), app: app);
    }
  }

  /// Share to WhatsApp.
  Future<GeniusAppShareResult> shareToWhatsApp({
    required Uint8List pdfBytes,
    required String fileName,
    String? phoneNumber,
    String? message,
  }) async {
    try {
      // Save file first
      final tempDir = await getTemporaryDirectory();
      final safeName = _sanitizeFileName(fileName);
      final filePath = '${tempDir.path}/$safeName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Try direct WhatsApp sharing if phone number provided
      if (phoneNumber != null && Platform.isAndroid) {
        final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
        final uri = Uri.parse(
          'whatsapp://send?phone=$cleanNumber'
          '${message != null ? '&text=${Uri.encodeComponent(message)}' : ''}',
        );

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          // Note: This doesn't actually attach the file
          // We fall through to regular share
        }
      }

      // Use regular share
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
      );

      if (result.status == ShareResultStatus.success) {
        return GeniusAppShareResult.success(
          app: GeniusSharableApp.whatsApp(),
          message: 'Shared via WhatsApp',
          filePath: filePath,
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return GeniusAppShareResult.failure('Share cancelled');
      } else {
        return GeniusAppShareResult.failure('Share unavailable');
      }
    } catch (e) {
      return GeniusAppShareResult.failure(e.toString());
    }
  }

  /// Share to Telegram.
  Future<GeniusAppShareResult> shareToTelegram({
    required Uint8List pdfBytes,
    required String fileName,
    String? message,
  }) async {
    return shareToApp(
      pdfBytes: pdfBytes,
      fileName: fileName,
      app: GeniusSharableApp.telegram(),
      message: message,
    );
  }

  /// Save PDF to local storage.
  Future<GeniusAppShareResult> saveToLocal({
    required Uint8List pdfBytes,
    required String fileName,
    GeniusStorageLocation location = GeniusStorageLocation.downloads,
    String? customPath,
  }) async {
    try {
      String targetPath;
      final safeName = _sanitizeFileName(fileName);

      switch (location) {
        case GeniusStorageLocation.downloads:
          if (Platform.isAndroid) {
            // On Android, try external storage Downloads
            targetPath = '/storage/emulated/0/Download/$safeName';
          } else {
            // On iOS, use app documents
            final dir = await getApplicationDocumentsDirectory();
            targetPath = '${dir.path}/$safeName';
          }
          break;
        case GeniusStorageLocation.documents:
          final dir = await getApplicationDocumentsDirectory();
          targetPath = '${dir.path}/$safeName';
          break;
        case GeniusStorageLocation.appDocuments:
          final dir = await getApplicationDocumentsDirectory();
          targetPath = '${dir.path}/PDFs/$safeName';
          break;
        case GeniusStorageLocation.custom:
          if (customPath == null) {
            return GeniusAppShareResult.failure('Custom path required');
          }
          targetPath = '$customPath/$safeName';
          break;
      }

      // Ensure directory exists
      final file = File(targetPath);
      await file.parent.create(recursive: true);

      // Handle existing file
      if (await file.exists()) {
        final baseName = safeName.replaceAll('.pdf', '');
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        targetPath = targetPath.replaceAll(
          safeName,
          '${baseName}_$timestamp.pdf',
        );
      }

      // Write file
      final finalFile = File(targetPath);
      await finalFile.writeAsBytes(pdfBytes);

      return GeniusAppShareResult.success(
        message: 'Saved to ${location.displayName}',
        filePath: targetPath,
      );
    } catch (e) {
      // If external storage fails, try app directory
      if (location == GeniusStorageLocation.downloads && Platform.isAndroid) {
        return saveToLocal(
          pdfBytes: pdfBytes,
          fileName: fileName,
          location: GeniusStorageLocation.appDocuments,
        );
      }
      return GeniusAppShareResult.failure(e.toString());
    }
  }

  /// Open PDF in an external viewer app.
  Future<GeniusAppShareResult> openInExternalApp({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    try {
      // Save to temp
      final tempDir = await getTemporaryDirectory();
      final safeName = _sanitizeFileName(fileName);
      final filePath = '${tempDir.path}/$safeName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Try to open with platform viewer
      final uri = Uri.file(filePath);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return GeniusAppShareResult.success(
          message: 'Opened in external viewer',
          filePath: filePath,
        );
      }

      // Fallback to share sheet
      final result = await Share.shareXFiles([XFile(file.path)]);

      if (result.status == ShareResultStatus.success) {
        return GeniusAppShareResult.success(
          message: 'Shared for viewing',
          filePath: filePath,
        );
      } else {
        return GeniusAppShareResult.failure('No viewer available');
      }
    } catch (e) {
      return GeniusAppShareResult.failure(e.toString());
    }
  }

  /// Get list of recently saved files.
  Future<List<FileSystemEntity>> getRecentlySavedFiles({
    int limit = 20,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final pdfDir = Directory('${dir.path}/PDFs');

      if (!await pdfDir.exists()) {
        return [];
      }

      final files = await pdfDir
          .list()
          .where((entity) =>
              entity is File && entity.path.toLowerCase().endsWith('.pdf'))
          .toList();

      // Sort by modification time
      files.sort((a, b) {
        final aStat = File(a.path).statSync();
        final bStat = File(b.path).statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      return files.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Delete a saved file.
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _sanitizeFileName(String fileName) {
    var name = fileName;
    // Add .pdf extension if missing
    if (!name.toLowerCase().endsWith('.pdf')) {
      name = '$name.pdf';
    }
    // Replace invalid characters
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }
}
