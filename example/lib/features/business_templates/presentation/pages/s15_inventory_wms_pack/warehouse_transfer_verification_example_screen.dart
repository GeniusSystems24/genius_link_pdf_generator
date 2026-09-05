import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Warehouse Transfer.
class S15WarehouseTransferVerificationExampleScreen extends StatelessWidget {
  const S15WarehouseTransferVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15WarehouseTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.warehouseTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.warehouseTransfer,
      description: pdfLocalization.s15WarehouseTransferVerify,
      apiName: 'buildS15WarehouseTransferVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15WarehouseTransferVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_warehouse_transfer.pdf',
    );
  }
}
