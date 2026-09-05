import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s15_inventory_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S15 verification example for Stock Availability.
class S15AvailabilityVerificationExampleScreen extends StatelessWidget {
  const S15AvailabilityVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS15AvailabilityVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.availability,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S15 Inventory & WMS Pack',
      title: pdfLocalization.stockAvailability,
      description: pdfLocalization.s15StockAvailabilityVerify,
      apiName: 'buildS15AvailabilityVerificationPdf',
      icon: Icons.inventory_2_outlined,
      generator: buildS15AvailabilityVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's15_inventory_availability.pdf',
    );
  }
}
