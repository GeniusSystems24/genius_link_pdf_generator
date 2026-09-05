import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/models/documents/s06_erp_domain_calculation_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S06 example for Paid / Due.
class S06PaidDueVerificationExampleScreen extends StatelessWidget {
  const S06PaidDueVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S06 ERP Domain & Calculations',
      title: pdfLocalization.paidDue,
      description: pdfLocalization.s06PaidDueVerify,
      apiName: 'buildS06PaidDueVerificationPdf',
      icon: Icons.calculate_outlined,
      generator: buildS06PaidDueVerificationPdf,
      fileName: 's06_erp_domain_calculation_paid_due.pdf',
      usageCode: r'''Future<Uint8List> buildS06PaidDueVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S06ErpDomainCalculationDocument(
    config: config,
    directionality: directionality,
    scenario: S06ErpDomainCalculationScenario.paidDue,
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
