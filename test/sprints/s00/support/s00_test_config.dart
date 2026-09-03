
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

const _s00FontCandidates = <String>[
  'example/assets/fonts/cairo/cairoRegular.ttf',
  'example/assets/fonts/hacen/hacenTunisia.ttf',
];

Uint8List loadS00ArabicFontBytes() {
  for (final relative in _s00FontCandidates) {
    final file = File(relative);
    if (file.existsSync()) return file.readAsBytesSync();
  }
  throw StateError(
    'S00 requires an existing example Arabic font. Checked: '
    '${_s00FontCandidates.join(', ')}',
  );
}

GeniusPdfConfig createS00Config({
  required TextDirection direction,
  Size pageSize = GeniusPdfPageSize.a4,
}) {
  final bytes = loadS00ArabicFontBytes();
  return GeniusPdfConfig(
    baseFontBytes: bytes,
    boldFontBytes: bytes,
    headerFontBytes: bytes,
    smallFontBytes: bytes,
    pageSize: pageSize,
    textDirection: direction,
    margins: PdfMargins()..all = 24,
  );
}
