import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_maintenance_service_logistics_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S20 verification example for Freight Summary.
class S20FreightSummaryVerificationExampleScreen extends StatelessWidget {
  const S20FreightSummaryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20FreightSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.freightSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: 'Freight Summary',
      description: 'Focused S20 verification for Freight Summary. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS20FreightSummaryVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20FreightSummaryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_maintenance_service_logistics_pack_freight_summary.pdf',
    );
  }
}
