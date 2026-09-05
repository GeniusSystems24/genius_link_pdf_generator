import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s20_service_logistics_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S20 verification example for Proof of Delivery.
class S20ProofOfDeliveryVerificationExampleScreen extends StatelessWidget {
  const S20ProofOfDeliveryVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS20ProofOfDeliveryVerificationPdf(GeniusPdfConfig config) {
  final runner = S20MaintenanceServiceLogisticsPackRunner(
    baseConfig: config,
    scenario: S20MaintenanceServiceLogisticsPackScenario.proofOfDelivery,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S20 Maintenance, Service & Logistics Pack',
      title: pdfLocalization.proofOfDelivery,
      description: pdfLocalization.s20ProofDeliveryVerify,
      apiName: 'buildS20ProofOfDeliveryVerificationPdf',
      icon: Icons.local_shipping_outlined,
      generator: buildS20ProofOfDeliveryVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's20_service_logistics_proof_of_delivery.pdf',
    );
  }
}
