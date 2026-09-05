import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s14_accounting_finance_pack/general_ledger_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S14 Accounting & Finance Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S14 verification example screens.')
class S14AccountingFinancePackVerificationPage extends StatelessWidget {
  const S14AccountingFinancePackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S14GeneralLedgerVerificationExampleScreen();
}
