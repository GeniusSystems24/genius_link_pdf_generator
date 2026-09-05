import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/models/documents/s23_compliance_signing_archival_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S23 verification example for Original.
class S23OriginalVerificationExampleScreen extends StatelessWidget {
  const S23OriginalVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS23OriginalVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.original,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S23 Compliance, Signing & Archival',
      title: pdfLocalization.original,
      description: pdfLocalization.s23OriginalVerify,
      apiName: 'buildS23OriginalVerificationPdf',
      icon: Icons.verified_user_outlined,
      generator: buildS23OriginalVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's23_compliance_signing_archival_original.pdf',
    );
  }
}
