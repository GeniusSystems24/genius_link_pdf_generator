import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/template_engine_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S22 verification example for Components / Styles / SubTemplate.
class S22CompositionVerificationExampleScreen extends StatefulWidget {
  const S22CompositionVerificationExampleScreen({super.key});

  @override
  State<S22CompositionVerificationExampleScreen> createState() => _S22CompositionVerificationExampleScreenState();
}

class _S22CompositionVerificationExampleScreenState extends State<S22CompositionVerificationExampleScreen> {
  int _rowCount = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS22CompositionVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.composition,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S22 Template Engine vNext',
      title: pdfLocalization.componentsStylesSubTemplate,
      description: pdfLocalization.s22ComponentsStylesSubTemplateVerify,
      apiName: 'buildS22CompositionVerificationPdf',
      icon: Icons.account_tree_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTemplateEngineVerificationInBackground(
        apiName: 'buildS22CompositionVerificationPdf',
        isRtl: isRtl,
        rowCount: _rowCount,
      ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 's22_engine_vnext_composition.pdf',
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
