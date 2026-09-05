import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_erp_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S12 verification example for Debit Note.
class S12DebitNoteVerificationExampleScreen extends StatelessWidget {
  const S12DebitNoteVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12DebitNoteVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.debitNote,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: pdfLocalization.debitNote,
      description: pdfLocalization.s12DebitNoteVerify,
      apiName: 'buildS12DebitNoteVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12DebitNoteVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_erp_pack_debit_note.pdf',
    );
  }
}
