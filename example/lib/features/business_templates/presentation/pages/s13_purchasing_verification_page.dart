import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s13_purchasing/requisition_verify_screen.dart';

/// Compatibility entry point for the former aggregate S13 Purchasing ERP Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S13 verification example screens.')
class S13PurchasingErpPackVerificationPage extends StatelessWidget {
  const S13PurchasingErpPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S13RequisitionVerificationExampleScreen();
}
