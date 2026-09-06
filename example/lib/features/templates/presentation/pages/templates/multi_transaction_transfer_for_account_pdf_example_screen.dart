import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show MultiTransactionTransferForAccountPdf;

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/transaction_transfer_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildMultiTransactionTransferForAccountPdf({
  required bool isRtl,
}) => TemplateExampleBuild(
  builder: buildMultiTransactionTransferForAccountPdfDemo(isRtl: isRtl),
  fileName: 'multi_transaction_transfer_for_account_pdf_demo',
);

/// Demonstrates [MultiTransactionTransferForAccountPdf] for account 2305.
class MultiTransactionTransferForAccountPdfExampleScreen
    extends StatelessWidget {
  const MultiTransactionTransferForAccountPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''final report = MultiTransactionTransferForAccountPdf(
  config: pdfConfig,
  company: company,
  meta: TransactionTransferDocumentMeta(
    title: 'Transaction Transfers for Account 2305',
    titleAr: 'حركات التحويل للحساب 2305',
    issueDate: DateTime.now(),
  ),
  rows: TransactionTransferJsonData.rowsFromJson(transactionJson),
  accountId: 2305,
  services: TransactionTransferJsonData.servicesFromJson(servicesJson),
  configuration: TransactionTransferReportConfiguration(
    periodStart: DateTime(2026, 8, 28),
    periodEnd: DateTime(2026, 9, 1),
    selectedCurrency: 'YER',
    includeCommission: true,
  ),
  openingBalances: const {'YER': 125000.0},
  reportId: 'TRF-ACC-2305',
);''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Transaction Transfer Export Templates',
      title: 'MultiTransactionTransferForAccountPdf',
      titleAr: 'PDF لحركات التحويل لحساب',
      description:
          'Account-scoped landscape report using account 2305 from the '
          'supplied transaction_transfer sample. It shows the account debit '
          'and credit movements, a caller-supplied opening balance row, '
          'commission legs, counterpart references, service information, QR, '
          'notes, and the repeating footer.',
      icon: Icons.account_balance_wallet_outlined,
      buildTemplate: _buildMultiTransactionTransferForAccountPdf,
      usageCode: dartUsageCode,
    );
  }
}
