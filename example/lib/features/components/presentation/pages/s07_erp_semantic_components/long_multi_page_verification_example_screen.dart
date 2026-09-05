import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s07_erp_semantic_components_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S07 example for Long / Multi-page Semantics.
class S07LongMultiPageVerificationExampleScreen extends StatelessWidget {
  const S07LongMultiPageVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S07 ERP Semantic Components',
      title: 'Long / Multi-page Semantics',
      description: 'Focused S07 verification for Long / Multi-page Semantics. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS07LongMultiPageVerificationPdf',
      icon: Icons.view_module_outlined,
      generator: buildS07LongMultiPageVerificationPdf,
      fileName: 's07_erp_semantic_components_long_multi_page.pdf',
      usageCode: r'''Future<Uint8List> buildS07LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S07ErpSemanticComponentsDocument(
    config: config,
    directionality: directionality,
    scenario: S07ErpSemanticComponentsScenario.longMultiPage,
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
