import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s07_erp_semantic_components_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S07 example for Null Collapse / No Gap.
class S07NullCollapseVerificationExampleScreen extends StatelessWidget {
  const S07NullCollapseVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S07 ERP Semantic Components',
      title: pdfLocalization.nullCollapseNoGap,
      description: pdfLocalization.s07NullCollapseNoGapVerify,
      apiName: 'buildS07NullCollapseVerificationPdf',
      icon: Icons.view_module_outlined,
      generator: buildS07NullCollapseVerificationPdf,
      fileName: 's07_erp_semantic_components_null_collapse.pdf',
      usageCode: r'''Future<Uint8List> buildS07NullCollapseVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S07ErpSemanticComponentsDocument(
    config: config,
    directionality: directionality,
    scenario: S07ErpSemanticComponentsScenario.nullCollapse,
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
