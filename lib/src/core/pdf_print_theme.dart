import 'dart:ui';

import 'package:flutter/material.dart' as material;

import '../components/models/pdf_styles.dart';

/// A comprehensive theming system for PDF documents.
///
/// [GeniusPdfPrintTheme] provides a centralized way to configure the visual
/// appearance of all PDF components, ensuring consistency across documents.
///
/// ## Example
/// ```dart
/// final theme = GeniusPdfPrintTheme.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// );
///
/// final config = GeniusPdfConfig(
///   baseFont: myFont,
///   printTheme: theme,
/// );
/// ```
class GeniusPdfPrintTheme {
  const GeniusPdfPrintTheme({
    required this.colorScheme,
    required this.typography,
    required this.spacing,
    required this.borders,
    this.gridTheme,
    this.summaryTheme,
    this.infoBoxTheme,
    this.headerTheme,
    this.sectionTheme,
  });

  /// Creates a default print theme.
  factory GeniusPdfPrintTheme.defaults() {
    return GeniusPdfPrintTheme(
      colorScheme: const GeniusPdfPrintColorScheme.defaults(),
      typography: const GeniusPdfPrintTypography.defaults(),
      spacing: const GeniusPdfPrintSpacing.defaults(),
      borders: const GeniusPdfPrintBorders.defaults(),
      gridTheme: const GeniusPdfGridTheme.defaults(),
      summaryTheme: const GeniusPdfSummaryTheme.defaults(),
      infoBoxTheme: const GeniusPdfInfoBoxTheme.defaults(),
      headerTheme: const GeniusPdfHeaderTheme.defaults(),
      sectionTheme: const GeniusPdfSectionTheme.defaults(),
    );
  }

