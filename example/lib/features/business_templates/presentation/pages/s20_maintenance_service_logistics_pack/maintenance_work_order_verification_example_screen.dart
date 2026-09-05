import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_maintenance_service_logistics_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S20 verification example for Maintenance Work Order.
class S20MaintenanceWorkOrderVerificationExampleScreen extends StatelessWidget {
  const S20MaintenanceWorkOrderVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20MaintenanceWorkOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.maintenanceWorkOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: pdfLocalization.maintenanceWorkOrder,
      description: pdfLocalization.s20MaintenanceWorkOrderVerify,
      apiName: 'buildS20MaintenanceWorkOrderVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20MaintenanceWorkOrderVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_maintenance_service_logistics_pack_maintenance_work_order.pdf',
    );
  }
}
