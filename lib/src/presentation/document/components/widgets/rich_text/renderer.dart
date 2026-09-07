part of '../pdf_rich_text.dart';

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
    GeniusPdfDirectionality? directionality,
    GeniusPdfDirection direction = GeniusPdfDirection.auto,
    this.lineSpacing = 1.2,
    this.paragraphSpacing = 8,
    GeniusPdfParagraphAlignment? paragraphAlignment,
    this.maxLines,
    this.overflow = GeniusPdfTextOverflow.clip,
    this.backgroundPadding = 1.5,
  })  : baseFont = _resolveRichTextBaseFont(baseFont, config),
        boldFont = _resolveRichTextBoldFont(boldFont, baseFont, config),
        defaultStyle = _resolveRichTextDefaultStyle(defaultStyle, config),
        _directionality = GeniusPdfComponentDirectionality.context(
          config: config,
          inherited: directionality,
          componentDirection: isRTL == null
              ? direction
              : (isRTL ? GeniusPdfDirection.rtl : GeniusPdfDirection.ltr),
        ),
        isRTL = GeniusPdfComponentDirectionality.context(
                  config: config,
                  inherited: directionality,
                  componentDirection: isRTL == null
                      ? direction
                      : (isRTL
                          ? GeniusPdfDirection.rtl
                          : GeniusPdfDirection.ltr),
                ).resolve().direction ==
            GeniusPdfResolvedDirection.rtl,
        paragraphAlignment = _resolveRichTextParagraphAlignment(
          paragraphAlignment,
          _resolveRichTextDefaultStyle(defaultStyle, config),
        );

  /// Text spans to render.
  final List<GeniusPdfTextSpan> spans;

  /// Default text style.
  final GeniusPdfTextStyle defaultStyle;

  /// PDF configuration.
  final GeniusPdfConfig config;

  final GeniusPdfDirectionality _directionality;
  GeniusPdfDirectionality get directionality => _directionality;

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

  /// Cache for sized fonts to avoid repeated PdfTrueTypeFont construction.
  final Map<String, PdfFont> _fontCache = {};

  PdfTextDirection _resolveSpanDirection(GeniusPdfTextSpan span) {
    switch (span.direction) {
      case GeniusPdfDirection.rtl:
        return PdfTextDirection.rightToLeft;
      case GeniusPdfDirection.ltr:
        return PdfTextDirection.leftToRight;
      case GeniusPdfDirection.auto:
        break;
    }
    switch (span.textDirectionOverride) {
      case TextDirection.rtl:
        return PdfTextDirection.rightToLeft;
      case TextDirection.ltr:
        return PdfTextDirection.leftToRight;
      case null:
        return GeniusPdfComponentDirectionality.valuePdfDirection(
          context: _directionality,
          text: span.text,
        );
    }
  }

  PdfTextAlignment _resolveSpanAlignment(PdfTextDirection direction) {
    return direction == PdfTextDirection.rightToLeft
        ? PdfTextAlignment.right
        : PdfTextAlignment.left;
  }

  /// Gets the combined plain text of all spans.
  String get plainText => spans.map((s) => s.text).join();

  /// Number of spans.
  int get spanCount => spans.length;

  /// Whether there are no spans.
  bool get isEmpty => spans.isEmpty;

  /// Resolves the font for a given span (base style resolution, no sizing).
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

  /// Resolves a font at the correct size for a span.
  ///
  /// If [span.fontSize] differs from the default or if the span is
  /// superscript/subscript, creates a font at the appropriate size
  /// using config font bytes. Falls back to the base-resolved font.
  PdfFont _resolveSizedFont(GeniusPdfTextSpan span) {
    final font = _resolveFont(span);
    final desiredSize = _resolveEffectiveFontSize(span);

    // If the font is already at the desired size, use it as-is.
    if ((font.size - desiredSize).abs() < 0.01) return font;

    // Build a cache key from style + size.
    final wantBold = span.isBold || (span.style?.isBold ?? false);
    final wantItalic = span.isItalic;
    final cacheKey =
        '${wantBold ? 'b' : ''}${wantItalic ? 'i' : ''}_$desiredSize';

    if (_fontCache.containsKey(cacheKey)) return _fontCache[cacheKey]!;

    // Create a sized font from config bytes.
    final Uint8List bytes;
    if (wantBold) {
      bytes = config.boldFontBytes ?? config.baseFontBytes;
    } else {
      bytes = config.baseFontBytes;
    }

    PdfFontStyle style = PdfFontStyle.regular;
    if (wantBold && wantItalic) {
      style = PdfFontStyle.bold;
    } else if (wantBold) {
      style = PdfFontStyle.bold;
    } else if (wantItalic) {
      style = PdfFontStyle.italic;
    }

    final sizedFont = PdfTrueTypeFont(bytes, desiredSize, style: style);
    _fontCache[cacheKey] = sizedFont;
    return sizedFont;
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
        final sizedFont = _resolveSizedFont(span);
        final textSize = _measureText(seg.text, sizedFont);
        final effectiveFontSize = _resolveEffectiveFontSize(span);

        // Apply ellipsis on last segment of last truncated line
        String drawText = seg.text;
        double drawWidth = textSize.width;
        if (isLastLine &&
            si == line.segments.length - 1 &&
            overflow == GeniusPdfTextOverflow.ellipsis) {
          const ellipsis = '…';
          final ellipsisSize = _measureText(ellipsis, sizedFont);
          if (drawWidth + ellipsisSize.width <= bounds.width) {
            drawText = '${seg.text}$ellipsis';
            drawWidth += ellipsisSize.width;
          }
        }

        // Resolve color + opacity
        final baseColor = span.color ?? span.style?.color ?? defaultStyle.color;
        final effectiveColor = span.opacity < 1.0
            ? Color.fromARGB(
                (baseColor.a * 255.0 * span.opacity).round(),
                (baseColor.r * 255.0).round(),
                (baseColor.g * 255.0).round(),
                (baseColor.b * 255.0).round(),
              )
            : baseColor;
        final brush = PdfSolidBrush(effectiveColor.toPdfColor());

        // Y offset for superscript / subscript
        final yOffset = _resolveYOffset(span, line.height);
        final drawY = currentY + yOffset;

        final drawX = isRTL ? cursorX - drawWidth : cursorX;
        final spanDirection = _resolveSpanDirection(span);
        final spanAlignment = _resolveSpanAlignment(spanDirection);

        // ── Draw background ──────────────────────────────────────
        if (span.hasBackground) {
          final bgX = math.max(0.0, drawX - backgroundPadding);
          final bgRect = Rect.fromLTWH(
            bgX,
            drawY - backgroundPadding,
            drawWidth + backgroundPadding * 2,
            textSize.height + backgroundPadding * 2,
          );
          graphics.drawRectangle(
            brush: PdfSolidBrush(span.backgroundColor!.toPdfColor()),
            bounds: bgRect,
          );
        }

        // ── Draw text / link ─────────────────────────────────────
        if (span.hasLink) {
          // Use PdfTextWebLink for proper clickable hyperlinks.
          final linkFormat = PdfStringFormat(
            alignment: spanAlignment,
            textDirection: spanDirection,
            characterSpacing: span.letterSpacing ?? 0,
            wordSpacing: span.wordSpacing ?? 0,
          );
          final webLink = PdfTextWebLink(
            url: span.link!,
            text: drawText,
            font: sizedFont,
            brush: brush,
            pen: PdfPen(PdfColor(0, 0, 0, 0), width: 0),
            format: linkFormat,
          );
          webLink.draw(page, Offset(drawX, drawY));
        } else {
          final format = PdfStringFormat(
            alignment: spanAlignment,
            textDirection: spanDirection,
            characterSpacing: span.letterSpacing ?? 0,
            wordSpacing: span.wordSpacing ?? 0,
          );

          graphics.drawString(
            drawText,
            sizedFont,
            brush: brush,
            bounds: Rect.fromLTWH(
              drawX,
              drawY,
              drawWidth + (span.letterSpacing ?? 0) * drawText.length + 2,
              effectiveFontSize + 4,
            ),
            format: format,
          );
        }

        // ── Draw decorations ─────────────────────────────────────
        final penColor = effectiveColor.toPdfColor();
        final decorPen = PdfPen(penColor, width: 0.5);

        // Skip manual underline for links — PdfTextWebLink handles it.
        if (span.isUnderline && !span.hasLink) {
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

    void flushLine() {
      // Trim trailing whitespace from the last segment on this line.
      if (currentSegments.isNotEmpty) {
        final lastSeg = currentSegments.last;
        final trimmed = lastSeg.text.trimRight();
        if (trimmed != lastSeg.text) {
          final trimmedSize = _measureText(trimmed, lastSeg.font);
          final widthDiff = lastSeg.size.width - trimmedSize.width;
          currentSegments[currentSegments.length - 1] = _RichTextSegment(
            text: trimmed,
            span: lastSeg.span,
            font: lastSeg.font,
            size: trimmedSize,
          );
          currentLineWidth -= widthDiff;
        }
      }
      lines.add(_RichTextLine(
        segments: List.unmodifiable(currentSegments),
        width: currentLineWidth,
        height:
            currentLineHeight > 0 ? currentLineHeight : _defaultLineHeight(),
      ));
      currentSegments = [];
      currentLineWidth = 0;
      currentLineHeight = 0;
    }

    for (final span in spans) {
      if (span.isEmpty) continue;

      // Handle explicit newlines
      if (span.text == '\n') {
        flushLine();
        continue;
      }

      final font = _resolveSizedFont(span);
      final words = _splitIntoWords(span.text);

      for (final word in words) {
        final wordSize = _measureText(word, font);
        final wordWidth = wordSize.width;
        final wordHeight = wordSize.height;

        // Check if word fits on current line
        if (currentLineWidth + wordWidth > maxWidth &&
            currentSegments.isNotEmpty) {
          flushLine();
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
      flushLine();
    }

    return lines;
  }

  /// Splits text into words, attaching trailing space to each word.
  ///
  /// Example: `"hello world"` → `["hello ", "world"]`
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
    // Draw a minimal invisible element so that result.bounds.bottom
    // equals the actual content bottom, not content bottom + font height.
    final fontHeight = baseFont.height;
    final drawY = (bounds.bottom - fontHeight)
        .clamp(0.0, bounds.bottom)
        .toDouble();
    final dummyElement = PdfTextElement(
      text: ' ',
      font: baseFont,
    );
    return dummyElement.draw(
      page: page,
      bounds: Rect.fromLTWH(bounds.left, drawY, 1, fontHeight + 1),
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
