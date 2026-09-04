import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S05Scenario {
  consistency,
  currencies,
  precision,
  accounting,
  arabicDigits,
  nullsUnitsExchange,
  themeTokens,
  longMultiPage,
}

enum _S05ThemePreset { defaults, corporate, minimal, saudi }

class S05FormattingThemeVerificationPage extends StatefulWidget {
  const S05FormattingThemeVerificationPage({super.key});

  @override
  State<S05FormattingThemeVerificationPage> createState() =>
      _S05FormattingThemeVerificationPageState();
}

class _S05FormattingThemeVerificationPageState
    extends State<S05FormattingThemeVerificationPage> {
  _S05Scenario _scenario = _S05Scenario.consistency;
  _S05ThemePreset _theme = _S05ThemePreset.defaults;
  GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
  String _locale = 'en_US';
  GeniusPdfDigitPolicy _digits = GeniusPdfDigitPolicy.latin;
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _generate();
  }

  void _change(VoidCallback action) {
    action();
    setState(() {
      _pdfFuture = _generate();
    });
  }

  GeniusPdfTheme get _resolvedTheme => switch (_theme) {
        _S05ThemePreset.defaults => GeniusPdfTheme.defaults(),
        _S05ThemePreset.corporate => GeniusPdfTheme.corporate(),
        _S05ThemePreset.minimal => GeniusPdfTheme.minimal(),
        _S05ThemePreset.saudi => GeniusPdfTheme.saudi(),
      };

  String _label(_S05Scenario value) => switch (value) {
        _S05Scenario.consistency => 'Summary / Grid / Info consistency',
        _S05Scenario.currencies => 'Multi-currency',
        _S05Scenario.precision => 'Decimal precision',
        _S05Scenario.accounting => 'Negative accounting',
        _S05Scenario.arabicDigits => 'Arabic / Latin digits',
        _S05Scenario.nullsUnitsExchange => 'Null / units / exchange rate',
        _S05Scenario.themeTokens => 'Theme / design tokens',
        _S05Scenario.longMultiPage => 'Long multi-page table',
      };

  String get _expected => switch (_scenario) {
        _S05Scenario.consistency =>
          'The raw value 15697.50 has identical separators/precision in '
              'Summary, DataGrid and labeled-value content.',
        _S05Scenario.currencies =>
          'SAR, USD and EUR use the selected locale and digit policy from '
              'one formatter without damaging value direction.',
        _S05Scenario.precision =>
          'The same source number is rendered with exactly 0, 2 and 4 '
              'decimal places without component-specific snippets.',
        _S05Scenario.accounting =>
          'Negative money uses accounting parentheses. Semantic positive/'
              'negative colors do not change because direction changes.',
        _S05Scenario.arabicDigits =>
          'Display digits follow the selected policy while '
              'INV-2026-000123 remains unchanged.',
        _S05Scenario.nullsUnitsExchange =>
          'Null uses one shared placeholder; quantity/unit and USD→SAR '
              'exchange rate come from the shared formatter.',
        _S05Scenario.themeTokens =>
          'Theme preset changes typography/spacing/borders/colors without '
              'editing document code; RTL changes only logical geometry.',
        _S05Scenario.longMultiPage =>
          'A long table repeats headers and all values keep the same '
              'formatter/theme rules across pages.',
      };

  Future<Uint8List> _generate() async {
    final formatter = GeniusPdfDefaultFormatter(
      settings: GeniusPdfFormatSettings(
        locale: _locale,
        digitPolicy: _digits,
        nullPolicy: const GeniusPdfNullPlaceholderPolicy.emDash(),
        currencyDisplay: GeniusPdfCurrencyDisplay.code,
        currencyPosition: GeniusPdfCurrencyPosition.after,
        negativeFormat: _scenario == _S05Scenario.accounting
            ? GeniusPdfNegativeFormat.accounting
            : GeniusPdfNegativeFormat.minus,
      ),
    );

    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
      formatter: formatter,
      theme: _resolvedTheme,
    );

    final builder = _S05Document(
      config: config,
      directionality: GeniusPdfDirectionality(
        documentDirection: _direction,
      ),
      scenario: _scenario,
    );
    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S05 — Formatting & Theme Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<_S05Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S05Scenario.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_label(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) _change(() => _scenario = value);
                          },
                        ),
                      ),
                      DropdownButton<String>(
                        value: _locale,
                        items: const [
                          DropdownMenuItem(value: 'en_US', child: Text('en_US')),
                          DropdownMenuItem(value: 'ar_SA', child: Text('ar_SA')),
                          DropdownMenuItem(value: 'de_DE', child: Text('de_DE')),
                        ],
                        onChanged: (value) {
                          if (value != null) _change(() => _locale = value);
                        },
                      ),
                      DropdownButton<GeniusPdfDigitPolicy>(
                        value: _digits,
                        items: GeniusPdfDigitPolicy.values
                            .map((value) => DropdownMenuItem(value: value, child: Text(value.name)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) _change(() => _digits = value);
                        },
                      ),
                      DropdownButton<_S05ThemePreset>(
                        value: _theme,
                        items: _S05ThemePreset.values
                            .map((value) => DropdownMenuItem(value: value, child: Text(value.name)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) _change(() => _theme = value);
                        },
                      ),
                      SegmentedButton<GeniusPdfDirection>(
                        segments: const [
                          ButtonSegment(value: GeniusPdfDirection.ltr, label: Text('LTR')),
                          ButtonSegment(value: GeniusPdfDirection.rtl, label: Text('RTL')),
                        ],
                        selected: {_direction},
                        onSelectionChanged: (selection) =>
                            _change(() => _direction = selection.first),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _pdfFuture = _generate();
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's05_formatting_theme.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Expected Result: $_expected'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdfFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: SelectableText('Generation failed:\n${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _S05Document extends GeniusPdfDocumentBuilder {
  _S05Document({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
  }) : super(config, directionality: directionality);

  final _S05Scenario scenario;

  @override
  void build() {
    newPage();
    switch (scenario) {
      case _S05Scenario.consistency:
        _consistency();
        return;
      case _S05Scenario.currencies:
        _currencies();
        return;
      case _S05Scenario.precision:
        _precision();
        return;
      case _S05Scenario.accounting:
        _accounting();
        return;
      case _S05Scenario.arabicDigits:
        _digits();
        return;
      case _S05Scenario.nullsUnitsExchange:
        _nullsUnitsExchange();
        return;
      case _S05Scenario.themeTokens:
        _themeTokens();
        return;
      case _S05Scenario.longMultiPage:
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
