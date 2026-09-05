import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s18_manufacturing_quality_pack/bom_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S18 Manufacturing & Quality Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S18 verification example screens.')
class S18ManufacturingQualityPackVerificationPage extends StatelessWidget {
  const S18ManufacturingQualityPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S18BomVerificationExampleScreen();
}
