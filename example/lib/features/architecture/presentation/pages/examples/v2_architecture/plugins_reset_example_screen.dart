import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Reset Plugin Manager.
class PluginsResetExampleScreen extends StatelessWidget {
  const PluginsResetExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _resetPluginManager() async {
    setState(() {
      _isLoading = true;
      _status = 'Resetting plugin manager...';
    });

    try {
      GeniusPluginManager.resetInstance();

      setState(() {
        _status = 'Plugin manager reset successfully!\n'
            'All plugins have been unregistered.';
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
      example: V2ArchitectureExample.resetPluginManager,
      usageCode: dartUsageCode,
    );
  }
}
