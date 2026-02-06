import 'dart:ui';




import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Purchase order line item.
class PurchaseOrderItem {
  const PurchaseOrderItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.unit,
    this.productCode,
    this.discount = 0,
    this.deliveryDate,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final String? productCode;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;
  final DateTime? deliveryDate;

  double get lineTotal => (quantity * unitPrice) - discount;
}

/// Supplier/Vendor information.
class PurchaseOrderVendor {
  const PurchaseOrderVendor({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.vatNumber,
    this.phone,
    this.email,
    this.contactPerson,
    this.vendorCode,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? vatNumber;
  final String? phone;
  final String? email;
  final String? contactPerson;
  final String? vendorCode;
}

/// Shipping information.
class ShippingInfo {
  const ShippingInfo({
    required this.address,
    this.addressAr,
    this.contactPerson,
    this.phone,
    this.instructions,
    this.instructionsAr,
  });

  final String address;
  final String? addressAr;
  final String? contactPerson;
  final String? phone;
  final String? instructions;
  final String? instructionsAr;
}

/// Purchase order data model.
class PurchaseOrderData {
  const PurchaseOrderData({
    required this.poNumber,
    required this.poDate,
    required this.items,
    this.expectedDeliveryDate,
    this.quotationRef,
    this.paymentTerms,
    this.paymentTermsAr,
    this.shippingInfo,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.termsAndConditions,
    this.termsAndConditionsAr,
    this.currency = 'SAR',
    this.status = 'Draft',
  });

  final String poNumber;
  final DateTime poDate;
  final DateTime? expectedDeliveryDate;
  final String? quotationRef;
  final String? paymentTerms;
  final String? paymentTermsAr;
  final ShippingInfo? shippingInfo;
  final List<PurchaseOrderItem> items;
  final List<({String name, String? nameAr, double rate})> taxes;
  final String? notes;
  final String? notesAr;
  final String? termsAndConditions;
  final String? termsAndConditionsAr;
  final String currency;
  final String status;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get totalTax =>
      taxes.fold(0.0, (sum, tax) => sum + (subtotal * tax.rate / 100));
  double get grandTotal => subtotal + totalTax;
}

/// A professional purchase order template.
///
/// Creates purchase orders with itemized items, vendor info,
/// shipping details, and terms.
///
/// ## Example
/// ```dart
/// final po = PurchaseOrderTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   vendor: vendorInfo,
///   purchaseOrder: poData,
/// );
///
/// final bytes = po.generate();
/// ```
class PurchaseOrderTemplate extends GeniusPdfDocumentBuilder {
  PurchaseOrderTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.vendor,
    required this.purchaseOrder,
    this.boldFont,
    this.showShippingInfo = true,
    this.showTerms = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final PurchaseOrderVendor vendor;
  final PurchaseOrderData purchaseOrder;
  final PdfFont? boldFont;
  final bool showShippingInfo;
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

    if (showShippingInfo && purchaseOrder.shippingInfo != null) {
      _drawShippingInfo();
    }

    if (purchaseOrder.notes != null || purchaseOrder.notesAr != null) {
      _drawNotes();
    }

    if (showTerms &&
        (purchaseOrder.termsAndConditions != null ||
            purchaseOrder.termsAndConditionsAr != null)) {
      _drawTermsAndConditions();
    }

    _drawSignatureSection();
  }

  void _drawHeader() {
    // Status badge
    _drawStatusBadge();

    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Purchase Order',
      titleAr: 'أمر شراء',
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

  void _drawStatusBadge() {
    final statusColors = {
      'Draft': PdfColor(150, 150, 150),
      'Pending': PdfColor(255, 165, 0),
      'Approved': PdfColor(0, 150, 0),
      'Sent': PdfColor(0, 100, 200),
      'Received': PdfColor(0, 180, 0),
      'Cancelled': PdfColor(200, 0, 0),
    };

    final color = statusColors[purchaseOrder.status] ?? PdfColor(100, 100, 100);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(pageWidth - 80, 5, 75, 20),
    );

    currentPage.graphics.drawString(
      purchaseOrder.status,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 9,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(pageWidth - 80, 5, 75, 20),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection),
    );
  }

