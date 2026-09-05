import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_maintenance_service_logistics_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S20 verification example for Calibration / Service History.
class S20ServiceHistoryVerificationExampleScreen extends StatelessWidget {
  const S20ServiceHistoryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20ServiceHistoryVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.serviceHistory,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: pdfLocalization.calibrationServiceHistory,
      description: pdfLocalization.s20CalibrationServiceHistoryVerify,
      apiName: 'buildS20ServiceHistoryVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20ServiceHistoryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_maintenance_service_logistics_pack_service_history.pdf',
    );
  }
}
