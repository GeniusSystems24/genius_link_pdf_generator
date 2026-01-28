import 'dart:ui';

import '../../../genius_link_pdf_generator.dart';

/// A text span with optional styling for use in [GeniusPdfRichText].
///
/// Enhanced text span with support for:
/// - Multiple text decorations (underline, strikethrough)
/// - Background highlighting
/// - Superscript and subscript
/// - Letter spacing
/// - Custom fonts
///
/// ## Example
/// ```dart
/// GeniusPdfTextSpan(
///   text: 'Important',
///   color: Colors.red,
///   isBold: true,
///   backgroundColor: Colors.yellow.withOpacity(0.3),
/// )
/// ```
class GeniusPdfTextSpan {
  const GeniusPdfTextSpan({
    required this.text,
    this.style,
    this.link,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.letterSpacing,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.isSuperscript = false,
    this.isSubscript = false,
    this.fontFamily,
    this.tooltip,
  });

  /// Creates a plain text span.
  const GeniusPdfTextSpan.plain(this.text)
      : style = null,
        link = null,
        color = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a bold text span.
  const GeniusPdfTextSpan.bold(this.text, {this.color, this.fontSize, this.backgroundColor})
      : style = null,
        link = null,
        letterSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a link text span.
  const GeniusPdfTextSpan.link(
    this.text, {
    required this.link,
    this.color = const Color(0xFF1565C0),
    this.tooltip,
  })  : style = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = true,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null;

