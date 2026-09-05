import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_service_logistics_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
      title: pdfLocalization.dispatchNote,
      description: pdfLocalization.s20DispatchNoteVerify,
      apiName: 'buildS20DispatchNoteVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20DispatchNoteVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_service_logistics_dispatch_note.pdf',
    );
  }
}
