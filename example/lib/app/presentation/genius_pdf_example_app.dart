import 'package:flutter/material.dart';

import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_layout.dart';

class GeniusPdfExampleApp extends StatelessWidget {
  const GeniusPdfExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) => MaterialApp(
        title: 'Genius PDF Generator',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const DashboardLayout(),
      ),
    );
  }
}
