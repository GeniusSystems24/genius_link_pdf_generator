import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/s04_data_grid_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S04 example for 1k-row Large-data Mode.
class S04LargeDataVerificationExampleScreen extends StatelessWidget {
  const S04LargeDataVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: '1k-row Large-data Mode',
      description: 'Focused S04 verification for 1k-row Large-data Mode. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS04LargeDataVerificationPdf',
      icon: Icons.table_view_outlined,
      generator: buildS04LargeDataVerificationPdf,
      fileName: 's04_data_grid_vnext_large_data.pdf',
      usageCode: r'''Future<Uint8List> buildS04LargeDataVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S04DataGridVNextDocument(
    config: config,
    directionality: directionality,
    scenario: S04DataGridVNextScenario.largeData,
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
