import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    show SingleAccountPdf;

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

Future<Uint8List> _generateSingleAccountPdfInBackground({required bool isRtl}) {
  return generateSingleAccountPdfInBackground(isRtl: isRtl);
}

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
);

// The example app submits generation to its global GeniusPdfGenerationManager.
final result = await generateExamplePdf(
  builder: detailed,
  fileName: 'single_account_pdf_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'SingleAccountPdf',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Account Export Templates',
      title: 'SingleAccountPdf',
      titleAr: 'PDF لحساب واحد',
      description: 'Portrait bilingual account export with three-column minimal account details, a balance summary plus Grid-based account activity per currency, independent currency sections, 120+ detailed rows per currency in the demo, TrialBalance-style QR and notes, and a per-page user/page footer.',
      icon: Icons.account_balance_wallet_outlined,
      backgroundGenerator: _generateSingleAccountPdfInBackground,
      backgroundFileName: 'single_account_pdf_demo.pdf',
      jobMetadata: <String, dynamic>{
        'feature': 'templates',
        'template': 'SingleAccountPdf',
      },
      showGenerationToast: true,
      usageCode: dartUsageCode,
    );
  }
}
