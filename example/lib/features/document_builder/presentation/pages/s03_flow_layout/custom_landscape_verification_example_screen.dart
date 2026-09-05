import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S03 example for Custom Landscape Page.
class S03CustomLandscapeVerificationExampleScreen extends StatelessWidget {
  const S03CustomLandscapeVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: 'Custom Landscape Page',
      description: 'Focused S03 verification for Custom Landscape Page. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS03CustomLandscapeVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03CustomLandscapeVerificationPdf,
      fileName: 's03_flow_layout_custom_landscape.pdf',
      usageCode: r'''Future<Uint8List> buildS03CustomLandscapeVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.customLandscape,
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
