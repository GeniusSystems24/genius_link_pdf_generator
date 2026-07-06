part of '../pdf_print_theme.dart';

class GeniusPdfHeaderTheme {
  const GeniusPdfHeaderTheme({
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.companyNameColor,
    required this.companyInfoColor,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.logoMaxWidth,
    required this.logoMaxHeight,
    required this.spacing,
    required this.showBorder,
  });

  /// Default header theme.
  const GeniusPdfHeaderTheme.defaults()
      : backgroundColor = null,
        titleColor = const Color(0xFF212121),
        subtitleColor = const Color(0xFF757575),
        companyNameColor = const Color(0xFF212121),
        companyInfoColor = const Color(0xFF616161),
        borderColor = const Color(0xFFBDBDBD),
        borderWidth = 1.0,
        padding = const GeniusPdfCellPadding.all(10),
        logoMaxWidth = 150,
        logoMaxHeight = 60,
        spacing = 8,
        showBorder = true;

  factory GeniusPdfHeaderTheme.corporate({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfHeaderTheme(
      backgroundColor: colorScheme.background,
      titleColor: colorScheme.primary,
      subtitleColor: colorScheme.secondary,
      companyNameColor: colorScheme.onSurface,
      companyInfoColor: colorScheme.secondary,
      borderColor: colorScheme.primary,
      borderWidth: 2.0,
      padding: const GeniusPdfCellPadding.all(14),
      logoMaxWidth: 160,
      logoMaxHeight: 65,
      spacing: 10,
      showBorder: true,
    );
  }

  factory GeniusPdfHeaderTheme.minimal({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfHeaderTheme(
      backgroundColor: null,
      titleColor: colorScheme.onSurface,
      subtitleColor: colorScheme.secondary,
      companyNameColor: colorScheme.onSurface,
      companyInfoColor: colorScheme.secondary,
      borderColor: colorScheme.dividerColor,
      borderWidth: 0.5,
      padding: const GeniusPdfCellPadding.all(8),
      logoMaxWidth: 120,
      logoMaxHeight: 50,
      spacing: 6,
      showBorder: true,
    );
  }

  factory GeniusPdfHeaderTheme.saudi({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfHeaderTheme(
      backgroundColor: colorScheme.background,
      titleColor: colorScheme.primary,
      subtitleColor: colorScheme.secondary,
      companyNameColor: colorScheme.headerText,
      companyInfoColor: colorScheme.secondary,
      borderColor: colorScheme.primary,
      borderWidth: 2.0,
      padding: const GeniusPdfCellPadding.all(12),
      logoMaxWidth: 150,
      logoMaxHeight: 60,
      spacing: 10,
      showBorder: true,
    );
  }

  final Color? backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color companyNameColor;
  final Color companyInfoColor;
  final Color borderColor;
  final double borderWidth;
  final GeniusPdfCellPadding padding;
  final double logoMaxWidth;
  final double logoMaxHeight;
  final double spacing;
  final bool showBorder;
}

/// Section theming.
