import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S16 verification example for Barcode Label.
class S16BarcodeLabelVerificationExampleScreen extends StatelessWidget {
  const S16BarcodeLabelVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16BarcodeLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.barcodeLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: pdfLocalization.barcodeLabel,
      description: pdfLocalization.s16BarcodeLabelVerify,
      apiName: 'buildS16BarcodeLabelVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16BarcodeLabelVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_barcode_label.pdf',
    );
  }
}
