import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s22_template_engine_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S22 verification example for Invalid Expression Rejection.
class S22InvalidExpressionVerificationExampleScreen extends StatefulWidget {
  const S22InvalidExpressionVerificationExampleScreen({super.key});

  @override
  State<S22InvalidExpressionVerificationExampleScreen> createState() => _S22InvalidExpressionVerificationExampleScreenState();
}

class _S22InvalidExpressionVerificationExampleScreenState extends State<S22InvalidExpressionVerificationExampleScreen> {
  int _rowCount = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS22InvalidExpressionVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.invalidExpression,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S22 Template Engine vNext',
      title: 'Invalid Expression Rejection',
      description: 'Focused S22 verification for Invalid Expression Rejection. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS22InvalidExpressionVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: (config) => buildS22InvalidExpressionVerificationPdf(
        config,
        rowCount: _rowCount,
      ),
      usageCode: dartUsageCode,
      fileName: 's22_template_engine_vnext_invalid_expression.pdf',
      configurationVersion: _rowCount,
      controls: <Widget>[
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 1, label: Text('1 row')),
            ButtonSegment(value: 100, label: Text('100 rows')),
            ButtonSegment(value: 1000, label: Text('1000 rows')),
          ],
          selected: <int>{_rowCount},
          onSelectionChanged: (selection) {
            setState(() => _rowCount = selection.first);
          },
        ),
      ],
    );
  }
}
