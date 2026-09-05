import 'package:flutter/material.dart';

import 'grid_qrcode/zatca_invoice_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Grid + QR Code example screen instead.')
class GridQrcodeExampleScreen extends StatelessWidget {
  const GridQrcodeExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const GridQrcodeZatcaInvoiceExampleScreen();
}
