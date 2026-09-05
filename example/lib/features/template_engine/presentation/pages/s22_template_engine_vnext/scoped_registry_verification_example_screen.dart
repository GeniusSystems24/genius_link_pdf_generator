import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s22_template_engine_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S22 verification example for Registry Fallback / History.
class S22ScopedRegistryVerificationExampleScreen extends StatefulWidget {
  const S22ScopedRegistryVerificationExampleScreen({super.key});

  @override
  State<S22ScopedRegistryVerificationExampleScreen> createState() => _S22ScopedRegistryVerificationExampleScreenState();
}

class _S22ScopedRegistryVerificationExampleScreenState extends State<S22ScopedRegistryVerificationExampleScreen> {
  int _rowCount = 10;

  static const String dartUsageCode = r'''Future<Uint8List> buildS22ScopedRegistryVerificationPdf(
  GeniusPdfConfig config, {
  int rowCount = 10,
}) {
  final runner = S22TemplateEngineVnextRunner(
    baseConfig: config,
    scenario: S22TemplateEngineVnextScenario.scopedRegistry,
  );
  runner._rowCount = rowCount;
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S22 Template Engine vNext',
      title: pdfLocalization.registryFallbackHistory,
      description: pdfLocalization.s22RegistryFallbackHistoryVerify,
      apiName: 'buildS22ScopedRegistryVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: (config) => buildS22ScopedRegistryVerificationPdf(
        config,
        rowCount: _rowCount,
      ),
      usageCode: dartUsageCode,
      fileName: 's22_template_engine_vnext_scoped_registry.pdf',
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
