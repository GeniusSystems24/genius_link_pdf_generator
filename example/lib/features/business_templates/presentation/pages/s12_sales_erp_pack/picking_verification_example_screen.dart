import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S12 verification example for Picking List.
class S12PickingVerificationExampleScreen extends StatelessWidget {
  const S12PickingVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12PickingVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.picking,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: 'Picking List',
      description: 'Focused S12 verification for Picking List. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS12PickingVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12PickingVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_erp_pack_picking.pdf',
    );
  }
}
