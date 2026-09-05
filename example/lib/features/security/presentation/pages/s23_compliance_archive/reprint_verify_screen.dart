import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/models/documents/s23_compliance_archive_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S23 verification example for Reprint.
class S23ReprintVerificationExampleScreen extends StatelessWidget {
  const S23ReprintVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS23ReprintVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.reprint,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S23 Compliance, Signing & Archival',
      title: pdfLocalization.reprint,
      description: pdfLocalization.s23ReprintVerify,
      apiName: 'buildS23ReprintVerificationPdf',
      icon: Icons.verified_user_outlined,
      generator: buildS23ReprintVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's23_compliance_archive_reprint.pdf',
    );
  }
}
