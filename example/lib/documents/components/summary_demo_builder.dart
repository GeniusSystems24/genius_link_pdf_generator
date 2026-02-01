import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Summary demo PDF document with extended details.
class SummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  SummaryDemoBuilder(super.config);

  @override
  void build() {
    newPage();

    // Title using builder method
    addSectionDivider(
      title: config.isRTL
          ? 'ملخص المبالغ - GeniusPdfSummary'
          : 'Summary Section - GeniusPdfSummary',
      spacing: 10,
    );

    addSpace(20);

    // Summary section using builder method (aligned to right/end)
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: [
          GeniusPdfSummaryItem(
            label: 'Subtotal',
            labelAr: 'المجموع الفرعي',
            value: config.isRTL ? '30,100.00 ر.س' : 'SAR 30,100.00',
          ),
          GeniusPdfSummaryItem(
            label: 'Discount (3.3%)',
            labelAr: 'الخصم (3.3%)',
            value: config.isRTL ? '- 1,000.00 ر.س' : '- SAR 1,000.00',
            valueColor: const Color(0xFFF44336),
          ),
          GeniusPdfSummaryItem(
            label: 'Taxable Amount',
            labelAr: 'المبلغ الخاضع للضريبة',
            value: config.isRTL ? '29,100.00 ر.س' : 'SAR 29,100.00',
          ),
          GeniusPdfSummaryItem(
            label: 'VAT (15%)',
            labelAr: 'ضريبة القيمة المضافة (15%)',
            value: config.isRTL ? '4,365.00 ر.س' : 'SAR 4,365.00',
          ),
          GeniusPdfSummaryItem.total(
            label: 'Total',
            labelAr: 'الإجمالي',
            value: config.isRTL ? '33,465.00 ر.س' : 'SAR 33,465.00',
            valueColor: const Color(0xFF4CAF50),
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
      ),
      spacing: 20,
    );

    addSpace(30);

    // Note info box using builder method
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'توضيح' : 'Note',
        titleAr: 'توضيح',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'الحساب' : 'Calculation',
            labelAr: 'الحساب',
            value: config.isRTL
                ? 'يتم احتساب ضريبة القيمة المضافة بعد الخصم.'
                : 'VAT is calculated after discount is applied.',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.highlighted(),
      ),
      spacing: 10,
    );
  }
}
