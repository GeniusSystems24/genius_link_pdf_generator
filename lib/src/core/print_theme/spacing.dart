part of '../pdf_print_theme.dart';

class GeniusPdfPrintSpacing {
  const GeniusPdfPrintSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.componentGap,
    required this.sectionGap,
    required this.cellPaddingHorizontal,
    required this.cellPaddingVertical,
    required this.contentPadding,
    required this.pagePadding,
  });

  /// Default spacing (balanced).
  const GeniusPdfPrintSpacing.defaults()
      : xs = 2,
        sm = 4,
        md = 8,
        lg = 12,
        xl = 16,
        xxl = 24,
        componentGap = 12,
        sectionGap = 20,
        cellPaddingHorizontal = 6,
        cellPaddingVertical = 4,
        contentPadding = 10,
        pagePadding = 20;

  /// Compact spacing (dense).
  const GeniusPdfPrintSpacing.compact()
      : xs = 1,
        sm = 2,
        md = 4,
        lg = 8,
        xl = 12,
        xxl = 16,
        componentGap = 8,
        sectionGap = 14,
        cellPaddingHorizontal = 4,
        cellPaddingVertical = 3,
        contentPadding = 8,
        pagePadding = 15;

  /// Comfortable spacing (relaxed).
  const GeniusPdfPrintSpacing.comfortable()
      : xs = 3,
        sm = 6,
        md = 10,
        lg = 16,
        xl = 20,
        xxl = 30,
        componentGap = 16,
        sectionGap = 24,
        cellPaddingHorizontal = 8,
        cellPaddingVertical = 6,
        contentPadding = 14,
        pagePadding = 25;

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double componentGap;
  final double sectionGap;
  final double cellPaddingHorizontal;
  final double cellPaddingVertical;
  final double contentPadding;
  final double pagePadding;

  /// Creates cell padding from spacing settings.
  GeniusPdfCellPadding get cellPadding => GeniusPdfCellPadding.symmetric(
        horizontal: cellPaddingHorizontal,
        vertical: cellPaddingVertical,
      );

  /// Creates content padding from spacing settings.
  GeniusPdfCellPadding get contentPaddingValue => GeniusPdfCellPadding.all(contentPadding);

  GeniusPdfPrintSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? componentGap,
    double? sectionGap,
    double? cellPaddingHorizontal,
    double? cellPaddingVertical,
    double? contentPadding,
    double? pagePadding,
  }) {
    return GeniusPdfPrintSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      componentGap: componentGap ?? this.componentGap,
      sectionGap: sectionGap ?? this.sectionGap,
      cellPaddingHorizontal: cellPaddingHorizontal ?? this.cellPaddingHorizontal,
      cellPaddingVertical: cellPaddingVertical ?? this.cellPaddingVertical,
      contentPadding: contentPadding ?? this.contentPadding,
      pagePadding: pagePadding ?? this.pagePadding,
    );
  }
}

/// Border styles for PDF printing.
