import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s21_crm_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S21 verification example for Contract Summary.
class S21ContractVerificationExampleScreen extends StatelessWidget {
  const S21ContractVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS21ContractVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.contract,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S21 CRM Pack',
      title: pdfLocalization.contractSummary,
      description: pdfLocalization.s21ContractSummaryVerify,
      apiName: 'buildS21ContractVerificationPdf',
      icon: Icons.people_alt_outlined,
      generator: buildS21ContractVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's21_crm_pack_contract.pdf',
    );
  }
}
