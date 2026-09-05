import 'package:flutter/material.dart';

import 'package:genius_pdf_example/benchmark/models/documents/s24_performance_regression_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Focused S24 verification screen for Resource / Measurement Cache.
class S24MeasurementCacheVerificationExampleScreen extends StatefulWidget {
  const S24MeasurementCacheVerificationExampleScreen({super.key});

  /// Exact generator function executed by this screen.
  static const String dartUsageCode = r'''Future<Uint8List> buildS24MeasurementCacheVerificationPdf(
  GeniusPdfConfig config, {
  int rows = 50,
}) async {
  final cache = GeniusPdfMeasurementCache();
  var calls = 0;
  const key = GeniusPdfMeasurementKey(
    contentHash: 101,
    widthMicros: 300000,
    styleHash: 202,
    direction: 'auto',
  );

  for (var index = 0; index < rows; index++) {
    cache.measure(key, () {
      calls++;
      return 40;
    });
  }

  final diagnostic = 'measurementCalls=$calls; '
      'cacheEntries=${cache.length}; requested=$rows';
  final rtl = config.textDirection == TextDirection.rtl;
  final document = S24PerformanceRegressionVerificationDocument(
    config,
    scenario: 'Resource / Measurement Cache',
    diagnostic: diagnostic,
    rows: rows,
    rtl: rtl,
  );

  try {
    return Uint8List.fromList(document.generate());
  } finally {
    document.dispose();
  }
}''';

  @override
  State<S24MeasurementCacheVerificationExampleScreen> createState() =>
      _S24MeasurementCacheVerificationExampleScreenState();
}

class _S24MeasurementCacheVerificationExampleScreenState extends State<S24MeasurementCacheVerificationExampleScreen> {
  int _rows = 50;

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'Sprint S24 — Performance & Regression',
      title: 'Resource / Measurement Cache',
      description: 'Verify repeated measurement requests reuse one cached calculation while the generated PDF records the requested row count.',
      apiName: 'buildS24MeasurementCacheVerificationPdf',
      icon: Icons.cached_outlined,
      generator: (config) => buildS24MeasurementCacheVerificationPdf(
        config,
        rows: _rows,
      ),
      usageCode: S24MeasurementCacheVerificationExampleScreen.dartUsageCode,
      fileName: 's24_performance_regression_cache.pdf',
      configurationVersion: _rows,
      controls: <Widget>[
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(value: 1, label: Text('1 row')),
            ButtonSegment<int>(value: 50, label: Text('50 rows')),
            ButtonSegment<int>(value: 500, label: Text('500 rows')),
          ],
          selected: <int>{_rows},
          onSelectionChanged: (selection) {
            final value = selection.first;
            if (value == _rows) return;
            setState(() => _rows = value);
          },
        ),
      ],
    );
  }
}
