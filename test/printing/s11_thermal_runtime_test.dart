
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config(TextDirection direction) => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 9),
      boldFont: PdfStandardFont(
        PdfFontFamily.helvetica,
        9,
        style: PdfFontStyle.bold,
      ),
      headerFont: PdfStandardFont(
        PdfFontFamily.helvetica,
        11,
        style: PdfFontStyle.bold,
      ),
      smallFont: PdfStandardFont(PdfFontFamily.helvetica, 7),
      textDirection: direction,
    );

GeniusPdfThermalReceiptData data() => GeniusPdfThermalReceiptData(
      merchantName: 'Store',
      merchantNameAr: 'المتجر',
      receiptNumber: 'POS-2026-0001',
      date: DateTime(2026, 9, 4),
      items: const [
        GeniusPdfThermalLineItem(
          description: 'Tea',
          descriptionAr: 'شاي',
          sku: 'SKU-001',
          quantity: 2,
          unitPrice: 5,
        ),
      ],
      tax: 1.5,
      payments: const [
        GeniusPdfThermalPaymentLine(
          label: 'Cash',
          labelAr: 'نقداً',
          amount: 11.5,
        ),
      ],
      qrData: 'https://example.com/r/POS-2026-0001',
      barcodeData: 'POS20260001',
    );

void main() {
  for (final direction in <TextDirection>[
    TextDirection.ltr,
    TextDirection.rtl,
  ]) {
    test('58mm thermal generates without empty output: $direction', () {
      final document = GeniusPdfThermalReceiptEngine(
        config: config(direction),
        profile: GeniusPdfPrintProfile.thermal58(),
        data: data(),
      );

      final bytes = document.generate();
      expect(bytes, isNotEmpty);
      expect(document.pageCount, greaterThanOrEqualTo(1));
      document.dispose();
    });

    test('80mm thermal generates without empty output: $direction', () {
      final document = GeniusPdfThermalReceiptEngine(
        config: config(direction),
        profile: GeniusPdfPrintProfile.thermal80(),
        data: data(),
      );

      final bytes = document.generate();
      expect(bytes, isNotEmpty);
      document.dispose();
    });
  }
}
