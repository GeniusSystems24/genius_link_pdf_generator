import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/text_typography/models/documents/s01_directionality_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S01 example for Legacy Template JSON.
class S01LegacyTemplateJsonVerificationExampleScreen extends StatelessWidget {
  const S01LegacyTemplateJsonVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S01 Directionality',
      title: pdfLocalization.legacyTemplateJson,
      description: pdfLocalization.s01LegacyTemplateJsonVerify,
      apiName: 'buildS01LegacyTemplateJsonVerificationPdf',
      icon: Icons.swap_horiz_outlined,
      generator: buildS01LegacyTemplateJsonVerificationPdf,
      fileName: 's01_directionality_legacy_template_json.pdf',
      usageCode: r'''Future<Uint8List> buildS01LegacyTemplateJsonVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.legacyTemplateJson,
    valueKind: GeniusPdfValueKind.money,
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
