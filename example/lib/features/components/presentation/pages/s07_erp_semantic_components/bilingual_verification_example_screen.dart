import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s07_erp_semantic_components_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S07 example for Bilingual Mixed Values.
class S07BilingualVerificationExampleScreen extends StatelessWidget {
  const S07BilingualVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S07 ERP Semantic Components',
      title: pdfLocalization.bilingualMixedValues,
      description: pdfLocalization.s07BilingualMixedValuesVerify,
      apiName: 'buildS07BilingualVerificationPdf',
      icon: Icons.view_module_outlined,
      generator: buildS07BilingualVerificationPdf,
      fileName: 's07_erp_semantic_components_bilingual.pdf',
      usageCode: r'''Future<Uint8List> buildS07BilingualVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S07ErpSemanticComponentsDocument(
    config: config,
    directionality: directionality,
    scenario: S07ErpSemanticComponentsScenario.bilingual,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}''',
    );
  }
}
