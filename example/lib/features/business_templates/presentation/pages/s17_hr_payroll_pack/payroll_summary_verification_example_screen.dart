import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S17 verification example for Payroll Summary.
class S17PayrollSummaryVerificationExampleScreen extends StatelessWidget {
  const S17PayrollSummaryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17PayrollSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payrollSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: 'Payroll Summary',
      description: 'Focused S17 verification for Payroll Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS17PayrollSummaryVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17PayrollSummaryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_payroll_summary.pdf',
    );
  }
}
