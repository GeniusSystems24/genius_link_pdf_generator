import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/template_engine/presentation/internal/template_engine_single_example_host.dart';

/// Compatibility entry point for the former multi-example Template Engine screen.
///
/// The example application now exposes every example as a dedicated navigation
/// destination. [initialTab] is retained only for existing callers and selects
/// one focused example; no tab bar or multi-example page is rendered.
@Deprecated('Use one of the dedicated Template Engine example screens.')
class TemplateEngineDemoScreen extends StatelessWidget {
  const TemplateEngineDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return TemplateEngineSingleExampleHost(initialTab: initialTab);
  }
}
