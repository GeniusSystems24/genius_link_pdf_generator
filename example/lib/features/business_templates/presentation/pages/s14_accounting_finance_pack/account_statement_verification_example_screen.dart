import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S14 verification example for Account Statement.
class S14AccountStatementVerificationExampleScreen extends StatelessWidget {
  const S14AccountStatementVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14AccountStatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.accountStatement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: 'Account Statement',
      description: 'Focused S14 verification for Account Statement. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS14AccountStatementVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14AccountStatementVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_account_statement.pdf',
    );
  }
}
