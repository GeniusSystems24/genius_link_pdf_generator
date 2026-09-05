import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for AR Aging.
class S14ArAgingVerificationExampleScreen extends StatelessWidget {
  const S14ArAgingVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14ArAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.arAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.arAging,
      description: pdfLocalization.s14ArAgingVerify,
      apiName: 'buildS14ArAgingVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14ArAgingVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_ar_aging.pdf',
    );
  }
}
