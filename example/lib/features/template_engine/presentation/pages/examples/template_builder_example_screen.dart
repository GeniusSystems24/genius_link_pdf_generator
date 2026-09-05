import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/template_engine/presentation/internal/template_engine_single_example_host.dart';

/// Dedicated single-example screen for **Template Builder**.
///
/// This screen deliberately contains no tabs and no sibling examples. It keeps
/// the original Template Engine implementation and behavior through the
/// shared internal host while selecting only this example.
class TemplateBuilderExampleScreen extends StatelessWidget {
  const TemplateBuilderExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateEngineSingleExampleHost(initialTab: 0);
  }
}
