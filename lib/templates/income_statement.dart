import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridRow, PdfTextStyle, PdfGridColumn, PdfGridStyle;

import '../src/presentation/document/components/components.dart';
import '../src/core/pdf_config.dart';

import '../src/presentation/document/families/erp/erp_families.dart';
/// Income statement line item.
class IncomeStatementItem {
  const IncomeStatementItem({
    required this.accountCode,
    required this.accountName,
    required this.amount,
    this.accountNameAr,
    this.previousAmount,
    this.isSubtotal = false,
    this.level = 0,
  });

  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final double amount;
  final double? previousAmount;
  final bool isSubtotal;
  final int level;

  double? get variance =>
      previousAmount != null ? amount - previousAmount! : null;
  double? get variancePercent => previousAmount != null && previousAmount != 0
      ? ((amount - previousAmount!) / previousAmount!) * 100
      : null;
}

/// Income statement section (Revenue, Expenses, etc.).
class IncomeStatementSection {
  const IncomeStatementSection({
    required this.title,
    required this.items,
    this.titleAr,
    this.isDeduction = false,
  });

  final String title;
  final String? titleAr;
  final List<IncomeStatementItem> items;
  final bool isDeduction;

  double get total => items.fold(0.0, (sum, item) => sum + item.amount);
  double? get previousTotal {
    if (items.every((item) => item.previousAmount == null)) return null;
    return items.fold(
        0.0, (sum, item) => (sum ?? 0) + (item.previousAmount ?? 0));
  }
}

