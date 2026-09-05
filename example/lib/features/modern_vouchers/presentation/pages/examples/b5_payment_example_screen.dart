import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated PDF-preview example for **B5 Payment Voucher**.
///
/// The document is generated only after the user presses **Run example**.
/// `dartUsageCode` contains the exact function wired to [generator].
class B5PaymentExampleScreen extends StatelessWidget {
  const B5PaymentExampleScreen({super.key});

  /// Exact source of [generateB5PaymentVoucherPdf], which is the function
  /// executed by this screen.
  static const String dartUsageCode = r'''/// Generates the B5 Payment Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateB5PaymentVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildB5PaymentVoucher(
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
      title: pdfLocalization.b5PaymentVoucher,
      description: pdfLocalization.specialB5SizedPaymentVoucher,
      apiName: 'generateB5PaymentVoucherPdf',
      icon: Icons.payments_outlined,
      generator: generateB5PaymentVoucherPdf,
      usageCode: dartUsageCode,
      fileName: 'payment_voucher_b5.pdf',
      initialRtl: true,
    );
  }
}
