import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show MultiTransactionTransferPdf;

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/transaction_transfer_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildMultiTransactionTransferPdf({
  required bool isRtl,
}) => TemplateExampleBuild(
  builder: buildMultiTransactionTransferPdfDemo(isRtl: isRtl),
  fileName: 'multi_transaction_transfer_pdf_demo',
);

/// Demonstrates [MultiTransactionTransferPdf] using the supplied transfer data.
class MultiTransactionTransferPdfExampleScreen extends StatelessWidget {
  const MultiTransactionTransferPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''final report = MultiTransactionTransferPdf(
  config: pdfConfig,
  company: company,
  meta: TransactionTransferDocumentMeta(
    title: 'Transaction Transfer Register',
    titleAr: 'سجل حركات التحويلات',
    issueDate: DateTime.now(),
    exportingUserName: 'Ahmed Al-Hakimi',
  ),
  rows: TransactionTransferJsonData.rowsFromJson(transactionJson),
  services: TransactionTransferJsonData.servicesFromJson(servicesJson),
  configuration: TransactionTransferReportConfiguration(
    periodStart: DateTime(2026, 8, 28),
    periodEnd: DateTime(2026, 9, 1),
    selectedCurrency: 'YER',
    includeCommission: true,
  ),
  reportId: 'TRF-REG-001',
);''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Transaction Transfer Export Templates',
      title: 'MultiTransactionTransferPdf',
      titleAr: 'PDF لحركات التحويلات',
      description:
          'Landscape bilingual transfer register built from the supplied '
          'transaction_transfer structure. Every grid row represents one '
          'accounting leg and names one affected account, while serviceId + '
          'transactionId remains the transaction reference. It keeps commission '
          'rows visible and uses debit/credit semantic colors, QR, notes, and '
          'the repeating footer.',
      icon: Icons.compare_arrows,
      buildTemplate: _buildMultiTransactionTransferPdf,
      usageCode: dartUsageCode,
    );
  }
}
