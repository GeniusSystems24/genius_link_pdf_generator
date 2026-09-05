part of '../pdf_print_theme.dart';

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
///   baseFontBytes: myFontBytes,
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
    return const GeniusPdfPrintTheme(
      colorScheme: GeniusPdfPrintColorScheme.defaults(),
      typography: GeniusPdfPrintTypography.defaults(),
      spacing: GeniusPdfPrintSpacing.defaults(),
      borders: GeniusPdfPrintBorders.defaults(),
      gridTheme: GeniusPdfGridTheme.defaults(),
      summaryTheme: GeniusPdfSummaryTheme.defaults(),
      infoBoxTheme: GeniusPdfInfoBoxTheme.defaults(),
      headerTheme: GeniusPdfHeaderTheme.defaults(),
      sectionTheme: GeniusPdfSectionTheme.defaults(),
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
