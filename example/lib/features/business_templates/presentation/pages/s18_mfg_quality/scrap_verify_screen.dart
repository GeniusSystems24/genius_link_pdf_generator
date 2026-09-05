import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_mfg_quality_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Scrap Report.
class S18ScrapVerificationExampleScreen extends StatelessWidget {
  const S18ScrapVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18ScrapVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.scrap,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.scrapReport,
      description: pdfLocalization.s18ScrapReportVerify,
      apiName: 'buildS18ScrapVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18ScrapVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_mfg_quality_scrap.pdf',
    );
  }
}
