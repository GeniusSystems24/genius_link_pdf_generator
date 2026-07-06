import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

final class ExampleBootstrap {
  const ExampleBootstrap._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
    final fontBytes = fontData.buffer.asUint8List();

    final config = await GeniusPdfConfig.create(
      baseFontBytes: fontBytes,
      boldFontBytes: fontBytes,
      headerFontBytes: fontBytes,
      smallFontBytes: fontBytes,
      textDirection: TextDirection.rtl,
      pageSize: GeniusPdfPageSize.a4,
      orientation: PdfPageOrientation.portrait,
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
      loggerConfig: const GeniusPdfLoggerConfig(
        enabled: true,
        useConsole: true,
        minLevel: GeniusLogLevel.debug,
        showLocation: true,
        showTimestamp: true,
        keepHistory: true,
      ),
    );

    ExampleDependencies.configure(pdfConfig: config);
  }
}
