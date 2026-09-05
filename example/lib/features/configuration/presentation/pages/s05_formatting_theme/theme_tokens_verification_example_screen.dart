import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/configuration/models/documents/s05_formatting_theme_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S05 example for Theme / Design Tokens.
class S05ThemeTokensVerificationExampleScreen extends StatelessWidget {
  const S05ThemeTokensVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S05 Formatting & Theme',
      title: pdfLocalization.themeDesignTokens,
      description: pdfLocalization.s05ThemeDesignTokensVerify,
      apiName: 'buildS05ThemeTokensVerificationPdf',
      icon: Icons.format_paint_outlined,
      generator: buildS05ThemeTokensVerificationPdf,
      fileName: 's05_formatting_theme_theme_tokens.pdf',
      usageCode: r'''Future<Uint8List> buildS05ThemeTokensVerificationPdf(GeniusPdfConfig config) async {
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
    theme: GeniusPdfTheme.corporate(),
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
    scenario: S05FormattingThemeScenario.themeTokens,
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
