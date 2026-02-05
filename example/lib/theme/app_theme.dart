import 'package:flutter/material.dart';

/// Modern Professional Dashboard Color Scheme
class AppColors {
  // Primary Brand Colors - Deep Indigo & Violet
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryLight = Color(0xFFA5B4FC); // Indigo 200
  static const Color primaryDark = Color(0xFF4338CA); // Indigo 700

  // Secondary Brand Colors - Electric Purple
  static const Color secondary = Color(0xFF8B5CF6); // Violet 500
  static const Color secondaryLight = Color(0xFFDDD6FE); // Violet 200
  static const Color secondaryDark = Color(0xFF6D28D9); // Violet 700

  // Accent Colors - Cyan & Teal
  static const Color accent = Color(0xFF06B6D4); // Cyan 500
  static const Color accentLight = Color(0xFF67E8F9); // Cyan 200
  static const Color accentDark = Color(0xFF0E7490); // Cyan 700

  // Functional Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Dark Theme Base (Slate)
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF475569); // Slate 600
  static const Color darkText = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400

  // Light Theme Base (Cool Gray)
  static const Color lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightCard = Color(0xFFFFFFFF); // White
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightText = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500

  // Modern Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1), // Indigo 500
    Color(0xFF8B5CF6), // Violet 500
  ];

  static const List<Color> successGradient = [
    Color(0xFF34D399), // Emerald 400
    Color(0xFF10B981), // Emerald 500
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFBBF24), // Amber 400
    Color(0xFFF59E0B), // Amber 500
  ];

  static const List<Color> errorGradient = [
    Color(0xFFF87171), // Red 400
    Color(0xFFEF4444), // Red 500
  ];

  static const List<Color> infoGradient = [
    Color(0xFF60A5FA), // Blue 400
    Color(0xFF3B82F6), // Blue 500
  ];

  static const List<Color> purpleGradient = [
    Color(0xFFA78BFA), // Violet 400
    Color(0xFF8B5CF6), // Violet 500
  ];

  static const List<Color> cyanGradient = [
    Color(0xFF22D3EE),
    Color(0xFF06B6D4),
  ];

  static const List<Color> pinkGradient = [
    Color(0xFFF472B6), // Pink 400
    Color(0xFFEC4899), // Pink 500
  ];

  static const List<Color> tealGradient = [
    Color(0xFF2DD4BF),
    Color(0xFF14B8A6),
  ];

  static const List<Color> orangeGradient = [
    Color(0xFFFB923C),
    Color(0xFFF97316),
  ];

  static const List<Color> glassDark = [
    Color(0xCC1E293B), // Slate 800 with 80% opacity
    Color(0xCC0F172A), // Slate 900 with 80% opacity
  ];
}

/// Modern App Theme Configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter', // Assumed font, fallback to system default
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBg,
      canvasColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkText,
        onError: Colors.white,
        surfaceContainerHighest: AppColors.darkCard,
        outline: AppColors.darkBorder,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Glass effect intended later
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      dividerColor: AppColors.darkBorder,
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: _textTheme(AppColors.darkText, AppColors.darkTextSecondary),
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
      inputDecorationTheme: _inputDecorationTheme(true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(true),
      textButtonTheme: _textButtonTheme(),
      chipTheme: _chipTheme(true),
      tabBarTheme: _tabBarTheme(true),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: TextStyle(color: AppColors.darkText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBg,
      canvasColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightText,
        onError: Colors.white,
        surfaceContainerHighest: AppColors.lightCard,
        outline: AppColors.lightBorder,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      dividerColor: AppColors.lightBorder,
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: _textTheme(AppColors.lightText, AppColors.lightTextSecondary),
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
      inputDecorationTheme: _inputDecorationTheme(false),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(false),
      textButtonTheme: _textButtonTheme(),
      chipTheme: _chipTheme(false),
      tabBarTheme: _tabBarTheme(false),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.lightCard,
        contentTextStyle: TextStyle(color: AppColors.lightText),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800, // Extra Bold
        color: primary,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700, // Bold
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primary, // Good contrast for reading
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondary, // Softer for secondary lists/descriptions
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.5,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isDark) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fillColor = isDark ? AppColors.darkCard : AppColors.lightBg;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hoverColor: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(bool isDark) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ChipThemeData _chipTheme(bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBg,
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
    );
  }

  static TabBarThemeData _tabBarTheme(bool isDark) {
    return TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor:
          isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.primary,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      dividerColor: Colors.transparent, // Clean look
    );
  }
}

/// Theme Controller for Dark/Light Mode
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.dark);

  bool get isDark => value == ThemeMode.dark;

  void toggleTheme() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void setDark() => value = ThemeMode.dark;
  void setLight() => value = ThemeMode.light;
}

/// Global Theme Controller Instance
final themeController = ThemeController();
