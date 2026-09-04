
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPurchaseLedgerEntry purchaseEntry({
  required String supplier,
  required String item,
  double ordered = 10,
  double received = 4,
  double amount = 100,
}) =>
    GeniusPurchaseLedgerEntry(
      date: DateTime(2026, 9, 4),
      documentNumber: 'PO-$supplier-$item',
      supplierId: supplier,
      supplierName: 'Supplier $supplier',
      itemCode: item,
      itemName: 'Item $item',
      orderedQuantity: ordered,
      receivedQuantity: received,
      netAmount: ErpMoney.fromAmount(
        amount,
        currency: ErpCurrency.sar,
      ),
      taxAmount: ErpMoney.fromAmount(
        amount * 0.15,
        currency: ErpCurrency.sar,
      ),
      expectedDelivery: DateTime(2026, 9, 20),
      warehouse: 'MAIN',
    );

void main() {
  const analytics = GeniusPurchasingAnalytics();

  test('partial receipt remains explicit', () {
    final entry = purchaseEntry(
      supplier: 'S1',
      item: 'SKU-AR-001',
      ordered: 10,
      received: 4,
    );

    expect(entry.isPartiallyReceived, isTrue);
    expect(entry.outstandingQuantity, 6);
  });

  test('outstanding PO filters complete receipts', () {
    final report = analytics.outstandingPurchaseOrders([
      purchaseEntry(
        supplier: 'S1',
        item: 'I1',
        ordered: 10,
        received: 10,
      ),
      purchaseEntry(
        supplier: 'S2',
        item: 'I2',
        ordered: 10,
        received: 5,
      ),
    ]);

    expect(report.rows, hasLength(1));
    expect(report.rows.single.cells['open'], 5);
  });

  test('quotation comparison identifies lowest same-currency quote', () {
    final report = analytics.quotationComparison([
      GeniusSupplierQuoteLine(
        supplierId: 'S1',
        supplierName: 'Supplier 1',
        itemCode: 'SKU-001',
        itemDescription: 'Item',
        unitPrice: ErpMoney.fromAmount(
          100,
          currency: ErpCurrency.sar,
        ),
      ),
      GeniusSupplierQuoteLine(
        supplierId: 'S2',
        supplierName: 'Supplier 2',
        itemCode: 'SKU-001',
        itemDescription: 'Item',
        unitPrice: ErpMoney.fromAmount(
          90,
          currency: ErpCurrency.sar,
        ),
      ),
    ]);

    expect(
      report.rows.where((row) => row.cells['best'] == '✓'),
      hasLength(1),
    );
    expect(
      report.rows.firstWhere(
        (row) => row.cells['best'] == '✓',
      ).cells['price'],
      90,
    );
  });

  test('supplier aging is deterministic', () {
    final report = analytics.supplierAging(
      [
        GeniusErpOpenItem(
          partyId: 'S1',
          partyName: 'Supplier',
          documentNumber: 'PI-1',
          issueDate: DateTime(2026, 6, 1),
          dueDate: DateTime(2026, 6, 30),
          amount: ErpMoney.fromAmount(
            250,
            currency: ErpCurrency.sar,
          ),
        ),
      ],
      asOf: DateTime(2026, 9, 4),
    );

    expect(report.rows.last.cells['amount'], 250);
  });
}
