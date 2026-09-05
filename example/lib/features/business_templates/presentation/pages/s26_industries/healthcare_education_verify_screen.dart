import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industries_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S26 verification example for Healthcare / Education Shells.
class S26HealthcareEducationVerificationExampleScreen extends StatelessWidget {
  const S26HealthcareEducationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26HealthcareEducationVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.healthcareEducation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: pdfLocalization.healthcareEducationShells,
      description: pdfLocalization.s26HealthcareEducationShellsVerify,
      apiName: 'buildS26HealthcareEducationVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26HealthcareEducationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industries_healthcare_education.pdf',
    );
  }
}
