import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/components/presentation/pages/s02_components_rtl/matrix_verify_screen.dart';

/// Compatibility entry point for the former aggregate S02 Components RTL page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S02 verification example screens.')
class S02ComponentsRtlVerificationPage extends StatelessWidget {
  const S02ComponentsRtlVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S02MatrixVerificationExampleScreen();
}
