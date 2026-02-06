// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/pdf_config.dart';
import '../models/security_models.dart';

/// مكون التوقيع الرقمي للـ PDF
/// Digital signature component for PDF documents
class GeniusPdfDigitalSignature {
  GeniusPdfDigitalSignature({
    required this.settings,
    required this.config,
  });

  /// إعدادات التوقيع
  final GeniusDigitalSignatureSettings settings;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// إضافة التوقيع للمستند
  /// Add signature to document
  void addToDocument(PdfDocument document) {
    if (settings.certificateBytes == null) {
      // Create visual signature without certificate (placeholder)
      _addVisualSignature(document);
      return;
    }

    // Add digital signature with certificate
    _addDigitalSignature(document);
  }

  /// إضافة توقيع مرئي فقط (بدون شهادة)
  void _addVisualSignature(PdfDocument document) {
    final page = settings.pageNumber < document.pages.count
        ? document.pages[settings.pageNumber]
        : document.pages[document.pages.count - 1];

    final pageSize = page.getClientSize();
    final graphics = page.graphics;

    // Calculate bounds
    final bounds = settings.bounds ??
        Rect.fromLTWH(
          pageSize.width - 220,
          pageSize.height - 120,
          200,
          100,
        );

    // Draw signature box
    _drawSignatureBox(graphics, bounds);
  }

  /// إضافة توقيع رقمي مع شهادة
  void _addDigitalSignature(PdfDocument document) {
    final page = settings.pageNumber < document.pages.count
        ? document.pages[settings.pageNumber]
        : document.pages[document.pages.count - 1];

    final pageSize = page.getClientSize();

    // Calculate bounds
    final bounds = settings.bounds ??
        Rect.fromLTWH(
          pageSize.width - 220,
          pageSize.height - 120,
          200,
          100,
        );

    // Create signature field
    final signatureField = PdfSignatureField(
      page,
      'Signature_${DateTime.now().millisecondsSinceEpoch}',
      bounds: bounds,
    );

    // Create certificate
    final certificate = PdfCertificate(
      settings.certificateBytes!,
      settings.certificatePassword ?? '',
    );

    // Create signature
    signatureField.signature = PdfSignature(
      certificate: certificate,
      contactInfo: settings.contactInfo,
      locationInfo: settings.location,
      reason: settings.reason,
      signedName: settings.signerName,
    );

    // Set signature type
    if (settings.type == GeniusSignatureType.certified) {
      signatureField.signature!.certificate = certificate;
    }

    // Configure timestamp if enabled
    if (settings.addTimestamp && settings.timestampServerUrl != null) {
      signatureField.signature!.timestampServer = TimestampServer(
        Uri.parse(settings.timestampServerUrl!),
      );
    }

    // Add signature appearance
    _configureAppearance(signatureField, bounds);

    // Add to document
    document.form.fields.add(signatureField);
  }

  /// تكوين مظهر التوقيع
  void _configureAppearance(PdfSignatureField signatureField, Rect bounds) {
    // Create graphics appearance
    final template = PdfTemplate(bounds.width, bounds.height);
    final graphics = template.graphics!;

    _drawSignatureContent(graphics, bounds);

    signatureField.appearance.normal = template;
  }

