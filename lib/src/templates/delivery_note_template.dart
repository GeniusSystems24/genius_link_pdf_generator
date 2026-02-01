import 'dart:ui';


import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Delivery note line item.
class DeliveryItem {
  const DeliveryItem({
    required this.itemNumber,
    required this.description,
    required this.orderedQty,
    required this.deliveredQty,
    this.descriptionAr,
    this.productCode,
    this.unit,
    this.batchNumber,
    this.serialNumbers = const [],
    this.notes,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final String? productCode;
  final double orderedQty;
  final double deliveredQty;
  final String? unit;
  final String? batchNumber;
  final List<String> serialNumbers;
  final String? notes;

  double get remainingQty => orderedQty - deliveredQty;
  bool get isFullyDelivered => deliveredQty >= orderedQty;
  bool get isPartialDelivery => deliveredQty > 0 && deliveredQty < orderedQty;
}

/// Delivery recipient information.
class DeliveryRecipient {
  const DeliveryRecipient({
    required this.name,
    this.nameAr,
    this.company,
    this.companyAr,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
  });

  final String name;
  final String? nameAr;
  final String? company;
  final String? companyAr;
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
}

/// Delivery note data model.
class DeliveryNoteData {
  const DeliveryNoteData({
    required this.deliveryNumber,
    required this.deliveryDate,
    required this.items,
    this.salesOrderRef,
    this.invoiceRef,
    this.driverName,
    this.vehicleNumber,
    this.deliveryMethod,
    this.deliveryMethodAr,
    this.notes,
    this.notesAr,
  });

  final String deliveryNumber;
  final DateTime deliveryDate;
  final String? salesOrderRef;
  final String? invoiceRef;
  final String? driverName;
  final String? vehicleNumber;
  final String? deliveryMethod;
  final String? deliveryMethodAr;
  final List<DeliveryItem> items;
  final String? notes;
  final String? notesAr;

  int get totalItems => items.length;
  double get totalDeliveredQty =>
      items.fold(0, (sum, item) => sum + item.deliveredQty);
  bool get isFullDelivery => items.every((item) => item.isFullyDelivered);
  bool get hasPartialDelivery => items.any((item) => item.isPartialDelivery);
}

/// A professional delivery note template.
///
/// Creates delivery notes with item tracking,
/// quantity verification, and delivery confirmation.
///
/// ## Example
/// ```dart
/// final delivery = DeliveryNoteTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   recipient: recipientInfo,
///   delivery: deliveryData,
/// );
///
/// final bytes = delivery.generate();
/// ```
class DeliveryNoteTemplate extends GeniusPdfDocumentBuilder {
  DeliveryNoteTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.recipient,
    required this.delivery,
    this.boldFont,
    this.showQuantityComparison = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final DeliveryRecipient recipient;
  final DeliveryNoteData delivery;
  final PdfFont? boldFont;
  final bool showQuantityComparison;

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
    _drawDeliverySummary();

    if (delivery.notes != null || delivery.notesAr != null) {
      _drawNotes();
    }

    _drawSignatureSection();
  }

  void _drawHeader() {
    // Delivery status indicator
    _drawStatusIndicator();

    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Delivery Note',
      titleAr: 'إشعار تسليم',
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

  void _drawStatusIndicator() {
    final status = delivery.isFullDelivery
        ? (config.isRTL ? 'تسليم كامل' : 'Full Delivery')
        : (config.isRTL ? 'تسليم جزئي' : 'Partial Delivery');

    final color =
        delivery.isFullDelivery ? PdfColor(0, 150, 0) : PdfColor(255, 165, 0);

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(pageWidth - 100, 5, 95, 20),
    );

    currentPage.graphics.drawString(
      status,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 9,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(pageWidth - 100, 5, 95, 20),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle),
    );
  }

  void _drawInfoSection() {
    final recipientBox = GeniusPdfInfoBox(
      config: config,
      title: 'Deliver To',
      titleAr: 'التسليم إلى',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL
              ? (recipient.nameAr ?? recipient.name)
              : recipient.name,
        ),
        if (recipient.company != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Company',
            labelAr: 'الشركة',
            value: config.isRTL
                ? (recipient.companyAr ?? recipient.company!)
                : recipient.company!,
          ),
        if (recipient.address != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (recipient.addressAr ?? recipient.address!)
                : recipient.address!,
          ),
        if (recipient.phone != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'الهاتف',
            value: recipient.phone!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final deliveryBox = GeniusPdfInfoBox(
      config: config,
      title: 'Delivery Details',
      titleAr: 'تفاصيل التسليم',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Delivery No',
          labelAr: 'رقم التسليم',
          value: delivery.deliveryNumber,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(delivery.deliveryDate),
        ),
        if (delivery.salesOrderRef != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Sales Order',
            labelAr: 'أمر البيع',
            value: delivery.salesOrderRef!,
          ),
        if (delivery.invoiceRef != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Invoice Ref',
            labelAr: 'رقم الفاتورة',
            value: delivery.invoiceRef!,
          ),
        if (delivery.driverName != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Driver',
            labelAr: 'السائق',
            value: delivery.driverName!,
          ),
        if (delivery.vehicleNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Vehicle',
            labelAr: 'المركبة',
            value: delivery.vehicleNumber!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: config.isRTL ? deliveryBox : recipientBox,
      rightBox: config.isRTL ? recipientBox : deliveryBox,
      spacing: 20,
    );

    final result = dualBox.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );

    addSpace(result.height + 20);
  }

