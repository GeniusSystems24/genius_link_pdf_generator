import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s09_migrated_transaction_templates_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

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
      title: 'Purchase Order — 50 lines',
      description: 'Focused S09 verification for Purchase Order — 50 lines. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS09PurchaseOrder50VerificationPdf',
      icon: Icons.description_outlined,
      generator: buildS09PurchaseOrder50VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's09_migrated_transaction_templates_purchase_order50.pdf',
    );
  }
}
