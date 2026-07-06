part of '../pdf_print_theme.dart';

class GeniusPdfGridTheme {
  const GeniusPdfGridTheme({
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.alternateRowColor,
    required this.totalRowBackgroundColor,
    required this.totalRowTextColor,
    required this.groupHeaderBackgroundColor,
    required this.groupHeaderTextColor,
    required this.borderColor,
    required this.headerBorderWidth,
    required this.cellBorderWidth,
    required this.headerPadding,
    required this.cellPadding,
    required this.rowHeight,
    required this.headerHeight,
    required this.showOuterBorder,
    required this.showInnerBorder,
  });

  /// Default grid theme.
  const GeniusPdfGridTheme.defaults()
      : headerBackgroundColor = const Color(0xFFE0E0E0),
        headerTextColor = const Color(0xFF212121),
        alternateRowColor = const Color(0xFFF5F5F5),
        totalRowBackgroundColor = const Color(0xFFE8E8E8),
        totalRowTextColor = const Color(0xFF212121),
        groupHeaderBackgroundColor = const Color(0xFFF5F5F5),
        groupHeaderTextColor = const Color(0xFF424242),
        borderColor = const Color(0xFFBDBDBD),
        headerBorderWidth = 1.0,
        cellBorderWidth = 0.5,
        headerPadding = const GeniusPdfCellPadding.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        cellPadding = const GeniusPdfCellPadding.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        rowHeight = null,
        headerHeight = null,
        showOuterBorder = true,
        showInnerBorder = true;

  /// Corporate grid theme.
  factory GeniusPdfGridTheme.corporate({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfGridTheme(
      headerBackgroundColor: colorScheme.headerBackground,
      headerTextColor: colorScheme.headerText,
      alternateRowColor: colorScheme.alternateRowBackground,
      totalRowBackgroundColor: colorScheme.highlightBackground,
      totalRowTextColor: colorScheme.primary,
      groupHeaderBackgroundColor: colorScheme.background,
      groupHeaderTextColor: colorScheme.secondary,
      borderColor: colorScheme.borderColor,
      headerBorderWidth: 1.5,
      cellBorderWidth: 0.5,
      headerPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      cellPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      rowHeight: null,
      headerHeight: null,
      showOuterBorder: true,
      showInnerBorder: true,
    );
  }

  /// Minimal grid theme.
  factory GeniusPdfGridTheme.minimal({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfGridTheme(
      headerBackgroundColor: Colors.transparent,
      headerTextColor: colorScheme.primary,
      alternateRowColor: colorScheme.alternateRowBackground,
      totalRowBackgroundColor: colorScheme.highlightBackground,
      totalRowTextColor: colorScheme.onSurface,
      groupHeaderBackgroundColor: colorScheme.background,
      groupHeaderTextColor: colorScheme.secondary,
      borderColor: colorScheme.dividerColor,
      headerBorderWidth: 1.0,
      cellBorderWidth: 0.25,
      headerPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      cellPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      rowHeight: null,
      headerHeight: null,
      showOuterBorder: false,
      showInnerBorder: false,
    );
  }

  /// Saudi grid theme.
  factory GeniusPdfGridTheme.saudi({
    required GeniusPdfPrintColorScheme colorScheme,
  }) {
    return GeniusPdfGridTheme(
      headerBackgroundColor: colorScheme.headerBackground,
      headerTextColor: colorScheme.headerText,
      alternateRowColor: colorScheme.alternateRowBackground,
      totalRowBackgroundColor: colorScheme.highlightBackground,
      totalRowTextColor: colorScheme.primary,
      groupHeaderBackgroundColor: colorScheme.background,
      groupHeaderTextColor: colorScheme.secondary,
      borderColor: colorScheme.borderColor,
      headerBorderWidth: 1.0,
      cellBorderWidth: 0.5,
      headerPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      cellPadding: const GeniusPdfCellPadding.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      rowHeight: null,
      headerHeight: null,
      showOuterBorder: true,
      showInnerBorder: true,
    );
  }

  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color alternateRowColor;
  final Color totalRowBackgroundColor;
  final Color totalRowTextColor;
  final Color groupHeaderBackgroundColor;
  final Color groupHeaderTextColor;
  final Color borderColor;
  final double headerBorderWidth;
  final double cellBorderWidth;
  final GeniusPdfCellPadding headerPadding;
  final GeniusPdfCellPadding cellPadding;
  final double? rowHeight;
  final double? headerHeight;
  final bool showOuterBorder;
  final bool showInnerBorder;
}

/// Summary section theming.
