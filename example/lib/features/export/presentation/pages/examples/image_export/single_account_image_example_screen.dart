import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show SingleAccountImage;

import 'package:genius_pdf_example/features/templates/models/documents/account_export_image_exporters.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';

/// Demonstrates [SingleAccountImage] using the existing PDF-to-image exporter.
class SingleAccountImageExampleScreen extends StatelessWidget {
  const SingleAccountImageExampleScreen({super.key});

  static const String dartUsageCode = r'''final compact = SingleAccountImage(
  config: config,
  meta: meta,
  account: account,
  company: company,
  reportId: 'SINGLE-ACC-IMG-001',
  showQRCode: true,
  showNotes: true,
  configuration: const AccountExportConfiguration(
    fields: AccountExportFieldVisibility.singleImage,
    selectedCurrency: 'YER',
    showBalances: true,
    showActivity: true,
    activityMode: AccountExportActivityMode.summary,
  ),
);

// SingleAccountImage is summary-only. Generate its PDF source page, then use
// PdfDocument.exportToImages(...) through the package's existing exporter.
''';

  @override
  Widget build(BuildContext context) {
    return const TemplateImageExportDetailScreen(
      category: 'Account Export Templates',
      title: 'SingleAccountImage',
      description:
          'Portrait summary-only account image with bilingual split header, three-column minimal details, semantic balance/activity styling, QR verification, notes, and export metadata footer.',
      icon: Icons.image_outlined,
      exportTemplate: exportSingleAccountImageDemo,
      usageCode: dartUsageCode,
    );
  }
}
