import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated PDF-preview example for **Modern Sales Return**.
///
/// The document is generated only after the user presses **Run example**.
/// `dartUsageCode` contains the exact function wired to [generator].
class SalesReturnExampleScreen extends StatelessWidget {
  const SalesReturnExampleScreen({super.key});

  /// Exact source of [generateModernSalesReturnVoucherPdf], which is the function
  /// executed by this screen.
  static const String dartUsageCode = r'''/// Generates the Modern Sales Return example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernSalesReturnVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernSalesReturnVoucher(
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
      title: 'Modern Sales Return',
      description: 'Sales return voucher with refund details.',
      apiName: 'generateModernSalesReturnVoucherPdf',
      icon: Icons.assignment_return_outlined,
      generator: generateModernSalesReturnVoucherPdf,
      usageCode: dartUsageCode,
      fileName: 'modern_sales_return_demo.pdf',
      initialRtl: true,
    );
  }
}
