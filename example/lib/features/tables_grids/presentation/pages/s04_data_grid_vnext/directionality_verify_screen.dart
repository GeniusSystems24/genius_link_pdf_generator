import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/s04_data_grid_vnext_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S04 example for RTL / Per-column Direction.
class S04DirectionalityVerificationExampleScreen extends StatelessWidget {
  const S04DirectionalityVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: pdfLocalization.rtlPerColumnDirection,
      description: pdfLocalization.s04RtlPerColumnDirectionVerify,
      apiName: 'buildS04DirectionalityVerificationPdf',
      icon: Icons.table_view_outlined,
      generator: buildS04DirectionalityVerificationPdf,
      fileName: 's04_data_grid_vnext_directionality.pdf',
      usageCode: r'''Future<Uint8List> buildS04DirectionalityVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S04DataGridVNextDocument(
    config: config,
    directionality: directionality,
    scenario: S04DataGridVNextScenario.directionality,
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
