import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s20_maintenance_service_logistics_pack/service_order_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S20 Maintenance, Service & Logistics Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S20 verification example screens.')
class S20MaintenanceServiceLogisticsPackVerificationPage extends StatelessWidget {
  const S20MaintenanceServiceLogisticsPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S20ServiceOrderVerificationExampleScreen();
}
