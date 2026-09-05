import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S18 verification example for Labor Report.
class S18LaborVerificationExampleScreen extends StatelessWidget {
  const S18LaborVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18LaborVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.labor,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: 'Labor Report',
      description: 'Focused S18 verification for Labor Report. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS18LaborVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18LaborVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_labor.pdf',
    );
  }
}
