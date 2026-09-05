import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S03 example for 50 Rows / Multi-page.
class S03FiftyRowsVerificationExampleScreen extends StatelessWidget {
  const S03FiftyRowsVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: '50 Rows / Multi-page',
      description: 'Focused S03 verification for 50 Rows / Multi-page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS03FiftyRowsVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03FiftyRowsVerificationPdf,
      fileName: 's03_flow_layout_fifty_rows.pdf',
      usageCode: r'''Future<Uint8List> buildS03FiftyRowsVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.fiftyRows,
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
