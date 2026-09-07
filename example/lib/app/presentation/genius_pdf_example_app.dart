import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

import 'package:genius_pdf_example/app/controllers/locale_controller.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_layout.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/pdf_generation_toast_observer.dart';

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
                return SuperToastHost(
                  style: const SuperToastHostStyle(
                    maxVisible: 4,
                    alignment: SuperToastAlignment.bottomEnd,
                    padding: EdgeInsets.all(12),
                    expandBehavior: SuperToastExpandBehavior.always,
                    expandSpacing: 8,
                    collapsedProtrusion: 8,
                  ),
                  child: PDFGeneratorLocalizationBinder(
                    child: PdfGenerationToastObserver(
                      manager: geniusPdfGenerationManager,
                      duration: const Duration(seconds: 10),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
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
