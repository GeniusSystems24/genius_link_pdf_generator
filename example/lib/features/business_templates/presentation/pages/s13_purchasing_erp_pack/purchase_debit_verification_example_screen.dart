import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S13 verification example for Purchase Debit Note.
class S13PurchaseDebitVerificationExampleScreen extends StatelessWidget {
  const S13PurchaseDebitVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13PurchaseDebitVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseDebit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: 'Purchase Debit Note',
      description: 'Focused S13 verification for Purchase Debit Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS13PurchaseDebitVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13PurchaseDebitVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_erp_pack_purchase_debit.pdf',
    );
  }
}
