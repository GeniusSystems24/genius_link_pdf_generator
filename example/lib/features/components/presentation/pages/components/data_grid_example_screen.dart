import 'package:flutter/material.dart';

import 'data_grid/invoice_footer_rows_example_screen.dart';

/// Backward-compatible entry point for the old Data Grid aggregate example.
///
/// Data Grid demonstrations now live in independent destinations. New code
/// should navigate to one of the focused screens under `components/data_grid/`.
@Deprecated('Use a focused DataGrid example screen instead.')
class DataGridExampleScreen extends StatelessWidget {
  const DataGridExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DataGridInvoiceFooterRowsExampleScreen();
  }
}
