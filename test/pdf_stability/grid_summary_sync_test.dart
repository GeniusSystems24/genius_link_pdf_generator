import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'support/pdf_openability_assertions.dart';
import 'support/pdf_stability_fixtures.dart';

void main() {
  group('grid and summary synchronization', () {
    test('multi-page grid updates currentPage and currentY from layout result',
        () {
      final config = createTestConfig(pageSize: const Size(180, 180));
      final builder = TestPdfDocumentBuilder(config);
      final grid = createPagedGrid(config, rowCount: 72);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(12);
      builder.newPage();

      final result = builder.addGrid(grid);

      expect(result, isNotNull);
      expect(builder.document.pages.count, greaterThan(1));
      expect(builder.pageCount, builder.document.pages.count);
      expect(builder.currentPage, same(result!.page));
      expect(builder.currentY, result.bounds.bottom);
    });

    test('summary after multi-page grid stays on the final grid page or later',
        () {
      final config = createTestConfig(pageSize: const Size(180, 180));
      final builder = TestPdfDocumentBuilder(config);
      final grid = createPagedGrid(config, rowCount: 72);
      final summary = createSummary(config, itemCount: 6);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(12);
      builder.newPage();

      final gridResult = builder.addGrid(grid)!;
      final gridPageIndex = pageIndexOf(builder.document, gridResult.page);
      final summaryBounds = builder.addSummary(summary, spacing: 10);
      final summaryPageIndex = pageIndexOf(builder.document, builder.currentPage);

      expect(summaryPageIndex, greaterThanOrEqualTo(gridPageIndex));
      if (summaryPageIndex == gridPageIndex) {
        expect(summaryBounds.top, greaterThanOrEqualTo(gridResult.bounds.bottom));
      } else {
        expect(summaryBounds.top, greaterThanOrEqualTo(builder.headerHeight));
      }

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: builder.document.pages.count);
    });

    test('repeated gridWithSummary sections do not break final page tracking', () {
      final config = createTestConfig(pageSize: const Size(180, 180));
      final builder = TestPdfDocumentBuilder(config);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(12);
      builder.newPage();

      builder.addGridWithSummary(
        grid: createPagedGrid(config, rowCount: 48),
        summary: createSummary(config, itemCount: 4),
      );
      builder.addGridWithSummary(
        grid: createPagedGrid(config, rowCount: 52),
        summary: createSummary(config, itemCount: 4),
      );

      expect(builder.pageCount, builder.document.pages.count);
      expect(
        pageIndexOf(builder.document, builder.currentPage),
        builder.document.pages.count - 1,
      );

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: builder.document.pages.count);
    });
  });
}
