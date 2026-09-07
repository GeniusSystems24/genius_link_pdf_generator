import 'package:flutter/material.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_background_generation.dart';
import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated PDF-preview example for **Modern Purchase Voucher**.
///
/// The document is generated only after the user presses **Run example**.
/// `dartUsageCode` contains the exact function wired to [generator].
class PurchaseVoucherExampleScreen extends StatelessWidget {
  const PurchaseVoucherExampleScreen({super.key});

  /// Exact source of [generateModernPurchaseVoucherPdf], which is the function
  /// executed by this screen.
  static const String dartUsageCode = r'''/// Generates the Modern Purchase Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernPurchaseVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernPurchaseVoucher(
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
      title: pdfLocalization.modernPurchaseVoucher,
      description: pdfLocalization.officialPurchaseVoucherOrderDesc,
      apiName: 'generateModernPurchaseVoucherPdf',
      icon: Icons.inventory_2_outlined,
      backgroundGenerator: ({required bool isRtl}) =>
          generateModernVoucherInBackground(
            apiName: 'generateModernPurchaseVoucherPdf',
            isRtl: isRtl,
            rootConfig: geniusPdfConfig,
          ),
      showGenerationToast: true,
      usageCode: dartUsageCode,
      fileName: 'modern_purchase_demo.pdf',
      initialRtl: true,
    );
  }
}
