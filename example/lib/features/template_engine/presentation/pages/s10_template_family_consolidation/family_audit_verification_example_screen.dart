import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/template_engine/models/documents/s10_template_family_consolidation_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

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
      title: 'Template Family Audit',
      description: 'Focused S10 verification for Template Family Audit. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS10FamilyAuditVerificationPdf',
      icon: Icons.hub_outlined,
      generator: buildS10FamilyAuditVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's10_template_family_consolidation_family_audit.pdf',
    );
  }
}
