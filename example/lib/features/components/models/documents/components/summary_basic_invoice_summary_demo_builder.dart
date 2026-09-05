import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Basic Invoice Summary** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `basic_invoice_summary_example_screen.dart` and displayed as **Dart usage code**.
class BasicInvoiceSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  BasicInvoiceSummaryDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Basic Invoice Summary + Grouped Summary
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'ملخص المبالغ v2.12.5 — GeniusPdfSummary'
          : 'Summary Section v2.12.5 — GeniusPdfSummary',
      spacing: 10,
    );

    // --- Example 1: Basic Invoice Summary ---
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        title: config.isRTL ? 'ملخص الفاتورة' : 'Invoice Summary',
        titleAr: 'ملخص الفاتورة',
        items: [
          GeniusPdfSummaryItem(
            label: 'Subtotal',
            labelAr: 'المجموع الفرعي',
            value: config.formatter.formatMoney(30100.00, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem.negative(
            label: 'Discount (3.3%)',
            labelAr: 'الخصم (3.3%)',
            value: config.formatter.formatMoney(-1000.00, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem(
            label: 'Taxable Amount',
            labelAr: 'المبلغ الخاضع للضريبة',
            value: config.formatter.formatMoney(29100.00, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem(
            label: 'VAT (15%)',
            labelAr: 'ضريبة القيمة المضافة (15%)',
            value: config.formatter.formatMoney(4365.00, currencyCode: 'SAR'),
          ),
          const GeniusPdfSummaryItem.separator(),
          GeniusPdfSummaryItem.total(
            label: 'Total Due',
            labelAr: 'المبلغ المستحق',
            value: config.formatter.formatMoney(33465.00, currencyCode: 'SAR'),
            valueColor: const Color(0xFF2E7D32),
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
      ),
      spacing: 20,
    );

    addSpace(25);
  }
}
