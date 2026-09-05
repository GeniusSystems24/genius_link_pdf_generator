import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S09 verification example for Bilingual / RTL structured values.
class S09BilingualVerificationExampleScreen extends StatelessWidget {
  const S09BilingualVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS09BilingualVerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.bilingual,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S09 Migrated Transaction Templates',
      title: 'Bilingual / RTL structured values',
      description: 'Focused S09 verification for Bilingual / RTL structured values. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS09BilingualVerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09BilingualVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_bilingual.pdf',
    );
  }
}
