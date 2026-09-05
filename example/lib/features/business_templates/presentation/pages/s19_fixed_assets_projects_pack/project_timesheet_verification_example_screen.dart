import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s19_fixed_assets_projects_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S19 verification example for Project Timesheet.
class S19ProjectTimesheetVerificationExampleScreen extends StatelessWidget {
  const S19ProjectTimesheetVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS19ProjectTimesheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectTimesheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S19 Fixed Assets & Projects Pack',
      title: pdfLocalization.projectTimesheet,
      description: pdfLocalization.s19ProjectTimesheetVerify,
      apiName: 'buildS19ProjectTimesheetVerificationPdf',
      icon: Icons.domain_outlined,
      generator: buildS19ProjectTimesheetVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's19_fixed_assets_projects_pack_project_timesheet.pdf',
    );
  }
}
