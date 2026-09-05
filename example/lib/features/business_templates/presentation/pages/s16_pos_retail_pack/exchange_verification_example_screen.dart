import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S16 verification example for Exchange Receipt.
class S16ExchangeVerificationExampleScreen extends StatelessWidget {
  const S16ExchangeVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16ExchangeVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.exchange,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: 'Exchange Receipt',
      description: 'Focused S16 verification for Exchange Receipt. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS16ExchangeVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16ExchangeVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_pack_exchange.pdf',
    );
  }
}