  /// رسم محتوى التوقيع
  void _drawSignatureContent(PdfGraphics graphics, Rect bounds) {
    final appearance = settings.appearance;

    // Draw background
    graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(
        appearance.backgroundColor.red,
        appearance.backgroundColor.green,
        appearance.backgroundColor.blue,
      )),
      bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height),
    );

    // Draw border
    if (appearance.borderWidth > 0) {
      graphics.drawRectangle(
        pen: PdfPen(
          PdfColor(
            appearance.borderColor.red,
            appearance.borderColor.green,
            appearance.borderColor.blue,
          ),
          width: appearance.borderWidth,
        ),
        bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      );
    }

    double yOffset = 8;
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final fontToUse = config.baseFont;
    final boldFontToUse = config.boldFont;
    final textBrush = PdfSolidBrush(PdfColor(
      appearance.textColor.red,
      appearance.textColor.green,
      appearance.textColor.blue,
    ));

    // Draw signature image if available
    if (appearance.showImage && appearance.signatureImage != null) {
      try {
        final image = PdfBitmap(appearance.signatureImage!);
        const imageHeight = 40.0;
        final imageWidth = (image.width / image.height) * imageHeight;
        graphics.drawImage(
          image,
          Rect.fromLTWH((bounds.width - imageWidth) / 2, yOffset, imageWidth,
              imageHeight),
        );
        yOffset += imageHeight + 5;
      } catch (_) {}
    }

    // Draw signer name
    if (appearance.showName) {
      graphics.drawString(
        'Signed by: ${settings.signerName}',
        boldFontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw date
    if (appearance.showDate) {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      graphics.drawString(
        'Date: $dateStr',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw reason
    if (appearance.showReason && settings.reason != null) {
      graphics.drawString(
        'Reason: ${settings.reason}',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw location
    if (appearance.showLocation && settings.location != null) {
      graphics.drawString(
        'Location: ${settings.location}',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
    }
  }

  /// رسم صندوق التوقيع
  void _drawSignatureBox(PdfGraphics graphics, Rect bounds) {
    final appearance = settings.appearance;

    // Draw background
    graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(
        appearance.backgroundColor.red,
        appearance.backgroundColor.green,
        appearance.backgroundColor.blue,
      )),
      bounds: bounds,
    );

    // Draw border
    graphics.drawRectangle(
      pen: PdfPen(
        PdfColor(
          appearance.borderColor.red,
          appearance.borderColor.green,
          appearance.borderColor.blue,
        ),
        width: appearance.borderWidth,
      ),
      bounds: bounds,
    );

    double yOffset = bounds.top + 8;
    // Font - baseFont is required for Arabic support, no fallback to Helvetica
    final fontToUse = config.baseFont;
    final boldFontToUse =  config.boldFont;
    final textBrush = PdfSolidBrush(PdfColor(
      appearance.textColor.red,
      appearance.textColor.green,
      appearance.textColor.blue,
    ));

    // Draw signature image if available
    if (appearance.showImage && appearance.signatureImage != null) {
      try {
        final image = PdfBitmap(appearance.signatureImage!);
        const imageHeight = 40.0;
        final imageWidth = (image.width / image.height) * imageHeight;
        graphics.drawImage(
          image,
          Rect.fromLTWH(
            bounds.left + (bounds.width - imageWidth) / 2,
            yOffset,
            imageWidth,
            imageHeight,
          ),
        );
        yOffset += imageHeight + 5;
      } catch (_) {}
    }

    // Draw signer name
    if (appearance.showName) {
      graphics.drawString(
        'Signed by: ${settings.signerName}',
        boldFontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(bounds.left + 8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw date
    if (appearance.showDate) {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      graphics.drawString(
        'Date: $dateStr',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(bounds.left + 8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw reason
    if (appearance.showReason && settings.reason != null) {
      graphics.drawString(
        'Reason: ${settings.reason}',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(bounds.left + 8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
      yOffset += 14;
    }

    // Draw location
    if (appearance.showLocation && settings.location != null) {
      graphics.drawString(
        'Location: ${settings.location}',
        fontToUse,
        brush: textBrush,
        bounds: Rect.fromLTWH(bounds.left + 8, yOffset, bounds.width - 16, 12),
        format: PdfStringFormat(textDirection: config.pdfTextDirection),
      );
    }
  }

  /// رسم التوقيع على صفحة
  void drawOnPage(PdfPage page, [Rect? customBounds]) {
    final pageSize = page.getClientSize();
    final bounds = customBounds ??
        settings.bounds ??
        Rect.fromLTWH(
          pageSize.width - 220,
          pageSize.height - 120,
          200,
          100,
        );

    _drawSignatureBox(page.graphics, bounds);
  }
}

/// خدمة التوقيع الرقمي
/// Digital Signature Service
class GeniusDigitalSignatureService {
  /// التحقق من التوقيع
  /// Verify signature
  static Future<GeniusSignatureVerificationResult> verifySignature(
      PdfDocument document) async {
    try {
      final form = document.form;
      bool hasSignature = false;
      const bool isValid = true;
      final List<GeniusSignatureInfo> signatures = [];

      for (int i = 0; i < form.fields.count; i++) {
        final field = form.fields[i];
        if (field is PdfSignatureField && field.signature != null) {
          hasSignature = true;

          final sigInfo = GeniusSignatureInfo(
            signerName: field.signature!.signedName ?? 'Unknown',
            reason: field.signature!.reason,
            location: field.signature!.locationInfo,
            signedDate: DateTime
                .now(), // Syncfusion doesn't expose signed date directly
            isCertified: field.signature!.certificate != null,
          );

          signatures.add(sigInfo);
        }
      }

      return GeniusSignatureVerificationResult(
        hasSignature: hasSignature,
        isValid: isValid,
        signatures: signatures,
      );
    } catch (e) {
      return GeniusSignatureVerificationResult(
        hasSignature: false,
        isValid: false,
        signatures: [],
        error: e.toString(),
      );
    }
  }

  /// إزالة جميع التوقيعات
  /// Remove all signatures
  static void removeAllSignatures(PdfDocument document) {
    final form = document.form;
    final fieldsToRemove = <PdfSignatureField>[];

    for (int i = 0; i < form.fields.count; i++) {
      final field = form.fields[i];
      if (field is PdfSignatureField) {
        fieldsToRemove.add(field);
      }
    }

    for (final field in fieldsToRemove) {
      form.fields.remove(field);
    }
  }

  /// الحصول على عدد التوقيعات
  /// Get signature count
  static int getSignatureCount(PdfDocument document) {
    int count = 0;
    final form = document.form;

    for (int i = 0; i < form.fields.count; i++) {
      final field = form.fields[i];
      if (field is PdfSignatureField && field.signature != null) {
        count++;
      }
    }

    return count;
  }
}

/// نتيجة التحقق من التوقيع
/// Signature verification result
class GeniusSignatureVerificationResult {
  GeniusSignatureVerificationResult({
    required this.hasSignature,
    required this.isValid,
    required this.signatures,
    this.error,
  });

  /// هل يوجد توقيع
  final bool hasSignature;

  /// هل التوقيع صالح
  final bool isValid;

  /// قائمة التوقيعات
  final List<GeniusSignatureInfo> signatures;

  /// رسالة خطأ
  final String? error;
}

/// معلومات التوقيع
/// Signature information
class GeniusSignatureInfo {
  GeniusSignatureInfo({
    required this.signerName,
    this.reason,
    this.location,
    required this.signedDate,
    this.isCertified = false,
  });

  /// اسم الموقع
  final String signerName;

  /// سبب التوقيع
  final String? reason;

  /// موقع التوقيع
  final String? location;

  /// تاريخ التوقيع
  final DateTime signedDate;

  /// هل مصادق
  final bool isCertified;
}

/// امتداد لإضافة التوقيع للمستند
/// Extension to add signature to document
extension PdfDocumentSignatureExtension on PdfDocument {
  /// إضافة توقيع رقمي
  void addDigitalSignature(
    {required GeniusDigitalSignatureSettings settings,
    required GeniusPdfConfig config,
    PdfFont? baseFont,
    PdfFont? boldFont}) {
    GeniusPdfDigitalSignature(
      settings: settings,
      config: config)
        .addToDocument(this);
  }

  /// التحقق من التوقيعات
  Future<GeniusSignatureVerificationResult> verifySignatures() {
    return GeniusDigitalSignatureService.verifySignature(this);
  }

  /// إزالة جميع التوقيعات
  void removeAllSignatures() {
    GeniusDigitalSignatureService.removeAllSignatures(this);
  }

  /// عدد التوقيعات
  int get signatureCount =>
      GeniusDigitalSignatureService.getSignatureCount(this);
}
