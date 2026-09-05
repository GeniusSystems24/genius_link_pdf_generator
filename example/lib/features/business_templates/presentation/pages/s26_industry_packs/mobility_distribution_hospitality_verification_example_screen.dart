import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industry_packs_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S26 verification example for Automotive / Distribution / Hospitality.
class S26MobilityDistributionHospitalityVerificationExampleScreen extends StatelessWidget {
  const S26MobilityDistributionHospitalityVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26MobilityDistributionHospitalityVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.mobilityDistributionHospitality,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: pdfLocalization.automotiveDistributionHospitality,
      description: pdfLocalization.s26AutomotiveDistributionVerify,
      apiName: 'buildS26MobilityDistributionHospitalityVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26MobilityDistributionHospitalityVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industry_packs_mobility_distribution_hospitality.pdf',
    );
  }
}
