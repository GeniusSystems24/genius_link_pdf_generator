import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Advanced Grouped Summary** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `advanced_grouped_summary_example_screen.dart` and displayed as **Dart usage code**.
class AdvancedGroupedSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  AdvancedGroupedSummaryDemoBuilder(super.config);

  @override
  void build() {
    // PAGE 3: Advanced Grouped + Custom Font Sizes
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٥: ملخص متقدم مع مجموعات متعددة وأحجام خطوط مخصصة'
          : 'Example 5: Advanced multi-group summary with custom font sizes',
      spacing: 10,
    );

    addSpace(12);

    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        title: config.isRTL ? 'تقرير الأرباح والخسائر' : 'Profit & Loss Report',
        titleAr: 'تقرير الأرباح والخسائر',
        groups: [
          GeniusPdfSummaryGroup.income(
            title: config.isRTL ? 'الإيرادات' : 'Revenue',
            titleAr: 'الإيرادات',
            items: [
              GeniusPdfSummaryItem.indented(
                label: 'Domestic Sales',
                labelAr: 'المبيعات المحلية',
                value: config.formatter.formatMoney(250000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Export Sales',
                labelAr: 'مبيعات التصدير',
                value: config.formatter.formatMoney(120000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Service Income',
                labelAr: 'دخل الخدمات',
                value: config.formatter.formatMoney(45000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Revenue',
                labelAr: 'إجمالي الإيرادات',
                value: config.formatter.formatMoney(415000, currencyCode: 'SAR'),
                valueColor: const Color(0xFF2E7D32),
              ),
            ],
          ),
          GeniusPdfSummaryGroup(
            title: config.isRTL ? 'تكلفة البضاعة المباعة' : 'Cost of Goods Sold',
            titleAr: 'تكلفة البضاعة المباعة',
            items: [
              GeniusPdfSummaryItem.indented(
                label: 'Raw Materials',
                labelAr: 'مواد خام',
                value: config.formatter.formatMoney(85000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Manufacturing',
                labelAr: 'تصنيع',
                value: config.formatter.formatMoney(60000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Shipping',
                labelAr: 'شحن',
                value: config.formatter.formatMoney(18000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total COGS',
                labelAr: 'إجمالي التكلفة',
                value: config.formatter.formatMoney(163000, currencyCode: 'SAR'),
                valueColor: const Color(0xFFC62828),
              ),
            ],
          ),
          GeniusPdfSummaryGroup.expense(
            title: config.isRTL ? 'المصروفات التشغيلية' : 'Operating Expenses',
            titleAr: 'المصروفات التشغيلية',
            items: [
              GeniusPdfSummaryItem.indented(
                label: 'Salaries & Benefits',
                labelAr: 'رواتب ومزايا',
                value: config.formatter.formatMoney(75000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Rent',
                labelAr: 'إيجار',
                value: config.formatter.formatMoney(25000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Marketing',
                labelAr: 'تسويق',
                value: config.formatter.formatMoney(18000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Utilities',
                labelAr: 'مرافق',
                value: config.formatter.formatMoney(8000, currencyCode: 'SAR'),
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total OpEx',
                labelAr: 'إجمالي التشغيلية',
                value: config.formatter.formatMoney(126000, currencyCode: 'SAR'),
                valueColor: const Color(0xFFC62828),
              ),
            ],
          ),
        ],
        items: [
          const GeniusPdfSummaryItem.separator(height: 6),
          GeniusPdfSummaryItem.subtotal(
            label: 'Gross Profit',
            labelAr: 'إجمالي الربح',
            value: config.formatter.formatMoney(252000, currencyCode: 'SAR'),
            valueColor: const Color(0xFF388E3C),
          ),
          GeniusPdfSummaryItem.subtotal(
            label: 'Operating Income',
            labelAr: 'الدخل التشغيلي',
            value: config.formatter.formatMoney(126000, currencyCode: 'SAR'),
          ),
          GeniusPdfSummaryItem.negative(
            label: 'Taxes (20%)',
            labelAr: 'ضرائب (20%)',
            value: config.formatter.formatMoney(25200, currencyCode: 'SAR'),
          ),
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.total(
            label: 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.formatter.formatMoney(100800, currencyCode: 'SAR'),
            valueColor: const Color(0xFF1B5E20),
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
        width: 300,
      ),
      spacing: 15,
    );

    addSpace(15);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL
            ? 'تحسينات الملخص v2.12.5'
            : 'Summary Enhancements v2.12.5',
        titleAr: 'تحسينات الملخص v2.12.5',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'المجموعات' : 'Groups',
            labelAr: 'المجموعات',
            value: config.isRTL
                ? 'GeniusPdfSummaryGroup — مجموعات بعنوان وخلفية ملونة'
                : 'GeniusPdfSummaryGroup — titled sections with colored headers',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'الارتفاع الدقيق' : 'Accurate Height',
            labelAr: 'الارتفاع الدقيق',
            value: config.isRTL
                ? 'يستخدم customHeight وأحجام الخط لكل عنصر'
                : 'Uses customHeight and per-item font sizes',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'خطوط الفصل' : 'Separator Lines',
            labelAr: 'خطوط الفصل',
            value: config.isRTL
                ? 'showSeparatorLine يرسم خطوطاً فعلية بين العناصر'
                : 'showSeparatorLine now renders actual lines between items',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'أنماط الإجمالي' : 'Total Styles',
            labelAr: 'أنماط الإجمالي',
            value: config.isRTL
                ? 'totalLabelStyle / totalValueStyle تُطبَّق على صفوف الإجمالي'
                : 'totalLabelStyle / totalValueStyle applied to total rows',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );

    final footerEdgeGap = remainingHeight > 18 ? remainingHeight - 18 : 0.0;
    addSpace(footerEdgeGap);

    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: [
          GeniusPdfSummaryItem(
            label: 'Footer Edge Metric',
            value: '84,250.00',
          ),
          GeniusPdfSummaryItem.total(
            label: 'Move Together',
            value: 'Required',
          ),
        ],
        style: GeniusPdfSummaryStyle.card(),
        width: 240,
      ),
      spacing: 6,
    );
  }
}
