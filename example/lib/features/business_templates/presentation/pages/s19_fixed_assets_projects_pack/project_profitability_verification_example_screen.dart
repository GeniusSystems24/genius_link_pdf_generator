import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_fixed_assets_projects_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Project Profitability.
class S19ProjectProfitabilityVerificationExampleScreen extends StatelessWidget {
  const S19ProjectProfitabilityVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19ProjectProfitabilityVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectProfitability,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.projectProfitability,
      description: pdfLocalization.s19ProjectProfitabilityVerify,
      apiName: 'buildS19ProjectProfitabilityVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19ProjectProfitabilityVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_fixed_assets_projects_pack_project_profitability.pdf',
    );
  }
}
