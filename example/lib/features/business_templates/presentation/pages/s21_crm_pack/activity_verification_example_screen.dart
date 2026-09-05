import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

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
      title: 'Activity Report',
      description: 'Focused S21 verification for Activity Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS21ActivityVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21ActivityVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_activity.pdf',
    );
  }
}
