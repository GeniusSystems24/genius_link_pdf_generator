part of '../pdf_rich_text.dart';

enum GeniusPdfBulletStyle {
  /// Filled circle bullet (•).
  disc,

  /// Open circle bullet (○).
  circle,

  /// Square bullet (■).
  square,

  /// Dash bullet (–).
  dash,

  /// Arabic numbered list (1. 2. 3.).
  numberedArabic,

  /// Arabic-Indic numbered list (١. ٢. ٣.).
  numberedArabicIndic,

  /// Alphabetic list (a. b. c.).
  alphabetic,

  /// No bullet or number.
  none,
}

/// A single item in a [GeniusPdfBulletList].
class GeniusPdfBulletItem {
  const GeniusPdfBulletItem({
    required this.text,
    this.spans,
    this.color,
    this.isBold = false,
    this.subItems,
  });

  /// Creates a simple text bullet item.
  const GeniusPdfBulletItem.simple(this.text)
      : spans = null,
        color = null,
        isBold = false,
        subItems = null;

  /// Creates a bullet item with rich text spans.
  const GeniusPdfBulletItem.rich(this.spans, {this.color})
      : text = '',
        isBold = false,
        subItems = null;

  /// Plain text content for the item.
  final String text;

  /// Rich text spans (overrides [text] if provided).
  final List<GeniusPdfTextSpan>? spans;

  /// Override color for this item.
  final Color? color;

  /// Whether this item text is bold.
  final bool isBold;

  /// Nested sub-items for hierarchical lists.
  final List<GeniusPdfBulletItem>? subItems;

  /// Whether this item has rich text spans.
  bool get hasSpans => spans != null && spans!.isNotEmpty;

  /// Whether this item has nested sub-items.
  bool get hasSubItems => subItems != null && subItems!.isNotEmpty;
}

/// A bulleted or numbered list component for PDF.
///
/// Supports disc, circle, square, dash, numbered, and alphabetic styles.
/// Supports nested sub-items and rich text per item.
///
/// ## Example
/// ```dart
/// final list = GeniusPdfBulletList(
///   items: [
///     GeniusPdfBulletItem.simple('First item'),
///     GeniusPdfBulletItem.simple('Second item'),
///     GeniusPdfBulletItem(text: 'Third', subItems: [
///       GeniusPdfBulletItem.simple('Sub-item A'),
///     ]),
///   ],
///   style: GeniusPdfBulletStyle.disc,
///   baseFont: font,
///   boldFont: boldFont,
/// );
///
/// list.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfBulletList {
  GeniusPdfBulletList({
    required this.items,
    required this.config,
    this.style = GeniusPdfBulletStyle.disc,
    PdfFont? baseFont,
    PdfFont? boldFont,
    this.fontSize = 10,
    this.itemSpacing = 4,
    this.indentWidth = 20,
    this.bulletColor,
    this.textColor,
    bool? isRTL,
    this.startNumber = 1,
  })  : baseFont = _resolveRichTextBaseFont(baseFont, config),
        boldFont = _resolveRichTextBoldFont(boldFont, baseFont, config),
        isRTL = isRTL ?? config.isRTL;

  final List<GeniusPdfBulletItem> items;
  final GeniusPdfConfig config;
  final GeniusPdfBulletStyle style;
  final PdfFont baseFont;
  final PdfFont boldFont;
  final double fontSize;
  final double itemSpacing;
  final double indentWidth;
  final Color? bulletColor;
  final Color? textColor;
  final bool isRTL;
  final int startNumber;

  /// Returns the bullet/number marker for a given index.
  String _bulletMarker(int index, GeniusPdfBulletStyle bulletStyle) {
    switch (bulletStyle) {
      case GeniusPdfBulletStyle.disc:
        return '•  ';
      case GeniusPdfBulletStyle.circle:
        return '○  ';
      case GeniusPdfBulletStyle.square:
        return '■  ';
      case GeniusPdfBulletStyle.dash:
        return '–  ';
      case GeniusPdfBulletStyle.numberedArabic:
        return '${startNumber + index}.  ';
      case GeniusPdfBulletStyle.numberedArabicIndic:
        return '${_toArabicIndic(startNumber + index)}.  ';
      case GeniusPdfBulletStyle.alphabetic:
        return '${String.fromCharCode(97 + (index % 26))}.  ';
      case GeniusPdfBulletStyle.none:
        return '';
    }
  }

  /// Converts a number to Arabic-Indic numerals (٠١٢٣٤٥٦٧٨٩).
  String _toArabicIndic(int number) {
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicIndic[int.parse(d)])
        .join();
  }

  /// Sub-item bullet style (cycles: disc → circle → dash).
  GeniusPdfBulletStyle _subItemStyle(GeniusPdfBulletStyle parentStyle) {
    switch (parentStyle) {
      case GeniusPdfBulletStyle.disc:
        return GeniusPdfBulletStyle.circle;
      case GeniusPdfBulletStyle.circle:
        return GeniusPdfBulletStyle.dash;
      default:
        return GeniusPdfBulletStyle.dash;
    }
  }

  /// Draws the bullet list on a PDF page.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (items.isEmpty) return null;

    double currentY = bounds.top;
    PdfLayoutResult? lastResult;

    lastResult = _drawItems(
      items: items,
      page: page,
      bounds: bounds,
      currentY: currentY,
      depth: 0,
      bulletStyle: style,
      onYAdvance: (y) => currentY = y,
    );

    return lastResult;
  }

  PdfLayoutResult? _drawItems({
    required List<GeniusPdfBulletItem> items,
    required PdfPage page,
    required Rect bounds,
    required double currentY,
    required int depth,
    required GeniusPdfBulletStyle bulletStyle,
    required void Function(double) onYAdvance,
  }) {
    final graphics = page.graphics;
    PdfLayoutResult? lastResult;

    final indent = depth * indentWidth;
    final effectiveBounds = Rect.fromLTWH(
      isRTL ? bounds.left : bounds.left + indent,
      bounds.top,
      bounds.width - indent,
      bounds.height,
    );

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final marker = _bulletMarker(i, bulletStyle);
      final itemFont = item.isBold ? boldFont : baseFont;
      final itemColor = item.color ?? textColor ?? const Color(0xFF212121);
      final markerColor = bulletColor ?? itemColor;

      // Draw marker
      final markerSize = baseFont.measureString(marker);
      final markerBrush = PdfSolidBrush(markerColor.toPdfColor());

      final textDirection =
          isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;
      final format = PdfStringFormat(
        textDirection: textDirection,
        alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      );

      final markerX = isRTL
          ? effectiveBounds.right - markerSize.width
          : effectiveBounds.left;

      graphics.drawString(
        marker,
        baseFont,
        brush: markerBrush,
        bounds: Rect.fromLTWH(
          markerX,
          currentY,
          markerSize.width + 5,
          markerSize.height,
        ),
        format: format,
      );

      // Draw item text or rich spans
      final textX = isRTL
          ? effectiveBounds.left
          : effectiveBounds.left + markerSize.width;
      final textWidth = effectiveBounds.width - markerSize.width;

      if (item.hasSpans) {
        final richText = GeniusPdfRichText(
          spans: item.spans!,
          config: config,
          baseFont: baseFont,
          boldFont: boldFont,
          isRTL: isRTL,
        );
        lastResult = richText.draw(
          page: page,
          bounds: Rect.fromLTWH(textX, currentY, textWidth, bounds.height),
        );
      } else {
        final brush = PdfSolidBrush(itemColor.toPdfColor());
        final textSize = itemFont.measureString(item.text);
        graphics.drawString(
          item.text,
          itemFont,
          brush: brush,
          bounds: Rect.fromLTWH(
            textX,
            currentY,
            textWidth,
            textSize.height + 4,
          ),
          format: format,
        );
      }

      final lineHeight = baseFont.measureString('A').height;
      currentY += lineHeight + itemSpacing;

      // Draw sub-items recursively
      if (item.hasSubItems) {
        lastResult = _drawItems(
          items: item.subItems!,
          page: page,
          bounds: bounds,
          currentY: currentY,
          depth: depth + 1,
          bulletStyle: _subItemStyle(bulletStyle),
          onYAdvance: (y) => currentY = y,
        );
      }

      onYAdvance(currentY);
    }

    return lastResult;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Paragraph
