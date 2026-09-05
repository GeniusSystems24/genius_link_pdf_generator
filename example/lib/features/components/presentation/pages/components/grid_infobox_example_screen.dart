import 'package:flutter/material.dart';

import 'grid_infobox/order_document_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Grid + Info Box example screen instead.')
class GridInfoboxExampleScreen extends StatelessWidget {
  const GridInfoboxExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const GridInfoboxOrderDocumentExampleScreen();
}
