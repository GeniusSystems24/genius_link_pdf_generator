import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/models/documents/s23_compliance_signing_archival_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S23 verification example for Archive / Audit Metadata.
class S23ArchiveMetadataVerificationExampleScreen extends StatelessWidget {
  const S23ArchiveMetadataVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS23ArchiveMetadataVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.archiveMetadata,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S23 Compliance, Signing & Archival',
      title: pdfLocalization.archiveAuditMetadata,
      description: pdfLocalization.s23ArchiveAuditMetadataVerify,
      apiName: 'buildS23ArchiveMetadataVerificationPdf',
      icon: Icons.verified_user_outlined,
      generator: buildS23ArchiveMetadataVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's23_compliance_signing_archival_archive_metadata.pdf',
    );
  }
}
