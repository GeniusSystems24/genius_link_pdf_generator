import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/template_engine_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S25 verification example for Components / Styles.
class S25ComponentsStylesVerificationExampleScreen extends StatefulWidget {
  const S25ComponentsStylesVerificationExampleScreen({super.key});

  @override
  State<S25ComponentsStylesVerificationExampleScreen> createState() => _S25ComponentsStylesVerificationExampleScreenState();
}

class _S25ComponentsStylesVerificationExampleScreenState extends State<S25ComponentsStylesVerificationExampleScreen> {
  String _profile = 'a4-portrait';
  int _rows = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS25ComponentsStylesVerificationPdf(
  GeniusPdfConfig config, {
  String profile = 'a4-portrait',
  int rows = 10,
}) {
  final runner = S25TemplateDesignerRunner(
    baseConfig: config,
    scenario: S25TemplateDesignerScenario.componentsStyles,
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
      title: pdfLocalization.componentsStyles,
      description: pdfLocalization.s25ComponentsStylesVerify,
      apiName: 'buildS25ComponentsStylesVerificationPdf',
      icon: Icons.design_services_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTemplateEngineVerificationInBackground(
        apiName: 'buildS25ComponentsStylesVerificationPdf',
        isRtl: isRtl,
        profile: _profile,
        rows: _rows,
      ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 's25_template_designer_components_styles.pdf',
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
