import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated PDF-preview example for **Modern Purchase Return**.
///
/// The document is generated only after the user presses **Run example**.
/// `dartUsageCode` contains the exact function wired to [generator].
class PurchaseReturnExampleScreen extends StatelessWidget {
  const PurchaseReturnExampleScreen({super.key});

  /// Exact source of [generateModernPurchaseReturnVoucherPdf], which is the function
  /// executed by this screen.
  static const String dartUsageCode = r'''/// Generates the Modern Purchase Return example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernPurchaseReturnVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernPurchaseReturnVoucher(
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
      title: pdfLocalization.modernPurchaseReturn,
      description: pdfLocalization.purchaseReturnVoucherWithPoReference,
      apiName: 'generateModernPurchaseReturnVoucherPdf',
      icon: Icons.remove_shopping_cart_outlined,
      generator: generateModernPurchaseReturnVoucherPdf,
      usageCode: dartUsageCode,
      fileName: 'modern_purchase_return_demo.pdf',
      initialRtl: true,
    );
  }
}
