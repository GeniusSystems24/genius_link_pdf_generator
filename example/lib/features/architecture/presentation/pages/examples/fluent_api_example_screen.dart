import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/architecture/presentation/pages/examples/v2_architecture/fluent_api_simple_doc_ex_screen.dart';

/// Compatibility entry point for the former architecture_fluent_api aggregate example.
@Deprecated('Use the dedicated V2 Architecture example screens.')
class FluentApiExampleScreen extends StatelessWidget {
  const FluentApiExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const FluentApiSimpleDocumentExampleScreen();
}
