import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/components/presentation/pages/s07_erp_components/identity_party_verify_screen.dart';

/// Compatibility entry point for the former aggregate S07 ERP Semantic Components page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S07 verification example screens.')
class S07ErpSemanticComponentsVerificationPage extends StatelessWidget {
  const S07ErpSemanticComponentsVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S07IdentityPartyVerificationExampleScreen();
}
