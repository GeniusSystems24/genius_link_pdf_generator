import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S15 verification example for Stock Transfer.
class S15StockTransferVerificationExampleScreen extends StatelessWidget {
  const S15StockTransferVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15StockTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: 'Stock Transfer',
      description: 'Focused S15 verification for Stock Transfer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS15StockTransferVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15StockTransferVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_stock_transfer.pdf',
    );
  }
}
