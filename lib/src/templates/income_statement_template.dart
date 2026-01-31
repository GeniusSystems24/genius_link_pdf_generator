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

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    newPage();

    // Header
    _drawHeader();

    // Revenue section
    _drawSectionWithTotal(
      data.revenue,
      'Total Revenue',
      'إجمالي الإيرادات',
    );

    addSpace(10);

    // Cost of Sales section
    _drawSectionWithTotal(
      data.costOfSales,
      'Total Cost of Sales',
      'إجمالي تكلفة المبيعات',
    );

    // Gross Profit
    _drawSubtotalLine('Gross Profit', 'إجمالي الربح', data.grossProfit);

    addSpace(10);

    // Operating Expenses section
    _drawSectionWithTotal(
      data.operatingExpenses,
      'Total Operating Expenses',
      'إجمالي المصروفات التشغيلية',
    );

    // Operating Income
    _drawSubtotalLine(
        'Operating Income', 'الدخل التشغيلي', data.operatingIncome);

    addSpace(10);

    // Other Income (if any)
    if (data.otherIncome != null && data.otherIncome!.items.isNotEmpty) {
      _drawSectionWithTotal(
        data.otherIncome!,
        'Total Other Income',
        'إجمالي الإيرادات الأخرى',
      );
    }

    // Other Expenses (if any)
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
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(110);
  }

  void _drawSectionWithTotal(
    IncomeStatementSection section,
    String totalLabel,
    String totalLabelAr,
  ) {
    // Section title
    final titleText =
        config.isRTL ? (section.titleAr ?? section.title) : section.title;

    currentPage.graphics.drawString(
      titleText,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(25);

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

    // Section total
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
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 5);
    }
  }

  void _drawSubtotalLine(String label, String labelAr, double amount) {
    final displayLabel = config.isRTL ? labelAr : label;
    final isProfit = amount >= 0;
    final color = isProfit ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(240, 240, 240)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 22),
    );

    currentPage.graphics.drawString(
      displayLabel,
      _boldFont,
      bounds: Rect.fromLTWH(10, currentY + 4, pageWidth * 0.6, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(amount),
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold),
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(
          pageWidth * 0.6, currentY + 4, pageWidth * 0.4 - 10, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
      ),
    );

    addSpace(28);
  }

  void _drawSimpleLine(String label, String labelAr, double amount) {
    final displayLabel = config.isRTL ? labelAr : label;

    currentPage.graphics.drawString(
      displayLabel,
      baseFont,
      bounds: Rect.fromLTWH(20, currentY, pageWidth * 0.6, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      '(${_formatCurrency(amount)})',
      baseFont,
      bounds:
          Rect.fromLTWH(pageWidth * 0.6, currentY, pageWidth * 0.4 - 10, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
      ),
    );

    addSpace(22);
  }

  void _drawNetIncome() {
    final label = config.isRTL ? 'صافي الدخل' : 'Net Income';
    final isProfit = data.netIncome >= 0;
    final bgColor =
        isProfit ? PdfColor(200, 255, 200) : PdfColor(255, 200, 200);
    final textColor = isProfit ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(bgColor),
      pen: PdfPen(PdfColor(100, 100, 100)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 30),
    );

    currentPage.graphics.drawString(
      label,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 12,
              style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(10, currentY + 7, pageWidth * 0.6, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(data.netIncome),
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 12,
              style: PdfFontStyle.bold),
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(
          pageWidth * 0.6, currentY + 7, pageWidth * 0.4 - 10, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
      ),
    );

    addSpace(40);
  }

  void _drawProfitabilityRatios() {
    final title = config.isRTL ? 'مؤشرات الربحية' : 'Profitability Ratios';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(25);

    final ratios = [
      (
        config.isRTL ? 'هامش الربح الإجمالي' : 'Gross Profit Margin',
        data.grossProfitMargin
      ),
      (
        config.isRTL ? 'هامش صافي الربح' : 'Net Profit Margin',
        data.netProfitMargin
      ),
    ];

    for (final ratio in ratios) {
      currentPage.graphics.drawString(
        '${ratio.$1}: ${ratio.$2.toStringAsFixed(2)}%',
        baseFont,
        bounds: Rect.fromLTWH(20, currentY, pageWidth - 20, 18),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        ),
      );
      addSpace(18);
    }

    addSpace(10);
  }

  void _drawNotes() {
    final notesText =
        config.isRTL ? (data.notesAr ?? data.notes!) : data.notes!;
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';

    currentPage.graphics.drawString(
      '$notesLabel\n$notesText',
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 60),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(65);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${data.currency}';
  }
}
