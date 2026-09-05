import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated PDF-preview example for **Modern Sales Voucher**.
///
/// The document is generated only after the user presses **Run example**.
/// `dartUsageCode` contains the exact function wired to [generator].
class SalesVoucherExampleScreen extends StatelessWidget {
  const SalesVoucherExampleScreen({super.key});

  /// Exact source of [generateModernSalesVoucherPdf], which is the function
  /// executed by this screen.
  static const String dartUsageCode = r'''/// Generates the Modern Sales Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernSalesVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernSalesVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'Modern Vouchers',
      title: 'Modern Sales Voucher',
      description: 'Clean, official sales invoice design.',
      apiName: 'generateModernSalesVoucherPdf',
      icon: Icons.shopping_cart_outlined,
      generator: generateModernSalesVoucherPdf,
      usageCode: dartUsageCode,
      fileName: 'modern_sales_demo.pdf',
      initialRtl: true,
    );
  }
}
