import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/architecture/presentation/pages/examples/v2_architecture/events_doc_created_ex_screen.dart';

/// Compatibility entry point for the former architecture_events aggregate example.
@Deprecated('Use the dedicated V2 Architecture example screens.')
class EventsExampleScreen extends StatelessWidget {
  const EventsExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const EventsDocumentCreatedExampleScreen();
}
