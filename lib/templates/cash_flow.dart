import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfTextStyle;

import '../src/presentation/document/components/components.dart';
import '../src/core/pdf_config.dart';

import '../src/presentation/document/families/erp/erp_families.dart';
/// Cash flow activity type.
enum CashFlowActivityType {
  operating,
  investing,
  financing,
}

/// Cash flow line item.
class CashFlowItem {
  const CashFlowItem({
    required this.description,
    required this.amount,
    this.descriptionAr,
    this.isSubtotal = false,
    this.level = 0,
  });

  final String description;
  final String? descriptionAr;
  final double amount;
  final bool isSubtotal;
  final int level;
}

/// Cash flow activity section.
class CashFlowSection {
  const CashFlowSection({
    required this.type,
    required this.title,
    required this.items,
    this.titleAr,
  });

  final CashFlowActivityType type;
  final String title;
  final String? titleAr;
  final List<CashFlowItem> items;

  double get netCashFlow => items.fold(0.0, (sum, item) => sum + item.amount);

  String get defaultTitle {
    switch (type) {
      case CashFlowActivityType.operating:
        return 'Cash Flows from Operating Activities';
      case CashFlowActivityType.investing:
        return 'Cash Flows from Investing Activities';
      case CashFlowActivityType.financing:
        return 'Cash Flows from Financing Activities';
    }
  }

  String get defaultTitleAr {
    switch (type) {
      case CashFlowActivityType.operating:
        return 'التدفقات النقدية من الأنشطة التشغيلية';
      case CashFlowActivityType.investing:
        return 'التدفقات النقدية من الأنشطة الاستثمارية';
      case CashFlowActivityType.financing:
        return 'التدفقات النقدية من الأنشطة التمويلية';
    }
  }
}

