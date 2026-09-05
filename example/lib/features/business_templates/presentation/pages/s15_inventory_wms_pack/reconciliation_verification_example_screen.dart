import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Count Reconciliation.
class S15ReconciliationVerificationExampleScreen extends StatelessWidget {
  const S15ReconciliationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15ReconciliationVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.reconciliation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.countReconciliation,
      description: pdfLocalization.s15CountReconciliationVerify,
      apiName: 'buildS15ReconciliationVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15ReconciliationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_reconciliation.pdf',
    );
  }
}
