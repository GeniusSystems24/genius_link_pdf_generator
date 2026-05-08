import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

const List<int> _transparentPngBytes = <int>[
  137, 80, 78, 71, 13, 10, 26, 10,
  0, 0, 0, 13, 73, 72, 68, 82,
  0, 0, 0, 1, 0, 0, 0, 1,
  8, 6, 0, 0, 0, 31, 21, 196,
  137, 0, 0, 0, 13, 73, 68, 65,
  84, 120, 156, 99, 248, 255, 255, 63,
  0, 5, 254, 2, 254, 167, 53, 129,
  132, 0, 0, 0, 0, 73, 69, 78,
  68, 174, 66, 96, 130,
];

GeniusPdfImage createTestImage({
  double width = 24,
  double height = 24,
}) {
  return GeniusPdfImage(
    data: Uint8List.fromList(_transparentPngBytes),
    width: width,
    height: height,
  );
}

GeniusPdfImage createOversizedTestImage({
  double width = 600,
  double height = 800,
}) {
  return createTestImage(width: width, height: height);
}

GeniusPdfQRCodeGenerator createQrCodeFixture({
  required GeniusPdfConfig config,
  String value = 'https://example.com/invoice/123',
}) {
  return GeniusPdfQRCodeGenerator.url(url: value, config: config);
}

GeniusPdfBarcode createInvalidBarcodeFixture({
  required GeniusPdfConfig config,
}) {
  return GeniusPdfBarcode.ean13(data: '123', config: config);
}
