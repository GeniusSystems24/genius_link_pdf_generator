import 'package:flutter/material.dart';

import 'grid_watermark/confidential_audit_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Grid + Watermark example screen instead.')
class GridWatermarkExampleScreen extends StatelessWidget {
  const GridWatermarkExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const GridWatermarkConfidentialAuditExampleScreen();
}
