import 'dart:ui';
import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:intl/intl.dart';

import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

import 'erp_shared_template_layout.dart';
import '../src/families/erp/erp_families.dart';
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
class TrialBalanceTemplate extends GeniusErpRegisterDocument {
  TrialBalanceTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.showCategories = true,
    this.showCategorySubtotals = true,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final TrialBalanceData data;
  final bool showCategories;
  final bool showCategorySubtotals;

  /// Report ID for QR code URL
  final String? reportId;

  /// User who printed the report
  final String? printedBy;

  /// Whether to show QR code with report link
  final bool showQRCode;

  /// Whether to show signature areas
  final bool showSignatures;

  /// Whether to show notes section
  final bool showNotes;

  /// Custom notes to display
  final String? notes;
  final String? notesAr;

  @override
  void build() {
    // Add repeating footer with QR code and user info on all pages
    if (showQRCode || printedBy != null) {
      addFooter(
        userName: printedBy,
        printTime: _formatDate(DateTime.now()),
        showPageNumber: true,
      );
    }

    newPage();

    // Header
    _drawHeader();

    // Trial balance table
    _drawTable();

    // Footer totals
    _drawTotals();

    // Summary section
    _drawSummary();

    // Footer Section (Notes + QR Code)
    _drawFooterSection();

    // Signatures section
    if (showSignatures) {
      drawErpSignatureRow(
        signatures: const [
          GeniusErpTemplateSignatureSpec(
            title: 'Prepared By',
            titleAr: 'أعده',
          ),
          GeniusErpTemplateSignatureSpec(
            title: 'Reviewed By',
            titleAr: 'راجعه',
          ),
          GeniusErpTemplateSignatureSpec(
            title: 'Approved By',
            titleAr: 'اعتمده',
          ),
        ],
        itemWidth: 110,
        lineWidth: 100,
      );
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Trial Balance',
      titleAr: 'ميزان المراجعة',
      subtitle: config.isLTR ? 'As of ${_formatDateLong(data.asOfDate)}' : null,
      subtitleAr:
          !config.isLTR ? 'كما في ${_formatDateArabic(data.asOfDate)}' : null,
      company: company,
      config: config.copyWith(textDirection: m.TextDirection.ltr),
      style: const GeniusPdfReportHeaderStyle.classic(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
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
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      // Update current page and Y position from the grid result
      // This handles multi-page grids correctly in both RTL and LTR modes
      updateFromLayoutResult(result, spacing: 10);
    }
  }

  void _drawTotals() {
    // Grand total bar
    final totalBar = GeniusPdfTotalBar(
      config: config,
      label: 'Total',
      labelAr: 'الإجمالي',
      value:
          '${_formatNumber(data.totalDebit)} ${data.currency}    |    ${_formatNumber(data.totalCredit)} ${data.currency}',
      backgroundColor: const Color(0xFF424242),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 11,
    );

    totalBar.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 35),
    );

    addSpace(50);
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _drawSummary() {
    // Summary section with key metrics
    final summaryItems = <GeniusPdfSummaryItem>[
      GeniusPdfSummaryItem(
        label: 'Total Accounts',
        labelAr: 'إجمالي الحسابات',
        value: '${data.allEntries.length}',
      ),
      GeniusPdfSummaryItem(
        label: 'Categories',
        labelAr: 'التصنيفات',
        value: '${data.categories.length}',
      ),
      GeniusPdfSummaryItem.negative(
        label: 'Total Debit',
        labelAr: 'إجمالي المدين',
        value: '${_formatNumber(data.totalDebit)} ${data.currency}',
      ),
      GeniusPdfSummaryItem.positive(
        label: 'Total Credit',
        labelAr: 'إجمالي الدائن',
        value: '${_formatNumber(data.totalCredit)} ${data.currency}',
      ),
      if (data.totalDebit != data.totalCredit)
        GeniusPdfSummaryItem.total(
          label: 'Difference',
          labelAr: 'الفرق',
          value:
              '${_formatNumber(data.totalDebit - data.totalCredit)} ${data.currency}',
        ),
    ];

    final summary = GeniusPdfSummarySection(
      config: config,
      items: summaryItems,
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.45,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 120),
    );

    addSpace(result.height + 15);
  }

  void _drawFooterSection() {
    if (!showNotes && (!showQRCode || reportId == null)) {
      return;
    }

    addSpace(20);

    // If only one section is shown, draw it normally
    if (showNotes && (!showQRCode || reportId == null)) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && (showQRCode && reportId != null)) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    // Draw side-by-side if both are present
    // LTR: Notes (2/3) | QR (1/3)
    addTwoColumns(
      spacing: 10,
      leftFlex: config.isLTR ? 2 : 1,
      rightFlex: config.isLTR ? 1 : 2,
      leftContent: (page, bounds) {
        if (config.isLTR) {
          return _drawNotesContent(page, bounds);
        } else {
          return _drawQRCodeContent(page, bounds);
        }
      },
      rightContent: (page, bounds) {
        if (config.isLTR) {
          return _drawQRCodeContent(page, bounds);
        } else {
          return _drawNotesContent(page, bounds);
        }
      },
    );

    addSpace(20);
  }

  void _drawNotes({required double width}) {
    _drawNotesContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes = notes ?? (config.isRTL ? notesAr : notes);
    final defaultNotes = config.isRTL
        ? '''ملاحظات:
• ميزان المراجعة يعرض أرصدة جميع الحسابات كما في تاريخ التقرير
• يجب أن يتساوى إجمالي الجانب المدين مع إجمالي الجانب الدائن
• أي فرق يشير إلى وجود خطأ في القيود المحاسبية
• للاستفسارات، يرجى التواصل مع قسم المحاسبة'''
        : '''Notes:
• Trial Balance shows all account balances as of the report date
• Total Debit must equal Total Credit
• Any difference indicates errors in accounting entries
• For inquiries, contact the Accounting Department''';

    final notesText = displayNotes ?? defaultNotes;

    final font = config.baseFont;
    final element = PdfTextElement(
      text: notesText,
      font: font,
      format: config.isLTR
          ? null
          : PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right),
    );

    final result = element.draw(
      page: page,
      bounds: bounds,
    );

    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeSection({required double width}) {
    _drawQRCodeContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    if (reportId == null) return 0;

    final qrUrl = 'https://localhost:443/report/$reportId';
    final caption = 'ID: $reportId';

    final captionFont = config.baseFont;
    final captionLayout = PdfTextElement(
      text: caption,
      font: captionFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection
      ),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0));

    final captionHeight = captionLayout?.bounds.height ?? 0;
    const qrSize = 80.0; // Reduced size
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
  }


}
