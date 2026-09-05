import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for the Auto Grouping DataGrid example.
///
/// The document is generated only after the user presses **Run example**. The
/// code panel below contains the actual builder source used by this example.
class DataGridAutoGroupingExampleScreen extends StatelessWidget {
  const DataGridAutoGroupingExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused auto-grouping DataGrid example.
class DataGridAutoGroupingDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridAutoGroupingDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    newPage();

    // ================================================================

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٤: التجميع التلقائي بالأداة المساعدة'
          : 'Example 4: Auto-Grouping via Utility',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'يقوم GeniusDataGridUtils.autoGroup بتجميع الصفوف تلقائياً حسب عمود محدد.'
          : 'GeniusDataGridUtils.autoGroup groups rows by a specified column automatically.',
      topMargin: 5,
    );

    addSpace(10);

    // Raw data rows (mixed departments)
    final allRows = [
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'أحمد' : 'Ahmed', 'dept': config.isRTL ? 'تقنية' : 'IT', 'hours': 160, 'rate': 50, 'amount': 8000}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'سارة' : 'Sara', 'dept': config.isRTL ? 'مالية' : 'Finance', 'hours': 170, 'rate': 55, 'amount': 9350}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'خالد' : 'Khalid', 'dept': config.isRTL ? 'تقنية' : 'IT', 'hours': 155, 'rate': 60, 'amount': 9300}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'فاطمة' : 'Fatima', 'dept': config.isRTL ? 'مالية' : 'Finance', 'hours': 165, 'rate': 45, 'amount': 7425}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'عمر' : 'Omar', 'dept': config.isRTL ? 'مبيعات' : 'Sales', 'hours': 180, 'rate': 40, 'amount': 7200}),
    ];

    // Auto-group by department with summaries
    final autoGroups = GeniusDataGridUtils.autoGroup(
      rows: allRows,
      groupByColumn: 'dept',
      sumColumns: ['amount'],
      summaryLabelColumnId: 'name',
      summaryLabel: 'Dept Total',
      summaryLabelAr: 'مجموع القسم',
    );

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم', flexFactor: 2),
          GeniusPdfGridColumn(id: 'dept', title: 'Department', titleAr: 'القسم', width: 80),
          GeniusPdfGridColumn.numeric(id: 'hours', title: 'Hours', titleAr: 'الساعات', width: 60, alignment: GeniusPdfTextAlign.center),
          GeniusPdfGridColumn.currency(id: 'rate', title: 'Rate', titleAr: 'المعدل', width: 70, isNumeric: true),
          GeniusPdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ', width: 90, isNumeric: true),
        ],
        rows: [],
        groups: autoGroups,
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Grand Total',
            labelAr: 'الإجمالي الكلي',
            labelColumnId: 'name',
            columnIds: ['amount'],
          ),
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
    return const ComponentExampleDetailScreen(
      componentId: 'data_grid_auto_grouping',
      category: 'Components / Data Grid',
      title: 'Auto Grouping',
      apiName: 'GeniusPdfDataGrid',
      description: 'Use GeniusDataGridUtils.autoGroup to convert ordinary rows into grouped sections with automatically generated summaries.',
      icon: Icons.table_chart_outlined,
      usageCode: dartUsageCode,
    );
  }
}
