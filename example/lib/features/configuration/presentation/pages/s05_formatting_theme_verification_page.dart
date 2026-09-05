import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/configuration/presentation/pages/s05_formatting_theme/consistency_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S05 Formatting & Theme page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S05 verification example screens.')
class S05FormattingThemeVerificationPage extends StatelessWidget {
  const S05FormattingThemeVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S05ConsistencyVerificationExampleScreen();
}
