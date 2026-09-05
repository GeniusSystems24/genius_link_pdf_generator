import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S11 verification example for Pre-printed physical anchors.
class S11PrePrintedVerificationExampleScreen extends StatelessWidget {
  const S11PrePrintedVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11PrePrintedVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.prePrinted,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: pdfLocalization.prePrintedPhysicalAnchors,
      description: pdfLocalization.s11PrePrintedPhysicalAnchorsVerify,
      apiName: 'buildS11PrePrintedVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11PrePrintedVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_pre_printed.pdf',
    );
  }
}
