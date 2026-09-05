import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for Project Financial.
class S14ProjectFinancialVerificationExampleScreen extends StatelessWidget {
  const S14ProjectFinancialVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14ProjectFinancialVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.projectFinancial,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.projectFinancial,
      description: pdfLocalization.s14ProjectFinancialVerify,
      apiName: 'buildS14ProjectFinancialVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14ProjectFinancialVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_project_financial.pdf',
    );
  }
}
