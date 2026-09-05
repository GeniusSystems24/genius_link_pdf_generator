import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/architecture/presentation/pages/s06_erp_calc/baseline_verify_screen.dart';

/// Compatibility entry point for the former aggregate S06 ERP Domain & Calculations page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S06 verification example screens.')
class S06ErpDomainCalculationVerificationPage extends StatelessWidget {
  const S06ErpDomainCalculationVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S06BaselineVerificationExampleScreen();
}
