import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/presentation/pages/templates/tax_invoice_template_screen.dart';
import 'package:genius_pdf_example/features/templates/presentation/pages/templates/trial_balance_template_screen.dart';
import 'package:genius_pdf_example/features/templates/presentation/pages/templates/customer_statement_template_screen.dart';
import 'package:genius_pdf_example/features/templates/presentation/pages/templates/inventory_report_template_screen.dart';

/// Legacy compatibility wrapper for the former tabbed Templates Demo screen.
///
/// Report templates are now exposed as individual navigation destinations.
/// This class remains only so old source links and route aliases continue to
/// compile. It does not render a catalog, multiple examples, [TabBar], or
/// [TabBarView].
@Deprecated(
  'Use the dedicated template screens, such as TaxInvoiceTemplateScreen or '
  'TrialBalanceTemplateScreen.',
)
class TemplatesDemoScreen extends StatelessWidget {
  const TemplatesDemoScreen({super.key, this.initialTab = 0});

  /// Compatibility mapping for old callers that selected one of the former
  /// tabs by index.
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return switch (initialTab) {
      1 => const TrialBalanceTemplateScreen(),
      2 => const CustomerStatementTemplateScreen(),
      3 => const InventoryReportTemplateScreen(),
      _ => const TaxInvoiceTemplateScreen(),
    };
  }
}
