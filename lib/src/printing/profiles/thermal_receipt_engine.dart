
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../components/components.dart';
import '../../core/directionality.dart';
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import 'print_profile.dart';

/// One thermal receipt line item.
class GeniusPdfThermalLineItem {
  const GeniusPdfThermalLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.sku,
    this.discount = 0,
  });

  final String description;
  final String? descriptionAr;
  final String? sku;
  final double quantity;
  final double unitPrice;
  final double discount;

  double get total => quantity * unitPrice - discount;
}

/// One payment/cash line in a thermal receipt.
class GeniusPdfThermalPaymentLine {
  const GeniusPdfThermalPaymentLine({
    required this.label,
    required this.amount,
    this.labelAr,
  });

  final String label;
  final String? labelAr;
  final double amount;
}

/// Data consumed by [GeniusPdfThermalReceiptEngine].
class GeniusPdfThermalReceiptData {
  const GeniusPdfThermalReceiptData({
    required this.merchantName,
    required this.receiptNumber,
    required this.date,
    required this.items,
    this.merchantNameAr,
    this.title,
    this.titleAr,
    this.showAmounts = true,
    this.currency = 'SAR',
    this.discount = 0,
    this.tax = 0,
    this.total,
    this.payments = const [],
    this.footer,
    this.footerAr,
    this.qrData,
    this.barcodeData,
  });

  final String merchantName;
  final String? merchantNameAr;

  /// Optional localized receipt heading.
  final String? title;
  final String? titleAr;

  /// Whether monetary quantity/price/summary/payment sections are rendered.
  ///
  /// Defaults to true for backward compatibility. S16 Gift/KOT sets false.
  final bool showAmounts;

  final String receiptNumber;
  final DateTime date;
  final List<GeniusPdfThermalLineItem> items;
  final String currency;
  final double discount;
  final double tax;

  /// Optional supplied grand total. When null it is derived deterministically.
  final double? total;

  final List<GeniusPdfThermalPaymentLine> payments;
  final String? footer;
  final String? footerAr;
  final String? qrData;
  final String? barcodeData;

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.total);

  double get grandTotal => total ?? subtotal - discount + tax;
}

GeniusPdfConfig _thermalReceiptConfig(
  GeniusPdfConfig config,
  GeniusPdfPrintProfile profile,
  GeniusPdfThermalReceiptData data,
) {
  if (!profile.isThermal &&
      profile.kind != GeniusPdfPrintProfileKind.continuous) {
    throw ArgumentError.value(
      profile.kind,
      'profile',
      'Thermal receipt requires thermal58, thermal80 or continuous profile.',
    );
  }

  // Variable-height receipt. The estimate deliberately includes generous
  // wrapping allowance so the generated page does not clip at the cut edge.
  int _estimatedThermalItemLines(
    GeniusPdfThermalLineItem item,
  ) {
    final longest = item.description.length >
            (item.descriptionAr?.length ?? 0)
        ? item.description
        : (item.descriptionAr ?? item.description);
    final explicitLines = '\n'.allMatches(longest).length + 1;
    final wrappedLines = (longest.length / 34).ceil();
    return explicitLines > wrappedLines
        ? explicitLines
        : wrappedLines;
  }

  final itemHeight = data.items.fold<double>(
    0,
    (sum, item) =>
        sum + 18 + _estimatedThermalItemLines(item) * 16,
  );
  final paymentHeight = data.payments.length * 18.0;
  final codesHeight =
      (data.qrData != null ? 120.0 : 0) +
      (data.barcodeData != null ? 90.0 : 0);
  final estimated = 210 +
      itemHeight +
      paymentHeight +
      codesHeight +
      profile.cutSpacing +
      profile.margins.vertical;
  final height = estimated < 240 ? 240.0 : estimated;

  return profile.apply(config).copyWith(
        pageSize: Size(profile.pageSize.width, height),
        orientation: PdfPageOrientation.portrait,
      );
}

