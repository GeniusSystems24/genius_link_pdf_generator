import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/s14_accounting_verification_documents.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S14 verification example for Multi-period Comparison.
class S14MultiPeriodVerificationExampleScreen extends StatelessWidget {
  const S14MultiPeriodVerificationExampleScreen({super.key});

  static const String dartUsageCode = r'''Future<Uint8List> buildS14MultiPeriodVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.multiPeriod,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return BusinessVerificationExampleDetailScreen(
      sprint: 'S14 Accounting & Finance Pack',
      title: pdfLocalization.multiPeriodComparison,
      description: pdfLocalization.s14MultiPeriodComparisonVerify,
      apiName: 'buildS14MultiPeriodVerificationPdf',
      icon: Icons.account_balance_outlined,
      generator: buildS14MultiPeriodVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's14_accounting_multi_period.pdf',
    );
  }
}
