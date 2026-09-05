import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/benchmark/presentation/pages/s24_performance_regression/family_benchmark_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S24 page.
///
/// S24 now exposes one screen per performance/regression scenario.
@Deprecated('Use the dedicated S24 verification example screens.')
class S24PerformanceRegressionVerificationPage extends StatelessWidget {
  const S24PerformanceRegressionVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S24FamilyBenchmarkVerificationExampleScreen();
}
