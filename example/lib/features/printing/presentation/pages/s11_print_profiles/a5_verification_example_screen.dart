import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for A5.
class S11A5VerificationExampleScreen extends StatelessWidget {
  const S11A5VerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11A5VerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.a5,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.a5,
      description: pdfLocalization.s115Verify,
      apiName: 'buildS11A5VerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11A5VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_a5.pdf',
    );
  }
}
