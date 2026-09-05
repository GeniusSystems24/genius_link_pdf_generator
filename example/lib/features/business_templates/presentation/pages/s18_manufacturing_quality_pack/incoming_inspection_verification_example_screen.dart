import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Incoming Inspection.
class S18IncomingInspectionVerificationExampleScreen extends StatelessWidget {
  const S18IncomingInspectionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18IncomingInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.incomingInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.incomingInspection,
      description: pdfLocalization.s18IncomingInspectionVerify,
      apiName: 'buildS18IncomingInspectionVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18IncomingInspectionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_incoming_inspection.pdf',
    );
  }
}
