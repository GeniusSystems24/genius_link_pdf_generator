import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_maintenance_service_logistics_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S20 verification example for Spare Parts Usage.
class S20SparePartsVerificationExampleScreen extends StatelessWidget {
  const S20SparePartsVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20SparePartsVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.spareParts,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: pdfLocalization.sparePartsUsage,
      description: pdfLocalization.s20SparePartsUsageVerify,
      apiName: 'buildS20SparePartsVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20SparePartsVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_maintenance_service_logistics_pack_spare_parts.pdf',
    );
  }
}
