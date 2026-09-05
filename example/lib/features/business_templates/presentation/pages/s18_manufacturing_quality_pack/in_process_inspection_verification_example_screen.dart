import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for In-process Inspection.
class S18InProcessInspectionVerificationExampleScreen extends StatelessWidget {
  const S18InProcessInspectionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18InProcessInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.inProcessInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.inProcessInspection,
      description: pdfLocalization.s18ProcessInspectionVerify,
      apiName: 'buildS18InProcessInspectionVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18InProcessInspectionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_in_process_inspection.pdf',
    );
  }
}
