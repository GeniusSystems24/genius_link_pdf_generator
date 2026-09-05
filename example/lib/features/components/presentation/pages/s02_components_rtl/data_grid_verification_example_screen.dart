import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/s02_components_rtl_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S02 example for Data Grid RTL.
class S02DataGridVerificationExampleScreen extends StatelessWidget {
  const S02DataGridVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S02 Components RTL',
      title: 'Data Grid RTL',
      description: 'Focused S02 verification for Data Grid RTL. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS02DataGridVerificationPdf',
      icon: Icons.compare_arrows_outlined,
      generator: buildS02DataGridVerificationPdf,
      fileName: 's02_components_rtl_data_grid.pdf',
      usageCode: r'''Future<Uint8List> buildS02DataGridVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S02ComponentsRtlDocument(
    config: config,
    directionality: directionality,
    scenario: S02ComponentsRtlScenario.dataGrid,
    showOptional: false,
    preserveGridOrder: false,
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
