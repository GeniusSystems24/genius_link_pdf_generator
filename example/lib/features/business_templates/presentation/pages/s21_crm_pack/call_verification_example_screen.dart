import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S21 verification example for Call Report.
class S21CallVerificationExampleScreen extends StatelessWidget {
  const S21CallVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21CallVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.call,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: 'Call Report',
      description: 'Focused S21 verification for Call Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS21CallVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21CallVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_call.pdf',
    );
  }
}
