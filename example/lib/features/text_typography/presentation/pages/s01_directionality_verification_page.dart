import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/text_typography/presentation/pages/s01_directionality/precedence_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S01 Directionality page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S01 verification example screens.')
class S01DirectionalityVerificationPage extends StatelessWidget {
  const S01DirectionalityVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S01PrecedenceVerificationExampleScreen();
}
