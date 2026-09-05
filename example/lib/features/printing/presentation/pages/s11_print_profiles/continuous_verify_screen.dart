import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for Continuous paper.
class S11ContinuousVerificationExampleScreen extends StatelessWidget {
  const S11ContinuousVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11ContinuousVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.continuous,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.continuousPaper,
      description: pdfLocalization.s11ContinuousPaperVerify,
      apiName: 'buildS11ContinuousVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11ContinuousVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_continuous.pdf',
    );
  }
}
