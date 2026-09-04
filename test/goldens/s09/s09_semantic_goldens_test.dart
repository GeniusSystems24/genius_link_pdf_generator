
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String matrix(String template) {
  final rows = <String>[
    'template=$template',
    'family=GeniusErpTransactionDocument',
  ];

  for (final locale in <(String, String)>[
    ('en', 'ltr'),
    ('ar', 'rtl'),
    ('bilingual', 'rtl'),
  ]) {
    for (final lines in <int>[1, 50, 500]) {
      rows.add(
        'locale=${locale.$1}|layout=${locale.$2}|'
        'lines=$lines|structuredValueDirection=ltr',
      );
    }
  }

  rows.add('nullOptional=collapse');
  rows.add('longContent=wrap');
  return rows.join('\n');
}

void main() {
  for (final template in <String>[
    'quotation',
    'purchase_order',
    'tax_invoice',
  ]) {
    test('$template S09 migration matrix golden', () {
      final expected = File(
        'test/goldens/s09/${template}_expected.txt',
      ).readAsStringSync().trim();

      expect(matrix(template), expected);
    });
  }
}
