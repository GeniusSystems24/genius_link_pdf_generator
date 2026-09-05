import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_erp_document_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S08 verification example for Operational form.
class S08OperationalVerificationExampleScreen extends StatelessWidget {
  const S08OperationalVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08OperationalVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.operational,
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
      title: 'Operational form',
      description: 'Focused S08 verification for Operational form. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS08OperationalVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08OperationalVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_erp_document_families_operational.pdf',
    );
  }
}
