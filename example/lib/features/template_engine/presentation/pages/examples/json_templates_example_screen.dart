import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/template_engine/presentation/internal/template_engine_single_example_host.dart';

/// Dedicated single-example screen for **JSON Templates**.
///
/// This screen deliberately contains no tabs and no sibling examples. It keeps
/// the original Template Engine implementation and behavior through the
/// shared internal host while selecting only this example.
class JsonTemplatesExampleScreen extends StatelessWidget {
  const JsonTemplatesExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateEngineSingleExampleHost(initialTab: 1);
  }
}
