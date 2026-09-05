import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_doc_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S08 verification example for Long multi-page transaction.
class S08LongMultiPageVerificationExampleScreen extends StatelessWidget {
  const S08LongMultiPageVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08LongMultiPageVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.longMultiPage,
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
      title: pdfLocalization.longMultiPageTransaction,
      description: pdfLocalization.s08LongMultiPageTransactionVerify,
      apiName: 'buildS08LongMultiPageVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08LongMultiPageVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_doc_families_long_multi_page.pdf',
    );
  }
}
