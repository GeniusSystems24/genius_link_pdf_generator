import 'package:flutter/material.dart';

import 'web_link/web_link_builder_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Web Links example screen instead.')
class WebLinkExampleScreen extends StatelessWidget {
  const WebLinkExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const WebLinkBuilderExampleScreen();
}
