import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s25_template_designer_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

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
      title: 'Validation Messages',
      description: 'Focused S25 verification for Validation Messages. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS25ValidationVerificationPdf',
      icon: Icons.design_services_outlined,
      generator: (config) => buildS25ValidationVerificationPdf(
        config,
        profile: _profile,
        rows: _rows,
      ),
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
