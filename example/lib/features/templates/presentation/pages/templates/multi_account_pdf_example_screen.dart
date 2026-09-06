import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show MultiAccountPdf;

import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildMultiAccountPdf({required bool isRtl}) =>
    TemplateExampleBuild(
      builder: buildMultiAccountPdfDemo(
        isRtl: isRtl,
      ),
      fileName: 'multi_account_pdf_demo',
    );

/// Demonstrates [MultiAccountPdf] with 200 accounts in a landscape report.
class MultiAccountPdfExampleScreen extends StatelessWidget {
  const MultiAccountPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''// The demo renders 200 accounts in a landscape PDF.
// Activity stays summarized in the account grid; no per-account transaction
// tables are appended. Group totals show the group name in Account Name.
final report = buildMultiAccountPdfDemo(
  isRtl: true,
);''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Account Export Templates',
      title: 'MultiAccountPdf',
      titleAr: 'PDF لعدة حسابات',
      description:
          'Landscape export with 200 demo accounts, bilingual split header, '
          'three-column report details, last transaction dates, group names '
          'inside total rows, summary movement columns, Trial Balance-style '
          'notes/QR, and a repeating user/date/page footer.',
      icon: Icons.account_tree_outlined,
      buildTemplate: _buildMultiAccountPdf,
      usageCode: dartUsageCode,
    );
  }
}
