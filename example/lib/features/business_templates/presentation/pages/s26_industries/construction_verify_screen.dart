import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industries_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S26 verification example for Construction / Real Estate.
class S26ConstructionVerificationExampleScreen extends StatelessWidget {
  const S26ConstructionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26ConstructionVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.construction,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: pdfLocalization.constructionRealEstate,
      description: pdfLocalization.s26ConstructionRealEstateVerify,
      apiName: 'buildS26ConstructionVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26ConstructionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industries_construction.pdf',
    );
  }
}
