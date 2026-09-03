import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  const rtl = GeniusPdfDirectionality(
    documentDirection: GeniusPdfDirection.rtl,
  );
  const ltr = GeniusPdfDirectionality(
    documentDirection: GeniusPdfDirection.ltr,
  );

  const samples = <(GeniusPdfValueKind, String)>[
    (GeniusPdfValueKind.number, '13,650.00'),
    (GeniusPdfValueKind.money, '15,697.50 SAR'),
    (GeniusPdfValueKind.percentage, '15.00%'),
    (GeniusPdfValueKind.quantity, '1,250.500 KG'),
    (GeniusPdfValueKind.date, '2026-09-03'),
    (GeniusPdfValueKind.time, '09:45:20'),
    (GeniusPdfValueKind.dateTime, '2026-09-03 09:45:20'),
    (GeniusPdfValueKind.documentNumber, 'INV-2026-000123'),
    (GeniusPdfValueKind.sku, 'SKU-AR-ENG-001'),
    (GeniusPdfValueKind.serial, 'SN-AZ09-998877'),
    (GeniusPdfValueKind.batch, 'BATCH-2026-09-A'),
    (GeniusPdfValueKind.iban, 'SA0380000000608010167519'),
    (GeniusPdfValueKind.swift, 'RJHISARIXXX'),
    (GeniusPdfValueKind.taxId, '310123456700003'),
    (GeniusPdfValueKind.phone, '+966 55 123 4567'),
    (GeniusPdfValueKind.email, 'accounts@example.test'),
    (GeniusPdfValueKind.url,
        'https://erp.example.test/invoices/INV-2026-000123'),
  ];

  test('ERP strings are byte-for-byte stable between LTR and RTL contexts', () {
    for (final sample in samples) {
      final ltrRun = GeniusPdfDirectedTextRun(sample.$2, kind: sample.$1);
      final rtlRun = GeniusPdfDirectedTextRun(sample.$2, kind: sample.$1);
      expect(ltrRun.text, sample.$2);
      expect(rtlRun.text, sample.$2);
      expect(ltrRun.text, rtlRun.text);
    }
  });

  test('structured ERP values resolve LTR inside RTL by default', () {
    for (final sample in samples) {
      final run = GeniusPdfDirectedTextRun(sample.$2, kind: sample.$1);
      expect(run.resolveDirection(rtl), GeniusPdfResolvedDirection.ltr);
      expect(run.resolveDirection(ltr), GeniusPdfResolvedDirection.ltr);
    }
  });

  test('mixed Arabic/Latin run is not reversed', () {
    const source =
        'رقم المستند INV-2026-000123 — الإجمالي 15,697.50 SAR';
    const run = GeniusPdfDirectedTextRun(
      source,
      kind: GeniusPdfValueKind.customIdentifier,
    );
    expect(run.text, source);
    expect(run.text, contains('INV-2026-000123'));
    expect(run.text, contains('15,697.50 SAR'));
  });
}
