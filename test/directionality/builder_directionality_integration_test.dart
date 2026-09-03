import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

class _DirectionalityBuilder extends GeniusPdfDocumentBuilder {
  _DirectionalityBuilder(
    super.config, {
    super.directionality,
  });

  @override
  void build() {
    newPage();
    addLine('S01 builder directionality integration');
  }
}

void main() {
  test('builder accepts explicit directionality and exposes it', () {
    final config = GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: TextDirection.rtl,
    );

    const context = GeniusPdfDirectionality(
      documentDirection: GeniusPdfDirection.rtl,
      componentDirection: GeniusPdfDirection.ltr,
    );

    final builder = _DirectionalityBuilder(
      config,
      directionality: context,
    );

    expect(builder.directionality, same(context));
    expect(
      builder.resolvedLayoutDirection,
      GeniusPdfResolvedDirection.ltr,
    );

    builder.dispose();
  });

  test('builder stays backward compatible when directionality is omitted', () {
    final config = GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: TextDirection.rtl,
    );

    final builder = _DirectionalityBuilder(config);

    expect(
      builder.resolvedLayoutDirection,
      GeniusPdfResolvedDirection.rtl,
    );

    builder.dispose();
  });
}
