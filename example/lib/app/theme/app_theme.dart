
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

export 'package:genius_pdf_example/app/controllers/theme_controller.dart';

/// Compatibility color aliases used by existing example screens.
///
/// New and refactored presentation code should read colors from
/// `context.superTheme`, `Theme.of(context).colorScheme`, or
/// `SuperSemanticColors.of(context)`. These constants remain available so this
/// reorganization does not break older example screens while their UI is
/// migrated incrementally to Super theme roles.
final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFFA5B4FC);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryLight = Color(0xFFDDD6FE);
  static const Color secondaryDark = Color(0xFF6D28D9);
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentLight = Color(0xFF67E8F9);
  static const Color accentDark = Color(0xFF0E7490);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const List<Color> primaryGradient = <Color>[
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];
  static const List<Color> successGradient = <Color>[
    Color(0xFF34D399),
    Color(0xFF10B981),
  ];
  static const List<Color> warningGradient = <Color>[
    Color(0xFFFBBF24),
    Color(0xFFF59E0B),
  ];
  static const List<Color> errorGradient = <Color>[
    Color(0xFFF87171),
    Color(0xFFEF4444),
  ];
  static const List<Color> infoGradient = <Color>[
    Color(0xFF60A5FA),
    Color(0xFF3B82F6),
  ];
  static const List<Color> purpleGradient = <Color>[
    Color(0xFFA78BFA),
    Color(0xFF8B5CF6),
  ];
  static const List<Color> cyanGradient = <Color>[
    Color(0xFF22D3EE),
    Color(0xFF06B6D4),
  ];
  static const List<Color> pinkGradient = <Color>[
    Color(0xFFF472B6),
    Color(0xFFEC4899),
  ];
  static const List<Color> tealGradient = <Color>[
    Color(0xFF2DD4BF),
    Color(0xFF14B8A6),
  ];
  static const List<Color> orangeGradient = <Color>[
    Color(0xFFFB923C),
    Color(0xFFF97316),
  ];
  static const List<Color> glassDark = <Color>[
    Color(0xCC1E293B),
    Color(0xCC0F172A),
  ];
  static const List<Color> darkGradient = <Color>[
    Color(0xFF475569),
    Color(0xFF1E293B),
  ];
}

/// The example application's visual source of truth.
///
/// New presentation code should stay on the ambient Material/Super theme
/// rather than introducing feature-specific palette values.
final class AppTheme {
  AppTheme._();

  static final SuperTextTheme _typography = SuperTextTheme();

  static ThemeData get lightTheme => SuperMaterialThemeData.light(
        palette: SuperPalette.indigoPalette,
        textTheme: _typography,
        primaryTextTheme: _typography,
      );

  static ThemeData get darkTheme => SuperMaterialThemeData.dark(
        palette: SuperPalette.indigoPalette,
        textTheme: _typography,
        primaryTextTheme: _typography,
      );
}
