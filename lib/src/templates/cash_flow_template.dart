import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

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
class CashFlowTemplate extends GeniusPdfDocumentBuilder {
  CashFlowTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final CashFlowData data;
  final PdfFont? boldFont;

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

    // Operating Activities
    _drawSection(data.operatingActivities);

    // Investing Activities
    _drawSection(data.investingActivities);

    // Financing Activities
    _drawSection(data.financingActivities);

    // Net Change in Cash
    _drawNetChange();

    // Cash Reconciliation
    _drawCashReconciliation();

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

  void _drawSection(CashFlowSection section) {
    // Section title
    final titleText = config.isRTL
        ? (section.titleAr ?? section.defaultTitleAr)
        : (section.title.isNotEmpty ? section.title : section.defaultTitle);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(230, 230, 250)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 22),
    );

    currentPage.graphics.drawString(
      titleText,
      _boldFont,
      bounds: Rect.fromLTWH(5, currentY + 4, pageWidth - 10, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(28);

    // Section items
    for (final item in section.items) {
      _drawCashFlowItem(item);
    }

    // Section net cash flow
    _drawSectionTotal(section);

    addSpace(15);
  }

  void _drawCashFlowItem(CashFlowItem item) {
    final indent = 10.0 + (item.level * 15.0);
    final description = config.isRTL
        ? (item.descriptionAr ?? item.description)
        : item.description;

    final font = item.isSubtotal
        ? _boldFont
        : baseFont;

    if (item.isSubtotal) {
      currentPage.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(245, 245, 245)),
        bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      );
    }

    currentPage.graphics.drawString(
      description,
      font,
      bounds: Rect.fromLTWH(indent, currentY + 2, pageWidth * 0.65, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    final amountText = item.amount >= 0
        ? _formatCurrency(item.amount)
        : '(${_formatCurrency(item.amount.abs())})';

    currentPage.graphics.drawString(
      amountText,
      font,
      bounds: Rect.fromLTWH(
          pageWidth * 0.65, currentY + 2, pageWidth * 0.35 - 5, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(20);
  }

  void _drawSectionTotal(CashFlowSection section) {
    String totalLabel;
    switch (section.type) {
      case CashFlowActivityType.operating:
        totalLabel = config.isRTL
            ? 'صافي النقد من الأنشطة التشغيلية'
            : 'Net Cash from Operating Activities';
        break;
      case CashFlowActivityType.investing:
        totalLabel = config.isRTL
            ? 'صافي النقد من الأنشطة الاستثمارية'
            : 'Net Cash from Investing Activities';
        break;
      case CashFlowActivityType.financing:
        totalLabel = config.isRTL
            ? 'صافي النقد من الأنشطة التمويلية'
            : 'Net Cash from Financing Activities';
        break;
    }

    final netCashFlow = section.netCashFlow;
    final isPositive = netCashFlow >= 0;
    final bgColor =
        isPositive ? PdfColor(220, 255, 220) : PdfColor(255, 220, 220);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(bgColor),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 22),
    );

    currentPage.graphics.drawString(
      totalLabel,
      _boldFont,
      bounds: Rect.fromLTWH(5, currentY + 4, pageWidth * 0.65, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    final amountText = isPositive
        ? _formatCurrency(netCashFlow)
        : '(${_formatCurrency(netCashFlow.abs())})';

    currentPage.graphics.drawString(
      amountText,
      _boldFont,
      bounds: Rect.fromLTWH(
          pageWidth * 0.65, currentY + 4, pageWidth * 0.35 - 5, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(28);
  }

  void _drawNetChange() {
    final label = config.isRTL ? 'صافي التغير في النقد' : 'Net Change in Cash';

    final netChange = data.netChangeInCash;
    final isPositive = netChange >= 0;
    final color = isPositive ? PdfColor(0, 100, 0) : PdfColor(180, 0, 0);

    final netChangeFont = config.configAssets == null
        ? config.baseFont
        : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
            style: PdfFontStyle.bold);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(200, 200, 255)),
      pen: PdfPen(PdfColor(100, 100, 150)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 26),
    );

    currentPage.graphics.drawString(
      label,
      netChangeFont,
      bounds: Rect.fromLTWH(5, currentY + 5, pageWidth * 0.65, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    final amountText = isPositive
        ? _formatCurrency(netChange)
        : '(${_formatCurrency(netChange.abs())})';

    currentPage.graphics.drawString(
      amountText,
      netChangeFont,
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(
          pageWidth * 0.65, currentY + 5, pageWidth * 0.35 - 5, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(35);
  }

  void _drawCashReconciliation() {
    final title = config.isRTL ? 'تسوية النقد' : 'Cash Reconciliation';

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

    // Beginning balance
    _drawReconciliationLine(
      config.isRTL
          ? 'رصيد النقد في بداية الفترة'
          : 'Cash at Beginning of Period',
      data.beginningCashBalance,
    );

    // Net change
    _drawReconciliationLine(
      config.isRTL ? 'صافي التغير في النقد' : 'Net Change in Cash',
      data.netChangeInCash,
    );

    // Ending balance
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(220, 255, 220)),
      pen: PdfPen(PdfColor(0, 150, 0)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 24),
    );

    currentPage.graphics.drawString(
      config.isRTL ? 'رصيد النقد في نهاية الفترة' : 'Cash at End of Period',
      _boldFont,
      bounds: Rect.fromLTWH(5, currentY + 5, pageWidth * 0.65, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(data.endingCashBalance),
      _boldFont,
      brush: PdfSolidBrush(PdfColor(0, 100, 0)),
      bounds: Rect.fromLTWH(
          pageWidth * 0.65, currentY + 5, pageWidth * 0.35 - 5, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(35);
  }

  void _drawReconciliationLine(String label, double amount) {
    currentPage.graphics.drawString(
      label,
      baseFont,
      bounds: Rect.fromLTWH(10, currentY, pageWidth * 0.65, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    final amountText = amount >= 0
        ? _formatCurrency(amount)
        : '(${_formatCurrency(amount.abs())})';

    currentPage.graphics.drawString(
      amountText,
      baseFont,
      bounds:
          Rect.fromLTWH(pageWidth * 0.65, currentY, pageWidth * 0.35 - 5, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(22);
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
