import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S21 verification example for Activity Report.
class S21ActivityVerificationExampleScreen extends StatelessWidget {
  const S21ActivityVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21ActivityVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.activity,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: pdfLocalization.activityReport,
      description: pdfLocalization.s21ActivityReportVerify,
      apiName: 'buildS21ActivityVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21ActivityVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_activity.pdf',
    );
  }
}
