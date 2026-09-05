import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_tx_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.taxInvoice500Lines,
      description: pdfLocalization.s09TaxInvoice500LinesVerify,
      apiName: 'buildS09TaxInvoice500VerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09TaxInvoice500VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_tx_tax_invoice500.pdf',
    );
  }
}
