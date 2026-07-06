part of '../pdf_print_theme.dart';

class GeniusPdfSectionTheme {
  const GeniusPdfSectionTheme({
    required this.backgroundColor,
    required this.titleColor,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.titleSpacing,
    required this.showBorder,
  });

  /// Default section theme.
  const GeniusPdfSectionTheme.defaults()
      : backgroundColor = null,
        titleColor = const Color(0xFF212121),
        borderColor = const Color(0xFFBDBDBD),
        borderWidth = 0.5,
        padding = const GeniusPdfCellPadding.all(8),
        titleSpacing = 8,
        showBorder = true;

  factory GeniusPdfSectionTheme.corporate({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSectionTheme(
      backgroundColor: null,
      titleColor: colorScheme.primary,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      padding: const GeniusPdfCellPadding.all(12),
      titleSpacing: 10,
      showBorder: true,
    );
  }

  factory GeniusPdfSectionTheme.minimal({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSectionTheme(
      backgroundColor: null,
      titleColor: colorScheme.onSurface,
      borderColor: colorScheme.dividerColor,
      borderWidth: 0.25,
      padding: const GeniusPdfCellPadding.all(6),
      titleSpacing: 6,
      showBorder: false,
    );
  }

  factory GeniusPdfSectionTheme.saudi({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfSectionTheme(
      backgroundColor: colorScheme.background,
      titleColor: colorScheme.headerText,
      borderColor: colorScheme.borderColor,
      borderWidth: 1.0,
      padding: const GeniusPdfCellPadding.all(10),
      titleSpacing: 8,
      showBorder: true,
    );
  }

  final Color? backgroundColor;
  final Color titleColor;
  final Color borderColor;
  final double borderWidth;
  final GeniusPdfCellPadding padding;
  final double titleSpacing;
  final bool showBorder;
}

// Helper for transparent color
class Colors {
  Colors._();
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
