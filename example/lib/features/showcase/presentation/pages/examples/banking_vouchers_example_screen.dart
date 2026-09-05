import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for the Banking Vouchers Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class BankingVouchersExampleScreen extends StatelessWidget {
  const BankingVouchersExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing 4 banking vouchers in a single batch.
List<int> buildBankingVoucherDemoReport({
  required GeniusPdfConfig config,
}''';

  @override
  Widget build(BuildContext context) {
    return  ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_banking_vouchers',
      category: 'Showcase',
      title: pdfLocalization.bankingVouchers,
      apiName: 'buildBankingVoucherDemoReport',
      description: pdfLocalization.bankDepositsWithdrawalsTransfersBillDesc,
      icon: Icons.account_balance_outlined,
      usageCode: dartUsageCode,
    );
  }
}
