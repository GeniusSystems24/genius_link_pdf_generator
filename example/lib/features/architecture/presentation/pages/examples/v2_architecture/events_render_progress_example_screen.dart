import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Render Progress Events.
class EventsRenderProgressExampleScreen extends StatelessWidget {
  const EventsRenderProgressExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''void _emitRenderProgress() {
    final eventBus = GeniusPdfEventBus.instance;

    for (var i = 1; i <= 5; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        eventBus.emit(GeniusRenderProgressEvent(
          documentId: 'doc-render',
          currentPage: i,
          totalPages: 5,
        ));
      });
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      eventBus.emit(GeniusRenderCompletedEvent(
        documentId: 'doc-render',
        duration: const Duration(seconds: 1),
      ));
    });

    setState(() {
      _status = 'Emitting render progress events...\n'
          'Watch the event log for updates.';
    });
  }''';

  @override
  Widget build(BuildContext context) {
    return const V2ArchitectureSingleExampleHost(
      example: V2ArchitectureExample.renderProgressEvents,
      usageCode: dartUsageCode,
    );
  }
}
