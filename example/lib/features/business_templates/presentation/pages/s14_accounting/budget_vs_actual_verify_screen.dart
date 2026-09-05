import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for Budget vs Actual.
class S14BudgetVsActualVerificationExampleScreen extends StatelessWidget {
  const S14BudgetVsActualVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14BudgetVsActualVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.budgetVsActual,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.budgetVsActual,
      description: pdfLocalization.s14BudgetVsActualVerify,
      apiName: 'buildS14BudgetVsActualVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14BudgetVsActualVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_budget_vs_actual.pdf',
    );
  }
}