  void _drawInfoSection() {
    final vendorBox = GeniusPdfInfoBox(
      config: config,
      title: 'Vendor',
      titleAr: 'المورد',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL ? (vendor.nameAr ?? vendor.name) : vendor.name,
        ),
        if (vendor.vendorCode != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Vendor Code',
            labelAr: 'كود المورد',
            value: vendor.vendorCode!,
          ),
        if (vendor.address != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (vendor.addressAr ?? vendor.address!)
                : vendor.address!,
          ),
        if (vendor.vatNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: vendor.vatNumber!,
          ),
        if (vendor.phone != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: vendor.phone!,
          ),
        if (vendor.contactPerson != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Contact',
            labelAr: 'جهة الاتصال',
            value: vendor.contactPerson!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final poBox = GeniusPdfInfoBox(
      config: config,
      title: 'Order Details',
      titleAr: 'تفاصيل الطلب',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'PO Number',
          labelAr: 'رقم الطلب',
          value: purchaseOrder.poNumber,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(purchaseOrder.poDate),
        ),
        if (purchaseOrder.expectedDeliveryDate != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Expected Delivery',
            labelAr: 'التسليم المتوقع',
            value: _formatDate(purchaseOrder.expectedDeliveryDate!),
          ),
        if (purchaseOrder.quotationRef != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Quotation Ref',
            labelAr: 'مرجع العرض',
            value: purchaseOrder.quotationRef!,
          ),
        if (purchaseOrder.paymentTerms != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (purchaseOrder.paymentTermsAr ?? purchaseOrder.paymentTerms!)
                : purchaseOrder.paymentTerms!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: config.isRTL ? poBox : vendorBox,
      rightBox: config.isRTL ? vendorBox : poBox,
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
        if (purchaseOrder.items.any((i) => i.productCode != null))
          const GeniusPdfGridColumn(
            id: 'code',
            title: 'Code',
            titleAr: 'الكود',
            width: 60,
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
          width: 85,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 95,
          currencySymbol: '',
        ),
      ],
      rows: purchaseOrder.items.map((item) {
        final cells = <String, dynamic>{
          'no': item.itemNumber,
          'description': config.isRTL
              ? (item.descriptionAr ?? item.description)
              : item.description,
          'qty': '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
          'price': item.unitPrice,
          'total': item.lineTotal,
        };
        if (purchaseOrder.items.any((i) => i.productCode != null)) {
          cells['code'] = item.productCode ?? '';
        }
        return GeniusPdfGridRow(cells: cells);
      }).toList(),
      style: GeniusPdfGridStyle.modern(),
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
        value: _formatCurrency(purchaseOrder.subtotal),
      ),
    ];

    for (final tax in purchaseOrder.taxes) {
      items.add(GeniusPdfSummaryItem(
        label: '${tax.name} (${tax.rate}%)',
        labelAr: '${tax.nameAr ?? tax.name} (${tax.rate}%)',
        value: _formatCurrency(purchaseOrder.subtotal * tax.rate / 100),
      ));
    }

    items.add(GeniusPdfSummaryItem.total(
      label: 'Grand Total',
      labelAr: 'الإجمالي الكلي',
      value: _formatCurrency(purchaseOrder.grandTotal),
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

  void _drawShippingInfo() {
    final shipping = purchaseOrder.shippingInfo!;
    final title = config.isRTL ? 'معلومات الشحن' : 'Shipping Information';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(22);

    final shippingText = StringBuffer();
    shippingText.writeln(config.isRTL
        ? (shipping.addressAr ?? shipping.address)
        : shipping.address);
    if (shipping.contactPerson != null) {
      shippingText.writeln(
          '${config.isRTL ? 'جهة الاتصال' : 'Contact'}: ${shipping.contactPerson}');
    }
    if (shipping.phone != null) {
      shippingText
          .writeln('${config.isRTL ? 'الهاتف' : 'Phone'}: ${shipping.phone}');
    }
    if (shipping.instructions != null) {
      final instructions = config.isRTL
          ? (shipping.instructionsAr ?? shipping.instructions!)
          : shipping.instructions!;
      shippingText.writeln(
          '${config.isRTL ? 'تعليمات' : 'Instructions'}: $instructions');
    }

    currentPage.graphics.drawString(
      shippingText.toString(),
      baseFont,
      bounds: Rect.fromLTWH(10, currentY, pageWidth - 10, 60),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(65);
  }

  void _drawNotes() {
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText = config.isRTL
        ? (purchaseOrder.notesAr ?? purchaseOrder.notes!)
        : purchaseOrder.notes!;

    currentPage.graphics.drawString(
      '$notesLabel\n$notesText',
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 50),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(55);
  }

  void _drawTermsAndConditions() {
    final termsLabel =
        config.isRTL ? 'الشروط والأحكام:' : 'Terms & Conditions:';
    final termsText = config.isRTL
        ? (purchaseOrder.termsAndConditionsAr ??
            purchaseOrder.termsAndConditions!)
        : purchaseOrder.termsAndConditions!;

    currentPage.graphics.drawString(
      '$termsLabel\n$termsText',
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

  void _drawSignatureSection() {
    final bottomY = pageHeight - 80;

    // Prepared by
    final preparedBy = GeniusPdfSignatureArea(config: config,
      title: 'Prepared By',
      titleAr: 'أعده',
    );

    preparedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, bottomY, 150, 60),
    );

    // Approved by
    final approvedBy = GeniusPdfSignatureArea(config: config,
      title: 'Approved By',
      titleAr: 'اعتمده',
    );

    approvedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH((pageWidth - 150) / 2, bottomY, 150, 60),
    );

    // Received by vendor
    final receivedBy = GeniusPdfSignatureArea(config: config,
      title: 'Received By Vendor',
      titleAr: 'استلمه المورد',
    );

    receivedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(pageWidth - 150, bottomY, 150, 60),
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
    return '$formatted ${purchaseOrder.currency}';
  }
}
