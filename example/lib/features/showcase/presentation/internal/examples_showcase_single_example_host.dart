import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/advanced_layout_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/position_tracking_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/multi_grid_summary_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/qr_attachments_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/report_composer_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/service_vouchers_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/banking_vouchers_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/remittance_vouchers_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/trade_vouchers_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/auxiliary_vouchers_example_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples/complete_demo_example_screen.dart';

/// Compatibility router for callers that still use an old Showcase tab index.
///
/// The actual examples are now completely split into dedicated screens. This
/// class contains no generation, preview, or example implementation logic.
@Deprecated('Use the dedicated Showcase example screens directly.')
class ExamplesShowcaseSingleExampleHost extends StatelessWidget {
  const ExamplesShowcaseSingleExampleHost({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return switch (initialTab.clamp(0, 10)) {
      0 => const AdvancedLayoutExampleScreen(),
      1 => const PositionTrackingExampleScreen(),
      2 => const MultiGridSummaryExampleScreen(),
      3 => const QrAttachmentsExampleScreen(),
      4 => const ReportComposerExampleScreen(),
      5 => const ServiceVouchersExampleScreen(),
      6 => const BankingVouchersExampleScreen(),
      7 => const RemittanceVouchersExampleScreen(),
      8 => const TradeVouchersExampleScreen(),
      9 => const AuxiliaryVouchersExampleScreen(),
      10 => const CompleteDemoExampleScreen(),
      _ => const AdvancedLayoutExampleScreen(),
    };
  }
}
