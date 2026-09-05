import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide Colors, EdgeInsets;

import '../sprints/s00/support/s00_test_config.dart';

void main() {
  group('summary row height', () {
    final config = createS00Config(direction: TextDirection.ltr);
    const style = GeniusPdfSummaryStyle.invoice();

    GeniusPdfSummarySection summary({
      required String label,
      required String value,
    }) {
      return GeniusPdfSummarySection(
        config: config,
        width: 180,
        style: style,
        items: [GeniusPdfSummaryItem(label: label, value: value)],
      );
    }

    test('a wrapped label expands its row', () {
      final singleLine = summary(label: 'Total', value: '100 SAR');
      final wrapped = summary(
        label: 'A deliberately long summary label that needs multiple lines',
        value: '100 SAR',
      );

      expect(
        wrapped.estimateHeight(500),
        greaterThan(singleLine.estimateHeight(500)),
      );
    });

    test('a wrapped value expands its row', () {
      final singleLine = summary(label: 'Total', value: '100 SAR');
      final wrapped = summary(
        label: 'Total',
        value: 'A deliberately long summary value that needs multiple lines',
      );

      expect(
        wrapped.estimateHeight(500),
        greaterThan(singleLine.estimateHeight(500)),
      );
    });

    test('the taller side determines the row height', () {
      const longText =
          'Long summary content that is expected to wrap onto several lines';
      final labelOnly = summary(label: longText, value: '');
      final valueOnly = summary(label: '', value: longText);
      final both = summary(label: longText, value: longText);

      expect(
        both.estimateHeight(500),
        closeTo(
          labelOnly.estimateHeight(500) > valueOnly.estimateHeight(500)
              ? labelOnly.estimateHeight(500)
              : valueOnly.estimateHeight(500),
          0.001,
        ),
      );
    });
  });
}
