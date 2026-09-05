import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S11 verification example for Legal.
class S11LegalVerificationExampleScreen extends StatelessWidget {
  const S11LegalVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11LegalVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.legal,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: 'Legal',
      description: 'Focused S11 verification for Legal. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS11LegalVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11LegalVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_legal.pdf',
    );
  }
}
