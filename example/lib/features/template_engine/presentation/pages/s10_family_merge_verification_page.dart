import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/template_engine/presentation/pages/s10_family_merge/family_audit_verify_screen.dart';

/// Compatibility entry point for the former aggregate S10 Template Family Consolidation page.
///
/// Every concrete verification scenario now has its own screen.
@Deprecated('Use the dedicated S10 verification example screens.')
class S10TemplateFamilyConsolidationVerificationPage extends StatelessWidget {
  const S10TemplateFamilyConsolidationVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S10FamilyAuditVerificationExampleScreen();
}
