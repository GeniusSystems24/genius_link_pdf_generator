import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for End-of-Service.
class S17EndOfServiceVerificationExampleScreen extends StatelessWidget {
  const S17EndOfServiceVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17EndOfServiceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.endOfService,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.endOfService,
      description: pdfLocalization.s17EndServiceVerify,
      apiName: 'buildS17EndOfServiceVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17EndOfServiceVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_end_of_service.pdf',
    );
  }
}
