import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/architecture_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Long / Multi-page Domain.
class S06LongMultiPageVerificationExampleScreen extends StatelessWidget {
  const S06LongMultiPageVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.longMultiPageDomain,
      description: pdfLocalization.s06LongMultiPageDomainVerify,
      apiName: 'buildS06LongMultiPageVerificationPdf',
      icon: Icons.calculate_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateArchitectureVerificationInBackground(

          apiName: 'buildS06LongMultiPageVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's06_erp_calc_long_multi_page.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS06LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.longMultiPage,
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
