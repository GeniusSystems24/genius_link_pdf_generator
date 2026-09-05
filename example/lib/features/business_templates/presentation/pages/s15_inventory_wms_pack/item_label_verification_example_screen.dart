import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Item Label.
class S15ItemLabelVerificationExampleScreen extends StatelessWidget {
  const S15ItemLabelVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15ItemLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.itemLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.itemLabel,
      description: pdfLocalization.s15ItemLabelVerify,
      apiName: 'buildS15ItemLabelVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15ItemLabelVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_item_label.pdf',
    );
  }
}
