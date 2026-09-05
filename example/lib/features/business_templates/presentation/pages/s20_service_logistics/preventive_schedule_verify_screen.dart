import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_service_logistics_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S20 verification example for Preventive Schedule.
class S20PreventiveScheduleVerificationExampleScreen extends StatelessWidget {
  const S20PreventiveScheduleVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20PreventiveScheduleVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.preventiveSchedule,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: pdfLocalization.preventiveSchedule,
      description: pdfLocalization.s20PreventiveScheduleVerify,
      apiName: 'buildS20PreventiveScheduleVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20PreventiveScheduleVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_service_logistics_preventive_schedule.pdf',
    );
  }
}
