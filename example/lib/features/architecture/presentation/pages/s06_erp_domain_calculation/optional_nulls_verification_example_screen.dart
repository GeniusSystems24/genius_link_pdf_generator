import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/s06_erp_domain_calculation_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S06 example for Null Optional Metadata.
class S06OptionalNullsVerificationExampleScreen extends StatelessWidget {
  const S06OptionalNullsVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: 'Null Optional Metadata',
      description: 'Focused S06 verification for Null Optional Metadata. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS06OptionalNullsVerificationPdf',
      icon: Icons.calculate_outlined,
      generator: buildS06OptionalNullsVerificationPdf,
      fileName: 's06_erp_domain_calculation_optional_nulls.pdf',
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
