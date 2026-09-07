// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart' as bc;
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/barcode_models.dart';
import '../../../../core/pdf_config.dart';
import '../../../../core/directionality.dart';
import '../../../../core/component_directionality.dart';
import '../../../../core/pdf_logger.dart';

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
    required this.config,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    GeniusPdfBarcodeStyle? style,
    this.width,
    this.height,
  }) : style = style ?? const GeniusPdfBarcodeStyle();

  /// Creates an EAN-13 barcode.
  factory GeniusPdfBarcode.ean13({
    required String data,
    String? caption,
    String? captionAr,
    required GeniusPdfConfig config,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle.retail(),
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.ean13,
      caption: caption,
      captionAr: captionAr,
      config: config,
      style: style,
    );
  }

  /// Creates a Code128 barcode.
  factory GeniusPdfBarcode.code128({
    required String data,
    String? caption,
    String? captionAr,
    required GeniusPdfConfig config,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle(),
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.code128,
      caption: caption,
      captionAr: captionAr,
      config: config,
      style: style,
    );
  }

  /// Creates a shipping/tracking barcode.
  factory GeniusPdfBarcode.shipping({
    required String data,
    String trackingLabel = 'Tracking Number',
    String trackingLabelAr = 'رقم التتبع',
    required GeniusPdfConfig config,
  }) {
    return GeniusPdfBarcode(
      data: data,
      type: GeniusBarcodeType.code128,
      caption: trackingLabel,
      captionAr: trackingLabelAr,
      style: const GeniusPdfBarcodeStyle.shipping(),
      config: config,
    );
  }

  final String data;
  final GeniusBarcodeType type;
  final String? caption;
  final String? captionAr;
  final GeniusPdfBarcodeStyle style;
  final GeniusPdfConfig config;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );
  bool get _isRtl => _effectiveDirectionality.resolve().direction == GeniusPdfResolvedDirection.rtl;
  final double? width;
  final double? height;

  /// Gets display caption based on locale.
  String? getCaption() {
    if (_isRtl && captionAr != null) return captionAr;
    return caption ?? captionAr;
  }

  /// Draws the barcode on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug(
        'Drawing barcode: ${type.name} data="${data.length > 20 ? '${data.substring(0, 20)}...' : data}"',
        tag: 'Barcode');
    final graphics = page.graphics;
    final pad = style.padding;
    final validation = GeniusBarcodeValidator.validate(data: data, type: type);
    if (!validation.isValid) {
      throw StateError(
        validation.getErrorMessage(isRTL: _isRtl) ??
            'Invalid ${type.name} barcode data',
      );
    }

    // Calculate barcode dimensions
    final barcodeWidth = (width ?? bounds.width) - (pad * 2);
    final barcodeHeight =
        (height ?? (type.is2D ? barcodeWidth : 60)) - (pad * 2);
    if (barcodeWidth <= 0 || barcodeHeight <= 0) {
      throw StateError(
        'Barcode bounds are too small for ${type.name}: '
        '${barcodeWidth.toStringAsFixed(1)}x${barcodeHeight.toStringAsFixed(1)}',
      );
    }

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
      final font = config.smallFont;
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
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
        ),
      );
      currentY += style.captionFontSize + style.textSpacing + 4;
    }

    final barcodeImage = _generateBarcodeImage(
      math.max(1, barcodeWidth.round()),
      math.max(1, barcodeHeight.round()),
    );

    // Draw barcode image
    final barcodeX = bounds.left + (bounds.width - barcodeWidth) / 2;
    graphics.drawImage(
      PdfBitmap(barcodeImage),
      Rect.fromLTWH(barcodeX, currentY, barcodeWidth, barcodeHeight),
    );
    currentY += barcodeHeight;

    // Draw data text below barcode (for 1D barcodes)
    if (style.showText && type.is1D) {
      currentY += style.textSpacing;
      final font = config.smallFont;
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
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.leftToRight
        ),
      );
      currentY += style.captionFontSize + 4;
    }

    // Draw caption below if position is below
    if (displayCaption != null &&
        style.captionPosition == GeniusPdfCaptionPosition.below) {
      currentY += style.textSpacing;
      final font = config.smallFont;
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
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
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
    try {
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
          final x2 =
              (element.left + element.width).clamp(0, imageWidth).toInt();
          final y2 =
              (element.top + element.height).clamp(0, imageHeight).toInt();

          for (int y = y1; y < y2; y++) {
            for (int x = x1; x < x2; x++) {
              image.setPixel(x, y, fgColor);
            }
          }
        }
      }

      return Uint8List.fromList(img.encodePng(image));
    } catch (error, stackTrace) {
      GeniusPdfLogger.error(
        'Barcode generation failed: ${type.name}',
        tag: 'Barcode',
        error: error,
        stackTrace: stackTrace,
      );
      throw StateError('Failed to render ${type.name} barcode: $error');
    }
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
/// );
///
/// qrCode.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfQRCodeGenerator {
  GeniusPdfQRCodeGenerator({
    required this.data,
    this.caption,
    this.captionAr,
    required this.config,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    GeniusPdfQRCodeStyle? style,
  }) : style = style ?? const GeniusPdfQRCodeStyle();

  /// Creates a QR code for a URL.
  factory GeniusPdfQRCodeGenerator.url({
    required String url,
    String? caption,
    String? captionAr,
    required GeniusPdfConfig config,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle(),
  }) {
    return GeniusPdfQRCodeGenerator(
      data: url,
      caption: caption ?? 'Scan to open',
      captionAr: captionAr ?? 'امسح للفتح',
      config: config,
      style: style,
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
    required GeniusPdfConfig config,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle.invoice(),
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
      config: config,
      style: style,
    );
  }

  /// Creates a WiFi configuration QR code.
  factory GeniusPdfQRCodeGenerator.wifi({
    required String ssid,
    required String password,
    String encryption = 'WPA',
    required GeniusPdfConfig config,
    GeniusPdfQRCodeStyle style = const GeniusPdfQRCodeStyle(),
  }) {
    final wifiData = 'WIFI:T:$encryption;S:$ssid;P:$password;;';

    return GeniusPdfQRCodeGenerator(
      data: wifiData,
      caption: 'WiFi: $ssid',
      captionAr: 'واي فاي: $ssid',
      config: config,
      style: style,
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
    required GeniusPdfConfig config,
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
      config: config,
    );
  }

  final String data;
  final String? caption;
  final String? captionAr;
  final GeniusPdfQRCodeStyle style;
  final GeniusPdfConfig config;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );
  bool get _isRtl => _effectiveDirectionality.resolve().direction == GeniusPdfResolvedDirection.rtl;

  /// Gets display caption based on locale.
  String? getCaption() {
    if (_isRtl && captionAr != null) return captionAr;
    return caption ?? captionAr;
  }

  /// Draws the QR code on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug(
        'Drawing QR code: data="${data.length > 30 ? '${data.substring(0, 30)}...' : data}"',
        tag: 'QRCode');
    final graphics = page.graphics;
    final qrValidation = GeniusBarcodeValidator.validate(
      data: data,
      type: GeniusBarcodeType.qrCode,
    );
    if (!qrValidation.isValid) {
      throw StateError(
        qrValidation.getErrorMessage(isRTL: _isRtl) ??
            'Invalid QR code data',
      );
    }

    final qrSize = math.min(style.size, math.min(bounds.width, bounds.height));
    final pad = style.padding;
    if (qrSize <= 0) {
      throw StateError('QR code bounds are too small to render');
    }

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

    final qrImage = _generateQRCodeImage(math.max(1, qrSize.round()));

    // Center QR code in bounds
    final qrX = bounds.left + (bounds.width - qrSize) / 2;
    graphics.drawImage(
      PdfBitmap(qrImage),
      Rect.fromLTWH(qrX, currentY, qrSize, qrSize),
    );
    currentY += qrSize;

    // Draw caption
    if (displayCaption != null) {
      currentY += style.captionSpacing;
      final font = config.smallFont;
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
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
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
    try {
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
    } catch (error, stackTrace) {
      GeniusPdfLogger.error(
        'QR code generation failed',
        tag: 'QRCode',
        error: error,
        stackTrace: stackTrace,
      );
      throw StateError('Failed to render QR code: $error');
    }
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

// ============================================================================
// GeniusBarcodeValidator - Barcode Data Validation
// ============================================================================

/// Validates barcode data for different formats.
class GeniusBarcodeValidator {
  /// Validates data for the given barcode type.
  static GeniusBarcodeValidationResult validate({
    required String data,
    required GeniusBarcodeType type,
  }) {
    switch (type) {
      case GeniusBarcodeType.ean13:
        return _validateEan13(data);
      case GeniusBarcodeType.ean8:
        return _validateEan8(data);
      case GeniusBarcodeType.upcA:
        return _validateUpcA(data);
      case GeniusBarcodeType.code128:
        return _validateCode128(data);
      case GeniusBarcodeType.code39:
        return _validateCode39(data);
      case GeniusBarcodeType.itf:
        return _validateItf(data);
      case GeniusBarcodeType.qrCode:
        return _validateQrCode(data);
      case GeniusBarcodeType.dataMatrix:
        return _validateDataMatrix(data);
      case GeniusBarcodeType.pdf417:
        return _validatePdf417(data);
    }
  }

  static GeniusBarcodeValidationResult _validateEan13(String data) {
    // EAN-13: exactly 12 or 13 digits (12 if no check digit)
    if (!RegExp(r'^\d{12,13}$').hasMatch(data)) {
      return GeniusBarcodeValidationResult.invalid(
        'EAN-13 requires exactly 12 or 13 digits',
        'رمز EAN-13 يتطلب 12 أو 13 رقم بالضبط',
      );
    }
    if (data.length == 13 && !_verifyCheckDigit(data, 13)) {
      return GeniusBarcodeValidationResult.invalid(
        'Invalid EAN-13 check digit',
        'رقم التحقق غير صحيح لـ EAN-13',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateEan8(String data) {
    // EAN-8: exactly 7 or 8 digits
    if (!RegExp(r'^\d{7,8}$').hasMatch(data)) {
      return GeniusBarcodeValidationResult.invalid(
        'EAN-8 requires exactly 7 or 8 digits',
        'رمز EAN-8 يتطلب 7 أو 8 أرقام بالضبط',
      );
    }
    if (data.length == 8 && !_verifyCheckDigit(data, 8)) {
      return GeniusBarcodeValidationResult.invalid(
        'Invalid EAN-8 check digit',
        'رقم التحقق غير صحيح لـ EAN-8',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateUpcA(String data) {
    // UPC-A: exactly 11 or 12 digits
    if (!RegExp(r'^\d{11,12}$').hasMatch(data)) {
      return GeniusBarcodeValidationResult.invalid(
        'UPC-A requires exactly 11 or 12 digits',
        'رمز UPC-A يتطلب 11 أو 12 رقم بالضبط',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateCode128(String data) {
    // Code128: ASCII characters 0-127
    if (data.isEmpty) {
      return GeniusBarcodeValidationResult.invalid(
        'Code128 requires at least one character',
        'رمز Code128 يتطلب حرف واحد على الأقل',
      );
    }
    for (final char in data.codeUnits) {
      if (char > 127) {
        return GeniusBarcodeValidationResult.invalid(
          'Code128 only supports ASCII characters',
          'رمز Code128 يدعم حروف ASCII فقط',
        );
      }
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateCode39(String data) {
    // Code39: A-Z, 0-9, -, ., $, /, +, %, space
    if (data.isEmpty) {
      return GeniusBarcodeValidationResult.invalid(
        'Code39 requires at least one character',
        'رمز Code39 يتطلب حرف واحد على الأقل',
      );
    }
    if (!RegExp(r'^[A-Z0-9\-\.\$\/\+\%\s]+$').hasMatch(data.toUpperCase())) {
      return GeniusBarcodeValidationResult.invalid(
        'Code39 only supports A-Z, 0-9, and special characters (- . \$ / + %)',
        'رمز Code39 يدعم A-Z و 0-9 والرموز الخاصة فقط',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateItf(String data) {
    // ITF: even number of digits
    if (!RegExp(r'^\d+$').hasMatch(data)) {
      return GeniusBarcodeValidationResult.invalid(
        'ITF requires only digits',
        'رمز ITF يتطلب أرقام فقط',
      );
    }
    if (data.length < 2 || data.length % 2 != 0) {
      return GeniusBarcodeValidationResult.invalid(
        'ITF requires an even number of digits (minimum 2)',
        'رمز ITF يتطلب عدد زوجي من الأرقام (حد أدنى 2)',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateQrCode(String data) {
    // QR Code: up to 4296 alphanumeric or 7089 numeric characters
    if (data.isEmpty) {
      return GeniusBarcodeValidationResult.invalid(
        'QR Code requires at least one character',
        'رمز QR يتطلب حرف واحد على الأقل',
      );
    }
    if (data.length > 4296) {
      return GeniusBarcodeValidationResult.invalid(
        'QR Code data exceeds maximum length (4296 characters)',
        'بيانات رمز QR تتجاوز الحد الأقصى (4296 حرف)',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validateDataMatrix(String data) {
    // DataMatrix: up to 2335 alphanumeric or 3116 numeric characters
    if (data.isEmpty) {
      return GeniusBarcodeValidationResult.invalid(
        'DataMatrix requires at least one character',
        'رمز DataMatrix يتطلب حرف واحد على الأقل',
      );
    }
    if (data.length > 2335) {
      return GeniusBarcodeValidationResult.invalid(
        'DataMatrix data exceeds maximum length (2335 characters)',
        'بيانات DataMatrix تتجاوز الحد الأقصى (2335 حرف)',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  static GeniusBarcodeValidationResult _validatePdf417(String data) {
    // PDF417: up to 1850 text characters
    if (data.isEmpty) {
      return GeniusBarcodeValidationResult.invalid(
        'PDF417 requires at least one character',
        'رمز PDF417 يتطلب حرف واحد على الأقل',
      );
    }
    if (data.length > 1850) {
      return GeniusBarcodeValidationResult.invalid(
        'PDF417 data exceeds maximum length (1850 characters)',
        'بيانات PDF417 تتجاوز الحد الأقصى (1850 حرف)',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }

  /// Verifies check digit for EAN/UPC barcodes.
  static bool _verifyCheckDigit(String data, int length) {
    int sum = 0;
    for (int i = 0; i < length - 1; i++) {
      final digit = int.parse(data[i]);
      sum += digit * (i % 2 == 0 ? 1 : 3);
    }
    final checkDigit = (10 - (sum % 10)) % 10;
    return checkDigit == int.parse(data[length - 1]);
  }

  /// Calculates check digit for EAN-13.
  static String calculateEan13CheckDigit(String data12) {
    if (data12.length != 12) return '';
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      final digit = int.parse(data12[i]);
      sum += digit * (i % 2 == 0 ? 1 : 3);
    }
    final checkDigit = (10 - (sum % 10)) % 10;
    return '$data12$checkDigit';
  }
}

/// Result of barcode validation.
class GeniusBarcodeValidationResult {
  const GeniusBarcodeValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.errorMessageAr,
  });

  /// Creates an valid result with error message.
  factory GeniusBarcodeValidationResult.valid() {
    return const GeniusBarcodeValidationResult._(isValid: true);
  }

  /// Creates an invalid result with error message.
  factory GeniusBarcodeValidationResult.invalid(
      String message, String messageAr) {
    return GeniusBarcodeValidationResult._(
      isValid: false,
      errorMessage: message,
      errorMessageAr: messageAr,
    );
  }

  /// Whether the data is valid.
  final bool isValid;

  /// Error message in English.
  final String? errorMessage;

  /// Error message in Arabic.
  final String? errorMessageAr;

  /// Gets error message based on locale.
  String? getErrorMessage({bool isRTL = false}) {
    return isRTL ? errorMessageAr : errorMessage;
  }
}

// ============================================================================
// GeniusBarcodeGroup - Multiple Barcodes in a Row/Column
// ============================================================================

/// Layout direction for barcode groups.
enum GeniusBarcodeGroupLayout {
  /// Arrange barcodes horizontally.
  horizontal,

  /// Arrange barcodes vertically.
  vertical,

  /// Grid layout with specified columns.
  grid,
}

/// A group of barcodes arranged in a layout.
class GeniusBarcodeGroup {
  GeniusBarcodeGroup({
    required this.barcodes,
    required this.config,
    this.layout = GeniusBarcodeGroupLayout.horizontal,
    this.spacing = 16.0,
    this.gridColumns = 2,
    this.groupTitle,
    this.groupTitleAr,
  });

  /// List of barcodes to display.
  final List<GeniusPdfBarcode> barcodes;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Layout direction.
  final GeniusBarcodeGroupLayout layout;

  /// Spacing between barcodes.
  final double spacing;

  /// Number of columns for grid layout.
  final int gridColumns;

  /// Group title in English.
  final String? groupTitle;

  /// Group title in Arabic.
  final String? groupTitleAr;

  /// Gets display title based on locale.
  String? getTitle() {
    if (config.isRTL && groupTitleAr != null) return groupTitleAr;
    return groupTitle;
  }

  /// Draws the barcode group on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    double currentY = bounds.top;

    // Draw title if present
    final title = getTitle();
    if (title != null) {
      final titleFont = config.boldFont;
      graphics.drawString(
        title,
        titleFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width, 20),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: config.pdfTextDirection
        ),
      );
      currentY += 24;
    }

    switch (layout) {
      case GeniusBarcodeGroupLayout.horizontal:
        return _drawHorizontal(
            page,
            Rect.fromLTWH(bounds.left, currentY, bounds.width,
                bounds.height - (currentY - bounds.top)));
      case GeniusBarcodeGroupLayout.vertical:
        return _drawVertical(
            page,
            Rect.fromLTWH(bounds.left, currentY, bounds.width,
                bounds.height - (currentY - bounds.top)));
      case GeniusBarcodeGroupLayout.grid:
        return _drawGrid(
            page,
            Rect.fromLTWH(bounds.left, currentY, bounds.width,
                bounds.height - (currentY - bounds.top)));
    }
  }

  Rect _drawHorizontal(PdfPage page, Rect bounds) {
    final itemWidth =
        (bounds.width - (spacing * (barcodes.length - 1))) / barcodes.length;
    double maxHeight = 0;

    for (int i = 0; i < barcodes.length; i++) {
      final x = bounds.left + (itemWidth + spacing) * i;
      final result = barcodes[i].draw(
        page: page,
        bounds: Rect.fromLTWH(x, bounds.top, itemWidth, bounds.height),
      );
      if (result.height > maxHeight) {
        maxHeight = result.height;
      }
    }

    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, maxHeight);
  }

  Rect _drawVertical(PdfPage page, Rect bounds) {
    double currentY = bounds.top;

    for (int i = 0; i < barcodes.length; i++) {
      final result = barcodes[i].draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width,
            bounds.height - (currentY - bounds.top)),
      );
      currentY += result.height + spacing;
    }

    return Rect.fromLTWH(
        bounds.left, bounds.top, bounds.width, currentY - bounds.top - spacing);
  }

  Rect _drawGrid(PdfPage page, Rect bounds) {
    if (barcodes.isEmpty) {
      return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0);
    }
    final cols = gridColumns.clamp(1, barcodes.length).toInt();
    final itemWidth = (bounds.width - (spacing * (cols - 1))) / cols;
    const itemHeight = 100.0; // Estimated height per barcode

    double maxY = bounds.top;

    for (int i = 0; i < barcodes.length; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final x = bounds.left + (itemWidth + spacing) * col;
      final y = bounds.top + (itemHeight + spacing) * row;

      final result = barcodes[i].draw(
        page: page,
        bounds: Rect.fromLTWH(x, y, itemWidth, itemHeight),
      );

      if (y + result.height > maxY) {
        maxY = y + result.height;
      }
    }

    return Rect.fromLTWH(
        bounds.left, bounds.top, bounds.width, maxY - bounds.top);
  }
}

// ============================================================================
// GeniusBarcodeGenerator - Utility for Batch Generation
// ============================================================================

/// Utility class for generating multiple barcodes.
class GeniusBarcodeGenerator {
  /// Generates a sequence of barcodes with incrementing data.
  static List<GeniusPdfBarcode> generateSequence({
    required String prefix,
    required int start,
    required int count,
    required GeniusBarcodeType type,
    required GeniusPdfConfig config,
    int padLength = 6,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle(),
  }) {
    return List.generate(count, (i) {
      final number = (start + i).toString().padLeft(padLength, '0');
      final data = '$prefix$number';
      return GeniusPdfBarcode(
        data: data,
        type: type,
        config: config,
        style: style,
      );
    });
  }

  /// Generates barcodes from a list of data.
  static List<GeniusPdfBarcode> fromDataList({
    required List<String> dataList,
    required GeniusBarcodeType type,
    required GeniusPdfConfig config,
    GeniusPdfBarcodeStyle style = const GeniusPdfBarcodeStyle(),
  }) {
    return dataList
        .map((data) => GeniusPdfBarcode(
              data: data,
              type: type,
              config: config,
              style: style,
            ))
        .toList();
  }

  /// Validates all data in a list before generating barcodes.
  static List<GeniusBarcodeValidationResult> validateDataList({
    required List<String> dataList,
    required GeniusBarcodeType type,
  }) {
    return dataList
        .map((data) => GeniusBarcodeValidator.validate(data: data, type: type))
        .toList();
  }
}
