import 'package:flutter/material.dart';

final class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController({ThemeMode initialMode = ThemeMode.dark}) : super(initialMode);

  bool get isDark => value == ThemeMode.dark;

  void toggleTheme() => value = isDark ? ThemeMode.light : ThemeMode.dark;

  void setDark() => value = ThemeMode.dark;

  void setLight() => value = ThemeMode.light;
}

final themeController = ThemeController();
