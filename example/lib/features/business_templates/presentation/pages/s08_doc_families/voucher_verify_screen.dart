import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s08_doc_families_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S08 verification example for Voucher family.
class S08VoucherVerificationExampleScreen extends StatelessWidget {
  const S08VoucherVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS08VoucherVerificationPdf(GeniusPdfConfig config) {
  final runner = S08ErpDocumentFamiliesRunner(
    baseConfig: config,
    scenario: S08ErpDocumentFamiliesScenario.voucher,
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
      title: pdfLocalization.voucherFamily,
      description: pdfLocalization.s08VoucherFamilyVerify,
      apiName: 'buildS08VoucherVerificationPdf',
      icon: Icons.account_tree_outlined,
      generator: buildS08VoucherVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's08_doc_families_voucher.pdf',
    );
  }
}
