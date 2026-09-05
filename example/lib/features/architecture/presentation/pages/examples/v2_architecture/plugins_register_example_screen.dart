import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Register Demo Plugin.
class PluginsRegisterExampleScreen extends StatelessWidget {
  const PluginsRegisterExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _registerDemoPlugin() async {
    setState(() {
      _isLoading = true;
      _status = 'Registering demo plugin...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      final result = await manager.register(_DemoPlugin());

      setState(() {
        _status = result
            ? 'Demo plugin registered successfully!\n'
                'Plugin ID: demo-plugin\n'
                'Version: 1.0.0'
            : 'Plugin already registered or registration failed.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }''';

  @override
  Widget build(BuildContext context) {
    return const V2ArchitectureSingleExampleHost(
      example: V2ArchitectureExample.registerPlugin,
      usageCode: dartUsageCode,
    );
  }
}
