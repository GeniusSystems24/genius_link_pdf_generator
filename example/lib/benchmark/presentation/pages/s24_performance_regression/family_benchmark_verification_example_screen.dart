import 'package:flutter/material.dart';

import 'package:genius_pdf_example/benchmark/models/documents/s24_performance_regression_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Focused S24 verification screen for Family Benchmark.
class S24FamilyBenchmarkVerificationExampleScreen extends StatefulWidget {
  const S24FamilyBenchmarkVerificationExampleScreen({super.key});

  /// Exact generator function executed by this screen.
  static const String dartUsageCode = r'''Future<Uint8List> buildS24FamilyBenchmarkVerificationPdf(
  GeniusPdfConfig config, {
  int rows = 50,
}) async {
  const runner = GeniusPdfPerformanceBenchmarkRunner();
  final result = await runner.run(
    GeniusPdfBenchmarkCase(
      id: 'manual-family-benchmark',
      family: GeniusPdfBenchmarkFamily.transaction,
      iterations: 3,
      generate: () => List<int>.filled(rows * 10, 1),
    ),
  );

  final diagnostic = 'iterations=${result.iterations}; '
      'avgMs=${result.averageMilliseconds.toStringAsFixed(3)}; '
      'bytes=${result.totalOutputBytes}';
  final rtl = config.textDirection == TextDirection.rtl;
  final document = S24PerformanceRegressionVerificationDocument(
    config,
    scenario: 'Family Benchmark',
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
  State<S24FamilyBenchmarkVerificationExampleScreen> createState() =>
      _S24FamilyBenchmarkVerificationExampleScreenState();
}

class _S24FamilyBenchmarkVerificationExampleScreenState extends State<S24FamilyBenchmarkVerificationExampleScreen> {
  int _rows = 50;

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'Sprint S24 — Performance & Regression',
      title: 'Family Benchmark',
      description: 'Run the public performance benchmark API and render the measured iteration timing and output-byte diagnostics in a focused PDF.',
      apiName: 'buildS24FamilyBenchmarkVerificationPdf',
      icon: Icons.speed_outlined,
      generator: (config) => buildS24FamilyBenchmarkVerificationPdf(
        config,
        rows: _rows,
      ),
      usageCode: S24FamilyBenchmarkVerificationExampleScreen.dartUsageCode,
      fileName: 's24_performance_regression_benchmark.pdf',
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
