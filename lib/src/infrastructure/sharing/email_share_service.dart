import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/sharing/share_models.dart';

/// Email client types supported.
enum GeniusEmailClient {
  /// System default email client
  system('Default', 'الافتراضي'),

  /// Gmail
  gmail('Gmail', 'جيميل'),

  /// Outlook
  outlook('Outlook', 'أوتلوك'),

  /// Yahoo Mail
  yahoo('Yahoo Mail', 'ياهو ميل'),

  /// Custom SMTP
  smtp('SMTP', 'SMTP');

  const GeniusEmailClient(this.displayName, this.displayNameAr);

  final String displayName;
  final String displayNameAr;
}

/// Email attachment representation.
class GeniusEmailAttachment {
  /// Creates a new email attachment.
  const GeniusEmailAttachment({
    required this.fileName,
    required this.bytes,
    this.mimeType = 'application/pdf',
  });

  /// Creates from PDF bytes.
  factory GeniusEmailAttachment.pdf({
    required String fileName,
    required Uint8List bytes,
  }) {
    return GeniusEmailAttachment(
      fileName: fileName.endsWith('.pdf') ? fileName : '$fileName.pdf',
      bytes: bytes,
      mimeType: 'application/pdf',
    );
  }

  /// File name.
  final String fileName;

  /// File bytes.
  final Uint8List bytes;

  /// MIME type.
  final String mimeType;

  /// File size in bytes.
  int get size => bytes.length;

  /// Formatted file size.
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Email composition data.
class GeniusEmailData {
  /// Creates new email data.
  const GeniusEmailData({
    this.to = const [],
    this.cc = const [],
    this.bcc = const [],
    this.subject = '',
    this.body = '',
    this.isHtml = false,
    this.attachments = const [],
  });

  /// Recipients (To).
  final List<String> to;

  /// Carbon copy recipients (CC).
  final List<String> cc;

  /// Blind carbon copy recipients (BCC).
  final List<String> bcc;

  /// Email subject.
  final String subject;

  /// Email body.
  final String body;

  /// Whether body is HTML.
  final bool isHtml;

  /// Attachments.
  final List<GeniusEmailAttachment> attachments;

  /// Total size of all attachments.
  int get totalAttachmentSize =>
      attachments.fold(0, (sum, att) => sum + att.size);

  /// Copy with modifications.
  GeniusEmailData copyWith({
    List<String>? to,
    List<String>? cc,
    List<String>? bcc,
    String? subject,
    String? body,
    bool? isHtml,
    List<GeniusEmailAttachment>? attachments,
  }) {
    return GeniusEmailData(
      to: to ?? this.to,
      cc: cc ?? this.cc,
      bcc: bcc ?? this.bcc,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      isHtml: isHtml ?? this.isHtml,
      attachments: attachments ?? this.attachments,
    );
  }
}

/// SMTP configuration for custom email sending.
class GeniusSmtpConfig {
  /// Creates SMTP configuration.
  const GeniusSmtpConfig({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    this.useSsl = true,
    this.fromName,
    this.fromEmail,
  });

  /// Common SMTP configurations.
  factory GeniusSmtpConfig.gmail({
    required String email,
    required String appPassword,
    String? fromName,
  }) {
    return GeniusSmtpConfig(
      host: 'smtp.gmail.com',
      port: 587,
      username: email,
      password: appPassword,
      useSsl: true,
      fromName: fromName,
      fromEmail: email,
    );
  }

  factory GeniusSmtpConfig.outlook({
    required String email,
    required String password,
    String? fromName,
  }) {
    return GeniusSmtpConfig(
      host: 'smtp-mail.outlook.com',
      port: 587,
      username: email,
      password: password,
      useSsl: true,
      fromName: fromName,
      fromEmail: email,
    );
  }

  /// SMTP server host.
  final String host;

  /// SMTP server port.
  final int port;

  /// SMTP username.
  final String username;

  /// SMTP password.
  final String password;

  /// Whether to use SSL/TLS.
  final bool useSsl;

  /// Sender display name.
  final String? fromName;

  /// Sender email address.
  final String? fromEmail;
}

/// Result of email operation.
class GeniusEmailResult {
  /// Creates an email result.
  const GeniusEmailResult({
    required this.success,
    this.messageId,
    this.error,
    this.sentAt,
  });

  /// Factory for success.
  factory GeniusEmailResult.success({String? messageId}) {
    return GeniusEmailResult(
      success: true,
      messageId: messageId,
      sentAt: DateTime.now(),
    );
  }

  /// Factory for failure.
  factory GeniusEmailResult.failure(String error) {
    return GeniusEmailResult(
      success: false,
      error: error,
    );
  }

