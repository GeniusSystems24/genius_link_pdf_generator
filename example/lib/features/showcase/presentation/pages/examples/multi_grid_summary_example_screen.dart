import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for the Multi-Grid Summary Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class MultiGridSummaryExampleScreen extends StatelessWidget {
  const MultiGridSummaryExampleScreen({super.key});

  static const String dartUsageCode = r'''/// Manual regression fixture for multi-page grid to summary continuation.
///
/// This example intentionally generates enough rows to force grid pagination,
/// then draws per-section summaries plus a final report summary so manual
/// verification can confirm that follow-up content stays on the grid's final
/// page or moves safely to a new page when required.
class MultiGridSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  MultiGridSummaryDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
  }) : super(config);

  final String userName;

  double _totalSales = 0;
  double _totalExpenses = 0;

  @override
  void build() {
    _buildHeader();
    _buildSalesSection();
    _buildExpensesSection();
    _buildOverallReportSummary();
    _buildFooter();
  }

  void _buildHeader() {
    addHeader(
      title: isRTL
          ? 'RTL Multi-Grid Continuation Fixture'
          : 'Multi-Grid Continuation Fixture',
    );
  }

  void _buildSalesSection() {
    addSectionDivider(
      title: isRTL ? 'RTL Sales Section' : 'Sales Section',
      spacing: 10,
    );

    final salesRows = _buildSalesRows();
    final salesGrid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'item',
          title: 'Item',
          flexFactor: 3,
        ),
        const GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Price',
          width: 80,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          width: 90,
          currencySymbol: '',
        ),
      ],
      rows: salesRows,
      style: GeniusPdfGridStyle.classic(),
    );

    final salesSubtotal = salesRows.fold<double>(
      0,
      (sum, row) => sum + (row.cells['total'] as double),
    );
    final salesTax = salesSubtotal * 0.15;
    final salesTotal = salesSubtotal + salesTax;
    _totalSales = salesTotal;

    final salesSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Subtotal',
          value: _fmt(salesSubtotal),
        ),
        GeniusPdfSummaryItem(
          label: 'VAT (15%)',
          value: _fmt(salesTax),
        ),
        GeniusPdfSummaryItem.total(
          label: 'Sales Total',
          value: _fmt(salesTotal),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: 220,
    );

    addGridWithSummary(
      grid: salesGrid,
      summary: salesSummary,
      gridSpacing: 5,
      summarySpacing: 10,
    );

    addSpace(15);
  }

  void _buildExpensesSection() {
    addSectionDivider(
      title: isRTL ? 'RTL Expenses Section' : 'Expenses Section',
      spacing: 10,
    );

    final expenseRows = _buildExpenseRows();
    final expensesGrid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'category',
          title: 'Category',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn.currency(
          id: 'amount',
          title: 'Amount',
          width: 100,
          currencySymbol: '',
        ),
      ],
      rows: expenseRows,
      style: GeniusPdfGridStyle.classic(),
    );

    final expensesTotal = expenseRows.fold<double>(
      0,
      (sum, row) => sum + (row.cells['amount'] as double),
    );
    _totalExpenses = expensesTotal;

    final expensesSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.total(
          label: 'Expenses Total',
          value: _fmt(expensesTotal),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: 220,
    );

    addGrid(expensesGrid, spacing: 5);
    addSummary(expensesSummary, spacing: 10);
    addSpace(15);
  }

  void _buildOverallReportSummary() {
    final netProfit = _totalSales - _totalExpenses;

    final reportSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Total Sales',
          value: _fmt(_totalSales),
        ),
        GeniusPdfSummaryItem(
          label: 'Total Expenses',
          value: '(${_fmt(_totalExpenses)})',
        ),
        GeniusPdfSummaryItem.total(
          label: 'Net Profit',
          value: _fmt(netProfit),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.center,
      width: 280,
    );

    addReportSummary(
      summary: reportSummary,
      title: isRTL ? 'RTL Report Summary' : 'Report Summary',
      spacing: 20,
    );
  }

  void _buildFooter() {
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );
  }

  String _fmt(double value) => value.toStringAsFixed(2);

  List<GeniusPdfGridRow> _buildSalesRows() {
    const catalog = <({String name, int qty, double price})>[
      (name: 'Laptop', qty: 2, price: 3500),
      (name: 'Monitor', qty: 4, price: 1200),
      (name: 'Keyboard', qty: 6, price: 250),
      (name: 'Mouse', qty: 8, price: 150),
      (name: 'Dock', qty: 3, price: 650),
      (name: 'Headset', qty: 5, price: 420),
      (name: 'Printer', qty: 2, price: 1800),
      (name: 'Scanner', qty: 2, price: 1450),
    ];

    return List.generate(36, (index) {
      final seed = catalog[index % catalog.length];
      final qty = seed.qty + (index % 3);
      final price = seed.price + ((index % 4) * 35);
      final total = qty * price;
      final batch = (index ~/ catalog.length) + 1;

      return GeniusPdfGridRow(
        cells: {
          'no': index + 1,
          'item': '${seed.name} Batch $batch',
          'qty': qty,
          'price': price,
          'total': total,
        },
      );
    });
  }

  List<GeniusPdfGridRow> _buildExpenseRows() {
    const catalog = <({String name, double amount})>[
      (name: 'Office Rent', amount: 8000),
      (name: 'Employee Salaries', amount: 15000),
      (name: 'Operating Costs', amount: 3500),
      (name: 'Utilities', amount: 2200),
      (name: 'Logistics', amount: 2800),
      (name: 'Marketing', amount: 4100),
    ];

    return List.generate(18, (index) {
      final seed = catalog[index % catalog.length];
      final amount = seed.amount + ((index % 5) * 175);
      final cycle = (index ~/ catalog.length) + 1;

      return GeniusPdfGridRow(
        cells: {
          'no': index + 1,
          'category': '${seed.name} Cycle $cycle',
          'amount': amount,
        },
      );
    });
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_multi_grid_summary',
      category: 'Showcase',
      title: pdfLocalization.multiGridSummary,
      apiName: 'MultiGridSummaryDemoBuilder',
      description: pdfLocalization.multiplePaginatedGridsSectionDesc,
      icon: Icons.table_chart_outlined,
      usageCode: dartUsageCode,
    );
  }
}
