
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S24Scenario {
  benchmark,
  cache,
  semantic,
  goldenManifest,
}

class S24PerformanceRegressionVerificationPage extends StatefulWidget {
  const S24PerformanceRegressionVerificationPage({super.key});

  @override
  State<S24PerformanceRegressionVerificationPage> createState() =>
      _S24PerformanceRegressionVerificationPageState();
}

class _S24PerformanceRegressionVerificationPageState
    extends State<S24PerformanceRegressionVerificationPage> {
  _S24Scenario _scenario = _S24Scenario.benchmark;
  bool _rtl = false;
  int _rows = 50;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S24Scenario value) => switch (value) {
        _S24Scenario.benchmark => 'Family Benchmark',
        _S24Scenario.cache => 'Resource / Measurement Cache',
        _S24Scenario.semantic => 'Semantic Regression',
        _S24Scenario.goldenManifest => 'Golden Coverage Manifest',
      };

  Future<String> _diagnostic() async {
    switch (_scenario) {
      case _S24Scenario.benchmark:
        const runner = GeniusPdfPerformanceBenchmarkRunner();
        final result = await runner.run(
          GeniusPdfBenchmarkCase(
            id: 'manual-family-benchmark',
            family: GeniusPdfBenchmarkFamily.transaction,
            iterations: 3,
            generate: () => List<int>.filled(_rows * 10, 1),
          ),
        );
        return 'iterations=${result.iterations}; '
            'avgMs=${result.averageMilliseconds.toStringAsFixed(3)}; '
            'bytes=${result.totalOutputBytes}';
      case _S24Scenario.cache:
        final cache = GeniusPdfMeasurementCache();
        var calls = 0;
        const key = GeniusPdfMeasurementKey(
          contentHash: 101,
          widthMicros: 300000,
          styleHash: 202,
          direction: 'auto',
        );
        for (var index = 0; index < _rows; index++) {
          cache.measure(key, () {
            calls++;
            return 40;
          });
        }
        return 'measurementCalls=$calls; cacheEntries=${cache.length}; '
            'requested=$_rows';
      case _S24Scenario.semantic:
        const checker = GeniusPdfSemanticRegression();
        final expectation = GeniusPdfSemanticRegression.erpDocument(
          documentNumber: 'INV-LATIN-001',
          party: _rtl ? 'عميل تجريبي' : 'Demo Customer',
          total: '1150.00',
          tax: '150.00',
          currency: 'SAR',
          pageNumber: '1/1',
          complianceMetadata: const ['UUID-DEMO-001'],
        );
        final source = [
          'INV-LATIN-001',
          _rtl ? 'عميل تجريبي' : 'Demo Customer',
          '1000.00',
          '150.00',
          '1150.00',
          'SAR',
          '1/1',
          'UUID-DEMO-001',
        ].join(' ');
        final result = checker.checkExtractedText(source, expectation);
        return 'semanticPass=${result.passed}; '
            'missing=${result.missing}; '
            'forbidden=${result.forbiddenFound}';
      case _S24Scenario.goldenManifest:
        final manifest = GeniusPdfGoldenManifest.core;
        return 'goldenCases=${manifest.cases.length}; '
            'directions=${GeniusPdfRegressionDirection.values.map((e) => e.name).join(',')}';
    }
  }

  Future<Uint8List> _generate() async {
    final diagnostic = await _diagnostic();
    final document = _S24VerificationDocument(
      _config,
      scenario: _label(_scenario),
      diagnostic: diagnostic,
      rows: _rows,
      rtl: _rtl,
    );
    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  void _refresh() {
    setState(() => _pdf = _generate());
  }

  String get _expected =>
      'Expected Result: ${_label(_scenario)} displays S24 public quality APIs. '
      'Repeated measurement uses one cached calculation, semantic fields '
      'remain discoverable, and benchmark values are measured rather than '
      'hard-coded performance claims. PDF preview must remain readable in '
      '${_rtl ? 'RTL' : 'LTR'} with $_rows generated verification rows.';

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
                    'Sprint S24 — Performance & Regression',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 270,
                        child: DropdownButtonFormField<_S24Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S24Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 50, label: Text('50')),
                          ButtonSegment(value: 500, label: Text('500')),
                        ],
                        selected: {_rows},
                        onSelectionChanged: (value) {
                          _rows = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's24_performance_regression.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
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

class _S24VerificationDocument extends GeniusPdfDocumentBuilder {
  _S24VerificationDocument(
    super.config, {
    required this.scenario,
    required this.diagnostic,
    required this.rows,
    required this.rtl,
  });

  final String scenario;
  final String diagnostic;
  final int rows;
  final bool rtl;

  @override
  void build() {
    newPage();
    addLine(
      'S24 — $scenario',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine(diagnostic);
    addLine(rtl ? 'الاتجاه: RTL' : 'Direction: LTR');
    addSpace(8);
    for (var index = 0; index < rows; index++) {
      addLine(
        rtl
            ? 'سطر تحقق ${index + 1} — INV-${index + 1} — 1150.00 SAR'
            : 'Verification row ${index + 1} — INV-${index + 1} — 1150.00 SAR',
        font: config.smallFont,
      );
    }
  }
}
