import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s22_engine_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.invalidExpressionRejection,
      description: pdfLocalization.s22InvalidExpressionRejectionVerify,
      apiName: 'buildS22InvalidExpressionVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: (config) => buildS22InvalidExpressionVerificationPdf(
        config,
        rowCount: _rowCount,
      ),
      usageCode: dartUsageCode,
      fileName: 's22_engine_vnext_invalid_expression.pdf',
      configurationVersion: _rowCount,
      controls: <Widget>[
        SegmentedButton<int>(
          segments:  [
            ButtonSegment(value: 1, label: Text(pdfLocalization.oneRow)),
            ButtonSegment(value: 100, label: Text(pdfLocalization.oneHundredRows)),
            ButtonSegment(value: 1000, label: Text(pdfLocalization.oneThousandRows)),
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
