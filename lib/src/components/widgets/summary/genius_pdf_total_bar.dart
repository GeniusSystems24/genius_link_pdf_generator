part of '../pdf_summary.dart';

/// A horizontal total bar for displaying a single total prominently.
///
/// Useful for displaying grand totals at the bottom of reports.
class GeniusPdfTotalBar {
  GeniusPdfTotalBar({
    required this.config,
    required this.label,
    required this.value,
    this.labelAr,
    this.backgroundColor = const Color(0xFF1565C0),
    this.textColor = const Color(0xFFFFFFFF),
    this.borderStyle = const GeniusPdfBorderStyle.none(),
    this.padding =
        const GeniusPdfCellPadding.symmetric(horizontal: 12, vertical: 8),
    this.fontSize = 12,
  });

  final GeniusPdfConfig config;
  final String label;
  final String? labelAr;
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final GeniusPdfBorderStyle borderStyle;
  final GeniusPdfCellPadding padding;
  final double fontSize;

  /// Gets the display label based on locale.
  String getLabel() {
    if (config.isRTL && labelAr != null) return labelAr!;
    return label;
  }

  /// Draws the total bar on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    final barHeight = fontSize * 1.5 + padding.top + padding.bottom;

    final barBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      barHeight,
    );

    // Draw background
    graphics.drawRectangle(
      brush: PdfSolidBrush(backgroundColor.toPdfColor()),
      bounds: barBounds,
    );

    // Draw border
    if (borderStyle.width > 0) {
      final pen = borderStyle.toPen();
      if (borderStyle.top) {
        graphics.drawLine(pen, barBounds.topLeft, barBounds.topRight);
      }
      if (borderStyle.bottom) {
        graphics.drawLine(pen, barBounds.bottomLeft, barBounds.bottomRight);
      }
      if (borderStyle.left) {
        graphics.drawLine(pen, barBounds.topLeft, barBounds.bottomLeft);
      }
      if (borderStyle.right) {
        graphics.drawLine(pen, barBounds.topRight, barBounds.bottomRight);
      }
    }

    // Draw label and value
    final textY = bounds.top + padding.top;
    final textBrush = PdfSolidBrush(textColor.toPdfColor());
    // Font - baseFont and boldFont are required, no fallback to Helvetica
    final font = config.boldFont;

    final contentWidth = bounds.width - padding.left - padding.right;
    final halfWidth = contentWidth / 2;

    // Label
    graphics.drawString(
      getLabel(),
      font,
      brush: textBrush,
      bounds: Rect.fromLTWH(
        config.isRTL
            ? bounds.left + padding.left + halfWidth
            : bounds.left + padding.left,
        textY,
        halfWidth,
        0,
      ),
      format: PdfStringFormat(
        alignment: config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection:
            config.isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      ),
    );

    // Value
    graphics.drawString(
      value,
      font,
      brush: textBrush,
      bounds: Rect.fromLTWH(
        config.isRTL
            ? bounds.left + padding.left
            : bounds.left + padding.left + halfWidth,
        textY,
        halfWidth,
        0,
      ),
      format: PdfStringFormat(
        alignment: config.isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: config.pdfTextDirection,
      ),
    );

    return barBounds;
  }
}