  /// Whether the operation was successful.
  final bool success;

  /// Message ID if sent via SMTP.
  final String? messageId;

  /// Error message if failed.
  final String? error;

  /// When the email was sent.
  final DateTime? sentAt;
}

/// Email sharing service for PDF documents.
///
/// Provides multiple ways to share PDFs via email:
/// - System email client (mailto:)
/// - Gmail app
/// - Outlook app
/// - Custom SMTP (direct send)
///
/// Example:
/// ```dart
/// final service = GeniusEmailShareService.instance;
///
/// // Open email client with PDF attachment
/// await service.composeEmail(
///   email: GeniusEmailData(
///     to: ['client@example.com'],
///     subject: 'Invoice #12345',
///     body: 'Please find attached your invoice.',
///   ),
///   pdfBytes: invoiceBytes,
///   pdfFileName: 'invoice_12345.pdf',
/// );
///
/// // Send directly via SMTP (if configured)
/// final result = await service.sendEmail(
///   email: emailData,
///   smtpConfig: GeniusSmtpConfig.gmail(
///     email: 'sender@gmail.com',
///     appPassword: 'xxxx xxxx xxxx xxxx',
///   ),
/// );
/// ```
class GeniusEmailShareService {
  GeniusEmailShareService._();

  static final GeniusEmailShareService _instance = GeniusEmailShareService._();

  /// Singleton instance.
  static GeniusEmailShareService get instance => _instance;

  /// Default SMTP configuration (if set).
  GeniusSmtpConfig? _defaultSmtpConfig;

  /// Maximum attachment size (25 MB by default).
  int _maxAttachmentSize = 25 * 1024 * 1024;

  /// Set default SMTP configuration.
  void setDefaultSmtpConfig(GeniusSmtpConfig config) {
    _defaultSmtpConfig = config;
  }

  /// Set maximum attachment size.
  void setMaxAttachmentSize(int bytes) {
    _maxAttachmentSize = bytes;
  }

  /// Check if email client is available.
  Future<bool> canSendEmail() async {
    final uri = Uri.parse('mailto:test@example.com');
    return canLaunchUrl(uri);
  }

  /// Check if Gmail app is available.
  Future<bool> isGmailAvailable() async {
    if (Platform.isAndroid) {
      final uri = Uri.parse('googlegmail://');
      return canLaunchUrl(uri);
    }
    return false;
  }

  /// Check if Outlook app is available.
  Future<bool> isOutlookAvailable() async {
    if (Platform.isAndroid) {
      final uri = Uri.parse('ms-outlook://');
      return canLaunchUrl(uri);
    }
    return false;
  }

  /// Compose email with PDF attachment using system email client.
  ///
  /// Opens the default email client with pre-filled data.
  /// Note: Due to platform limitations, attachments may not be supported
  /// via mailto: on all platforms. Use [composeEmailWithAttachment] for
  /// better attachment support.
  Future<GeniusEmailResult> composeEmail({
    required GeniusEmailData email,
    Uint8List? pdfBytes,
    String? pdfFileName,
  }) async {
    try {
      // Build mailto URI
      final queryParams = <String, String>{};

      if (email.cc.isNotEmpty) {
        queryParams['cc'] = email.cc.join(',');
      }
      if (email.bcc.isNotEmpty) {
        queryParams['bcc'] = email.bcc.join(',');
      }
      if (email.subject.isNotEmpty) {
        queryParams['subject'] = email.subject;
      }
      if (email.body.isNotEmpty) {
        queryParams['body'] = email.body;
      }

      final uri = Uri(
        scheme: 'mailto',
        path: email.to.join(','),
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return GeniusEmailResult.success();
      } else {
        return GeniusEmailResult.failure('No email client available');
      }
    } catch (e) {
      return GeniusEmailResult.failure(e.toString());
    }
  }

  /// Compose email with attachment support.
  ///
  /// Saves the PDF to a temp file and uses platform-specific sharing
  /// to properly attach the file.
  Future<GeniusShareResult> composeEmailWithAttachment({
    required GeniusEmailData email,
    required Uint8List pdfBytes,
    required String pdfFileName,
  }) async {
    try {
      // Check attachment size
      if (pdfBytes.length > _maxAttachmentSize) {
        return GeniusShareResult.failure(
          target: GeniusShareTarget.email(toAddress: email.to.firstOrNull),
          error:
              'Attachment too large. Maximum size: ${_formatSize(_maxAttachmentSize)}',
        );
      }

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final fileName = pdfFileName.endsWith('.pdf')
          ? pdfFileName
          : '$pdfFileName.pdf';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Use share_plus for attachment support
      // This will be handled by the main share service
      return GeniusShareResult.success(
        target: GeniusShareTarget.email(
          toAddress: email.to.firstOrNull,
          subject: email.subject,
          body: email.body,
        ),
        filePath: filePath,
        fileSize: pdfBytes.length,
        message: 'Email composed with attachment',
      );
    } catch (e) {
      return GeniusShareResult.failure(
        target: GeniusShareTarget.email(toAddress: email.to.firstOrNull),
        error: e.toString(),
      );
    }
  }

