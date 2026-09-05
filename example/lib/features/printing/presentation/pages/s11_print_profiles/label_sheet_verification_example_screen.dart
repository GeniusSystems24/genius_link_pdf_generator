import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/models/documents/s11_print_profiles_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S11 verification example for Label sheet.
class S11LabelSheetVerificationExampleScreen extends StatelessWidget {
  const S11LabelSheetVerificationExampleScreen({super.key});

  /// Exact generator function wired to [VerificationExampleDetailScreen].
  static const String dartUsageCode = r'''Future<Uint8List> buildS11LabelSheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S11PrintProfilesRunner(
    baseConfig: config,
    scenario: S11PrintProfilesScenario.labelSheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}''';

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S11 Print Profiles',
      title: 'Label sheet',
      description: 'Focused S11 verification for Label sheet. Generate this example independently, inspect the PDF output, and compare LTR and RTL without switching to another scenario.',
      apiName: 'buildS11LabelSheetVerificationPdf',
      icon: Icons.settings_applications_outlined,
      generator: buildS11LabelSheetVerificationPdf,
      usageCode: dartUsageCode,
      fileName: 's11_print_profiles_label_sheet.pdf',
    );
  }
}
