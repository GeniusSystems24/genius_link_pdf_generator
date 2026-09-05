import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/configuration/models/documents/s05_formatting_theme_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S05 example for Negative Accounting.
class S05AccountingVerificationExampleScreen extends StatelessWidget {
  const S05AccountingVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S05 Formatting & Theme',
      title: pdfLocalization.negativeAccounting,
      description: pdfLocalization.s05NegativeAccountingVerify,
      apiName: 'buildS05AccountingVerificationPdf',
      icon: Icons.format_paint_outlined,
      generator: buildS05AccountingVerificationPdf,
      fileName: 's05_formatting_theme_accounting.pdf',
      usageCode: r'''Future<Uint8List> buildS05AccountingVerificationPdf(GeniusPdfConfig config) async {
  final formatter = GeniusPdfDefaultFormatter(
    settings: GeniusPdfFormatSettings(
      locale: 'en_US',
      digitPolicy: GeniusPdfDigitPolicy.latin,
      nullPolicy: const GeniusPdfNullPlaceholderPolicy.emDash(),
      currencyDisplay: GeniusPdfCurrencyDisplay.code,
      currencyPosition: GeniusPdfCurrencyPosition.after,
      negativeFormat: GeniusPdfNegativeFormat.accounting,
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
    scenario: S05FormattingThemeScenario.accounting,
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
