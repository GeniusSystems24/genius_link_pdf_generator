import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

TemplateExampleBuild _buildTrialBalanceTemplate({required bool isRtl}) {
  return TemplateExampleBuild(
    builder: buildTrialBalanceTemplate(isRtl: isRtl),
    fileName: 'trial_balance_demo',
  );
}

/// Dedicated example screen for the Trial Balance template.
class TrialBalanceTemplateScreen extends StatelessWidget {
  const TrialBalanceTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same builder used by this example.
// Set isRtl to false for LTR output.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
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
final pdfBytes = Uint8List.fromList(template.generate());
template.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.trialBalance,
      titleAr: 'ميزان المراجعة',
      description: pdfLocalization.financialTrialBalanceReportDesc,
      icon: Icons.balance_outlined,
      buildTemplate: _buildTrialBalanceTemplate,
      usageCode: dartUsageCode,
    );
  }
}
