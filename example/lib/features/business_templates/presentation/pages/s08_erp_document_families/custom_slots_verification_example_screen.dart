import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_erp_document_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S08 verification example for Replacement / custom section.
class S08CustomSlotsVerificationExampleScreen extends StatelessWidget {
  const S08CustomSlotsVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08CustomSlotsVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.customSlots,
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
      title: 'Replacement / custom section',
      description: 'Focused S08 verification for Replacement / custom section. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS08CustomSlotsVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08CustomSlotsVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_erp_document_families_custom_slots.pdf',
    );
  }
}
