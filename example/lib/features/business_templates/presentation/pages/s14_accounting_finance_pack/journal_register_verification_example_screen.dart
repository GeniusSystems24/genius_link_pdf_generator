import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for Journal Register.
class S14JournalRegisterVerificationExampleScreen extends StatelessWidget {
  const S14JournalRegisterVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14JournalRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.journalRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.journalRegister,
      description: pdfLocalization.s14JournalRegisterVerify,
      apiName: 'buildS14JournalRegisterVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14JournalRegisterVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_journal_register.pdf',
    );
  }
}
