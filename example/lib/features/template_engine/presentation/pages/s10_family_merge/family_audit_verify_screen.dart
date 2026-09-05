import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s10_family_merge_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S10 verification example for Template Family Audit.
class S10FamilyAuditVerificationExampleScreen extends StatelessWidget {
  const S10FamilyAuditVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS10FamilyAuditVerificationPdf(GeniusPdfConfig config) async {
  final document = S10FamilyAuditDocument(config);
  try {
    return Uint8List.fromList(document.generate());
  } finally {
    document.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S10 Template Family Consolidation',
      title: pdfLocalization.templateFamilyAudit,
      description: pdfLocalization.s10TemplateFamilyAuditVerify,
      apiName: 'buildS10FamilyAuditVerificationPdf',
      icon: Icons.hub_outlined,
      generator: buildS10FamilyAuditVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's10_family_merge_family_audit.pdf',
    );
  }
}
