part of '../pdf_print_theme.dart';

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
