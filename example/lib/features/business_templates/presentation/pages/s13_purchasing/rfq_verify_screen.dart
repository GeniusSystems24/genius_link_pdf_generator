import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S13 verification example for Request for Quotation.
class S13RfqVerificationExampleScreen extends StatelessWidget {
  const S13RfqVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13RfqVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.rfq,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: pdfLocalization.requestForQuotation,
      description: pdfLocalization.s13RequestQuotationVerify,
      apiName: 'buildS13RfqVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13RfqVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_rfq.pdf',
    );
  }
}
