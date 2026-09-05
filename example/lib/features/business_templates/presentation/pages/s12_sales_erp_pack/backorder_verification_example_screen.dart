import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S12 verification example for Backorder.
class S12BackorderVerificationExampleScreen extends StatelessWidget {
  const S12BackorderVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12BackorderVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.backorder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: 'Backorder',
      description: 'Focused S12 verification for Backorder. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS12BackorderVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12BackorderVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_erp_pack_backorder.pdf',
    );
  }
}
