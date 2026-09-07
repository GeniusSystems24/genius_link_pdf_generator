import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/architecture_verification_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Discount After Tax.
class S06AfterTaxDiscountVerificationExampleScreen extends StatelessWidget {
  const S06AfterTaxDiscountVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.discountAfterTax,
      description: pdfLocalization.s06DiscountAfterTaxVerify,
      apiName: 'buildS06AfterTaxDiscountVerificationPdf',
      icon: Icons.calculate_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateArchitectureVerificationInBackground(

          apiName: 'buildS06AfterTaxDiscountVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's06_erp_calc_after_tax_discount.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS06AfterTaxDiscountVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.afterTaxDiscount,
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
