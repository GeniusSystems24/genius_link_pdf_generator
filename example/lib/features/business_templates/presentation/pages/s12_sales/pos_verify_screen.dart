import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s12_sales_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S12 verification example for Simplified / POS Invoice.
class S12PosVerificationExampleScreen extends StatelessWidget {
  const S12PosVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS12PosVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.pos,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S12 Sales ERP Pack',
      title: pdfLocalization.simplifiedPosInvoice,
      description: pdfLocalization.s12SimplifiedPosInvoiceVerify,
      apiName: 'buildS12PosVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS12PosVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's12_sales_pos.pdf',
    );
  }
}
