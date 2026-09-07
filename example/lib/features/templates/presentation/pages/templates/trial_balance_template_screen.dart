import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

Future<Uint8List> _generateTrialBalanceInBackground({required bool isRtl}) {
  return generateTrialBalanceTemplateInBackground(isRtl: isRtl);
}

/// Dedicated example screen for the Trial Balance template.
class TrialBalanceTemplateScreen extends StatelessWidget {
  const TrialBalanceTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same builder used by this example.
// Set isRtl to false for LTR output.

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';
import 'package:genius_pdf_example/shared/data/sample_data.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
GeniusPdfConfig createTemplatesDemoConfig({required bool isRtl}) {
  return geniusPdfConfig.copyWith(
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}

TrialBalanceTemplate buildTrialBalanceTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return TrialBalanceTemplate(
    config: config,
    company: SampleData.companyInfo,
    data: SampleData.trialBalanceData,
    reportId: "123456789",
    printedBy: config.isRTL ? "أنور السياري" : "Anwar Al-saiary",
    showSignatures: true,
    showQRCode: true,
  );
}

final template = buildTrialBalanceTemplate(isRtl: true);
final result = await generateExamplePdf(
  builder: template,
  fileName: 'trial_balance_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'TrialBalanceTemplate',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.trialBalance,
      titleAr: 'ميزان المراجعة',
      description: pdfLocalization.financialTrialBalanceReportDesc,
      icon: Icons.balance_outlined,
      backgroundGenerator: _generateTrialBalanceInBackground,
      backgroundFileName: 'trial_balance_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'TrialBalanceTemplate',
      },
      showGenerationToast: true,
      usageCode: dartUsageCode,
    );
  }
}
