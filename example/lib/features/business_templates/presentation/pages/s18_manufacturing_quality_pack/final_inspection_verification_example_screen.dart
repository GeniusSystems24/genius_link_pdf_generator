import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S18 verification example for Final Inspection.
class S18FinalInspectionVerificationExampleScreen extends StatelessWidget {
  const S18FinalInspectionVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18FinalInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.finalInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: 'Final Inspection',
      description: 'Focused S18 verification for Final Inspection. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS18FinalInspectionVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18FinalInspectionVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_final_inspection.pdf',
    );
  }
}
