import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/template_engine/presentation/pages/s25_template_designer/metadata_verify_screen.dart';

/// Compatibility entry point for the former aggregate S25 Template Designer page.
///
/// Every concrete verification scenario now has its own screen.
@Deprecated('Use the dedicated S25 verification example screens.')
class S25TemplateDesignerVerificationPage extends StatelessWidget {
  const S25TemplateDesignerVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S25MetadataVerificationExampleScreen();
}
