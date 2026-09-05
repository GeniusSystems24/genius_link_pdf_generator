import 'package:flutter/material.dart';

import 'package:genius_pdf_example/benchmark/models/documents/s24_performance_regression_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Focused S24 verification screen for Golden Coverage Manifest.
class S24GoldenCoverageManifestVerificationExampleScreen extends StatefulWidget {
  const S24GoldenCoverageManifestVerificationExampleScreen({super.key});

  /// Exact generator function executed by this screen.
  static const String dartUsageCode = r'''Future<Uint8List> buildS24GoldenCoverageManifestVerificationPdf(
  GeniusPdfConfig config, {
  int rows = 50,
}) async {
  final manifest = GeniusPdfGoldenManifest.core;
  final directions = GeniusPdfRegressionDirection.values
      .map((value) => value.name)
      .join(',');
  final diagnostic = 'goldenCases=${manifest.cases.length}; '
      'directions=$directions';
  final rtl = config.textDirection == TextDirection.rtl;

  final document = S24PerformanceRegressionVerificationDocument(
    config,
    scenario: 'Golden Coverage Manifest',
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
  State<S24GoldenCoverageManifestVerificationExampleScreen> createState() =>
      _S24GoldenCoverageManifestVerificationExampleScreenState();
}

class _S24GoldenCoverageManifestVerificationExampleScreenState extends State<S24GoldenCoverageManifestVerificationExampleScreen> {
  int _rows = 50;

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'Sprint S24 — Performance & Regression',
      title: 'Golden Coverage Manifest',
      description: 'Inspect the public golden-regression manifest and render its case count and supported regression directions in a focused PDF.',
      apiName: 'buildS24GoldenCoverageManifestVerificationPdf',
      icon: Icons.verified_outlined,
      generator: (config) => buildS24GoldenCoverageManifestVerificationPdf(
        config,
        rows: _rows,
      ),
      usageCode: S24GoldenCoverageManifestVerificationExampleScreen.dartUsageCode,
      fileName: 's24_performance_regression_golden_manifest.pdf',
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
