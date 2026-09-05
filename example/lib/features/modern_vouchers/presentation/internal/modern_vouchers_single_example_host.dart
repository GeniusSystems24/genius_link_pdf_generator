// Compatibility dispatcher for the formerly shared Modern Vouchers host.
//
// Actual generation, PDF preview, and Dart usage code now live in the focused
// example screens under presentation/pages/examples.

import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/examples/sales_voucher_example_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/examples/purchase_voucher_example_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/examples/sales_return_example_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/examples/purchase_return_example_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/examples/b5_payment_example_screen.dart';

@Deprecated('Use one of the dedicated Modern Vouchers example screens.')
class ModernVouchersSingleExampleHost extends StatelessWidget {
  const ModernVouchersSingleExampleHost({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return switch (initialTab.clamp(0, 4)) {
      0 => const SalesVoucherExampleScreen(),
      1 => const PurchaseVoucherExampleScreen(),
      2 => const SalesReturnExampleScreen(),
      3 => const PurchaseReturnExampleScreen(),
      4 => const B5PaymentExampleScreen(),
      _ => const SalesVoucherExampleScreen(),
    };
  }
}
