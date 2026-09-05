import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for Rounding / Reconciliation.
class S14ReconciliationVerificationExampleScreen extends StatelessWidget {
  const S14ReconciliationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14ReconciliationVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.reconciliation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.roundingReconciliation,
      description: pdfLocalization.s14RoundingReconciliationVerify,
      apiName: 'buildS14ReconciliationVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14ReconciliationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_reconciliation.pdf',
    );
  }
}
