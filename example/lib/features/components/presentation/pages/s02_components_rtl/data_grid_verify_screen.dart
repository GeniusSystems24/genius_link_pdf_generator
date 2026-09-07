import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/components_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S02 example for Data Grid RTL.
class S02DataGridVerificationExampleScreen extends StatelessWidget {
  const S02DataGridVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S02 Components RTL',
      title: pdfLocalization.dataGridRtl,
      description: pdfLocalization.s02DataGridRtlVerify,
      apiName: 'buildS02DataGridVerificationPdf',
      icon: Icons.compare_arrows_outlined,
      backgroundGenerator: ({required bool isRtl}) =>
          generateComponentsVerificationInBackground(
            apiName: 'buildS02DataGridVerificationPdf',
            isRtl: isRtl,
          ),
      showGenerationToast: true,
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
