import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_erp_document_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S08 verification example for Statement family.
class S08StatementVerificationExampleScreen extends StatelessWidget {
  const S08StatementVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08StatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.statement,
  );
  runner._direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S08 ERP Document Families',
      title: 'Statement family',
      description: 'Focused S08 verification for Statement family. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS08StatementVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08StatementVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_erp_document_families_statement.pdf',
    );
  }
}
