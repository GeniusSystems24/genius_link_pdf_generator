import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/document_builder/presentation/pages/s03_flow_layout/one_page_verify_screen.dart';

/// Compatibility entry point for the former aggregate S03 Flow Layout page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S03 verification example screens.')
class S03FlowLayoutVerificationPage extends StatelessWidget {
  const S03FlowLayoutVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S03OnePageVerificationExampleScreen();
}
