import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'support/pdf_openability_assertions.dart';
import 'support/pdf_stability_fixtures.dart';

void main() {
  group('builder state stability', () {
    test('newPage starts at headerHeight and remainingHeight honors footer', () {
      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(180, 220)),
      );

      builder.reserveHeaderSpace(18);
      builder.reserveFooterSpace(22);
      final page = builder.newPage();

      expect(builder.currentPage, same(page));
      expect(builder.currentY, 18);
      expect(builder.headerHeight, 18);
      expect(builder.footerHeight, 22);
      expect(builder.remainingHeight, 220 - 18 - 22);
      expect(builder.canFit(50), isTrue);
      expect(builder.contentBounds.top, 18);
      expect(builder.contentBounds.height, 220 - 18 - 22);
    });

    test('resetY uses headerHeight by default and explicit value when provided',
        () {
      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(180, 220)),
      );

      builder.reserveHeaderSpace(16);
      builder.newPage();
      builder.addSpace(20);

      builder.resetY();
      expect(builder.currentY, 16);

      builder.resetY(40);
      expect(builder.currentY, 40);
    });

    test('addSpace creates new pages instead of moving into footer space', () {
      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(180, 200)),
      );

      builder.reserveHeaderSpace(20);
      builder.reserveFooterSpace(30);
      builder.newPage();

      builder.addSpace(160);

      expect(builder.pageCount, 2);
      expect(builder.currentY, 30);
      expect(builder.currentY, greaterThanOrEqualTo(builder.headerHeight));
      expect(
        builder.currentY,
        lessThanOrEqualTo(builder.pageHeight - builder.footerHeight),
      );
    });

    test('generate resets build start Y to headerHeight and produces a PDF', () {
      double? buildStartY;

      final builder = TestPdfDocumentBuilder(
        createTestConfig(pageSize: const Size(180, 220)),
        onBuild: (doc) {
          buildStartY = doc.currentY;
          doc.addLine('Builder start state check', topMargin: 0);
        },
      );

      builder.reserveHeaderSpace(24);
      final bytes = builder.generate();

      expect(buildStartY, 24);
      expectReopenablePdf(bytes, expectedPageCount: 1);
    });
  });
}
