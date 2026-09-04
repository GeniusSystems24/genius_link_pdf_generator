
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusSalesLedgerEntry salesEntry({
  required String customer,
  required String item,
  required String salesperson,
  required double amount,
  double commission = 5,
}) =>
    GeniusSalesLedgerEntry(
      date: DateTime(2026, 9, 4),
      documentNumber: 'INV-$customer-$item',
      customerId: customer,
      customerName: 'Customer $customer',
      itemId: item,
      itemName: 'Item $item',
      quantity: 2,
      netAmount: ErpMoney.fromAmount(
        amount,
        currency: ErpCurrency.sar,
      ),
      taxAmount: ErpMoney.fromAmount(
        amount * 0.15,
        currency: ErpCurrency.sar,
      ),
      salespersonId: salesperson,
      salespersonName: 'Salesperson $salesperson',
      commissionRatePercent: commission,
    );

void main() {
  const analytics = GeniusSalesAnalytics();

  test('sales by customer is calculation-testable', () {
    final report = analytics.salesByCustomer([
      salesEntry(
        customer: 'C1',
        item: 'I1',
        salesperson: 'S1',
        amount: 100,
      ),
      salesEntry(
        customer: 'C1',
        item: 'I2',
        salesperson: 'S1',
        amount: 50,
      ),
    ]);

    expect(report.rows, hasLength(1));
    expect(report.rows.single.cells['net'], 150);
  });

  test('sales by item groups independent of renderer', () {
    final report = analytics.salesByItem([
      salesEntry(
        customer: 'C1',
        item: 'I1',
        salesperson: 'S1',
        amount: 100,
      ),
      salesEntry(
        customer: 'C2',
        item: 'I1',
        salesperson: 'S2',
        amount: 75,
      ),
    ]);

    expect(report.rows, hasLength(1));
    expect(report.rows.single.cells['net'], 175);
  });

  test('commission report calculates commission before rendering', () {
    final report = analytics.commissionReport([
      salesEntry(
        customer: 'C1',
        item: 'I1',
        salesperson: 'S1',
        amount: 200,
        commission: 5,
      ),
    ]);

    expect(report.rows.single.cells['commission'], 10);
  });

  test('customer aging buckets are deterministic', () {
    final report = analytics.customerAging(
      [
        GeniusErpOpenItem(
          partyId: 'C1',
          partyName: 'Customer',
          documentNumber: 'INV-1',
          issueDate: DateTime(2026, 7, 1),
          dueDate: DateTime(2026, 8, 20),
          amount: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
        ),
      ],
      asOf: DateTime(2026, 9, 4),
    );

    expect(report.rows, isNotEmpty);
    expect(
      report.rows.last.cells['amount'],
      100,
    );
  });

  test('backorder excludes fully fulfilled rows', () {
    final report = analytics.backorders(
      const [
        GeniusSalesBackorderLine(
          orderNumber: 'SO-1',
          customerName: 'A',
          itemCode: 'SKU-1',
          description: 'Item',
          orderedQuantity: 10,
          fulfilledQuantity: 10,
        ),
        GeniusSalesBackorderLine(
          orderNumber: 'SO-2',
          customerName: 'B',
          itemCode: 'SKU-2',
          description: 'Item',
          orderedQuantity: 10,
          fulfilledQuantity: 4,
        ),
      ],
    );

    expect(report.rows, hasLength(1));
    expect(report.rows.single.cells['open'], 6);
  });
}
