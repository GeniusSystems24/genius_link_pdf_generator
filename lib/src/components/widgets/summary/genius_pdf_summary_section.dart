part of '../pdf_summary.dart';

/// A summary section component for displaying totals and calculations.
///
/// [GeniusPdfSummarySection] is commonly used at the bottom of invoices
/// for subtotals, taxes, and grand totals.
///
/// ## Example
/// ```dart
/// final summary = PdfSummarySection(
///   items: [
///     PdfSummaryItem.subtotal(
///       label: 'Subtotal',
///       labelAr: 'المجموع الفرعي',
///       value: '30,100.00 SAR',
///     ),
///     PdfSummaryItem(
///       label: 'VAT (15%)',
///       labelAr: 'ضريبة القيمة المضافة (15%)',
///       value: '4,515.00 SAR',
///     ),
///     PdfSummaryItem.total(
///       label: 'Total Amount',
///       labelAr: 'الإجمالي',
///       value: '34,615.00 SAR',
///     ),
///   ],
/// );
///
/// summary.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfSummarySection {
  GeniusPdfSummarySection({
    required this.items,
    this.title,
    this.titleAr,
    required this.config,
    GeniusPdfSummaryStyle? style,
    this.alignment = GeniusPdfSummaryAlignment.right,
    this.width,
  }) : style = _resolveSummaryStyle(style, config);

  /// Summary items to display.
  final List<GeniusPdfSummaryItem> items;

  /// Section title (optional).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Style configuration.
  final GeniusPdfSummaryStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Base font for text.
  PdfFont get baseFont => config.baseFont;

  /// Bold font for highlighted items.
  PdfFont get boldFont => config.boldFont;

  /// Whether to use RTL layout.
  bool get isRTL => config.isRTL;

  /// Horizontal alignment of the summary box.
  final GeniusPdfSummaryAlignment alignment;

  /// Fixed width (optional, uses default proportion if null).
  final double? width;

  static GeniusPdfSummaryStyle _resolveSummaryStyle(
    GeniusPdfSummaryStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return GeniusPdfSummaryStyle.fromTheme(config.printTheme);
  }

  /// Draws the summary section on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;

    // Calculate actual width and position
    final actualWidth = width ?? bounds.width * 0.4;
    double boxLeft;

    switch (alignment) {
      case GeniusPdfSummaryAlignment.left:
        boxLeft = bounds.left;
        break;
      case GeniusPdfSummaryAlignment.center:
        boxLeft = bounds.left + (bounds.width - actualWidth) / 2;
        break;
      case GeniusPdfSummaryAlignment.right:
        boxLeft = bounds.right - actualWidth;
        break;
    }

    final boxTop = bounds.top;
    double currentY = boxTop + style.padding.top;

    // Calculate total height
    final contentHeight = _calculateContentHeight();
    final boxHeight = contentHeight + style.padding.top + style.padding.bottom;

    final boxBounds = Rect.fromLTWH(boxLeft, boxTop, actualWidth, boxHeight);

    // Draw background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: boxBounds,
      );
    }

    // Draw border
    _drawBorder(graphics, boxBounds);

    // Draw title if present
    if (title != null || titleAr != null) {
      final displayTitle = isRTL && titleAr != null ? titleAr : title;
      if (displayTitle != null) {
        // Font
        final titleFont = boldFont;

        graphics.drawString(
          displayTitle,
          titleFont,
          brush: style.labelStyle.toBrush(),
          bounds: Rect.fromLTWH(
            boxLeft + style.padding.left,
            currentY,
            actualWidth - style.padding.left - style.padding.right,
            0,
          ),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
          ),
        );
        currentY += style.labelStyle.fontSize * 1.5 + style.itemSpacing;
      }
    }

    // Draw items
    final contentLeft = boxLeft + style.padding.left;
    final contentWidth = actualWidth - style.padding.left - style.padding.right;
    final labelWidth = contentWidth * style.labelWidth;
    final valueWidth = contentWidth - labelWidth;

    for (final item in items) {
      // Draw highlight background if needed
      if (item.isHighlighted) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(style.highlightBackgroundColor.toPdfColor()),
          bounds: Rect.fromLTWH(
            boxLeft,
            currentY - 2,
            actualWidth,
            style.labelStyle.fontSize * 1.4 + 4,
          ),
        );
      }

      // Determine fonts
      final labelFont = item.isBold ? boldFont : baseFont;
      final valueFont = item.isBold ? boldFont : baseFont;

      // Draw label
      final labelX = isRTL ? contentLeft + valueWidth : contentLeft;
      graphics.drawString(
        item.getLabel(isArabic: isRTL),
        labelFont,
        brush: style.labelStyle.toBrush(),
        bounds: Rect.fromLTWH(labelX, currentY, labelWidth, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );

      // Draw value
      final valueX = isRTL ? contentLeft : contentLeft + labelWidth;
      final valueBrush = item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : style.valueStyle.toBrush();

      graphics.drawString(
        item.value,
        valueFont,
        brush: valueBrush,
        bounds: Rect.fromLTWH(valueX, currentY, valueWidth, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
          textDirection: PdfTextDirection.leftToRight,
        ),
      );

      currentY += style.labelStyle.fontSize * 1.4 + style.itemSpacing;
    }

    return boxBounds;
  }

  void _drawBorder(PdfGraphics graphics, Rect bounds) {
    final pen = style.borderStyle.toPen();
    if (style.borderStyle.top) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }
    if (style.borderStyle.bottom) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.bottom),
        Offset(bounds.right, bounds.bottom),
      );
    }
    if (style.borderStyle.left) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.left, bounds.bottom),
      );
    }
    if (style.borderStyle.right) {
      graphics.drawLine(
        pen,
        Offset(bounds.right, bounds.top),
        Offset(bounds.right, bounds.bottom),
      );
    }
  }

  double _calculateContentHeight() {
    double height = 0;

    if (title != null || titleAr != null) {
      height += style.labelStyle.fontSize * 1.5 + style.itemSpacing;
    }

    height +=
        items.length * (style.labelStyle.fontSize * 1.4 + style.itemSpacing);

    return height;
  }
}
