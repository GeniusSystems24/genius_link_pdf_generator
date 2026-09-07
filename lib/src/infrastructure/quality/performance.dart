
import 'dart:async';
import 'dart:typed_data';

enum GeniusPdfBenchmarkFamily {
  transaction,
  statement,
  voucher,
  analyticalReport,
  operationalForm,
  register,
  thermalReceipt,
  label,
  certificate,
  crm,
  accounting,
  inventory,
  manufacturing,
  serviceLogistics,
}

class GeniusPdfBenchmarkCase {
  const GeniusPdfBenchmarkCase({
    required this.id,
    required this.family,
    required this.iterations,
    required this.generate,
    this.description,
  }) : assert(iterations > 0);

  final String id;
  final GeniusPdfBenchmarkFamily family;
  final int iterations;
  final FutureOr<List<int>> Function() generate;
  final String? description;
}

class GeniusPdfBenchmarkSample {
  const GeniusPdfBenchmarkSample({
    required this.elapsedMicroseconds,
    required this.outputBytes,
  });

  final int elapsedMicroseconds;
  final int outputBytes;
}

class GeniusPdfBenchmarkResult {
  const GeniusPdfBenchmarkResult({
    required this.id,
    required this.family,
    required this.samples,
  });

  final String id;
  final GeniusPdfBenchmarkFamily family;
  final List<GeniusPdfBenchmarkSample> samples;

  int get iterations => samples.length;

  int get totalMicroseconds => samples.fold<int>(
        0,
        (sum, sample) => sum + sample.elapsedMicroseconds,
      );

  double get averageMilliseconds =>
      samples.isEmpty ? 0 : totalMicroseconds / samples.length / 1000;

  int get minMicroseconds => samples.isEmpty
      ? 0
      : samples
          .map((sample) => sample.elapsedMicroseconds)
          .reduce((a, b) => a < b ? a : b);

  int get maxMicroseconds => samples.isEmpty
      ? 0
      : samples
          .map((sample) => sample.elapsedMicroseconds)
          .reduce((a, b) => a > b ? a : b);

  int get totalOutputBytes => samples.fold<int>(
        0,
        (sum, sample) => sum + sample.outputBytes,
      );
}

/// S24-T01/T06/T07 — deterministic benchmark harness.
///
/// The library does not persist machine-specific thresholds. Callers can store
/// accepted baselines in CI for their own hardware/runtime.
class GeniusPdfPerformanceBenchmarkRunner {
  const GeniusPdfPerformanceBenchmarkRunner();

  Future<GeniusPdfBenchmarkResult> run(
    GeniusPdfBenchmarkCase benchmark,
  ) async {
    final samples = <GeniusPdfBenchmarkSample>[];
    for (var index = 0; index < benchmark.iterations; index++) {
      final watch = Stopwatch()..start();
      final bytes = await benchmark.generate();
      watch.stop();
      samples.add(
        GeniusPdfBenchmarkSample(
          elapsedMicroseconds: watch.elapsedMicroseconds,
          outputBytes: bytes.length,
        ),
      );
    }
    return GeniusPdfBenchmarkResult(
      id: benchmark.id,
      family: benchmark.family,
      samples: List.unmodifiable(samples),
    );
  }

  Future<List<GeniusPdfBenchmarkResult>> runBatch(
    Iterable<GeniusPdfBenchmarkCase> cases, {
    bool concurrent = false,
  }) async {
    if (concurrent) {
      return Future.wait([for (final item in cases) run(item)]);
    }
    final results = <GeniusPdfBenchmarkResult>[];
    for (final item in cases) {
      results.add(await run(item));
    }
    return results;
  }
}

class GeniusPdfResourceCache<K, V> {
  GeniusPdfResourceCache({
    this.maxEntries = 256,
  }) : assert(maxEntries > 0);

  final int maxEntries;
  final Map<K, V> _values = <K, V>{};
  final List<K> _order = <K>[];

  int get length => _values.length;

  bool containsKey(K key) => _values.containsKey(key);

  V? operator [](K key) => _values[key];

  V putIfAbsent(
    K key,
    V Function() create,
  ) {
    final existing = _values[key];
    if (existing != null || _values.containsKey(key)) {
      _touch(key);
      return existing as V;
    }
    final value = create();
    _values[key] = value;
    _order.add(key);
    _trim();
    return value;
  }

  Future<V> putIfAbsentAsync(
    K key,
    Future<V> Function() create,
  ) async {
    final existing = _values[key];
    if (existing != null || _values.containsKey(key)) {
      _touch(key);
      return existing as V;
    }
    final value = await create();
    _values[key] = value;
    _order.add(key);
    _trim();
    return value;
  }

  void invalidate(K key) {
    _values.remove(key);
    _order.remove(key);
  }

  void clear() {
    _values.clear();
    _order.clear();
  }

  void _touch(K key) {
    _order.remove(key);
    _order.add(key);
  }

  void _trim() {
    while (_order.length > maxEntries) {
      final oldest = _order.removeAt(0);
      _values.remove(oldest);
    }
  }
}

