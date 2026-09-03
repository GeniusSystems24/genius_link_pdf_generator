
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  const rtl = GeniusPdfDirectionality(
    documentDirection: GeniusPdfDirection.rtl,
  );

  test('ERP numeric values stay LTR inside RTL', () {
    for (final kind in <GeniusPdfValueKind>[
      GeniusPdfValueKind.number,
      GeniusPdfValueKind.money,
      GeniusPdfValueKind.percentage,
      GeniusPdfValueKind.quantity,
      GeniusPdfValueKind.date,
      GeniusPdfValueKind.time,
      GeniusPdfValueKind.dateTime,
    ]) {
      expect(rtl.resolveValue(kind), GeniusPdfResolvedDirection.ltr);
    }
  });

  test('ERP identifiers stay LTR inside RTL', () {
    for (final kind in <GeniusPdfValueKind>[
      GeniusPdfValueKind.documentNumber,
      GeniusPdfValueKind.sku,
      GeniusPdfValueKind.serial,
      GeniusPdfValueKind.batch,
      GeniusPdfValueKind.iban,
      GeniusPdfValueKind.swift,
      GeniusPdfValueKind.taxId,
      GeniusPdfValueKind.phone,
      GeniusPdfValueKind.email,
      GeniusPdfValueKind.url,
    ]) {
      expect(rtl.resolveValue(kind), GeniusPdfResolvedDirection.ltr);
    }
  });

  test('plain prose inherits RTL', () {
    expect(
      rtl.resolveValue(GeniusPdfValueKind.plainText),
      GeniusPdfResolvedDirection.rtl,
    );
  });

  test('individual run can override policy', () {
    const run = GeniusPdfDirectedTextRun(
      '15,697.50 SAR',
      kind: GeniusPdfValueKind.money,
      direction: GeniusPdfDirection.rtl,
    );
    expect(run.resolveDirection(rtl), GeniusPdfResolvedDirection.rtl);
  });

  test('mixed Arabic/Latin strings are never mutated by the core', () {
    const raw = 'الإجمالي: 15,697.50 SAR — INV-2026-000123';
    const run = GeniusPdfDirectedTextRun(
      raw,
      kind: GeniusPdfValueKind.customIdentifier,
    );
    expect(run.text, raw);
    expect(run.resolveDirection(rtl), GeniusPdfResolvedDirection.ltr);
  });
}
