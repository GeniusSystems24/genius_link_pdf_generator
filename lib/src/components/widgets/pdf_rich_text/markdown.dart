part of '../pdf_rich_text.dart';

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

  /// Converts to a web link text span rendered via [PdfTextWebLink].
  GeniusPdfTextSpan toWebLinkSpan(String url, {Color? color}) =>
      GeniusPdfTextSpan.webLink(this,
          url: url, color: color ?? const Color(0xFF1565C0));

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
