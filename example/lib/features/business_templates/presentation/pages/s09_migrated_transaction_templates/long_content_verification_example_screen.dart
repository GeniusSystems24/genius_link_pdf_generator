import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S09 verification example for Long party / notes / terms.
class S09LongContentVerificationExampleScreen extends StatelessWidget {
  const S09LongContentVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS09LongContentVerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.longContent,
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
      title: pdfLocalization.longPartyNotesTerms,
      description: pdfLocalization.s09LongPartyNotesTermsVerify,
      apiName: 'buildS09LongContentVerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09LongContentVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_long_content.pdf',
    );
  }
}
