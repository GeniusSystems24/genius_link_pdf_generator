import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s07_erp_components_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S07 example for Reusable Composition.
class S07CompositionVerificationExampleScreen extends StatelessWidget {
  const S07CompositionVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S07 ERP Semantic Components',
      title: pdfLocalization.reusableComposition,
      description: pdfLocalization.s07ReusableCompositionVerify,
      apiName: 'buildS07CompositionVerificationPdf',
      icon: Icons.view_module_outlined,
      generator: buildS07CompositionVerificationPdf,
      fileName: 's07_erp_components_composition.pdf',
      usageCode: r'''Future<Uint8List> buildS07CompositionVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S07ErpSemanticComponentsDocument(
    config: config,
    directionality: directionality,
    scenario: S07ErpSemanticComponentsScenario.composition,
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
