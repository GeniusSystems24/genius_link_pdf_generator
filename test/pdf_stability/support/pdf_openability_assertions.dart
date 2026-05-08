import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void expectReopenablePdf(
  List<int> bytes, {
  int? expectedPageCount,
}) {
  expect(bytes, isNotEmpty);

  final reopened = PdfDocument(inputBytes: Uint8List.fromList(bytes));
  try {
    if (expectedPageCount != null) {
      expect(reopened.pages.count, expectedPageCount);
    }
  } finally {
    reopened.dispose();
  }
}

int pageIndexOf(PdfDocument document, PdfPage page) {
  for (var i = 0; i < document.pages.count; i++) {
    if (document.pages[i] == page) {
      return i;
    }
  }
  return -1;
}
