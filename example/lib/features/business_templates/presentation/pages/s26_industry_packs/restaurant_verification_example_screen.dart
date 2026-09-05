import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s26_industry_packs_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S26 verification example for Restaurant.
class S26RestaurantVerificationExampleScreen extends StatelessWidget {
  const S26RestaurantVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS26RestaurantVerificationPdf(GeniusPdfConfig config) {
  final runner = S26IndustryPacksRunner(
    baseConfig: config,
    scenario: S26IndustryPacksScenario.restaurant,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S26 Industry / Plugin Packs',
      title: 'Restaurant',
      description: 'Focused S26 verification for Restaurant. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS26RestaurantVerificationPdf',
      icon: Icons.extension_outlined,
      generator: buildS26RestaurantVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's26_industry_packs_restaurant.pdf',
    );
  }
}
