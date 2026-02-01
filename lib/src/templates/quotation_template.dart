import 'dart:ui';




import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Quotation line item.
class QuotationItem {
  const QuotationItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.unit,
    this.discount = 0,
    this.notes,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;
  final String? notes;

  double get lineTotal => (quantity * unitPrice) - discount;
}

/// Quotation customer info.
class QuotationCustomer {
  const QuotationCustomer({
    required this.name,
    this.nameAr,
    this.company,
    this.companyAr,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
    this.contactPerson,
  });

  final String name;
  final String? nameAr;
  final String? company;
  final String? companyAr;
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? contactPerson;
}

/// Quotation data model.
class QuotationData {
  const QuotationData({
    required this.quotationNumber,
    required this.quotationDate,
    required this.items,
    this.validUntil,
    this.reference,
    this.paymentTerms,
    this.paymentTermsAr,
    this.deliveryTerms,
    this.deliveryTermsAr,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.termsAndConditions,
    this.termsAndConditionsAr,
    this.currency = 'SAR',
  });

  final String quotationNumber;
  final DateTime quotationDate;
  final DateTime? validUntil;
  final String? reference;
  final String? paymentTerms;
  final String? paymentTermsAr;
  final String? deliveryTerms;
  final String? deliveryTermsAr;
  final List<QuotationItem> items;
  final List<({String name, String? nameAr, double rate})> taxes;
  final String? notes;
  final String? notesAr;
  final String? termsAndConditions;
  final String? termsAndConditionsAr;
  final String currency;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get totalTax =>
      taxes.fold(0.0, (sum, tax) => sum + (subtotal * tax.rate / 100));
  double get grandTotal => subtotal + totalTax;
}

/// A professional quotation/price quote template.
///
/// Creates quotations with itemized pricing, terms,
/// and validity period.
///
/// ## Example
/// ```dart
/// final quotation = QuotationTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   customer: customerInfo,
///   quotation: quotationData,
/// );
///
/// final bytes = quotation.generate();
/// ```
class QuotationTemplate extends GeniusPdfDocumentBuilder {
  QuotationTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.customer,
    required this.quotation,
    this.boldFont,
    this.showTerms = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final QuotationCustomer customer;
  final QuotationData quotation;
  final PdfFont? boldFont;
  final bool showTerms;

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    newPage();

    _drawHeader();
    _drawInfoSection();
    _drawItemsTable();
    _drawSummary();

    if (quotation.notes != null || quotation.notesAr != null) {
      _drawNotes();
    }

    if (showTerms &&
        (quotation.termsAndConditions != null ||
            quotation.termsAndConditionsAr != null)) {
      _drawTermsAndConditions();
    }

    _drawSignatureSection();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Quotation',
      titleAr: 'عرض سعر',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 20),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(105);
  }

  void _drawInfoSection() {
    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'To',
      titleAr: 'إلى',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value:
              config.isRTL ? (customer.nameAr ?? customer.name) : customer.name,
        ),
        if (customer.company != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Company',
            labelAr: 'الشركة',
            value: config.isRTL
                ? (customer.companyAr ?? customer.company!)
                : customer.company!,
          ),
        if (customer.address != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (customer.addressAr ?? customer.address!)
                : customer.address!,
          ),
        if (customer.phone != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: customer.phone!,
          ),
        if (customer.email != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Email',
            labelAr: 'البريد',
            value: customer.email!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final quotationBox = GeniusPdfInfoBox(
      config: config,
      title: 'Quotation Details',
      titleAr: 'تفاصيل العرض',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Quotation No',
          labelAr: 'رقم العرض',
          value: quotation.quotationNumber,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(quotation.quotationDate),
        ),
        if (quotation.validUntil != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Valid Until',
            labelAr: 'صالح حتى',
            value: _formatDate(quotation.validUntil!),
          ),
        if (quotation.reference != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Reference',
            labelAr: 'المرجع',
            value: quotation.reference!,
          ),
        if (quotation.paymentTerms != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (quotation.paymentTermsAr ?? quotation.paymentTerms!)
                : quotation.paymentTerms!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: config.isRTL ? quotationBox : customerBox,
      rightBox: config.isRTL ? customerBox : quotationBox,
      spacing: 20,
    );

    final result = dualBox.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );

    addSpace(result.height + 20);
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
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Unit Price',
          titleAr: 'سعر الوحدة',
          width: 90,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 100,
          currencySymbol: '',
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
                'price': item.unitPrice,
                'total': item.lineTotal,
              }))
          .toList(),
      style: const GeniusPdfGridStyle.modern(),
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 15);
    }
  }

  void _drawSummary() {
    final items = <GeniusPdfSummaryItem>[
      GeniusPdfSummaryItem.subtotal(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        value: _formatCurrency(quotation.subtotal),
      ),
    ];

    for (final tax in quotation.taxes) {
      items.add(GeniusPdfSummaryItem(
        label: '${tax.name} (${tax.rate}%)',
        labelAr: '${tax.nameAr ?? tax.name} (${tax.rate}%)',
        value: _formatCurrency(quotation.subtotal * tax.rate / 100),
      ));
    }

    items.add(GeniusPdfSummaryItem.total(
      label: 'Grand Total',
      labelAr: 'الإجمالي الكلي',
      value: _formatCurrency(quotation.grandTotal),
    ));

    final summary = GeniusPdfSummarySection(
      config: config,
      items: items,
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.4,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );

    addSpace(result.height + 15);
  }

  void _drawNotes() {
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText = config.isRTL
        ? (quotation.notesAr ?? quotation.notes!)
        : quotation.notes!;

    currentPage.graphics.drawString(
      '$notesLabel\n$notesText',
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 50),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(55);
  }

  void _drawTermsAndConditions() {
    final termsLabel =
        config.isRTL ? 'الشروط والأحكام:' : 'Terms & Conditions:';
    final termsText = config.isRTL
        ? (quotation.termsAndConditionsAr ?? quotation.termsAndConditions!)
        : quotation.termsAndConditions!;

    currentPage.graphics.drawString(
      termsLabel,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(20);

    currentPage.graphics.drawString(
      termsText,
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 60),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(65);
  }

  void _drawSignatureSection() {
    final bottomY = pageHeight - 80;

    final signature = GeniusPdfSignatureArea(config: config,
      title: 'Authorized Signature',
      titleAr: 'التوقيع المعتمد',
    );

    signature.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? pageWidth - 200 : 0,
        bottomY,
        200,
        60,
      ),
    );

    // Customer acceptance
    final acceptance = GeniusPdfSignatureArea(config: config,
      title: 'Customer Acceptance',
      titleAr: 'موافقة العميل',
    );

    acceptance.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? 0 : pageWidth - 200,
        bottomY,
        200,
        60,
      ),
    );
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
}
