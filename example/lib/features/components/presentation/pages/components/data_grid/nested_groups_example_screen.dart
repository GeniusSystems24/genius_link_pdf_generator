import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for the Nested Groups DataGrid example.
///
/// The document is generated only after the user presses **Run example**. The
/// code panel below contains the actual builder source used by this example.
class DataGridNestedGroupsExampleScreen extends StatelessWidget {
  const DataGridNestedGroupsExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused nested-groups DataGrid example.
class DataGridNestedGroupsDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridNestedGroupsDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٣: مجموعات مع مجموعات فرعية'
          : 'Example 3: Groups with Nested Subgroups',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'جدول مُجمَّع حسب الفئة مع مجموعات فرعية وإجماليات لكل مجموعة.'
          : 'Grouped table by category with nested subgroups and per-group totals.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'item',
            title: 'Item',
            titleAr: 'الصنف',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
            width: 50,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Unit Price',
            titleAr: 'سعر الوحدة',
            width: 90,
            isNumeric: true,
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            width: 100,
            isNumeric: true,
          ),
        ],
        rows: [],
        groups: [
          // Group 1: Electronics with subgroups
          GeniusPdfGridGroup(
            title: 'Electronics',
            titleAr: 'إلكترونيات',
            rows: const [],
            subgroups: [
              GeniusPdfGridGroup.withSummary(
                title: 'Computers',
                titleAr: 'حواسيب',
                rows: [
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لابتوب HP' : 'HP Laptop', 'qty': 5, 'price': 3200, 'total': 16000}),
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لابتوب Dell' : 'Dell Laptop', 'qty': 3, 'price': 4500, 'total': 13500}),
                ],
                sumColumns: ['total'],
                labelColumnId: 'item',
                summaryLabel: 'Computers Subtotal',
                summaryLabelAr: 'مجموع الحواسيب',
              ),
              GeniusPdfGridGroup.withSummary(
                title: 'Accessories',
                titleAr: 'ملحقات',
                rows: [
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'ماوس لاسلكي' : 'Wireless Mouse', 'qty': 20, 'price': 85, 'total': 1700}),
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لوحة مفاتيح' : 'Keyboard', 'qty': 15, 'price': 120, 'total': 1800}),
                ],
                sumColumns: ['total'],
                labelColumnId: 'item',
                summaryLabel: 'Accessories Subtotal',
                summaryLabelAr: 'مجموع الملحقات',
              ),
            ],
            summary: GeniusPdfGridRow.total({
              'item': config.isRTL ? 'إجمالي الإلكترونيات' : 'Electronics Total',
              'total': 33000,
            }),
          ),

          // Group 2: Furniture
          GeniusPdfGridGroup.withSummary(
            title: 'Office Furniture',
            titleAr: 'أثاث مكتبي',
            rows: [
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'مكتب خشبي' : 'Wooden Desk', 'qty': 8, 'price': 950, 'total': 7600}),
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'كرسي مكتبي' : 'Office Chair', 'qty': 12, 'price': 650, 'total': 7800}),
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'خزانة ملفات' : 'Filing Cabinet', 'qty': 5, 'price': 480, 'total': 2400}),
            ],
            sumColumns: ['total'],
            labelColumnId: 'item',
            summaryLabel: 'Furniture Subtotal',
            summaryLabelAr: 'مجموع الأثاث',
          ),
        ],
        // Grand total after all groups
        footerRows: [
          GeniusPdfGridRow.total({
            'item': config.isRTL ? 'الإجمالي الكلي' : 'Grand Total',
            'total': 50800,
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    // ================================================================
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'data_grid_nested_groups',
      category: 'Components / Data Grid',
      title: pdfLocalization.nestedGroups,
      apiName: 'GeniusPdfDataGrid',
      description: pdfLocalization.groupedDataGridContentNestedDesc,
      icon: Icons.table_chart_outlined,
      usageCode: dartUsageCode,
    );
  }
}
