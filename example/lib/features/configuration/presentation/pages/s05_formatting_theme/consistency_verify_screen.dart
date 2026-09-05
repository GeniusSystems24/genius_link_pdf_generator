import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/configuration/models/documents/s05_formatting_theme_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S05 example for Summary / Grid / Info Consistency.
class S05ConsistencyVerificationExampleScreen extends StatelessWidget {
  const S05ConsistencyVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S05 Formatting & Theme',
      title: pdfLocalization.summaryGridInfoConsistency,
      description: pdfLocalization.s05SummaryGridInfoConsistencyVerify,
      apiName: 'buildS05ConsistencyVerificationPdf',
      icon: Icons.format_paint_outlined,
      generator: buildS05ConsistencyVerificationPdf,
      fileName: 's05_formatting_theme_consistency.pdf',
      usageCode: r'''Future<Uint8List> buildS05ConsistencyVerificationPdf(GeniusPdfConfig config) async {
  final formatter = GeniusPdfDefaultFormatter(
    settings: GeniusPdfFormatSettings(
      locale: 'en_US',
      digitPolicy: GeniusPdfDigitPolicy.latin,
      nullPolicy: const GeniusPdfNullPlaceholderPolicy.emDash(),
      currencyDisplay: GeniusPdfCurrencyDisplay.code,
      currencyPosition: GeniusPdfCurrencyPosition.after,
      negativeFormat: GeniusPdfNegativeFormat.minus,
    ),
  );
  final configured = config.copyWith(
    formatter: formatter,
    theme: GeniusPdfTheme.defaults(),
  );
  final direction = configured.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    documentDirection: direction,
  );
  final builder = S05FormattingThemeDocument(
    config: configured,
    directionality: directionality,
    scenario: S05FormattingThemeScenario.consistency,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}''',
    );
  }
}
