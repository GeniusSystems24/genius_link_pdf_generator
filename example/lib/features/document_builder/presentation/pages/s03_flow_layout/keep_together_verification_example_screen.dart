import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S03 example for Keep Together / Keep With Next.
class S03KeepTogetherVerificationExampleScreen extends StatelessWidget {
  const S03KeepTogetherVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: 'Keep Together / Keep With Next',
      description: 'Focused S03 verification for Keep Together / Keep With Next. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS03KeepTogetherVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03KeepTogetherVerificationPdf,
      fileName: 's03_flow_layout_keep_together.pdf',
      usageCode: r'''Future<Uint8List> buildS03KeepTogetherVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.keepTogether,
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
