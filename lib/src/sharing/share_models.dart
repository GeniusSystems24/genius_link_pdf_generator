import 'dart:typed_data';

/// Target type for sharing operations.
///
/// Defines the different channels through which PDF files can be shared.
enum GeniusShareTargetType {
  /// Share via system share sheet
  system('System', 'النظام'),

  /// Share via email
  email('Email', 'البريد الإلكتروني'),

  /// Share via Bluetooth
  bluetooth('Bluetooth', 'البلوتوث'),

  /// Share to specific app (WhatsApp, Telegram, etc.)
  app('App', 'تطبيق'),

  /// Share to cloud storage
  cloud('Cloud', 'السحابة'),

  /// Save to local storage
  local('Local Storage', 'التخزين المحلي');

  const GeniusShareTargetType(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Status of a share operation.
enum GeniusShareStatus {
  /// Share operation is pending
  pending('Pending', 'قيد الانتظار'),

  /// Share operation is in progress
  inProgress('In Progress', 'جاري'),

  /// Share operation completed successfully
  completed('Completed', 'مكتمل'),

  /// Share operation failed
  failed('Failed', 'فشل'),

  /// Share operation was cancelled
  cancelled('Cancelled', 'ملغي');

  const GeniusShareStatus(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Represents a share target with its configuration.
class GeniusShareTarget {
  /// Creates a new share target.
  const GeniusShareTarget({
    required this.type,
    this.appPackageName,
    this.appDisplayName,
    this.emailAddress,
    this.bluetoothDeviceId,
    this.cloudProvider,
    this.localPath,
    this.metadata = const {},
  });

  /// Factory for system share sheet.
  factory GeniusShareTarget.system() {
    return const GeniusShareTarget(type: GeniusShareTargetType.system);
  }

  /// Factory for email sharing.
  factory GeniusShareTarget.email({
    String? toAddress,
    String? subject,
    String? body,
  }) {
    return GeniusShareTarget(
      type: GeniusShareTargetType.email,
      emailAddress: toAddress,
      metadata: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
  }

  /// Factory for Bluetooth sharing.
  factory GeniusShareTarget.bluetooth({String? deviceId}) {
    return GeniusShareTarget(
      type: GeniusShareTargetType.bluetooth,
      bluetoothDeviceId: deviceId,
    );
  }

  /// Factory for app sharing (e.g., WhatsApp, Telegram).
  factory GeniusShareTarget.app({
    required String packageName,
    String? displayName,
  }) {
    return GeniusShareTarget(
      type: GeniusShareTargetType.app,
      appPackageName: packageName,
      appDisplayName: displayName,
    );
  }

  /// Factory for WhatsApp sharing.
  factory GeniusShareTarget.whatsApp() {
    return GeniusShareTarget.app(
      packageName: 'com.whatsapp',
      displayName: 'WhatsApp',
    );
  }

  /// Factory for Telegram sharing.
  factory GeniusShareTarget.telegram() {
    return GeniusShareTarget.app(
      packageName: 'org.telegram.messenger',
      displayName: 'Telegram',
    );
  }

  /// Factory for cloud storage.
  factory GeniusShareTarget.cloud({
    required String provider,
    String? folderPath,
  }) {
    return GeniusShareTarget(
      type: GeniusShareTargetType.cloud,
      cloudProvider: provider,
      metadata: {
        if (folderPath != null) 'folderPath': folderPath,
      },
    );
  }

  /// Factory for local storage (Downloads, Documents, etc.).
  factory GeniusShareTarget.local({String? path}) {
    return GeniusShareTarget(
      type: GeniusShareTargetType.local,
      localPath: path,
    );
  }

  /// The type of share target.
  final GeniusShareTargetType type;

  /// Package name for app sharing.
  final String? appPackageName;

  /// Display name for the app.
  final String? appDisplayName;

  /// Email address for email sharing.
  final String? emailAddress;

  /// Bluetooth device ID for Bluetooth sharing.
  final String? bluetoothDeviceId;

  /// Cloud provider name (gdrive, dropbox, onedrive).
  final String? cloudProvider;

  /// Local path for saving.
  final String? localPath;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Get display name for this target.
  String get displayName {
    switch (type) {
      case GeniusShareTargetType.app:
        return appDisplayName ?? appPackageName ?? 'App';
      case GeniusShareTargetType.email:
        return emailAddress ?? 'Email';
      case GeniusShareTargetType.cloud:
        return cloudProvider ?? 'Cloud';
      default:
        return type.displayName;
    }
  }
}

/// Result of a share operation.
class GeniusShareResult {
  /// Creates a new share result.
  const GeniusShareResult({
    required this.status,
    required this.target,
    this.message,
    this.error,
    this.sharedAt,
    this.filePath,
    this.fileSize,
    this.shareId,
  });

  /// Factory for successful share.
  factory GeniusShareResult.success({
    required GeniusShareTarget target,
    String? message,
    String? filePath,
    int? fileSize,
  }) {
    return GeniusShareResult(
      status: GeniusShareStatus.completed,
      target: target,
      message: message ?? 'File shared successfully',
      sharedAt: DateTime.now(),
      filePath: filePath,
      fileSize: fileSize,
      shareId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Factory for failed share.
  factory GeniusShareResult.failure({
    required GeniusShareTarget target,
    required String error,
  }) {
    return GeniusShareResult(
      status: GeniusShareStatus.failed,
      target: target,
      error: error,
      sharedAt: DateTime.now(),
    );
  }

  /// Factory for cancelled share.
  factory GeniusShareResult.cancelled({
    required GeniusShareTarget target,
  }) {
    return GeniusShareResult(
      status: GeniusShareStatus.cancelled,
      target: target,
      message: 'Share operation cancelled',
      sharedAt: DateTime.now(),
    );
  }

  /// The status of the share operation.
  final GeniusShareStatus status;

  /// The target of the share operation.
  final GeniusShareTarget target;

  /// Success or info message.
  final String? message;

  /// Error message if failed.
  final String? error;

  /// When the share occurred.
  final DateTime? sharedAt;

  /// Path to the shared file.
  final String? filePath;

  /// Size of the shared file in bytes.
  final int? fileSize;

  /// Unique identifier for this share operation.
  final String? shareId;

  /// Whether the share was successful.
  bool get isSuccess => status == GeniusShareStatus.completed;

  /// Whether the share failed.
  bool get isFailure => status == GeniusShareStatus.failed;

  /// Whether the share was cancelled.
  bool get isCancelled => status == GeniusShareStatus.cancelled;
}

/// A history item for share operations.
class GeniusShareHistoryItem {

  /// Create from JSON map.
  factory GeniusShareHistoryItem.fromJson(Map<String, dynamic> json) {
    return GeniusShareHistoryItem(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      target: GeniusShareTarget(
        type: GeniusShareTargetType.values.firstWhere(
          (t) => t.name == json['targetType'],
          orElse: () => GeniusShareTargetType.system,
        ),
      ),
      status: GeniusShareStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => GeniusShareStatus.completed,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      fileSize: json['fileSize'] as int?,
      error: json['error'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
  /// Creates a new share history item.
  const GeniusShareHistoryItem({
    required this.id,
    required this.fileName,
    required this.target,
    required this.status,
    required this.timestamp,
    this.fileSize,
    this.error,
    this.metadata = const {},
  });

  /// Creates from a share result.
  factory GeniusShareHistoryItem.fromResult(
    GeniusShareResult result,
    String fileName,
  ) {
    return GeniusShareHistoryItem(
      id: result.shareId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      target: result.target,
      status: result.status,
      timestamp: result.sharedAt ?? DateTime.now(),
      fileSize: result.fileSize,
      error: result.error,
    );
  }

  /// Unique identifier.
  final String id;

  /// Name of the shared file.
  final String fileName;

  /// Share target.
  final GeniusShareTarget target;

  /// Status of the share.
  final GeniusShareStatus status;

  /// When the share occurred.
  final DateTime timestamp;

  /// File size in bytes.
  final int? fileSize;

  /// Error message if failed.
  final String? error;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'targetType': target.type.name,
      'targetDisplayName': target.displayName,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'fileSize': fileSize,
      'error': error,
      'metadata': metadata,
    };
  }
}

/// Configuration for share operations.
class GeniusShareConfig {
  /// Creates a new share configuration.
  const GeniusShareConfig({
    this.compressIfLargerThan,
    this.maxFileSize,
    this.defaultSubject,
    this.defaultBody,
    this.includeTimestamp = true,
    this.createBackup = false,
  });

  /// Default configuration.
  static const defaults = GeniusShareConfig(
    compressIfLargerThan: 10 * 1024 * 1024, // 10 MB
    maxFileSize: 25 * 1024 * 1024, // 25 MB
    includeTimestamp: true,
    createBackup: false,
  );

  /// Compress file if larger than this size (in bytes).
  final int? compressIfLargerThan;

  /// Maximum file size allowed (in bytes).
  final int? maxFileSize;

  /// Default subject for email sharing.
  final String? defaultSubject;

  /// Default body for email sharing.
  final String? defaultBody;

  /// Include timestamp in filename.
  final bool includeTimestamp;

  /// Create backup before sharing.
  final bool createBackup;

  /// Copy with modifications.
  GeniusShareConfig copyWith({
    int? compressIfLargerThan,
    int? maxFileSize,
    String? defaultSubject,
    String? defaultBody,
    bool? includeTimestamp,
    bool? createBackup,
  }) {
    return GeniusShareConfig(
      compressIfLargerThan: compressIfLargerThan ?? this.compressIfLargerThan,
      maxFileSize: maxFileSize ?? this.maxFileSize,
      defaultSubject: defaultSubject ?? this.defaultSubject,
      defaultBody: defaultBody ?? this.defaultBody,
      includeTimestamp: includeTimestamp ?? this.includeTimestamp,
      createBackup: createBackup ?? this.createBackup,
    );
  }
}

/// Quick share contact for favorite recipients.
class GeniusQuickShareContact {
  /// Creates a new quick share contact.
  const GeniusQuickShareContact({
    required this.id,
    required this.name,
    required this.target,
    this.nameAr,
    this.avatar,
    this.usageCount = 0,
    this.lastUsed,
    this.isFavorite = false,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Arabic display name.
  final String? nameAr;

  /// Share target for this contact.
  final GeniusShareTarget target;

  /// Avatar image bytes.
  final Uint8List? avatar;

  /// Number of times shared with this contact.
  final int usageCount;

  /// Last time shared with this contact.
  final DateTime? lastUsed;

  /// Whether this is a favorite contact.
  final bool isFavorite;

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'targetType': target.type.name,
      'targetData': {
        'appPackageName': target.appPackageName,
        'emailAddress': target.emailAddress,
        'bluetoothDeviceId': target.bluetoothDeviceId,
        'cloudProvider': target.cloudProvider,
        'localPath': target.localPath,
      },
      'usageCount': usageCount,
      'lastUsed': lastUsed?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  /// Copy with modifications.
  GeniusQuickShareContact copyWith({
    String? name,
    String? nameAr,
    GeniusShareTarget? target,
    Uint8List? avatar,
    int? usageCount,
    DateTime? lastUsed,
    bool? isFavorite,
  }) {
    return GeniusQuickShareContact(
      id: id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      target: target ?? this.target,
      avatar: avatar ?? this.avatar,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// Message template for sharing.
class GeniusShareMessageTemplate {
  /// Creates a new message template.
  const GeniusShareMessageTemplate({
    required this.id,
    required this.name,
    this.nameAr,
    required this.subject,
    required this.body,
    this.subjectAr,
    this.bodyAr,
    this.variables = const [],
  });

  /// Default invoice template.
  factory GeniusShareMessageTemplate.invoice() {
    return const GeniusShareMessageTemplate(
      id: 'invoice',
      name: 'Invoice',
      nameAr: 'فاتورة',
      subject: 'Invoice #{invoiceNumber}',
      subjectAr: 'فاتورة #{invoiceNumber}',
      body: '''Dear {customerName},

Please find attached the invoice #{invoiceNumber} for your reference.

Total Amount: {amount}
Due Date: {dueDate}

Thank you for your business.

Best regards''',
      bodyAr: '''عزيزي {customerName}،

مرفق طيه الفاتورة رقم #{invoiceNumber} للرجوع إليها.

المبلغ الإجمالي: {amount}
تاريخ الاستحقاق: {dueDate}

شكراً لتعاملكم معنا.

مع أطيب التحيات''',
      variables: ['invoiceNumber', 'customerName', 'amount', 'dueDate'],
    );
  }

  /// Default report template.
  factory GeniusShareMessageTemplate.report() {
    return const GeniusShareMessageTemplate(
      id: 'report',
      name: 'Report',
      nameAr: 'تقرير',
      subject: '{reportType} Report - {date}',
      subjectAr: 'تقرير {reportType} - {date}',
      body: '''Hello,

Please find attached the {reportType} report for {period}.

Best regards''',
      bodyAr: '''مرحباً،

مرفق طيه تقرير {reportType} لفترة {period}.

مع أطيب التحيات''',
      variables: ['reportType', 'date', 'period'],
    );
  }

  /// Default document template.
  factory GeniusShareMessageTemplate.document() {
    return const GeniusShareMessageTemplate(
      id: 'document',
      name: 'Document',
      nameAr: 'مستند',
      subject: '{documentType} - {title}',
      subjectAr: '{documentType} - {title}',
      body: '''Hello,

Please find attached the {documentType}.

Best regards''',
      bodyAr: '''مرحباً،

مرفق طيه {documentType}.

مع أطيب التحيات''',
      variables: ['documentType', 'title'],
    );
  }

  /// Unique identifier.
  final String id;

  /// Template name.
  final String name;

  /// Template name in Arabic.
  final String? nameAr;

  /// Subject line.
  final String subject;

  /// Subject line in Arabic.
  final String? subjectAr;

  /// Body text.
  final String body;

  /// Body text in Arabic.
  final String? bodyAr;

  /// List of variable placeholders.
  final List<String> variables;

  /// Apply variables to the template.
  String applyToSubject(Map<String, String> values, {bool useArabic = false}) {
    String result = useArabic ? (subjectAr ?? subject) : subject;
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value);
    }
    return result;
  }

  /// Apply variables to the body.
  String applyToBody(Map<String, String> values, {bool useArabic = false}) {
    String result = useArabic ? (bodyAr ?? body) : body;
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value);
    }
    return result;
  }
}
