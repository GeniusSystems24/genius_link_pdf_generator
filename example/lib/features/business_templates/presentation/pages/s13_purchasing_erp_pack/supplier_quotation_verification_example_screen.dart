import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S13 verification example for Supplier Quotation.
class S13SupplierQuotationVerificationExampleScreen extends StatelessWidget {
  const S13SupplierQuotationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13SupplierQuotationVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierQuotation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: pdfLocalization.supplierQuotation,
      description: pdfLocalization.s13SupplierQuotationVerify,
      apiName: 'buildS13SupplierQuotationVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13SupplierQuotationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_erp_pack_supplier_quotation.pdf',
    );
  }
}
