
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S03Scenario {
  onePage,
  fiftyRows,
  fiveHundredRows,
  keepTogether,
  repeatedHeaders,
  longNotes,
  pageMetadata,
  customLandscape,
  compatibilityAdapter,
}

class S03FlowLayoutVerificationPage extends StatefulWidget {
  const S03FlowLayoutVerificationPage({super.key});

  @override
  State<S03FlowLayoutVerificationPage> createState() =>
      _S03FlowLayoutVerificationPageState();
}

class _S03FlowLayoutVerificationPageState
    extends State<S03FlowLayoutVerificationPage> {
  _S03Scenario _scenario = _S03Scenario.onePage;
  GeniusPdfDirection _direction = GeniusPdfDirection.ltr;
  late Future<Uint8List> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _generate();
  }

  void _change(VoidCallback mutation) {
    mutation();
    setState(() {
      _pdfFuture = _generate();
    });
  }

  String _scenarioLabel(_S03Scenario value) => switch (value) {
        _S03Scenario.onePage => '1-page document',
        _S03Scenario.fiftyRows => '50 rows / multi-page',
        _S03Scenario.fiveHundredRows => '500-row stress',
        _S03Scenario.keepTogether => 'Keep together / keep with next',
        _S03Scenario.repeatedHeaders => 'Repeated headers / footers',
        _S03Scenario.longNotes => 'Very long notes + orphan/widow',
        _S03Scenario.pageMetadata => 'Page X of Y / variants / markers',
        _S03Scenario.customLandscape => 'Custom landscape page',
        _S03Scenario.compatibilityAdapter => 'Legacy callback adapter',
      };

  String get _expected => switch (_scenario) {
        _S03Scenario.onePage =>
          'All rows remain on exactly one page. currentY advances '
              'monotonically and no empty trailing page is created.',
        _S03Scenario.fiftyRows =>
          'Rows paginate automatically. No row overlaps the footer and '
              'the Page X of Y footer repeats.',
        _S03Scenario.fiveHundredRows =>
          'The same flow API handles 500 rows without performing drawing '
              'during the measurement pass. Output spans many pages deterministically.',
        _S03Scenario.keepTogether =>
          'The Keep Together card moves as one unit when it cannot fit near '
              'the page end. The heading using keepWithNext stays with its detail block.',
        _S03Scenario.repeatedHeaders =>
          'Section/table header bands appear on every page and the footer '
              'shows Page X of Y. RTL/LTR changes text direction, not page count.',
        _S03Scenario.longNotes =>
          'Long notes split across pages with at least two lines kept at the '
              'bottom/top around a split whenever possible.',
        _S03Scenario.pageMetadata =>
          'Page 1 uses the first-page header; later pages use the normal '
              'header; the final page uses the last-page footer. ORIGINAL/COPY '
              'marker and page numbers remain visible.',
        _S03Scenario.customLandscape =>
          'Every page in the section uses the custom landscape size. '
              'Later legacy pages are not permanently changed by the section setting.',
        _S03Scenario.compatibilityAdapter =>
          'A callback using the existing (PdfPage, Rect) signature renders '
              'inside the new flow engine without changing the old callback API.',
      };

  Future<Uint8List> _generate() async {
    final directionality = GeniusPdfDirectionality(
      documentDirection: _direction,
    );
    final config = geniusPdfConfig.copyWith(
      textDirection: _direction == GeniusPdfDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
    );

    final builder = _S03FlowDemoDocument(
      config: config,
      directionality: directionality,
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
                    'Sprint S03 — Flow Layout & Pagination',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manual acceptance harness for blocks, bands, two-pass '
                    'measurement, pagination policies, repeated headers, page '
                    'metadata, custom page sizes and compatibility adapters.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<_S03Scenario>(
                          key: ValueKey(_scenario),
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: _S03Scenario.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_scenarioLabel(value)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            _change(() {
                              _scenario = value;
                            });
                          },
                        ),
                      ),
                      SegmentedButton<GeniusPdfDirection>(
                        segments: const [
                          ButtonSegment(
                            value: GeniusPdfDirection.ltr,
                            label: Text('LTR'),
                          ),
                          ButtonSegment(
                            value: GeniusPdfDirection.rtl,
                            label: Text('RTL'),
                          ),
                        ],
                        selected: {_direction},
                        onSelectionChanged: (selection) {
                          _change(() {
                            _direction = selection.first;
                          });
                        },
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
                        fileName: 's03_flow_layout.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
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
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                        textAlign: TextAlign.center,
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

class _S03FlowDemoDocument extends GeniusPdfDocumentBuilder {
  _S03FlowDemoDocument({
    required GeniusPdfConfig config,
    required GeniusPdfDirectionality directionality,
    required this.scenario,
  }) : super(config, directionality: directionality);

  final _S03Scenario scenario;

  bool get _rtl =>
      directionality.resolve().direction ==
      GeniusPdfResolvedDirection.rtl;

  String _rowText(int index) => _rtl
      ? 'السطر ${index + 1} — INV-2026-${(index + 1).toString().padLeft(5, '0')} — 15,697.50 SAR'
      : 'Row ${index + 1} — INV-2026-${(index + 1).toString().padLeft(5, '0')} — 15,697.50 SAR';

  PdfTextBand _header({
    String id = 'page-header',
    String text = 'ERP FLOW REPORT',
    String textAr = 'تقرير تدفق ERP',
  }) {
    return PdfTextBand(
      id: id,
      text: text,
      textAr: textAr,
      height: 28,
      placement: PdfBandPlacement.top,
      kind: PdfBandKind.pageHeader,
      font: config.boldFont,
    );
  }

  PdfPageNumberBand _pageNumbers() {
    return const PdfPageNumberBand(
      id: 'page-x-of-y',
      scope: PdfPageNumberScope.section,
      height: 22,
    );
  }

  List<PdfBlock> _rows(
    int count, {
    double padding = 2,
  }) {
    return List<PdfBlock>.generate(
      count,
      (index) => PdfTextBlock(
        id: 'row-$index',
        text: _rowText(index),
        paddingTop: padding,
        paddingBottom: padding,
        minOrphanLines: 1,
        minWidowLines: 1,
      ),
    );
  }

  @override
  void build() {
    switch (scenario) {
      case _S03Scenario.onePage:
        addFlowSection(
          PdfFlowSection(
            id: 'one-page',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            blocks: _rows(12),
          ),
        );
        return;

      case _S03Scenario.fiftyRows:
        addFlowSection(
          PdfFlowSection(
            id: 'fifty-rows',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            blocks: _rows(50),
          ),
        );
        return;

      case _S03Scenario.fiveHundredRows:
        addFlowSection(
          PdfFlowSection(
            id: 'five-hundred-rows',
            directionality: directionality,
            pageHeader: _header(
              text: '500 ROW STRESS FLOW',
              textAr: 'اختبار تدفق 500 سطر',
            ),
            pageFooter: _pageNumbers(),
            blocks: _rows(500, padding: 1),
          ),
        );
        return;

      case _S03Scenario.keepTogether:
        addFlowSection(
          PdfFlowSection(
            id: 'keep-together',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            blocks: [
              ..._rows(28),
              PdfKeepTogether(
                PdfCallbackBlock(
                  id: 'keep-together-card',
                  measureCallback: (_) =>
                      const PdfBlockMeasurement(height: 125),
                  renderCallback: (context) {
                    context.page.graphics.drawRectangle(
                      pen: PdfPen(PdfColor(80, 80, 80)),
                      bounds: context.bounds,
                    );
                    context.page.graphics.drawString(
                      _rtl
                          ? 'هذه البطاقة يجب أن تبقى كاملة في صفحة واحدة'
                          : 'This card must remain together on one page',
                      config.boldFont,
                      bounds: context.bounds.deflate(10),
                      format: PdfStringFormat(
                        alignment: _rtl
                            ? PdfTextAlignment.right
                            : PdfTextAlignment.left,
                        textDirection: _rtl
                            ? PdfTextDirection.rightToLeft
                            : PdfTextDirection.leftToRight,
                      ),
                    );
                    return const PdfBlockRenderResult(
                      usedHeight: 125,
                    );
                  },
                ),
              ),
              PdfTextBlock(
                id: 'keep-with-next-heading',
                text: _rtl ? 'عنوان القسم' : 'Section heading',
                font: config.boldFont,
                breakPolicy: const PdfPageBreakPolicy(
                  keepWithNext: true,
                ),
              ),
              PdfFixedBlock(
                id: 'keep-with-next-detail',
                height: 100,
                renderer: (context) {
                  context.page.graphics.drawRectangle(
                    pen: PdfPen(PdfColor(120, 120, 120)),
                    bounds: context.bounds,
                  );
                  return const PdfBlockRenderResult(
                    usedHeight: 100,
                  );
                },
              ),
            ],
          ),
        );
        return;

      case _S03Scenario.repeatedHeaders:
        addFlowSection(
          PdfFlowSection(
            id: 'repeated',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            repeatableBands: [
              PdfRepeatableBand(
                id: 'table-header',
                placement: PdfBandPlacement.top,
                kind: PdfBandKind.tableHeader,
                child: PdfTextBand(
                  text: 'Item | Document | Amount',
                  textAr: 'الصنف | المستند | المبلغ',
                  height: 24,
                  placement: PdfBandPlacement.top,
                  kind: PdfBandKind.tableHeader,
                  font: config.boldFont,
                ),
              ),
            ],
            blocks: _rows(90),
          ),
        );
        return;

      case _S03Scenario.longNotes:
        final note = _rtl
            ? List<String>.filled(
                180,
                'هذه ملاحظة عربية طويلة لاختبار تقسيم النص وحماية الأسطر '
                    'حول فاصل الصفحة مع الحفاظ على INV-2026-000123 و '
                    '15,697.50 SAR.',
              ).join(' ')
            : List<String>.filled(
                180,
                'This is a long ERP note that verifies wrapping, page splitting '
                    'and orphan/widow protection while preserving '
                    'INV-2026-000123 and 15,697.50 SAR.',
              ).join(' ');

        addFlowSection(
          PdfFlowSection(
            id: 'long-notes',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            blocks: [
              PdfTextBlock(
                id: 'long-note',
                text: note,
                minOrphanLines: 2,
                minWidowLines: 2,
              ),
            ],
          ),
        );
        return;

      case _S03Scenario.pageMetadata:
        addFlowSection(
          PdfFlowSection(
            id: 'metadata',
            directionality: directionality,
            firstPageHeader: _header(
              id: 'first-page-header',
              text: 'FIRST PAGE — ERP DOCUMENT',
              textAr: 'الصفحة الأولى — مستند ERP',
            ),
            pageHeader: _header(
              id: 'normal-page-header',
              text: 'CONTINUED ERP DOCUMENT',
              textAr: 'متابعة مستند ERP',
            ),
            pageFooter: _pageNumbers(),
            lastPageFooter: PdfTextBand(
              id: 'last-page-footer',
              text: 'END OF DOCUMENT',
              textAr: 'نهاية المستند',
              height: 24,
              placement: PdfBandPlacement.bottom,
              kind: PdfBandKind.pageFooter,
              font: config.boldFont,
              alignment: GeniusPdfLogicalAlignment.center,
            ),
            repeatableBands: const [
              PdfRepeatableBand(
                id: 'original-marker',
                placement: PdfBandPlacement.top,
                kind: PdfBandKind.documentMarker,
                child: PdfDocumentMarkerBand(
                  text: 'ORIGINAL',
                  textAr: 'أصل',
                  placement: PdfBandPlacement.top,
                ),
              ),
              PdfRepeatableBand(
                id: 'page-number-repeat',
                placement: PdfBandPlacement.bottom,
                kind: PdfBandKind.pageFooter,
                child: PdfPageNumberBand(),
              ),
            ],
            documentStatus: 'POSTED',
            copyLabel: _rtl ? 'أصل' : 'ORIGINAL',
            blocks: _rows(75),
          ),
        );
        return;

      case _S03Scenario.customLandscape:
        addFlowSection(
          PdfFlowSection(
            id: 'custom-landscape',
            directionality: directionality,
            pageSpec: const PdfFlowPageSpec(
              size: Size(420, 595),
              orientation: PdfPageOrientation.landscape,
            ),
            pageHeader: _header(
              text: 'CUSTOM LANDSCAPE SECTION',
              textAr: 'قسم أفقي مخصص',
            ),
            pageFooter: _pageNumbers(),
            blocks: _rows(55),
          ),
        );
        return;

      case _S03Scenario.compatibilityAdapter:
        addFlowSection(
          PdfFlowSection(
            id: 'legacy-adapter',
            directionality: directionality,
            pageHeader: _header(),
            pageFooter: _pageNumbers(),
            blocks: [
              PdfLegacyCallbackBlock(
                id: 'legacy-callback',
                estimatedHeight: 100,
                callback: (page, bounds) {
                  page.graphics.drawRectangle(
                    pen: PdfPen(PdfColor(60, 60, 60)),
                    bounds: bounds,
                  );
                  page.graphics.drawString(
                    _rtl
                        ? 'تم الرسم باستخدام callback القديم (PdfPage, Rect)'
                        : 'Rendered with the legacy (PdfPage, Rect) callback',
                    config.boldFont,
                    bounds: bounds.deflate(12),
                    format: PdfStringFormat(
                      alignment: _rtl
                          ? PdfTextAlignment.right
                          : PdfTextAlignment.left,
                      textDirection: _rtl
                          ? PdfTextDirection.rightToLeft
                          : PdfTextDirection.leftToRight,
                    ),
                  );
                  return 100;
                },
              ),
            ],
          ),
        );
        return;
    }
  }
}