/// Cash flow statement data model.
class CashFlowData {
  const CashFlowData({
    required this.periodStart,
    required this.periodEnd,
    required this.operatingActivities,
    required this.investingActivities,
    required this.financingActivities,
    required this.beginningCashBalance,
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final CashFlowSection operatingActivities;
  final CashFlowSection investingActivities;
  final CashFlowSection financingActivities;
  final double beginningCashBalance;
  final String currency;
  final String? notes;
  final String? notesAr;

  double get netOperatingCashFlow => operatingActivities.netCashFlow;
  double get netInvestingCashFlow => investingActivities.netCashFlow;
  double get netFinancingCashFlow => financingActivities.netCashFlow;

  double get netChangeInCash =>
      netOperatingCashFlow + netInvestingCashFlow + netFinancingCashFlow;

  double get endingCashBalance => beginningCashBalance + netChangeInCash;
}

/// A professional cash flow statement template.
///
/// Creates a standard cash flow statement showing operating,
/// investing, and financing activities using the direct method.
///
/// ## Example
/// ```dart
/// final cashFlow = CashFlowTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: cashFlowData,
/// );
///
/// final bytes = cashFlow.generate();
/// ```
class CashFlowTemplate extends GeniusErpAnalyticalReport {
  CashFlowTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final CashFlowData data;
  final PdfFont? boldFont;

  @override
  void build() {
    newPage();

    // Header
    _drawHeader();

    // Cash flow statement grid
    _drawCashFlowGrid();

    addSpace(10);
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
      title: 'Statement of Cash Flows',
      titleAr: 'قائمة التدفقات النقدية',
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

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(110);
  }

  void _drawCashFlowGrid() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'description',
        title: 'Description',
        titleAr: 'البيان',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.numeric(
        id: 'amount',
        title: 'Amount (${data.currency})',
        titleAr: 'المبلغ (${data.currency})',
        width: 130,
        alignment: GeniusPdfTextAlign.end,
        valueFormatter: (value) {
          if (value == null) return '';
          final amount = (value as num).toDouble();
          return amount >= 0
              ? _formatCurrency(amount)
              : '(${_formatCurrency(amount.abs())})';
        },
      ),
    ];

    final rows = <GeniusPdfGridRow>[];

    _appendActivityRows(rows, data.operatingActivities);
    _appendActivityRows(rows, data.investingActivities);
    _appendActivityRows(rows, data.financingActivities);
    _appendNetChangeRow(rows);
    _appendCashReconciliationRows(rows);

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

  void _appendActivityRows(
    List<GeniusPdfGridRow> rows,
    CashFlowSection section,
  ) {
    final titleText = config.isRTL
        ? (section.titleAr ?? section.defaultTitleAr)
        : (section.title.isNotEmpty ? section.title : section.defaultTitle);

    // Section identity is structural, so all activity headers use the same
    // neutral slate treatment. Financial meaning is carried by signed rows.
    rows.add(
      GeniusPdfGridRow.groupHeader(
        titleText,
        style: _cashFlowSectionHeaderStyle(),
      ),
    );

    for (final item in section.items) {
      final description = config.isRTL
          ? (item.descriptionAr ?? item.description)
          : item.description;
      final indent = '  ' * item.level;

      rows.add(
        GeniusPdfGridRow(
          cells: {
            'description': '$indent$description',
            'amount': item.amount,
          },
          style: item.isSubtotal
              ? _cashFlowSignedStyle(
                  item.amount,
                  emphasized: true,
                  subtle: true,
                )
              : _cashFlowSignedStyle(
                  item.amount,
                  emphasized: false,
                  subtle: true,
                ),
          keepTogether: true,
        ),
      );
    }

    rows.add(
      GeniusPdfGridRow.total(
        {
          'description': _sectionTotalLabel(section.type),
          'amount': section.netCashFlow,
        },
        style: _cashFlowSignedStyle(
          section.netCashFlow,
          emphasized: true,
          subtle: false,
        ),
      ),
    );
  }

  void _appendNetChangeRow(List<GeniusPdfGridRow> rows) {
    rows.add(
      GeniusPdfGridRow.total(
        {
          'description':
              config.isRTL ? 'صافي التغير في النقد' : 'Net Change in Cash',
          'amount': data.netChangeInCash,
        },
        style: _cashFlowSignedStyle(
          data.netChangeInCash,
          emphasized: true,
          subtle: false,
          fontSize: 10,
          padding: 6,
        ),
      ),
    );
  }

  void _appendCashReconciliationRows(List<GeniusPdfGridRow> rows) {
    rows.add(
      GeniusPdfGridRow.groupHeader(
        config.isRTL ? 'تسوية النقد' : 'Cash Reconciliation',
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A5F),
          ),
          backgroundColor: Color(0xFFEFF6FF),
          border: GeniusPdfBorderStyle.all(color: Color(0xFFBFDBFE)),
          padding: GeniusPdfCellPadding.all(5),
        ),
      ),
    );

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'description': config.isRTL
              ? 'رصيد النقد في بداية الفترة'
              : 'Cash at Beginning of Period',
          'amount': data.beginningCashBalance,
        },
        style: const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(color: Color(0xFF334155)),
          backgroundColor: Color(0xFFF8FAFC),
          border: GeniusPdfBorderStyle.horizontal(color: Color(0xFFE2E8F0)),
          padding: GeniusPdfCellPadding.all(5),
        ),
      ),
    );

    rows.add(
      GeniusPdfGridRow(
        cells: {
          'description':
              config.isRTL ? 'صافي التغير في النقد' : 'Net Change in Cash',
          'amount': data.netChangeInCash,
        },
        style: _cashFlowSignedStyle(
          data.netChangeInCash,
          emphasized: false,
          subtle: true,
        ),
      ),
    );

    rows.add(
      GeniusPdfGridRow.total(
        {
          'description': config.isRTL
              ? 'رصيد النقد في نهاية الفترة'
              : 'Cash at End of Period',
          'amount': data.endingCashBalance,
        },
        style: _cashFlowSignedStyle(
          data.endingCashBalance,
          emphasized: true,
          subtle: false,
          fontSize: 10,
          padding: 6,
        ),
      ),
    );
  }

  String _sectionTotalLabel(CashFlowActivityType type) {
    switch (type) {
      case CashFlowActivityType.operating:
        return config.isRTL
            ? 'صافي النقد من الأنشطة التشغيلية'
            : 'Net Cash from Operating Activities';
      case CashFlowActivityType.investing:
        return config.isRTL
            ? 'صافي النقد من الأنشطة الاستثمارية'
            : 'Net Cash from Investing Activities';
      case CashFlowActivityType.financing:
        return config.isRTL
            ? 'صافي النقد من الأنشطة التمويلية'
            : 'Net Cash from Financing Activities';
    }
  }

  GeniusPdfCellStyle _cashFlowSectionHeaderStyle() {
    return const GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
      backgroundColor: Color(0xFFF1F5F9),
      border: GeniusPdfBorderStyle.all(color: Color(0xFFCBD5E1)),
      padding: GeniusPdfCellPadding.all(5),
    );
  }

  GeniusPdfCellStyle _cashFlowSignedStyle(
    double amount, {
    required bool emphasized,
    required bool subtle,
    double fontSize = 9,
    double padding = 5,
  }) {
    if (amount == 0) {
      return GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: fontSize,
          fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF475569),
        ),
        backgroundColor:
            subtle ? const Color(0xFFF8FAFC) : const Color(0xFFE2E8F0),
        border: const GeniusPdfBorderStyle.horizontal(
          color: Color(0xFFCBD5E1),
        ),
        padding: GeniusPdfCellPadding.all(padding),
      );
    }

    final isInflow = amount > 0;
    final background = isInflow
        ? (subtle ? const Color(0xFFF0FDF4) : const Color(0xFFDCFCE7))
        : (subtle ? const Color(0xFFFEF2F2) : const Color(0xFFFEE2E2));
    final textColor =
        isInflow ? const Color(0xFF166534) : const Color(0xFF991B1B);
    final borderColor =
        isInflow ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA);

    return GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: fontSize,
        fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
        color: textColor,
      ),
      backgroundColor: background,
      border: GeniusPdfBorderStyle.horizontal(color: borderColor),
      padding: GeniusPdfCellPadding.all(padding),
    );
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
