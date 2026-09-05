import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s21_crm_pack/customer_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S21 CRM Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S21 verification example screens.')
class S21CrmPackVerificationPage extends StatelessWidget {
  const S21CrmPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S21CustomerVerificationExampleScreen();
}
