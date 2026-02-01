import 'dart:math' as math;
import 'dart:ui';

import '../../../genius_link_pdf_generator.dart';
import '../../core/pdf_logger.dart';

PdfFont _resolveRichTextBaseFont(PdfFont? baseFont, GeniusPdfConfig config) {
  return baseFont ?? config.baseFont;
}

PdfFont _resolveRichTextBoldFont(
  PdfFont? boldFont,
  PdfFont? baseFont,
  GeniusPdfConfig config,
) {
  return boldFont ?? config.boldFont;
}

GeniusPdfTextStyle _resolveRichTextDefaultStyle(
  GeniusPdfTextStyle? style,
  GeniusPdfConfig config,
) {
  if (style != null) return style;
  final typography = config.printTheme.typography;
  return GeniusPdfTextStyle(
    fontSize: typography.bodySize,
    color: config.printTheme.colorScheme.onSurface,
    alignment: GeniusPdfTextAlign.start,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Text Span
// ─────────────────────────────────────────────────────────────────────────────

/// A text span with optional styling for use in [GeniusPdfRichText].
///
/// Enhanced text span with support for:
/// - Multiple text decorations (underline, strikethrough, overline)
/// - Background highlighting
/// - Superscript and subscript
/// - Letter spacing and word spacing
/// - Custom fonts
/// - Inline direction override (LTR/RTL)
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
    this.wordSpacing,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isStrikethrough = false,
    this.isOverline = false,
    this.isSuperscript = false,
    this.isSubscript = false,
    this.fontFamily,
    this.tooltip,
    this.opacity = 1.0,
    this.textDirectionOverride,
  });

  // ─── Factory Constructors ───────────────────────────────────────────

  /// Creates a plain text span.
  const GeniusPdfTextSpan.plain(this.text)
      : style = null,
        link = null,
        color = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a bold text span.
  const GeniusPdfTextSpan.bold(this.text,
      {this.color, this.fontSize, this.backgroundColor})
      : style = null,
        link = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates an italic text span.
  const GeniusPdfTextSpan.italic(this.text, {this.color, this.fontSize})
      : style = null,
        link = null,
        backgroundColor = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = true,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a bold-italic text span.
  const GeniusPdfTextSpan.boldItalic(this.text, {this.color, this.fontSize})
      : style = null,
        link = null,
        backgroundColor = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = true,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

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
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = true,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a colored text span.
  const GeniusPdfTextSpan.colored(this.text, this.color, {this.backgroundColor})
      : style = null,
        link = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a highlighted (positive amount) span — green bold.
  const GeniusPdfTextSpan.positive(this.text, {this.backgroundColor})
      : style = null,
        link = null,
        color = const Color(0xFF2E7D32),
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a highlighted (negative amount) span — red bold.
  const GeniusPdfTextSpan.negative(this.text, {this.backgroundColor})
      : style = null,
        link = null,
        color = const Color(0xFFC62828),
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a highlighted/marked text span.
  const GeniusPdfTextSpan.highlight(
    this.text, {
    this.backgroundColor = const Color(0xFFFFEB3B),
    this.color,
  })  : style = null,
        link = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a superscript text span (for footnotes, powers, etc.).
  const GeniusPdfTextSpan.superscript(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = true,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a subscript text span (for chemical formulas, etc.).
  const GeniusPdfTextSpan.subscript(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = true,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a strikethrough text span (for deleted/old values).
  const GeniusPdfTextSpan.strikethrough(this.text, {this.color})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = true,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a code/monospace text span.
  const GeniusPdfTextSpan.code(this.text)
      : style = null,
        link = null,
        color = const Color(0xFFD32F2F),
        backgroundColor = const Color(0xFFF5F5F5),
        fontSize = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = 'monospace',
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a label-style span — bold, slightly larger, gray color.
  /// Useful for form field labels, section titles, etc.
  const GeniusPdfTextSpan.label(this.text, {this.fontSize = 11})
      : style = null,
        link = null,
        color = const Color(0xFF424242),
        backgroundColor = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a currency value span — bold, right-aligned friendly.
  ///
  /// ```dart
  /// GeniusPdfTextSpan.currency('1,250.00', symbol: 'SAR')
  /// // renders as "1,250.00 SAR" or "SAR 1,250.00"
  /// ```
  factory GeniusPdfTextSpan.currency(
    String amount, {
    String? symbol,
    bool symbolBefore = false,
    Color? color,
    bool isBold = true,
  }) {
    final display = symbol != null
        ? (symbolBefore ? '$symbol $amount' : '$amount $symbol')
        : amount;
    return GeniusPdfTextSpan(
      text: display,
      color: color,
      isBold: isBold,
      letterSpacing: 0.3,
    );
  }

  /// Creates a heading-style span — larger, bold.
  const GeniusPdfTextSpan.heading(this.text,
      {this.fontSize = 14, this.color = const Color(0xFF212121)})
      : style = null,
        link = null,
        backgroundColor = null,
        letterSpacing = null,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a small/caption text span — smaller font, gray.
  const GeniusPdfTextSpan.small(this.text,
      {this.color = const Color(0xFF757575)})
      : style = null,
        link = null,
        backgroundColor = null,
        fontSize = 8,
        letterSpacing = null,
        wordSpacing = null,
        isBold = false,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  /// Creates a badge-style span — bold text with colored background.
  ///
  /// ```dart
  /// GeniusPdfTextSpan.badge('PAID', backgroundColor: Colors.green, color: Colors.white)
  /// ```
  const GeniusPdfTextSpan.badge(
    this.text, {
    this.backgroundColor = const Color(0xFF1976D2),
    this.color = const Color(0xFFFFFFFF),
    this.fontSize = 9,
  })  : style = null,
        link = null,
        letterSpacing = 0.5,
        wordSpacing = null,
        isBold = true,
        isItalic = false,
        isUnderline = false,
        isStrikethrough = false,
        isOverline = false,
        isSuperscript = false,
        isSubscript = false,
        fontFamily = null,
        tooltip = null,
        opacity = 1.0,
        textDirectionOverride = null;

  // ─── Properties ─────────────────────────────────────────────────────

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

  /// Word spacing.
  final double? wordSpacing;

  /// Whether text is bold.
  final bool isBold;

  /// Whether text is italic.
  final bool isItalic;

  /// Whether text is underlined.
  final bool isUnderline;

  /// Whether text has strikethrough.
  final bool isStrikethrough;

  /// Whether text has an overline.
  final bool isOverline;

  /// Whether text is superscript.
  final bool isSuperscript;

  /// Whether text is subscript.
  final bool isSubscript;

  /// Custom font family name.
  final String? fontFamily;

  /// Tooltip text (for accessibility).
  final String? tooltip;

  /// Opacity of this span (0.0 – 1.0).
  final double opacity;

  /// Explicit text direction override for this span.
  final TextDirection? textDirectionOverride;

  // ─── Computed Properties ────────────────────────────────────────────

  /// Whether this span has a link.
  bool get hasLink => link != null && link!.isNotEmpty;

  /// Whether this span has any decoration.
  bool get hasDecoration => isUnderline || isStrikethrough || isOverline;

  /// Whether this span has background highlighting.
  bool get hasBackground => backgroundColor != null;

  /// Whether the text is empty.
  bool get isEmpty => text.isEmpty;

  /// Whether the text is not empty.
  bool get isNotEmpty => text.isNotEmpty;

  /// Effective font size multiplier for superscript/subscript.
  double get _scriptSizeRatio => 0.65;

  /// Creates a copy with the given fields replaced.
  GeniusPdfTextSpan copyWith({
    String? text,
    GeniusPdfTextStyle? style,
    String? link,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isStrikethrough,
    bool? isOverline,
    bool? isSuperscript,
    bool? isSubscript,
    String? fontFamily,
    String? tooltip,
    double? opacity,
    TextDirection? textDirectionOverride,
  }) {
    return GeniusPdfTextSpan(
      text: text ?? this.text,
      style: style ?? this.style,
      link: link ?? this.link,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSize: fontSize ?? this.fontSize,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isStrikethrough: isStrikethrough ?? this.isStrikethrough,
      isOverline: isOverline ?? this.isOverline,
      isSuperscript: isSuperscript ?? this.isSuperscript,
      isSubscript: isSubscript ?? this.isSubscript,
      fontFamily: fontFamily ?? this.fontFamily,
      tooltip: tooltip ?? this.tooltip,
      opacity: opacity ?? this.opacity,
      textDirectionOverride:
          textDirectionOverride ?? this.textDirectionOverride,
    );
  }

  @override
  String toString() =>
      'GeniusPdfTextSpan("$text", bold=$isBold, italic=$isItalic)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Rich Text Component
// ─────────────────────────────────────────────────────────────────────────────

/// Paragraph alignment for [GeniusPdfRichText].
enum GeniusPdfParagraphAlignment {
  /// Align to the start (left for LTR, right for RTL).
  start,

  /// Center alignment.
  center,

  /// Align to the end (right for LTR, left for RTL).
  end,
}

/// A rich text component that supports multiple styled spans.
///
/// [GeniusPdfRichText] allows you to create text with multiple styles,
/// colors, and links in a single paragraph. Now supports:
/// - Background color rendering
/// - Strikethrough and overline decorations
/// - Superscript and subscript positioning
/// - Letter spacing
/// - Italic font rendering
/// - Paragraph alignment (start, center, end)
/// - Word-level wrapping within spans
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
    required this.config,
    PdfFont? baseFont,
    PdfFont? boldFont,
    this.italicFont,
    this.boldItalicFont,
    GeniusPdfTextStyle? defaultStyle,
    bool? isRTL,
    this.lineSpacing = 1.2,
    this.paragraphSpacing = 8,
    this.paragraphAlignment = GeniusPdfParagraphAlignment.start,
    this.maxLines,
    this.overflow = GeniusPdfTextOverflow.clip,
    this.backgroundPadding = 1.5,
  })  : baseFont = _resolveRichTextBaseFont(baseFont, config),
        boldFont = _resolveRichTextBoldFont(boldFont, baseFont, config),
        defaultStyle = _resolveRichTextDefaultStyle(defaultStyle, config),
        isRTL = isRTL ?? config.isRTL;

  /// Text spans to render.
  final List<GeniusPdfTextSpan> spans;

  /// Default text style.
  final GeniusPdfTextStyle defaultStyle;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Base font for normal text.
  final PdfFont baseFont;

  /// Bold font for bold text.
  final PdfFont boldFont;

  /// Italic font for italic text (falls back to baseFont if null).
  final PdfFont? italicFont;

  /// Bold-italic font (falls back to boldFont if null).
  final PdfFont? boldItalicFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Line spacing multiplier.
  final double lineSpacing;

  /// Spacing between paragraphs.
  final double paragraphSpacing;

  /// Paragraph alignment.
  final GeniusPdfParagraphAlignment paragraphAlignment;

  /// Maximum number of lines to render (null = unlimited).
  final int? maxLines;

  /// Overflow behavior when text exceeds bounds.
  final GeniusPdfTextOverflow overflow;

  /// Padding around background highlight rectangles.
  final double backgroundPadding;

  /// Gets the combined plain text of all spans.
  String get plainText => spans.map((s) => s.text).join();

  /// Number of spans.
  int get spanCount => spans.length;

  /// Whether there are no spans.
  bool get isEmpty => spans.isEmpty;

  /// Resolves the font for a given span.
  PdfFont _resolveFont(GeniusPdfTextSpan span) {
    final wantBold = span.isBold || (span.style?.isBold ?? false);
    final wantItalic = span.isItalic;

    if (wantBold && wantItalic) {
      return boldItalicFont ?? boldFont;
    } else if (wantBold) {
      return boldFont;
    } else if (wantItalic) {
      return italicFont ?? baseFont;
    }
    return baseFont;
  }

  /// Resolves the effective font size for a span, accounting for
  /// superscript/subscript scaling.
  double _resolveEffectiveFontSize(GeniusPdfTextSpan span) {
    final base = span.fontSize ?? defaultStyle.fontSize;
    if (span.isSuperscript || span.isSubscript) {
      return base * span._scriptSizeRatio;
    }
    return base;
  }

  /// Calculates the Y offset for superscript/subscript.
  double _resolveYOffset(GeniusPdfTextSpan span, double lineHeight) {
    if (span.isSuperscript) {
      return -lineHeight * 0.3;
    }
    if (span.isSubscript) {
      return lineHeight * 0.2;
    }
    return 0;
  }

  /// Measures a text string with the given font, returning its Size.
  Size _measureText(String text, PdfFont font) {
    return font.measureString(text);
  }

  /// Draws the rich text on a PDF page.
  ///
  /// Fully renders: background color, underline, strikethrough, overline,
  /// superscript/subscript positioning, letter spacing, opacity, and links.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (spans.isEmpty) return null;
    GeniusPdfLogger.debug('Drawing rich text: ${spans.length} spans',
        tag: 'RichText');

    final graphics = page.graphics;
    final textDirection =
        isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;

    // ── Build line segments first (word-wrap aware) ──────────────────
    final lines = _buildLines(bounds.width);
    if (lines.isEmpty) return null;

    // ── Clamp to maxLines ───────────────────────────────────────────
    final effectiveLines = maxLines != null && lines.length > maxLines!
        ? lines.sublist(0, maxLines!)
        : lines;

    double currentY = bounds.top;
    int lineIndex = 0;

    for (final line in effectiveLines) {
      final lineHeight = line.height * lineSpacing;

      // Check vertical overflow
      if (currentY + lineHeight > bounds.bottom) {
        break;
      }

      // Calculate line X start based on alignment
      final lineStartX = _resolveLineStartX(
        bounds: bounds,
        lineWidth: line.width,
      );

      double cursorX = lineStartX;

      // Check if this is the last rendered line and we're truncating
      final isLastLine = lineIndex == effectiveLines.length - 1 &&
          maxLines != null &&
          lines.length > maxLines!;

      for (int si = 0; si < line.segments.length; si++) {
        final seg = line.segments[si];
        final span = seg.span;
        final font = seg.font;
        final textSize = seg.size;
        final effectiveFontSize = _resolveEffectiveFontSize(span);

        // Apply ellipsis on last segment of last truncated line
        String drawText = seg.text;
        double drawWidth = textSize.width;
        if (isLastLine &&
            si == line.segments.length - 1 &&
            overflow == GeniusPdfTextOverflow.ellipsis) {
          const ellipsis = '…';
          final ellipsisSize = _measureText(ellipsis, font);
          if (drawWidth + ellipsisSize.width <= bounds.width) {
            drawText = '${seg.text}$ellipsis';
            drawWidth += ellipsisSize.width;
          }
        }

        // Resolve color + opacity
        final baseColor = span.color ?? span.style?.color ?? defaultStyle.color;
        final effectiveColor = span.opacity < 1.0
            ? Color.fromARGB(
                (baseColor.alpha * span.opacity).round(),
                baseColor.red,
                baseColor.green,
                baseColor.blue,
              )
            : baseColor;
        final brush = PdfSolidBrush(effectiveColor.toPdfColor());

        // Y offset for superscript / subscript
        final yOffset = _resolveYOffset(span, line.height);
        final drawY = currentY + yOffset;

        final drawX = isRTL ? cursorX - drawWidth : cursorX;

        // ── Draw background ──────────────────────────────────────
        if (span.hasBackground) {
          final bgRect = Rect.fromLTWH(
            drawX - backgroundPadding,
            drawY - backgroundPadding,
            drawWidth + backgroundPadding * 2,
            textSize.height + backgroundPadding * 2,
          );
          graphics.drawRectangle(
            brush: PdfSolidBrush(span.backgroundColor!.toPdfColor()),
            bounds: bgRect,
          );
        }

        // ── Draw text ────────────────────────────────────────────
        final format = PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: textDirection,
          characterSpacing: span.letterSpacing ?? 0,
          wordSpacing: span.wordSpacing ?? 0,
        );

        graphics.drawString(
          drawText,
          font,
          brush: brush,
          bounds: Rect.fromLTWH(
            drawX,
            drawY,
            drawWidth + 10,
            effectiveFontSize + 4,
          ),
          format: format,
        );

        // ── Draw decorations ─────────────────────────────────────
        final penColor = effectiveColor.toPdfColor();
        final decorPen = PdfPen(penColor, width: 0.5);

        if (span.isUnderline) {
          final uY = drawY + textSize.height - 1;
          graphics.drawLine(
            decorPen,
            Offset(drawX, uY),
            Offset(drawX + drawWidth, uY),
          );
        }

        if (span.isStrikethrough) {
          final sY = drawY + textSize.height * 0.5;
          graphics.drawLine(
            decorPen,
            Offset(drawX, sY),
            Offset(drawX + drawWidth, sY),
          );
        }

        if (span.isOverline) {
          final oY = drawY + 1;
          graphics.drawLine(
            decorPen,
            Offset(drawX, oY),
            Offset(drawX + drawWidth, oY),
          );
        }

        // ── Add link annotation ──────────────────────────────────
        if (span.hasLink) {
          final linkBounds = Rect.fromLTWH(
            drawX,
            drawY,
            drawWidth,
            textSize.height,
          );
          page.annotations.add(PdfUriAnnotation(
            bounds: linkBounds,
            uri: span.link!,
          ));
        }

        // Advance cursor
        if (isRTL) {
          cursorX -= drawWidth;
        } else {
          cursorX += drawWidth;
        }
      }

      currentY += lineHeight;
      lineIndex++;
    }

    // Return approximate layout bounds
    final resultBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      currentY - bounds.top,
    );
    return _createLayoutResult(page, resultBounds);
  }

  /// Draws as a simple single-line text element using Syncfusion's PdfTextElement.
  PdfLayoutResult? drawSimple({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
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

  /// Measures the total height the rich text will occupy at the given width.
  double measureHeight(double availableWidth) {
    if (spans.isEmpty) return 0;
    final lines = _buildLines(availableWidth);
    double total = 0;
    for (final line in lines) {
      total += line.height * lineSpacing;
    }
    return total;
  }

  // ─── Private Helpers ────────────────────────────────────────────────

  /// Calculates the starting X position for a line based on alignment.
  double _resolveLineStartX({
    required Rect bounds,
    required double lineWidth,
  }) {
    switch (paragraphAlignment) {
      case GeniusPdfParagraphAlignment.center:
        final centerOffset = (bounds.width - lineWidth) / 2;
        return isRTL ? bounds.right - centerOffset : bounds.left + centerOffset;
      case GeniusPdfParagraphAlignment.end:
        return isRTL ? bounds.left + lineWidth : bounds.right - lineWidth;
      case GeniusPdfParagraphAlignment.start:
        return isRTL ? bounds.right : bounds.left;
    }
  }

  /// Builds a list of [_RichTextLine] by performing word-level wrapping.
  List<_RichTextLine> _buildLines(double maxWidth) {
    final lines = <_RichTextLine>[];
    var currentSegments = <_RichTextSegment>[];
    double currentLineWidth = 0;
    double currentLineHeight = 0;

    for (final span in spans) {
      if (span.isEmpty) continue;

      // Handle explicit newlines
      if (span.text == '\n') {
        lines.add(_RichTextLine(
          segments: List.unmodifiable(currentSegments),
          width: currentLineWidth,
          height:
              currentLineHeight > 0 ? currentLineHeight : _defaultLineHeight(),
        ));
        currentSegments = [];
        currentLineWidth = 0;
        currentLineHeight = 0;
        continue;
      }

      final font = _resolveFont(span);
      final words = _splitIntoWords(span.text);

      for (final word in words) {
        final wordSize = _measureText(word, font);
        final wordWidth = wordSize.width;
        final wordHeight = wordSize.height;

        // Check if word fits on current line
        if (currentLineWidth + wordWidth > maxWidth &&
            currentSegments.isNotEmpty) {
          // Flush current line
          lines.add(_RichTextLine(
            segments: List.unmodifiable(currentSegments),
            width: currentLineWidth,
            height: currentLineHeight,
          ));
          currentSegments = [];
          currentLineWidth = 0;
          currentLineHeight = 0;
        }

        // Add word as segment
        currentSegments.add(_RichTextSegment(
          text: word,
          span: span,
          font: font,
          size: wordSize,
        ));
        currentLineWidth += wordWidth;
        currentLineHeight = math.max(currentLineHeight, wordHeight);
      }
    }

    // Flush remaining segments
    if (currentSegments.isNotEmpty) {
      lines.add(_RichTextLine(
        segments: List.unmodifiable(currentSegments),
        width: currentLineWidth,
        height: currentLineHeight,
      ));
    }

    return lines;
  }

  /// Splits text into words preserving spaces and delimiters.
  List<String> _splitIntoWords(String text) {
    final words = <String>[];
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == ' ') {
        buffer.write(char);
        words.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    if (buffer.isNotEmpty) {
      words.add(buffer.toString());
    }
    return words;
  }

  double _defaultLineHeight() {
    return _measureText('A', baseFont).height;
  }

  PdfLayoutResult? _createLayoutResult(PdfPage page, Rect bounds) {
    final dummyElement = PdfTextElement(
      text: ' ',
      font: baseFont,
    );
    return dummyElement.draw(
      page: page,
      bounds: Rect.fromLTWH(bounds.left, bounds.bottom, 1, 1),
    );
  }
}

/// Text overflow behavior.
enum GeniusPdfTextOverflow {
  /// Clip text that exceeds bounds (no indicator).
  clip,

  /// Show ellipsis (…) at the end of the last visible line.
  ellipsis,
}

// ─── Internal Layout Models ─────────────────────────────────────────────────

class _RichTextSegment {
  const _RichTextSegment({
    required this.text,
    required this.span,
    required this.font,
    required this.size,
  });

  final String text;
  final GeniusPdfTextSpan span;
  final PdfFont font;
  final Size size;
}

class _RichTextLine {
  const _RichTextLine({
    required this.segments,
    required this.width,
    required this.height,
  });

  final List<_RichTextSegment> segments;
  final double width;
  final double height;
}

// ─────────────────────────────────────────────────────────────────────────────
// Rich Text Builder
// ─────────────────────────────────────────────────────────────────────────────

/// Builder for creating rich text content with a fluent API.
///
/// ## Example
/// ```dart
/// final richText = GeniusPdfRichTextBuilder(baseFont: font, boldFont: boldFont)
///   .text('Total: ')
///   .bold('1,250.00')
///   .space()
///   .small('SAR')
///   .build();
/// ```
class GeniusPdfRichTextBuilder {
  GeniusPdfRichTextBuilder({
    required this.config,
    GeniusPdfTextStyle? defaultStyle,
    this.paragraphAlignment = GeniusPdfParagraphAlignment.start,
  }) : defaultStyle = _resolveRichTextDefaultStyle(defaultStyle, config);

  final GeniusPdfTextStyle defaultStyle;
  final GeniusPdfConfig config;

  PdfFont get baseFont => config.baseFont;

  PdfFont get boldFont => config.boldFont;

  PdfFont? get italicFont => null;

  PdfFont? get boldItalicFont => null;

  bool get isRTL => config.isRTL;
  final GeniusPdfParagraphAlignment paragraphAlignment;

  final List<GeniusPdfTextSpan> _spans = [];

  /// Number of spans added so far.
  int get spanCount => _spans.length;

  /// Whether no spans have been added.
  bool get isEmpty => _spans.isEmpty;

  /// Whether at least one span has been added.
  bool get isNotEmpty => _spans.isNotEmpty;

  // ─── Text Methods ───────────────────────────────────────────────────

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

  /// Adds italic text.
  GeniusPdfRichTextBuilder italic(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.italic(text, color: color));
    return this;
  }

  /// Adds bold-italic text.
  GeniusPdfRichTextBuilder boldItalic(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.boldItalic(text, color: color));
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

  /// Adds highlighted text.
  GeniusPdfRichTextBuilder highlight(String text, {Color? backgroundColor}) {
    _spans.add(GeniusPdfTextSpan.highlight(
      text,
      backgroundColor: backgroundColor ?? const Color(0xFFFFEB3B),
    ));
    return this;
  }

  /// Adds superscript text.
  GeniusPdfRichTextBuilder superscript(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.superscript(text, color: color));
    return this;
  }

  /// Adds subscript text.
  GeniusPdfRichTextBuilder subscript(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.subscript(text, color: color));
    return this;
  }

  /// Adds strikethrough text.
  GeniusPdfRichTextBuilder strikethrough(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.strikethrough(text, color: color));
    return this;
  }

  /// Adds code-style text.
  GeniusPdfRichTextBuilder code(String text) {
    _spans.add(GeniusPdfTextSpan.code(text));
    return this;
  }

  /// Adds a label-style span.
  GeniusPdfRichTextBuilder label(String text) {
    _spans.add(GeniusPdfTextSpan.label(text));
    return this;
  }

  /// Adds a heading-style span.
  GeniusPdfRichTextBuilder heading(String text, {double fontSize = 14}) {
    _spans.add(GeniusPdfTextSpan.heading(text, fontSize: fontSize));
    return this;
  }

  /// Adds a small/caption text.
  GeniusPdfRichTextBuilder small(String text, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.small(text, color: color));
    return this;
  }

  /// Adds a badge-style span.
  GeniusPdfRichTextBuilder badge(String text,
      {Color? backgroundColor, Color? color}) {
    _spans.add(GeniusPdfTextSpan.badge(
      text,
      backgroundColor: backgroundColor ?? const Color(0xFF1976D2),
      color: color ?? const Color(0xFFFFFFFF),
    ));
    return this;
  }

  /// Adds a currency value span.
  GeniusPdfRichTextBuilder currency(String amount,
      {String? symbol, bool symbolBefore = false, Color? color}) {
    _spans.add(GeniusPdfTextSpan.currency(
      amount,
      symbol: symbol,
      symbolBefore: symbolBefore,
      color: color,
    ));
    return this;
  }

  /// Adds a custom styled span.
  GeniusPdfRichTextBuilder span(GeniusPdfTextSpan span) {
    _spans.add(span);
    return this;
  }

  // ─── Spacing & Structure ────────────────────────────────────────────

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

  /// Adds a tab (4 spaces).
  GeniusPdfRichTextBuilder tab() {
    _spans.add(const GeniusPdfTextSpan.plain('    '));
    return this;
  }

  /// Adds a separator (e.g. ' | ', ' - ', ' · ').
  GeniusPdfRichTextBuilder separator([String sep = ' | ']) {
    _spans.add(GeniusPdfTextSpan(
      text: sep,
      color: const Color(0xFF9E9E9E),
    ));
    return this;
  }

  // ─── Conditional Methods ────────────────────────────────────────────

  /// Adds a span only if [condition] is true.
  GeniusPdfRichTextBuilder addIf(bool condition, GeniusPdfTextSpan span) {
    if (condition) _spans.add(span);
    return this;
  }

  /// Adds plain text only if [condition] is true.
  GeniusPdfRichTextBuilder textIf(bool condition, String text) {
    if (condition) _spans.add(GeniusPdfTextSpan.plain(text));
    return this;
  }

  /// Adds bold text only if [condition] is true.
  GeniusPdfRichTextBuilder boldIf(bool condition, String text, {Color? color}) {
    if (condition) _spans.add(GeniusPdfTextSpan.bold(text, color: color));
    return this;
  }

  /// Adds text styled positive or negative based on the value.
  GeniusPdfRichTextBuilder amount(double value, {String? format}) {
    final display = format ?? value.toStringAsFixed(2);
    if (value >= 0) {
      _spans.add(GeniusPdfTextSpan.positive(display));
    } else {
      _spans.add(GeniusPdfTextSpan.negative(display));
    }
    return this;
  }

  // ─── Build ──────────────────────────────────────────────────────────

  /// Builds the rich text component.
  GeniusPdfRichText build({
    int? maxLines,
    GeniusPdfTextOverflow overflow = GeniusPdfTextOverflow.clip,
  }) {
    return GeniusPdfRichText(
      spans: List.unmodifiable(_spans),
      config: config,
      defaultStyle: defaultStyle,
      baseFont: baseFont,
      boldFont: boldFont,
      italicFont: italicFont,
      boldItalicFont: boldItalicFont,
      isRTL: isRTL,
      paragraphAlignment: paragraphAlignment,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Clears all spans.
  void clear() {
    _spans.clear();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Labeled Value
// ─────────────────────────────────────────────────────────────────────────────

/// A labeled value component for key-value pairs.
///
/// Useful for displaying data like "Invoice No: INV-001" or "المجموع: 1,000 ريال".
class GeniusPdfLabeledValue {
  const GeniusPdfLabeledValue({
    required this.config,
    required this.label,
    required this.value,
    this.labelAr,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
    this.separator = ': ',
  });

  /// Creates a labeled value where the value is styled as positive (green).
  factory GeniusPdfLabeledValue.positive({
    required String label,
    required String value,
    String? labelAr,
    required GeniusPdfConfig config,
  }) {
    return GeniusPdfLabeledValue(
      config: config,
      label: label,
      value: value,
      labelAr: labelAr,
      valueColor: const Color(0xFF2E7D32),
    );
  }

  /// Creates a labeled value where the value is styled as negative (red).
  factory GeniusPdfLabeledValue.negative({
    required String label,
    required String value,
    String? labelAr,
    required GeniusPdfConfig config,
    required PdfFont baseFont,
    required PdfFont boldFont,
  }) {
    return GeniusPdfLabeledValue(
      config: config,
      label: label,
      value: value,
      labelAr: labelAr,
      valueColor: const Color(0xFFC62828),
    );
  }

  final GeniusPdfConfig config;
  final String label;
  final String? labelAr;
  final String value;
  final GeniusPdfTextStyle? labelStyle;
  final GeniusPdfTextStyle? valueStyle;
  final Color? valueColor;
  final String separator;

  /// Gets the display label based on locale.
  String getLabel() {
    if (config.isRTL && labelAr != null) return labelAr!;
    return label;
  }

  /// Draws the labeled value.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    final labelText = getLabel();

    final valueSpan = valueColor != null
        ? GeniusPdfTextSpan.bold(value, color: valueColor)
        : GeniusPdfTextSpan.plain(value);

    final richText = GeniusPdfRichText(
      spans: [
        GeniusPdfTextSpan.bold(labelText),
        GeniusPdfTextSpan.plain(separator),
        valueSpan,
      ],
      config: config,
      baseFont: config.baseFont,
      boldFont: config.boldFont,
      isRTL: config.isRTL,
    );

    return richText.draw(
        page: page, bounds: bounds, layoutFormat: layoutFormat);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Key-Value List
// ─────────────────────────────────────────────────────────────────────────────

/// A key-value list component for displaying multiple labeled values.
class GeniusPdfKeyValueList {
  const GeniusPdfKeyValueList({
    required this.items,
    required this.config,
    this.itemSpacing = 4,
    this.baseFont,
    this.boldFont,
    this.isRTL = true,
    this.columns = 1,
    this.columnSpacing = 20,
  });

  final List<GeniusPdfLabeledValue> items;
  final GeniusPdfConfig config;
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
          config: config,
          label: item.label,
          labelAr: item.labelAr,
          value: item.value,
          labelStyle: item.labelStyle,
          valueStyle: item.valueStyle,
          valueColor: item.valueColor,
          separator: item.separator,
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
        if (startIndex >= items.length) break;
        final columnItems = items.sublist(startIndex, endIndex);

        double colY = bounds.top;
        final colX = bounds.left + (col * (columnWidth + columnSpacing));

        for (final item in columnItems) {
          final labeledValue = GeniusPdfLabeledValue(
            config: config,
            label: item.label,
            labelAr: item.labelAr,
            value: item.value,
            valueColor: item.valueColor,
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

// ─────────────────────────────────────────────────────────────────────────────
// Bullet List
// ─────────────────────────────────────────────────────────────────────────────

/// Bullet/number style for [GeniusPdfBulletList].
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
class GeniusPdfTextMeasurer {
  GeniusPdfTextMeasurer({
    required this.config,
    PdfFont? baseFont,
    PdfFont? boldFont,
    this.italicFont,
    this.boldItalicFont,
  })  : baseFont = _resolveRichTextBaseFont(baseFont, config),
        boldFont = _resolveRichTextBoldFont(boldFont, baseFont, config);

  final GeniusPdfConfig config;
  final PdfFont baseFont;
  final PdfFont boldFont;
  final PdfFont? italicFont;
  final PdfFont? boldItalicFont;

  /// Measures a single text span's size.
  Size measureSpan(GeniusPdfTextSpan span) {
    final font = _resolveFont(span);
    return font.measureString(span.text);
  }

  /// Measures the width of a single text span.
  double measureSpanWidth(GeniusPdfTextSpan span) {
    return measureSpan(span).width;
  }

  /// Measures the total width of multiple spans (single-line, no wrapping).
  double measureSpansWidth(List<GeniusPdfTextSpan> spans) {
    double total = 0;
    for (final span in spans) {
      total += measureSpanWidth(span);
    }
    return total;
  }

  /// Measures the height a [GeniusPdfRichText] will occupy at the given width.
  double measureRichTextHeight(GeniusPdfRichText richText,
      {required double availableWidth}) {
    return richText.measureHeight(availableWidth);
  }

  /// Checks whether the given spans fit in a single line at the given width.
  bool fitsInSingleLine(List<GeniusPdfTextSpan> spans, double availableWidth) {
    return measureSpansWidth(spans) <= availableWidth;
  }

  /// Returns the number of lines the spans will occupy at the given width.
  int estimateLineCount(List<GeniusPdfTextSpan> spans, double availableWidth) {
    if (availableWidth <= 0) return 0;
    final totalWidth = measureSpansWidth(spans);
    return (totalWidth / availableWidth).ceil();
  }

  PdfFont _resolveFont(GeniusPdfTextSpan span) {
    final wantBold = span.isBold || (span.style?.isBold ?? false);
    final wantItalic = span.isItalic;

    if (wantBold && wantItalic) return boldItalicFont ?? boldFont;
    if (wantBold) return boldFont;
    if (wantItalic) return italicFont ?? baseFont;
    return baseFont;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Markdown Parser Configuration
// ─────────────────────────────────────────────────────────────────────────────

/// Configuration for [GeniusPdfSimpleMarkdownParser].
///
/// Controls link styling and auto-detection of URLs, emails, and phone numbers
/// in parsed text.
///
/// ## Example
/// ```dart
/// final config = GeniusPdfMarkdownConfig(
///   linkColor: Color(0xFF0D47A1),
///   autoDetectUrls: true,
///   autoDetectEmails: true,
/// );
/// final spans = GeniusPdfSimpleMarkdownParser.parse(
///   'Visit https://example.com or email info@example.com',
///   config: config,
/// );
/// ```
class GeniusPdfMarkdownConfig {

  /// Creates a markdown configuration.
  const GeniusPdfMarkdownConfig({
    this.linkColor = const Color(0xFF1565C0),
    this.autoDetectUrls = true,
    this.autoDetectEmails = true,
    this.autoDetectPhones = false,
    this.autoLinkColor,
  });
  /// Color applied to explicit markdown links `[text](url)`.
  final Color linkColor;

  /// Whether to auto-detect bare URLs (`https://...`, `http://...`, `www.…`).
  final bool autoDetectUrls;

  /// Whether to auto-detect email addresses (`user@domain.com`).
  final bool autoDetectEmails;

  /// Whether to auto-detect phone numbers (`+123-456-7890`).
  final bool autoDetectPhones;

  /// Color for auto-detected links (URLs, emails, phones).
  /// Falls back to [linkColor] if null.
  final Color? autoLinkColor;

  /// The effective color for auto-detected links.
  Color get effectiveAutoLinkColor => autoLinkColor ?? linkColor;

  /// Default configuration with standard blue links and auto-detection enabled.
  static const defaultConfig = GeniusPdfMarkdownConfig();

  /// Configuration with no auto-detection (only explicit markdown links).
  static const noAutoDetect = GeniusPdfMarkdownConfig(
    autoDetectUrls: false,
    autoDetectEmails: false,
    autoDetectPhones: false,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Simple Markdown Parser
// ─────────────────────────────────────────────────────────────────────────────

/// Converts simple markdown-like markup into [GeniusPdfTextSpan] list.
///
/// Supported syntax:
/// - `**bold**` → bold span
/// - `*italic*` → italic span
/// - `***bold italic***` → bold-italic span
/// - `~~strikethrough~~` → strikethrough span
/// - `==highlight==` → highlighted span
/// - `^superscript^` → superscript span
/// - `` `code` `` → code span
/// - `[text](url)` → link span (uses [GeniusPdfMarkdownConfig.linkColor])
/// - `[text](url){#RRGGBB}` → link span with inline hex color
/// - Bare URLs (`https://...`) → auto-detected link (when enabled)
/// - Emails (`user@domain.com`) → auto-detected mailto link (when enabled)
/// - Phone numbers (`+123-456-7890`) → auto-detected tel link (when enabled)
///
/// ## Example
/// ```dart
/// final spans = GeniusPdfSimpleMarkdownParser.parse(
///   'This is **bold** and *italic* with a [link](https://example.com)',
/// );
/// ```
///
/// ## Example with config
/// ```dart
/// final spans = GeniusPdfSimpleMarkdownParser.parse(
///   'Visit https://example.com for details',
///   config: GeniusPdfMarkdownConfig(
///     linkColor: Color(0xFF0D47A1),
///     autoDetectUrls: true,
///   ),
/// );
/// ```
class GeniusPdfSimpleMarkdownParser {
  GeniusPdfSimpleMarkdownParser._();

  // ── Auto-detection patterns ──────────────────────────────────────────────

  /// Matches bare URLs: https://..., http://..., www.…
  static final _urlPattern = RegExp(r'https?://[^\s<>\]\)]+|www\.[^\s<>\]\)]+');

  /// Matches email addresses: user@domain.com
  static final _emailPattern =
      RegExp(r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}');

  /// Matches phone numbers: +1-234-567-8901, (123) 456-7890, etc.
  static final _phonePattern = RegExp(
      r'(?:\+?\d{1,3}[-.\s]?)?(?:\(?\d{2,4}\)?[-.\s]?)?\d{3,4}[-.\s]?\d{3,4}');

  /// Matches link with inline hex color: [text](url){#RRGGBB}
  static final _linkWithColorPattern =
      RegExp(r'\[([^\]]+)\]\(([^)]+)\)\{#([0-9a-fA-F]{6})\}');

  /// Matches standard link: [text](url)
  static final _linkPattern = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

  // ── Public API ───────────────────────────────────────────────────────────

  /// Parses a markdown-like string into a list of spans.
  ///
  /// If [config] is null, uses [GeniusPdfMarkdownConfig.noAutoDetect] for
  /// backward compatibility (explicit links only, default blue color).
  static List<GeniusPdfTextSpan> parse(
    String input, {
    GeniusPdfMarkdownConfig? config,
  }) {
    if (input.isEmpty) return [];

    final effectiveConfig = config ?? GeniusPdfMarkdownConfig.noAutoDetect;
    final spans = <GeniusPdfTextSpan>[];
    final buffer = StringBuffer();
    int i = 0;

    while (i < input.length) {
      // ── Link with inline color [text](url){#RRGGBB} ──────────
      if (input[i] == '[') {
        final colorMatch = _linkWithColorPattern.matchAsPrefix(input, i);
        if (colorMatch != null) {
          _flushBuffer(buffer, spans);
          final hexColor = colorMatch.group(3)!;
          final color = Color(0xFF000000 | int.parse(hexColor, radix: 16));
          spans.add(GeniusPdfTextSpan.link(
            colorMatch.group(1)!,
            link: colorMatch.group(2)!,
            color: color,
          ));
          i += colorMatch.end - colorMatch.start;
          continue;
        }

        // ── Standard link [text](url) ──────────────────────────
        final linkMatch = _linkPattern.matchAsPrefix(input, i);
        if (linkMatch != null) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.link(
            linkMatch.group(1)!,
            link: linkMatch.group(2)!,
            color: effectiveConfig.linkColor,
          ));
          i += linkMatch.end - linkMatch.start;
          continue;
        }
      }

      // ── Bold italic ***text*** ──────────────────────────────────
      if (_matchAt(input, i, '***')) {
        final end = input.indexOf('***', i + 3);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.boldItalic(input.substring(i + 3, end)));
          i = end + 3;
          continue;
        }
      }

      // ── Bold **text** ───────────────────────────────────────────
      if (_matchAt(input, i, '**')) {
        final end = input.indexOf('**', i + 2);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.bold(input.substring(i + 2, end)));
          i = end + 2;
          continue;
        }
      }

      // ── Strikethrough ~~text~~ ──────────────────────────────────
      if (_matchAt(input, i, '~~')) {
        final end = input.indexOf('~~', i + 2);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(
              GeniusPdfTextSpan.strikethrough(input.substring(i + 2, end)));
          i = end + 2;
          continue;
        }
      }

      // ── Highlight ==text== ──────────────────────────────────────
      if (_matchAt(input, i, '==')) {
        final end = input.indexOf('==', i + 2);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.highlight(input.substring(i + 2, end)));
          i = end + 2;
          continue;
        }
      }

      // ── Italic *text* (single, not double) ──────────────────────
      if (input[i] == '*' && !_matchAt(input, i, '**')) {
        final end = _findSingleChar(input, '*', i + 1);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.italic(input.substring(i + 1, end)));
          i = end + 1;
          continue;
        }
      }

      // ── Superscript ^text^ ──────────────────────────────────────
      if (input[i] == '^') {
        final end = input.indexOf('^', i + 1);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.superscript(input.substring(i + 1, end)));
          i = end + 1;
          continue;
        }
      }

      // ── Code `text` ────────────────────────────────────────────
      if (input[i] == '`') {
        final end = input.indexOf('`', i + 1);
        if (end != -1) {
          _flushBuffer(buffer, spans);
          spans.add(GeniusPdfTextSpan.code(input.substring(i + 1, end)));
          i = end + 1;
          continue;
        }
      }

      // ── Plain character ─────────────────────────────────────────
      buffer.write(input[i]);
      i++;
    }

    // Flush remaining buffer
    if (buffer.isNotEmpty) {
      spans.add(GeniusPdfTextSpan.plain(buffer.toString()));
    }

    // ── Second pass: auto-detect URLs, emails, phones in plain spans ──
    if (effectiveConfig.autoDetectUrls ||
        effectiveConfig.autoDetectEmails ||
        effectiveConfig.autoDetectPhones) {
      return _autoDetectLinks(spans, effectiveConfig);
    }

    return spans;
  }

  // ── Auto-detection (second pass) ─────────────────────────────────────────

  /// Scans plain text spans for bare URLs, emails, and phone numbers,
  /// splitting them into link spans and remaining plain text.
  static List<GeniusPdfTextSpan> _autoDetectLinks(
    List<GeniusPdfTextSpan> spans,
    GeniusPdfMarkdownConfig config,
  ) {
    final result = <GeniusPdfTextSpan>[];

    for (final span in spans) {
      // Only process plain text spans (no existing links, no styled spans)
      if (span.hasLink ||
          span.isBold ||
          span.isItalic ||
          span.isStrikethrough ||
          span.isSuperscript ||
          span.isSubscript ||
          span.backgroundColor != null) {
        result.add(span);
        continue;
      }

      final text = span.text;
      final matches = <_AutoMatch>[];

      // Collect all auto-detection matches
      if (config.autoDetectUrls) {
        for (final m in _urlPattern.allMatches(text)) {
          matches.add(_AutoMatch(m.start, m.end, m.group(0)!, _AutoType.url));
        }
      }
      if (config.autoDetectEmails) {
        for (final m in _emailPattern.allMatches(text)) {
          // Avoid matching emails that overlap with URLs
          final email = m.group(0)!;
          matches.add(_AutoMatch(m.start, m.end, email, _AutoType.email));
        }
      }
      if (config.autoDetectPhones) {
        for (final m in _phonePattern.allMatches(text)) {
          final phone = m.group(0)!;
          // Only match if the phone has at least 7 digits
          final digits = phone.replaceAll(RegExp(r'\D'), '');
          if (digits.length >= 7) {
            matches.add(_AutoMatch(m.start, m.end, phone, _AutoType.phone));
          }
        }
      }

      if (matches.isEmpty) {
        result.add(span);
        continue;
      }

      // Sort by start position and remove overlaps
      matches.sort((a, b) => a.start.compareTo(b.start));
      final filtered = _removeOverlaps(matches);

      // Split the plain text span into segments
      int pos = 0;
      final linkColor = config.effectiveAutoLinkColor;

      for (final match in filtered) {
        // Add plain text before this match
        if (match.start > pos) {
          result.add(GeniusPdfTextSpan.plain(text.substring(pos, match.start)));
        }

        // Add the auto-detected link
        String url;
        switch (match.type) {
          case _AutoType.url:
            url = match.text.startsWith('www.')
                ? 'https://${match.text}'
                : match.text;
            break;
          case _AutoType.email:
            url = 'mailto:${match.text}';
            break;
          case _AutoType.phone:
            url = 'tel:${match.text.replaceAll(RegExp(r'[\s\-\(\)]'), '')}';
            break;
        }

        result.add(GeniusPdfTextSpan.link(
          match.text,
          link: url,
          color: linkColor,
        ));

        pos = match.end;
      }

      // Add remaining plain text
      if (pos < text.length) {
        result.add(GeniusPdfTextSpan.plain(text.substring(pos)));
      }
    }

    return result;
  }

  /// Removes overlapping matches, keeping earlier/longer ones.
  static List<_AutoMatch> _removeOverlaps(List<_AutoMatch> sorted) {
    if (sorted.isEmpty) return sorted;
    final result = <_AutoMatch>[sorted.first];
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].start >= result.last.end) {
        result.add(sorted[i]);
      }
    }
    return result;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Flushes the [buffer] into a plain text span.
  static void _flushBuffer(StringBuffer buffer, List<GeniusPdfTextSpan> spans) {
    if (buffer.isNotEmpty) {
      spans.add(GeniusPdfTextSpan.plain(buffer.toString()));
      buffer.clear();
    }
  }

  /// Checks if [pattern] appears at position [i] in [input].
  static bool _matchAt(String input, int i, String pattern) {
    if (i + pattern.length > input.length) return false;
    return input.substring(i, i + pattern.length) == pattern;
  }

  /// Finds the next occurrence of a single [char] that is NOT doubled.
  static int _findSingleChar(String input, String char, int start) {
    for (int i = start; i < input.length; i++) {
      if (input[i] == char) {
        // Make sure it's not a double (e.g. ** for bold)
        final isDouble = (i + 1 < input.length && input[i + 1] == char);
        if (!isDouble) return i;
      }
    }
    return -1;
  }
}

