import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/text_typography/models/documents/text_typography_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S01 example for Media Preserve Policy.
class S01MediaPolicyVerificationExampleScreen extends StatelessWidget {
  const S01MediaPolicyVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S01 Directionality',
      title: pdfLocalization.mediaPreservePolicy,
      description: pdfLocalization.s01MediaPreservePolicyVerify,
      apiName: 'buildS01MediaPolicyVerificationPdf',
      icon: Icons.swap_horiz_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateTextTypographyVerificationInBackground(

          apiName: 'buildS01MediaPolicyVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's01_directionality_media_policy.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS01MediaPolicyVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S01DirectionalityScenario.mediaPolicy,
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
