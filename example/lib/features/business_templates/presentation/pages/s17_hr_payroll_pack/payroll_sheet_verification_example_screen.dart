import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S17 verification example for Payroll Sheet.
class S17PayrollSheetVerificationExampleScreen extends StatelessWidget {
  const S17PayrollSheetVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17PayrollSheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payrollSheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: 'Payroll Sheet',
      description: 'Focused S17 verification for Payroll Sheet. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS17PayrollSheetVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17PayrollSheetVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_payroll_sheet.pdf',
    );
  }
}
