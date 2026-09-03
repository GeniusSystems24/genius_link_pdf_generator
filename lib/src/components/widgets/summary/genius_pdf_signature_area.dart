part of '../pdf_summary.dart';

/// A signature area component for documents requiring signatures.
class GeniusPdfSignatureArea {
  GeniusPdfSignatureArea({
    required this.config,
    this.title,
    this.titleAr,
    this.lineWidth = 150,
    this.lineY,
    this.showDate = true,
    this.dateLabel = 'Date',
    this.dateLabelAr = 'التاريخ',
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.signatureImage,
    this.signatureImageHeight = 36,
  });

  final GeniusPdfConfig config;
  final String? title;
  final String? titleAr;
  final double lineWidth;
  final double? lineY;
  final bool showDate;
  final String dateLabel;
  final String dateLabelAr;

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  /// Optional signature image; pixels are never mirrored.
  final GeniusPdfImage? signatureImage;
  final double signatureImageHeight;

  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );
  bool get _isRtl => _effectiveDirectionality.resolve().direction == GeniusPdfResolvedDirection.rtl;

  /// Gets the display title based on locale.
  String? getTitle() {
    if (_isRtl && titleAr != null) return titleAr;
    return title;
  }

  /// Gets the date label based on locale.
  String getDateLabel() {
    return _isRtl ? dateLabelAr : dateLabel;
  }

  /// Draws the signature area on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    double currentY = bounds.top;

    final displayTitle = getTitle();
    // Font - baseFont is required, no fallback to Helvetica
    final font = config.baseFont;

    // Draw title
    if (displayTitle != null) {
      graphics.drawString(
        displayTitle,
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width, 0),
        format: PdfStringFormat(
          alignment:
              _isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
        ),
      );
      currentY += 20;
    }

    // Draw signature line
    final signatureY = lineY ?? currentY + 30;
    final lineX = _isRtl ? bounds.right - lineWidth : bounds.left;

    graphics.drawLine(
      PdfPen(const Color(0xFF000000).toPdfColor(), width: 0.5),
      Offset(lineX, signatureY),
      Offset(lineX + lineWidth, signatureY),
    );

    if (signatureImage != null) {
      final image = signatureImage!.scaledToFit(
        maxWidth: lineWidth,
        maxHeight: signatureImageHeight,
      );
      final imageX = lineX + (lineWidth - image.width) / 2;
      final imageY = signatureY - image.height - 4;
      graphics.drawImage(
        PdfBitmap(image.data),
        Rect.fromLTWH(imageX, imageY, image.width, image.height),
      );
    }

    // Draw date line if needed
    if (showDate) {
      final dateLineX = _isRtl ? bounds.left : bounds.right - 100;
      graphics.drawLine(
        PdfPen(const Color(0xFF000000).toPdfColor(), width: 0.5),
        Offset(dateLineX, signatureY),
        Offset(dateLineX + 100, signatureY),
      );

      graphics.drawString(
        getDateLabel(),
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(dateLineX, signatureY + 2, 100, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: GeniusPdfComponentDirectionality.pdfDirection(_effectiveDirectionality.resolve().direction)
        ),
      );
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      signatureY + 20 - bounds.top,
    );
  }
}
