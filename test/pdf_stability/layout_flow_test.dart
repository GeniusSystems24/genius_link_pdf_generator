import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'support/pdf_openability_assertions.dart';
import 'support/pdf_stability_fixtures.dart';

void main() {
  group('layout flow stability', () {
    test('long flowing text synchronizes final page state after pagination', () {
      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(160, 160)),
      );

      builder.reserveHeaderSpace(10);
      builder.reserveFooterSpace(10);
      builder.newPage();
      builder.addLine(createLongParagraph(repeat: 220), topMargin: 0);

      expect(builder.document.pages.count, greaterThan(1));
      expect(builder.pageCount, builder.document.pages.count);
      expect(
        pageIndexOf(builder.document, builder.currentPage),
        builder.document.pages.count - 1,
      );
      expect(
        builder.currentY,
        lessThanOrEqualTo(builder.pageHeight - builder.footerHeight),
      );

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: builder.document.pages.count);
    });

    test('rich text near the footer moves safely to a new page', () {
      final config = createTestConfig(pageSize: const Size(160, 140));
      final builder = TestPdfDocumentBuilder(config);

      builder.reserveHeaderSpace(10);
      builder.reserveFooterSpace(10);
      builder.newPage();
      builder.addSpace(builder.remainingHeight - 6);

      final pageBeforeRichText = pageIndexOf(builder.document, builder.currentPage);
      builder.addRichText(createLongRichText(config, repeat: 40));

      expect(
        pageIndexOf(builder.document, builder.currentPage),
        greaterThan(pageBeforeRichText),
      );
      expect(
        builder.currentY,
        lessThanOrEqualTo(builder.pageHeight - builder.footerHeight),
      );
    });

    test('section divider near footer moves safely to a new page', () {
      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(180, 200)),
      );

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(18);
      builder.newPage();
      builder.addSpace(builder.remainingHeight - 4);

      final pageBeforeDivider = pageIndexOf(builder.document, builder.currentPage);
      builder.addSectionDivider(title: 'Totals', spacing: 6);

      expect(
        pageIndexOf(builder.document, builder.currentPage),
        greaterThan(pageBeforeDivider),
      );
      expect(builder.currentY, greaterThan(builder.headerHeight));

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: builder.document.pages.count);
    });

    test('summary near footer moves safely to a new page', () {
      final config = createTestConfig(pageSize: const Size(180, 200));
      final builder = TestPdfDocumentBuilder(config);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(18);
      builder.newPage();
      builder.addSpace(builder.remainingHeight - 4);

      final pageBeforeSummary = pageIndexOf(builder.document, builder.currentPage);
      builder.addSummary(createSummary(config, itemCount: 4), spacing: 6);

      expect(
        pageIndexOf(builder.document, builder.currentPage),
        greaterThan(pageBeforeSummary),
      );
      expect(builder.currentY, greaterThan(builder.headerHeight));
    });

    test('info box near footer moves safely to a new page', () {
      final config = createTestConfig(pageSize: const Size(180, 200));
      final builder = TestPdfDocumentBuilder(config);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(18);
      builder.newPage();
      builder.addSpace(builder.remainingHeight - 4);

      final pageBeforeInfoBox = pageIndexOf(builder.document, builder.currentPage);
      builder.addInfoBox(createInfoBox(config, itemCount: 4), spacing: 6);

      expect(
        pageIndexOf(builder.document, builder.currentPage),
        greaterThan(pageBeforeInfoBox),
      );
      expect(builder.currentY, greaterThan(builder.headerHeight));
    });

    test('report header near footer moves safely to a new page', () {
      final config = createTestConfig(pageSize: const Size(180, 220));
      final builder = TestPdfDocumentBuilder(config);

      builder.reserveHeaderSpace(12);
      builder.reserveFooterSpace(18);
      builder.newPage();
      builder.addSpace(builder.remainingHeight - 8);

      final pageBeforeHeader = pageIndexOf(builder.document, builder.currentPage);
      builder.addReportHeader(createReportHeader(config), spacing: 6, height: 90);

      expect(
        pageIndexOf(builder.document, builder.currentPage),
        greaterThan(pageBeforeHeader),
      );
      expect(builder.currentY, greaterThan(builder.headerHeight));
    });
  });
}
