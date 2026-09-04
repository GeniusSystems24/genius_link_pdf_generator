import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S01Scenario {
  precedence,
  logicalGeometry,
  valueMatrix,
  mixedText,
  nestedOverrides,
  longMultiPage,
  autoInheritance,
  legacyTemplateJson,
  mediaPolicy,
}

class S01DirectionalityVerificationPage extends StatefulWidget {
  const S01DirectionalityVerificationPage({super.key});

  @override
  State<S01DirectionalityVerificationPage> createState() =>
      _S01DirectionalityVerificationPageState();
}

class _S01DirectionalityVerificationPageState
    extends State<S01DirectionalityVerificationPage> {
  _S01Scenario _scenario = _S01Scenario.precedence;
  GeniusPdfDirection _document = GeniusPdfDirection.rtl;
  GeniusPdfDirection _template = GeniusPdfDirection.auto;
  GeniusPdfDirection _component = GeniusPdfDirection.auto;
  GeniusPdfDirection _element = GeniusPdfDirection.auto;
  GeniusPdfValueKind _valueKind = GeniusPdfValueKind.money;
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _buildPdf();
  }

  GeniusPdfDirectionality get _directionality => GeniusPdfDirectionality(
        localeDirection: GeniusPdfDirection.rtl,
        documentDirection: _document,
        templateDirection: _template,
        componentDirection: _component,
        elementDirection: _element,
      );

  void _change(VoidCallback mutation) {
    mutation();
    setState(() {
      _pdfFuture = _buildPdf();
    });
  }

  void _regenerate() {
    setState(() {
      _pdfFuture = _buildPdf();
    });
  }

  Future<Uint8List> _buildPdf() async {
    final resolved = _directionality.resolve().direction;
    final config = geniusPdfConfig.copyWith(
      textDirection: resolved.isRtl ? TextDirection.rtl : TextDirection.ltr,
    );
    final builder = _S01DirectionalityDocument(
      config: config,
      directionality: _directionality,
      scenario: _scenario,
      valueKind: _valueKind,
    );
    final bytes = Uint8List.fromList(builder.generate());
    builder.dispose();
    return bytes;
  }

  String get _legacyJsonResult {
    final definition = TemplateDefinition.fromJson(<String, dynamic>{
      'id': 's01-legacy-json',
      'name': 'S01 Legacy JSON',
      'content': <dynamic>[],
      'pageSettings': <String, dynamic>{
        'pageSize': 'a4',
        'orientation': 'portrait',
      },
    });
    return 'template=${definition.direction.name}, '
        'page=${definition.pageSettings!.direction.name}';
  }

  String get _expected {
    final resolution = _directionality.resolve();
    final valueDirection = _directionality.resolveValue(_valueKind);
    return switch (_scenario) {
      _S01Scenario.precedence =>
        'Winner must follow element > component > template > document > '
            'locale > fallback. Current: ${resolution.direction.name} from '
            '${resolution.source.name}.',
      _S01Scenario.logicalGeometry =>
        'START must be ${resolution.isRtl ? 'right' : 'left'} and END must be '
            '${resolution.isRtl ? 'left' : 'right'}. Center stays centered.',
      _S01Scenario.valueMatrix =>
        'All structured ERP values keep source text and resolve LTR inside RTL.',
      _S01Scenario.mixedText =>
        '${_valueKind.name} resolves ${valueDirection.name}; IDs, money and '
            'email must not reverse.',
      _S01Scenario.nestedOverrides =>
        'Child overrides win by precedence without mutating the parent context.',
      _S01Scenario.longMultiPage =>
        'Preview must contain multiple long-content pages; ERP IDs and values '
            'remain unchanged across pages.',
      _S01Scenario.autoInheritance =>
        'AUTO is the inheritance/absence state. With upper scopes AUTO, locale '
            'RTL wins. Null direction is intentionally not public API.',
      _S01Scenario.legacyTemplateJson =>
        'Legacy template/page JSON without direction remains valid and both '
            'directions resolve AUTO. Current: $_legacyJsonResult.',
      _S01Scenario.mediaPolicy =>
        'RTL never mirrors media implicitly. preserve=false, explicit mirror=true.',
    };
  }

  String _scenarioLabel(_S01Scenario scenario) => switch (scenario) {
        _S01Scenario.precedence => 'Resolver precedence',
        _S01Scenario.logicalGeometry => 'Logical geometry',
        _S01Scenario.valueMatrix => 'ERP value matrix',
        _S01Scenario.mixedText => 'Mixed Arabic / Latin',
        _S01Scenario.nestedOverrides => 'Nested overrides',
        _S01Scenario.longMultiPage => 'Long + multi-page',
        _S01Scenario.autoInheritance => 'AUTO inheritance',
        _S01Scenario.legacyTemplateJson => 'Legacy template JSON',
        _S01Scenario.mediaPolicy => 'Media preserve policy',
      };

  Widget _directionField(
    String label,
    GeniusPdfDirection value,
    ValueChanged<GeniusPdfDirection> onChanged,
  ) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<GeniusPdfDirection>(
        key: ValueKey('$label-${value.name}'),
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: GeniusPdfDirection.values
            .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
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
                    'Sprint S01 — Directionality Core',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manual acceptance for precedence, logical geometry, BiDi '
                    'ERP values, nested inheritance, long/multi-page output, '
                    'legacy JSON and media policy using real public APIs.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 230,
                        child: DropdownButtonFormField<_S01Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S01Scenario.values
                              .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(_scenarioLabel(s)),
                                  ))
                              .toList(),
                          onChanged: (next) {
                            if (next != null) {
                              _change(() {
                                _scenario = next;
                              });
                            }
                          },
                        ),
                      ),
                      _directionField('Document', _document, (value) {
                        _change(() {
                          _document = value;
                        });
                      }),
                      _directionField('Template', _template, (value) {
                        _change(() {
                          _template = value;
                        });
                      }),
                      _directionField('Component', _component, (value) {
                        _change(() {
                          _component = value;
                        });
                      }),
                      _directionField('Element', _element, (value) {
                        _change(() {
                          _element = value;
                        });
                      }),
                      SizedBox(
                        width: 220,
                        child: DropdownButtonFormField<GeniusPdfValueKind>(
                          key: ValueKey(_valueKind),
                          initialValue: _valueKind,
                          decoration: const InputDecoration(
                            labelText: 'Value kind',
                            border: OutlineInputBorder(),
                          ),
                          items: GeniusPdfValueKind.values
                              .map((kind) => DropdownMenuItem(
                                    value: kind,
                                    child: Text(kind.name),
                                  ))
                              .toList(),
                          onChanged: (next) {
                            if (next != null) {
                              _change(() {
                                _valueKind = next;
                              });
                            }
                          },
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _regenerate,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _buildPdf,
                        fileName: 's01_directionality.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Expected Result: $_expected'),
                    ),
                  ),
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
                    return Center(child: SelectableText('${snapshot.error}'));
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

