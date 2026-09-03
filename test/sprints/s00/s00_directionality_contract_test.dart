
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'support/s00_fixture_data.dart';
import 'support/s00_test_config.dart';

bool get runKnownFailures =>
    Platform.environment['GENIUS_RUN_KNOWN_FAILURES'] == '1';

String sourceOf(String path) => File(path).readAsStringSync();

void main() {
  group('S00 passing directionality baseline guards', () {
    test('Summary preserves the raw amount string before drawing', () {
      const item = GeniusPdfSummaryItem(
        label: 'Grand Total',
        labelAr: 'الإجمالي النهائي',
        value: S00FixtureData.grandTotal,
      );
      expect(item.getFormattedValue(), '15,697.50 SAR');
    });

    test('Summary currently has explicit RTL physical label/value branches', () {
      final source = sourceOf(
        'lib/src/components/widgets/summary/genius_pdf_summary_section.dart',
      );
      expect(source, contains('final labelX = isRTL'));
      expect(source, contains('final valueX = isRTL'));
    });

    test('InfoBox currently has RTL physical label/value mirroring', () {
      final source = sourceOf(
        'lib/src/components/widgets/pdf_info_box/info_box.dart',
      );
      expect(source, contains('else if (config.isRTL)'));
      expect(source, contains('valueBounds'));
      expect(source, contains('labelBounds'));
    });

    test('InfoBox icon currently switches physical side in RTL', () {
      final source = sourceOf(
        'lib/src/components/widgets/pdf_info_box/info_box.dart',
      );
      expect(source, contains('final iconX = config.isRTL'));
    });

    test('QR payload does not change with document direction', () {
      final ltr = createS00Config(direction: TextDirection.ltr);
      final rtl = createS00Config(direction: TextDirection.rtl);
      final ltrQr = GeniusPdfQRCodeGenerator(data: S00FixtureData.url, config: ltr);
      final rtlQr = GeniusPdfQRCodeGenerator(data: S00FixtureData.url, config: rtl);
      expect(ltrQr.data, S00FixtureData.url);
      expect(rtlQr.data, ltrQr.data);
    });

    test('Barcode payload does not change with document direction', () {
      final ltr = createS00Config(direction: TextDirection.ltr);
      final rtl = createS00Config(direction: TextDirection.rtl);
      final ltrCode = GeniusPdfBarcode.code128(
        data: S00FixtureData.serial,
        config: ltr,
      );
      final rtlCode = GeniusPdfBarcode.code128(
        data: S00FixtureData.serial,
        config: rtl,
      );
      expect(ltrCode.data, S00FixtureData.serial);
      expect(rtlCode.data, ltrCode.data);
    });
  });

  group('S00 opt-in known targets — expected to fail before S01/S02', () {
    test(
      'KF-S00-001 Summary needs an independent value-direction policy',
      () {
        final source = sourceOf(
          'lib/src/components/widgets/summary/genius_pdf_summary_section.dart',
        );
        expect(
          source,
          contains('valueDirection'),
          reason: 'Known S00 target: numeric/Latin Summary values still inherit '
              'the document direction. Implement in S01/S02, not S00.',
        );
      },
      skip: !runKnownFailures,
    );

    test(
      'KF-S00-002 InfoBox needs an independent value-direction policy',
      () {
        final source = sourceOf(
          'lib/src/components/widgets/pdf_info_box/info_box.dart',
        );
        expect(source, contains('valueDirection'));
      },
      skip: !runKnownFailures,
    );

    test(
      'KF-S00-003 Summary needs a component/nested direction override',
      () {
        final source = sourceOf(
          'lib/src/components/widgets/summary/genius_pdf_summary_section.dart',
        );
        expect(
          source,
          anyOf(contains('this.direction,'), contains('this.directionality,')),
        );
      },
      skip: !runKnownFailures,
    );

    test(
      'KF-S00-004 InfoBox needs logical leading/trailing semantics',
      () {
        final source = sourceOf(
          'lib/src/components/widgets/pdf_info_box/info_box.dart',
        );
        expect(source, anyOf(contains('leading'), contains('trailing')));
      },
      skip: !runKnownFailures,
    );
  });
}
