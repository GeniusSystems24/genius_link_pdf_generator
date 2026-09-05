import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industry_packs_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S26 verification example for Retail.
class S26RetailVerificationExampleScreen extends StatelessWidget {
  const S26RetailVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26RetailVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.retail,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: 'Retail',
      description: 'Focused S26 verification for Retail. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS26RetailVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26RetailVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industry_packs_retail.pdf',
    );
  }
}