/// Type of auto-detected content.
enum _AutoType { url, email, phone }

/// A match from auto-detection.
class _AutoMatch {
  const _AutoMatch(this.start, this.end, this.text, this.type);
  final int start;
  final int end;
  final String text;
  final _AutoType type;
}

// ─────────────────────────────────────────────────────────────────────────────
// String Extensions
// ─────────────────────────────────────────────────────────────────────────────

/// Extension methods on [String] for quick span creation.
extension GeniusPdfStringSpanExtension on String {
  /// Converts to a plain text span.
  GeniusPdfTextSpan toSpan() => GeniusPdfTextSpan.plain(this);

  /// Converts to a bold text span.
  GeniusPdfTextSpan toBoldSpan({Color? color}) =>
      GeniusPdfTextSpan.bold(this, color: color);

  /// Converts to an italic text span.
  GeniusPdfTextSpan toItalicSpan({Color? color}) =>
      GeniusPdfTextSpan.italic(this, color: color);

  /// Converts to a colored text span.
  GeniusPdfTextSpan toColoredSpan(Color color) =>
      GeniusPdfTextSpan.colored(this, color);

  /// Converts to a highlighted text span.
  GeniusPdfTextSpan toHighlightSpan({Color? backgroundColor}) =>
      GeniusPdfTextSpan.highlight(this, backgroundColor: backgroundColor);

