import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/template_engine_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S25 verification example for Conditions / Expressions.
class S25ExpressionsVerificationExampleScreen extends StatefulWidget {
  const S25ExpressionsVerificationExampleScreen({super.key});

  @override
  State<S25ExpressionsVerificationExampleScreen> createState() => _S25ExpressionsVerificationExampleScreenState();
}

class _S25ExpressionsVerificationExampleScreenState extends State<S25ExpressionsVerificationExampleScreen> {
  String _profile = 'a4-portrait';
  int _rows = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS25ExpressionsVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.expressions,
  );
  runner._profile = profile;
  runner._rows = rows;
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDesignerDirectionMode.arRtl
      : GeniusPdfDesignerDirectionMode.enLtr;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S25 Template Designer',
      title: pdfLocalization.conditionsExpressions,
      description: pdfLocalization.s25ConditionsExpressionsVerify,
      apiName: 'buildS25ExpressionsVerificationPdf',
      icon: Icons.design_services_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTemplateEngineVerificationInBackground(
        apiName: 'buildS25ExpressionsVerificationPdf',
        isRtl: isRtl,
        profile: _profile,
        rows: _rows,
      ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 's25_template_designer_expressions.pdf',
      configurationVersion: '$_profile:$_rows',
      controls: <Widget>[
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            initialValue: _profile,
            decoration: const InputDecoration(
              labelText: 'Page profile',
              border: OutlineInputBorder(),
            ),
            items:  [
              DropdownMenuItem(
                value: 'a4-portrait',
                child: Text(pdfLocalization.a4Portrait),
              ),
              DropdownMenuItem(
                value: 'thermal80',
                child: Text(pdfLocalization.thermal80),
              ),
              DropdownMenuItem(
                value: 'labelSheet',
                child: Text(pdfLocalization.labelSheet),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _profile = value);
            },
          ),
        ),
        SegmentedButton<int>(
          segments:  [
            ButtonSegment(value: 10, label: Text(pdfLocalization.tenRows)),
            ButtonSegment(value: 100, label: Text(pdfLocalization.oneHundredRows)),
            ButtonSegment(value: 500, label: Text(pdfLocalization.fiveHundredRows)),
          ],
          selected: <int>{_rows},
          onSelectionChanged: (selection) {
            setState(() => _rows = selection.first);
          },
        ),
      ],
    );
  }
}
