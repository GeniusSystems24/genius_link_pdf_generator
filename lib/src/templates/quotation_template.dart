import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Quotation item model.
class QuotationItem {
  const QuotationItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.unit,
    this.descriptionAr,
    this.discount = 0,
    this.tax = 0,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;
  final double tax;

  double get subtotal => quantity * unitPrice;
  double get total => subtotal - discount + tax;
  String get lineTotal => total.toStringAsFixed(2);
}

/// Customer information for quotation.
class QuotationCustomer {
  const QuotationCustomer({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
    this.vatNumber,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? vatNumber;
}

/// Quotation data model.
class QuotationData {
  const QuotationData({
    required this.quotationNumber,
    required this.quotationDate,
    required this.validUntil,
    required this.customer,
    required this.items,
    this.status = 'Draft',
    this.statusAr = 'مسودة',
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
    this.terms,
    this.termsAr,
  });

  final String quotationNumber;
  final DateTime quotationDate;
  final DateTime validUntil;
  final QuotationCustomer customer;
  final List<QuotationItem> items;
  final String status;
  final String statusAr;
  final String currency;
  final String? notes;
  final String? notesAr;
  final String? terms;
  final String? termsAr;

  double get subTotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get totalDiscount => items.fold(0, (sum, item) => sum + item.discount);
  double get totalTax => items.fold(0, (sum, item) => sum + item.tax);
  double get grandTotal => subTotal - totalDiscount + totalTax;
}

/// A professional quotation template.
///
/// Creates detailed quotations with customer info, itemized list,
/// taxes, and terms & conditions.
///
/// ## Example
/// ```dart
/// final quote = QuotationTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: quotationData,
/// );
///
/// final bytes = quote.generate();
/// ```
class QuotationTemplate extends GeniusPdfDocumentBuilder {
  QuotationTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.quotation,
    this.boldFont,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final QuotationData quotation;
  final PdfFont? boldFont;

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
  final String?
      notesAr; // Added logic to use constructor notes if provided or fallback to data notes

  @override
  void build() {
    // Add repeating footer with user info on all pages
    if (printedBy != null || showQRCode) {
      addFooter(
        userName: printedBy,
        printTime: _formatDate(DateTime.now()),
        showPageNumber: true,
      );
    }

    newPage();

    _drawHeader();
    _drawCustomerInfo();
    _drawItemsTable();
    _drawTotals();

    // Draw Footer Section (Notes/Terms + QR Code)
    _drawFooterSection();

    // Signatures section
    if (showSignatures) {
      _drawSignatureSection();
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Quotation',
      titleAr: 'عرض سعر',
      subtitle: '#${quotation.quotationNumber}',
      subtitleAr: '#${quotation.quotationNumber}',
      company: company,
      printDate: quotation.quotationDate,
      style: const GeniusPdfReportHeaderStyle.modern(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );

    addReportHeader(header, height: 110);
  }

  void _drawCustomerInfo() {
    final customer = quotation.customer;

    // Left side: Customer details
    final customerItems = [
      GeniusPdfLabeledValue(
        config: config,
        label: 'Customer',
        labelAr: 'العميل',
        value:
            config.isRTL ? (customer.nameAr ?? customer.name) : customer.name,
      ),
      if (customer.address != null || customer.addressAr != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: config.isRTL
              ? (customer.addressAr ?? customer.address ?? '-')
              : (customer.address ?? '-'),
        ),
      if (customer.vatNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'VAT No',
          labelAr: 'الرقم الضريبي',
          value: customer.vatNumber!,
        ),
      if (customer.phone != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: customer.phone!,
        ),
    ];

    // Right side: Quotation details
    final quoteItems = [
      GeniusPdfLabeledValue(
        config: config,
        label: 'Date',
        labelAr: 'التاريخ',
        value: _formatDate(quotation.quotationDate),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Valid Until',
        labelAr: 'صالح حتى',
        value: _formatDate(quotation.validUntil),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Status',
        labelAr: 'الحالة',
        value: config.isRTL ? quotation.statusAr : quotation.status,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Currency',
        labelAr: 'العملة',
        value: quotation.currency,
      ),
    ];

    addTwoColumns(
        spacing: 10,
        leftContent: (page, bounds) {
          final infoBox = GeniusPdfInfoBox(
            config: config,
            title: 'Bill To',
            titleAr: 'فاتورة إلى',
            columns: 1,
            items: customerItems,
            style: const GeniusPdfInfoBoxStyle.headerContent(),
          );
          return infoBox.draw(page: page, bounds: bounds).height;
        },
        rightContent: (page, bounds) {
          final infoBox = GeniusPdfInfoBox(
            config: config,
            title: 'Details',
            titleAr: 'التفاصيل',
            columns: 1,
            items: quoteItems,
            style: const GeniusPdfInfoBoxStyle.headerContent(),
          );
          return infoBox.draw(page: page, bounds: bounds).height;
        });

    addSpace(10);
  }

  void _drawItemsTable() {
    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          titleAr: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        const GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'price',
          title: 'Unit Price',
          titleAr: 'السعر',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 80,
          alignment: GeniusPdfTextAlign.center,
        ),
      ],
      rows: quotation.items
          .map((item) => GeniusPdfGridRow(cells: {
                'no': item.itemNumber,
                'description': config.isRTL
                    ? (item.descriptionAr ?? item.description)
                    : item.description,
                'qty':
                    '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
                'price': _formatNumber(item.unitPrice),
                'total': item.lineTotal,
              }))
          .toList(),
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(8);
  }

  void _drawTotals() {
    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Subtotal',
          labelAr: 'المجموع الفرعي',
          value: _formatCurrency(quotation.subTotal),
        ),
        if (quotation.totalDiscount > 0)
          GeniusPdfSummaryItem.subtotal(
            label: 'Discount',
            labelAr: 'الخصم',
            value: '-${_formatCurrency(quotation.totalDiscount)}',
          ),
        if (quotation.totalTax > 0)
          GeniusPdfSummaryItem.subtotal(
            label: 'Tax (VAT)',
            labelAr: 'الضريبة',
            value: _formatCurrency(quotation.totalTax),
          ),
        GeniusPdfSummaryItem.total(
          label: 'Grand Total',
          labelAr: 'الإجمالي النهائي',
          value: _formatCurrency(quotation.grandTotal),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.5,
    );

    addSummary(summary, spacing: 10);
  }

