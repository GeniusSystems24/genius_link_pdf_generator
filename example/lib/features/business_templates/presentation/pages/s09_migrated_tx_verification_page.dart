import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s09_migrated_tx/quotation1_verify_screen.dart';

/// Compatibility entry point for the former aggregate S09 Migrated Transaction Templates page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S09 verification example screens.')
class S09MigratedTransactionTemplatesVerificationPage extends StatelessWidget {
  const S09MigratedTransactionTemplatesVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S09Quotation1VerificationExampleScreen();
}
