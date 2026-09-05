import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for Calibration page.
class S11CalibrationVerificationExampleScreen extends StatelessWidget {
  const S11CalibrationVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11CalibrationVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.calibration,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.calibrationPage,
      description: pdfLocalization.s11CalibrationPageVerify,
      apiName: 'buildS11CalibrationVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11CalibrationVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_calibration.pdf',
    );
  }
}
