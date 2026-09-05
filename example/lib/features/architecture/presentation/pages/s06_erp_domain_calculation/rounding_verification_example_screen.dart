import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/s06_erp_domain_calculation_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S06 example for Rounding Adjustment.
class S06RoundingVerificationExampleScreen extends StatelessWidget {
  const S06RoundingVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: 'Rounding Adjustment',
      description: 'Focused S06 verification for Rounding Adjustment. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS06RoundingVerificationPdf',
      icon: Icons.calculate_outlined,
      generator: buildS06RoundingVerificationPdf,
      fileName: 's06_erp_domain_calculation_rounding.pdf',
      usageCode: r'''Future<Uint8List> buildS06RoundingVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.rounding,
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
