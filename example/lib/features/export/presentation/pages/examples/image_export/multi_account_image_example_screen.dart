import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show MultiAccountImage;

import 'package:genius_pdf_example/features/templates/models/documents/account_export_image_exporters.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';

/// Demonstrates [MultiAccountImage] splitting a dataset across compact images.
class MultiAccountImageExampleScreen extends StatelessWidget {
  const MultiAccountImageExampleScreen({super.key});

  static const String dartUsageCode = r'''final images = MultiAccountImage.split(
  config: config,
  meta: meta,
  accounts: accounts,
  company: company,
  reportId: 'MULTI-ACC-IMG-20260906',
  maxAccountsPerImage: 8,
  showQRCode: true,
  showNotes: true,
  showLastTransactionDate: true,
  configuration: const AccountExportConfiguration(
    fields: AccountExportFieldVisibility.multiImage,
    selectedCurrency: 'YER',
    showBalances: true,
    showActivity: true,
    activityMode: AccountExportActivityMode.summary,
  ),
);

// Each builder remains summary-only and is exported through the existing
// PdfDocument.exportToImages(...) flow.
''';

  @override
  Widget build(BuildContext context) {
    return const TemplateImageExportDetailScreen(
      category: 'Account Export Templates',
      title: 'MultiAccountImage',
      description:
          'Landscape summary-only account images with report details, last-transaction date, debit/credit semantic cells, QR/notes, footer metadata, and explicit dataset splitting.',
      icon: Icons.collections_outlined,
      exportTemplate: exportMultiAccountImageDemo,
      usageCode: dartUsageCode,
    );
  }
}
