import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s13_purchasing_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S13 verification example for Quotation Comparison.
class S13ComparisonVerificationExampleScreen extends StatelessWidget {
  const S13ComparisonVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS13ComparisonVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.comparison,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S13 Purchasing ERP Pack',
      title: pdfLocalization.quotationComparison,
      description: pdfLocalization.s13QuotationComparisonVerify,
      apiName: 'buildS13ComparisonVerificationPdf',
      icon: Icons.shopping_cart_checkout_outlined,
      generator: buildS13ComparisonVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's13_purchasing_erp_pack_comparison.pdf',
    );
  }
}
