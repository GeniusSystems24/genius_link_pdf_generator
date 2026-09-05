import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industry_packs_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S26 verification example for Construction / Real Estate.
class S26ConstructionVerificationExampleScreen extends StatelessWidget {
  const S26ConstructionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26ConstructionVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.construction,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: 'Construction / Real Estate',
      description: 'Focused S26 verification for Construction / Real Estate. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS26ConstructionVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26ConstructionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industry_packs_construction.pdf',
    );
  }
}
