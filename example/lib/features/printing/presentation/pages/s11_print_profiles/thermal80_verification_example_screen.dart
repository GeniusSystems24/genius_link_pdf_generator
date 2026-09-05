import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

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
      title: '80mm thermal',
      description: 'Focused S11 verification for 80mm thermal. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS11Thermal80VerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11Thermal80VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_thermal80.pdf',
    );
  }
}
