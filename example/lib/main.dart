import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets;
import 'dashboard_layout.dart';
import 'theme/app_theme.dart';

/// Global PDF configuration for the example app.
///
/// In v2.3.3+1, there is no singleton pattern. Each document builder
/// should have its own GeniusPdfConfig. This global variable is used
/// to share the config across example screens.
late final GeniusPdfConfig geniusPdfConfig;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load font data first for baseFont
  final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
  final fontBytes = fontData.buffer.asUint8List();

  // Create config instance with assets (v2.3.3+1)
  // Each document builder should have its own config instance.
  // For the example app, we create a shared config that screens can use.
  geniusPdfConfig = await GeniusPdfConfig.create(
    // PDF Configuration
    baseFontBytes: fontBytes,
    boldFontBytes: fontBytes,
    headerFontBytes: fontBytes,
    smallFontBytes: fontBytes,
    textDirection: TextDirection.rtl,
    pageSize: GeniusPdfPageSize.a4,
    orientation: PdfPageOrientation.portrait,

    // Assets Configuration
    assetPaths: GeniusPdfAssetPaths(
      fontPaths: GeniusPdfFontPaths(
        primaryFont: 'assets/fonts/din/din.ttf',
        secondaryFont: 'assets/fonts/din/din.ttf',
      ),
      brandingPaths: GeniusPdfBrandingPaths(
        headerImage: 'assets/images/header.png',
        logo: 'assets/images/logo.png',
      ),
    ),

    // Logger Configuration (v2.3.3+7 - with source location tracking)
    loggerConfig: const GeniusPdfLoggerConfig(
      enabled: true,
      useConsole: true,
      minLevel: GeniusLogLevel.debug,
      showLocation: true,
      showTimestamp: true,
      keepHistory: true,
    ),
  );

  runApp(const GeniusPdfExampleApp());
}

/// Genius PDF Generator Example Application
class GeniusPdfExampleApp extends StatelessWidget {
  const GeniusPdfExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Genius PDF Generator',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const DashboardLayout(),
        );
      },
    );
  }
}
