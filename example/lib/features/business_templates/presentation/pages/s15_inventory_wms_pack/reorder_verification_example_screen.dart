import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Reorder Report.
class S15ReorderVerificationExampleScreen extends StatelessWidget {
  const S15ReorderVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15ReorderVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.reorder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.reorderReport,
      description: pdfLocalization.s15ReorderReportVerify,
      apiName: 'buildS15ReorderVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15ReorderVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_reorder.pdf',
    );
  }
}
