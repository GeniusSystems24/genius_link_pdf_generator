import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s22_template_engine_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S22 verification example for Bounded Large Loop.
class S22LargeLoopVerificationExampleScreen extends StatefulWidget {
  const S22LargeLoopVerificationExampleScreen({super.key});

  @override
  State<S22LargeLoopVerificationExampleScreen> createState() => _S22LargeLoopVerificationExampleScreenState();
}

class _S22LargeLoopVerificationExampleScreenState extends State<S22LargeLoopVerificationExampleScreen> {
  int _rowCount = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS22LargeLoopVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.largeLoop,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S22 Template Engine vNext',
      title: 'Bounded Large Loop',
      description: 'Focused S22 verification for Bounded Large Loop. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS22LargeLoopVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: (config) => buildS22LargeLoopVerificationPdf(
        config,
        rowCount: _rowCount,
      ),
      usageCode: dartUsageCode,
      fileName: 's22_template_engine_vnext_large_loop.pdf',
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
