import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for the Auto-Calculated Totals DataGrid example.
///
/// The document is generated only after the user presses **Run example**. The
/// code panel below contains the actual builder source used by this example.
class DataGridAutoTotalsExampleScreen extends StatelessWidget {
  const DataGridAutoTotalsExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused automatic-totals DataGrid example.
class DataGridAutoTotalsDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridAutoTotalsDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    newPage();

    // ================================================================

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: إجماليات محسوبة تلقائياً'
          : 'Example 2: Auto-Calculated Totals',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'يقوم الجدول بحساب المجموع والمتوسط والعدد تلقائياً من بيانات الصفوف.'
          : 'The grid automatically calculates sum, average, and count from row data.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'employee',
            title: 'Employee',
            titleAr: 'الموظف',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn(
            id: 'dept',
            title: 'Department',
            titleAr: 'القسم',
            flexFactor: 1,
          ),
          GeniusPdfGridColumn.currency(
            id: 'salary',
            title: 'Salary',
            titleAr: 'الراتب',
            isNumeric: true,
            width: 90,
          ),
          GeniusPdfGridColumn.currency(
            id: 'bonus',
            title: 'Bonus',
            titleAr: 'المكافأة',
            isNumeric: true,
            width: 80,
          ),
          GeniusPdfGridColumn.currency(
            id: 'net',
            title: 'Net Pay',
            titleAr: 'صافي الدفع',
            isNumeric: true,
            width: 100,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'أحمد محمد' : 'Ahmed M.', 'dept': config.isRTL ? 'تقنية' : 'IT', 'salary': 12000, 'bonus': 2000, 'net': 14000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'سارة علي' : 'Sara A.', 'dept': config.isRTL ? 'مالية' : 'Finance', 'salary': 10000, 'bonus': 1500, 'net': 11500}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'خالد يوسف' : 'Khalid Y.', 'dept': config.isRTL ? 'تقنية' : 'IT', 'salary': 15000, 'bonus': 3000, 'net': 18000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'فاطمة حسن' : 'Fatima H.', 'dept': config.isRTL ? 'موارد' : 'HR', 'salary': 9000, 'bonus': 1000, 'net': 10000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'عمر سالم' : 'Omar S.', 'dept': config.isRTL ? 'مبيعات' : 'Sales', 'salary': 11000, 'bonus': 4000, 'net': 15000}),
        ],
        // Auto-calculated total rows
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total',
            labelAr: 'الإجمالي',
            labelColumnId: 'employee',
            columnIds: ['salary', 'bonus', 'net'],
          ),
          GeniusPdfAutoTotal.average(
            label: 'Average',
            labelAr: 'المتوسط',
            labelColumnId: 'employee',
            columnIds: ['salary', 'bonus', 'net'],
          ),
          GeniusPdfAutoTotal.count(
            label: 'Count',
            labelAr: 'العدد',
            labelColumnId: 'employee',
            columnIds: ['salary'],
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
      componentId: 'data_grid_auto_totals',
      category: 'Components / Data Grid',
      title: 'Auto-Calculated Totals',
      apiName: 'GeniusPdfDataGrid',
      description: 'Demonstrate GeniusPdfAutoTotal sum, average, and count rows calculated directly from DataGrid row values.',
      icon: Icons.table_chart_outlined,
      usageCode: dartUsageCode,
    );
  }
}
