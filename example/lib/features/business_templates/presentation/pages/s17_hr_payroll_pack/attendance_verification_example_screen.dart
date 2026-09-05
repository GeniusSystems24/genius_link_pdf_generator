import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S17 verification example for Attendance Report.
class S17AttendanceVerificationExampleScreen extends StatelessWidget {
  const S17AttendanceVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17AttendanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.attendance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: 'Attendance Report',
      description: 'Focused S17 verification for Attendance Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS17AttendanceVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17AttendanceVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_attendance.pdf',
    );
  }
}
