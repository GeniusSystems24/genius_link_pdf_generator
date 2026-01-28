import 'dart:ui';

/// Supported barcode types.
enum GeniusBarcodeType {
  /// EAN-13 barcode (13-digit product code).
  ean13,

  /// EAN-8 barcode (8-digit product code).
  ean8,

  /// UPC-A barcode (12-digit product code).
  upcA,

  /// Code 128 barcode (variable-length alphanumeric).
  code128,

  /// Code 39 barcode (alphanumeric + special characters).
  code39,

  /// ITF (Interleaved 2 of 5) barcode.
  itf,

  /// QR Code (2D matrix barcode).
  qrCode,

  /// DataMatrix (2D barcode).
  dataMatrix,

  /// PDF417 (2D stacked barcode).
  pdf417,
}

/// Whether the barcode is 1D or 2D.
extension GeniusBarcodeTypeExtension on GeniusBarcodeType {
  bool get is2D =>
      this == GeniusBarcodeType.qrCode ||
      this == GeniusBarcodeType.dataMatrix ||
      this == GeniusBarcodeType.pdf417;

  bool get is1D => !is2D;

  String get displayName {
    switch (this) {
      case GeniusBarcodeType.ean13:
        return 'EAN-13';
      case GeniusBarcodeType.ean8:
        return 'EAN-8';
      case GeniusBarcodeType.upcA:
        return 'UPC-A';
      case GeniusBarcodeType.code128:
        return 'Code 128';
      case GeniusBarcodeType.code39:
        return 'Code 39';
      case GeniusBarcodeType.itf:
        return 'ITF';
      case GeniusBarcodeType.qrCode:
        return 'QR Code';
      case GeniusBarcodeType.dataMatrix:
        return 'DataMatrix';
      case GeniusBarcodeType.pdf417:
        return 'PDF417';
    }
  }
}

/// Error correction level for QR codes.
enum GeniusQRErrorCorrection {
  /// ~7% recovery capacity.
  low,

  /// ~15% recovery capacity.
  medium,

  /// ~25% recovery capacity.
  quartile,

  /// ~30% recovery capacity.
  high,
}

/// Caption position relative to the barcode.
enum GeniusPdfCaptionPosition {
  /// Caption above the barcode.
  above,

  /// Caption below the barcode.
  below,
}

/// Style configuration for [GeniusPdfBarcode].
class GeniusPdfBarcodeStyle {
  const GeniusPdfBarcodeStyle({
    this.barColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.showText = true,
    this.textSpacing = 4.0,
    this.padding = 8.0,
    this.showBorder = false,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderWidth = 0.5,
    this.captionPosition = GeniusPdfCaptionPosition.below,
    this.captionFontSize = 8.0,
    this.captionColor = const Color(0xFF666666),
  });

  /// Creates a retail/product barcode style (EAN-13, UPC-A).
  const GeniusPdfBarcodeStyle.retail()
      : barColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        showText = true,
        textSpacing = 4.0,
        padding = 10.0,
        showBorder = false,
        borderColor = const Color(0xFFE0E0E0),
        borderWidth = 0.5,
        captionPosition = GeniusPdfCaptionPosition.below,
        captionFontSize = 8.0,
        captionColor = const Color(0xFF666666);

  /// Creates a shipping/logistics barcode style.
  const GeniusPdfBarcodeStyle.shipping()
      : barColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        showText = true,
        textSpacing = 6.0,
        padding = 12.0,
        showBorder = true,
        borderColor = const Color(0xFF333333),
        borderWidth = 1.0,
        captionPosition = GeniusPdfCaptionPosition.above,
        captionFontSize = 9.0,
        captionColor = const Color(0xFF333333);

  /// Creates a compact barcode style for limited space.
  const GeniusPdfBarcodeStyle.compact()
      : barColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        showText = false,
        textSpacing = 2.0,
        padding = 4.0,
        showBorder = false,
        borderColor = const Color(0xFFE0E0E0),
        borderWidth = 0.5,
        captionPosition = GeniusPdfCaptionPosition.below,
        captionFontSize = 7.0,
        captionColor = const Color(0xFF999999);

