part of '../pdf_rich_text.dart';

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

GeniusPdfParagraphAlignment _resolveRichTextParagraphAlignment(
  GeniusPdfParagraphAlignment? paragraphAlignment,
  GeniusPdfTextStyle defaultStyle,
) {
  if (paragraphAlignment != null) return paragraphAlignment;

  switch (defaultStyle.alignment) {
    case GeniusPdfTextAlign.center:
      return GeniusPdfParagraphAlignment.center;
    case GeniusPdfTextAlign.end:
      return GeniusPdfParagraphAlignment.end;
    case GeniusPdfTextAlign.start:
    case GeniusPdfTextAlign.justify:
      return GeniusPdfParagraphAlignment.start;
  }
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
///   backgroundColor: Colors.yellow.withValues(alpha:0.3),
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

  /// Creates a web link text span rendered via [PdfTextWebLink].
  ///
  /// Similar to [GeniusPdfTextSpan.link], but explicitly intended for web URLs.
  /// The link is rendered using Syncfusion's [PdfTextWebLink] for proper
  /// clickable hyperlink behavior in PDF viewers.
  ///
  /// ```dart
  /// GeniusPdfTextSpan.webLink(
  ///   'Visit Google',
  ///   url: 'https://www.google.com',
  ///   color: Color(0xFF0D47A1),
  /// )
  /// ```
  const GeniusPdfTextSpan.webLink(
    this.text, {
    required String url,
    this.color = const Color(0xFF1565C0),
    this.tooltip,
    this.fontSize,
  })  : style = null,
        link = url,
        backgroundColor = null,
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
