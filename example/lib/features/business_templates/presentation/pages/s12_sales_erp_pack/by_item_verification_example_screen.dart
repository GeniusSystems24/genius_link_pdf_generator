import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S12 verification example for Sales by Item.
class S12ByItemVerificationExampleScreen extends StatelessWidget {
  const S12ByItemVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12ByItemVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.byItem,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: 'Sales by Item',
      description: 'Focused S12 verification for Sales by Item. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS12ByItemVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12ByItemVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_erp_pack_by_item.pdf',
    );
  }
}
