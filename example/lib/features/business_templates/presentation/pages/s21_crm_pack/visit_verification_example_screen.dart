import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S21 verification example for Visit Report.
class S21VisitVerificationExampleScreen extends StatelessWidget {
  const S21VisitVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21VisitVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.visit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: 'Visit Report',
      description: 'Focused S21 verification for Visit Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS21VisitVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21VisitVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_visit.pdf',
    );
  }
}
