
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

ErpLineItem line({
  required String id,
  required double quantity,
  required double unitPrice,
  List<ErpTaxLine> taxes = const [],
  List<ErpDiscount> discounts = const [],
  ErpCurrency currency = ErpCurrency.sar,
}) =>
    ErpLineItem(
      id: id,
      description: 'Item $id',
      descriptionAr: 'صنف $id',
      sku: 'SKU-$id',
      quantity: ErpQuantity(
        value: quantity,
        unit: ErpUnit.each,
      ),
      unitPrice: ErpMoney.fromAmount(
        unitPrice,
        currency: currency,
      ),
      discounts: discounts,
      taxes: taxes,
      batch: const ErpBatchInfo(batchNumber: 'B-2026'),
      serials: const [
        ErpSerialInfo(serialNumber: 'SN-1'),
      ],
    );

GeniusErpPackTransactionRequest request({
  required List<ErpLineItem> lines,
  GeniusErpPackTaxMode taxMode = GeniusErpPackTaxMode.exclusive,
  bool allowNegative = false,
  ErpCurrency currency = ErpCurrency.sar,
  ErpCurrency? baseCurrency,
  ErpExchangeRate? exchangeRate,
  List<ErpDiscount> discounts = const [],
  List<ErpCharge> charges = const [],
}) {
  return GeniusErpPackTransactionRequest(
    document: ErpDocumentContext(
      organization: const ErpOrganization(
        id: 'ORG',
        legalName: 'Genius Demo',
        nameAr: 'جينيس',
      ),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.other,
        number: 'S12-TEST',
        issueDate: DateTime(2026, 9, 4),
      ),
      recipient: const ErpParty(
        id: 'C001',
        name: 'Customer',
        nameAr: 'العميل',
      ),
      documentCurrency: currency,
      baseCurrency: baseCurrency,
      exchangeRate: exchangeRate,
      lineItems: lines,
    ),
    documentDiscounts: discounts,
    documentCharges: charges,
    taxMode: taxMode,
    allowNegativeValues: allowNegative,
    paymentTerms: '30 days',
    expectedDelivery: DateTime(2026, 9, 15),
    warehouse: 'MAIN',
  );
}

void main() {
  const service = GeniusErpPackCalculationService();

  test('exclusive tax uses S06 arithmetic', () {
    final result = service.calculate(
      request(
        lines: [
          line(
            id: '1',
            quantity: 2,
            unitPrice: 100,
            taxes: const [
              ErpTaxLine(code: 'VAT', ratePercent: 15),
            ],
          ),
        ],
      ),
    );

    expect(result.subtotal.toDouble(), 200);
    expect(result.taxTotal.toDouble(), 30);
    expect(result.grandTotal.toDouble(), 230);
  });

  test('inclusive tax normalizes before S06 calculation', () {
    final result = service.calculate(
      request(
        taxMode: GeniusErpPackTaxMode.inclusive,
        lines: [
          line(
            id: '1',
            quantity: 1,
            unitPrice: 115,
            taxes: const [
              ErpTaxLine(code: 'VAT', ratePercent: 15),
            ],
          ),
        ],
      ),
    );

    expect(result.grandTotal.toDouble(), closeTo(115, 0.01));
    expect(result.taxTotal.toDouble(), closeTo(15, 0.01));
  });

  test('discounts and charges stay outside renderer', () {
    const currency = ErpCurrency.sar;
    final result = service.calculate(
      request(
        lines: [
          line(
            id: '1',
            quantity: 1,
            unitPrice: 100,
          ),
        ],
        discounts: [
          ErpDiscount.fixed(
            amount: ErpMoney.fromAmount(10, currency: currency),
          ),
        ],
        charges: [
          ErpCharge.fixed(
            amount: ErpMoney.fromAmount(5, currency: currency),
          ),
        ],
      ),
    );

    expect(result.documentDiscountTotal.toDouble(), 10);
    expect(result.chargeTotal.toDouble(), 5);
  });

  test('negative return values are enabled explicitly', () {
    final result = service.calculate(
      request(
        allowNegative: true,
        lines: [
          line(
            id: 'RET',
            quantity: -1,
            unitPrice: 100,
          ),
        ],
      ),
    );

    expect(result.grandTotal.toDouble(), -100);
  });

  test('zero return quantity is accepted only by explicit return mode', () {
    final result = service.calculate(
      request(
        allowNegative: true,
        lines: [
          line(
            id: 'ZERO',
            quantity: 0,
            unitPrice: 100,
          ),
        ],
      ),
    );

    expect(result.grandTotal.toDouble(), 0);
  });

  test('multi currency produces base totals', () {
    const documentCurrency = ErpCurrency.usd;
    const baseCurrency = ErpCurrency.sar;
    const rate = ErpExchangeRate(
      from: documentCurrency,
      to: baseCurrency,
      rate: 3.75,
    );

    final result = service.calculate(
      request(
        currency: documentCurrency,
        baseCurrency: baseCurrency,
        exchangeRate: rate,
        lines: [
          line(
            id: 'USD',
            quantity: 1,
            unitPrice: 100,
            currency: documentCurrency,
          ),
        ],
      ),
    );

    expect(result.baseGrandTotal, isNotNull);
    expect(result.baseGrandTotal!.toDouble(), 375);
  });
}