/// Income statement data model.
class IncomeStatementData {
  const IncomeStatementData({
    required this.periodStart,
    required this.periodEnd,
    required this.revenue,
    required this.costOfSales,
    required this.operatingExpenses,
    this.otherIncome,
    this.otherExpenses,
    this.taxExpense,
    this.comparativePeriodStart,
    this.comparativePeriodEnd,
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final IncomeStatementSection revenue;
  final IncomeStatementSection costOfSales;
  final IncomeStatementSection operatingExpenses;
  final IncomeStatementSection? otherIncome;
  final IncomeStatementSection? otherExpenses;
  final double? taxExpense;
  final DateTime? comparativePeriodStart;
  final DateTime? comparativePeriodEnd;
  final String currency;
  final String? notes;
  final String? notesAr;

  double get totalRevenue => revenue.total;
  double get totalCostOfSales => costOfSales.total;
  double get grossProfit => totalRevenue - totalCostOfSales;
  double get totalOperatingExpenses => operatingExpenses.total;
  double get operatingIncome => grossProfit - totalOperatingExpenses;
  double get totalOtherIncome => otherIncome?.total ?? 0;
  double get totalOtherExpenses => otherExpenses?.total ?? 0;
  double get incomeBeforeTax =>
      operatingIncome + totalOtherIncome - totalOtherExpenses;
  double get netIncome => incomeBeforeTax - (taxExpense ?? 0);

  double get grossProfitMargin =>
      totalRevenue != 0 ? (grossProfit / totalRevenue) * 100 : 0;
  double get netProfitMargin =>
      totalRevenue != 0 ? (netIncome / totalRevenue) * 100 : 0;
}

/// A professional income statement (P&L) template.
///
/// Creates a standard income statement showing revenue,
/// expenses, and profitability metrics.
///
/// ## Example
/// ```dart
/// final incomeStatement = IncomeStatementTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: incomeStatementData,
/// );
///
/// final bytes = incomeStatement.generate();
/// ```
class IncomeStatementTemplate extends GeniusErpAnalyticalReport {
  IncomeStatementTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showComparative = false,
    this.showPercentages = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final IncomeStatementData data;
  final PdfFont? boldFont;
  final bool showComparative;
  final bool showPercentages;

  /// Cached bold font — created once, reused across all methods.
  late final PdfFont _cachedBoldFont = boldFont ?? config.boldFont;


  @override
  void build() {
    newPage();

    _drawHeader();

    // Income statement grid
    _drawIncomeStatementGrid();

    addSpace(10);
    // Profitability Ratios
    if (showPercentages) {
      _drawProfitabilityRatios();
    }

    // Notes
    if (data.notes != null || data.notesAr != null) {
      _drawNotes();
    }
  }

  // ──────────────────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────────────────

  void _drawHeader() {
    final periodText =
        '${_formatDate(data.periodStart)} - ${_formatDate(data.periodEnd)}';

    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Income Statement',
      titleAr: 'قائمة الدخل',
      subtitle: 'For the period $periodText',
      subtitleAr: 'للفترة من $periodText',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    addReportHeader(header, height: 100, spacing: 0);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Section with Items Grid + Total
  // ──────────────────────────────────────────────────────────

  void _drawIncomeStatementGrid() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'code',
        title: 'Code',
        titleAr: 'الكود',
        width: 80,
      ),
      const GeniusPdfGridColumn(
        id: 'account',
        title: 'Description',
        titleAr: 'البيان',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.currency(
        id: 'amount',
        title: 'Amount (${data.currency})',
        titleAr: 'المبلغ (${data.currency})',
        width: 120,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[];

    _appendSectionRows(
      rows: rows,
      section: data.revenue,
      totalLabel: 'Total Revenue',
      totalLabelAr: 'إجمالي الإيرادات',
    );

    _appendSectionRows(
      rows: rows,
      section: data.costOfSales,
      totalLabel: 'Total Cost of Sales',
      totalLabelAr: 'إجمالي تكلفة المبيعات',
    );

    _appendCalculatedRow(
      rows,
      label: 'Gross Profit',
      labelAr: 'إجمالي الربح',
      amount: data.grossProfit,
    );

    _appendSectionRows(
      rows: rows,
      section: data.operatingExpenses,
      totalLabel: 'Total Operating Expenses',
      totalLabelAr: 'إجمالي المصروفات التشغيلية',
    );

    _appendCalculatedRow(
      rows,
      label: 'Operating Income',
      labelAr: 'الدخل التشغيلي',
      amount: data.operatingIncome,
    );

    if (data.otherIncome != null && data.otherIncome!.items.isNotEmpty) {
      _appendSectionRows(
        rows: rows,
        section: data.otherIncome!,
        totalLabel: 'Total Other Income',
        totalLabelAr: 'إجمالي الإيرادات الأخرى',
      );
    }

    if (data.otherExpenses != null && data.otherExpenses!.items.isNotEmpty) {
      _appendSectionRows(
        rows: rows,
        section: data.otherExpenses!,
        totalLabel: 'Total Other Expenses',
        totalLabelAr: 'إجمالي المصروفات الأخرى',
      );
    }

    _appendCalculatedRow(
      rows,
      label: 'Income Before Tax',
      labelAr: 'الدخل قبل الضريبة',
      amount: data.incomeBeforeTax,
    );

    if (data.taxExpense != null) {
      rows.add(
        GeniusPdfGridRow(
          cells: {
            'code': '',
            'account': config.isRTL ? 'مصروف الضريبة' : 'Tax Expense',
            'amount': data.taxExpense,
          },
        ),
      );
    }

    _appendNetIncomeRow(rows);

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      // Keep currentPage/currentY synchronized with Grid pagination,
      // matching TrialBalanceTemplate's multi-page handling.
      updateFromLayoutResult(result, spacing: 10);
    }
  }

  void _appendSectionRows({
    required List<GeniusPdfGridRow> rows,
    required IncomeStatementSection section,
    required String totalLabel,
    required String totalLabelAr,
  }) {
    rows.add(
      GeniusPdfGridRow.groupHeader(
        config.isRTL ? (section.titleAr ?? section.title) : section.title,
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
          backgroundColor: Color(0xFFE3F2FD),
          border: GeniusPdfBorderStyle.all(),
          padding: GeniusPdfCellPadding.all(5),
        ),
      ),
    );

    for (final item in section.items) {
      final indent = '  ' * item.level;
      final accountName = config.isRTL
          ? (item.accountNameAr ?? item.accountName)
          : item.accountName;

      rows.add(
        GeniusPdfGridRow(
          cells: {
            'code': item.accountCode,
            'account': '$indent$accountName',
            'amount': item.amount,
          },
          style: item.isSubtotal ? _subtotalRowStyle : null,
        ),
      );
    }

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'code': '',
          'account': config.isRTL ? totalLabelAr : totalLabel,
          'amount': section.total,
        },
        style: _subtotalRowStyle,
      ),
    );
  }

  void _appendCalculatedRow(
    List<GeniusPdfGridRow> rows, {
    required String label,
    required String labelAr,
    required double amount,
  }) {
    rows.add(
      GeniusPdfGridRow(
        cells: {
          'code': '',
          'account': config.isRTL ? labelAr : label,
          'amount': amount,
        },
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color(0xFFE8EAF6),
          border: GeniusPdfBorderStyle.horizontal(),
          padding: GeniusPdfCellPadding.all(5),
        ),
      ),
    );
  }

  void _appendNetIncomeRow(List<GeniusPdfGridRow> rows) {
    final isProfit = data.netIncome >= 0;

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'code': '',
          'account': config.isRTL ? 'صافي الدخل' : 'Net Income',
          'amount': data.netIncome,
        },
        style: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isProfit
                ? const Color(0xFF1B5E20)
                : const Color(0xFFB71C1C),
          ),
          backgroundColor: isProfit
              ? const Color(0xFFE8F5E9)
              : const Color(0xFFFFEBEE),
          border: const GeniusPdfBorderStyle.all(),
          padding: const GeniusPdfCellPadding.all(6),
        ),
      ),
    );
  }

  GeniusPdfCellStyle get _subtotalRowStyle => const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        border: GeniusPdfBorderStyle.horizontal(),
        padding: GeniusPdfCellPadding.all(4),
      );

  // ──────────────────────────────────────────────────────────
  // Profitability Ratios
  // ──────────────────────────────────────────────────────────

  void _drawProfitabilityRatios() {
    // Need ~60px for title + two ratio lines.
    if (remainingHeight < 60) newPage();

    final title = config.isRTL ? 'مؤشرات الربحية' : 'Profitability Ratios';

    addLine(title, font: _cachedBoldFont, topMargin: 5);

    final ratios = [
      (
        config.isRTL ? 'هامش الربح الإجمالي' : 'Gross Profit Margin',
        data.grossProfitMargin,
      ),
      (
        config.isRTL ? 'هامش صافي الربح' : 'Net Profit Margin',
        data.netProfitMargin,
      ),
    ];

    for (final ratio in ratios) {
      addLine(
        '${ratio.$1}: ${ratio.$2.toStringAsFixed(2)}%',
        topMargin: 5,
      );
    }

    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Notes
  // ──────────────────────────────────────────────────────────

  void _drawNotes() {
    if (remainingHeight < 40) newPage();

    final notesText =
        config.isRTL ? (data.notesAr ?? data.notes!) : data.notes!;
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';

    addLine(notesLabel, font: _cachedBoldFont, topMargin: 10);
    addLine(notesText, topMargin: 3);
  }

  // ──────────────────────────────────────────────────────────
  // Formatting Utilities
  // ──────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

}
