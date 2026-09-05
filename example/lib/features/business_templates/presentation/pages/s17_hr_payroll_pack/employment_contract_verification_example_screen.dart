import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S17 verification example for Employment Contract/Form.
class S17EmploymentContractVerificationExampleScreen extends StatelessWidget {
  const S17EmploymentContractVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17EmploymentContractVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employmentContract,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: 'Employment Contract/Form',
      description: 'Focused S17 verification for Employment Contract/Form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS17EmploymentContractVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17EmploymentContractVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_employment_contract.pdf',
    );
  }
}
