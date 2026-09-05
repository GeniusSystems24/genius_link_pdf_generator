
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('resource cache is bounded and LRU-like', () {
    final cache = GeniusPdfResourceBytesCache(maxEntries: 2);
    cache.putIfAbsent('a', () => Uint8List.fromList([1]));
    cache.putIfAbsent('b', () => Uint8List.fromList([2]));
    expect(cache['a'], isNotNull);
    cache.putIfAbsent('c', () => Uint8List.fromList([3]));

    expect(cache.containsKey('a'), isTrue);
    expect(cache.containsKey('b'), isFalse);
    expect(cache.containsKey('c'), isTrue);
  });

  test('measurement cache does not repeat immutable measurement', () {
    final cache = GeniusPdfMeasurementCache();
    var calls = 0;
    const key = GeniusPdfMeasurementKey(
      contentHash: 1,
      widthMicros: 100000,
      styleHash: 2,
      direction: 'rtl',
    );

    final first = cache.measure(key, () {
      calls++;
      return 42;
    });
    final second = cache.measure(key, () {
      calls++;
      return 99;
    });

    expect(first, 42);
    expect(second, 42);
    expect(calls, 1);
  });

  test('benchmark runner records every iteration', () async {
    const runner = GeniusPdfPerformanceBenchmarkRunner();
    final result = await runner.run(
      GeniusPdfBenchmarkCase(
        id: 'family-baseline',
        family: GeniusPdfBenchmarkFamily.transaction,
        iterations: 3,
        generate: () => <int>[1, 2, 3],
      ),
    );

    expect(result.iterations, 3);
    expect(result.totalOutputBytes, 9);
    expect(result.averageMilliseconds, greaterThanOrEqualTo(0));
  });

  test('large-grid profiler records portable cardinality proxy', () {
    const profiler = GeniusPdfLargeGridProfiler();
    final sample = profiler.profile(
      rows: 1000,
      columns: 8,
      textCells: List.generate(8000, (index) => 'C$index'),
      generatedBytes: 120000,
      elapsedMicroseconds: 500000,
    );

    expect(sample.estimatedCellCount, 8000);
    expect(sample.estimatedUtf16Units, greaterThan(0));
  });

  test('semantic regression checks ERP identifiers and totals', () {
    const checker = GeniusPdfSemanticRegression();
    final expectation = GeniusPdfSemanticRegression.erpDocument(
      documentNumber: 'INV-001',
      party: 'Customer A',
      total: '115.00',
      tax: '15.00',
      currency: 'SAR',
      pageNumber: '1/1',
      complianceMetadata: const ['UUID-1'],
    );

    final result = checker.checkExtractedText(
      'INV-001 Customer A 100.00 15.00 115.00 SAR 1/1 UUID-1',
      expectation,
    );

    expect(result.passed, isTrue);
  });

  test('golden manifest covers component family pack and directions', () {
    const manifest = GeniusPdfGoldenManifest.core;
    expect(
      manifest.cases.any(
        (item) => item.kind == GeniusPdfRegressionSubjectKind.component,
      ),
      isTrue,
    );
    expect(
      manifest.cases.any(
        (item) => item.kind == GeniusPdfRegressionSubjectKind.family,
      ),
      isTrue,
    );
    expect(
      manifest.cases.any(
        (item) => item.kind == GeniusPdfRegressionSubjectKind.erpPack,
      ),
      isTrue,
    );
    for (final direction in GeniusPdfRegressionDirection.values) {
      expect(
        manifest.cases.any((item) => item.direction == direction),
        isTrue,
      );
    }
  });
}
