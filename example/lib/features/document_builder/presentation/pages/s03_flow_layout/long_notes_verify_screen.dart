import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S03 example for Long Notes + Orphan/Widow.
class S03LongNotesVerificationExampleScreen extends StatelessWidget {
  const S03LongNotesVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: pdfLocalization.longNotesPlusOrphanWidow,
      description: pdfLocalization.s03LongNotesOrphanWidowVerify,
      apiName: 'buildS03LongNotesVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03LongNotesVerificationPdf,
      fileName: 's03_flow_layout_long_notes.pdf',
      usageCode: r'''Future<Uint8List> buildS03LongNotesVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.longNotes,
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
