import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s16_pos_retail_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S16 verification example for Shift Open.
class S16ShiftOpenVerificationExampleScreen extends StatelessWidget {
  const S16ShiftOpenVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS16ShiftOpenVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.shiftOpen,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S16 POS & Retail Pack',
      title: pdfLocalization.shiftOpen,
      description: pdfLocalization.s16ShiftOpenVerify,
      apiName: 'buildS16ShiftOpenVerificationPdf',
      icon: Icons.point_of_sale_outlined,
      generator: buildS16ShiftOpenVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's16_pos_retail_pack_shift_open.pdf',
    );
  }
}
