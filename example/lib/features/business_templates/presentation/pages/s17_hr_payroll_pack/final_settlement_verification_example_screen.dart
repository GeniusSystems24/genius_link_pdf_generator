import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s17_hr_payroll_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S17 verification example for Final Settlement.
class S17FinalSettlementVerificationExampleScreen extends StatelessWidget {
  const S17FinalSettlementVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS17FinalSettlementVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.finalSettlement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S17 HR & Payroll Pack',
      title: 'Final Settlement',
      description: 'Focused S17 verification for Final Settlement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS17FinalSettlementVerificationPdf',
      icon: Icons.groups_outlined,
      generator: buildS17FinalSettlementVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's17_hr_payroll_pack_final_settlement.pdf',
    );
  }
}
