import 'package:flutter/material.dart';

import 'package:genius_pdf_example/benchmark/models/documents/s24_performance_regression_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Focused S24 verification screen for Semantic Regression.
class S24SemanticRegressionVerificationExampleScreen extends StatefulWidget {
  const S24SemanticRegressionVerificationExampleScreen({super.key});

  /// Exact generator function executed by this screen.
  static const String dartUsageCode = r'''Future<Uint8List> buildS24SemanticRegressionVerificationPdf(
  GeniusPdfConfig config, {
  int rows = 50,
}) async {
  final rtl = config.textDirection == TextDirection.rtl;
  const checker = GeniusPdfSemanticRegression();
  final expectation = GeniusPdfSemanticRegression.erpDocument(
    documentNumber: 'INV-LATIN-001',
    party: rtl ? 'عميل تجريبي' : 'Demo Customer',
    total: '1150.00',
    tax: '150.00',
    currency: 'SAR',
    pageNumber: '1/1',
    complianceMetadata: const <String>['UUID-DEMO-001'],
  );
  final source = <String>[
    'INV-LATIN-001',
    rtl ? 'عميل تجريبي' : 'Demo Customer',
    '1000.00',
    '150.00',
    '1150.00',
    'SAR',
    '1/1',
    'UUID-DEMO-001',
  ].join(' ');
  final result = checker.checkExtractedText(source, expectation);
  final diagnostic = 'semanticPass=${result.passed}; '
      'missing=${result.missing}; forbidden=${result.forbiddenFound}';

  final document = S24PerformanceRegressionVerificationDocument(
    config,
    scenario: 'Semantic Regression',
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
  State<S24SemanticRegressionVerificationExampleScreen> createState() =>
      _S24SemanticRegressionVerificationExampleScreenState();
}

class _S24SemanticRegressionVerificationExampleScreenState extends State<S24SemanticRegressionVerificationExampleScreen> {
  int _rows = 50;

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'Sprint S24 — Performance & Regression',
      title: 'Semantic Regression',
      description: 'Exercise the semantic-regression checker with ERP document fields and verify the expected values remain discoverable in LTR and RTL.',
      apiName: 'buildS24SemanticRegressionVerificationPdf',
      icon: Icons.fact_check_outlined,
      generator: (config) => buildS24SemanticRegressionVerificationPdf(
        config,
        rows: _rows,
      ),
      usageCode: S24SemanticRegressionVerificationExampleScreen.dartUsageCode,
      fileName: 's24_performance_regression_semantic.pdf',
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
