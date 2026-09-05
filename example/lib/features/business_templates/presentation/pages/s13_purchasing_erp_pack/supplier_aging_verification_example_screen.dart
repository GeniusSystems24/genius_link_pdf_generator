import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S13 verification example for Supplier Aging.
class S13SupplierAgingVerificationExampleScreen extends StatelessWidget {
  const S13SupplierAgingVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13SupplierAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: 'Supplier Aging',
      description: 'Focused S13 verification for Supplier Aging. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS13SupplierAgingVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13SupplierAgingVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_erp_pack_supplier_aging.pdf',
    );
  }
}
