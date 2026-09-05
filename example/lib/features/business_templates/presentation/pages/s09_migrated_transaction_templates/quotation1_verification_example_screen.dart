import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S09 verification example for Quotation — 1 line.
class S09Quotation1VerificationExampleScreen extends StatelessWidget {
  const S09Quotation1VerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS09Quotation1VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.quotation1,
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
      title: 'Quotation — 1 line',
      description: 'Focused S09 verification for Quotation — 1 line. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS09Quotation1VerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09Quotation1VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_quotation1.pdf',
    );
  }
}