  /// Creates a corporate/professional theme.
  factory GeniusPdfPrintTheme.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color accentColor = const Color(0xFF0D47A1),
    Color textColor = const Color(0xFF212121),
  }) {
    final colorScheme = GeniusPdfPrintColorScheme(
      primary: primaryColor,
      secondary: const Color(0xFF424242),
      accent: accentColor,
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFFAFAFA),
      error: const Color(0xFFC62828),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onSurface: textColor,
      onBackground: textColor,
      onError: const Color(0xFFFFFFFF),
      headerBackground: Color.lerp(primaryColor, Colors.white, 0.9)!,
      headerText: primaryColor,
      alternateRowBackground: const Color(0xFFF5F5F5),
      borderColor: const Color(0xFFE0E0E0),
      dividerColor: const Color(0xFFBDBDBD),
      positiveAmount: const Color(0xFF2E7D32),
      negativeAmount: const Color(0xFFC62828),
      highlightBackground: Color.lerp(primaryColor, Colors.white, 0.85)!,
    );

    return GeniusPdfPrintTheme(
      colorScheme: colorScheme,
      typography: const GeniusPdfPrintTypography.corporate(),
      spacing: const GeniusPdfPrintSpacing.comfortable(),
      borders: GeniusPdfPrintBorders.corporate(primaryColor: primaryColor),
      gridTheme: GeniusPdfGridTheme.corporate(colorScheme: colorScheme),
      summaryTheme: GeniusPdfSummaryTheme.corporate(colorScheme: colorScheme),
      infoBoxTheme: GeniusPdfInfoBoxTheme.corporate(colorScheme: colorScheme),
      headerTheme: GeniusPdfHeaderTheme.corporate(colorScheme: colorScheme),
      sectionTheme: GeniusPdfSectionTheme.corporate(colorScheme: colorScheme),
    );
  }

  /// Creates a minimal/modern theme.
  factory GeniusPdfPrintTheme.minimal({
    Color primaryColor = const Color(0xFF37474F),
    Color accentColor = const Color(0xFF263238),
  }) {
    final colorScheme = GeniusPdfPrintColorScheme(
      primary: primaryColor,
      secondary: const Color(0xFF607D8B),
      accent: accentColor,
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFFFFFFF),
      error: const Color(0xFFD32F2F),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF212121),
      onBackground: const Color(0xFF212121),
      onError: const Color(0xFFFFFFFF),
      headerBackground: const Color(0xFFF5F5F5),
      headerText: primaryColor,
      alternateRowBackground: const Color(0xFFFAFAFA),
      borderColor: const Color(0xFFE0E0E0),
      dividerColor: const Color(0xFFEEEEEE),
      positiveAmount: const Color(0xFF388E3C),
      negativeAmount: const Color(0xFFD32F2F),
      highlightBackground: const Color(0xFFECEFF1),
    );

    return GeniusPdfPrintTheme(
      colorScheme: colorScheme,
      typography: const GeniusPdfPrintTypography.minimal(),
      spacing: const GeniusPdfPrintSpacing.compact(),
      borders: const GeniusPdfPrintBorders.minimal(),
      gridTheme: GeniusPdfGridTheme.minimal(colorScheme: colorScheme),
      summaryTheme: GeniusPdfSummaryTheme.minimal(colorScheme: colorScheme),
      infoBoxTheme: GeniusPdfInfoBoxTheme.minimal(colorScheme: colorScheme),
      headerTheme: GeniusPdfHeaderTheme.minimal(colorScheme: colorScheme),
      sectionTheme: GeniusPdfSectionTheme.minimal(colorScheme: colorScheme),
    );
  }

  /// Creates an Arabic/Saudi style theme.
  factory GeniusPdfPrintTheme.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color accentColor = const Color(0xFF00897B),
  }) {
    final colorScheme = GeniusPdfPrintColorScheme(
      primary: primaryColor,
      secondary: const Color(0xFF004D40),
      accent: accentColor,
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFF1F8E9),
      error: const Color(0xFFC62828),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF1B5E20),
      onBackground: const Color(0xFF212121),
      onError: const Color(0xFFFFFFFF),
      headerBackground: const Color(0xFFE8F5E9),
      headerText: const Color(0xFF1B5E20),
      alternateRowBackground: const Color(0xFFF1F8E9),
      borderColor: const Color(0xFF81C784),
      dividerColor: const Color(0xFFA5D6A7),
      positiveAmount: const Color(0xFF2E7D32),
      negativeAmount: const Color(0xFFC62828),
      highlightBackground: const Color(0xFFC8E6C9),
    );

    return GeniusPdfPrintTheme(
      colorScheme: colorScheme,
      typography: const GeniusPdfPrintTypography.arabic(),
      spacing: const GeniusPdfPrintSpacing.comfortable(),
      borders: GeniusPdfPrintBorders.saudi(primaryColor: primaryColor),
      gridTheme: GeniusPdfGridTheme.saudi(colorScheme: colorScheme),
      summaryTheme: GeniusPdfSummaryTheme.saudi(colorScheme: colorScheme),
      infoBoxTheme: GeniusPdfInfoBoxTheme.saudi(colorScheme: colorScheme),
      headerTheme: GeniusPdfHeaderTheme.saudi(colorScheme: colorScheme),
      sectionTheme: GeniusPdfSectionTheme.saudi(colorScheme: colorScheme),
    );
  }

  /// Color scheme for the theme.
  final GeniusPdfPrintColorScheme colorScheme;

  /// Typography settings.
  final GeniusPdfPrintTypography typography;

  /// Spacing configuration.
  final GeniusPdfPrintSpacing spacing;

  /// Border styles.
  final GeniusPdfPrintBorders borders;

  /// Grid-specific theming.
  final GeniusPdfGridTheme? gridTheme;

  /// Summary section theming.
  final GeniusPdfSummaryTheme? summaryTheme;

  /// Info box theming.
  final GeniusPdfInfoBoxTheme? infoBoxTheme;

  /// Header theming.
  final GeniusPdfHeaderTheme? headerTheme;

  /// Section theming.
  final GeniusPdfSectionTheme? sectionTheme;

  /// Creates a copy with the given fields replaced.
  GeniusPdfPrintTheme copyWith({
    GeniusPdfPrintColorScheme? colorScheme,
    GeniusPdfPrintTypography? typography,
    GeniusPdfPrintSpacing? spacing,
    GeniusPdfPrintBorders? borders,
    GeniusPdfGridTheme? gridTheme,
    GeniusPdfSummaryTheme? summaryTheme,
    GeniusPdfInfoBoxTheme? infoBoxTheme,
    GeniusPdfHeaderTheme? headerTheme,
    GeniusPdfSectionTheme? sectionTheme,
  }) {
    return GeniusPdfPrintTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      borders: borders ?? this.borders,
      gridTheme: gridTheme ?? this.gridTheme,
      summaryTheme: summaryTheme ?? this.summaryTheme,
      infoBoxTheme: infoBoxTheme ?? this.infoBoxTheme,
      headerTheme: headerTheme ?? this.headerTheme,
      sectionTheme: sectionTheme ?? this.sectionTheme,
    );
  }
}

