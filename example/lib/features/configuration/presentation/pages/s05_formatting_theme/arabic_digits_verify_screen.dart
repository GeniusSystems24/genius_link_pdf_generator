import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/configuration/models/documents/configuration_background_generation.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S05 example for Arabic / Latin Digits.
class S05ArabicDigitsVerificationExampleScreen extends StatelessWidget {
  const S05ArabicDigitsVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S05 Formatting & Theme',
      title: pdfLocalization.arabicLatinDigits,
      description: pdfLocalization.s05ArabicLatinDigitsVerify,
      apiName: 'buildS05ArabicDigitsVerificationPdf',
      icon: Icons.format_paint_outlined,
      backgroundGenerator: ({required bool isRtl}) =>

        generateConfigurationVerificationInBackground(

          apiName: 'buildS05ArabicDigitsVerificationPdf',

          isRtl: isRtl,

        ),
      fileName: 's05_formatting_theme_arabic_digits.pdf',
      showGenerationToast: true,
      usageCode: r'''Future<Uint8List> buildS05ArabicDigitsVerificationPdf(GeniusPdfConfig config) async {
  final formatter = GeniusPdfDefaultFormatter(
    settings: GeniusPdfFormatSettings(
      locale: 'ar_SA',
      digitPolicy: GeniusPdfDigitPolicy.arabicIndic,
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
    scenario: S05FormattingThemeScenario.arabicDigits,
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
