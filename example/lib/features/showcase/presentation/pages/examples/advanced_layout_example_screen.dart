import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Advanced Layout Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class AdvancedLayoutExampleScreen extends StatelessWidget {
  const AdvancedLayoutExampleScreen({super.key});

  static const String dartUsageCode = r'''/// Demonstrates v2.8.0 advanced layout features in the document builder.
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
              config: config,
              label: 'Company',
              labelAr: 'الشركة',
              value: 'Genius Systems LLC',
            ),
            GeniusPdfLabeledValue(
              config: config,
              label: 'Address',
              labelAr: 'العنوان',
              value: 'Riyadh, Saudi Arabia',
            ),
            GeniusPdfLabeledValue(
              config: config,
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
              config: config,
              label: 'Customer',
              labelAr: 'العميل',
              value: 'ABC Trading Co.',
            ),
            GeniusPdfLabeledValue(
              config: config,
              label: 'Address',
              labelAr: 'العنوان',
              value: 'Jeddah, Saudi Arabia',
            ),
            GeniusPdfLabeledValue(
              config: config,
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
          config: config,
          label: 'Payment Method',
          labelAr: 'طريقة الدفع',
          value: 'Bank Transfer',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Bank Name',
          labelAr: 'اسم البنك',
          value: 'Al Rajhi Bank',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account No.',
          labelAr: 'رقم الحساب',
          value: 'SA00 1234 5678 9012 3456',
        ),
        GeniusPdfLabeledValue(
          config: config,
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
}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_advanced_layout',
      category: 'Showcase',
      title: 'Advanced Layout',
      apiName: 'AdvancedLayoutDemoBuilder',
      description: 'Rich text, info boxes, report headers, flexible columns, and page templates.',
      icon: Icons.dashboard_customize_outlined,
      usageCode: dartUsageCode,
    );
  }
}