  /// Creates a colored text span.
  const GeniusPdfTextSpan.colored(this.text, this.color, {this.backgroundColor})
      : style = null,
        link = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a highlighted (positive amount) span.
  const GeniusPdfTextSpan.positive(this.text, {this.backgroundColor})
      : style = null,
        link = null,
        color = const Color(0xFF2E7D32),
        fontSize = null,
        letterSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a highlighted (negative amount) span.
  const GeniusPdfTextSpan.negative(this.text, {this.backgroundColor})
      : style = null,
        link = null,
        color = const Color(0xFFC62828),
        fontSize = null,
        letterSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a highlighted/marked text span.
  const GeniusPdfTextSpan.highlight(
    this.text, {
    this.backgroundColor = const Color(0xFFFFEB3B),
    this.color,
  })  : style = null,
        link = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a superscript text span (for footnotes, powers, etc.).
  const GeniusPdfTextSpan.superscript(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = true,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a subscript text span (for chemical formulas, etc.).
  const GeniusPdfTextSpan.subscript(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = true,
        fontFamily = null,
        tooltip = null;

  /// Creates a strikethrough text span (for deleted/old values).
  const GeniusPdfTextSpan.strikethrough(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = true,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null;

  /// Creates a code/monospace text span.
  const GeniusPdfTextSpan.code(this.text)
      : style = null,
        link = null,
        color = const Color(0xFFD32F2F),
        backgroundColor = const Color(0xFFF5F5F5),
        fontSize = null,
        letterSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = 'monospace',
        tooltip = null;

  /// The text content.
  final String text;

  /// Custom text style (overrides other style properties).
  final GeniusPdfTextStyle? style;

  /// Optional URL link.
  final String? link;

  /// Text color.
  final Color? color;

  /// Background color for highlighting.
  final Color? backgroundColor;

  /// Font size override.
  final double? fontSize;

  /// Letter spacing.
  final double? letterSpacing;

  /// Whether text is bold.
  final bool isBold;

  /// Whether text is italic.
  final bool isItalic;

  /// Whether text is underlined.
  final bool isUnderline;

  /// Whether text has strikethrough.
  final bool isStrikethrough;

  /// Whether text is superscript.
  final bool isSuperscript;

  /// Whether text is subscript.
  final bool isSubscript;

  /// Custom font family name.
  final String? fontFamily;

  /// Tooltip text (for accessibility).
  final String? tooltip;

  /// Whether this span has a link.
  bool get hasLink => link != null && link!.isNotEmpty;

  /// Whether this span has any decoration.
  bool get hasDecoration => isUnderline || isStrikethrough;

  /// Whether this span has background highlighting.
  bool get hasBackground => backgroundColor != null;

  /// Creates a copy with the given fields replaced.
  GeniusPdfTextSpan copyWith({
    String? text,
    GeniusPdfTextStyle? style,
    String? link,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    double? letterSpacing,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isStrikethrough,
    bool? isSuperscript,
    bool? isSubscript,
    String? fontFamily,
    String? tooltip,
  }) {
    return GeniusPdfTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
      link: link ?? this.link,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSize: fontSize ?? this.fontSize,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
      isSuperscript: isSuperscript ?? this.isSuperscript,
      isSubscript: isSubscript ?? this.isSubscript,
      fontFamily: fontFamily ?? this.fontFamily,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}

/// A rich text component that supports multiple styled spans.
///
/// [GeniusPdfRichText] allows you to create text with multiple styles,
/// colors, and links in a single paragraph.
///
/// ## Example
/// ```dart
/// final richText = GeniusPdfRichText(
///   spans: [
///     GeniusPdfTextSpan.plain('Invoice '),
///     GeniusPdfTextSpan.bold('#INV-2024-001', color: Colors.blue),
///     GeniusPdfTextSpan.plain(' - Total: '),
///     GeniusPdfTextSpan.positive('34,615.00 SAR'),
///   ],
///   baseFont: config.baseFont,
///   boldFont: config.boldFont,
/// );
///
/// richText.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfRichText {
  GeniusPdfRichText({
    required this.spans,
    required this.baseFont,
    required this.boldFont,
    this.defaultStyle = const GeniusPdfTextStyle.body(),
    this.isRTL = true,
    this.lineSpacing = 1.2,
    this.paragraphSpacing = 8,
  });

  /// Text spans to render.
  final List<GeniusPdfTextSpan> spans;

  /// Default text style.
  final GeniusPdfTextStyle defaultStyle;

  /// Base font for normal text.
  final PdfFont baseFont;

  /// Bold font for bold text.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Line spacing multiplier.
  final double lineSpacing;

  /// Spacing between paragraphs.
  final double paragraphSpacing;

  /// Gets the combined plain text of all spans.
  String get plainText => spans.map((s) => s.text).join();

  /// Draws the rich text on a PDF page.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (spans.isEmpty) return null;

    final graphics = page.graphics;
    final textDirection =
        isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;

    // Create a text element for the entire rich text
    // For complex rich text, we use positioned drawing
    double currentX = isRTL ? bounds.right : bounds.left;
    double currentY = bounds.top;
    double lineHeight = 0;

    PdfLayoutResult? lastResult;

    for (final span in spans) {
      // Determine font - baseFont and boldFont are required, no fallback to Helvetica
      PdfFont font;
      if (span.isBold || (span.style?.isBold ?? false)) {
        font = boldFont;
      } else {
        font = baseFont;
      }

      // Determine color
      final color = span.color ?? span.style?.color ?? defaultStyle.color;
      final brush = PdfSolidBrush(color.toPdfColor());

      // Measure text
      final textSize = font.measureString(span.text);
      lineHeight = lineHeight > textSize.height ? lineHeight : textSize.height;

      // Check if we need to wrap to next line
      final textWidth = textSize.width;
      if (isRTL) {
        if (currentX - textWidth < bounds.left) {
          currentX = bounds.right;
          currentY += lineHeight * lineSpacing;
          lineHeight = textSize.height;
        }
      } else {
        if (currentX + textWidth > bounds.right) {
          currentX = bounds.left;
          currentY += lineHeight * lineSpacing;
          lineHeight = textSize.height;
        }
      }

      // Draw text
      final drawX = isRTL ? currentX - textWidth : currentX;

      final format = PdfStringFormat(
        alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: textDirection,
      );

      graphics.drawString(
        span.text,
        font,
        brush: brush,
        bounds: Rect.fromLTWH(drawX, currentY, textWidth, textSize.height),
        format: format,
      );

      // Draw underline if needed
      if (span.isUnderline) {
        final underlineY = currentY + textSize.height - 1;
        graphics.drawLine(
          PdfPen(color.toPdfColor(), width: 0.5),
          Offset(drawX, underlineY),
          Offset(drawX + textWidth, underlineY),
        );
      }

      // Add link annotation if present
      if (span.hasLink) {
        final linkBounds =
            Rect.fromLTWH(drawX, currentY, textWidth, textSize.height);
        final annotation = PdfUriAnnotation(
          bounds: linkBounds,
          uri: span.link!,
        );
        page.annotations.add(annotation);
      }

      // Update position
      if (isRTL) {
        currentX -= textWidth;
      } else {
        currentX += textWidth;
      }
    }

    // Return approximate bounds
    final resultBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      currentY - bounds.top + lineHeight,
    );

    // Create a dummy result for positioning
    return _createLayoutResult(page, resultBounds);
  }

  /// Draws as a simple single-line text element.
  PdfLayoutResult? drawSimple({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    // Font - baseFont is required, no fallback to Helvetica
    final font = baseFont;

    final textElement = PdfTextElement(
      text: plainText,
      font: font,
      brush: defaultStyle.toBrush(),
      format: defaultStyle.toStringFormat(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
    );

    return textElement.draw(
      page: page,
      bounds: bounds,
      format: layoutFormat ??
          PdfLayoutFormat(
            layoutType: PdfLayoutType.paginate,
            breakType: PdfLayoutBreakType.fitPage,
          ),
    );
  }

  PdfLayoutResult? _createLayoutResult(PdfPage page, Rect bounds) {
    // Create a minimal text element to get a proper layout result
    final dummyElement = PdfTextElement(
      text: ' ',
      font: PdfStandardFont(PdfFontFamily.helvetica, 1),
    );

    return dummyElement.draw(
      page: page,
      bounds: Rect.fromLTWH(bounds.left, bounds.bottom, 1, 1),
    );
  }
}

/// Builder for creating rich text content easily.
class GeniusPdfRichTextBuilder {
  GeniusPdfRichTextBuilder({
    this.defaultStyle = const GeniusPdfTextStyle.body(),
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
  });

  final GeniusPdfTextStyle defaultStyle;
  final PdfFont baseFont;
  final PdfFont boldFont;
  final bool isRTL;

  final List<GeniusPdfTextSpan> _spans = [];

  /// Adds plain text.
  GeniusPdfRichTextBuilder text(String text) {
    _spans.add(GeniusPdfTextSpan.plain(text));
    return this;
  }

  /// Adds bold text.
  GeniusPdfRichTextBuilder bold(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.bold(text, color: color));
    return this;
  }

  /// Adds colored text.
  GeniusPdfRichTextBuilder colored(String text, Color color) {
    _spans.add(GeniusPdfTextSpan.colored(text, color));
    return this;
  }

  /// Adds a link.
  GeniusPdfRichTextBuilder link(String text, String url, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.link(
      text,
      link: url,
      color: color ?? const Color(0xFF1565C0),
    ));
    return this;
  }

  /// Adds a positive amount (green).
  GeniusPdfRichTextBuilder positive(String text) {
    _spans.add(GeniusPdfTextSpan.positive(text));
    return this;
  }

  /// Adds a negative amount (red).
  GeniusPdfRichTextBuilder negative(String text) {
    _spans.add(GeniusPdfTextSpan.negative(text));
    return this;
  }

  /// Adds a custom styled span.
  GeniusPdfRichTextBuilder span(GeniusPdfTextSpan span) {
    _spans.add(span);
    return this;
  }

  /// Adds a line break.
  GeniusPdfRichTextBuilder newLine() {
    _spans.add(const GeniusPdfTextSpan.plain('\n'));
    return this;
  }

  /// Adds a space.
  GeniusPdfRichTextBuilder space() {
    _spans.add(const GeniusPdfTextSpan.plain(' '));
    return this;
  }

  /// Builds the rich text component.
  GeniusPdfRichText build() {
    return GeniusPdfRichText(
      spans: List.unmodifiable(_spans),
      defaultStyle: defaultStyle,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Clears all spans.
  void clear() {
    _spans.clear();
  }
}

/// A labeled value component for key-value pairs.
///
/// Useful for displaying data like "Invoice No: INV-001" or "المجموع: 1,000 ريال".
class GeniusPdfLabeledValue {
  const GeniusPdfLabeledValue({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelStyle,
    this.valueStyle,
    this.separator = ': ',
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
  });

  final String label;
  final String? labelAr;
  final String value;
  final GeniusPdfTextStyle? labelStyle;
  final GeniusPdfTextStyle? valueStyle;
  final String separator;
  final PdfFont baseFont;
  final PdfFont boldFont;
  final bool isRTL;

  /// Gets the display label based on locale.
  String getLabel() {
    if (isRTL && labelAr != null) return labelAr!;
    return label;
  }

  /// Draws the labeled value.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    final labelText = getLabel();

    final richText = GeniusPdfRichText(
      spans: [
        GeniusPdfTextSpan.bold(labelText),
        GeniusPdfTextSpan.plain(separator),
        GeniusPdfTextSpan.plain(value),
      ],
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );

    return richText.draw(
        page: page, bounds: bounds, layoutFormat: layoutFormat);
  }
}

/// A key-value list component for displaying multiple labeled values.
class GeniusPdfKeyValueList {
  const GeniusPdfKeyValueList({
    required this.items,
    this.itemSpacing = 4,
    this.baseFont,
    this.boldFont,
    this.isRTL = true,
    this.columns = 1,
    this.columnSpacing = 20,
  });

  final List<GeniusPdfLabeledValue> items;
  final double itemSpacing;
  final PdfFont? baseFont;
  final PdfFont? boldFont;
  final bool isRTL;
  final int columns;
  final double columnSpacing;

  /// Draws the key-value list.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (items.isEmpty) return null;

    double currentY = bounds.top;
    PdfLayoutResult? lastResult;

    if (columns == 1) {
      // Single column layout
      for (final item in items) {
        final labeledValue = GeniusPdfLabeledValue(
          label: item.label,
          labelAr: item.labelAr,
          value: item.value,
          labelStyle: item.labelStyle,
          valueStyle: item.valueStyle,
          separator: item.separator,
          baseFont: baseFont ?? item.baseFont,
          boldFont: boldFont ?? item.boldFont,
          isRTL: isRTL,
        );

        lastResult = labeledValue.draw(
          page: page,
          bounds: Rect.fromLTWH(
            bounds.left,
            currentY,
            bounds.width,
            bounds.height - (currentY - bounds.top),
          ),
          layoutFormat: layoutFormat,
        );

        if (lastResult != null) {
          currentY = lastResult.bounds.bottom + itemSpacing;
        }
      }
    } else {
      // Multi-column layout
      final columnWidth =
          (bounds.width - (columnSpacing * (columns - 1))) / columns;
      final itemsPerColumn = (items.length / columns).ceil();

      for (int col = 0; col < columns; col++) {
        final startIndex = col * itemsPerColumn;
        final endIndex = (startIndex + itemsPerColumn).clamp(0, items.length);
        final columnItems = items.sublist(startIndex, endIndex);

        double colY = bounds.top;
        final colX = bounds.left + (col * (columnWidth + columnSpacing));

        for (final item in columnItems) {
          final labeledValue = GeniusPdfLabeledValue(
            label: item.label,
            labelAr: item.labelAr,
            value: item.value,
            baseFont: baseFont ?? item.baseFont,
            boldFont: boldFont ?? item.boldFont,
            isRTL: isRTL,
          );

          lastResult = labeledValue.draw(
            page: page,
            bounds: Rect.fromLTWH(
              colX,
              colY,
              columnWidth,
              bounds.height - (colY - bounds.top),
            ),
            layoutFormat: layoutFormat,
          );

          if (lastResult != null) {
            colY = lastResult.bounds.bottom + itemSpacing;
            if (colY > currentY) currentY = colY;
          }
        }
      }
    }

    return lastResult;
  }
}
