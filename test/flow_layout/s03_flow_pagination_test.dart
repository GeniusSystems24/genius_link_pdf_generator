
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

class _FlowTestBuilder extends GeniusPdfDocumentBuilder {
  _FlowTestBuilder(
    super.config, {
    super.directionality,
  });

  @override
  void build() {}
}

GeniusPdfConfig _config({
  TextDirection direction = TextDirection.ltr,
}) {
  final font = PdfStandardFont(
    PdfFontFamily.helvetica,
    10,
  );
  return GeniusPdfConfig(
    baseFontBytes: Uint8List(0),
    baseFont: font,
    boldFont: PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    ),
    smallFont: PdfStandardFont(
      PdfFontFamily.helvetica,
      8,
    ),
    textDirection: direction,
  );
}

PdfFlowSection _fixedRows(
  int count, {
  double height = 24,
  PdfBand? pageHeader,
  PdfBand? pageFooter,
  PdfBand? firstPageHeader,
  PdfBand? lastPageFooter,
  List<PdfRepeatableBand> repeatableBands = const [],
  PdfFlowPageSpec pageSpec = const PdfFlowPageSpec(),
}) {
  return PdfFlowSection(
    pageSpec: pageSpec,
    pageHeader: pageHeader,
    pageFooter: pageFooter,
    firstPageHeader: firstPageHeader,
    lastPageFooter: lastPageFooter,
    repeatableBands: repeatableBands,
    blocks: List<PdfBlock>.generate(
      count,
      (index) => PdfFixedBlock(
        id: 'row-$index',
        height: height,
      ),
    ),
  );
}

