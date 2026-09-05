import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_tx_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.bilingualRtlStructuredValues,
      description: pdfLocalization.s09BilingualRtlStructuredValuesVerify,
      apiName: 'buildS09BilingualVerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09BilingualVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_tx_bilingual.pdf',
    );
  }
}
