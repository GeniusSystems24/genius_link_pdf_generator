part of '../pdf_print_theme.dart';

class GeniusPdfSummaryTheme {
  const GeniusPdfSummaryTheme({
    required this.backgroundColor,
    required this.highlightBackgroundColor,
    required this.labelColor,
    required this.valueColor,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.itemSpacing,
    required this.labelWidthRatio,
    required this.showBorder,
  });

  /// Default summary theme.
  const GeniusPdfSummaryTheme.defaults()
      : backgroundColor = null,
        highlightBackgroundColor = const Color(0xFFE8E8E8),
        labelColor = const Color(0xFF212121),
        valueColor = const Color(0xFF212121),
        borderColor = const Color(0xFFBDBDBD),
        borderWidth = 0.5,
        padding = const GeniusPdfCellPadding.all(8),
        itemSpacing = 8,
        labelWidthRatio = 0.3,
        showBorder = true;

  factory GeniusPdfSummaryTheme.corporate({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSummaryTheme(
      backgroundColor: colorScheme.surface,
      highlightBackgroundColor: colorScheme.highlightBackground,
      labelColor: colorScheme.onSurface,
      valueColor: colorScheme.onSurface,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      padding: const GeniusPdfCellPadding.all(12),
      itemSpacing: 10,
      labelWidthRatio: 0.35,
      showBorder: true,
    );
  }

  factory GeniusPdfSummaryTheme.minimal({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSummaryTheme(
      backgroundColor: null,
      highlightBackgroundColor: colorScheme.highlightBackground,
      labelColor: colorScheme.secondary,
      valueColor: colorScheme.onSurface,
      borderColor: colorScheme.dividerColor,
      borderWidth: 0.25,
      padding: const GeniusPdfCellPadding.all(6),
      itemSpacing: 6,
      labelWidthRatio: 0.3,
      showBorder: false,
    );
  }

  factory GeniusPdfSummaryTheme.saudi({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSummaryTheme(
      backgroundColor: colorScheme.background,
      highlightBackgroundColor: colorScheme.highlightBackground,
      labelColor: colorScheme.onBackground,
      valueColor: colorScheme.primary,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      padding: const GeniusPdfCellPadding.all(10),
      itemSpacing: 8,
      labelWidthRatio: 0.35,
      showBorder: true,
    );
  }

  final Color? backgroundColor;
  final Color highlightBackgroundColor;
  final Color labelColor;
  final Color valueColor;
  final Color borderColor;
  final double borderWidth;
  final GeniusPdfCellPadding padding;
  final double itemSpacing;
  final double labelWidthRatio;
  final bool showBorder;
}

/// Info box theming.
