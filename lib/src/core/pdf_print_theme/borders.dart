part of '../pdf_print_theme.dart';

class GeniusPdfPrintBorders {
  const GeniusPdfPrintBorders({
    required this.thinWidth,
    required this.normalWidth,
    required this.thickWidth,
    required this.defaultColor,
    required this.accentColor,
    this.cellBorderStyle,
    this.tableBorderStyle,
    this.sectionBorderStyle,
    this.dividerStyle,
  });

  /// Default border settings.
  const GeniusPdfPrintBorders.defaults()
      : thinWidth = 0.5,
        normalWidth = 1,
        thickWidth = 2,
        defaultColor = const Color(0xFFBDBDBD),
        accentColor = const Color(0xFF1565C0),
        cellBorderStyle = null,
        tableBorderStyle = null,
        sectionBorderStyle = null,
        dividerStyle = null;

  /// Corporate border settings.
  factory GeniusPdfPrintBorders.corporate({Color primaryColor = const Color(0xFF1565C0)}) {
    return GeniusPdfPrintBorders(
      thinWidth: 0.5,
      normalWidth: 1,
      thickWidth: 2,
      defaultColor: const Color(0xFFE0E0E0),
      accentColor: primaryColor,
      cellBorderStyle: const GeniusPdfBorderStyle.all(
        width: 0.5,
        color: Color(0xFFE0E0E0),
      ),
      tableBorderStyle: const GeniusPdfBorderStyle.all(
        width: 1,
        color: Color(0xFFBDBDBD),
      ),
      sectionBorderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      dividerStyle: const GeniusPdfBorderStyle.bottom(
        width: 0.5,
        color: Color(0xFFE0E0E0),
      ),
    );
  }

  /// Minimal border settings.
  const GeniusPdfPrintBorders.minimal()
      : thinWidth = 0.25,
        normalWidth = 0.5,
        thickWidth = 1,
        defaultColor = const Color(0xFFE0E0E0),
        accentColor = const Color(0xFF37474F),
        cellBorderStyle = const GeniusPdfBorderStyle.bottom(
          width: 0.25,
          color: Color(0xFFEEEEEE),
        ),
        tableBorderStyle = const GeniusPdfBorderStyle.none(),
        sectionBorderStyle = const GeniusPdfBorderStyle.bottom(
          width: 0.5,
          color: Color(0xFFE0E0E0),
        ),
        dividerStyle = const GeniusPdfBorderStyle.bottom(
          width: 0.25,
          color: Color(0xFFEEEEEE),
        );

  /// Saudi border settings.
  factory GeniusPdfPrintBorders.saudi({Color primaryColor = const Color(0xFF006C35)}) {
    return GeniusPdfPrintBorders(
      thinWidth: 0.5,
      normalWidth: 1,
      thickWidth: 2,
      defaultColor: const Color(0xFF81C784),
      accentColor: primaryColor,
      cellBorderStyle: const GeniusPdfBorderStyle.all(
        width: 0.5,
        color: Color(0xFFA5D6A7),
      ),
      tableBorderStyle: const GeniusPdfBorderStyle.all(
        width: 1,
        color: Color(0xFF81C784),
      ),
      sectionBorderStyle: GeniusPdfBorderStyle.bottom(
        width: 2,
        color: primaryColor,
      ),
      dividerStyle: const GeniusPdfBorderStyle.bottom(
        width: 0.5,
        color: Color(0xFFA5D6A7),
      ),
    );
  }

  final double thinWidth;
  final double normalWidth;
  final double thickWidth;
  final Color defaultColor;
  final Color accentColor;
  final GeniusPdfBorderStyle? cellBorderStyle;
  final GeniusPdfBorderStyle? tableBorderStyle;
  final GeniusPdfBorderStyle? sectionBorderStyle;
  final GeniusPdfBorderStyle? dividerStyle;

  /// Creates a thin border with default color.
  GeniusPdfBorderStyle get thin => GeniusPdfBorderStyle.all(
        width: thinWidth,
        color: defaultColor,
      );

  /// Creates a normal border with default color.
  GeniusPdfBorderStyle get normal => GeniusPdfBorderStyle.all(
        width: normalWidth,
        color: defaultColor,
      );

  /// Creates a thick border with accent color.
  GeniusPdfBorderStyle get thick => GeniusPdfBorderStyle.all(
        width: thickWidth,
        color: accentColor,
      );

  GeniusPdfPrintBorders copyWith({
    double? thinWidth,
    double? normalWidth,
    double? thickWidth,
    Color? defaultColor,
    Color? accentColor,
    GeniusPdfBorderStyle? cellBorderStyle,
    GeniusPdfBorderStyle? tableBorderStyle,
    GeniusPdfBorderStyle? sectionBorderStyle,
    GeniusPdfBorderStyle? dividerStyle,
  }) {
    return GeniusPdfPrintBorders(
      thinWidth: thinWidth ?? this.thinWidth,
      normalWidth: normalWidth ?? this.normalWidth,
      thickWidth: thickWidth ?? this.thickWidth,
      defaultColor: defaultColor ?? this.defaultColor,
      accentColor: accentColor ?? this.accentColor,
      cellBorderStyle: cellBorderStyle ?? this.cellBorderStyle,
      tableBorderStyle: tableBorderStyle ?? this.tableBorderStyle,
      sectionBorderStyle: sectionBorderStyle ?? this.sectionBorderStyle,
      dividerStyle: dividerStyle ?? this.dividerStyle,
    );
  }
}

// ============================================================================
// Component-Specific Themes
// ============================================================================

/// Grid-specific theming.
