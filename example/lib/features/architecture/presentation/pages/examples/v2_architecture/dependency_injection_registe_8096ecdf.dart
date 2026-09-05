import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Register Services.
class DependencyInjectionRegisterServicesExampleScreen extends StatelessWidget {
  const DependencyInjectionRegisterServicesExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _registerServices() async {
    setState(() {
      _isLoading = true;
      _status = 'Registering services...';
    });

    try {
      final container = GeniusPdfContainer.instance;

      container.registerSingleton<String>('Global Config Value',
          name: 'config');

      container.registerFactory<int>(
          () => DateTime.now().millisecondsSinceEpoch,
          name: 'timestamp');

      container.registerLazySingleton<List<String>>(
        () => ['Item 1', 'Item 2', 'Item 3'],
        name: 'items',
      );

      setState(() {
        _status = 'Services registered successfully!\n'
            '• config (singleton): String\n'
            '• timestamp (factory): int\n'
            '• items (lazy singleton): List<String>';
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
      example: V2ArchitectureExample.registerServices,
      usageCode: dartUsageCode,
    );
  }
}
