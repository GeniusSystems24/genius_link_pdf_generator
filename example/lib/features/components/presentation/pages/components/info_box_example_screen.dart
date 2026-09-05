import 'package:flutter/material.dart';

import 'info_box/customer_company_info_boxes_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Info Box example screen instead.')
class InfoBoxExampleScreen extends StatelessWidget {
  const InfoBoxExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const CustomerCompanyInfoBoxesExampleScreen();
}
