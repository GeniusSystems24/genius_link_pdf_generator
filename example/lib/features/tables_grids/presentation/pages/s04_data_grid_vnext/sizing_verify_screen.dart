import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/tables_grids_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S04 example for Column Sizing.
class S04SizingVerificationExampleScreen extends StatelessWidget {
  const S04SizingVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: pdfLocalization.columnSizing,
      description: pdfLocalization.s04ColumnSizingVerify,
      apiName: 'buildS04SizingVerificationPdf',
      icon: Icons.table_view_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTablesGridsExampleInBackground(
        apiName: 'buildS04SizingVerificationPdf',
        isRtl: isRtl,
      ),
      fileName: 's04_data_grid_vnext_sizing.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS04SizingVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S04DataGridVNextDocument(
    config: config,
    directionality: directionality,
    scenario: S04DataGridVNextScenario.sizing,
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
