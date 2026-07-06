part of '../pdf_rich_text.dart';

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
