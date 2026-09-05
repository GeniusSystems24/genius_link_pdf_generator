import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import '../dependencies/example_dependencies.dart';

/// Loads the example-only font assets once and creates the shared base PDF
/// configuration. Individual demos call [geniusPdfConfig.copyWith] rather
/// than relying on package-global mutable state.
abstract final class ExampleBootstrap {
  static Future<void> initialize() async {
    final regular = await _bytes('assets/fonts/din/din_regular.ttf');
    final bold = await _bytes('assets/fonts/din/din_bold.ttf');
    configureExamplePdf(
      GeniusPdfConfig(
        baseFontBytes: regular,
        boldFontBytes: bold,
        headerFontBytes: bold,
        smallFontBytes: regular,
        textDirection: TextDirection.ltr,
        pageSize: GeniusPdfPageSize.a4,
        orientation: PdfPageOrientation.portrait,
        configAssets: GeniusPdfAssets(
          primaryFont: regular,
          secondaryFont: bold,
        ),
      ),
    );
  }

  static Future<Uint8List> _bytes(String asset) async {
    final data = await rootBundle.load(asset);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
