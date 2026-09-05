import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S09 verification example for Purchase Order — 50 lines.
class S09PurchaseOrder50VerificationExampleScreen extends StatelessWidget {
  const S09PurchaseOrder50VerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS09PurchaseOrder50VerificationPdf(GeniusPdfConfig config) {
  final runner = S09MigratedTransactionTemplatesRunner(
    baseConfig: config,
    scenario: S09MigratedTransactionTemplatesScenario.purchaseOrder50,
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
      title: pdfLocalization.purchaseOrder50Lines,
      description: pdfLocalization.s09PurchaseOrder50LinesVerify,
      apiName: 'buildS09PurchaseOrder50VerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09PurchaseOrder50VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_purchase_order50.pdf',
    );
  }
}
