import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Initialize All Plugins.
class PluginsInitializeExampleScreen extends StatelessWidget {
  const PluginsInitializeExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _initializePlugins() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing plugins...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      await manager.initializeAll();

      setState(() {
        _status = 'All plugins initialized!\n'
            'Total plugins: ${manager.count}';
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
      example: V2ArchitectureExample.initializePlugins,
      usageCode: dartUsageCode,
    );
  }
}
