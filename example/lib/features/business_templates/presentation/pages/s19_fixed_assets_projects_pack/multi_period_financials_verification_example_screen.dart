import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_fixed_assets_projects_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S19 verification example for Multi-period Financials.
class S19MultiPeriodFinancialsVerificationExampleScreen extends StatelessWidget {
  const S19MultiPeriodFinancialsVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19MultiPeriodFinancialsVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.multiPeriodFinancials,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: 'Multi-period Financials',
      description: 'Focused S19 verification for Multi-period Financials. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS19MultiPeriodFinancialsVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19MultiPeriodFinancialsVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_fixed_assets_projects_pack_multi_period_financials.pdf',
    );
  }
}
