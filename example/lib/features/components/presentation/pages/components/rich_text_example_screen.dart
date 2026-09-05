import 'package:flutter/material.dart';

import 'rich_text/fluent_formatting_example_screen.dart';

/// Backward-compatible entry point for the former aggregate example screen.
///
/// New navigation exposes every focused example directly.
@Deprecated('Use a focused Rich Text example screen instead.')
class RichTextExampleScreen extends StatelessWidget {
  const RichTextExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const RichTextFluentFormattingExampleScreen();
}
