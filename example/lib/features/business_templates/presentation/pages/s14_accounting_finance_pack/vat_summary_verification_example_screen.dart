import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S14 verification example for VAT / Tax Summary.
class S14VatSummaryVerificationExampleScreen extends StatelessWidget {
  const S14VatSummaryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14VatSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.vatSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: 'VAT / Tax Summary',
      description: 'Focused S14 verification for VAT / Tax Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS14VatSummaryVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14VatSummaryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_vat_summary.pdf',
    );
  }
}
