import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/export/presentation/pages/examples/image_export/balance_sheet_image_export_example_screen.dart';

/// Compatibility entry point for the former generic Image Export screen.
///
/// Image export is now demonstrated with focused business-template examples.
@Deprecated('Use the dedicated template image-export example screens.')
class ImageExportExampleScreen extends StatelessWidget {
  const ImageExportExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => const BalanceSheetImageExportExampleScreen();
}
