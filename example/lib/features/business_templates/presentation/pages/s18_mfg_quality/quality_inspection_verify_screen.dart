import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_mfg_quality_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Quality Inspection.
class S18QualityInspectionVerificationExampleScreen extends StatelessWidget {
  const S18QualityInspectionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18QualityInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.qualityInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.qualityInspection,
      description: pdfLocalization.s18QualityInspectionVerify,
      apiName: 'buildS18QualityInspectionVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18QualityInspectionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_mfg_quality_quality_inspection.pdf',
    );
  }
}
