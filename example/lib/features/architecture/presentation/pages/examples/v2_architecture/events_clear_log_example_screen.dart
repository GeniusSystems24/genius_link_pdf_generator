import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Clear Event Log.
class EventsClearLogExampleScreen extends StatelessWidget {
  const EventsClearLogExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''void _clearEventLog() {
  setState(() {
    _eventLog.clear();
    _status = 'Event log cleared.';
  });
}''';

  @override
  Widget build(BuildContext context) {
    return const V2ArchitectureSingleExampleHost(
      example: V2ArchitectureExample.clearEventLog,
      usageCode: dartUsageCode,
    );
  }
}
