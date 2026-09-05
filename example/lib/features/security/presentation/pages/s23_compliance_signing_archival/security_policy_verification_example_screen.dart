import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/models/documents/s23_compliance_signing_archival_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S23 verification example for Existing Security Adapter.
class S23SecurityPolicyVerificationExampleScreen extends StatelessWidget {
  const S23SecurityPolicyVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS23SecurityPolicyVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.securityPolicy,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S23 Compliance, Signing & Archival',
      title: pdfLocalization.existingSecurityAdapter,
      description: pdfLocalization.s23ExistingSecurityAdapterVerify,
      apiName: 'buildS23SecurityPolicyVerificationPdf',
      icon: Icons.verified_user_outlined,
      generator: buildS23SecurityPolicyVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's23_compliance_signing_archival_security_policy.pdf',
    );
  }
}
