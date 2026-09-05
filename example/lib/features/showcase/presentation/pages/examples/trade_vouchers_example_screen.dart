import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Trade Vouchers Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class TradeVouchersExampleScreen extends StatelessWidget {
  const TradeVouchersExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing 4 trade vouchers in a single batch.
List<int> buildTradeVoucherDemoReport({
  required GeniusPdfConfig config,
}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_trade_vouchers',
      category: 'Showcase',
      title: 'Trade Vouchers',
      apiName: 'buildTradeVoucherDemoReport',
      description: 'Purchase, sales, purchase-return, and sales-return vouchers in one PDF.',
      icon: Icons.storefront_outlined,
      usageCode: dartUsageCode,
    );
  }
}
