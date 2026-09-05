import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Leave Balance.
class S17LeaveBalanceVerificationExampleScreen extends StatelessWidget {
  const S17LeaveBalanceVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17LeaveBalanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.leaveBalance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.leaveBalance,
      description: pdfLocalization.s17LeaveBalanceVerify,
      apiName: 'buildS17LeaveBalanceVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17LeaveBalanceVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_leave_balance.pdf',
    );
  }
}
