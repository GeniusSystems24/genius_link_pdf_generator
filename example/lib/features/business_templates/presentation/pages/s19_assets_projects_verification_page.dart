import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s19_assets_projects/asset_card_verify_screen.dart';

/// Compatibility entry point for the former aggregate S19 Fixed Assets & Projects Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S19 verification example screens.')
class S19FixedAssetsProjectsPackVerificationPage extends StatelessWidget {
  const S19FixedAssetsProjectsPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S19AssetCardVerificationExampleScreen();
}
