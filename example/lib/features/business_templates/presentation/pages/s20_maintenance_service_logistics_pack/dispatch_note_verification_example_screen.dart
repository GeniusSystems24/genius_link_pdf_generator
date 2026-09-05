import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_maintenance_service_logistics_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S20 verification example for Dispatch Note.
class S20DispatchNoteVerificationExampleScreen extends StatelessWidget {
  const S20DispatchNoteVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20DispatchNoteVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.dispatchNote,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: 'Dispatch Note',
      description: 'Focused S20 verification for Dispatch Note. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS20DispatchNoteVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20DispatchNoteVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_maintenance_service_logistics_pack_dispatch_note.pdf',
    );
  }
}
