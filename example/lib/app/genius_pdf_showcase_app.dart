import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';
import 'localization/showcase_localizations.dart';
import 'navigation/showcase_catalog.dart';
import 'presentation/showcase_shell.dart';
import 'settings/showcase_settings.dart';
import 'theme/showcase_theme.dart';

class GeniusPdfShowcaseApp extends StatefulWidget {
  const GeniusPdfShowcaseApp({super.key});

  @override
  State<GeniusPdfShowcaseApp> createState() => _GeniusPdfShowcaseAppState();
}

class _GeniusPdfShowcaseAppState extends State<GeniusPdfShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  ShowcaseTextDirectionMode _textDirectionMode =
      ShowcaseTextDirectionMode.automatic;

  void _cycleTheme() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
    });
  }

  void _setTextDirection(ShowcaseTextDirectionMode mode) {
    setState(() => _textDirectionMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = SuperBreakpoint.ofWidth(constraints.maxWidth);
        final mode = switch (breakpoint) {
          SuperBreakpoint.mobile => SuperDeviceMode.mobile,
          SuperBreakpoint.tablet => SuperDeviceMode.tablet,
          SuperBreakpoint.desktop => SuperDeviceMode.desktop,
          SuperBreakpoint.large => SuperDeviceMode.desktop,
        };

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Genius PDF Showcase',
          locale: _locale,
          supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            ...SuperNavigationLocalization.localizationsDelegates,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: _themeMode,
          theme: ShowcaseTheme.light(mode),
          darkTheme: ShowcaseTheme.dark(mode),
          home: ShowcaseSettings(
            locale: _locale,
            textDirectionMode: _textDirectionMode,
            child: Builder(
              builder: (context) {
                final settings = ShowcaseSettings.of(context);
                return Directionality(
                  textDirection: settings.textDirection,
                  child: ShowcaseShell(
                    catalog: ShowcaseCatalog.destinations,
                    themeMode: _themeMode,
                    locale: _locale,
                    textDirectionMode: _textDirectionMode,
                    onCycleTheme: _cycleTheme,
                    onToggleLocale: _toggleLocale,
                    onTextDirectionChanged: _setTextDirection,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