  /// Converts to a link text span.
  GeniusPdfTextSpan toLinkSpan(String url, {Color? color}) =>
      GeniusPdfTextSpan.link(this,
          link: url, color: color ?? const Color(0xFF1565C0));

  /// Converts to a badge text span.
  GeniusPdfTextSpan toBadgeSpan({Color? backgroundColor, Color? color}) =>
      GeniusPdfTextSpan.badge(this,
          backgroundColor: backgroundColor ?? const Color(0xFF1976D2),
          color: color ?? const Color(0xFFFFFFFF));

  /// Converts to a label text span.
  GeniusPdfTextSpan toLabelSpan() => GeniusPdfTextSpan.label(this);

  /// Converts to a heading text span.
  GeniusPdfTextSpan toHeadingSpan({double fontSize = 14}) =>
      GeniusPdfTextSpan.heading(this, fontSize: fontSize);

  /// Converts to a small/caption text span.
  GeniusPdfTextSpan toSmallSpan({Color? color}) =>
      GeniusPdfTextSpan.small(this, color: color);

  /// Parses this string as simple markdown into spans.
  ///
  /// If [config] is provided, enables auto-detection of URLs, emails, and
  /// phone numbers, and customizes link colors.
  List<GeniusPdfTextSpan> parseMarkdownSpans(
          {GeniusPdfMarkdownConfig? config}) =>
      GeniusPdfSimpleMarkdownParser.parse(this, config: config);
}
