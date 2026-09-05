import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/printing/presentation/pages/s11_print_profiles/a4_portrait_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S11 Print Profiles page.
///
/// Every concrete verification scenario now has its own screen.
@Deprecated('Use the dedicated S11 verification example screens.')
class S11PrintProfilesVerificationPage extends StatelessWidget {
  const S11PrintProfilesVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S11A4PortraitVerificationExampleScreen();
}
