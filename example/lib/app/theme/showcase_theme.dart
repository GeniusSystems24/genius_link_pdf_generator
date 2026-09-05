import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

abstract final class ShowcaseTheme {
  static ThemeData light(SuperDeviceMode mode) => _build(mode, false);
  static ThemeData dark(SuperDeviceMode mode) => _build(mode, true);

  static ThemeData _build(SuperDeviceMode mode, bool dark) {
    final typography = SuperTextTheme(
      isDesktop: mode == SuperDeviceMode.desktop,
    );
    final SuperMaterialThemeData base = dark
        ? SuperMaterialThemeData.dark(
            mode: mode,
            palette: SuperPalette.bluePalette,
            textTheme: typography,
            primaryTextTheme: typography,
          )
        : SuperMaterialThemeData.light(
            mode: mode,
            palette: SuperPalette.bluePalette,
            textTheme: typography,
            primaryTextTheme: typography,
          );

    // SuperMaterialThemeData.copyWith preserves its generated extensions;
    // add the sidebar extension from the same resolved Super theme.
    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[
        SuperNavigationSidebarThemeData.fromMaterialTheme(base),
      ],
    );
  }
}
