part of '../pdf_rich_text.dart';

class GeniusPdfRichTextBuilder {
  GeniusPdfRichTextBuilder({
    required this.config,
    GeniusPdfTextStyle? defaultStyle,
    GeniusPdfParagraphAlignment? paragraphAlignment,
  })  : defaultStyle = _resolveRichTextDefaultStyle(defaultStyle, config),
        paragraphAlignment = _resolveRichTextParagraphAlignment(
          paragraphAlignment,
          _resolveRichTextDefaultStyle(defaultStyle, config),
        );

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

  /// Adds a web link rendered via [PdfTextWebLink].
  ///
  /// Creates a proper clickable hyperlink in the PDF using
  /// Syncfusion's PdfTextWebLink annotation.
  GeniusPdfRichTextBuilder webLink(String text, String url, {Color? color}) {
    _spans.add(GeniusPdfTextSpan.webLink(
      text,
      url: url,
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
