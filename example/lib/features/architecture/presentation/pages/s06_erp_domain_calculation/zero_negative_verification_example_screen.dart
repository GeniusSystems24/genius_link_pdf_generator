import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/s06_erp_domain_calculation_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Zero / Negative Policy.
class S06ZeroNegativeVerificationExampleScreen extends StatelessWidget {
  const S06ZeroNegativeVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.zeroNegativePolicy,
      description: pdfLocalization.s06ZeroNegativePolicyVerify,
      apiName: 'buildS06ZeroNegativeVerificationPdf',
      icon: Icons.calculate_outlined,
      generator: buildS06ZeroNegativeVerificationPdf,
      fileName: 's06_erp_domain_calculation_zero_negative.pdf',
      usageCode: r'''Future<Uint8List> buildS06ZeroNegativeVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.zeroNegative,
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
