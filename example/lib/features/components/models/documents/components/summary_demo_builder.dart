import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Summary demo PDF document with extended details (v2.12.5).
///
/// Demonstrates:
/// 1. Basic invoice summary with multiple item types
/// 2. Grouped summary with income/expense sections
/// 3. Indented hierarchical summary
/// 4. Different style presets (invoice, card, bordered, minimal)
/// 5. Custom per-item font sizes and colors
/// 6. Separator lines between items
class SummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  SummaryDemoBuilder(super.config);

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

    addLine(
      config.isRTL
          ? 'مثال ١: ملخص فاتورة أساسي مع صفوف متعددة الأنواع'
          : 'Example 1: Basic invoice summary with multiple item types',
      topMargin: 5,
    );

    addSpace(12);

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
            value: config.isRTL ? '30,100.00 ر.س' : 'SAR 30,100.00',
          ),
          GeniusPdfSummaryItem.negative(
            label: 'Discount (3.3%)',
            labelAr: 'الخصم (3.3%)',
            value: config.isRTL ? '- 1,000.00 ر.س' : '- SAR 1,000.00',
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
          const GeniusPdfSummaryItem.separator(),
          GeniusPdfSummaryItem.total(
            label: 'Total Due',
            labelAr: 'المبلغ المستحق',
            value: config.isRTL ? '33,465.00 ر.س' : 'SAR 33,465.00',
            valueColor: const Color(0xFF2E7D32),
          ),
        ],
        style: GeniusPdfSummaryStyle.invoice(),
      ),
      spacing: 20,
    );

    addSpace(25);

    // --- Example 2: Grouped Summary ---
    addLine(
      config.isRTL
          ? 'مثال ٢: ملخص مجمّع مع مجموعات (إيرادات / مصروفات)'
          : 'Example 2: Grouped summary (Revenue / Expenses)',
      topMargin: 5,
    );

    addSpace(12);

    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        title: config.isRTL ? 'الملخص المالي' : 'Financial Summary',
        titleAr: 'الملخص المالي',
        groups: [
          GeniusPdfSummaryGroup.income(
            title: config.isRTL ? 'الإيرادات' : 'Revenue',
            titleAr: 'الإيرادات',
            items: [
              GeniusPdfSummaryItem(
                label: 'Product Sales',
                labelAr: 'مبيعات المنتجات',
                value: config.isRTL ? '85,000.00 ر.س' : 'SAR 85,000.00',
              ),
              GeniusPdfSummaryItem(
                label: 'Service Revenue',
                labelAr: 'إيرادات الخدمات',
                value: config.isRTL ? '32,000.00 ر.س' : 'SAR 32,000.00',
              ),
              GeniusPdfSummaryItem(
                label: 'Consulting Fees',
                labelAr: 'رسوم الاستشارات',
                value: config.isRTL ? '15,000.00 ر.س' : 'SAR 15,000.00',
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Revenue',
                labelAr: 'إجمالي الإيرادات',
                value: config.isRTL ? '132,000.00 ر.س' : 'SAR 132,000.00',
                valueColor: const Color(0xFF2E7D32),
              ),
            ],
          ),
          GeniusPdfSummaryGroup.expense(
            title: config.isRTL ? 'المصروفات' : 'Expenses',
            titleAr: 'المصروفات',
            items: [
              GeniusPdfSummaryItem(
                label: 'Operating Costs',
                labelAr: 'تكاليف التشغيل',
                value: config.isRTL ? '45,000.00 ر.س' : 'SAR 45,000.00',
              ),
              GeniusPdfSummaryItem(
                label: 'Salaries',
                labelAr: 'الرواتب',
                value: config.isRTL ? '38,000.00 ر.س' : 'SAR 38,000.00',
              ),
              GeniusPdfSummaryItem(
                label: 'Rent & Utilities',
                labelAr: 'الإيجار والمرافق',
                value: config.isRTL ? '12,000.00 ر.س' : 'SAR 12,000.00',
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Expenses',
                labelAr: 'إجمالي المصروفات',
                value: config.isRTL ? '95,000.00 ر.س' : 'SAR 95,000.00',
                valueColor: const Color(0xFFC62828),
              ),
            ],
          ),
        ],
        items: [
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.total(
            label: 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.isRTL ? '37,000.00 ر.س' : 'SAR 37,000.00',
            valueColor: const Color(0xFF2E7D32),
          ),
        ],
        style: GeniusPdfSummaryStyle.bordered(),
        width: 280,
      ),
      spacing: 15,
    );

    // ================================================================
    // PAGE 2: Indented Summary + Style Presets
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٣: ملخص هرمي مع مسافات بادئة'
          : 'Example 3: Hierarchical summary with indentation',
      spacing: 10,
    );

    addSpace(12);

    // --- Example 3: Indented Hierarchical Summary ---
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: [
          GeniusPdfSummaryItem.subtotal(
            label: 'Electronics',
            labelAr: 'إلكترونيات',
            value: config.isRTL ? '29,500.00 ر.س' : 'SAR 29,500.00',
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Laptops',
            labelAr: 'حواسيب محمولة',
            value: config.isRTL ? '16,000.00 ر.س' : 'SAR 16,000.00',
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Monitors',
            labelAr: 'شاشات',
            value: config.isRTL ? '6,000.00 ر.س' : 'SAR 6,000.00',
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Accessories',
            labelAr: 'ملحقات',
            value: config.isRTL ? '7,500.00 ر.س' : 'SAR 7,500.00',
            level: 1,
          ),
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.subtotal(
            label: 'Furniture',
            labelAr: 'أثاث',
            value: config.isRTL ? '17,800.00 ر.س' : 'SAR 17,800.00',
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Desks',
            labelAr: 'مكاتب',
            value: config.isRTL ? '7,600.00 ر.س' : 'SAR 7,600.00',
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Chairs',
            labelAr: 'كراسي',
            value: config.isRTL ? '7,800.00 ر.س' : 'SAR 7,800.00',
            level: 1,
          ),
          GeniusPdfSummaryItem.indented(
            label: 'Cabinets',
            labelAr: 'خزائن',
            value: config.isRTL ? '2,400.00 ر.س' : 'SAR 2,400.00',
            level: 1,
          ),
          const GeniusPdfSummaryItem.separator(height: 6),
          GeniusPdfSummaryItem.total(
            label: 'Grand Total',
            labelAr: 'الإجمالي الكلي',
            value: config.isRTL ? '47,300.00 ر.س' : 'SAR 47,300.00',
          ),
        ],
        style: GeniusPdfSummaryStyle.card(),
        width: 260,
      ),
      spacing: 15,
    );

    addSpace(25);

    // --- Example 4: Style Comparison ---
    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٤: مقارنة الأنماط المختلفة'
          : 'Example 4: Style preset comparison',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'نفس البيانات بأربعة أنماط مختلفة: invoice / card / bordered / minimal'
          : 'Same data with 4 styles: invoice / card / bordered / minimal',
      topMargin: 5,
    );

    addSpace(10);

    // Shared items for comparison
    final comparisonItems = [
      GeniusPdfSummaryItem(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        value: config.isRTL ? '10,000 ر.س' : 'SAR 10,000',
      ),
      GeniusPdfSummaryItem(
        label: 'Tax (15%)',
        labelAr: 'ضريبة (15%)',
        value: config.isRTL ? '1,500 ر.س' : 'SAR 1,500',
      ),
      GeniusPdfSummaryItem.total(
        label: 'Total',
        labelAr: 'الإجمالي',
        value: config.isRTL ? '11,500 ر.س' : 'SAR 11,500',
      ),
    ];

    // Invoice style
    addLine(
      config.isRTL ? 'نمط الفاتورة (invoice)' : 'invoice style',
      topMargin: 4,
    );
    addSpace(4);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: comparisonItems,
        style: GeniusPdfSummaryStyle.invoice(),
        width: 220,
      ),
      spacing: 10,
    );

    addSpace(12);

    // Card style
    addLine(
      config.isRTL ? 'نمط البطاقة (card)' : 'card style',
      topMargin: 4,
    );
    addSpace(4);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: comparisonItems,
        style: GeniusPdfSummaryStyle.card(),
        width: 220,
      ),
      spacing: 10,
    );

    addSpace(12);

    // Bordered style
    addLine(
      config.isRTL ? 'نمط الحدود (bordered)' : 'bordered style',
      topMargin: 4,
    );
    addSpace(4);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: comparisonItems,
        style: GeniusPdfSummaryStyle.bordered(),
        width: 220,
      ),
      spacing: 10,
    );

    addSpace(12);

    // Minimal style
    addLine(
      config.isRTL ? 'نمط مبسّط (minimal)' : 'minimal style',
      topMargin: 4,
    );
    addSpace(4);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: comparisonItems,
        style: GeniusPdfSummaryStyle.minimal(),
        width: 220,
      ),
      spacing: 10,
    );

    // ================================================================
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
                value: config.isRTL ? '250,000 ر.س' : 'SAR 250,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Export Sales',
                labelAr: 'مبيعات التصدير',
                value: config.isRTL ? '120,000 ر.س' : 'SAR 120,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Service Income',
                labelAr: 'دخل الخدمات',
                value: config.isRTL ? '45,000 ر.س' : 'SAR 45,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Revenue',
                labelAr: 'إجمالي الإيرادات',
                value: config.isRTL ? '415,000 ر.س' : 'SAR 415,000',
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
                value: config.isRTL ? '85,000 ر.س' : 'SAR 85,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Manufacturing',
                labelAr: 'تصنيع',
                value: config.isRTL ? '60,000 ر.س' : 'SAR 60,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Shipping',
                labelAr: 'شحن',
                value: config.isRTL ? '18,000 ر.س' : 'SAR 18,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total COGS',
                labelAr: 'إجمالي التكلفة',
                value: config.isRTL ? '163,000 ر.س' : 'SAR 163,000',
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
                value: config.isRTL ? '75,000 ر.س' : 'SAR 75,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Rent',
                labelAr: 'إيجار',
                value: config.isRTL ? '25,000 ر.س' : 'SAR 25,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Marketing',
                labelAr: 'تسويق',
                value: config.isRTL ? '18,000 ر.س' : 'SAR 18,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.indented(
                label: 'Utilities',
                labelAr: 'مرافق',
                value: config.isRTL ? '8,000 ر.س' : 'SAR 8,000',
                level: 1,
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total OpEx',
                labelAr: 'إجمالي التشغيلية',
                value: config.isRTL ? '126,000 ر.س' : 'SAR 126,000',
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
            value: config.isRTL ? '252,000 ر.س' : 'SAR 252,000',
            valueColor: const Color(0xFF388E3C),
          ),
          GeniusPdfSummaryItem.subtotal(
            label: 'Operating Income',
            labelAr: 'الدخل التشغيلي',
            value: config.isRTL ? '126,000 ر.س' : 'SAR 126,000',
          ),
          GeniusPdfSummaryItem.negative(
            label: 'Taxes (20%)',
            labelAr: 'ضرائب (20%)',
            value: config.isRTL ? '25,200 ر.س' : 'SAR 25,200',
          ),
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.total(
            label: 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.isRTL ? '100,800 ر.س' : 'SAR 100,800',
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
