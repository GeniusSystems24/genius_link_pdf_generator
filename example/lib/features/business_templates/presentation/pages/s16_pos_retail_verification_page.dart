import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s16_pos_retail/receipt58_verify_screen.dart';

/// Compatibility entry point for the former aggregate S16 POS & Retail Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S16 verification example screens.')
class S16PosRetailPackVerificationPage extends StatelessWidget {
  const S16PosRetailPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S16Receipt58VerificationExampleScreen();
}
