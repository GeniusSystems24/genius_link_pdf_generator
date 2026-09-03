
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'support/s00_artifact_helper.dart';
import 'support/s00_fixture_documents.dart';
import 'support/s00_test_config.dart';

void main() {
  group('S00 current template baselines', () {
    for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
      final rtl = direction == TextDirection.rtl;
      final locale = rtl ? 'ar' : 'en';
      final dir = rtl ? 'rtl' : 'ltr';
      final fixtures = <String, GeniusPdfDocumentBuilder Function(GeniusPdfConfig)>{
        'quotation': createS00Quotation,
        'purchase-order': createS00PurchaseOrder,
        'tax-invoice': createS00TaxInvoice,
      };

      for (final entry in fixtures.entries) {
        test('${entry.key} $dir remains openable, A4 and one-page', () {
          final config = createS00Config(direction: direction);
          final builder = entry.value(config);
          final bytes = Uint8List.fromList(builder.generate());
          builder.dispose();

          final document = PdfDocument(inputBytes: bytes);
          try {
            expect(document.pages.count, 1);
            final size = document.pages[0].getClientSize();
            expect(size.width, closeTo(595, 1));
            expect(size.height, closeTo(842, 1));
          } finally {
            document.dispose();
          }

          captureS00Pdf(
            subject: entry.key, locale: locale, direction: dir,
            scenario: 'minimal', bytes: bytes,
          );
        });
      }
    }
  });
}