  void _drawItemsTable() {
    final columns = <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        titleAr: '#',
        width: 30,
        alignment: GeniusPdfTextAlign.center,
      ),
    ];

    if (delivery.items.any((i) => i.productCode != null)) {
      columns.add(const GeniusPdfGridColumn(
        id: 'code',
        title: 'Code',
        titleAr: 'الكود',
        width: 60,
      ));
    }

    columns.add(const GeniusPdfGridColumn(
      id: 'description',
      title: 'Description',
      titleAr: 'الوصف',
      flexFactor: 3,
    ));

    if (showQuantityComparison) {
      columns.addAll([
        const GeniusPdfGridColumn(
          id: 'ordered',
          title: 'Ordered',
          titleAr: 'المطلوب',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'delivered',
          title: 'Delivered',
          titleAr: 'المسلم',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'remaining',
          title: 'Remaining',
          titleAr: 'المتبقي',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
      ]);
    } else {
      columns.add(const GeniusPdfGridColumn(
        id: 'qty',
        title: 'Quantity',
        titleAr: 'الكمية',
        width: 80,
        alignment: GeniusPdfTextAlign.center,
      ));
    }

    if (delivery.items.any((i) => i.batchNumber != null)) {
      columns.add(const GeniusPdfGridColumn(
        id: 'batch',
        title: 'Batch',
        titleAr: 'الدفعة',
        width: 70,
      ));
    }

    final rows = delivery.items.map((item) {
      final cells = <String, dynamic>{
        'no': item.itemNumber,
        'description': config.isRTL
            ? (item.descriptionAr ?? item.description)
            : item.description,
      };

      if (delivery.items.any((i) => i.productCode != null)) {
        cells['code'] = item.productCode ?? '';
      }

      if (showQuantityComparison) {
        cells['ordered'] =
            '${item.orderedQty}${item.unit != null ? ' ${item.unit}' : ''}';
        cells['delivered'] =
            '${item.deliveredQty}${item.unit != null ? ' ${item.unit}' : ''}';
        cells['remaining'] =
            '${item.remainingQty}${item.unit != null ? ' ${item.unit}' : ''}';
      } else {
        cells['qty'] =
            '${item.deliveredQty}${item.unit != null ? ' ${item.unit}' : ''}';
      }

      if (delivery.items.any((i) => i.batchNumber != null)) {
        cells['batch'] = item.batchNumber ?? '';
      }

      return GeniusPdfGridRow(
        cells: cells,
        isGroupHeader: item.isPartialDelivery,
      );
    }).toList();

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
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

  void _drawDeliverySummary() {
    final title = config.isRTL ? 'ملخص التسليم' : 'Delivery Summary';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(240, 240, 240)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 60),
    );

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(10, currentY + 5, pageWidth - 20, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    final summaryItems = [
      '${config.isRTL ? 'عدد الأصناف' : 'Total Items'}: ${delivery.totalItems}',
      '${config.isRTL ? 'إجمالي الكمية المسلمة' : 'Total Qty Delivered'}: ${delivery.totalDeliveredQty}',
      '${config.isRTL ? 'حالة التسليم' : 'Delivery Status'}: ${delivery.isFullDelivery ? (config.isRTL ? 'كامل' : 'Complete') : (config.isRTL ? 'جزئي' : 'Partial')}',
    ];

    var yOffset = currentY + 25;
    for (final item in summaryItems) {
      currentPage.graphics.drawString(
        '• $item',
        baseFont,
        bounds: Rect.fromLTWH(15, yOffset, pageWidth - 30, 16),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        ),
      );
      yOffset += 14;
    }

    addSpace(70);
  }

  void _drawNotes() {
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText =
        config.isRTL ? (delivery.notesAr ?? delivery.notes!) : delivery.notes!;

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

  void _drawSignatureSection() {
    final bottomY = pageHeight - 100;

    // Delivered by
    final deliveredBy = GeniusPdfSignatureArea(config: config,
      title: 'Delivered By',
      titleAr: 'سلمه',
    );

    deliveredBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, bottomY, 180, 70),
    );

    // Received by
    final receivedBy = GeniusPdfSignatureArea(config: config,
      title: 'Received By',
      titleAr: 'استلمه',
    );

    receivedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(pageWidth - 180, bottomY, 180, 70),
    );

    // Received date/time
    currentPage.graphics.drawString(
      config.isRTL
          ? 'تاريخ ووقت الاستلام: _______________'
          : 'Date/Time Received: _______________',
      baseFont,
      bounds: Rect.fromLTWH((pageWidth - 200) / 2, bottomY + 50, 200, 18),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
