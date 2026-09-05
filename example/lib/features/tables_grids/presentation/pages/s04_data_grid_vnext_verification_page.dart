import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/tables_grids/presentation/pages/s04_data_grid_vnext/sizing_verification_example_screen.dart';

/// Compatibility entry point for the former aggregate S04 DataGrid vNext page.
///
/// Each scenario now has a dedicated screen. New navigation should target the
/// focused scenario ids instead of this aggregate entry point.
@Deprecated('Use the dedicated S04 verification example screens.')
class S04DataGridVNextVerificationPage extends StatelessWidget {
  const S04DataGridVNextVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => const S04SizingVerificationExampleScreen();
}
