import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart' as bc;
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/barcode_models.dart';

// ============================================================================
// GeniusPdfBarcode - 1D and 2D Barcode Component
// ============================================================================

/// A barcode component for PDF documents.
///
/// Supports multiple barcode formats including:
/// - 1D: EAN-13, EAN-8, UPC-A, Code128, Code39, ITF
/// - 2D: QR Code, DataMatrix, PDF417
///
/// ## Example
/// ```dart
/// final barcode = GeniusPdfBarcode(
///   data: '5901234123457',
///   type: GeniusBarcodeType.ean13,
///   caption: 'Product Code',
///   captionAr: 'رمز المنتج',
///   style: GeniusPdfBarcodeStyle.retail(),
///   baseFont: config.baseFont,
///   isRTL: true,
/// );
///
/// barcode.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfBarcode {
  GeniusPdfBarcode({
    required this.data,
    required this.type,
    this.caption,
    this.captionAr,
    this.style = const GeniusPdfBarcodeStyle(),
    required this.baseFont,
    this.boldFont,
    this.captionFont,
    this.isRTL = true,
    this.width,
    this.height,
  });

  /// Creates an EAN-13 barcode.
  factory GeniusPdfBarcode.ean13({
    required String data,
    String? caption,
    String? captionAr,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle.retail(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.ean13,
      caption: caption,
      captionAr: captionAr,
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  /// Creates a Code128 barcode.
  factory GeniusPdfBarcode.code128({
    required String data,
    String? caption,
    String? captionAr,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.code128,
      caption: caption,
      captionAr: captionAr,
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  /// Creates a shipping/tracking barcode.
  factory GeniusPdfBarcode.shipping({
    required String data,
    String trackingLabel = 'Tracking Number',
    String trackingLabelAr = 'رقم التتبع',
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.code128,
      caption: trackingLabel,
      captionAr: trackingLabelAr,
      style: const GeniusPdfBarcodeStyle.shipping(),
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  final String data;
  final GeniusBarcodeType type;
  final String? caption;
  final String? captionAr;
  final GeniusPdfBarcodeStyle style;
  final PdfFont baseFont;
  final PdfFont? boldFont;
  final PdfFont? captionFont;
  final bool isRTL;
  final double? width;
  final double? height;

  /// Gets display caption based on locale.
  String? getCaption() {
    if (isRTL && captionAr != null) return captionAr;
    return caption;
  }

  /// Draws the barcode on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    final pad = style.padding;

    // Calculate barcode dimensions
    final barcodeWidth = (width ?? bounds.width) - (pad * 2);
    final barcodeHeight =
        (height ?? (type.is2D ? barcodeWidth : 60)) - (pad * 2);

    double currentY = bounds.top + pad;

    // Draw border background
    if (style.showBorder) {
      graphics.drawRectangle(
        pen: PdfPen(
          PdfColor(
            style.borderColor.red,
            style.borderColor.green,
            style.borderColor.blue,
          ),
          width: style.borderWidth,
        ),
        brush: PdfSolidBrush(PdfColor(
          style.backgroundColor.red,
          style.backgroundColor.green,
          style.backgroundColor.blue,
        )),
        bounds: Rect.fromLTWH(
          bounds.left,
          bounds.top,
          bounds.width,
          barcodeHeight + (pad * 2) + (getCaption() != null ? 20 : 0),
        ),
      );
    }

    // Draw caption above if position is above
    final displayCaption = getCaption();
    if (displayCaption != null &&
        style.captionPosition == GeniusPdfCaptionPosition.above) {
      final font = captionFont ?? baseFont;
      graphics.drawString(
        displayCaption,
        font,
        brush: PdfSolidBrush(PdfColor(
          style.captionColor.red,
          style.captionColor.green,
          style.captionColor.blue,
        )),
        bounds: Rect.fromLTWH(
          bounds.left + pad,
          currentY,
          barcodeWidth,
          style.captionFontSize + 4,
        ),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      currentY += style.captionFontSize + style.textSpacing + 4;
    }

    // Generate barcode image
    try {
      final barcodeImage = _generateBarcodeImage(
        barcodeWidth.toInt(),
        barcodeHeight.toInt(),
      );

      // Draw barcode image
      final barcodeX = bounds.left + (bounds.width - barcodeWidth) / 2;
      graphics.drawImage(
        PdfBitmap(barcodeImage),
        Rect.fromLTWH(barcodeX, currentY, barcodeWidth, barcodeHeight),
      );
      currentY += barcodeHeight;
    } catch (e) {
      // Draw error text if barcode generation fails
      graphics.drawString(
        'Error: $e',
        baseFont,
        brush: PdfBrushes.red,
        bounds: Rect.fromLTWH(
          bounds.left + pad,
          currentY,
          barcodeWidth,
          barcodeHeight,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
      currentY += barcodeHeight;
    }

    // Draw data text below barcode (for 1D barcodes)
    if (style.showText && type.is1D) {
      currentY += style.textSpacing;
      final font = captionFont ?? baseFont;
      graphics.drawString(
        data,
        font,
        brush: PdfSolidBrush(PdfColor(
          style.barColor.red,
          style.barColor.green,
          style.barColor.blue,
        )),
        bounds: Rect.fromLTWH(
          bounds.left + pad,
          currentY,
          barcodeWidth,
          style.captionFontSize + 4,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
      currentY += style.captionFontSize + 4;
    }

    // Draw caption below if position is below
    if (displayCaption != null &&
        style.captionPosition == GeniusPdfCaptionPosition.below) {
      currentY += style.textSpacing;
      final font = captionFont ?? baseFont;
      graphics.drawString(
        displayCaption,
        font,
        brush: PdfSolidBrush(PdfColor(
          style.captionColor.red,
          style.captionColor.green,
          style.captionColor.blue,
        )),
        bounds: Rect.fromLTWH(
          bounds.left + pad,
          currentY,
          barcodeWidth,
          style.captionFontSize + 4,
        ),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      currentY += style.captionFontSize + 4;
    }

    currentY += pad;

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      currentY - bounds.top,
    );
  }

  /// Generates barcode image as PNG bytes.
  Uint8List _generateBarcodeImage(int imageWidth, int imageHeight) {
    final barcode = _getBarcodeInstance();

    // Generate the barcode binary data
    final barcodeData = barcode.make(data,
        width: imageWidth.toDouble(), height: imageHeight.toDouble());

    // Create image using image package
    final image = img.Image(width: imageWidth, height: imageHeight);

    // Fill background
    final bgColor = img.ColorRgba8(
      style.backgroundColor.red,
      style.backgroundColor.green,
      style.backgroundColor.blue,
      255,
    );
    img.fill(image, color: bgColor);

    // Draw barcode bars
    final fgColor = img.ColorRgba8(
      style.barColor.red,
      style.barColor.green,
      style.barColor.blue,
      255,
    );

    for (final element in barcodeData) {
      if ((element is bc.BarcodeBar) && element.black) {
        final x1 = element.left.clamp(0, imageWidth - 1).toInt();
        final y1 = element.top.clamp(0, imageHeight - 1).toInt();
        final x2 = (element.left + element.width).clamp(0, imageWidth).toInt();
        final y2 = (element.top + element.height).clamp(0, imageHeight).toInt();

        for (int y = y1; y < y2; y++) {
          for (int x = x1; x < x2; x++) {
            image.setPixel(x, y, fgColor);
          }
        }
      }
    }

    return Uint8List.fromList(img.encodePng(image));
  }

  /// Gets the barcode instance for the type.
  bc.Barcode _getBarcodeInstance() {
    switch (type) {
      case GeniusBarcodeType.ean13:
        return bc.Barcode.ean13();
      case GeniusBarcodeType.ean8:
        return bc.Barcode.ean8();
      case GeniusBarcodeType.upcA:
        return bc.Barcode.upcA();
      case GeniusBarcodeType.code128:
        return bc.Barcode.code128();
      case GeniusBarcodeType.code39:
        return bc.Barcode.code39();
      case GeniusBarcodeType.itf:
        return bc.Barcode.itf();
      case GeniusBarcodeType.qrCode:
        return bc.Barcode.qrCode();
      case GeniusBarcodeType.dataMatrix:
        return bc.Barcode.dataMatrix();
      case GeniusBarcodeType.pdf417:
        return bc.Barcode.pdf417();
    }
  }
}

// ============================================================================
// GeniusPdfQRCodeGenerator - Dynamic QR Code Component
// ============================================================================

/// A dynamic QR code generator component for PDF documents.
///
/// Unlike [GeniusPdfQRCode] which requires pre-generated image data,
/// this component generates QR codes dynamically from string data.
///
/// Supports:
/// - Plain text/URLs
/// - ZATCA-compliant e-invoice data (TLV format)
/// - vCard contact data
/// - WiFi configuration
///
/// ## Example
/// ```dart
/// final qrCode = GeniusPdfQRCodeGenerator(
///   data: 'https://example.com/invoice/123',
///   caption: 'Scan for details',
///   captionAr: 'امسح للتفاصيل',
///   style: GeniusPdfQRCodeStyle.invoice(),
///   baseFont: config.baseFont,
///   isRTL: true,
/// );
///
/// qrCode.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfQRCodeGenerator {
  GeniusPdfQRCodeGenerator({
    required this.data,
    this.caption,
    this.captionAr,
    this.style = const GeniusPdfQRCodeStyle(),
    required this.baseFont,
    this.boldFont,
    this.captionFont,
    this.isRTL = true,
  });

  /// Creates a QR code for a URL.
  factory GeniusPdfQRCodeGenerator.url({
    required String url,
    String? caption,
    String? captionAr,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    return GeniusPdfQRCodeGenerator(
      data: url,
      caption: caption ?? 'Scan to open',
      captionAr: captionAr ?? 'امسح للفتح',
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Creates a ZATCA-compliant QR code for Saudi e-invoices.
  ///
  /// Encodes seller name, VAT number, timestamp, total, and VAT amount
  /// in TLV (Tag-Length-Value) format as per ZATCA requirements.
  factory GeniusPdfQRCodeGenerator.zatca({
    required String sellerName,
    required String vatNumber,
    required DateTime timestamp,
    required double total,
    required double vatAmount,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle.invoice(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    final tlvData = _encodeZatcaTlv(
      sellerName: sellerName,
      vatNumber: vatNumber,
      timestamp: timestamp,
      total: total,
      vatAmount: vatAmount,
    );

    return GeniusPdfQRCodeGenerator(
      data: tlvData,
      caption: 'ZATCA QR Code',
      captionAr: 'رمز هيئة الزكاة والضريبة',
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  /// Creates a WiFi configuration QR code.
  factory GeniusPdfQRCodeGenerator.wifi({
    required String ssid,
    required String password,
    String encryption = 'WPA',
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    final wifiData = 'WIFI:T:$encryption;S:$ssid;P:$password;;';

    return GeniusPdfQRCodeGenerator(
      data: wifiData,
      caption: 'WiFi: $ssid',
      captionAr: 'واي فاي: $ssid',
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  /// Creates a vCard QR code for contact information.
  factory GeniusPdfQRCodeGenerator.vCard({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? address,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle(),
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? captionFont,
    bool isRTL = true,
  }) {
    final vCardData = StringBuffer();
    vCardData.writeln('BEGIN:VCARD');
    vCardData.writeln('VERSION:3.0');
    vCardData.writeln('FN:$name');
    if (phone != null) vCardData.writeln('TEL:$phone');
    if (email != null) vCardData.writeln('EMAIL:$email');
    if (company != null) vCardData.writeln('ORG:$company');
    if (address != null) vCardData.writeln('ADR:;;$address');
    vCardData.writeln('END:VCARD');

    return GeniusPdfQRCodeGenerator(
      data: vCardData.toString(),
      caption: name,
      captionAr: name,
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      captionFont: captionFont,
      isRTL: isRTL,
    );
  }

  final String data;
  final String? caption;
  final String? captionAr;
  final GeniusPdfQRCodeStyle style;
  final PdfFont baseFont;
  final PdfFont? boldFont;
  final PdfFont? captionFont;
  final bool isRTL;

  /// Gets display caption based on locale.
  String? getCaption() {
    if (isRTL && captionAr != null) return captionAr;
    return caption;
  }

  /// Draws the QR code on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    final qrSize = style.size;
    final pad = style.padding;

    double currentY = bounds.top + pad;

    // Calculate total height for border
    double totalHeight = pad * 2 + qrSize;
    final displayCaption = getCaption();
    if (displayCaption != null) {
      totalHeight += style.captionSpacing + style.captionFontSize + 4;
    }

    // Draw border if enabled
    if (style.showBorder) {
      final borderWidth = qrSize + pad * 2;
      final borderX = bounds.left + (bounds.width - borderWidth) / 2;
      graphics.drawRectangle(
        pen: PdfPen(
          PdfColor(
            style.borderColor.red,
            style.borderColor.green,
            style.borderColor.blue,
          ),
          width: style.borderWidth,
        ),
        brush: PdfSolidBrush(PdfColor(
          style.backgroundColor.red,
          style.backgroundColor.green,
          style.backgroundColor.blue,
        )),
        bounds: Rect.fromLTWH(borderX, bounds.top, borderWidth, totalHeight),
      );
    }

    // Generate QR code image
    try {
      final qrImage = _generateQRCodeImage(qrSize.toInt());

      // Center QR code in bounds
      final qrX = bounds.left + (bounds.width - qrSize) / 2;
      graphics.drawImage(
        PdfBitmap(qrImage),
        Rect.fromLTWH(qrX, currentY, qrSize, qrSize),
      );
      currentY += qrSize;
    } catch (e) {
      // Draw error placeholder
      graphics.drawString(
        'QR Error: $e',
        baseFont,
        brush: PdfBrushes.red,
        bounds: Rect.fromLTWH(
          bounds.left + pad,
          currentY,
          bounds.width - pad * 2,
          qrSize,
        ),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
      currentY += qrSize;
    }

    // Draw caption
    if (displayCaption != null) {
      currentY += style.captionSpacing;
      final font = captionFont ?? baseFont;
      graphics.drawString(
        displayCaption,
        font,
        brush: PdfSolidBrush(PdfColor(
          style.captionColor.red,
          style.captionColor.green,
          style.captionColor.blue,
        )),
        bounds: Rect.fromLTWH(
          bounds.left,
          currentY,
          bounds.width,
          style.captionFontSize + 4,
        ),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      currentY += style.captionFontSize + 4;
    }

    currentY += pad;

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      currentY - bounds.top,
    );
  }

  /// Generates QR code image as PNG bytes.
  Uint8List _generateQRCodeImage(int size) {
    final qrCode = bc.Barcode.qrCode();
    final qrData =
        qrCode.make(data, width: size.toDouble(), height: size.toDouble());

    // Create image
    final image = img.Image(width: size, height: size);

    // Fill background
    final bgColor = img.ColorRgba8(
      style.backgroundColor.red,
      style.backgroundColor.green,
      style.backgroundColor.blue,
      255,
    );
    img.fill(image, color: bgColor);

    // Draw QR modules
    final fgColor = img.ColorRgba8(
      style.foregroundColor.red,
      style.foregroundColor.green,
      style.foregroundColor.blue,
      255,
    );

    for (final element in qrData) {
      if ((element is bc.BarcodeBar) && element.black) {
        final x1 = element.left.clamp(0, size - 1).toInt();
        final y1 = element.top.clamp(0, size - 1).toInt();
        final x2 = (element.left + element.width).clamp(0, size).toInt();
        final y2 = (element.top + element.height).clamp(0, size).toInt();

        for (int y = y1; y < y2; y++) {
          for (int x = x1; x < x2; x++) {
            image.setPixel(x, y, fgColor);
          }
        }
      }
    }

    return Uint8List.fromList(img.encodePng(image));
  }

  /// Encodes ZATCA TLV data as Base64.
  ///
  /// ZATCA requires 5 TLV fields:
  /// - Tag 1: Seller Name
  /// - Tag 2: VAT Registration Number
  /// - Tag 3: Timestamp (ISO 8601)
  /// - Tag 4: Invoice Total
  /// - Tag 5: VAT Amount
  static String _encodeZatcaTlv({
    required String sellerName,
    required String vatNumber,
    required DateTime timestamp,
    required double total,
    required double vatAmount,
  }) {
    final buffer = <int>[];

    // Tag 1: Seller Name
    final sellerBytes = utf8.encode(sellerName);
    buffer.add(1);
    buffer.add(sellerBytes.length);
    buffer.addAll(sellerBytes);

    // Tag 2: VAT Registration Number
    final vatBytes = utf8.encode(vatNumber);
    buffer.add(2);
    buffer.add(vatBytes.length);
    buffer.addAll(vatBytes);

    // Tag 3: Timestamp (ISO 8601)
    final timestampStr = timestamp.toIso8601String();
    final timestampBytes = utf8.encode(timestampStr);
    buffer.add(3);
    buffer.add(timestampBytes.length);
    buffer.addAll(timestampBytes);

    // Tag 4: Invoice Total
    final totalStr = total.toStringAsFixed(2);
    final totalBytes = utf8.encode(totalStr);
    buffer.add(4);
    buffer.add(totalBytes.length);
    buffer.addAll(totalBytes);

    // Tag 5: VAT Amount
    final vatStr = vatAmount.toStringAsFixed(2);
    final vatAmountBytes = utf8.encode(vatStr);
    buffer.add(5);
    buffer.add(vatAmountBytes.length);
    buffer.addAll(vatAmountBytes);

    return base64.encode(buffer);
  }
}