  /// Open Gmail with email data.
  Future<GeniusEmailResult> openGmail({
    required GeniusEmailData email,
  }) async {
    try {
      if (Platform.isAndroid) {
        final queryParams = <String, String>{
          'to': email.to.join(','),
          if (email.cc.isNotEmpty) 'cc': email.cc.join(','),
          if (email.bcc.isNotEmpty) 'bcc': email.bcc.join(','),
          if (email.subject.isNotEmpty) 'su': email.subject,
          if (email.body.isNotEmpty) 'body': email.body,
        };

        final uri = Uri(
          scheme: 'googlegmail',
          path: '/co',
          queryParameters: queryParams,
        );

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return GeniusEmailResult.success();
        }
      }

      // Fallback to web Gmail
      final webUri = Uri.https('mail.google.com', '/mail/', {
        'view': 'cm',
        'to': email.to.join(','),
        if (email.cc.isNotEmpty) 'cc': email.cc.join(','),
        if (email.bcc.isNotEmpty) 'bcc': email.bcc.join(','),
        if (email.subject.isNotEmpty) 'su': email.subject,
        if (email.body.isNotEmpty) 'body': email.body,
      });

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return GeniusEmailResult.success();
      }

      return GeniusEmailResult.failure('Gmail not available');
    } catch (e) {
      return GeniusEmailResult.failure(e.toString());
    }
  }

  /// Open Outlook with email data.
  Future<GeniusEmailResult> openOutlook({
    required GeniusEmailData email,
  }) async {
    try {
      if (Platform.isAndroid) {
        final uri = Uri(
          scheme: 'ms-outlook',
          path: '/compose',
          queryParameters: {
            'to': email.to.join(';'),
            if (email.cc.isNotEmpty) 'cc': email.cc.join(';'),
            if (email.subject.isNotEmpty) 'subject': email.subject,
            if (email.body.isNotEmpty) 'body': email.body,
          },
        );

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return GeniusEmailResult.success();
        }
      }

      // Fallback to web Outlook
      final webUri = Uri.https('outlook.live.com', '/mail/0/deeplink/compose', {
        'to': email.to.join(','),
        if (email.subject.isNotEmpty) 'subject': email.subject,
        if (email.body.isNotEmpty) 'body': email.body,
      });

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return GeniusEmailResult.success();
      }

      return GeniusEmailResult.failure('Outlook not available');
    } catch (e) {
      return GeniusEmailResult.failure(e.toString());
    }
  }

  /// Send email directly via SMTP.
  ///
  /// Note: SMTP sending requires the `mailer` package which should be
  /// added to your project's dependencies if you want to use this feature.
  /// This method provides a placeholder for SMTP implementation.
  Future<GeniusEmailResult> sendViaSmtp({
    required GeniusEmailData email,
    GeniusSmtpConfig? smtpConfig,
  }) async {
    final config = smtpConfig ?? _defaultSmtpConfig;
    if (config == null) {
      return GeniusEmailResult.failure('SMTP not configured');
    }

    // Note: Actual SMTP implementation would require the 'mailer' package
    // This is a placeholder that documents the intended API
    return GeniusEmailResult.failure(
      'SMTP sending requires the mailer package. '
      'Add it to your dependencies and implement the sending logic.',
    );
  }

  /// Create email from template.
  GeniusEmailData createFromTemplate({
    required GeniusShareMessageTemplate template,
    required Map<String, String> variables,
    required List<String> recipients,
    bool useArabic = false,
    List<String>? cc,
    List<String>? bcc,
  }) {
    return GeniusEmailData(
      to: recipients,
      cc: cc ?? [],
      bcc: bcc ?? [],
      subject: template.applyToSubject(variables, useArabic: useArabic),
      body: template.applyToBody(variables, useArabic: useArabic),
    );
  }

  /// Validate email address.
  bool isValidEmail(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  /// Validate list of email addresses.
  List<String> validateEmails(List<String> emails) {
    return emails.where((e) => !isValidEmail(e)).toList();
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
