import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Experience Certificate.
class S17ExperienceCertificateVerificationExampleScreen extends StatelessWidget {
  const S17ExperienceCertificateVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17ExperienceCertificateVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.experienceCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.experienceCertificate,
      description: pdfLocalization.s17ExperienceCertificateVerify,
      apiName: 'buildS17ExperienceCertificateVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17ExperienceCertificateVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_experience_certificate.pdf',
    );
  }
}
