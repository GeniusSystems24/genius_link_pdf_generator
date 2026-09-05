import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/s06_erp_calc_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Discount Before Tax.
class S06BeforeTaxDiscountVerificationExampleScreen extends StatelessWidget {
  const S06BeforeTaxDiscountVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.discountBeforeTax,
      description: pdfLocalization.s06DiscountBeforeTaxVerify,
      apiName: 'buildS06BeforeTaxDiscountVerificationPdf',
      icon: Icons.calculate_outlined,
      generator: buildS06BeforeTaxDiscountVerificationPdf,
      fileName: 's06_erp_calc_before_tax_discount.pdf',
      usageCode: r'''Future<Uint8List> buildS06BeforeTaxDiscountVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.beforeTaxDiscount,
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
