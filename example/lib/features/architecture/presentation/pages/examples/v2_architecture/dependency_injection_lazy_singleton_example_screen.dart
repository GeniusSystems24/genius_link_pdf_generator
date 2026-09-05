import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Lazy Singleton.
class DependencyInjectionLazySingletonExampleScreen extends StatelessWidget {
  const DependencyInjectionLazySingletonExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<void> _demoLazySingleton() async {
    setState(() {
      _isLoading = true;
      _status = 'Demonstrating lazy singleton...';
    });

    try {
      final container = GeniusPdfContainer.instance;

      var creationCount = 0;
      container.registerLazySingleton<Map<String, int>>(() {
        creationCount++;
        return {
          'creationNumber': creationCount,
          'time': DateTime.now().millisecond
        };
      }, name: 'lazyDemo');

      final buffer = StringBuffer('Lazy Singleton Demo:\n\n');

      buffer.writeln('Before first access: creationCount = $creationCount');

      final first = container.get<Map<String, int>>(name: 'lazyDemo');
      buffer.writeln('First access: $first');
      buffer.writeln('After first access: creationCount = $creationCount');

      final second = container.get<Map<String, int>>(name: 'lazyDemo');
      buffer.writeln('Second access: $second');
      buffer.writeln('After second access: creationCount = $creationCount');

      buffer.writeln('\n(Same value = lazy singleton created only once)');

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
      example: V2ArchitectureExample.lazySingleton,
      usageCode: dartUsageCode,
    );
  }
}
