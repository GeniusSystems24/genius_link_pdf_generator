part of '../pdf_print_theme.dart';

class GeniusPdfInfoBoxTheme {
  const GeniusPdfInfoBoxTheme({
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.titleColor,
    required this.labelColor,
    required this.valueColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.padding,
    required this.showDivider,
    required this.dividerColor,
  });

  /// Default info box theme.
  const GeniusPdfInfoBoxTheme.defaults()
      : backgroundColor = null,
        headerBackgroundColor = null,
        titleColor = const Color(0xFF212121),
        labelColor = const Color(0xFF424242),
        valueColor = const Color(0xFF212121),
        borderColor = const Color(0xFFBDBDBD),
        borderWidth = 0.5,
        borderRadius = 0,
        padding = const GeniusPdfCellPadding.all(8),
        showDivider = false,
        dividerColor = const Color(0xFFE0E0E0);

  factory GeniusPdfInfoBoxTheme.corporate({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfInfoBoxTheme(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.headerBackground,
      titleColor: colorScheme.headerText,
      labelColor: colorScheme.secondary,
      valueColor: colorScheme.onSurface,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      borderRadius: 4,
      padding: const GeniusPdfCellPadding.all(12),
      showDivider: true,
      dividerColor: colorScheme.dividerColor,
    );
  }

  factory GeniusPdfInfoBoxTheme.minimal({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfInfoBoxTheme(
      backgroundColor: null,
      headerBackgroundColor: null,
      titleColor: colorScheme.primary,
      labelColor: colorScheme.secondary,
      valueColor: colorScheme.onSurface,
      borderColor: colorScheme.dividerColor,
      borderWidth: 0.25,
      borderRadius: 0,
      padding: const GeniusPdfCellPadding.all(6),
      showDivider: false,
      dividerColor: colorScheme.dividerColor,
    );
  }

  factory GeniusPdfInfoBoxTheme.saudi({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfInfoBoxTheme(
      backgroundColor: colorScheme.background,
      headerBackgroundColor: colorScheme.headerBackground,
      titleColor: colorScheme.headerText,
      labelColor: colorScheme.secondary,
      valueColor: colorScheme.onBackground,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      borderRadius: 0,
      padding: const GeniusPdfCellPadding.all(10),
      showDivider: true,
      dividerColor: colorScheme.dividerColor,
    );
  }

  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final Color titleColor;
  final Color labelColor;
  final Color valueColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final GeniusPdfCellPadding padding;
  final bool showDivider;
  final Color dividerColor;
}

/// Header theming.
