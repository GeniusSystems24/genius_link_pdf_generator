import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/s04_data_grid_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S04 example for Long Content / Overflow.
class S04LongContentVerificationExampleScreen extends StatelessWidget {
  const S04LongContentVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: 'Long Content / Overflow',
      description: 'Focused S04 verification for Long Content / Overflow. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS04LongContentVerificationPdf',
      icon: Icons.table_view_outlined,
      generator: buildS04LongContentVerificationPdf,
      fileName: 's04_data_grid_vnext_long_content.pdf',
      usageCode: r'''Future<Uint8List> buildS04LongContentVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S04DataGridVNextDocument(
    config: config,
    directionality: directionality,
    scenario: S04DataGridVNextScenario.longContent,
    preserveOrder: false,
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
