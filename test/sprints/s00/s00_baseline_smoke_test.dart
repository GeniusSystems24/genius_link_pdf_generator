
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'support/s00_artifact_helper.dart';
import 'support/s00_fixture_data.dart';
import 'support/s00_fixture_documents.dart';
import 'support/s00_test_config.dart';

Uint8List generateS00(
  TextDirection direction,
  GeniusPdfDocumentBuilder Function(GeniusPdfConfig) factory,
) {
  final config = createS00Config(direction: direction);
  final builder = factory(config);
  final bytes = Uint8List.fromList(builder.generate());
  builder.dispose();
  return bytes;
}

void expectOpenable(Uint8List bytes, {int? pageCount}) {
  expect(bytes, isNotEmpty);
  final document = PdfDocument(inputBytes: bytes);
  try {
    if (pageCount != null) expect(document.pages.count, pageCount);
  } finally {
    document.dispose();
  }
}

void main() {
  group('S00 canonical data', () {
    test('money, identifiers, null and empty values stay stable', () {
      expect(S00FixtureData.subtotal, '13,650.00 SAR');
      expect(S00FixtureData.vat, '2,047.50 SAR');
      expect(S00FixtureData.grandTotal, '15,697.50 SAR');
      expect(S00FixtureData.documentNumber, 'INV-2026-000123');
      expect(S00FixtureData.sku, 'SKU-AR-ENG-001');
      expect(S00FixtureData.nullableValue, isNull);
      expect(S00FixtureData.emptyValue, isEmpty);
    });
  });

  group('S00 reference PDFs', () {
    for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
      final rtl = direction == TextDirection.rtl;
      final locale = rtl ? 'ar' : 'en';
      final dir = rtl ? 'rtl' : 'ltr';

      test('Summary $dir is openable and A4', () {
        final bytes = generateS00(direction, S00SummaryBaselineDocument.new);
        expectOpenable(bytes, pageCount: 1);
        final metadata = inspectS00Pdf(bytes);
        final first = (metadata['pages'] as List).first as Map;
        expect((first['width'] as num).toDouble(), closeTo(595, 1));
        expect((first['height'] as num).toDouble(), closeTo(842, 1));
        captureS00Pdf(
          subject: 'summary', locale: locale, direction: dir,
          scenario: 'money-mixed', bytes: bytes,
        );
      });

      test('InfoBox $dir is openable', () {
        final bytes = generateS00(direction, S00InfoBoxBaselineDocument.new);
        expectOpenable(bytes, pageCount: 1);
        captureS00Pdf(
          subject: 'info-box', locale: locale, direction: dir,
          scenario: 'identifiers', bytes: bytes,
        );
      });

      test('bilingual $dir is openable', () {
        final bytes = generateS00(direction, S00BilingualBaselineDocument.new);
        expectOpenable(bytes, pageCount: 1);
        captureS00Pdf(
          subject: 'bilingual', locale: locale, direction: dir,
          scenario: 'arabic-latin-values', bytes: bytes,
        );
      });

      test('long content $dir is multi-page', () {
        final bytes = generateS00(direction, S00LongContentBaselineDocument.new);
        expectOpenable(bytes);
        expect(inspectS00Pdf(bytes)['pageCount'] as int, greaterThan(1));
        captureS00Pdf(
          subject: 'long-content', locale: locale, direction: dir,
          scenario: 'multi-page', bytes: bytes,
        );
      });
    }
  });
}
