import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_mfg_quality_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Certificate of Analysis.
class S18CoaVerificationExampleScreen extends StatelessWidget {
  const S18CoaVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18CoaVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.coa,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.certificateOfAnalysis,
      description: pdfLocalization.s18CertificateAnalysisVerify,
      apiName: 'buildS18CoaVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18CoaVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_mfg_quality_coa.pdf',
    );
  }
}
