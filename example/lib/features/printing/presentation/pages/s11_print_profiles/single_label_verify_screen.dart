import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for Single label.
class S11SingleLabelVerificationExampleScreen extends StatelessWidget {
  const S11SingleLabelVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11SingleLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.singleLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.singleLabel,
      description: pdfLocalization.s11SingleLabelVerify,
      apiName: 'buildS11SingleLabelVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11SingleLabelVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_single_label.pdf',
    );
  }
}
