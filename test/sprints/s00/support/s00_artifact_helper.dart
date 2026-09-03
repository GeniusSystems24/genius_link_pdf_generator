
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

bool get s00CaptureEnabled => Platform.environment['GENIUS_CAPTURE_S00'] == '1';

String s00ArtifactName({
  required String subject,
  required String locale,
  required String direction,
  required String scenario,
}) {
  String clean(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return 's00__${clean(subject)}__${clean(locale)}__'
      '${clean(direction)}__${clean(scenario)}';
}

Map<String, Object> inspectS00Pdf(Uint8List bytes) {
  final document = PdfDocument(inputBytes: bytes);
  try {
    final pages = <Map<String, Object>>[];
    for (var index = 0; index < document.pages.count; index++) {
      final size = document.pages[index].getClientSize();
      pages.add({
        'page': index + 1,
        'width': size.width,
        'height': size.height,
      });
    }
    return {'pageCount': document.pages.count, 'pages': pages};
  } finally {
    document.dispose();
  }
}

void captureS00Pdf({
  required String subject,
  required String locale,
  required String direction,
  required String scenario,
  required Uint8List bytes,
}) {
  if (!s00CaptureEnabled) return;

  final name = s00ArtifactName(
    subject: subject,
    locale: locale,
    direction: direction,
    scenario: scenario,
  );
  final directory = Directory('test/sprints/s00/baselines/generated')
    ..createSync(recursive: true);

  File('${directory.path}/$name.pdf').writeAsBytesSync(bytes, flush: true);
  File('${directory.path}/$name.baseline.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'name': name,
      'version': '4.0.0',
      'sprint': 'S00',
      ...inspectS00Pdf(bytes),
    }),
    flush: true,
  );
}