  void _drawFooterSection() {
    final effectiveNotes = notes ??
        quotation.notes ??
        (config.isRTL
            ? notesAr ?? quotation.notesAr
            : notes ?? quotation.notes);
    final effectiveTerms =
        config.isRTL ? quotation.termsAr ?? quotation.terms : quotation.terms;

    final hasNotesOrTerms =
        (effectiveNotes != null && effectiveNotes.isNotEmpty) ||
            (effectiveTerms != null && effectiveTerms.isNotEmpty);

    if (!showNotes && (!showQRCode || reportId == null) && !hasNotesOrTerms) {
      return;
    }

    addSpace(20);

    // If only one section is shown, draw it normally
    if (showNotes && (!showQRCode || reportId == null)) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && (showQRCode && reportId != null) && !hasNotesOrTerms) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    // Draw side-by-side if both are present
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
    final effectiveNotes = notes ??
        quotation.notes ??
        (config.isRTL
            ? notesAr ?? quotation.notesAr
            : notes ?? quotation.notes);
    final effectiveTerms =
        config.isRTL ? quotation.termsAr ?? quotation.terms : quotation.terms;

    var text = '';

    if (effectiveNotes != null && effectiveNotes.isNotEmpty) {
      text += config.isRTL
          ? 'ملاحظات:\n$effectiveNotes\n\n'
          : 'Notes:\n$effectiveNotes\n\n';
    }

    if (effectiveTerms != null && effectiveTerms.isNotEmpty) {
      text += config.isRTL
          ? 'الشروط والأحكام:\n$effectiveTerms'
          : 'Terms & Conditions:\n$effectiveTerms';
    }

    if (text.isEmpty) return 0;

    final font = config.baseFont;
    final element = PdfTextElement(
      text: text,
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
        textDirection: config.isRTL
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0));

    final captionHeight = captionLayout?.bounds.height ?? 0;
    final qrSize = 80.0;
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

  void _drawSignatureSection() {
    if (currentY > pageHeight - 120) {
      newPage();
    }

    addSpace(20);
    addSectionDivider(
        title: config.isRTL ? 'الموافقة' : 'Acceptance', spacing: 15);

    final signatureY = currentY;

    // Company Signature
    final companySig = GeniusPdfSignatureArea(
      config: config,
      title: 'Authorized Signature',
      titleAr: 'التوقيع المعتمد',
      lineWidth: 110,
    );

    companySig.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? pageWidth - 120 : 0,
        signatureY,
        120,
        60,
      ),
    );

    // Customer Signature
    final customerSig = GeniusPdfSignatureArea(
      config: config,
      title: 'Customer Acceptance',
      titleAr: 'موافقة العميل',
      lineWidth: 110,
    );

    customerSig.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? 0 : pageWidth - 120,
        signatureY,
        120,
        60,
      ),
    );

    addSpace(80);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${quotation.currency}';
  }

  String _formatNumber(double number) {
    final formatted = number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return formatted;
  }
}
