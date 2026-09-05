import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S17 verification example for Employee List.
class S17EmployeeListVerificationExampleScreen extends StatelessWidget {
  const S17EmployeeListVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17EmployeeListVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employeeList,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: pdfLocalization.employeeList,
      description: pdfLocalization.s17EmployeeListVerify,
      apiName: 'buildS17EmployeeListVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17EmployeeListVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_employee_list.pdf',
    );
  }
}
