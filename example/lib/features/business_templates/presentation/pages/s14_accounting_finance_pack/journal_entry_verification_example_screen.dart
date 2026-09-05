import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S14 verification example for Journal Entry.
class S14JournalEntryVerificationExampleScreen extends StatelessWidget {
  const S14JournalEntryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14JournalEntryVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.journalEntry,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: 'Journal Entry',
      description: 'Focused S14 verification for Journal Entry. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS14JournalEntryVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14JournalEntryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_journal_entry.pdf',
    );
  }
}
