import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_fixed_assets_projects_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Progress Report.
class S19ProgressVerificationExampleScreen extends StatelessWidget {
  const S19ProgressVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19ProgressVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.progress,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.progressReport,
      description: pdfLocalization.s19ProgressReportVerify,
      apiName: 'buildS19ProgressVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19ProgressVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_fixed_assets_projects_pack_progress.pdf',
    );
  }
}
