import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Service Vouchers Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class ServiceVouchersExampleScreen extends StatelessWidget {
  const ServiceVouchersExampleScreen({super.key});

  static const String dartUsageCode = r'''/// Builds a multi-page voucher demo PDF showcasing all v3.0.0 voucher types.
///
/// Generates 5 vouchers in a single PDF:
/// 1. Simple Accounting Entry
/// 2. Cash Receipt Voucher
/// 3. Bank Transfer Payment Voucher
/// 4. VAT Voucher
/// 5. Check Receipt Voucher
///
/// Uses [GeniusPdfVoucherBatch] to combine them into one document.
List<int> buildVoucherDemoReport({required GeniusPdfConfig config}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_service_vouchers',
      category: 'Showcase',
      title: 'Service Vouchers',
      apiName: 'buildVoucherDemoReport',
      description: 'Accounting entries, receipts, payments, tax vouchers, and check receipts in one batch.',
      icon: Icons.receipt_long_outlined,
      usageCode: dartUsageCode,
    );
  }
}
