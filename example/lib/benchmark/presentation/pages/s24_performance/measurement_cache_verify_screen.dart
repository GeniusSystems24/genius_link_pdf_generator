import 'package:flutter/material.dart';

import 'package:genius_pdf_example/benchmark/models/documents/s24_performance_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.resourceMeasurementCache,
      description: pdfLocalization.verifyRepeatedMeasurementRequestsDesc,
      apiName: 'buildS24MeasurementCacheVerificationPdf',
      icon: Icons.cached_outlined,
      generator: (config) => buildS24MeasurementCacheVerificationPdf(
        config,
        rows: _rows,
      ),
      usageCode: S24MeasurementCacheVerificationExampleScreen.dartUsageCode,
      fileName: 's24_performance_cache.pdf',
      configurationVersion: _rows,
      controls: <Widget>[
        SegmentedButton<int>(
          segments: <ButtonSegment<int>>[
            ButtonSegment<int>(value: 1, label: Text(pdfLocalization.oneRow)),
            ButtonSegment<int>(value: 50, label: Text(pdfLocalization.fiftyRows)),
            ButtonSegment<int>(value: 500, label: Text(pdfLocalization.fiveHundredRows)),
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
