import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S16 verification example for Cash Drawer.
class S16CashDrawerVerificationExampleScreen extends StatelessWidget {
  const S16CashDrawerVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16CashDrawerVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.cashDrawer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: 'Cash Drawer',
      description: 'Focused S16 verification for Cash Drawer. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS16CashDrawerVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16CashDrawerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_pack_cash_drawer.pdf',
    );
  }
}
