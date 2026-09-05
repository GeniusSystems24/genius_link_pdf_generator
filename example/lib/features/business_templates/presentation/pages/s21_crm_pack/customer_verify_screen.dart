import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S21 verification example for Customer Profile.
class S21CustomerVerificationExampleScreen extends StatelessWidget {
  const S21CustomerVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21CustomerVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.customer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: pdfLocalization.customerProfile,
      description: pdfLocalization.s21CustomerProfileVerify,
      apiName: 'buildS21CustomerVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21CustomerVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_customer.pdf',
    );
  }
}
