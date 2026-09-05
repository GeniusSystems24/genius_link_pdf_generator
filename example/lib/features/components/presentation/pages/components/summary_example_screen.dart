import 'package:flutter/material.dart';

import 'summary/basic_invoice_summary_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Summary example screen instead.')
class SummaryExampleScreen extends StatelessWidget {
  const SummaryExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const BasicInvoiceSummaryExampleScreen();
}
