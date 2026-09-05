import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/template_engine/presentation/pages/s22_template_engine_vnext/schema_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S22 Template Engine vNext page.
///
/// Every concrete verification scenario now has its own screen.
@Deprecated('Use the dedicated S22 verification example screens.')
class S22TemplateEngineVNextVerificationPage extends StatelessWidget {
  const S22TemplateEngineVNextVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S22SchemaVerificationExampleScreen();
}
