import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

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
class BudgetReportTemplate extends GeniusPdfDocumentBuilder {
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

    // Column headers
    _drawColumnHeaders();

    // Sections
    for (final section in data.sections) {
      _drawSection(section);
    }

    // Grand total
    _drawGrandTotal();

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
      title: title,
      subtitle: 'Period: $periodText',
      subtitleAr: 'الفترة: $periodText',
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

  void _drawColumnHeaders() {
    final columns = [
      (config.isRTL ? 'البند' : 'Category', 0.35),
      (config.isRTL ? 'الميزانية' : 'Budget', 0.18),
      (config.isRTL ? 'الفعلي' : 'Actual', 0.18),
      (config.isRTL ? 'الفرق' : 'Variance', 0.15),
      if (showVariancePercent) ('%', 0.14),
    ];

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(60, 60, 100)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 24),
    );

    double xOffset = 0;
    for (final column in columns) {
      currentPage.graphics.drawString(
        column.$1,
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
                style: PdfFontStyle.bold),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(
            xOffset + 5, currentY + 5, pageWidth * column.$2 - 10, 18),
        format: PdfStringFormat(
          alignment: xOffset == 0
              ? (config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left)
              : PdfTextAlignment.right,
        ),
      );
      xOffset += pageWidth * column.$2;
    }

    addSpace(28);
  }

  void _drawSection(BudgetSection section) {
    // Section title
    final titleText =
        config.isRTL ? (section.titleAr ?? section.title) : section.title;

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(220, 220, 240)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 22),
    );

    currentPage.graphics.drawString(
      titleText,
      _boldFont,
      bounds: Rect.fromLTWH(5, currentY + 4, pageWidth - 10, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(26);

    // Section items
    for (final item in section.items) {
      _drawBudgetItem(item);
    }

    // Section total
    _drawSectionTotal(section);

    addSpace(10);
  }

  void _drawBudgetItem(BudgetItem item) {
    final indent = '  ' * item.level;
    final category =
        config.isRTL ? (item.categoryAr ?? item.category) : item.category;

    // Determine row color based on variance
    PdfBrush? rowBrush;
    if (highlightVariances) {
      if (item.isOverBudget) {
        rowBrush = PdfSolidBrush(PdfColor(255, 235, 235));
      } else if (item.isUnderBudget &&
          item.variance.abs() > item.budgetedAmount * 0.1) {
        rowBrush = PdfSolidBrush(PdfColor(235, 255, 235));
      }
    }

    if (rowBrush != null) {
      currentPage.graphics.drawRectangle(
        brush: rowBrush,
        bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      );
    }

    final font = baseFont ?? PdfStandardFont(PdfFontFamily.helvetica, 9);

    // Category
    currentPage.graphics.drawString(
      '$indent$category',
      font,
      bounds: Rect.fromLTWH(5, currentY + 2, pageWidth * 0.35 - 10, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    // Budget
    currentPage.graphics.drawString(
      _formatNumber(item.budgetedAmount),
      font,
      bounds: Rect.fromLTWH(
          pageWidth * 0.35, currentY + 2, pageWidth * 0.18 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Actual
    currentPage.graphics.drawString(
      _formatNumber(item.actualAmount),
      font,
      bounds: Rect.fromLTWH(
          pageWidth * 0.53, currentY + 2, pageWidth * 0.18 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Variance
    final varianceColor =
        item.variance >= 0 ? PdfColor(0, 120, 0) : PdfColor(180, 0, 0);
    final varianceText = item.variance >= 0
        ? _formatNumber(item.variance)
        : '(${_formatNumber(item.variance.abs())})';

    currentPage.graphics.drawString(
      varianceText,
      font,
      brush: PdfSolidBrush(varianceColor),
      bounds: Rect.fromLTWH(
          pageWidth * 0.71, currentY + 2, pageWidth * 0.15 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    // Variance %
    if (showVariancePercent) {
      currentPage.graphics.drawString(
        '${item.variancePercent.toStringAsFixed(1)}%',
        font,
        brush: PdfSolidBrush(varianceColor),
        bounds: Rect.fromLTWH(
            pageWidth * 0.86, currentY + 2, pageWidth * 0.14 - 5, 16),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    addSpace(20);

    // Sub-items
    for (final subItem in item.subItems) {
      _drawBudgetItem(subItem);
    }
  }

  void _drawSectionTotal(BudgetSection section) {
    final totalLabel = config.isRTL
        ? 'إجمالي ${section.titleAr ?? section.title}'
        : 'Total ${section.title}';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(200, 200, 220)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 20),
    );

    currentPage.graphics.drawString(
      totalLabel,
      _boldFont,
      bounds: Rect.fromLTWH(5, currentY + 3, pageWidth * 0.35 - 10, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatNumber(section.totalBudgeted),
      _boldFont,
      bounds: Rect.fromLTWH(
          pageWidth * 0.35, currentY + 3, pageWidth * 0.18 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    currentPage.graphics.drawString(
      _formatNumber(section.totalActual),
      _boldFont,
      bounds: Rect.fromLTWH(
          pageWidth * 0.53, currentY + 3, pageWidth * 0.18 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    final varianceColor =
        section.totalVariance >= 0 ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);
    final varianceText = section.totalVariance >= 0
        ? _formatNumber(section.totalVariance)
        : '(${_formatNumber(section.totalVariance.abs())})';

    currentPage.graphics.drawString(
      varianceText,
      _boldFont,
      brush: PdfSolidBrush(varianceColor),
      bounds: Rect.fromLTWH(
          pageWidth * 0.71, currentY + 3, pageWidth * 0.15 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    if (showVariancePercent) {
      currentPage.graphics.drawString(
        '${section.variancePercent.toStringAsFixed(1)}%',
        _boldFont,
        brush: PdfSolidBrush(varianceColor),
        bounds: Rect.fromLTWH(
            pageWidth * 0.86, currentY + 3, pageWidth * 0.14 - 5, 16),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    addSpace(24);
  }

  void _drawGrandTotal() {
    final totalLabel = config.isRTL ? 'الإجمالي الكلي' : 'Grand Total';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(60, 60, 100)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 26),
    );

    currentPage.graphics.drawString(
      totalLabel,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(5, currentY + 5, pageWidth * 0.35 - 10, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatNumber(data.totalBudgeted),
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(
          pageWidth * 0.35, currentY + 5, pageWidth * 0.18 - 5, 18),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    currentPage.graphics.drawString(
      _formatNumber(data.totalActual),
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(
          pageWidth * 0.53, currentY + 5, pageWidth * 0.18 - 5, 18),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    final varianceText = data.totalVariance >= 0
        ? _formatNumber(data.totalVariance)
        : '(${_formatNumber(data.totalVariance.abs())})';

    currentPage.graphics.drawString(
      varianceText,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(
          pageWidth * 0.71, currentY + 5, pageWidth * 0.15 - 5, 18),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    if (showVariancePercent) {
      currentPage.graphics.drawString(
        '${data.overallVariancePercent.toStringAsFixed(1)}%',
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
                style: PdfFontStyle.bold),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(
            pageWidth * 0.86, currentY + 5, pageWidth * 0.14 - 5, 18),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
      );
    }

    addSpace(35);
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
        baseFont ?? PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: Rect.fromLTWH(10, currentY, pageWidth - 10, 18),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
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
      baseFont ?? PdfStandardFont(PdfFontFamily.helvetica, 9),
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