  /// Creates a document-style barcode with border.
  const GeniusPdfBarcodeStyle.document()
      : barColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        showText = true,
        textSpacing = 4.0,
        padding = 12.0,
        showBorder = true,
        borderColor = const Color(0xFFCCCCCC),
        borderWidth = 0.5,
        captionPosition = GeniusPdfCaptionPosition.below,
        captionFontSize = 8.0,
        captionColor = const Color(0xFF555555);

  final Color barColor;
  final Color backgroundColor;
  final bool showText;
  final double textSpacing;
  final double padding;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;
  final GeniusPdfCaptionPosition captionPosition;
  final double captionFontSize;
  final Color captionColor;
}

/// Style configuration for QR code components.
class GeniusPdfQRCodeStyle {
  const GeniusPdfQRCodeStyle({
    this.foregroundColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.size = 100.0,
    this.padding = 8.0,
    this.showBorder = false,
    this.borderColor = const Color(0xFFE0E0E0),
    this.borderWidth = 0.5,
    this.errorCorrection = GeniusQRErrorCorrection.medium,
    this.captionFontSize = 8.0,
    this.captionColor = const Color(0xFF666666),
    this.captionSpacing = 4.0,
    this.quietZone = 4,
  });

  /// Creates a QR code style optimized for invoices (ZATCA).
  const GeniusPdfQRCodeStyle.invoice()
      : foregroundColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        size = 100.0,
        padding = 8.0,
        showBorder = true,
        borderColor = const Color(0xFFCCCCCC),
        borderWidth = 0.5,
        errorCorrection = GeniusQRErrorCorrection.medium,
        captionFontSize = 7.0,
        captionColor = const Color(0xFF555555),
        captionSpacing = 4.0,
        quietZone = 4;

  /// Creates a QR code style for payment links.
  const GeniusPdfQRCodeStyle.payment()
      : foregroundColor = const Color(0xFF006C35),
        backgroundColor = const Color(0xFFFFFFFF),
        size = 120.0,
        padding = 10.0,
        showBorder = true,
        borderColor = const Color(0xFF006C35),
        borderWidth = 1.0,
        errorCorrection = GeniusQRErrorCorrection.high,
        captionFontSize = 9.0,
        captionColor = const Color(0xFF006C35),
        captionSpacing = 6.0,
        quietZone = 4;

  /// Creates a compact QR code for limited space.
  const GeniusPdfQRCodeStyle.compact()
      : foregroundColor = const Color(0xFF000000),
        backgroundColor = const Color(0xFFFFFFFF),
        size = 60.0,
        padding = 4.0,
        showBorder = false,
        borderColor = const Color(0xFFE0E0E0),
        borderWidth = 0.5,
        errorCorrection = GeniusQRErrorCorrection.low,
        captionFontSize = 7.0,
        captionColor = const Color(0xFF999999),
        captionSpacing = 2.0,
        quietZone = 2;

  /// Creates a branded QR code with custom colors.
  factory GeniusPdfQRCodeStyle.branded({
    required Color primaryColor,
    Color? backgroundColor,
    double size = 100.0,
  }) {
    return GeniusPdfQRCodeStyle(
      foregroundColor: primaryColor,
      backgroundColor: backgroundColor ?? const Color(0xFFFFFFFF),
      size: size,
      padding: 10.0,
      showBorder: true,
      borderColor: primaryColor,
      borderWidth: 1.0,
      errorCorrection: GeniusQRErrorCorrection.high,
      captionFontSize: 8.0,
      captionColor: primaryColor,
      captionSpacing: 4.0,
    );
  }

  final Color foregroundColor;
  final Color backgroundColor;
  final double size;
  final double padding;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;
  final GeniusQRErrorCorrection errorCorrection;
  final double captionFontSize;
  final Color captionColor;
  final double captionSpacing;
  final int quietZone;
}
