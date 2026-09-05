import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_fixed_assets_projects_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Project Budget.
class S19ProjectBudgetVerificationExampleScreen extends StatelessWidget {
  const S19ProjectBudgetVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19ProjectBudgetVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectBudget,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.projectBudget,
      description: pdfLocalization.s19ProjectBudgetVerify,
      apiName: 'buildS19ProjectBudgetVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19ProjectBudgetVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_fixed_assets_projects_pack_project_budget.pdf',
    );
  }
}
