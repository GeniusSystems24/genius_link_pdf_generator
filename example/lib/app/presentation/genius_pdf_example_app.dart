import 'package:flutter/material.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

import 'package:genius_pdf_example/app/controllers/locale_controller.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_layout.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

class GeniusPdfExampleApp extends StatelessWidget {
  const GeniusPdfExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeController,
          builder: (context, locale, _) {
            return MaterialApp(
              title: lookupPDFGeneratorLocalization(locale).geniusLinkPdfGenerator,
              debugShowCheckedModeBanner: false,
              locale: locale,
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                ...PDFGeneratorLocalization.localizationsDelegates,
                SuperNavigationLocalization.delegate,
              ],
              supportedLocales: PDFGeneratorLocalization.supportedLocales,
              builder: (context, child) {
                return PDFGeneratorLocalizationBinder(
                  child: child ?? const SizedBox.shrink(),
                );
              },
              // Recreate sidebar metadata so its labels use the new locale.
              home: DashboardLayout(
                key: ValueKey<String>(
                  'dashboard-${locale.languageCode}',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
