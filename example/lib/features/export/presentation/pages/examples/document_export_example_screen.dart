import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/export/presentation/pages/examples/document_export/balance_sheet_html_export_example_screen.dart';

/// Compatibility entry point for the former generic Document Export screen.
///
/// Document export is now demonstrated with focused template-to-HTML examples.
@Deprecated('Use the dedicated template HTML-export example screens.')
class DocumentExportExampleScreen extends StatelessWidget {
  const DocumentExportExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const BalanceSheetHtmlExportExampleScreen();
}
