import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Document Created Event.
class EventsDocumentCreatedExampleScreen extends StatelessWidget {
  const EventsDocumentCreatedExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''void _emitDocumentCreated() {
    final eventBus = GeniusPdfEventBus.instance;

    eventBus.emit(GeniusDocumentCreatedEvent(
      documentId: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Demo Document',
    ));

    setState(() {
      _status = 'DocumentCreatedEvent emitted!\n'
          'Check the event log above.';
    });
  }''';

  @override
  Widget build(BuildContext context) {
    return const V2ArchitectureSingleExampleHost(
      example: V2ArchitectureExample.documentCreatedEvent,
      usageCode: dartUsageCode,
    );
  }
}