// ─────────────────────────────────────────────────────────────────────────────

/// A multi-paragraph rich text component.
///
/// Wraps multiple [GeniusPdfRichText] blocks with paragraph spacing
/// and consistent alignment.
///
/// ## Example
/// ```dart
/// final paragraph = GeniusPdfParagraph(
///   blocks: [
///     GeniusPdfRichText(spans: [...], baseFont: font, boldFont: boldFont),
///     GeniusPdfRichText(spans: [...], baseFont: font, boldFont: boldFont),
///   ],
///   paragraphSpacing: 12,
/// );
///
/// paragraph.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfParagraph {
  const GeniusPdfParagraph({
    required this.config,
    required this.blocks,
    this.paragraphSpacing = 10,
    this.firstLineIndent = 0,
  });

  final GeniusPdfConfig config;

  /// Rich text blocks, one per paragraph.
  final List<GeniusPdfRichText> blocks;

  /// Vertical spacing between paragraphs.
  final double paragraphSpacing;

  /// Indent for the first line of each paragraph.
  final double firstLineIndent;

  /// Draws all paragraphs on the page.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (blocks.isEmpty) return null;

    double currentY = bounds.top;
    PdfLayoutResult? lastResult;

    for (final block in blocks) {
      final blockBounds = Rect.fromLTWH(
        bounds.left + (firstLineIndent > 0 ? firstLineIndent : 0),
        currentY,
        bounds.width - firstLineIndent,
        bounds.bottom - currentY,
      );

      if (blockBounds.height <= 0) break;

      lastResult = block.draw(
        page: page,
        bounds: blockBounds,
        layoutFormat: layoutFormat,
      );

      if (lastResult != null) {
        currentY = lastResult.bounds.bottom + paragraphSpacing;
      }
    }

    return lastResult;
  }

  /// Measures the total height all paragraphs will occupy.
  double measureHeight(double availableWidth) {
    double total = 0;
    for (int i = 0; i < blocks.length; i++) {
      total += blocks[i].measureHeight(availableWidth - firstLineIndent);
      if (i < blocks.length - 1) total += paragraphSpacing;
    }
    return total;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Text Measurer
// ─────────────────────────────────────────────────────────────────────────────

/// Utility class for measuring text dimensions before drawing.
///
/// Use this to calculate bounds, check if text fits,
/// or plan layout before committing to a draw call.
///
/// ## Example
/// ```dart
/// final measurer = GeniusPdfTextMeasurer(baseFont: font, boldFont: boldFont);
/// final size = measurer.measureSpan(GeniusPdfTextSpan.bold('Hello'));
/// final height = measurer.measureRichTextHeight(richText, availableWidth: 400);
/// ```
