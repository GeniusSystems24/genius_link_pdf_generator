import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for List Registered Plugins.
class PluginsListExampleScreen extends StatelessWidget {
  const PluginsListExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _listPlugins() async {
    setState(() {
      _isLoading = true;
      _status = 'Listing plugins...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      final plugins = manager.plugins;

      if (plugins.isEmpty) {
        setState(() {
          _status = 'No plugins registered.\n'
              'Use "Register Demo Plugin" to add a plugin.';
        });
      } else {
        final buffer = StringBuffer('Registered Plugins:\n\n');
        for (final plugin in plugins) {
          buffer.writeln('• ${plugin.name} (${plugin.id})');
          buffer.writeln('  Version: ${plugin.version}');
          buffer.writeln('  Priority: ${plugin.priority}');
          buffer.writeln('  Initialized: ${manager.isInitialized(plugin.id)}');
          buffer.writeln('');
        }
        setState(() {
          _status = buffer.toString();
        });
      }
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
      example: V2ArchitectureExample.listPlugins,
      usageCode: dartUsageCode,
    );
  }
}
