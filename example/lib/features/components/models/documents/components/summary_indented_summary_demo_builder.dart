import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Indented Hierarchy** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `indented_summary_example_screen.dart` and displayed as **Dart usage code**.
class IndentedSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  IndentedSummaryDemoBuilder(super.config);

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

    // --- Example 3: Indented Hierarchical Summary ---
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: [
          GeniusPdfSummaryItem.subtotal(
            label: 'Electronics',
            labelAr: 'إلكترونيات',
            value: config.formatter.formatMoney(29500.00, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Laptops',
            labelAr: 'حواسيب محمولة',
            value: config.formatter.formatMoney(16000.00, currencyCode: 'SAR'),
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Monitors',
            labelAr: 'شاشات',
            value: config.formatter.formatMoney(6000.00, currencyCode: 'SAR'),
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Accessories',
            labelAr: 'ملحقات',
            value: config.formatter.formatMoney(7500.00, currencyCode: 'SAR'),
            level: 1,
          ),
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.subtotal(
            label: 'Furniture',
            labelAr: 'أثاث',
            value: config.formatter.formatMoney(17800.00, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Desks',
            labelAr: 'مكاتب',
            value: config.formatter.formatMoney(7600.00, currencyCode: 'SAR'),
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Chairs',
            labelAr: 'كراسي',
            value: config.formatter.formatMoney(7800.00, currencyCode: 'SAR'),
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Cabinets',
            labelAr: 'خزائن',
            value: config.formatter.formatMoney(2400.00, currencyCode: 'SAR'),
            level: 1,
          ),
          const GeniusPdfSummaryItem.separator(height: 6),
          GeniusPdfSummaryItem.total(
            label: 'Grand Total',
            labelAr: 'الإجمالي الكلي',
            value: config.formatter.formatMoney(47300.00, currencyCode: 'SAR'),
          ),
        ],
        style: GeniusPdfSummaryStyle.card(),
        width: 260,
      ),
      spacing: 15,
    );

    addSpace(25);
  }
}
