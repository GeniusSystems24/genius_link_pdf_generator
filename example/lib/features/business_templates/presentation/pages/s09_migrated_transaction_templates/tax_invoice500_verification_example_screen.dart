import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S09 verification example for Tax Invoice — 500 lines.
class S09TaxInvoice500VerificationExampleScreen extends StatelessWidget {
  const S09TaxInvoice500VerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS09TaxInvoice500VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.taxInvoice500,
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
      title: 'Tax Invoice — 500 lines',
      description: 'Focused S09 verification for Tax Invoice — 500 lines. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS09TaxInvoice500VerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09TaxInvoice500VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_tax_invoice500.pdf',
    );
  }
}
