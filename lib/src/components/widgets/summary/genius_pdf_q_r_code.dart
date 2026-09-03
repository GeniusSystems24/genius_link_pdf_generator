part of '../pdf_summary.dart';

/// A QR code component for invoices and documents.
///
/// Note: This component requires QR code data to be pre-generated as an image.
class GeniusPdfQRCode {
  GeniusPdfQRCode({
    required this.config,
    required this.image,
    this.size = 80,
    this.caption,
    this.captionAr,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
  });

  final GeniusPdfConfig config;
  final GeniusPdfImage image;
  final double size;
  final String? caption;
  final String? captionAr;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );
  bool get _isRtl => _effectiveDirectionality.resolve().direction == GeniusPdfResolvedDirection.rtl;

  /// Gets the display caption based on locale.
  String? getCaption() {
    if (_isRtl && captionAr != null) return captionAr;
    return caption;
  }

  /// Draws the QR code on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;

    // Scale image to size
    final scaledImage = image.scaledToFit(maxWidth: size, maxHeight: size);

    // Center QR code in bounds
    final qrX = bounds.left + (bounds.width - scaledImage.width) / 2;
    final qrY = bounds.top;

    graphics.drawImage(
      PdfBitmap(scaledImage.data),
      Rect.fromLTWH(qrX, qrY, scaledImage.width, scaledImage.height),
    );

    double totalHeight = scaledImage.height;

    // Draw caption
    final displayCaption = getCaption();
    if (displayCaption != null) {
      // Font - baseFont is required, no fallback to Helvetica
      final font = config.baseFont;
      graphics.drawString(
        displayCaption,
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
          bounds.left,
          qrY + scaledImage.height + 4,
          bounds.width,
          0,
        ),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
        ),
      );
      totalHeight += 16;
    }

    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, totalHeight);
  }
}
