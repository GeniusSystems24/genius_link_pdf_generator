import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/configuration/models/documents/s05_formatting_theme_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

/// Dedicated S05 example for Null / Units / Exchange Rate.
class S05NullsUnitsExchangeVerificationExampleScreen extends StatelessWidget {
  const S05NullsUnitsExchangeVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S05 Formatting & Theme',
      title: 'Null / Units / Exchange Rate',
      description: 'Focused S05 verification for Null / Units / Exchange Rate. Generate the document explicitly, inspect the PDF result, and compare LTR and RTL output without switching to another scenario.',
      apiName: 'buildS05NullsUnitsExchangeVerificationPdf',
      icon: Icons.format_paint_outlined,
      generator: buildS05NullsUnitsExchangeVerificationPdf,
      fileName: 's05_formatting_theme_nulls_units_exchange.pdf',
      usageCode: r'''Future<Uint8List> buildS05NullsUnitsExchangeVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S05FormattingThemeScenario.nullsUnitsExchange,
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
