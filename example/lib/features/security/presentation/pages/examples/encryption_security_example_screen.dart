import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/security/presentation/pages/examples/encryption/password_protection_security_example_screen.dart';

/// Compatibility entry point for the former aggregate Encryption & Permissions screen.
///
/// The category is now a navigation group. Use its focused child destinations.
@Deprecated('Use the dedicated Encryption & Permissions example screens.')
class EncryptionSecurityExampleScreen extends StatelessWidget {
  const EncryptionSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const PasswordProtectionSecurityExampleScreen();
}