class _S01DirectionalityDocument extends GeniusPdfDocumentBuilder {
  _S01DirectionalityDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
    required this.valueKind,
  }) : super(config, directionality: directionality);

  final _S01Scenario scenario;
  final GeniusPdfValueKind valueKind;

  GeniusPdfResolvedDirection get _resolved => directionality.resolve().direction;

  PdfTextDirection _pdfDirection(GeniusPdfResolvedDirection direction) =>
      direction.isRtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight;

  @override
  void build() {
    switch (scenario) {
      case _S01Scenario.precedence:
        _precedence();
      case _S01Scenario.logicalGeometry:
        _geometry();
      case _S01Scenario.valueMatrix:
        _values();
      case _S01Scenario.mixedText:
        _mixed();
      case _S01Scenario.nestedOverrides:
        _nested();
      case _S01Scenario.longMultiPage:
        _longPages();
      case _S01Scenario.autoInheritance:
        _auto();
      case _S01Scenario.legacyTemplateJson:
        _legacyJson();
      case _S01Scenario.mediaPolicy:
        _media();
    }
  }

  void _title(String value) {
    addLine(value, font: config.boldFont, topMargin: 0);
    addSpace(12);
  }

  void _precedence() {
    newPage();
    final result = directionality.resolve();
    _title('S01 — Resolver precedence');
    addLine('Resolved: ${result.direction.name} from ${result.source.name}');
    for (final entry in <(String, GeniusPdfDirection)>[
      ('element', directionality.elementDirection),
      ('component', directionality.componentDirection),
      ('template', directionality.templateDirection),
      ('document', directionality.documentDirection),
      ('locale', directionality.localeDirection),
    ]) {
      addLine('${entry.$1}: ${entry.$2.name}', topMargin: 5);
    }
    addSpace(12);
    _logicalBoxes(_resolved);
  }

  void _geometry() {
    newPage();
    _title('S01 — Logical geometry');
    _logicalBoxes(_resolved);
    addSpace(70);
    final insets = const GeniusPdfDirectionalInsets(
      start: 12,
      top: 4,
      end: 28,
      bottom: 6,
    ).resolve(_resolved);
    addLine('Insets => left=${insets.left}, right=${insets.right}, '
        'top=${insets.top}, bottom=${insets.bottom}');
  }

  void _logicalBoxes(GeniusPdfResolvedDirection direction) {
    const width = 130.0;
    final y = currentY;
    for (final item in <(GeniusPdfLogicalAlignment, String)>[
      (GeniusPdfLogicalAlignment.start, 'START'),
      (GeniusPdfLogicalAlignment.center, 'CENTER'),
      (GeniusPdfLogicalAlignment.end, 'END'),
    ]) {
      final x = GeniusPdfLogicalGeometry.resolveX(
        containerX: 0,
        containerWidth: pageWidth,
        itemWidth: width,
        alignment: item.$1,
        direction: direction,
      );
      currentPage.graphics.drawRectangle(
        pen: PdfPen(PdfColor(90, 90, 90)),
        bounds: Rect.fromLTWH(x, y, width, 48),
      );
      currentPage.graphics.drawString(
        item.$2,
        config.boldFont,
        bounds: Rect.fromLTWH(x + 6, y + 12, width - 12, 22),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _pdfDirection(direction),
        ),
      );
    }
  }

  void _values() {
    newPage();
    _title('S01 — ERP value matrix');
    const values = <(String, String, GeniusPdfValueKind)>[
      ('Money', '15,697.50 SAR', GeniusPdfValueKind.money),
      ('Percentage', '15.00%', GeniusPdfValueKind.percentage),
      ('Quantity', '1,250.500 KG', GeniusPdfValueKind.quantity),
      ('Date', '2026-09-03', GeniusPdfValueKind.date),
      ('Time', '09:45:20', GeniusPdfValueKind.time),
      ('Document', 'INV-2026-000123', GeniusPdfValueKind.documentNumber),
      ('SKU', 'SKU-AR-ENG-001', GeniusPdfValueKind.sku),
      ('Serial', 'SN-AZ09-998877', GeniusPdfValueKind.serial),
      ('Batch', 'BATCH-2026-09-A', GeniusPdfValueKind.batch),
      ('IBAN', 'SA0380000000608010167519', GeniusPdfValueKind.iban),
      ('SWIFT', 'RJHISARIXXX', GeniusPdfValueKind.swift),
      ('Tax ID', '310123456700003', GeniusPdfValueKind.taxId),
      ('Phone', '+966 55 123 4567', GeniusPdfValueKind.phone),
      ('Email', 'accounts@example.test', GeniusPdfValueKind.email),
      ('URL', 'https://erp.example.test/INV-2026-000123',
          GeniusPdfValueKind.url),
    ];
    for (final item in values) {
      final run = GeniusPdfDirectedTextRun(item.$2, kind: item.$3);
      final runDirection = run.resolveDirection(directionality);
      addLine('${item.$1}: ${run.text}', topMargin: 6);
      addLine('runDirection=${runDirection.name}', topMargin: 2);
    }
  }

  void _mixed() {
    newPage();
    _title('S01 — Mixed Arabic / Latin');
    const source =
        'رقم المستند INV-2026-000123 — الإجمالي 15,697.50 SAR — '
        'accounts@example.test';
    final run = GeniusPdfDirectedTextRun(source, kind: valueKind);
    final runDirection = run.resolveDirection(directionality);
    currentPage.graphics.drawString(
      run.text,
      config.baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 90),
      format: PdfStringFormat(
        alignment: runDirection.isRtl
            ? PdfTextAlignment.right
            : PdfTextAlignment.left,
        textDirection: _pdfDirection(runDirection),
      ),
    );
    addSpace(95);
    addLine('Resolved run: ${runDirection.name}');
  }

  void _nested() {
    newPage();
    _title('S01 — Nested overrides');
    final parent = directionality;
    final component = parent.forComponent(GeniusPdfDirection.ltr);
    final inherited = component.forElement(GeniusPdfDirection.auto);
    final rtlChild = component.forElement(GeniusPdfDirection.rtl);
    for (final item in <(String, GeniusPdfDirectionality)>[
      ('Parent', parent),
      ('Component LTR', component),
      ('Element AUTO', inherited),
      ('Element RTL', rtlChild),
    ]) {
      final result = item.$2.resolve();
      addLine('${item.$1}: ${result.direction.name} / ${result.source.name}',
          topMargin: 8);
    }
  }

  void _longPages() {
    const ar =
        'هذا نص عربي طويل لاختبار الاتجاه عبر صفحات متعددة مع '
        'INV-2026-000123 و 15,697.50 SAR و accounts@example.test. ';
    const en =
        'Long directionality content across multiple pages with '
        'INV-2026-000123, 15,697.50 SAR and accounts@example.test. ';
    for (var page = 0; page < 3; page++) {
      newPage();
      _title('S01 — Long / multi-page ${page + 1}/3');
      for (var row = 0; row < 8; row++) {
        addLine(_resolved.isRtl ? '$ar$ar' : '$en$en', topMargin: 7);
      }
    }
  }

  void _auto() {
    newPage();
    _title('S01 — AUTO inheritance');
    const context = GeniusPdfDirectionality(
      localeDirection: GeniusPdfDirection.rtl,
      documentDirection: GeniusPdfDirection.auto,
      templateDirection: GeniusPdfDirection.auto,
      componentDirection: GeniusPdfDirection.auto,
      elementDirection: GeniusPdfDirection.auto,
    );
    final result = context.resolve();
    addLine('Resolved: ${result.direction.name} from ${result.source.name}');
    addSpace(12);
    _logicalBoxes(result.direction);
  }

  void _legacyJson() {
    newPage();
    _title('S01 — Legacy Template JSON');
    final definition = TemplateDefinition.fromJson(<String, dynamic>{
      'id': 'legacy',
      'name': 'Legacy',
      'content': <dynamic>[],
      'pageSettings': <String, dynamic>{
        'pageSize': 'a4',
        'orientation': 'portrait',
      },
    });
    addLine('Template direction: ${definition.direction.name}');
    addLine('Page direction: ${definition.pageSettings!.direction.name}',
        topMargin: 8);
  }

  void _media() {
    newPage();
    _title('S01 — Media mirroring policy');
    final defaultValue = GeniusPdfLogicalGeometry.shouldMirrorMedia();
    final preserve = GeniusPdfLogicalGeometry.shouldMirrorMedia(
      policy: GeniusPdfMediaMirroringPolicy.preserve,
    );
    final mirror = GeniusPdfLogicalGeometry.shouldMirrorMedia(
      policy: GeniusPdfMediaMirroringPolicy.mirror,
    );
    addLine('Document: ${_resolved.name}');
    addLine('Default mirrored: $defaultValue', topMargin: 8);
    addLine('Preserve mirrored: $preserve', topMargin: 8);
    addLine('Explicit mirror: $mirror', topMargin: 8);
  }
}
