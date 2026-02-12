import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridRow, PdfTextStyle, PdfGridColumn, PdfGridStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

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
class IncomeStatementTemplate extends GeniusPdfDocumentBuilder {
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

  /// Cached net income font (slightly larger, bold).
  late final PdfFont _cachedNetFont =
      config.fontBuild(fontSize: config.printTheme.typography.bodySize + 2);

  @override
  void build() {
    newPage();

    _drawHeader();

    // Revenue
    _drawSectionWithTotal(
      data.revenue,
      'Total Revenue',
      'إجمالي الإيرادات',
    );
    addSpace(10);

    // Cost of Sales
    _drawSectionWithTotal(
      data.costOfSales,
      'Total Cost of Sales',
      'إجمالي تكلفة المبيعات',
    );

    // Gross Profit
    _drawSubtotalLine('Gross Profit', 'إجمالي الربح', data.grossProfit);
    addSpace(10);

    // Operating Expenses
    _drawSectionWithTotal(
      data.operatingExpenses,
      'Total Operating Expenses',
      'إجمالي المصروفات التشغيلية',
    );

    // Operating Income
    _drawSubtotalLine(
        'Operating Income', 'الدخل التشغيلي', data.operatingIncome);
    addSpace(10);

    // Other Income
    if (data.otherIncome != null && data.otherIncome!.items.isNotEmpty) {
      _drawSectionWithTotal(
        data.otherIncome!,
        'Total Other Income',
        'إجمالي الإيرادات الأخرى',
      );
    }

    // Other Expenses
    if (data.otherExpenses != null && data.otherExpenses!.items.isNotEmpty) {
      _drawSectionWithTotal(
        data.otherExpenses!,
        'Total Other Expenses',
        'إجمالي المصروفات الأخرى',
      );
    }

    // Income Before Tax
    _drawSubtotalLine(
        'Income Before Tax', 'الدخل قبل الضريبة', data.incomeBeforeTax);

    // Tax Expense
    if (data.taxExpense != null) {
      _drawSimpleLine('Tax Expense', 'مصروف الضريبة', data.taxExpense!);
    }

    addSpace(10);

    // Net Income
    _drawNetIncome();

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

  void _drawSectionWithTotal(
    IncomeStatementSection section,
    String totalLabel,
    String totalLabelAr,
  ) {
    // Section title
    final titleText =
        config.isRTL ? (section.titleAr ?? section.title) : section.title;

    addLine(titleText, font: _cachedBoldFont, topMargin: 5);

    // Section items
    final rows = <GeniusPdfGridRow>[];
    for (final item in section.items) {
      final indent = '  ' * item.level;
      final accountName = config.isRTL
          ? (item.accountNameAr ?? item.accountName)
          : item.accountName;

      rows.add(GeniusPdfGridRow(
        cells: {
          'code': item.accountCode,
          'account': '$indent$accountName',
          'amount': item.amount,
        },
        isTotal: item.isSubtotal,
      ));
    }

    // Section total row
    rows.add(GeniusPdfGridRow(
      cells: {
        'code': '',
        'account': config.isRTL ? totalLabelAr : totalLabel,
        'amount': section.total,
      },
      isHeader: true,
    ));

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
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
      ],
      rows: rows,
      style: const GeniusPdfGridStyle(showHeader: false),
    );

    // Use drawAt + updateFromLayoutResult for multi-page safety.
    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      updateFromLayoutResult(result, spacing: 5);
    }
  }

  // ──────────────────────────────────────────────────────────
  // Subtotal Line (highlighted background)
  // ──────────────────────────────────────────────────────────

  void _drawSubtotalLine(String label, String labelAr, double amount) {
    // Ensure space before drawing.
    const lineHeight = 22.0;
    if (remainingHeight < lineHeight + 6) newPage();

    final displayLabel = config.isRTL ? labelAr : label;
    final isProfit = amount >= 0;
    final color = isProfit ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);

    final page = currentPage;
    final labelX = config.isRTL ? pageWidth * 0.4 : 10.0;
    final labelW = pageWidth * 0.6 - 10;
    final amountX = config.isRTL ? 10.0 : pageWidth * 0.6;
    final amountW = pageWidth * 0.4 - 10;

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(240, 240, 240)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, lineHeight),
    );

    page.graphics.drawString(
      displayLabel,
      _cachedBoldFont,
      bounds: Rect.fromLTWH(labelX, currentY + 4, labelW, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    page.graphics.drawString(
      _formatCurrency(amount),
      _cachedBoldFont,
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(amountX, currentY + 4, amountW, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(lineHeight + 6);
  }

  // ──────────────────────────────────────────────────────────
  // Simple Line (indented, for deductions like tax)
  // ──────────────────────────────────────────────────────────

  void _drawSimpleLine(String label, String labelAr, double amount) {
    if (remainingHeight < 22) newPage();

    final displayLabel = config.isRTL ? labelAr : label;
    final page = currentPage;

    final labelX = config.isRTL ? pageWidth * 0.4 : 20.0;
    final labelW = pageWidth * 0.6 - 20;
    final amountX = config.isRTL ? 10.0 : pageWidth * 0.6;
    final amountW = pageWidth * 0.4 - 10;

    page.graphics.drawString(
      displayLabel,
      baseFont,
      bounds: Rect.fromLTWH(labelX, currentY, labelW, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    page.graphics.drawString(
      '(${_formatCurrency(amount)})',
      baseFont,
      bounds: Rect.fromLTWH(amountX, currentY, amountW, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(22);
  }

  // ──────────────────────────────────────────────────────────
  // Net Income (highlighted box)
  // ──────────────────────────────────────────────────────────

  void _drawNetIncome() {
    const boxHeight = 30.0;
    if (remainingHeight < boxHeight + 10) newPage();

    final label = config.isRTL ? 'صافي الدخل' : 'Net Income';
    final isProfit = data.netIncome >= 0;
    final bgColor =
        isProfit ? PdfColor(200, 255, 200) : PdfColor(255, 200, 200);
    final textColor = isProfit ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);

    final page = currentPage;
    final labelX = config.isRTL ? pageWidth * 0.4 : 10.0;
    final labelW = pageWidth * 0.6 - 10;
    final amountX = config.isRTL ? 10.0 : pageWidth * 0.6;
    final amountW = pageWidth * 0.4 - 10;

    page.graphics.drawRectangle(
      brush: PdfSolidBrush(bgColor),
      pen: PdfPen(PdfColor(100, 100, 100)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, boxHeight),
    );

    page.graphics.drawString(
      label,
      _cachedNetFont,
      bounds: Rect.fromLTWH(labelX, currentY + 7, labelW, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    page.graphics.drawString(
      _formatCurrency(data.netIncome),
      _cachedNetFont,
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(amountX, currentY + 7, amountW, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(boxHeight + 10);
  }

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

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    final value = '$formatted ${data.currency}';
    return isNegative ? '($value)' : value;
  }
}