/// S11 variable-height thermal receipt engine.
///
/// The engine uses the S08 thermal family as its structural parent while
/// overriding the rendering body for compact receipt-specific typography.
/// Monetary/identifier runs are rendered LTR independently inside RTL receipts.
class GeniusPdfThermalReceiptEngine extends GeniusErpThermalReceipt {
  GeniusPdfThermalReceiptEngine({
    required GeniusPdfConfig config,
    required this.data,
    GeniusPdfPrintProfile? profile,
  })  : profile = profile ?? GeniusPdfPrintProfile.thermal80(),
        super(
          _thermalReceiptConfig(
            config,
            profile ?? GeniusPdfPrintProfile.thermal80(),
            data,
          ),
        );

  final GeniusPdfThermalReceiptData data;
  final GeniusPdfPrintProfile profile;

  @override
  void build() {
    newPage();

    _drawCentered(
      config.isRTL
          ? (data.merchantNameAr ?? data.merchantName)
          : data.merchantName,
      font: config.headerFont,
    );
    final receiptTitle = config.isRTL
        ? (data.titleAr ?? data.title ?? 'إيصال')
        : (data.title ?? data.titleAr ?? 'Receipt');
    _drawCentered(
      receiptTitle,
      font: config.boldFont,
    );

    _divider();

    _drawKeyValue(
      label: 'Receipt No.',
      labelAr: 'رقم الإيصال',
      value: data.receiptNumber,
    );
    _drawKeyValue(
      label: 'Date',
      labelAr: 'التاريخ',
      value: config.formatter.formatDate(data.date),
    );

    _divider();

    for (var index = 0; index < data.items.length; index++) {
      final item = data.items[index];
      final description = config.isRTL
          ? (item.descriptionAr ?? item.description)
          : item.description;

      _drawWrapped(
        '${index + 1}. $description',
        font: config.baseFont,
      );

      if (item.sku != null && item.sku!.isNotEmpty) {
        _drawLtrLine(
          'SKU: ${item.sku}',
          font: config.smallFont,
        );
      }

      if (data.showAmounts) {
        final qty = config.formatter.formatQuantity(
          item.quantity,
          decimalPlaces: 3,
        );
        _drawLtrLine(
          '$qty × ${item.unitPrice.toStringAsFixed(2)} '
          '= ${item.total.toStringAsFixed(2)} ${data.currency}',
          font: config.smallFont,
        );
      }
      addSpace(3);
    }

    if (data.showAmounts) {
      _divider();

      _drawMoneyLine(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        amount: data.subtotal,
      );
      if (data.discount != 0) {
        _drawMoneyLine(
          label: 'Discount',
          labelAr: 'الخصم',
          amount: -data.discount,
        );
      }
      if (data.tax != 0) {
        _drawMoneyLine(
          label: 'Tax',
          labelAr: 'الضريبة',
          amount: data.tax,
        );
      }
      _drawMoneyLine(
        label: 'Total',
        labelAr: 'الإجمالي',
        amount: data.grandTotal,
        bold: true,
      );
    }

    if (data.showAmounts && data.payments.isNotEmpty) {
      _divider();
      _drawWrapped(
        config.isRTL ? 'الدفع' : 'Payment',
        font: config.boldFont,
      );
      for (final payment in data.payments) {
        _drawMoneyLine(
          label: payment.label,
          labelAr: payment.labelAr,
          amount: payment.amount,
        );
      }
    }

    if (data.qrData != null && data.qrData!.isNotEmpty) {
      addSpace(8);
      final size =
          (pageWidth * 0.62).clamp(70.0, 115.0).toDouble();
      final qr = GeniusPdfQRCodeGenerator(
        data: data.qrData!,
        caption: 'Scan',
        captionAr: 'مسح',
        config: config,
        directionality: directionality,
      );
      final result = qr.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          0,
          currentY,
          pageWidth,
          size + 28,
        ),
      );
      setCurrentPage(currentPage, y: result.bottom + 4);
    }

    if (data.barcodeData != null &&
        data.barcodeData!.isNotEmpty) {
      addSpace(6);
      final barcode = GeniusPdfBarcode.code128(
        data: data.barcodeData!,
        caption: 'Receipt code',
        captionAr: 'رمز الإيصال',
        config: config,
      );
      final result = barcode.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          0,
          currentY,
          pageWidth,
          72,
        ),
      );
      setCurrentPage(currentPage, y: result.bottom + 4);
    }

    final footerText = config.isRTL
        ? (data.footerAr ?? data.footer)
        : (data.footer ?? data.footerAr);
    if (footerText != null && footerText.trim().isNotEmpty) {
      _divider();
      _drawCentered(
        footerText,
        font: config.smallFont,
      );
    }

    if (profile.cutSpacing > 0) {
      addSpace(profile.cutSpacing);
    }
  }

  void _drawMoneyLine({
    required String label,
    String? labelAr,
    required double amount,
    bool bold = false,
  }) {
    _drawKeyValue(
      label: label,
      labelAr: labelAr,
      value:
          '${amount.toStringAsFixed(2)} ${data.currency}',
      bold: bold,
    );
  }

  void _drawKeyValue({
    required String label,
    String? labelAr,
    required String value,
    bool bold = false,
  }) {
    final page = currentPage;
    final font = bold ? config.boldFont : config.baseFont;
    final labelText = config.isRTL ? (labelAr ?? label) : label;
    final y = currentY + 1;
    final height = font.height + 4;
    final half = pageWidth * 0.5;

    final isRtl =
        resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl;

    final labelBounds = Rect.fromLTWH(
      isRtl ? half : 0,
      y,
      half,
      height,
    );
    final valueBounds = Rect.fromLTWH(
      isRtl ? 0 : half,
      y,
      half,
      height,
    );

    page.graphics.drawString(
      labelText,
      font,
      bounds: labelBounds,
      brush: PdfBrushes.black,
      format: PdfStringFormat(
        alignment:
            isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: isRtl
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    // Structured amount/date/id value is intentionally independent LTR.
    page.graphics.drawString(
      value,
      font,
      bounds: valueBounds,
      brush: PdfBrushes.black,
      format: PdfStringFormat(
        alignment:
            isRtl ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );

    setCurrentPage(page, y: y + height);
  }

  void _drawCentered(
    String text, {
    required PdfFont font,
  }) {
    final page = currentPage;
    final y = currentY + 1;
    final result = PdfTextElement(
      text: text,
      font: font,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection:
            resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
      ),
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        y,
        pageWidth,
        pageHeight - y,
      ),
    );

    setCurrentPage(
      page,
      y: (result?.bounds.bottom ?? (y + font.height)) + 2,
    );
  }

  void _drawWrapped(
    String text, {
    required PdfFont font,
  }) {
    final page = currentPage;
    final y = currentY + 1;
    final result = PdfTextElement(
      text: text,
      font: font,
      format: PdfStringFormat(
        alignment:
            resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl
                ? PdfTextAlignment.right
                : PdfTextAlignment.left,
        textDirection:
            resolvedLayoutDirection == GeniusPdfResolvedDirection.rtl
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
      ),
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        y,
        pageWidth,
        pageHeight - y,
      ),
    );

    setCurrentPage(
      page,
      y: (result?.bounds.bottom ?? (y + font.height)) + 1,
    );
  }

  void _drawLtrLine(
    String text, {
    required PdfFont font,
  }) {
    final page = currentPage;
    final y = currentY + 1;
    page.graphics.drawString(
      text,
      font,
      bounds: Rect.fromLTWH(
        0,
        y,
        pageWidth,
        font.height + 4,
      ),
      brush: PdfBrushes.black,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );
    setCurrentPage(page, y: y + font.height + 4);
  }

  void _divider() {
    final page = currentPage;
    final y = currentY + 3;
    page.graphics.drawLine(
      PdfPen(PdfColor(170, 170, 170), width: 0.5),
      Offset(0, y),
      Offset(pageWidth, y),
    );
    setCurrentPage(page, y: y + 4);
  }
}
