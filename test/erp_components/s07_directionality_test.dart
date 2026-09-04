
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

void main() {
  test('S07 component inheritance resolves LTR and RTL independently', () {
    final ltr = GeniusPdfDocumentIdentity(
      config: config(false),
      data: ErpDocumentIdentity(
        kind: ErpDocumentKind.invoice,
        number: 'INV-2026-000123',
        issueDate: DateTime(2026, 9, 4),
      ),
      directionality: const GeniusPdfDirectionality(
        documentDirection: GeniusPdfDirection.ltr,
      ),
    );

    final rtl = GeniusPdfDocumentIdentity(
      config: config(true),
      data: ErpDocumentIdentity(
        kind: ErpDocumentKind.invoice,
        number: 'INV-2026-000123',
        issueDate: DateTime(2026, 9, 4),
      ),
      directionality: const GeniusPdfDirectionality(
        documentDirection: GeniusPdfDirection.rtl,
      ),
    );

    expect(ltr.resolvedDirection, GeniusPdfResolvedDirection.ltr);
    expect(rtl.resolvedDirection, GeniusPdfResolvedDirection.rtl);
  });

  test('structured ERP values remain LTR in an RTL component', () {
    const rtl = GeniusPdfDirectionality(
      documentDirection: GeniusPdfDirection.rtl,
    );

    for (final kind in <GeniusPdfValueKind>[
      GeniusPdfValueKind.money,
      GeniusPdfValueKind.documentNumber,
      GeniusPdfValueKind.taxId,
      GeniusPdfValueKind.phone,
      GeniusPdfValueKind.email,
      GeniusPdfValueKind.date,
    ]) {
      expect(
        rtl.resolveValue(kind),
        GeniusPdfResolvedDirection.ltr,
        reason: kind.name,
      );
    }

    expect(
      rtl.resolveValue(GeniusPdfValueKind.plainText),
      GeniusPdfResolvedDirection.rtl,
    );
  });

  test('logical start/end padding resolves only at draw boundary', () {
    const padding = GeniusPdfDirectionalInsets(
      start: 12,
      end: 4,
      top: 2,
      bottom: 3,
    );

    final ltr = padding.resolve(GeniusPdfResolvedDirection.ltr);
    final rtl = padding.resolve(GeniusPdfResolvedDirection.rtl);

    expect(ltr.left, 12);
    expect(ltr.right, 4);
    expect(rtl.left, 4);
    expect(rtl.right, 12);
    expect(ltr.top, rtl.top);
    expect(ltr.bottom, rtl.bottom);
  });
}
