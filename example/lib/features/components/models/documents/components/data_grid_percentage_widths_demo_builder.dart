import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused percentage-column-width DataGrid example.
class DataGridPercentageWidthsDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridPercentageWidthsDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٥: أعمدة بنسب مئوية وقيود عرض'
          : 'Example 5: Percentage Columns & Width Constraints',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'widthPercent يحدد عرض العمود كنسبة مئوية من العرض المتاح مع دعم الحد الأدنى والأقصى.'
          : 'widthPercent defines column width as a percentage of available width with min/max constraints.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'id',
            title: '#',
            titleAr: '#',
            widthPercent: 0.08,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'product',
            title: 'Product Name',
            titleAr: 'اسم المنتج',
            widthPercent: 0.32,
          ),
          GeniusPdfGridColumn(
            id: 'category',
            title: 'Category',
            titleAr: 'الفئة',
            widthPercent: 0.15,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'stock',
            title: 'Stock',
            titleAr: 'المخزون',
            widthPercent: 0.10,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'cost',
            title: 'Cost',
            titleAr: 'التكلفة',
            widthPercent: 0.15,
            isNumeric: true,
          ),
          GeniusPdfGridColumn.currency(
            id: 'sell',
            title: 'Sell Price',
            titleAr: 'سعر البيع',
            widthPercent: 0.20,
            isNumeric: true,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {'id': 1, 'product': config.isRTL ? 'هاتف ذكي سامسونج' : 'Samsung Phone', 'category': config.isRTL ? 'هواتف' : 'Phones', 'stock': 45, 'cost': 1800, 'sell': 2500}),
          GeniusPdfGridRow(cells: {'id': 2, 'product': config.isRTL ? 'آيفون ١٥' : 'iPhone 15', 'category': config.isRTL ? 'هواتف' : 'Phones', 'stock': 30, 'cost': 3200, 'sell': 4200}),
          GeniusPdfGridRow(cells: {'id': 3, 'product': config.isRTL ? 'سماعات بلوتوث' : 'Bluetooth Headphones', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 120, 'cost': 150, 'sell': 250}),
          GeniusPdfGridRow(cells: {'id': 4, 'product': config.isRTL ? 'حقيبة لابتوب' : 'Laptop Bag', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 80, 'cost': 95, 'sell': 180}),
          GeniusPdfGridRow(cells: {'id': 5, 'product': config.isRTL ? 'شاحن سريع' : 'Fast Charger', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 200, 'cost': 45, 'sell': 85}),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Stock Value',
            labelAr: 'إجمالي قيمة المخزون',
            labelColumnId: 'product',
            columnIds: ['stock', 'cost', 'sell'],
          ),
          GeniusPdfAutoTotal.min(
            label: 'Min',
            labelAr: 'الأدنى',
            labelColumnId: 'product',
            columnIds: ['cost', 'sell'],
          ),
          GeniusPdfAutoTotal.max(
            label: 'Max',
            labelAr: 'الأقصى',
            labelColumnId: 'product',
            columnIds: ['cost', 'sell'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التحسينات v2.12.0' : 'v2.12.0 Enhancements Summary',
        titleAr: 'ملخص التحسينات v2.12.0',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'أعمدة نسبية' : 'Percentage Columns',
            labelAr: 'أعمدة نسبية',
            value: config.isRTL
                ? 'widthPercent لتحديد عرض العمود كنسبة من العرض الكلي'
                : 'widthPercent to set column width as a ratio of total width',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجماليات متعددة' : 'Multi Totals',
            labelAr: 'إجماليات متعددة',
            value: config.isRTL
                ? 'footerRows + autoTotals (مجموع، متوسط، عدد، أدنى، أقصى)'
                : 'footerRows + autoTotals (sum, avg, count, min, max)',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'مجموعات فرعية' : 'Nested Groups',
            labelAr: 'مجموعات فرعية',
            value: config.isRTL
                ? 'دعم المجموعات المتداخلة مع إجماليات لكل مستوى'
                : 'Nested subgroups with per-level totals',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'حساب دقيق' : 'Accurate Widths',
            labelAr: 'حساب دقيق',
            value: config.isRTL
                ? 'خوارزمية محسّنة متعددة المراحل مع إعادة توزيع القيود'
                : 'Multi-pass algorithm with constraint redistribution',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );

    // ================================================================
  }
}
