import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for the QR & Attachments Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class QrAttachmentsExampleScreen extends StatelessWidget {
  const QrAttachmentsExampleScreen({super.key});

  static const String dartUsageCode = r'''/// Demonstrates v2.7.0 QR code and image attachment features.
///
/// This example showcases:
/// - **[addQRCode]** — Draw QR codes with alignment (start/center/end)
/// - **[addImageAttachment]** — Labeled image attachments inline
/// - **[addImagePage]** — Full-page image attachments (scanned documents)
/// - **[addAttachments]** — Batch add multiple image pages
/// - QR code factories: `.url()`, `.zatca()`, `.wifi()`, `.vCard()`
///
/// ## Example
/// ```dart
/// final doc = QRAttachmentsDemoBuilder(
///   config: myConfig,
///   qrUrl: 'https://example.com/invoice/123',
/// );
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class QRAttachmentsDemoBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [QRAttachmentsDemoBuilder].
  QRAttachmentsDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
    this.qrUrl = 'https://genius-link.dev/invoice/demo',
    this.attachmentImages,
  }) : super(config);

  /// User name for the footer.
  final String userName;

  /// URL to encode in the QR code.
  final String qrUrl;

  /// Optional list of images to attach as pages.
  final List<GeniusPdfImage>? attachmentImages;

  @override
  void build() {
    _buildHeader();
    _buildQRCodeSection();
    _buildImageAttachmentSection();
    _buildBatchAttachmentsSection();
    _buildFooter();
  }

  // ──────────────────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────────────────

  void _buildHeader() {
    addHeader(
      title: isRTL
          ? 'عرض رمز QR والمرفقات — الإصدار 2.7.0'
          : 'QR Code & Attachments Demo — v2.7.0',
    );
  }

  // ──────────────────────────────────────────────────────────
  // QR Code Section
  // ──────────────────────────────────────────────────────────

  void _buildQRCodeSection() {
    addSectionDivider(
      title: isRTL ? 'رموز QR' : 'QR Codes',
      spacing: 10,
    );

    // URL QR Code — centered
    addLine(
      isRTL ? 'رمز QR للرابط (وسط):' : 'URL QR Code (centered):',
      topMargin: 5,
    );
    addSpace(5);

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
    );
    addQRCode(
      urlQR,
      alignment: GeniusPdfImageAlignment.center,
      spacing: 5,
      size: 100,
    );
    addSpace(10);

    // WiFi QR Code — start aligned
    addLine(
      isRTL ? 'رمز QR للواي فاي (بداية):' : 'WiFi QR Code (start-aligned):',
      topMargin: 5,
    );
    addSpace(5);

    final wifiQR = GeniusPdfQRCodeGenerator.wifi(
      ssid: 'GeniusOffice',
      password: 'secure123',
      config: config,
    );
    addQRCode(
      wifiQR,
      alignment: GeniusPdfImageAlignment.start,
      spacing: 5,
      size: 80,
    );
    addSpace(10);

    // vCard QR Code — end aligned
    addLine(
      isRTL
          ? 'رمز QR لبطاقة جهة اتصال (نهاية):'
          : 'vCard QR Code (end-aligned):',
      topMargin: 5,
    );
    addSpace(5);

    final vCardQR = GeniusPdfQRCodeGenerator.vCard(
      name: 'Genius Systems',
      phone: '+966501234567',
      email: 'info@genius-link.dev',
      company: 'Genius Systems LLC',
      config: config,
    );
    addQRCode(
      vCardQR,
      alignment: GeniusPdfImageAlignment.end,
      spacing: 5,
      size: 80,
    );

    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Image Attachment Section
  // ──────────────────────────────────────────────────────────

  void _buildImageAttachmentSection() {
    addSectionDivider(
      title: isRTL ? 'مرفقات الصور' : 'Image Attachments',
      spacing: 10,
    );

    addLine(
      isRTL
          ? 'يمكنك إرفاق صور مباشرة أو على صفحات مستقلة.'
          : 'You can attach images inline or on dedicated pages.',
      topMargin: 5,
    );

    if (attachmentImages != null && attachmentImages!.isNotEmpty) {
      // Inline attachment with title
      addImageAttachment(
        attachmentImages!.first,
        title: 'Inline Attachment',
        titleAr: 'مرفق مضمن',
        spacing: 10,
      );
    } else {
      addLine(
        isRTL
            ? '(لم يتم تزويد صور — مرر attachmentImages لمشاهدة العرض)'
            : '(No images provided — pass attachmentImages to see the demo)',
        topMargin: 5,
      );
    }

    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Batch Attachments
  // ──────────────────────────────────────────────────────────

  void _buildBatchAttachmentsSection() {
    if (attachmentImages != null && attachmentImages!.length > 1) {
      // Each additional image gets its own page via addAttachments
      addAttachments(
        attachmentImages!.sublist(1),
        titles: List.generate(
          attachmentImages!.length - 1,
          (i) => 'Attachment ${i + 2}',
        ),
        titlesAr: List.generate(
          attachmentImages!.length - 1,
          (i) => 'مرفق ${i + 2}',
        ),
      );
    }
  }

  // ──────────────────────────────────────────────────────────
  // Footer
  // ──────────────────────────────────────────────────────────

  void _buildFooter() {
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_qr_attachments',
      category: 'Showcase',
      title: pdfLocalization.qrAndAttachments,
      apiName: 'QRAttachmentsDemoBuilder',
      description: pdfLocalization.qrCodesInlineImageAttachmentsImageDesc,
      icon: Icons.qr_code_2_outlined,
      usageCode: dartUsageCode,
    );
  }
}
