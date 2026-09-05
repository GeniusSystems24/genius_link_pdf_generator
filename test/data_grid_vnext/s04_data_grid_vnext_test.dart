import 'dart:typed_data';

import 'package:flutter/material.dart' show TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
GeniusPdfConfig _config({
  TextDirection direction = TextDirection.ltr,
}) {
  final font = PdfStandardFont(PdfFontFamily.helvetica, 10);
  return GeniusPdfConfig(
    baseFontBytes: Uint8List(0),
    baseFont: font,
    boldFont: PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    ),
    headerFont: font,
    smallFont: font,
    textDirection: direction,
  );
}

List<GeniusPdfGridColumn> _columns() => const [
      GeniusPdfGridColumn(
        id: 'name',
        title: 'Name',
        titleAr: 'الاسم',
      ),
      GeniusPdfGridColumn(
        id: 'qty',
        title: 'Qty',
        titleAr: 'الكمية',
        isNumeric: true,
      ),
      GeniusPdfGridColumn(
        id: 'amount',
        title: 'Amount',
        titleAr: 'المبلغ',
        isNumeric: true,
      ),
    ];

List<GeniusPdfGridRow> _rows(int count) {
  return List<GeniusPdfGridRow>.generate(
    count,
    (index) => GeniusPdfGridRow(
      cells: {
        'name': 'Item $index',
        'qty': index + 1,
        'amount': (index + 1) * 10.5,
      },
    ),
  );
}

void main() {
  group('S04 DataGrid vNext', () {
    test('T01..T04 fixed/flex/min/max/auto-fit and cache', () {
      final grid = GeniusPdfDataGridVNext(
        config: _config(),
        columns: _columns(),
        rows: _rows(20),
        columnPolicies: const {
          'name': GeniusPdfGridColumnPolicy(
            widthMode: GeniusPdfGridWidthMode.autoFit,
            minWidth: 90,
            maxWidth: 180,
          ),
          'qty': GeniusPdfGridColumnPolicy(
            widthMode: GeniusPdfGridWidthMode.fixed,
            fixedWidth: 60,
          ),
          'amount': GeniusPdfGridColumnPolicy(
            widthMode: GeniusPdfGridWidthMode.flex,
            flex: 2,
            minWidth: 80,
          ),
        },
      );

      GeniusPdfDataGridVNext.clearWidthCache();
      final first = grid.benchmark(availableWidth: 500);
      final second = grid.benchmark(availableWidth: 500);

      expect(first.preparedRows, 20);
      expect(first.measuredColumnCount, greaterThanOrEqualTo(1));
      expect(second.widthCacheHit, isTrue);
    });

    test('T14..T20 summary expressions calculate ERP totals', () {
      const expression = GeniusPdfGridSummaryExpression.sum(
        outputColumnId: 'amount',
        sourceColumnId: 'amount',
        label: 'Total',
        labelAr: 'الإجمالي',
        labelColumnId: 'name',
      );

      expect(expression.evaluate(_rows(3)), 63.0);
    });

    test('T21/T22 span model supports row and column spans', () {
      const span = GeniusPdfGridCellSpan(
        rowIndex: 0,
        columnId: 'name',
        rowSpan: 2,
        columnSpan: 2,
      );
      expect(span.rowSpan, 2);
      expect(span.columnSpan, 2);
    });

    test('T23..T26 builder/style callbacks are public and usable', () {
      var rowBuilderCalls = 0;
      var cellBuilderCalls = 0;
      var rowStyleCalls = 0;
      var cellStyleCalls = 0;

      final grid = GeniusPdfDataGridVNext(
        config: _config(),
        columns: _columns(),
        rows: _rows(4),
        rowBuilder: (context) {
          rowBuilderCalls++;
          return context.row;
        },
        rowStyleBuilder: (context) {
          rowStyleCalls++;
          return null;
        },
        cellBuilder: (context) {
          cellBuilderCalls++;
          return null;
        },
        cellStyleBuilder: (context) {
          cellStyleCalls++;
          return null;
        },
      );

      grid.benchmark(availableWidth: 500);
      expect(rowBuilderCalls, 4);
      expect(rowStyleCalls, 4);
      expect(cellBuilderCalls, 12);
      expect(cellStyleCalls, 12);
    });

    test('T28..T34 formatter hooks and per-row currency are used', () {
      var moneyCalls = 0;

      final grid = GeniusPdfDataGridVNext(
        config: _config(),
        columns: _columns(),
        rows: [
          const GeniusPdfGridRow(
            cells: {
              'name': 'A',
              'qty': 1,
              'amount': -1250.0,
              'currency': 'SAR',
            },
          ),
        ],
        columnPolicies: {
          'amount': GeniusPdfGridColumnPolicy(
            valueKind: GeniusPdfGridValueKind.money,
            accountingNegative: true,
            currencyResolver: (row) =>
                row.cells['currency']?.toString(),
          ),
        },
        formatters: GeniusPdfGridFormatterHooks(
          money: (context) {
            moneyCalls++;
            return '${context.value} ${context.currencyCode}';
          },
        ),
      );

      grid.benchmark(availableWidth: 500);
      expect(moneyCalls, greaterThan(0));
    });

    test('T35 direction policy preserves public flags', () {
      final grid = GeniusPdfDataGridVNext(
        config: _config(direction: TextDirection.rtl),
        columns: _columns(),
        rows: _rows(1),
        followDirection: true,
        preserveDefinitionOrder: true,
      );
      expect(grid.followDirection, isTrue);
      expect(grid.preserveDefinitionOrder, isTrue);
    });

    test('T40..T44 lazy 10k source is not built in constructor', () {
      var built = 0;
      final grid = GeniusPdfDataGridVNext(
        config: _config(),
        columns: _columns(),
        rowSource: GeniusPdfGridLazyRowSource(
          length: 10000,
          builder: (index) {
            built++;
            return GeniusPdfGridRow(
              cells: {
                'name': 'Item $index',
                'qty': index,
                'amount': index * 1.25,
              },
            );
          },
        ),
        performance: const GeniusPdfGridPerformanceOptions(
          veryLargeDataMode: true,
          autoFitSampleSize: 50,
        ),
      );

      expect(built, 0);
      final result = grid.benchmark(
        availableWidth: 500,
        rowLimit: 1000,
      );
      expect(result.preparedRows, 1000);
      expect(built, 1000);
    });
  });
}
