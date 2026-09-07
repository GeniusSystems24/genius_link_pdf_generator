part of '../pdf_report_header.dart';

enum GeniusPdfReportHeaderLayout {
  /// Standard layout with logo, company info, and centered title.
  standard,

  /// Compact layout with logo and title side by side.
  compact,

  /// Centered layout with everything centered.
  centered,

  /// Invoice-style layout with dual company info.
  invoice,

  /// Bilingual split: English info on left, logo in center, Arabic info on right.
  bilingualSplit,

  /// Letter-style layout with company on top left.
  letterhead,

  /// Report card layout with bordered sections.
  reportCard,

  /// Minimal layout with just title and optional date.
  minimal,

  /// Full width layout with company info spanning width.
  fullWidth,
}

/// Order for bilingual text display.
enum GeniusPdfBilingualOrder {
  /// Show Arabic text first, then English.
  arabicFirst,

  /// Show English text first, then Arabic.
  englishFirst,

  /// Show only the primary language based on RTL setting.
  primaryOnly,

  /// Show text side by side (Arabic on right, English on left).
  sideBySide,
}
