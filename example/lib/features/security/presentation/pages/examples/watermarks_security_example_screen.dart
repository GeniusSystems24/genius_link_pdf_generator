import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/security/presentation/pages/examples/watermarks/confidential_watermark_security_example_screen.dart';

/// Compatibility entry point for the former aggregate Watermarks screen.
///
/// The category is now a navigation group. Use its focused child destinations.
@Deprecated('Use the dedicated Watermarks example screens.')
class WatermarksSecurityExampleScreen extends StatelessWidget {
  const WatermarksSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const ConfidentialWatermarkSecurityExampleScreen();
}
