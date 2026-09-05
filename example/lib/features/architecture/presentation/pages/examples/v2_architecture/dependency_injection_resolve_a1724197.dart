import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Resolve Dependencies.
class DependencyInjectionResolveExampleScreen extends StatelessWidget {
  const DependencyInjectionResolveExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _resolveDependencies() async {
    setState(() {
      _isLoading = true;
      _status = 'Resolving dependencies...';
    });

    try {
      final container = GeniusPdfContainer.instance;
      final buffer = StringBuffer('Resolved Dependencies:\n\n');

      if (container.isRegistered<String>(name: 'config')) {
        final config = container.get<String>(name: 'config');
        buffer.writeln('config: $config');
      } else {
        buffer.writeln('config: Not registered');
      }

      if (container.isRegistered<int>(name: 'timestamp')) {
        final ts1 = container.get<int>(name: 'timestamp');
        await Future.delayed(const Duration(milliseconds: 10));
        final ts2 = container.get<int>(name: 'timestamp');
        buffer.writeln('timestamp (1st call): $ts1');
        buffer.writeln('timestamp (2nd call): $ts2');
        buffer.writeln('(Different values = factory creates new instances)');
      } else {
        buffer.writeln('timestamp: Not registered');
      }

      if (container.isRegistered<List<String>>(name: 'items')) {
        final items = container.get<List<String>>(name: 'items');
        buffer.writeln('items: $items');
      } else {
        buffer.writeln('items: Not registered');
      }

      setState(() {
        _status = buffer.toString();
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
      example: V2ArchitectureExample.resolveDependencies,
      usageCode: dartUsageCode,
    );
  }
}
