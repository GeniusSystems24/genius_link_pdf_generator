import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S11 verification example for A4 landscape.
class S11A4LandscapeVerificationExampleScreen extends StatelessWidget {
  const S11A4LandscapeVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11A4LandscapeVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.a4Landscape,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: 'A4 landscape',
      description: 'Focused S11 verification for A4 landscape. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS11A4LandscapeVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11A4LandscapeVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_a4_landscape.pdf',
    );
  }
}
