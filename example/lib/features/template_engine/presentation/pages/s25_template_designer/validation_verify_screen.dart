import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/template_engine_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S25 verification example for Validation Messages.
class S25ValidationVerificationExampleScreen extends StatefulWidget {
  const S25ValidationVerificationExampleScreen({super.key});

  @override
  State<S25ValidationVerificationExampleScreen> createState() => _S25ValidationVerificationExampleScreenState();
}

class _S25ValidationVerificationExampleScreenState extends State<S25ValidationVerificationExampleScreen> {
  String _profile = 'a4-portrait';
  int _rows = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS25ValidationVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.validation,
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
      title: pdfLocalization.validationMessages,
      description: pdfLocalization.s25ValidationMessagesVerify,
      apiName: 'buildS25ValidationVerificationPdf',
      icon: Icons.design_services_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTemplateEngineVerificationInBackground(
        apiName: 'buildS25ValidationVerificationPdf',
        isRtl: isRtl,
        profile: _profile,
        rows: _rows,
      ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 's25_template_designer_validation.pdf',
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
