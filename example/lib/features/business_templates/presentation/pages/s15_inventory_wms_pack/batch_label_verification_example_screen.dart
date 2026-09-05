import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S15 verification example for Batch Label.
class S15BatchLabelVerificationExampleScreen extends StatelessWidget {
  const S15BatchLabelVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15BatchLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.batchLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: 'Batch Label',
      description: 'Focused S15 verification for Batch Label. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS15BatchLabelVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15BatchLabelVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_batch_label.pdf',
    );
  }
}
