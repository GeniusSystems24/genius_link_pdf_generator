import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/getting_started/presentation/pages/s00_baseline/mixed_erp_baseline_example_screen.dart';

/// Compatibility entry point for the former aggregate S00 verification page.
///
/// S00 scenarios are now independent destinations. Existing callers continue
/// to open the first baseline example.
@Deprecated('Use the focused S00 baseline example screens.')
class S00BaselineRegressionVerificationPage extends StatelessWidget {
  const S00BaselineRegressionVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S00MixedErpBaselineExampleScreen();
}
