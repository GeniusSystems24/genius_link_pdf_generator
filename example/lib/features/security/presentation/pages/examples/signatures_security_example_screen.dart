import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/security/presentation/pages/examples/signatures/visual_signature_security_example_screen.dart';

/// Compatibility entry point for the former aggregate Digital Signatures screen.
///
/// The category is now a navigation group. Use its focused child destinations.
@Deprecated('Use the dedicated Digital Signatures example screens.')
class SignaturesSecurityExampleScreen extends StatelessWidget {
  const SignaturesSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const VisualSignatureSecurityExampleScreen();
}
