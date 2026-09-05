import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for General Ledger.
class S14GeneralLedgerVerificationExampleScreen extends StatelessWidget {
  const S14GeneralLedgerVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14GeneralLedgerVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.generalLedger,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.generalLedger,
      description: pdfLocalization.s14GeneralLedgerVerify,
      apiName: 'buildS14GeneralLedgerVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14GeneralLedgerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_general_ledger.pdf',
    );
  }
}
