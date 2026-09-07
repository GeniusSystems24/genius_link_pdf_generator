import 'package:flutter/material.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/features/printing/models/documents/printing_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for 80mm thermal.
class S11Thermal80VerificationExampleScreen extends StatelessWidget {
  const S11Thermal80VerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11Thermal80VerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.thermal80,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.eightyMmThermal,
      description: pdfLocalization.s1180MmThermalVerify,
      apiName: 'buildS11Thermal80VerificationPdf',
      icon: Icons.settings_applications_outlined,
      backgroundGenerator: ({required bool isRtl}) =>
          generatePrintingVerificationInBackground(
            apiName: 'buildS11Thermal80VerificationPdf',
            isRtl: isRtl,
            rootConfig: geniusPdfConfig,
          ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_thermal80.pdf',
    );
  }
}
