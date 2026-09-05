import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Payslip.
class S17PayslipVerificationExampleScreen extends StatelessWidget {
  const S17PayslipVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17PayslipVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payslip,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.payslip,
      description: pdfLocalization.s17PayslipVerify,
      apiName: 'buildS17PayslipVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17PayslipVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_payslip.pdf',
    );
  }
}
