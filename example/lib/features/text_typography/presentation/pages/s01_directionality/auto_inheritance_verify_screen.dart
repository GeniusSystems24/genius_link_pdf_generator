import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/text_typography/models/documents/text_typography_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S01 example for AUTO Inheritance.
class S01AutoInheritanceVerificationExampleScreen extends StatelessWidget {
  const S01AutoInheritanceVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S01 Directionality',
      title: pdfLocalization.autoInheritance,
      description: pdfLocalization.s01AutoInheritanceVerify,
      apiName: 'buildS01AutoInheritanceVerificationPdf',
      icon: Icons.swap_horiz_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateTextTypographyVerificationInBackground(

          apiName: 'buildS01AutoInheritanceVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's01_directionality_auto_inheritance.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS01AutoInheritanceVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S01DirectionalityScenario.autoInheritance,
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
