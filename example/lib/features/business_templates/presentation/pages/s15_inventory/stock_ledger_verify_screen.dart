import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.stockLedger,
      description: pdfLocalization.s15StockLedgerVerify,
      apiName: 'buildS15StockLedgerVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15StockLedgerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_stock_ledger.pdf',
    );
  }
}
