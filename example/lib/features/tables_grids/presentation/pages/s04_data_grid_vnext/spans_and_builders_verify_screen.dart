import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/tables_grids/models/documents/tables_grids_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S04 example for Spans / Builders / Conditional Style.
class S04SpansAndBuildersVerificationExampleScreen extends StatelessWidget {
  const S04SpansAndBuildersVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S04 DataGrid vNext',
      title: pdfLocalization.spansBuildersConditionalStyle,
      description: pdfLocalization.s04SpansBuildersConditionalStyleVerify,
      apiName: 'buildS04SpansAndBuildersVerificationPdf',
      icon: Icons.table_view_outlined,
      backgroundGenerator: ({required bool isRtl}) => generateTablesGridsExampleInBackground(
        apiName: 'buildS04SpansAndBuildersVerificationPdf',
        isRtl: isRtl,
      ),
      fileName: 's04_data_grid_vnext_spans_and_builders.pdf',
      showGenerationToast: true,
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
