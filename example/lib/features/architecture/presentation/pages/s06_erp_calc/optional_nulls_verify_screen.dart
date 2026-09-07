import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/architecture_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Null Optional Metadata.
class S06OptionalNullsVerificationExampleScreen extends StatelessWidget {
  const S06OptionalNullsVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.nullOptionalMetadata,
      description: pdfLocalization.s06NullOptionalMetadataVerify,
      apiName: 'buildS06OptionalNullsVerificationPdf',
      icon: Icons.calculate_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateArchitectureVerificationInBackground(

          apiName: 'buildS06OptionalNullsVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's06_erp_calc_optional_nulls.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS06OptionalNullsVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.optionalNulls,
    kind: ErpDocumentKind.invoice,
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
