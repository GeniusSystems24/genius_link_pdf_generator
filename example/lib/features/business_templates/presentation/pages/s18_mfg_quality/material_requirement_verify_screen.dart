import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_mfg_quality_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S18 verification example for Material Requirement.
class S18MaterialRequirementVerificationExampleScreen extends StatelessWidget {
  const S18MaterialRequirementVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18MaterialRequirementVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.materialRequirement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: pdfLocalization.materialRequirement,
      description: pdfLocalization.s18MaterialRequirementVerify,
      apiName: 'buildS18MaterialRequirementVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18MaterialRequirementVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_mfg_quality_material_requirement.pdf',
    );
  }
}
