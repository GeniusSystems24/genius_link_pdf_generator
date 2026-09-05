import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Allowances Report.
class S17AllowancesVerificationExampleScreen extends StatelessWidget {
  const S17AllowancesVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17AllowancesVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.allowances,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.allowancesReport,
      description: pdfLocalization.s17AllowancesReportVerify,
      apiName: 'buildS17AllowancesVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17AllowancesVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_allowances.pdf',
    );
  }
}
