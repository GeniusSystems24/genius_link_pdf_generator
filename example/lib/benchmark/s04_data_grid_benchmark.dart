import 'dart:typed_data';

import 'package:flutter/material.dart' show TextDirection, debugPrint;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfConfig _config() {
  final font = PdfStandardFont(PdfFontFamily.helvetica, 10);
  return GeniusPdfConfig(
    baseFontBytes: Uint8List(0),
    baseFont: font,
    boldFont: font,
    headerFont: font,
    smallFont: font,
    textDirection: TextDirection.ltr,
  );
}

void main() {
  const columns = [
    GeniusPdfGridColumn(id: 'id', title: 'ID'),
    GeniusPdfGridColumn(id: 'sku', title: 'SKU'),
    GeniusPdfGridColumn(id: 'qty', title: 'Qty', isNumeric: true),
    GeniusPdfGridColumn(id: 'amount', title: 'Amount', isNumeric: true),
  ];

  for (final rowCount in <int>[1000, 10000]) {
    final grid = GeniusPdfDataGridVNext(
      config: _config(),
      columns: columns,
      rowSource: GeniusPdfGridLazyRowSource(
        length: rowCount,
        builder: (index) => GeniusPdfGridRow(
          cells: {
            'id': 'ROW-$index',
            'sku': 'SKU-${index.toString().padLeft(6, '0')}',
            'qty': index % 100,
            'amount': index * 12.75,
          },
        ),
      ),
      columnPolicies: const {
        'id': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.autoFit,
        ),
        'sku': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.autoFit,
        ),
        'qty': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.fixed,
          fixedWidth: 60,
          valueKind: GeniusPdfGridValueKind.quantity,
        ),
        'amount': GeniusPdfGridColumnPolicy(
          widthMode: GeniusPdfGridWidthMode.flex,
          flex: 2,
          valueKind: GeniusPdfGridValueKind.money,
          currencyCode: 'SAR',
        ),
      },
      performance: const GeniusPdfGridPerformanceOptions(
        veryLargeDataMode: true,
        autoFitSampleSize: 100,
        cacheMeasuredWidths: true,
        cacheResolvedStyles: true,
      ),
    );

    GeniusPdfDataGridVNext.clearWidthCache();
    final cold = grid.benchmark(
      availableWidth: 540,
      rowLimit: rowCount,
    );
    final warm = grid.benchmark(
      availableWidth: 540,
      rowLimit: rowCount,
    );

    debugPrint('S04 $rowCount rows cold: $cold');
    debugPrint('S04 $rowCount rows warm: $warm');
  }
}
