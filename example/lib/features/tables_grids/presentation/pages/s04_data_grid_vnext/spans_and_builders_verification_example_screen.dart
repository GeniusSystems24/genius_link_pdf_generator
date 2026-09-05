import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/s04_data_grid_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S04 example for Spans / Builders / Conditional Style.
class S04SpansAndBuildersVerificationExampleScreen extends StatelessWidget {
  const S04SpansAndBuildersVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: 'Spans / Builders / Conditional Style',
      description: 'Focused S04 verification for Spans / Builders / Conditional Style. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS04SpansAndBuildersVerificationPdf',
      icon: Icons.table_view_outlined,
      generator: buildS04SpansAndBuildersVerificationPdf,
      fileName: 's04_data_grid_vnext_spans_and_builders.pdf',
      usageCode: r'''Future<Uint8List> buildS04SpansAndBuildersVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S04DataGridVNextDocument(
    config: config,
    directionality: directionality,
    scenario: S04DataGridVNextScenario.spansAndBuilders,
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
