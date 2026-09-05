import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S12 verification example for Sales by Salesperson.
class S12BySalespersonVerificationExampleScreen extends StatelessWidget {
  const S12BySalespersonVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12BySalespersonVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.bySalesperson,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: pdfLocalization.salesBySalesperson,
      description: pdfLocalization.s12SalesSalespersonVerify,
      apiName: 'buildS12BySalespersonVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12BySalespersonVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_by_salesperson.pdf',
    );
  }
}
