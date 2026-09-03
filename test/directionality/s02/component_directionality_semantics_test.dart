
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/core/component_directionality.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator_api.dart';

void main() {
  test('RTL definition order mirrors unless physical order is preserved', () {
    expect(
      GeniusPdfComponentDirectionality.definitionIndex(
        index: 0,
        count: 4,
        direction: GeniusPdfResolvedDirection.rtl,
      ),
      3,
    );
    expect(
      GeniusPdfComponentDirectionality.definitionIndex(
        index: 0,
        count: 4,
        direction: GeniusPdfResolvedDirection.rtl,
        preserveDefinitionOrder: true,
      ),
      0,
    );
  });

  test('ERP values stay LTR inside RTL', () {
    const values = <String>[
      '13,650.00 SAR',
      '15,697.50 SAR',
      '-1,250.00 SAR',
      '15.00%',
      'INV-2026-000123',
      'SKU-AR-ENG-001',
      'SA0380000000608010167519',
      '+966 55 123 4567',
      'accounts@example.test',
      'https://erp.example.test/invoice/123',
    ];
    for (final value in values) {
      expect(
        GeniusPdfComponentDirectionality.valueDirection(
          text: value,
          layoutDirection: GeniusPdfResolvedDirection.rtl,
        ),
        GeniusPdfResolvedDirection.ltr,
        reason: value,
      );
    }
  });

  test('Arabic prose inherits RTL and no source value is reversed', () {
    expect(
      GeniusPdfComponentDirectionality.valueDirection(
        text: 'هذا وصف عربي طويل',
        layoutDirection: GeniusPdfResolvedDirection.rtl,
      ),
      GeniusPdfResolvedDirection.rtl,
    );
    const value = '15,697.50 SAR';
    expect(GeniusPdfComponentDirectionality.isolateLtr(value), contains(value));
  });
}
