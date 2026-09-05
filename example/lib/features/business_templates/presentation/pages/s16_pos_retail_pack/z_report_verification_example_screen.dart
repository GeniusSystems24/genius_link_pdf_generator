import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S16 verification example for Z Report.
class S16ZReportVerificationExampleScreen extends StatelessWidget {
  const S16ZReportVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16ZReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.zReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: pdfLocalization.zReport,
      description: pdfLocalization.s16ZReportVerify,
      apiName: 'buildS16ZReportVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16ZReportVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_pack_z_report.pdf',
    );
  }
}
