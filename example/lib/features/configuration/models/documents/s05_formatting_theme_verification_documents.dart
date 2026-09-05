import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Focused scenarios extracted from the former S05FormattingThemeVerificationPage.
enum S05FormattingThemeScenario {
  consistency,
  currencies,
  precision,
  accounting,
  arabicDigits,
  nullsUnitsExchange,
  themeTokens,
  longMultiPage,
}

class S05FormattingThemeDocument extends GeniusPdfDocumentBuilder {
  S05FormattingThemeDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
  }) : super(config, directionality: directionality);

  final S05FormattingThemeScenario scenario;

  @override
  void build() {
    newPage();
    switch (scenario) {
      case S05FormattingThemeScenario.consistency:
        _consistency();
        return;
      case S05FormattingThemeScenario.currencies:
        _currencies();
        return;
      case S05FormattingThemeScenario.precision:
        _precision();
        return;
      case S05FormattingThemeScenario.accounting:
        _accounting();
        return;
      case S05FormattingThemeScenario.arabicDigits:
        _digits();
        return;
      case S05FormattingThemeScenario.nullsUnitsExchange:
        _nullsUnitsExchange();
        return;
      case S05FormattingThemeScenario.themeTokens:
        _themeTokens();
        return;
      case S05FormattingThemeScenario.longMultiPage:
        _longMultiPage();
        return;
    }
  }

  void _consistency() {
    const money = GeniusPdfFormatSpec.money(currencyCode: 'SAR');

    final labeled = GeniusPdfLabeledValue.formatted(
      config: config,
      directionality: directionality,
      label: 'Info / Labeled Value',
      labelAr: 'قيمة المعلومات',
      rawValue: 15697.5,
      formatSpec: money,
      valueDirection: GeniusPdfDirection.ltr,
    );
    final labelResult = labeled.draw(page: currentPage, bounds: contentBounds);
    if (labelResult != null) updateFromLayoutResult(labelResult, spacing: 8);

    final grid = GeniusPdfDataGridVNext(
      config: config,
      columns: const [
        GeniusPdfGridColumn(id: 'source', title: 'Source', titleAr: 'المصدر'),
        GeniusPdfGridColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          isNumeric: true,
          formatSpec: money,
        ),
      ],
      rows: const [
        GeniusPdfGridRow(cells: {'source': 'Grid', 'amount': 15697.5}),
      ],
    );
    final gridResult = grid.draw(page: currentPage, bounds: contentBounds);
    if (gridResult != null) updateFromLayoutResult(gridResult, spacing: 12);

    addSummary(
      GeniusPdfSummarySection(
        config: config,
        directionality: directionality,
        items: [
          GeniusPdfSummaryItem.formatted(
            label: 'Grand Total',
            labelAr: 'الإجمالي النهائي',
            rawValue: 15697.5,
            formatter: config.formatter,
            formatSpec: money,
            isBold: true,
            isHighlighted: true,
            isRtl: config.isRTL,
          ),
        ],
      ),
    );
  }

  void _currencies() {
    for (final pair in const <(String, num)>[
      ('SAR', 15697.5), ('USD', 2047.5), ('EUR', -1250),
    ]) {
      addLine(config.formatter.formatMoney(pair.$2, currencyCode: pair.$1), topMargin: 8);
    }
  }

  void _precision() {
    for (final precision in const <int>[0, 2, 4]) {
      addLine('precision=$precision → ${config.formatter.formatNumber(12.3456, decimalPlaces: precision)}', topMargin: 8);
    }
  }

  void _accounting() {
    addLine(config.formatter.formatMoney(-1250, currencyCode: 'SAR', negativeFormat: GeniusPdfNegativeFormat.accounting));
    addLine(config.formatter.formatMoney(1250, currencyCode: 'SAR'), topMargin: 8);
  }

  void _digits() {
    addLine(config.formatter.formatMoney(15697.5, currencyCode: 'SAR'));
    addLine('ID: ${config.formatter.formatIdentifier('INV-2026-000123')}', topMargin: 8);
  }

  void _nullsUnitsExchange() {
    addLine('Null: ${config.formatter.formatNumber(null)}');
    addLine(
      'Quantity: ${config.formatter.formatQuantity(1250.5, unit: 'KG', unitAr: 'كجم', isRtl: config.isRTL, decimalPlaces: 3)}',
      topMargin: 8,
    );
    addLine(
      'Rate: ${config.formatter.formatExchangeRate(3.75, from: 'USD', to: 'SAR')}',
      topMargin: 8,
    );
  }

  void _themeTokens() {
    final direction = config.isRTL ? GeniusPdfResolvedDirection.rtl : GeniusPdfResolvedDirection.ltr;
    final padding = config.theme.logicalSpacing.content.resolve(direction);
    final border = config.theme.logicalBorders.sectionAccent.resolve(direction);
    addLine('GeniusPdfTheme controls visual tokens without editing template source.');
    addLine('logical padding left=${padding.left}, right=${padding.right}', topMargin: 8);
    addLine('leading border left=${border.left}, right=${border.right}', topMargin: 8);
    addSpace(10);
    _consistency();
  }

  void _longMultiPage() {
    final rows = List<GeniusPdfGridRow>.generate(
      180,
      (index) => GeniusPdfGridRow(
        cells: {
          'id': 'INV-${202600000 + index}',
          'description': config.isRTL
              ? 'سطر مالي طويل رقم $index مع وصف متعدد اللغات'
              : 'Long financial row $index with bilingual content',
          'amount': (index + 1) * 13.65,
        },
      ),
    );
    final grid = GeniusPdfDataGridVNext(
      config: config,
      columns: const [
        GeniusPdfGridColumn(
          id: 'id',
          title: 'Document',
          titleAr: 'المستند',
          contentDirection: GeniusPdfDirection.ltr,
          formatSpec: GeniusPdfFormatSpec.identifier(),
        ),
        GeniusPdfGridColumn(id: 'description', title: 'Description', titleAr: 'الوصف'),
        GeniusPdfGridColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          isNumeric: true,
          formatSpec: GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
        ),
      ],
      rows: rows,
      repeatHeaderOnPages: true,
    );
    final result = grid.draw(page: currentPage, bounds: contentBounds);
    if (result != null) updateFromLayoutResult(result, spacing: 8);
  }
}

Future<Uint8List> buildS05ConsistencyVerificationPdf(GeniusPdfConfig config) async {
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
}

Future<Uint8List> buildS05CurrenciesVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S05FormattingThemeScenario.currencies,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS05PrecisionVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S05FormattingThemeScenario.precision,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

Future<Uint8List> buildS05AccountingVerificationPdf(GeniusPdfConfig config) async {
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
}

Future<Uint8List> buildS05ArabicDigitsVerificationPdf(GeniusPdfConfig config) async {
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
}

Future<Uint8List> buildS05NullsUnitsExchangeVerificationPdf(GeniusPdfConfig config) async {
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
}

Future<Uint8List> buildS05ThemeTokensVerificationPdf(GeniusPdfConfig config) async {
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
}

Future<Uint8List> buildS05LongMultiPageVerificationPdf(GeniusPdfConfig config) async {
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
    scenario: S05FormattingThemeScenario.longMultiPage,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}
