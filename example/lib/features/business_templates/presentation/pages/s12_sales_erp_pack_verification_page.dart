import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s12_sales_erp_pack/sales_order_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S12 Sales ERP Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S12 verification example screens.')
class S12SalesErpPackVerificationPage extends StatelessWidget {
  const S12SalesErpPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S12SalesOrderVerificationExampleScreen();
}
