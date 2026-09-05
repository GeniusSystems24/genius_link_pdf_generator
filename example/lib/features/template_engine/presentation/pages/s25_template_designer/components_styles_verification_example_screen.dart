import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s25_template_designer_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

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
      title: 'Components / Styles',
      description: 'Focused S25 verification for Components / Styles. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS25ComponentsStylesVerificationPdf',
      icon: Icons.design_services_outlined,
      generator: (config) => buildS25ComponentsStylesVerificationPdf(
        config,
        profile: _profile,
        rows: _rows,
      ),
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
            items: const [
              DropdownMenuItem(
                value: 'a4-portrait',
                child: Text('A4 Portrait'),
              ),
              DropdownMenuItem(
                value: 'thermal80',
                child: Text('Thermal 80'),
              ),
              DropdownMenuItem(
                value: 'labelSheet',
                child: Text('Label Sheet'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _profile = value);
            },
          ),
        ),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 10, label: Text('10 rows')),
            ButtonSegment(value: 100, label: Text('100 rows')),
            ButtonSegment(value: 500, label: Text('500 rows')),
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
