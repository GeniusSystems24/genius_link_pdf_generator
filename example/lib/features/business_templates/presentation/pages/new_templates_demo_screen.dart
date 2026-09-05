import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/presentation/pages/templates/balance_sheet_template_screen.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/pages/templates/payslip_template_screen.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/pages/templates/quotation_template_screen.dart';

/// Legacy compatibility wrapper for the former multi-template catalog.
///
/// Business templates are now exposed as individual navigation destinations.
/// This class is retained so older example links/source references continue to
/// compile, but it no longer renders cards, multiple examples, [TabBar], or
/// [TabBarView].
@Deprecated(
  'Use the dedicated template screens, such as BalanceSheetTemplateScreen, '
  'QuotationTemplateScreen, or PayslipTemplateScreen.',
)
class NewTemplatesDemoScreen extends StatelessWidget {
  const NewTemplatesDemoScreen({super.key, this.initialTab = 0});

  /// Retained only for source compatibility with the former catalog.
  ///
  /// 0 opens the first Financial example, 1 the first Sales example, and 2 the
  /// first HR example. New navigation code should target the dedicated screens
  /// directly instead.
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return switch (initialTab) {
      1 => const QuotationTemplateScreen(),
      2 => const PayslipTemplateScreen(),
      _ => const BalanceSheetTemplateScreen(),
    };
  }
}
