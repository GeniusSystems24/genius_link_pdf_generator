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
  });

  final GeniusPdfConfig config;
  final String? title;
  final String? titleAr;
  final double lineWidth;
  final double? lineY;
  final bool showDate;
  final String dateLabel;
  final String dateLabelAr;

  /// Gets the display title based on locale.
  String? getTitle() {
    if (config.isRTL && titleAr != null) return titleAr;
    return title;
  }

  /// Gets the date label based on locale.
  String getDateLabel() {
    return config.isRTL ? dateLabelAr : dateLabel;
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
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: config.isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      currentY += 20;
    }

    // Draw signature line
    final signatureY = lineY ?? currentY + 30;
    final lineX = config.isRTL ? bounds.right - lineWidth : bounds.left;

    graphics.drawLine(
      PdfPen(const Color(0xFF000000).toPdfColor(), width: 0.5),
      Offset(lineX, signatureY),
      Offset(lineX + lineWidth, signatureY),
    );

    // Draw date line if needed
    if (showDate) {
      final dateLineX = config.isRTL ? bounds.left : bounds.right - 100;
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
          textDirection: config.isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
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
