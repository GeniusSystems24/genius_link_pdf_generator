import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/internal/modern_vouchers_single_example_host.dart';

/// Compatibility entry point for the former multi-example Modern Vouchers screen.
///
/// The example application now exposes every example as a dedicated navigation
/// destination. [initialTab] is retained only for existing callers and selects
/// one focused example; no tab bar or multi-example page is rendered.
@Deprecated('Use one of the dedicated Modern Vouchers example screens.')
class ModernVouchersDemoScreen extends StatelessWidget {
  const ModernVouchersDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return ModernVouchersSingleExampleHost(initialTab: initialTab);
  }
}
