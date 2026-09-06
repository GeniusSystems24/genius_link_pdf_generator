import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show SingleAccountPdf;

import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildSingleAccountPdf({required bool isRtl}) =>
    TemplateExampleBuild(
      builder: buildSingleAccountPdfDemo(
        isRtl: isRtl,
      ),
      fileName: 'single_account_pdf_demo',
    );

/// Demonstrates [SingleAccountPdf] in portrait with long per-currency activity.
class SingleAccountPdfExampleScreen extends StatelessWidget {
  const SingleAccountPdfExampleScreen({super.key});

  static const String dartUsageCode = r'''// Detailed mode renders each currency independently in this order:
// balance -> activity grid -> detailed transactions.
// The demo contains 120 detailed rows for YER and 120 rows for USD.
final detailed = buildSingleAccountPdfDemo(
  isRtl: false,
  activityMode: AccountExportActivityMode.detailed,
);

// SingleAccountPdf uses portrait pages, a bilingual split header,
// a repeating footer (user + page number) and
// TrialBalanceTemplate-style notes + QR.
final summary = buildSingleAccountPdfDemo(
  isRtl: false,
  activityMode: AccountExportActivityMode.summary,
);''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Account Export Templates',
      title: 'SingleAccountPdf',
      titleAr: 'PDF لحساب واحد',
      description: 'Portrait bilingual account export with three-column minimal account details, a balance summary plus Grid-based account activity per currency, independent currency sections, 120+ detailed rows per currency in the demo, TrialBalance-style QR and notes, and a per-page user/page footer.',
      icon: Icons.account_balance_wallet_outlined,
      buildTemplate: _buildSingleAccountPdf,
      usageCode: dartUsageCode,
    );
  }
}
