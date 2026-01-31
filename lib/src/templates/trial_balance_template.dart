import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridStyle, PdfBorderStyle, PdfTextStyle, PdfGridRow, PdfGridColumn;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';
import '../extensions/color_extensions.dart';

/// Account entry for trial balance.
class TrialBalanceEntry {
  const TrialBalanceEntry({
    required this.accountName,
    this.accountNameAr,
    this.accountCode,
    this.debit = 0,
    this.credit = 0,
    this.isCategory = false,
    this.categoryLevel = 0,
  });

  final String accountName;
  final String? accountNameAr;
  final String? accountCode;
  final double debit;
  final double credit;
  final bool isCategory;
  final int categoryLevel;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && accountNameAr != null) return accountNameAr!;
    return accountName;
  }
}

/// Trial balance category with entries.
class TrialBalanceCategory {
  const TrialBalanceCategory({
    required this.name,
    required this.entries,
    this.nameAr,
  });

  final String name;
  final String? nameAr;
  final List<TrialBalanceEntry> entries;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && nameAr != null) return nameAr!;
    return name;
  }

  double get totalDebit => entries.fold(0, (sum, e) => sum + e.debit);
  double get totalCredit => entries.fold(0, (sum, e) => sum + e.credit);
}

/// Trial balance report data.
class TrialBalanceData {
  const TrialBalanceData({
    required this.asOfDate,
    required this.categories,
    this.currency = 'SAR',
  });

  final DateTime asOfDate;
  final List<TrialBalanceCategory> categories;
  final String currency;

  List<TrialBalanceEntry> get allEntries =>
      categories.expand((c) => c.entries).toList();

  double get totalDebit => categories.fold(0, (sum, c) => sum + c.totalDebit);

  double get totalCredit => categories.fold(0, (sum, c) => sum + c.totalCredit);
}

/// A trial balance report template.
///
/// Creates a professional trial balance report with:
/// - Bilingual header (Arabic/English)
/// - Categorized account listings
/// - Debit and credit columns
/// - Category subtotals
/// - Grand total row
///
/// ## Example
/// ```dart
/// final report = TrialBalanceTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: trialBalanceData,
/// );
///
/// final bytes = report.generate();
/// ```
class TrialBalanceTemplate extends GeniusPdfDocumentBuilder {
  TrialBalanceTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showCategories = true,
    this.showCategorySubtotals = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final TrialBalanceData data;
  final PdfFont? boldFont;
  final bool showCategories;
  final bool showCategorySubtotals;

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

    // Trial balance table
    _drawTable();

    // Footer totals
    _drawTotals();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Trial Balance',
      titleAr: 'ميزان المراجعة',
      subtitle: 'As of ${_formatDateLong(data.asOfDate)}',
      subtitleAr: 'كما في ${_formatDateArabic(data.asOfDate)}',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.centered,
    );

    final height = header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 120),
    );

    addSpace(height + 15);
  }

  void _drawTable() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'account',
        title: 'Account Name',
        titleAr: 'اسم الحساب',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.currency(
        id: 'debit',
        title: 'Debit',
        titleAr: 'مدين',
        width: 100,
        currencySymbol: '',
      ),
      GeniusPdfGridColumn.currency(
        id: 'credit',
        title: 'Credit',
        titleAr: 'دائن',
        width: 100,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[];

    for (final category in data.categories) {
      // Add category header
      if (showCategories) {
        rows.add(GeniusPdfGridRow.groupHeader(
          category.getName(isArabic: config.isRTL),
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
        ));
      }

      // Add entries
      for (final entry in category.entries) {
        rows.add(GeniusPdfGridRow(cells: {
          'account': entry.getName(isArabic: config.isRTL),
          'debit': entry.debit > 0 ? entry.debit : null,
          'credit': entry.credit > 0 ? entry.credit : null,
        }));
      }

      // Add category subtotal
      if (showCategorySubtotals && category.entries.length > 1) {
        rows.add(GeniusPdfGridRow(
          cells: {
            'account': '',
            'debit': category.totalDebit,
            'credit': category.totalCredit,
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
        ));
      }
    }

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
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
      addSpace(result.bounds.height + 10);
    }
  }

  void _drawTotals() {
    // Grand total bar
    final totalBar = GeniusPdfTotalBar(
      label: 'Total',
      labelAr: 'الإجمالي',
      value:
          '${_formatNumber(data.totalDebit)} ${data.currency}    |    ${_formatNumber(data.totalCredit)} ${data.currency}',
      backgroundColor: const Color(0xFF424242),
      textColor: const Color(0xFFFFFFFF),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      fontSize: 11,
    );

    totalBar.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 35),
    );

    addSpace(50);

    // Page indicator (if multi-page)
    final pageText = config.isRTL
        ? 'صفحة ${document.pages.count} من ${document.pages.count}'
        : 'Page ${document.pages.count} of ${document.pages.count}';

    addTextAt(
      pageText,
      x: pageWidth - 100,
      y: pageHeight - 20,
      font: config.configAssets == null
          ? PdfStandardFont(PdfFontFamily.helvetica, 8)
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
              style: PdfFontStyle.regular),
      brush: PdfSolidBrush(const Color(0xFF757575).toPdfColor()),
    );
  }

  String _formatDateLong(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateArabic(DateTime date) {
    return '${date.day} ${_arabicMonth(date.month)} ${date.year}';
  }

  String _arabicMonth(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return months[month - 1];
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
