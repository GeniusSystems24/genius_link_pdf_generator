import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for AP Aging.
class S14ApAgingVerificationExampleScreen extends StatelessWidget {
  const S14ApAgingVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14ApAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.apAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.apAging,
      description: pdfLocalization.s14ApAgingVerify,
      apiName: 'buildS14ApAgingVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14ApAgingVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_ap_aging.pdf',
    );
  }
}
