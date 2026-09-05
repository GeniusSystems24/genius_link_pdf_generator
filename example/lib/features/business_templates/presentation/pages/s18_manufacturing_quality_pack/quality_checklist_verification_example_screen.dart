import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S18 verification example for Quality Checklist.
class S18QualityChecklistVerificationExampleScreen extends StatelessWidget {
  const S18QualityChecklistVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18QualityChecklistVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.qualityChecklist,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: 'Quality Checklist',
      description: 'Focused S18 verification for Quality Checklist. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS18QualityChecklistVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18QualityChecklistVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_quality_checklist.pdf',
    );
  }
}
