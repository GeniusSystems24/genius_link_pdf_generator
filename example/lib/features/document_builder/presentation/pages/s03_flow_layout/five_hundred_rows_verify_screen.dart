import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/document_builder/models/documents/s03_flow_layout_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S03 example for 500-row Stress.
class S03FiveHundredRowsVerificationExampleScreen extends StatelessWidget {
  const S03FiveHundredRowsVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S03 Flow Layout',
      title: pdfLocalization.fiveHundredRowStress,
      description: pdfLocalization.s03500RowStressVerify,
      apiName: 'buildS03FiveHundredRowsVerificationPdf',
      icon: Icons.view_stream_outlined,
      generator: buildS03FiveHundredRowsVerificationPdf,
      fileName: 's03_flow_layout_five_hundred_rows.pdf',
      usageCode: r'''Future<Uint8List> buildS03FiveHundredRowsVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S03FlowLayoutDocument(
    config: config,
    directionality: directionality,
    scenario: S03FlowLayoutScenario.fiveHundredRows,
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
