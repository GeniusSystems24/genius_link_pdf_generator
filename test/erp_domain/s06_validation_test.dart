
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  const validator = ErpDomainValidator();

  test('currency mismatch is rejected', () {
    final request = ErpCalculationRequest(
      currency: ErpCurrency.sar,
      lineItems: [
        ErpLineItem(
          id: 'L1',
          description: 'Wrong currency',
          quantity: const ErpQuantity(value: 1, unit: ErpUnit.each),
          unitPrice: ErpMoney.fromAmount(
            10,
            currency: ErpCurrency.usd,
          ),
        ),
      ],
    );

    final result = validator.validateCalculationRequest(request);
    expect(result.isValid, isFalse);
    expect(
      result.issues.any((e) => e.code == 'line.currency.mismatch'),
      isTrue,
    );
  });

  test('multi-currency requires an explicit matching rate', () {
    final request = ErpCalculationRequest(
      currency: ErpCurrency.usd,
      baseCurrency: ErpCurrency.sar,
      lineItems: [
        ErpLineItem(
          id: 'L1',
          description: 'USD',
          quantity: const ErpQuantity(value: 1, unit: ErpUnit.each),
          unitPrice: ErpMoney.fromAmount(
            10,
            currency: ErpCurrency.usd,
          ),
        ),
      ],
    );

    final result = validator.validateCalculationRequest(request);
    expect(
      result.issues.any((e) => e.code == 'exchangeRate.required'),
      isTrue,
    );
  });

  test('null optional metadata needs no dummy values', () {
    final context = ErpDocumentContext(
      organization: const ErpOrganization(
        id: 'ORG',
        legalName: 'Organization',
      ),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.quotation,
        number: 'Q-1',
        issueDate: DateTime(2026, 9, 4),
      ),
      documentCurrency: ErpCurrency.sar,
    );

    final result = validator.validateDocumentContext(context);
    expect(result.isValid, isTrue);
    expect(context.branch, isNull);
    expect(context.recipient, isNull);
    expect(context.printMetadata, isNull);
    expect(context.attachments, isEmpty);
  });

  test('discount percentage above 100 is rejected', () {
    final request = ErpCalculationRequest(
      currency: ErpCurrency.sar,
      lineItems: [
        ErpLineItem(
          id: 'L1',
          description: 'Item',
          quantity: const ErpQuantity(value: 1, unit: ErpUnit.each),
          unitPrice: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
          discounts: [
            ErpDiscount.percentage(percentage: 125),
          ],
        ),
      ],
    );

    final result = validator.validateCalculationRequest(request);
    expect(
      result.issues.any(
        (e) => e.code == 'discount.percentage.invalid',
      ),
      isTrue,
    );
  });
}
