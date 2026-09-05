import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Calibration Record.
class S18CalibrationVerificationExampleScreen extends StatelessWidget {
  const S18CalibrationVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18CalibrationVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.calibration,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.calibrationRecord,
      description: pdfLocalization.s18CalibrationRecordVerify,
      apiName: 'buildS18CalibrationVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18CalibrationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_calibration.pdf',
    );
  }
}
