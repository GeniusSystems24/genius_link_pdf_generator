import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:genius_pdf_example/localizations/generated/l10n.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_layout.dart';

class GeniusPdfExampleApp extends StatelessWidget {
  const GeniusPdfExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) => MaterialApp(
        title: 'Genius Link PDF Generator',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: [
          PDFGeneratorLocalization.delegate,
          SuperNavigationLocalization.delegate,

          //
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: SuperNavigationLocalization.supportedLocales,
        home: const DashboardLayout(),
      ),
    );
  }
}
