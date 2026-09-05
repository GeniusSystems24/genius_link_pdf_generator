import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S16 verification example for Promotion Label.
class S16PromotionLabelVerificationExampleScreen extends StatelessWidget {
  const S16PromotionLabelVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16PromotionLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.promotionLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: pdfLocalization.promotionLabel,
      description: pdfLocalization.s16PromotionLabelVerify,
      apiName: 'buildS16PromotionLabelVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16PromotionLabelVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_promotion_label.pdf',
    );
  }
}
