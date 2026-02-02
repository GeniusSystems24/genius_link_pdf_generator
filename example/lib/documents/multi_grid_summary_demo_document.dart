import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Demonstrates v2.5.0 grid integration with per-grid and overall report summaries.
///
/// This example showcases:
/// - **[addGrid]** — Draw a data grid at the current position
/// - **[addSummary]** — Draw a summary section at the current position
/// - **[addGridWithSummary]** — Combined grid + summary in one call
/// - **[addReportSummary]** — Overall report summary aggregating all sections
/// - **[addSectionDivider]** — Visual divider with centered title
///
/// ## Example
/// ```dart
/// final doc = MultiGridSummaryDemoBuilder(config: myConfig);
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class MultiGridSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [MultiGridSummaryDemoBuilder].
  MultiGridSummaryDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
  }) : super(config);

  /// User name for the footer.
  final String userName;

  // Accumulators for the overall report summary.
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

  // ──────────────────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────────────────

  void _buildHeader() {
    addHeader(
      title: isRTL
          ? 'تقرير متعدد الجداول — الإصدار 2.5.0'
          : 'Multi-Grid Report — v2.5.0',
    );
  }

  // ──────────────────────────────────────────────────────────
  // Section 1: Sales Grid + Summary
  // ──────────────────────────────────────────────────────────

  void _buildSalesSection() {
    addSectionDivider(
      title: isRTL ? 'قسم المبيعات' : 'Sales Section',
      spacing: 10,
    );

    final salesGrid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          titleAr: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
          flexFactor: 3,
        ),
        const GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Price',
          titleAr: 'السعر',
          width: 80,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 90,
          currencySymbol: '',
        ),
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'no': 1,
          'item': isRTL ? 'حاسوب محمول' : 'Laptop',
          'qty': 5,
          'price': 3500.00,
          'total': 17500.00,
        }),
        GeniusPdfGridRow(cells: {
          'no': 2,
          'item': isRTL ? 'شاشة عرض' : 'Monitor',
          'qty': 10,
          'price': 1200.00,
          'total': 12000.00,
        }),
        GeniusPdfGridRow(cells: {
          'no': 3,
          'item': isRTL ? 'لوحة مفاتيح' : 'Keyboard',
          'qty': 20,
          'price': 250.00,
          'total': 5000.00,
        }),
        GeniusPdfGridRow(cells: {
          'no': 4,
          'item': isRTL ? 'فأرة' : 'Mouse',
          'qty': 20,
          'price': 150.00,
          'total': 3000.00,
        }),
      ],
      style: GeniusPdfGridStyle.classic(),
    );

    final salesSubtotal = 37500.00;
    final salesTax = salesSubtotal * 0.15;
    final salesTotal = salesSubtotal + salesTax;
    _totalSales = salesTotal;

    final salesSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Subtotal',
          labelAr: 'المجموع الفرعي',
          value: _fmt(salesSubtotal),
        ),
        GeniusPdfSummaryItem(
          label: 'VAT (15%)',
          labelAr: 'ضريبة القيمة المضافة (15%)',
          value: _fmt(salesTax),
        ),
        GeniusPdfSummaryItem.total(
          label: 'Sales Total',
          labelAr: 'إجمالي المبيعات',
          value: _fmt(salesTotal),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: 220,
    );

    // Use addGridWithSummary for combined output.
    addGridWithSummary(
      grid: salesGrid,
      summary: salesSummary,
      gridSpacing: 5,
      summarySpacing: 10,
    );

    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Section 2: Expenses Grid + Summary
  // ──────────────────────────────────────────────────────────

  void _buildExpensesSection() {
    addSectionDivider(
      title: isRTL ? 'قسم المصروفات' : 'Expenses Section',
      spacing: 10,
    );

    final expensesGrid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          titleAr: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'الفئة',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn.currency(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          width: 100,
          currencySymbol: '',
        ),
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'no': 1,
          'category': isRTL ? 'إيجار المكتب' : 'Office Rent',
          'amount': 8000.00,
        }),
        GeniusPdfGridRow(cells: {
          'no': 2,
          'category': isRTL ? 'رواتب الموظفين' : 'Employee Salaries',
          'amount': 15000.00,
        }),
        GeniusPdfGridRow(cells: {
          'no': 3,
          'category': isRTL ? 'مصاريف تشغيل' : 'Operating Costs',
          'amount': 3500.00,
        }),
      ],
      style: GeniusPdfGridStyle.classic(),
    );

    final expensesTotal = 26500.00;
    _totalExpenses = expensesTotal;

    final expensesSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.total(
          label: 'Expenses Total',
          labelAr: 'إجمالي المصروفات',
          value: _fmt(expensesTotal),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: 220,
    );

    // Draw grid and summary separately to show the individual APIs.
    addGrid(expensesGrid, spacing: 5);
    addSummary(expensesSummary, spacing: 10);
    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Overall Report Summary
  // ──────────────────────────────────────────────────────────

  void _buildOverallReportSummary() {
    final netProfit = _totalSales - _totalExpenses;

    final reportSummary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Total Sales',
          labelAr: 'إجمالي المبيعات',
          value: _fmt(_totalSales),
        ),
        GeniusPdfSummaryItem(
          label: 'Total Expenses',
          labelAr: 'إجمالي المصروفات',
          value: '(${_fmt(_totalExpenses)})',
        ),
        GeniusPdfSummaryItem.total(
          label: 'Net Profit',
          labelAr: 'صافي الربح',
          value: _fmt(netProfit),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.center,
      width: 280,
    );

    addReportSummary(
      summary: reportSummary,
      title: isRTL ? 'ملخص التقرير' : 'Report Summary',
      titleAr: isRTL ? 'ملخص التقرير' : 'Report Summary',
      spacing: 20,
    );
  }

  // ──────────────────────────────────────────────────────────
  // Footer
  // ──────────────────────────────────────────────────────────

  void _buildFooter() {
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );
  }

  // ──────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────

  String _fmt(double value) => value.toStringAsFixed(2);
}
