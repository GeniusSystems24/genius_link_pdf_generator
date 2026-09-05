import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s15_inventory/stock_receipt_verify_screen.dart';

/// Compatibility entry point for the former aggregate S15 Inventory & WMS Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S15 verification example screens.')
class S15InventoryWmsPackVerificationPage extends StatelessWidget {
  const S15InventoryWmsPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S15StockReceiptVerificationExampleScreen();
}
