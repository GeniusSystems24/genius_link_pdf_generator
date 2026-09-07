import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/architecture_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Document / Base Currency.
class S06MultiCurrencyVerificationExampleScreen extends StatelessWidget {
  const S06MultiCurrencyVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.documentBaseCurrency,
      description: pdfLocalization.s06DocumentBaseCurrencyVerify,
      apiName: 'buildS06MultiCurrencyVerificationPdf',
      icon: Icons.calculate_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateArchitectureVerificationInBackground(

          apiName: 'buildS06MultiCurrencyVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's06_erp_calc_multi_currency.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS06MultiCurrencyVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.multiCurrency,
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
