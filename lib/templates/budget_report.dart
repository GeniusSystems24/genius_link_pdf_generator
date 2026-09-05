import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfTextStyle;

import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

import '../src/families/erp/erp_families.dart';
/// Budget line item with actual vs budgeted comparison.
class BudgetItem {
  const BudgetItem({
    required this.category,
    required this.budgetedAmount,
    required this.actualAmount,
    this.categoryAr,
    this.subItems = const [],
    this.level = 0,
  });

  final String category;
  final String? categoryAr;
  final double budgetedAmount;
  final double actualAmount;
  final List<BudgetItem> subItems;
  final int level;

  double get variance => actualAmount - budgetedAmount;
  double get variancePercent =>
      budgetedAmount != 0 ? (variance / budgetedAmount) * 100 : 0;
  bool get isOverBudget => actualAmount > budgetedAmount;
  bool get isUnderBudget => actualAmount < budgetedAmount;

  double get totalBudgeted {
    if (subItems.isEmpty) return budgetedAmount;
    return subItems.fold(0.0, (sum, item) => sum + item.totalBudgeted);
  }

  double get totalActual {
    if (subItems.isEmpty) return actualAmount;
    return subItems.fold(0.0, (sum, item) => sum + item.totalActual);
  }
}

/// Budget section (Income, Expenses, etc.).
class BudgetSection {
  const BudgetSection({
    required this.title,
    required this.items,
    this.titleAr,
    this.isExpense = false,
  });

  final String title;
  final String? titleAr;
  final List<BudgetItem> items;
  final bool isExpense;

  double get totalBudgeted =>
      items.fold(0.0, (sum, item) => sum + item.totalBudgeted);
  double get totalActual =>
      items.fold(0.0, (sum, item) => sum + item.totalActual);
  double get totalVariance => totalActual - totalBudgeted;
  double get variancePercent =>
      totalBudgeted != 0 ? (totalVariance / totalBudgeted) * 100 : 0;
}

/// Budget report data model.
class BudgetReportData {
  const BudgetReportData({
    required this.reportTitle,
    required this.periodStart,
    required this.periodEnd,
    required this.sections,
    this.reportTitleAr,
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
  });

  final String reportTitle;
  final String? reportTitleAr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<BudgetSection> sections;
  final String currency;
  final String? notes;
  final String? notesAr;

  double get totalBudgeted =>
      sections.fold(0.0, (sum, section) => sum + section.totalBudgeted);
  double get totalActual =>
      sections.fold(0.0, (sum, section) => sum + section.totalActual);
  double get totalVariance => totalActual - totalBudgeted;
  double get overallVariancePercent =>
      totalBudgeted != 0 ? (totalVariance / totalBudgeted) * 100 : 0;
}

/// A professional budget report template.
///
/// Creates a comprehensive budget vs actual comparison report
/// with variance analysis.
///
/// ## Example
/// ```dart
/// final budgetReport = BudgetReportTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: budgetData,
/// );
///
/// final bytes = budgetReport.generate();
/// ```
class BudgetReportTemplate extends GeniusErpAnalyticalReport {
  BudgetReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showVariancePercent = true,
    this.highlightVariances = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final BudgetReportData data;
  final PdfFont? boldFont;
  final bool showVariancePercent;
  final bool highlightVariances;

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

    // Budget comparison grid
    _drawBudgetGrid();

    addSpace(20);

    // Variance summary
    _drawVarianceSummary();

