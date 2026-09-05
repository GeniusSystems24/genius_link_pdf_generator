import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S21 verification example for Customer History.
class S21HistoryVerificationExampleScreen extends StatelessWidget {
  const S21HistoryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21HistoryVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.history,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: 'Customer History',
      description: 'Focused S21 verification for Customer History. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS21HistoryVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21HistoryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_history.pdf',
    );
  }
}
