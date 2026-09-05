import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s02_components_rtl_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S02 example for Rich Text RTL.
class S02RichTextVerificationExampleScreen extends StatelessWidget {
  const S02RichTextVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S02 Components RTL',
      title: 'Rich Text RTL',
      description: 'Focused S02 verification for Rich Text RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS02RichTextVerificationPdf',
      icon: Icons.compare_arrows_outlined,
      generator: buildS02RichTextVerificationPdf,
      fileName: 's02_components_rtl_rich_text.pdf',
      usageCode: r'''Future<Uint8List> buildS02RichTextVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S02ComponentsRtlDocument(
    config: config,
    directionality: directionality,
    scenario: S02ComponentsRtlScenario.richText,
    showOptional: false,
    preserveGridOrder: false,
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
