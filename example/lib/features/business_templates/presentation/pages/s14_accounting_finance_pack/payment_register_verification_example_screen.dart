import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_finance_pack_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

/// Dedicated S14 verification example for Payment Register.
class S14PaymentRegisterVerificationExampleScreen extends StatelessWidget {
  const S14PaymentRegisterVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14PaymentRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.paymentRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: 'Payment Register',
      description: 'Focused S14 verification for Payment Register. Generate this scenario independently, inspect the PDF output, and compare LTR and RTL without switching to another example.',
      apiName: 'buildS14PaymentRegisterVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14PaymentRegisterVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_finance_pack_payment_register.pdf',
    );
  }
}
