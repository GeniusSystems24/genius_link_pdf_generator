import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide
        PdfTextStyle,
        PdfGridStyle,
        PdfBorderStyle,
        PdfGridColumn,
        PdfGridRow;

/// Demonstrates v2.8.0 advanced layout features in the document builder.
///
/// This example showcases:
/// - **[addRichText]** — Rich text with bold, colors, and links
/// - **[addInfoBox]** — Info boxes with labeled values
/// - **[addReportHeader]** — Professional report headers
/// - **[addTwoColumns]** — Two-column layout with flexible widths
/// - **[setPageTemplate]** — Page-level stamps and templates
///
/// ## Example
/// ```dart
/// final doc = AdvancedLayoutDemoBuilder(config: myConfig);
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class AdvancedLayoutDemoBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [AdvancedLayoutDemoBuilder].
  AdvancedLayoutDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
  }) : super(config);

  /// User name for the footer.
  final String userName;

  @override
  void build() {
    _buildReportHeaderSection();
    _buildTwoColumnSection();
    _buildRichTextSection();
    _buildInfoBoxSection();
    _buildFooter();
  }

  // ──────────────────────────────────────────────────────────
  // Report Header
  // ──────────────────────────────────────────────────────────

  void _buildReportHeaderSection() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Advanced Layout Demo',
      titleAr: 'عرض التخطيط المتقدم',
      subtitle: 'v2.8.0 Features',
      subtitleAr: 'مميزات الإصدار 2.8.0',
      printDate: DateTime.now(),
      showPrintDate: true,
      layout: GeniusPdfReportHeaderLayout.centered,
    );

    addReportHeader(header, spacing: 0, height: 80);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Two-Column Layout
  // ──────────────────────────────────────────────────────────

  void _buildTwoColumnSection() {
    addSectionDivider(
      title: isRTL ? 'تخطيط عمودين' : 'Two-Column Layout',
      spacing: 10,
    );

    addTwoColumns(
      leftContent: (page, bounds) {
        final box = GeniusPdfInfoBox(
          config: config,
          title: 'From',
          titleAr: 'من',
          items: [
            GeniusPdfLabeledValue(
              label: 'Company',
              labelAr: 'الشركة',
              value: 'Genius Systems LLC',
            ),
            GeniusPdfLabeledValue(
              label: 'Address',
              labelAr: 'العنوان',
              value: 'Riyadh, Saudi Arabia',
            ),
            GeniusPdfLabeledValue(
              label: 'VAT No.',
              labelAr: 'الرقم الضريبي',
              value: '310123456789003',
            ),
          ],
          style: const GeniusPdfInfoBoxStyle.card(),
        );
        final rect = box.draw(page: page, bounds: bounds);
        return rect.height;
      },
      rightContent: (page, bounds) {
        final box = GeniusPdfInfoBox(
          config: config,
          title: 'To',
          titleAr: 'إلى',
          items: [
            GeniusPdfLabeledValue(
              label: 'Customer',
              labelAr: 'العميل',
              value: 'ABC Trading Co.',
            ),
            GeniusPdfLabeledValue(
              label: 'Address',
              labelAr: 'العنوان',
              value: 'Jeddah, Saudi Arabia',
            ),
            GeniusPdfLabeledValue(
              label: 'VAT No.',
              labelAr: 'الرقم الضريبي',
              value: '310987654321003',
            ),
          ],
          style: const GeniusPdfInfoBoxStyle.card(),
        );
        final rect = box.draw(page: page, bounds: bounds);
        return rect.height;
      },
      spacing: 5,
      gap: 15,
    );

    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Rich Text
  // ──────────────────────────────────────────────────────────

  void _buildRichTextSection() {
    addSectionDivider(
      title: isRTL ? 'نص منسق' : 'Rich Text',
      spacing: 10,
    );

    final richText = GeniusPdfRichTextBuilder(config: config)
        .bold(isRTL ? 'ملاحظة: ' : 'Note: ')
        .text(isRTL
            ? 'يمكنك الآن إضافة نصوص منسقة مباشرة من خلال البناء باستخدام '
            : 'You can now add rich text directly through the builder using ')
        .bold('addRichText()')
        .text(isRTL
            ? '. يدعم الخط العريض والألوان والروابط والمزيد.'
            : '. It supports bold, colors, links, and more.')
        .build();

    addRichText(richText, spacing: 5);
    addSpace(10);

    // Another rich text block.
    final statusText = GeniusPdfRichTextBuilder(config: config)
        .text(isRTL ? 'الحالة: ' : 'Status: ')
        .bold(isRTL ? 'مكتمل' : 'Complete')
        .text(isRTL ? ' — آخر تحديث: ' : ' — Last updated: ')
        .text(DateTime.now().toString().substring(0, 10))
        .build();

    addRichText(statusText, spacing: 5);
    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Info Box
  // ──────────────────────────────────────────────────────────

  void _buildInfoBoxSection() {
    addSectionDivider(
      title: isRTL ? 'صندوق معلومات' : 'Info Box',
      spacing: 10,
    );

    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: 'Payment Details',
      titleAr: 'تفاصيل الدفع',
      items: [
        GeniusPdfLabeledValue(
          label: 'Payment Method',
          labelAr: 'طريقة الدفع',
          value: 'Bank Transfer',
        ),
        GeniusPdfLabeledValue(
          label: 'Bank Name',
          labelAr: 'اسم البنك',
          value: 'Al Rajhi Bank',
        ),
        GeniusPdfLabeledValue(
          label: 'Account No.',
          labelAr: 'رقم الحساب',
          value: 'SA00 1234 5678 9012 3456',
        ),
        GeniusPdfLabeledValue(
          label: 'IBAN',
          labelAr: 'آيبان',
          value: 'SA0012345678901234567890',
        ),
      ],
      style: const GeniusPdfInfoBoxStyle.highlighted(),
      columns: 2,
    );

    addInfoBox(infoBox, spacing: 5);
    addSpace(15);
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
}
