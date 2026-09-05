import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s17_hr_payroll_pack/employee_profile_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S17 HR & Payroll Pack page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S17 verification example screens.')
class S17HrPayrollPackVerificationPage extends StatelessWidget {
  const S17HrPayrollPackVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S17EmployeeProfileVerificationExampleScreen();
}
