import 'dart:ui';

import 'package:flutter_test/flutter_test.dart' hide createTestImage;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'support/pdf_failure_scenarios.dart';
import 'support/pdf_openability_assertions.dart';
import 'support/pdf_stability_fixtures.dart';

void main() {
  // ─── US4: RTL and LTR Layout Correctness ────────────────────────────────

  group('RTL / LTR layout correctness', () {
    test('RTL document generates valid, reopenable PDF', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('RTL layout text renders correctly', topMargin: 0);
        b.addLine('Second line RTL', topMargin: 4);
        b.addSpace(10);
        b.addHorizontalLine();
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('LTR document generates valid, reopenable PDF', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.ltr,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('English text renders correctly', topMargin: 0);
        b.addLine('Second line', topMargin: 4);
        b.addSpace(10);
        b.addHorizontalLine();
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('RTL and LTR single-page docs produce non-empty outputs', () {
      final rtlBytes = _generateDirectionalDoc(TextDirection.rtl);
      final ltrBytes = _generateDirectionalDoc(TextDirection.ltr);

      expect(rtlBytes, isNotEmpty);
      expect(ltrBytes, isNotEmpty);
    });

    test('portrait document generates correctly and is reopenable', () {
      final config = createTestConfig(
        pageSize: const Size(180, 260),
        orientation: PdfPageOrientation.portrait,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Portrait layout test', topMargin: 0);
        b.addSpace(20);
        b.addLine('Page height > page width', topMargin: 4);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('landscape document generates correctly and is reopenable', () {
      final config = createTestConfig(
        pageSize: const Size(260, 180),
        orientation: PdfPageOrientation.landscape,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Landscape layout test', topMargin: 0);
        b.addSpace(20);
        b.addLine('Page width > page height', topMargin: 4);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('RTL multi-page document keeps builder state consistent', () {
      final config = createTestConfig(
        pageSize: const Size(160, 160),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(12);
        b.reserveFooterSpace(12);
        b.newPage();
        b.addLine(createLongParagraph(repeat: 200), topMargin: 0);
      });

      builder.generate();
      expect(builder.document.pages.count, greaterThan(1));
      expect(
        builder.currentY,
        lessThanOrEqualTo(builder.pageHeight - builder.footerHeight),
      );
      builder.dispose();
    });

    test('bilingual document (RTL + LTR sections) opens without corruption', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Annual Report Title RTL', topMargin: 0);
        b.addLine('Annual Report', topMargin: 4);
        b.addHorizontalLine(spacing: 6);
        b.addLine('Total Amount: 100,000', topMargin: 4);
        b.addLine('Total: 100,000', topMargin: 4);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('summary section renders in RTL without page corruption', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addSummary(createSummary(config, itemCount: 4));
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('info box renders in RTL without page corruption', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addInfoBox(createInfoBox(config, itemCount: 4));
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('report header renders in both RTL and LTR without corruption', () {
      for (final dir in [TextDirection.rtl, TextDirection.ltr]) {
        final config = createTestConfig(
          pageSize: const Size(200, 280),
          textDirection: dir,
        );
        final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
          b.reserveHeaderSpace(10);
          b.reserveFooterSpace(10);
          b.newPage();
          b.addReportHeader(createReportHeader(config));
        });

        final bytes = builder.generate();
        expectReopenablePdf(bytes, expectedPageCount: 1);
        builder.dispose();
      }
    });

    test('constrained small-page RTL layout does not overflow footer', () {
      final config = createTestConfig(
        pageSize: const Size(120, 150),
        textDirection: TextDirection.rtl,
        margin: 0,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addLine('Short RTL text', topMargin: 0);
        b.addSummary(createSummary(config, itemCount: 3));
      });

      builder.generate();
      expect(
        builder.currentY,
        lessThanOrEqualTo(builder.pageHeight - builder.footerHeight),
      );
      builder.dispose();
    });

    test('rich text renders in RTL without page corruption', () {
      final config = createTestConfig(
        pageSize: const Size(200, 280),
        textDirection: TextDirection.rtl,
      );
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addRichText(createLongRichText(config, repeat: 30));
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes);
      builder.dispose();
    });
  });

  // ─── US5: Image, QR, and Barcode Safety ─────────────────────────────────

  group('image safety', () {
    test('reasonably-sized image generates valid PDF', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final image = createTestImage(width: 50, height: 30);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addImage(image);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('oversized image is scaled to fit available content space', () {
      final config = createTestConfig(
        pageSize: const Size(120, 150),
        margin: 0,
      );
      final image = createOversizedTestImage(width: 300, height: 300);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addImage(image);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes);
      builder.dispose();
    });

    test('zero-dimension image throws explicit StateError before drawing', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final image = createTestImage(width: 0, height: 0);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addImage(image);
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });

    test('image that cannot fit on even a full page throws StateError', () {
      final config = createTestConfig(
        pageSize: const Size(5, 5),
        margin: 0,
      );
      final image = createOversizedTestImage(width: 300, height: 300);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(4);
        b.reserveFooterSpace(4);
        b.newPage();
        b.addImage(image);
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });
  });

  group('QR code safety', () {
    test('valid QR code generates without corruption', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final qr = createQrCodeFixture(config: config);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addQRCode(qr, size: 80);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('QR code with empty data throws StateError before drawing', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final qr = GeniusPdfQRCodeGenerator(data: '', config: config);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addQRCode(qr, size: 80);
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });

    test('QR code placement when no usable content space throws StateError', () {
      final config = createTestConfig(
        pageSize: const Size(30, 30),
        margin: 0,
      );
      final qr = GeniusPdfQRCodeGenerator(
        data: 'https://example.com',
        config: config,
      );

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(14);
        b.reserveFooterSpace(14);
        b.newPage();
        b.addQRCode(qr, size: 100);
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });
  });

  group('barcode safety', () {
    test('valid EAN-13 barcode generates without corruption', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final barcode = GeniusPdfBarcode.ean13(
        data: '5901234123457',
        config: config,
      );

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        barcode.draw(
          page: b.currentPage,
          bounds: const Rect.fromLTWH(0, 20, 180, 80),
        );
        b.addSpace(90);
      });

      final bytes = builder.generate();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('invalid EAN-13 data throws StateError', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final barcode = createInvalidBarcodeFixture(config: config);

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        barcode.draw(
          page: b.currentPage,
          bounds: const Rect.fromLTWH(0, 20, 180, 80),
        );
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });

    test('barcode with bounds too small throws StateError', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final barcode = GeniusPdfBarcode.code128(
        data: 'VALID123',
        config: config,
      );

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        barcode.draw(
          page: b.currentPage,
          bounds: const Rect.fromLTWH(0, 10, 0, 0),
        );
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });

    test('invalid Code39 characters throw StateError', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final barcode = GeniusPdfBarcode(
        data: 'invalid lowercase',
        type: GeniusBarcodeType.code39,
        config: config,
      );

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        barcode.draw(
          page: b.currentPage,
          bounds: const Rect.fromLTWH(0, 20, 180, 80),
        );
      });

      expect(() => builder.generate(), throwsStateError);
      builder.dispose();
    });
  });

  group('watermark coexistence', () {
    test('diagonal watermark applied after content does not corrupt PDF', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Regular content', topMargin: 0);
        b.addSpace(10);
        b.addLine('Second line', topMargin: 4);
      });

      builder.generate();

      final watermark = GeniusPdfWatermark.confidential(config: config);
      watermark.applyToDocument(builder.document);

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });

    test('text watermark on multi-page doc opens correctly', () {
      final config = createTestConfig(pageSize: const Size(160, 160));
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.reserveHeaderSpace(10);
        b.reserveFooterSpace(10);
        b.newPage();
        b.addLine(createLongParagraph(repeat: 180), topMargin: 0);
      });

      builder.generate();
      final pageCount = builder.document.pages.count;

      final watermark = GeniusPdfWatermark.draft(config: config);
      watermark.applyToDocument(builder.document);

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: pageCount);
      builder.dispose();
    });

    test('image watermark with fill position does not corrupt PDF', () {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final imageData = createTestImage().data;

      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Content with image watermark', topMargin: 0);
      });

      builder.generate();

      final watermark = GeniusPdfWatermark.image(
        GeniusImageWatermarkSettings(
          imageBytes: imageData,
          position: GeniusWatermarkPosition.fill,
          opacity: 0.1,
        ),
        config: config,
      );
      watermark.applyToDocument(builder.document);

      final bytes = builder.document.saveSync();
      expectReopenablePdf(bytes, expectedPageCount: 1);
      builder.dispose();
    });
  });
}

// ─── Helpers ────────────────────────────────────────────────────────────────

List<int> _generateDirectionalDoc(TextDirection dir) {
  final config = createTestConfig(
    pageSize: const Size(200, 280),
    textDirection: dir,
  );
  final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
    b.newPage();
    b.addLine(
      dir == TextDirection.rtl ? 'RTL direction test text' : 'Direction test text',
      topMargin: 0,
    );
    b.addHorizontalLine(spacing: 6);
    b.addSummary(createSummary(config, itemCount: 2));
  });

  final bytes = builder.generate();
  builder.dispose();
  return bytes;
}
