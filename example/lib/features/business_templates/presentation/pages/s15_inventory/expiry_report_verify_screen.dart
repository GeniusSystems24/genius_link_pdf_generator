import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Expiry Report.
class S15ExpiryReportVerificationExampleScreen extends StatelessWidget {
  const S15ExpiryReportVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15ExpiryReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.expiryReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.expiryReport,
      description: pdfLocalization.s15ExpiryReportVerify,
      apiName: 'buildS15ExpiryReportVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15ExpiryReportVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_expiry_report.pdf',
    );
  }
}
