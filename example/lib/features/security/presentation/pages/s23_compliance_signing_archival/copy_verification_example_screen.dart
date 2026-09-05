import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/models/documents/s23_compliance_signing_archival_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S23 verification example for Copy.
class S23CopyVerificationExampleScreen extends StatelessWidget {
  const S23CopyVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS23CopyVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.copy,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S23 Compliance, Signing & Archival',
      title: pdfLocalization.copy,
      description: pdfLocalization.s23CopyVerify,
      apiName: 'buildS23CopyVerificationPdf',
      icon: Icons.verified_user_outlined,
      generator: buildS23CopyVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's23_compliance_signing_archival_copy.pdf',
    );
  }
}
