import 'package:flutter/material.dart';

import 'headers/invoice_header_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Headers example screen instead.')
class HeadersExampleScreen extends StatelessWidget {
  const HeadersExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const InvoiceHeaderExampleScreen();
}
