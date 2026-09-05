import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Employment Certificate.
class S17EmploymentCertificateVerificationExampleScreen extends StatelessWidget {
  const S17EmploymentCertificateVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17EmploymentCertificateVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employmentCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.employmentCertificate,
      description: pdfLocalization.s17EmploymentCertificateVerify,
      apiName: 'buildS17EmploymentCertificateVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17EmploymentCertificateVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_employment_certificate.pdf',
    );
  }
}
