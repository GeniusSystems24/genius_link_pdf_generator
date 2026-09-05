import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/pages/examples/encryption_security_example_screen.dart';
import 'package:genius_pdf_example/features/security/presentation/pages/examples/signatures_security_example_screen.dart';
import 'package:genius_pdf_example/features/security/presentation/pages/examples/watermarks_security_example_screen.dart';

/// Compatibility entry point. New navigation should use the focused screens.
@Deprecated('Use a dedicated security example screen.')
class SecurityDemoScreen extends StatelessWidget {
  const SecurityDemoScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  Widget build(BuildContext context) => switch (initialTab) {
        1 => const EncryptionSecurityExampleScreen(),
        2 => const SignaturesSecurityExampleScreen(),
        _ => const WatermarksSecurityExampleScreen(),
      };
}
