import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridRow, PdfGridColumn, PdfGridStyle, PdfTextStyle;

import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

import '../src/families/erp/erp_families.dart';
/// Balance sheet account item.
class BalanceSheetItem {
  const BalanceSheetItem({
    required this.accountCode,
    required this.accountName,
    required this.amount,
    this.accountNameAr,
    this.subItems = const [],
    this.isSubtotal = false,
    this.level = 0,
  });

  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final double amount;
  final List<BalanceSheetItem> subItems;
  final bool isSubtotal;
  final int level;

  double get totalAmount {
    if (subItems.isEmpty) return amount;
    return subItems.fold(0.0, (sum, item) => sum + item.totalAmount);
  }
}

/// Balance sheet section (Assets, Liabilities, Equity).
class BalanceSheetSection {
  const BalanceSheetSection({
    required this.title,
    required this.items,
    this.titleAr,
  });

  final String title;
  final String? titleAr;
  final List<BalanceSheetItem> items;

  double get total => items.fold(0.0, (sum, item) => sum + item.totalAmount);
}

/// Balance sheet data model.
class BalanceSheetData {
  const BalanceSheetData({
    required this.reportDate,
    required this.assets,
    required this.liabilities,
    required this.equity,
    this.comparativePeriod,
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
  });

  final DateTime reportDate;
  final BalanceSheetSection assets;
  final BalanceSheetSection liabilities;
  final BalanceSheetSection equity;
  final DateTime? comparativePeriod;
  final String currency;
  final String? notes;
  final String? notesAr;

  double get totalAssets => assets.total;
  double get totalLiabilities => liabilities.total;
  double get totalEquity => equity.total;
  double get totalLiabilitiesAndEquity => totalLiabilities + totalEquity;

  bool get isBalanced => (totalAssets - totalLiabilitiesAndEquity).abs() < 0.01;
}

/// A professional balance sheet template.
///
/// Creates a standard balance sheet report showing assets,
/// liabilities, and equity with proper formatting.
///
/// ## Example
/// ```dart
/// final balanceSheet = BalanceSheetTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: balanceSheetData,
/// );
///
/// final bytes = balanceSheet.generate();
/// ```
class BalanceSheetTemplate extends GeniusErpAnalyticalReport {
  BalanceSheetTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showComparative = false,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final BalanceSheetData data;
  final PdfFont? boldFont;
  final bool showComparative;

  @override
  void build() {
    newPage();

    // Header
    _drawHeader();

    // Balance sheet grid
    _drawBalanceSheetGrid();

    addSpace(15);
    // Total Liabilities & Equity
    _drawGrandTotal();

    // Balance check
    _drawBalanceCheck();

    // Notes
    if (data.notes != null || data.notesAr != null) {
      _drawNotes();
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Balance Sheet',
      titleAr: 'الميزانية العمومية',
      subtitle: 'As of ${_formatDate(data.reportDate)}',
      subtitleAr: 'كما في ${_formatDate(data.reportDate)}',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(110);
  }

  void _drawBalanceSheetGrid() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'code',
        title: 'Code',
        titleAr: 'الكود',
        width: 80,
      ),
      const GeniusPdfGridColumn(
        id: 'account',
        title: 'Account',
        titleAr: 'الحساب',
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
      section: data.assets,
      totalLabel: 'Total Assets',
      totalLabelAr: 'إجمالي الأصول',
    );
    _appendSectionRows(
      rows: rows,
      section: data.liabilities,
      totalLabel: 'Total Liabilities',
      totalLabelAr: 'إجمالي الالتزامات',
    );
    _appendSectionRows(
      rows: rows,
      section: data.equity,
      totalLabel: 'Total Equity',
      totalLabelAr: 'إجمالي حقوق الملكية',
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
      // Keep the current page/Y synchronized with multi-page Grid output,
      // matching the approach used by TrialBalanceTemplate.
      updateFromLayoutResult(result, spacing: 10);
    }
  }

  void _appendSectionRows({
    required List<GeniusPdfGridRow> rows,
    required BalanceSheetSection section,
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
      _addItemRows(rows, item);
    }

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'code': '',
          'account': config.isRTL ? totalLabelAr : totalLabel,
          'amount': section.total,
        },
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color(0xFFF5F5F5),
          border: GeniusPdfBorderStyle.horizontal(),
          padding: GeniusPdfCellPadding.all(4),
        ),
      ),
    );
  }

  void _addItemRows(List<GeniusPdfGridRow> rows, BalanceSheetItem item) {
    final indent = '  ' * item.level;
    final accountName = config.isRTL
        ? (item.accountNameAr ?? item.accountName)
        : item.accountName;

    rows.add(GeniusPdfGridRow(
      cells: {
        'code': item.accountCode,
        'account': '$indent$accountName',
        'amount': item.totalAmount,
      },
      isTotal: item.isSubtotal,
    ));

    for (final subItem in item.subItems) {
      _addItemRows(rows, subItem);
    }
  }

  void _drawGrandTotal() {
    final totalLabel = config.isRTL
        ? 'إجمالي الالتزامات وحقوق الملكية'
        : 'Total Liabilities & Equity';

    final summaryItems = [
      GeniusPdfSummaryItem.total(
        label: totalLabel,
        value: _formatCurrency(data.totalLiabilitiesAndEquity),
      ),
    ];

    final summary = GeniusPdfSummarySection(
      config: config,
      items: summaryItems,
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.5,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 50),
    );

    addSpace(result.height + 10);
  }

  void _drawBalanceCheck() {
    final isBalanced = data.isBalanced;
    final difference = data.totalAssets - data.totalLiabilitiesAndEquity;

    final bgColor = isBalanced
        ? PdfColor(220, 252, 231)
        : PdfColor(254, 226, 226);
    final borderColor = isBalanced
        ? PdfColor(34, 197, 94)
        : PdfColor(239, 68, 68);
    final textColor = isBalanced
        ? PdfColor(21, 128, 61)
        : PdfColor(185, 28, 28);

    final boxHeight = isBalanced ? 30.0 : 45.0;

    // Background box
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(bgColor),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, boxHeight),
    );

    // Left border accent
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(borderColor),
      bounds: Rect.fromLTWH(
          config.isRTL ? pageWidth - 4 : 0, currentY, 4, boxHeight),
    );

    final message = isBalanced
        ? (config.isRTL ? '✓ الميزانية متوازنة' : '✓ Balance Sheet is Balanced')
        : (config.isRTL
            ? '✗ الميزانية غير متوازنة'
            : '✗ Balance Sheet is NOT Balanced');

    final font = config.configAssets == null
        ? config.baseFont
        : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
            style: PdfFontStyle.bold);

    currentPage.graphics.drawString(
      message,
      font,
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(12, currentY + 7, pageWidth - 24, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    // Show difference when not balanced
    if (!isBalanced) {
      final diffLabel = config.isRTL
          ? 'الفرق: ${_formatCurrency(difference.abs())}'
          : 'Difference: ${_formatCurrency(difference.abs())}';

      currentPage.graphics.drawString(
        diffLabel,
        baseFont,
        brush: PdfSolidBrush(textColor),
        bounds: Rect.fromLTWH(12, currentY + 25, pageWidth - 24, 16),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: config.pdfTextDirection
        ),
      );
    }

    addSpace(boxHeight + 10);
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

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${data.currency}';
  }
}