/// Color scheme for PDF printing.
class GeniusPdfPrintColorScheme {
  const GeniusPdfPrintColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
    required this.background,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.onBackground,
    required this.onError,
    required this.headerBackground,
    required this.headerText,
    required this.alternateRowBackground,
    required this.borderColor,
    required this.dividerColor,
    required this.positiveAmount,
    required this.negativeAmount,
    required this.highlightBackground,
  });

  /// Default color scheme.
  const GeniusPdfPrintColorScheme.defaults()
      : primary = const Color(0xFF1565C0),
        secondary = const Color(0xFF424242),
        accent = const Color(0xFF0D47A1),
        surface = const Color(0xFFFFFFFF),
        background = const Color(0xFFFAFAFA),
        error = const Color(0xFFC62828),
        onPrimary = const Color(0xFFFFFFFF),
        onSecondary = const Color(0xFFFFFFFF),
        onSurface = const Color(0xFF212121),
        onBackground = const Color(0xFF212121),
        onError = const Color(0xFFFFFFFF),
        headerBackground = const Color(0xFFE3F2FD),
        headerText = const Color(0xFF1565C0),
        alternateRowBackground = const Color(0xFFFAFAFA),
        borderColor = const Color(0xFFBDBDBD),
        dividerColor = const Color(0xFFE0E0E0),
        positiveAmount = const Color(0xFF2E7D32),
        negativeAmount = const Color(0xFFC62828),
        highlightBackground = const Color(0xFFE3F2FD);

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color surface;
  final Color background;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color onBackground;
  final Color onError;
  final Color headerBackground;
  final Color headerText;
  final Color alternateRowBackground;
  final Color borderColor;
  final Color dividerColor;
  final Color positiveAmount;
  final Color negativeAmount;
  final Color highlightBackground;

  GeniusPdfPrintColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? surface,
    Color? background,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onSurface,
    Color? onBackground,
    Color? onError,
    Color? headerBackground,
    Color? headerText,
    Color? alternateRowBackground,
    Color? borderColor,
    Color? dividerColor,
    Color? positiveAmount,
    Color? negativeAmount,
    Color? highlightBackground,
  }) {
    return GeniusPdfPrintColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onSurface: onSurface ?? this.onSurface,
      onBackground: onBackground ?? this.onBackground,
      onError: onError ?? this.onError,
      headerBackground: headerBackground ?? this.headerBackground,
      headerText: headerText ?? this.headerText,
      alternateRowBackground:
          alternateRowBackground ?? this.alternateRowBackground,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      positiveAmount: positiveAmount ?? this.positiveAmount,
      negativeAmount: negativeAmount ?? this.negativeAmount,
      highlightBackground: highlightBackground ?? this.highlightBackground,
    );
  }
}

/// Typography settings for PDF printing.
class GeniusPdfPrintTypography {
  const GeniusPdfPrintTypography({
    required this.titleSize,
    required this.headingSize,
    required this.subheadingSize,
    required this.bodySize,
    required this.captionSize,
    required this.smallSize,
    required this.lineHeight,
    required this.paragraphSpacing,
    required this.letterSpacing,
  });

  /// Default typography settings.
  const GeniusPdfPrintTypography.defaults()
      : titleSize = 18,
        headingSize = 14,
        subheadingSize = 12,
        bodySize = 10,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.4,
        paragraphSpacing = 8,
        letterSpacing = 0;

  /// Corporate typography (slightly larger).
  const GeniusPdfPrintTypography.corporate()
      : titleSize = 20,
        headingSize = 16,
        subheadingSize = 13,
        bodySize = 11,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.5,
        paragraphSpacing = 10,
        letterSpacing = 0;

  /// Minimal typography (compact).
  const GeniusPdfPrintTypography.minimal()
      : titleSize = 16,
        headingSize = 12,
        subheadingSize = 10,
        bodySize = 9,
        captionSize = 8,
        smallSize = 7,
        lineHeight = 1.3,
        paragraphSpacing = 6,
        letterSpacing = 0;

  /// Arabic typography (optimized for RTL).
  const GeniusPdfPrintTypography.arabic()
      : titleSize = 18,
        headingSize = 14,
        subheadingSize = 12,
        bodySize = 11,
        captionSize = 9,
        smallSize = 8,
        lineHeight = 1.6,
        paragraphSpacing = 10,
        letterSpacing = 0;

  final double titleSize;
  final double headingSize;
  final double subheadingSize;
  final double bodySize;
  final double captionSize;
  final double smallSize;
  final double lineHeight;
  final double paragraphSpacing;
  final double letterSpacing;

  /// Creates text styles based on typography settings.
  GeniusPdfTextStyle titleStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: titleSize,
        fontWeight: material.FontWeight.bold,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle headingStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: headingSize,
        fontWeight: material.FontWeight.bold,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle subheadingStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: subheadingSize,
        fontWeight: material.FontWeight.w500,
        color: color ?? const Color(0xFF424242),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle bodyStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: bodySize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF212121),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle captionStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: captionSize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF757575),
        lineSpacing: lineHeight,
      );

  GeniusPdfTextStyle smallStyle({Color? color}) => GeniusPdfTextStyle(
        fontSize: smallSize,
        fontWeight: material.FontWeight.normal,
        color: color ?? const Color(0xFF9E9E9E),
        lineSpacing: lineHeight,
      );

  GeniusPdfPrintTypography copyWith({
    double? titleSize,
    double? headingSize,
    double? subheadingSize,
    double? bodySize,
    double? captionSize,
    double? smallSize,
    double? lineHeight,
    double? paragraphSpacing,
    double? letterSpacing,
  }) {
    return GeniusPdfPrintTypography(
      titleSize: titleSize ?? this.titleSize,
      headingSize: headingSize ?? this.headingSize,
      subheadingSize: subheadingSize ?? this.subheadingSize,
      bodySize: bodySize ?? this.bodySize,
      captionSize: captionSize ?? this.captionSize,
      smallSize: smallSize ?? this.smallSize,
      lineHeight: lineHeight ?? this.lineHeight,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }
}

/// Spacing configuration for PDF printing.
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