void main() {
  test('S03-T29: one-page document stays on one page', () {
    final builder = _FlowTestBuilder(_config());
    final plan = builder.planFlowSection(_fixedRows(10));

    expect(plan.pageCount, 1);
    expect(plan.pages.single.blockIds.length, 10);
    builder.dispose();
  });

  test('S03-T30: 50 rows paginate deterministically', () {
    final builder = _FlowTestBuilder(_config());
    final plan = builder.planFlowSection(_fixedRows(50));

    expect(plan.pageCount, greaterThan(1));
    expect(
      plan.pages.fold<int>(
        0,
        (sum, page) => sum + page.blockIds.length,
      ),
      50,
    );
    builder.dispose();
  });

  test('S03-T31: 500-row stress plan does not render', () {
    final builder = _FlowTestBuilder(_config());
    var renderCount = 0;

    final section = PdfFlowSection(
      blocks: List<PdfBlock>.generate(
        500,
        (index) => PdfCallbackBlock(
          id: 'stress-$index',
          measureCallback: (_) =>
              const PdfBlockMeasurement(height: 18),
          renderCallback: (_) {
            renderCount++;
            return const PdfBlockRenderResult(
              usedHeight: 18,
            );
          },
        ),
      ),
    );

    final plan = builder.planFlowSection(section);
    expect(plan.pageCount, greaterThan(5));
    expect(renderCount, 0);
    expect(plan.measurementCount, greaterThan(0));
    builder.dispose();
  });

  test('S03-T32: very long notes split across pages', () {
    final builder = _FlowTestBuilder(_config());
    final longText = List<String>.filled(
      700,
      'Long ERP note with INV-2026-000123 and 15,697.50 SAR.',
    ).join(' ');

    final plan = builder.planFlowSection(
      PdfFlowSection(
        blocks: [
          PdfTextBlock(
            id: 'long-note',
            text: longText,
            minOrphanLines: 2,
            minWidowLines: 2,
          ),
        ],
      ),
    );

    expect(plan.pageCount, greaterThan(1));
    builder.dispose();
  });

  test('S03-T33: keepTogether moves near-end block to next page', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      PdfFlowSection(
        blocks: [
          const PdfFixedBlock(
            id: 'large-prefix',
            height: 700,
          ),
          PdfKeepTogether(
            const PdfFixedBlock(
              id: 'keep-card',
              height: 120,
            ),
          ),
        ],
      ),
    );

    expect(plan.pageCount, 2);
    expect(plan.pages.last.blockIds, contains('keep-card'));
    builder.dispose();
  });

  test('S03-T34: repeatable table header appears on every page', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      _fixedRows(
        80,
        repeatableBands: const [
          PdfRepeatableBand(
            id: 'table-header',
            placement: PdfBandPlacement.top,
            kind: PdfBandKind.tableHeader,
            child: PdfFixedBlock(height: 26),
          ),
        ],
      ),
    );

    expect(plan.pageCount, greaterThan(1));
    for (final page in plan.pages) {
      expect(page.headerBandIds, contains('table-header'));
    }
    builder.dispose();
  });

  test('S03-T35: RTL/LTR pagination parity', () {
    final ltrBuilder = _FlowTestBuilder(
      _config(direction: TextDirection.ltr),
      directionality: const GeniusPdfDirectionality(
        documentDirection: GeniusPdfDirection.ltr,
      ),
    );
    final rtlBuilder = _FlowTestBuilder(
      _config(direction: TextDirection.rtl),
      directionality: const GeniusPdfDirectionality(
        documentDirection: GeniusPdfDirection.rtl,
      ),
    );

    final section = _fixedRows(120, height: 21);
    final ltr = ltrBuilder.planFlowSection(section);
    final rtl = rtlBuilder.planFlowSection(section);

    expect(rtl.pageCount, ltr.pageCount);
    expect(
      rtl.pages.map((page) => page.blockIds.length).toList(),
      ltr.pages.map((page) => page.blockIds.length).toList(),
    );

    ltrBuilder.dispose();
    rtlBuilder.dispose();
  });

  test('S03-T36: custom landscape page size is planned', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      _fixedRows(
        20,
        pageSpec: const PdfFlowPageSpec(
          size: Size(300, 500),
          orientation: PdfPageOrientation.landscape,
        ),
      ),
    );

    expect(plan.pages.first.pageSize.width, 500);
    expect(plan.pages.first.pageSize.height, 300);
    expect(
      plan.pages.first.orientation,
      PdfPageOrientation.landscape,
    );
    builder.dispose();
  });

  test('keepWithNext moves pair when pair fits on empty page', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      const PdfFlowSection(
        blocks: [
          PdfFixedBlock(
            id: 'prefix',
            height: 680,
          ),
          PdfFixedBlock(
            id: 'heading',
            height: 60,
            breakPolicy: PdfPageBreakPolicy(
              keepWithNext: true,
            ),
          ),
          PdfFixedBlock(
            id: 'detail',
            height: 100,
          ),
        ],
      ),
    );

    expect(plan.pageCount, 2);
    expect(plan.pages.last.blockIds, containsAll(['heading', 'detail']));
    builder.dispose();
  });

  test('pageBreakBefore/pageBreakAfter policies are honored', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      const PdfFlowSection(
        blocks: [
          PdfFixedBlock(id: 'a', height: 40),
          PdfFixedBlock(
            id: 'b',
            height: 40,
            breakPolicy: PdfPageBreakPolicy(
              pageBreakBefore: true,
              pageBreakAfter: true,
            ),
          ),
          PdfFixedBlock(id: 'c', height: 40),
        ],
      ),
    );

    expect(plan.pageCount, 3);
    expect(plan.pages[0].blockIds, ['a']);
    expect(plan.pages[1].blockIds, ['b']);
    expect(plan.pages[2].blockIds, ['c']);
    builder.dispose();
  });

  test('conditional page break receives deterministic context', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      PdfFlowSection(
        blocks: [
          const PdfFixedBlock(id: 'a', height: 80),
          PdfFixedBlock(
            id: 'b',
            height: 80,
            breakPolicy: PdfPageBreakPolicy(
              breakBeforeWhen: (context) =>
                  context.usedHeight > 0,
            ),
          ),
        ],
      ),
    );

    expect(plan.pageCount, 2);
    builder.dispose();
  });

  test('two-pass layout never invokes render during planning', () {
    final builder = _FlowTestBuilder(_config());
    var measured = 0;
    var rendered = 0;

    final section = PdfFlowSection(
      blocks: [
        PdfCallbackBlock(
          id: 'callback',
          measureCallback: (_) {
            measured++;
            return const PdfBlockMeasurement(height: 40);
          },
          renderCallback: (_) {
            rendered++;
            return const PdfBlockRenderResult(
              usedHeight: 40,
            );
          },
        ),
      ],
    );

    final plan = builder.planFlowSection(section);
    expect(measured, 1);
    expect(rendered, 0);

    builder.addFlowSection(section, plan: plan);
    expect(rendered, 1);
    expect(builder.currentY, closeTo(40, 0.01));
    builder.dispose();
  });

  test('first-page header and last-page footer variants are planned', () {
    final builder = _FlowTestBuilder(_config());

    final plan = builder.planFlowSection(
      _fixedRows(
        80,
        pageHeader: const PdfTextBand(
          id: 'normal-header',
          text: 'Header',
          placement: PdfBandPlacement.top,
          kind: PdfBandKind.pageHeader,
        ),
        firstPageHeader: const PdfTextBand(
          id: 'first-header',
          text: 'First',
          placement: PdfBandPlacement.top,
          kind: PdfBandKind.pageHeader,
        ),
        pageFooter: const PdfPageNumberBand(
          id: 'normal-footer',
        ),
        lastPageFooter: const PdfTextBand(
          id: 'last-footer',
          text: 'Last footer',
          placement: PdfBandPlacement.bottom,
          kind: PdfBandKind.pageFooter,
        ),
      ),
    );

    expect(plan.pageCount, greaterThan(1));
    expect(plan.pages.first.headerBandIds, contains('first-header'));
    expect(plan.pages[1].headerBandIds, contains('normal-header'));
    expect(plan.pages.last.footerBandIds, contains('last-footer'));
    builder.dispose();
  });

  test('legacy PdfPage/Rect callback has a flow adapter', () {
    final builder = _FlowTestBuilder(_config());

    final section = PdfFlowSection(
      blocks: [
        PdfLegacyCallbackBlock(
          id: 'legacy',
          estimatedHeight: 35,
          callback: (page, bounds) => 35,
        ),
      ],
    );

    final plan = builder.planFlowSection(section);
    expect(plan.pages.single.blockIds, ['legacy']);
    builder.dispose();
  });
}
