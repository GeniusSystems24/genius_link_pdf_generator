import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_erp_document_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S08 verification example for Thermal receipt.
class S08ThermalVerificationExampleScreen extends StatelessWidget {
  const S08ThermalVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08ThermalVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.thermal,
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
      title: pdfLocalization.thermalReceipt,
      description: pdfLocalization.s08ThermalReceiptVerify,
      apiName: 'buildS08ThermalVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08ThermalVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_erp_document_families_thermal.pdf',
    );
  }
}
