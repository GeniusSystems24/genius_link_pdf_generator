import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S16 verification example for 58mm Receipt.
class S16Receipt58VerificationExampleScreen extends StatelessWidget {
  const S16Receipt58VerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16Receipt58VerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.receipt58,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: pdfLocalization.fiftyEightMmReceipt,
      description: pdfLocalization.s1658MmReceiptVerify,
      apiName: 'buildS16Receipt58VerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16Receipt58VerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_receipt58.pdf',
    );
  }
}
