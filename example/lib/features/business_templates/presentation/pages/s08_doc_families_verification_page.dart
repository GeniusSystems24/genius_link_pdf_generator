import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/s08_doc_families/transaction_verify_screen.dart';

/// Compatibility entry point for the former aggregate S08 ERP Document Families page.
///
/// Each scenario now has its own destination and screen.
@Deprecated('Use the dedicated S08 verification example screens.')
class S08ErpDocumentFamiliesVerificationPage extends StatelessWidget {
  const S08ErpDocumentFamiliesVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S08TransactionVerificationExampleScreen();
}
