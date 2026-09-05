
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S24 contains no hard-coded pass/fail performance threshold', () {
    final source = File('lib/src/quality/performance.dart')
        .readAsStringSync();

    expect(source, contains('GeniusPdfPerformanceBenchmarkRunner'));
    expect(source, contains('GeniusPdfMeasurementCache'));
    expect(source, contains('GeniusPdfLargeGridProfiler'));
    expect(source, isNot(contains('maxAllowedMilliseconds')));
  });

  test('S24 semantic regression covers required ERP semantics', () {
    final source = File('lib/src/quality/regression.dart')
        .readAsStringSync();

    for (final marker in [
      'documentNumber',
      'party',
      'total',
      'tax',
      'pageNumber',
      'currency',
      'complianceMetadata',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });
}
