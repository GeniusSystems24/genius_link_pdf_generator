part of '../pdf_report_header.dart';

enum GeniusPdfLogoPosition {
  /// Start side (left in LTR, right in RTL).
  start,

  /// End side (right in LTR, left in RTL).
  end,

  /// Centered horizontally.
  center,

  /// Centered above title.
  centerTop,

  /// Centered below content.
  centerBottom,

  /// Logo in the background (watermark style).
  background,
}

/// Title alignment options (direction-aware).
///
/// `start` and `end` resolve based on RTL/LTR context:
/// - In LTR: start = left, end = right
/// - In RTL: start = right, end = left
enum GeniusPdfTitleAlignment {
  /// Aligned to start (left in LTR, right in RTL).
  start,

  /// Aligned to end (right in LTR, left in RTL).
  end,

  /// Centered.
  center;

  PdfTextAlignment toPdfTextAlignment(bool isRTL) {
    switch (this) {
      case GeniusPdfTitleAlignment.start:
        return isRTL ? PdfTextAlignment.right : PdfTextAlignment.left;
      case GeniusPdfTitleAlignment.end:
        return isRTL ? PdfTextAlignment.left : PdfTextAlignment.right;
      case GeniusPdfTitleAlignment.center:
        return PdfTextAlignment.center;
    }
  }
}

// ---------------------------------------------------------------------------
// Style
// ---------------------------------------------------------------------------

/// Style configuration for report headers.
///
/// Comprehensive styling options for:
/// - Background and borders
/// - Title, subtitle, and company info typography
/// - Logo positioning and sizing
/// - Spacing and alignment control
/// - Decorative elements
///
/// ## Example
/// ```dart
/// GeniusPdfReportHeaderStyle.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// )
/// ```
