import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s18_manufacturing_quality_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S18 verification example for Production Variance.
class S18VarianceVerificationExampleScreen extends StatelessWidget {
  const S18VarianceVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS18VarianceVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.variance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S18 Manufacturing & Quality Pack',
      title: 'Production Variance',
      description: 'Focused S18 verification for Production Variance. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS18VarianceVerificationPdf',
      icon: Icons.precision_manufacturing_outlined,
      generator: buildS18VarianceVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's18_manufacturing_quality_pack_variance.pdf',
    );
  }
}
