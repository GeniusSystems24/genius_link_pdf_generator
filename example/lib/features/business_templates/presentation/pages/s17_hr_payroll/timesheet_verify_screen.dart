import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Timesheet.
class S17TimesheetVerificationExampleScreen extends StatelessWidget {
  const S17TimesheetVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17TimesheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.timesheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.timesheet,
      description: pdfLocalization.s17TimesheetVerify,
      apiName: 'buildS17TimesheetVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17TimesheetVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_timesheet.pdf',
    );
  }
}
