import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_wms_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S15 verification example for Batch Report.
class S15BatchReportVerificationExampleScreen extends StatelessWidget {
  const S15BatchReportVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15BatchReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.batchReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: 'Batch Report',
      description: 'Focused S15 verification for Batch Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS15BatchReportVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15BatchReportVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_wms_pack_batch_report.pdf',
    );
  }
}
