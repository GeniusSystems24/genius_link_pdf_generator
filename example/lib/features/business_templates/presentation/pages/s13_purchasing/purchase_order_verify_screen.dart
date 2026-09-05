import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S13 verification example for Purchase Order.
class S13PurchaseOrderVerificationExampleScreen extends StatelessWidget {
  const S13PurchaseOrderVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13PurchaseOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: pdfLocalization.purchaseOrder,
      description: pdfLocalization.s13PurchaseOrderVerify,
      apiName: 'buildS13PurchaseOrderVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13PurchaseOrderVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_purchase_order.pdf',
    );
  }
}
