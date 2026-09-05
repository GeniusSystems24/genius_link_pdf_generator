import 'package:flutter/material.dart';

import 'grid_richtext/financial_analysis_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Grid + Rich Text example screen instead.')
class GridRichtextExampleScreen extends StatelessWidget {
  const GridRichtextExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const GridRichtextFinancialAnalysisExampleScreen();
}
