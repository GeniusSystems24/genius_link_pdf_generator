import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S12 verification example for Sales by Customer.
class S12ByCustomerVerificationExampleScreen extends StatelessWidget {
  const S12ByCustomerVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12ByCustomerVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.byCustomer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: pdfLocalization.salesByCustomer,
      description: pdfLocalization.s12SalesCustomerVerify,
      apiName: 'buildS12ByCustomerVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12ByCustomerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_erp_pack_by_customer.pdf',
    );
  }
}
