
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

GeniusPdfConfig config(bool rtl) => GeniusPdfConfig(
      baseFontBytes: Uint8List(0),
      baseFont: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    );

String snapshot({
  required bool rtl,
  required String partyName,
}) {
  final c = config(rtl);
  final directionality = GeniusPdfDirectionality(
    documentDirection:
        rtl ? GeniusPdfDirection.rtl : GeniusPdfDirection.ltr,
  );

  final identity = GeniusPdfDocumentIdentity(
    config: c,
    data: ErpDocumentIdentity(
      kind: ErpDocumentKind.invoice,
      number: 'INV-2026-000123',
      issueDate: DateTime(2026, 9, 4),
    ),
    directionality: directionality,
  );

  return [
    'layout=${identity.resolvedDirection.name}',
    'party=$partyName',
    'documentNumber=INV-2026-000123|dir='
        '${directionality.resolveValue(GeniusPdfValueKind.documentNumber).name}',
    'money=15,697.50 SAR|dir='
        '${directionality.resolveValue(GeniusPdfValueKind.money).name}',
    'taxId=310123456700003|dir='
        '${directionality.resolveValue(GeniusPdfValueKind.taxId).name}',
    'phone=+966 50 123 4567|dir='
        '${directionality.resolveValue(GeniusPdfValueKind.phone).name}',
    'email=finance@example.com|dir='
        '${directionality.resolveValue(GeniusPdfValueKind.email).name}',
    'proseDir='
        '${directionality.resolveValue(GeniusPdfValueKind.plainText).name}',
  ].join('\\n');
}

void main() {
  test('EN/LTR semantic direction golden', () {
    final expected = File(
      'test/goldens/s07/en_ltr_expected.txt',
    ).readAsStringSync().trim();
    expect(
      snapshot(rtl: false, partyName: 'Acme Trading'),
      expected,
    );
  });

  test('AR/RTL semantic direction golden', () {
    final expected = File(
      'test/goldens/s07/ar_rtl_expected.txt',
    ).readAsStringSync().trim();
    expect(
      snapshot(rtl: true, partyName: 'شركة أكمي'),
      expected,
    );
  });

  test('bilingual semantic direction golden', () {
    final expected = File(
      'test/goldens/s07/bilingual_expected.txt',
    ).readAsStringSync().trim();
    expect(
      snapshot(rtl: true, partyName: 'شركة Acme Trading'),
      expected,
    );
  });
}
