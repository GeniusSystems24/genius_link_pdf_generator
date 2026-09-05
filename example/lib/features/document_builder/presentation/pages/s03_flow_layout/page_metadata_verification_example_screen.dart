import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S03 example for Page Metadata / Markers.
class S03PageMetadataVerificationExampleScreen extends StatelessWidget {
  const S03PageMetadataVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: pdfLocalization.pageMetadataMarkers,
      description: pdfLocalization.s03PageMetadataMarkersVerify,
      apiName: 'buildS03PageMetadataVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03PageMetadataVerificationPdf,
      fileName: 's03_flow_layout_page_metadata.pdf',
      usageCode: r'''Future<Uint8List> buildS03PageMetadataVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.pageMetadata,
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
