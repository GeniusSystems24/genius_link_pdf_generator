import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S15 verification example for Stock Ledger.
class S15StockLedgerVerificationExampleScreen extends StatelessWidget {
  const S15StockLedgerVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15StockLedgerVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockLedger,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: 'Stock Ledger',
      description: 'Focused S15 verification for Stock Ledger. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS15StockLedgerVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15StockLedgerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_stock_ledger.pdf',
    );
  }
}