/// S24-T02 — cache for immutable font/resource byte payloads.
class GeniusPdfResourceBytesCache
    extends GeniusPdfResourceCache<String, Uint8List> {
  GeniusPdfResourceBytesCache({super.maxEntries});
}

/// S24-T03 — cache for decoded/generated image, barcode and QR byte payloads.
class GeniusPdfMediaBytesCache
    extends GeniusPdfResourceCache<String, Uint8List> {
  GeniusPdfMediaBytesCache({super.maxEntries});
}

class GeniusPdfMeasurementKey {
  const GeniusPdfMeasurementKey({
    required this.contentHash,
    required this.widthMicros,
    required this.styleHash,
    this.direction = 'auto',
  });

  final int contentHash;
  final int widthMicros;
  final int styleHash;
  final String direction;

  @override
  bool operator ==(Object other) =>
      other is GeniusPdfMeasurementKey &&
      other.contentHash == contentHash &&
      other.widthMicros == widthMicros &&
      other.styleHash == styleHash &&
      other.direction == direction;

  @override
  int get hashCode =>
      Object.hash(contentHash, widthMicros, styleHash, direction);
}

/// S24-T04 — cache predictable measurements instead of re-measuring the same
/// immutable text/style/width tuple repeatedly.
class GeniusPdfMeasurementCache {
  GeniusPdfMeasurementCache({this.maxEntries = 4096})
      : _cache = GeniusPdfResourceCache<GeniusPdfMeasurementKey, double>(
          maxEntries: maxEntries,
        );

  final int maxEntries;
  final GeniusPdfResourceCache<GeniusPdfMeasurementKey, double> _cache;

  double measure(
    GeniusPdfMeasurementKey key,
    double Function() calculate,
  ) =>
      _cache.putIfAbsent(key, calculate);

  int get length => _cache.length;

  void clear() => _cache.clear();
}

class GeniusPdfLargeGridProfileSample {
  const GeniusPdfLargeGridProfileSample({
    required this.rows,
    required this.columns,
    required this.estimatedCellCount,
    required this.estimatedUtf16Units,
    required this.generatedBytes,
    required this.elapsedMicroseconds,
  });

  final int rows;
  final int columns;
  final int estimatedCellCount;
  final int estimatedUtf16Units;
  final int generatedBytes;
  final int elapsedMicroseconds;
}

/// S24-T05 — portable large-grid memory proxy.
///
/// The base package cannot read platform-specific process RSS reliably on every
/// target. This profile records the portable cardinality/text-volume/output
/// metrics needed by CI, where process-memory tooling can be layered on top.
class GeniusPdfLargeGridProfiler {
  const GeniusPdfLargeGridProfiler();

  GeniusPdfLargeGridProfileSample profile({
    required int rows,
    required int columns,
    required Iterable<String> textCells,
    required int generatedBytes,
    required int elapsedMicroseconds,
  }) {
    if (rows < 0 || columns < 0) {
      throw ArgumentError('rows/columns cannot be negative.');
    }
    final utf16 = textCells.fold<int>(
      0,
      (sum, value) => sum + value.length,
    );
    return GeniusPdfLargeGridProfileSample(
      rows: rows,
      columns: columns,
      estimatedCellCount: rows * columns,
      estimatedUtf16Units: utf16,
      generatedBytes: generatedBytes,
      elapsedMicroseconds: elapsedMicroseconds,
    );
  }
}

/// S24 benchmark baselines are identifiers, not hard-coded performance claims.
class GeniusPdfBenchmarkBaseline {
  const GeniusPdfBenchmarkBaseline({
    required this.id,
    required this.family,
    required this.rows,
    this.notes,
  });

  final String id;
  final GeniusPdfBenchmarkFamily family;
  final int rows;
  final String? notes;
}

class GeniusPdfBenchmarkCatalog {
  const GeniusPdfBenchmarkCatalog._();

  static const families = <GeniusPdfBenchmarkBaseline>[
    GeniusPdfBenchmarkBaseline(
      id: 'transaction-1-page',
      family: GeniusPdfBenchmarkFamily.transaction,
      rows: 5,
    ),
    GeniusPdfBenchmarkBaseline(
      id: 'statement-500-rows',
      family: GeniusPdfBenchmarkFamily.statement,
      rows: 500,
    ),
    GeniusPdfBenchmarkBaseline(
      id: 'analytical-1000-rows',
      family: GeniusPdfBenchmarkFamily.analyticalReport,
      rows: 1000,
    ),
    GeniusPdfBenchmarkBaseline(
      id: 'register-10000-rows',
      family: GeniusPdfBenchmarkFamily.register,
      rows: 10000,
      notes: 'Run only where CI/runtime limits permit.',
    ),
    GeniusPdfBenchmarkBaseline(
      id: 'thermal-100-lines',
      family: GeniusPdfBenchmarkFamily.thermalReceipt,
      rows: 100,
    ),
    GeniusPdfBenchmarkBaseline(
      id: 'label-sheet-100-labels',
      family: GeniusPdfBenchmarkFamily.label,
      rows: 100,
    ),
  ];
}
