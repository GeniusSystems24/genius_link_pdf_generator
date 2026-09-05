import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Auxiliary Vouchers Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class AuxiliaryVouchersExampleScreen extends StatelessWidget {
  const AuxiliaryVouchersExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing gift and inventory vouchers in a single batch.
List<int> buildAuxiliaryVoucherDemoReport({
  required GeniusPdfConfig config,
}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_auxiliary_vouchers',
      category: 'Showcase',
      title: 'Auxiliary Vouchers',
      apiName: 'buildAuxiliaryVoucherDemoReport',
      description: 'Gift, grant, and supporting inventory-operation voucher examples.',
      icon: Icons.card_giftcard_outlined,
      usageCode: dartUsageCode,
    );
  }
}
