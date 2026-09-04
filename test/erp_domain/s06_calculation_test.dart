
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

ErpMoney money(num value, [ErpCurrency c = ErpCurrency.sar]) =>
    ErpMoney.fromAmount(value, currency: c);

ErpLineItem line({
  String id = 'L1',
  double qty = 1,
  num price = 100,
  ErpCurrency currency = ErpCurrency.sar,
  List<ErpDiscount> discounts = const [],
  List<ErpCharge> charges = const [],
  List<ErpTaxLine> taxes = const [],
}) =>
    ErpLineItem(
      id: id,
      description: 'Item $id',
      quantity: ErpQuantity(value: qty, unit: ErpUnit.each),
      unitPrice: money(price, currency),
      discounts: discounts,
      charges: charges,
      taxes: taxes,
    );

void main() {
  const service = ErpCalculationService();

  group('S06 calculation service', () {
    test('subtotal/line discount/charge/tax/grand total', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [
            line(
              qty: 2,
              discounts: [
                ErpDiscount.percentage(percentage: 10),
              ],
              charges: [
                ErpCharge.fixed(amount: money(10)),
              ],
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
        ),
      );

      expect(result.subtotal.toDouble(), 200);
      expect(result.lineDiscountTotal.toDouble(), 20);
      expect(result.chargeTotal.toDouble(), 10);
      expect(result.taxableAmount.toDouble(), 190);
      expect(result.taxTotal.toDouble(), 28.5);
      expect(result.grandTotal.toDouble(), 218.5);
    });

    test('document discount before tax', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [
            line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
          documentDiscounts: [
            ErpDiscount.percentage(percentage: 10),
          ],
          config: const ErpCalculationConfig(
            documentDiscountTaxPolicy:
                ErpDocumentDiscountTaxPolicy.beforeTax,
          ),
        ),
      );

      expect(result.documentDiscountTotal.toDouble(), 10);
      expect(result.taxableAmount.toDouble(), 90);
      expect(result.taxTotal.toDouble(), 13.5);
      expect(result.grandTotal.toDouble(), 103.5);
    });

    test('document discount after tax', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [
            line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
          documentDiscounts: [
            ErpDiscount.percentage(percentage: 10),
          ],
          config: const ErpCalculationConfig(
            documentDiscountTaxPolicy:
                ErpDocumentDiscountTaxPolicy.afterTax,
          ),
        ),
      );

      expect(result.taxableAmount.toDouble(), 100);
      expect(result.taxTotal.toDouble(), 15);
      expect(result.grandTotal.toDouble(), 105);
    });

    test('multi-tax supports compound tax', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [
            line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
                ErpTaxLine(
                  code: 'LEVY',
                  ratePercent: 5,
                  compound: true,
                ),
              ],
            ),
          ],
        ),
      );

      expect(result.taxTotals.length, 2);
      expect(result.taxTotal.toDouble(), 20.75);
      expect(result.grandTotal.toDouble(), 120.75);
    });

    test('rounding adjustment uses minor-unit increment', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [line(price: 10.03)],
          config: const ErpCalculationConfig(
            roundingIncrementMinorUnits: 5,
          ),
        ),
      );

      expect(result.totalBeforeRounding.toDouble(), 10.03);
      expect(result.roundingAdjustment.toDouble(), 0.02);
      expect(result.grandTotal.toDouble(), 10.05);
    });

    test('paid/due remain null until payment state is supplied', () {
      final none = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [line()],
        ),
      );
      expect(none.paidAmount, isNull);
      expect(none.dueAmount, isNull);

      final paid = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [
            line(
              taxes: const [
                ErpTaxLine(code: 'VAT', ratePercent: 15),
              ],
            ),
          ],
          paidAmount: money(50),
        ),
      );
      expect(paid.grandTotal.toDouble(), 115);
      expect(paid.dueAmount!.toDouble(), 65);
    });

    test('document/base currencies are separate', () {
      final result = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.usd,
          lineItems: [
            line(currency: ErpCurrency.usd),
          ],
          baseCurrency: ErpCurrency.sar,
          exchangeRate: const ErpExchangeRate(
            from: ErpCurrency.usd,
            to: ErpCurrency.sar,
            rate: 3.75,
          ),
        ),
      );

      expect(result.grandTotal.toDouble(), 100);
      expect(result.baseGrandTotal!.toDouble(), 375);
      expect(result.baseGrandTotal!.currency, ErpCurrency.sar);
    });

    test('zero/negative lines require explicit config', () {
      expect(
        () => service.calculate(
          ErpCalculationRequest(
            currency: ErpCurrency.sar,
            lineItems: [line(qty: 0)],
          ),
        ),
        throwsA(isA<ErpDomainValidationException>()),
      );

      final zero = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [line(qty: 0)],
          config: const ErpCalculationConfig(
            allowZeroQuantity: true,
          ),
        ),
      );
      expect(zero.grandTotal.isZero, isTrue);

      final negative = service.calculate(
        ErpCalculationRequest(
          currency: ErpCurrency.sar,
          lineItems: [line(qty: -1)],
          config: const ErpCalculationConfig(
            allowNegativeQuantity: true,
            allowNegativeGrandTotal: true,
          ),
        ),
      );
      expect(negative.grandTotal.toDouble(), -100);
    });
  });
}