    // Notes
    if (data.notes != null || data.notesAr != null) {
      _drawNotes();
    }
  }

  void _drawHeader() {
    final periodText =
        '${_formatDate(data.periodStart)} - ${_formatDate(data.periodEnd)}';
    final title = config.isRTL
        ? (data.reportTitleAr ?? data.reportTitle)
        : data.reportTitle;

    final header = GeniusPdfReportHeader(
      config: config,
      title: title,
      subtitle: 'Period: $periodText',
      subtitleAr: 'الفترة: $periodText',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(110);
  }

  void _drawBudgetGrid() {
    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'category',
        title: 'Category',
        titleAr: 'البند',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.numeric(
        id: 'budget',
        title: 'Budget',
        titleAr: 'الميزانية',
        width: 92,
        alignment: GeniusPdfTextAlign.end,
        valueFormatter: (value) => _formatSignedNumber(value as num?),
      ),
      GeniusPdfGridColumn.numeric(
        id: 'actual',
        title: 'Actual',
        titleAr: 'الفعلي',
        width: 92,
        alignment: GeniusPdfTextAlign.end,
        valueFormatter: (value) => _formatSignedNumber(value as num?),
      ),
      GeniusPdfGridColumn.numeric(
        id: 'variance',
        title: 'Variance',
        titleAr: 'الفرق',
        width: 92,
        alignment: GeniusPdfTextAlign.end,
        valueFormatter: (value) => _formatSignedNumber(value as num?),
      ),
      if (showVariancePercent)
        GeniusPdfGridColumn.numeric(
          id: 'variancePercent',
          title: 'Variance %',
          titleAr: 'نسبة الفرق',
          width: 72,
          alignment: GeniusPdfTextAlign.end,
          valueFormatter: (value) {
            if (value == null) return '';
            return '${(value as num).toDouble().toStringAsFixed(1)}%';
          },
        ),
    ];

    final rows = <GeniusPdfGridRow>[];

    for (final section in data.sections) {
      _appendBudgetSectionRows(rows, section);
    }

    // Do not infer favorable/unfavorable from the cross-section grand total.
    // Income and expense sections have opposite variance semantics, so the
    // aggregate is intentionally styled as a neutral report total.
    rows.add(
      GeniusPdfGridRow.total(
        {
          'category': config.isRTL ? 'الإجمالي الكلي' : 'Grand Total',
          'budget': data.totalBudgeted,
          'actual': data.totalActual,
          'variance': data.totalVariance,
          if (showVariancePercent)
            'variancePercent': data.overallVariancePercent,
        },
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
          backgroundColor: Color(0xFF334155),
          border: GeniusPdfBorderStyle.all(color: Color(0xFF1E293B)),
          padding: GeniusPdfCellPadding.all(6),
        ),
      ),
    );

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
      updateFromLayoutResult(result, spacing: 10);
    }
  }

  void _appendBudgetSectionRows(
    List<GeniusPdfGridRow> rows,
    BudgetSection section,
  ) {
    final title =
        config.isRTL ? (section.titleAr ?? section.title) : section.title;

    rows.add(
      GeniusPdfGridRow.groupHeader(
        title,
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
          backgroundColor: Color(0xFFF1F5F9),
          border: GeniusPdfBorderStyle.all(color: Color(0xFFCBD5E1)),
          padding: GeniusPdfCellPadding.all(5),
        ),
      ),
    );

    for (final item in section.items) {
      _appendBudgetItemRows(rows, item, section: section);
    }

    final totalLabel = config.isRTL
        ? 'إجمالي ${section.titleAr ?? section.title}'
        : 'Total ${section.title}';

    rows.add(
      GeniusPdfGridRow.total(
        {
          'category': totalLabel,
          'budget': section.totalBudgeted,
          'actual': section.totalActual,
          'variance': section.totalVariance,
          if (showVariancePercent)
            'variancePercent': section.variancePercent,
        },
        style: _budgetVarianceStyle(
          variance: section.totalVariance,
          budgeted: section.totalBudgeted,
          isExpense: section.isExpense,
          emphasized: true,
          forceColor: true,
        ),
      ),
    );
  }

  void _appendBudgetItemRows(
    List<GeniusPdfGridRow> rows,
    BudgetItem item, {
    required BudgetSection section,
  }) {
    final category =
        config.isRTL ? (item.categoryAr ?? item.category) : item.category;
    final indent = '  ' * item.level;
    final hasChildren = item.subItems.isNotEmpty;

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'category': '$indent$category',
          'budget': item.budgetedAmount,
          'actual': item.actualAmount,
          'variance': item.variance,
          if (showVariancePercent) 'variancePercent': item.variancePercent,
        },
        style: _budgetVarianceStyle(
          variance: item.variance,
          budgeted: item.budgetedAmount,
          isExpense: section.isExpense,
          emphasized: hasChildren,
          forceColor: false,
        ),
        keepTogether: true,
      ),
    );

    for (final subItem in item.subItems) {
      _appendBudgetItemRows(rows, subItem, section: section);
    }
  }

  GeniusPdfCellStyle _budgetVarianceStyle({
    required double variance,
    required double budgeted,
    required bool isExpense,
    required bool emphasized,
    required bool forceColor,
  }) {
    final isZero = variance.abs() < 0.005;
    final material = budgeted.abs() < 0.005
        ? !isZero
        : (variance.abs() / budgeted.abs()) >= 0.10;
    final shouldColor = highlightVariances && (forceColor || material);

    if (isZero || !shouldColor) {
      return GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF475569),
        ),
        backgroundColor: emphasized ? const Color(0xFFF8FAFC) : null,
        border: const GeniusPdfBorderStyle.horizontal(
          color: Color(0xFFE2E8F0),
        ),
        padding: const GeniusPdfCellPadding.all(4),
      );
    }

    // Expense: spending less than budget is favorable.
    // Income/non-expense: actual above budget is favorable.
    final favorable = isExpense ? variance < 0 : variance > 0;

    return GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
        color: favorable
            ? const Color(0xFF166534)
            : const Color(0xFF991B1B),
      ),
      backgroundColor: favorable
          ? (emphasized
              ? const Color(0xFFDCFCE7)
              : const Color(0xFFF0FDF4))
          : (emphasized
              ? const Color(0xFFFEE2E2)
              : const Color(0xFFFEF2F2)),
      border: GeniusPdfBorderStyle.horizontal(
        color: favorable
            ? const Color(0xFFBBF7D0)
            : const Color(0xFFFECACA),
      ),
      padding: const GeniusPdfCellPadding.all(4),
    );
  }

  String _formatSignedNumber(num? value) {
    if (value == null) return '';
    final amount = value.toDouble();
    if (amount < 0) {
      return '(${_formatNumber(amount.abs())})';
    }
    return _formatNumber(amount);
  }

  void _drawVarianceSummary() {
    final title = config.isRTL ? 'ملخص الفروقات' : 'Variance Summary';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(25);

    // Summary items
    final summaryItems = [
      (
        config.isRTL ? 'إجمالي الميزانية' : 'Total Budget',
        _formatCurrency(data.totalBudgeted),
      ),
      (
        config.isRTL ? 'إجمالي الفعلي' : 'Total Actual',
        _formatCurrency(data.totalActual),
      ),
      (
        config.isRTL ? 'صافي الفرق' : 'Net Variance',
        data.totalVariance >= 0
            ? _formatCurrency(data.totalVariance)
            : '(${_formatCurrency(data.totalVariance.abs())})',
      ),
      (
        config.isRTL ? 'نسبة الفرق' : 'Variance %',
        '${data.overallVariancePercent.toStringAsFixed(2)}%',
      ),
    ];

    for (final item in summaryItems) {
      currentPage.graphics.drawString(
        '• ${item.$1}: ${item.$2}',
        baseFont,
        bounds: Rect.fromLTWH(10, currentY, pageWidth - 10, 18),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: config.pdfTextDirection
        ),
      );
      addSpace(20);
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
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(65);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatNumber(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${data.currency}';
  }
}
