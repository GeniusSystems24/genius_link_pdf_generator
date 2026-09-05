import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s26_industries/retail_verify_screen.dart';

/// Compatibility entry point for the former aggregate S26 Industry / Plugin Packs page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S26 verification example screens.')
class S26IndustryPacksVerificationPage extends StatelessWidget {
  const S26IndustryPacksVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S26RetailVerificationExampleScreen();
}
