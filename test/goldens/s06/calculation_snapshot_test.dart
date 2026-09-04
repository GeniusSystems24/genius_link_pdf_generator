
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('deterministic S06 calculation snapshot', () {
    const service = ErpCalculationService();

    final result = service.calculate(
      ErpCalculationRequest(
        currency: ErpCurrency.sar,
        lineItems: [
          ErpLineItem(
            id: 'L1',
            description: 'Consulting',
            quantity: const ErpQuantity(value: 2, unit: ErpUnit.each),
            unitPrice: ErpMoney.fromAmount(
              100,
              currency: ErpCurrency.sar,
            ),
            discounts: [
              ErpDiscount.percentage(percentage: 10),
            ],
            charges: [
              ErpCharge.fixed(
                amount: ErpMoney.fromAmount(
                  10,
                  currency: ErpCurrency.sar,
                ),
              ),
            ],
            taxes: const [
              ErpTaxLine(code: 'VAT', ratePercent: 15),
            ],
          ),
        ],
      ),
    );

    final actual = [
      'subtotal=${result.subtotal}',
      'lineDiscount=${result.lineDiscountTotal}',
      'charges=${result.chargeTotal}',
      'taxable=${result.taxableAmount}',
      'tax=${result.taxTotal}',
      'rounding=${result.roundingAdjustment}',
      'grand=${result.grandTotal}',
      'paid=${result.paidAmount}',
      'due=${result.dueAmount}',
    ].join('\n');

    final expected = File(
      'test/goldens/s06/calculation_expected.txt',
    ).readAsStringSync().trim();

    expect(actual, expected);
  });
}
