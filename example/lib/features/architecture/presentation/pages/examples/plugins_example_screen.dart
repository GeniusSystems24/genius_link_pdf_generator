import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/architecture/presentation/pages/examples/v2_architecture/plugins_register_example_screen.dart';

/// Compatibility entry point for the former architecture_plugins aggregate example.
@Deprecated('Use the dedicated V2 Architecture example screens.')
class PluginsExampleScreen extends StatelessWidget {
  const PluginsExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const PluginsRegisterExampleScreen();
}
