import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/security/presentation/pages/s23_compliance_signing_archival/original_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S23 Compliance, Signing & Archival page.
///
/// Every concrete verification scenario now has its own screen.
@Deprecated('Use the dedicated S23 verification example screens.')
class S23ComplianceSigningArchivalVerificationPage extends StatelessWidget {
  const S23ComplianceSigningArchivalVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S23OriginalVerificationExampleScreen();
}
