
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

const box = ErpUnit(
  code: 'BOX',
  name: 'Box',
  nameAr: 'كرتون',
  precision: 3,
);

GeniusInventoryMovementLine movement({
  required GeniusInventoryMovementKind kind,
  required double quantity,
  double? baseQuantity,
  String itemCode = 'SKU-001',
  String? batch = 'B-01',
  String? serial = 'SN-001',
}) =>
    GeniusInventoryMovementLine(
      date: DateTime(2026, 9, 4),
      documentNumber: 'MOV-001',
      kind: kind,
      itemCode: itemCode,
      itemName: 'Long Inventory Product Name',
      itemNameAr: 'اسم صنف مخزون عربي طويل',
      quantity: quantity,
      unit: box,
      baseQuantity: baseQuantity,
      baseUnit: ErpUnit.each,
      sourceWarehouse: 'WH-A',
      sourceLocation: 'A-01',
      destinationWarehouse: 'WH-B',
      destinationLocation: 'B-02',
      batch: batch == null ? null : ErpBatchInfo(batchNumber: batch),
      serials: serial == null
          ? const []
          : [ErpSerialInfo(serialNumber: serial)],
      expiryDate: DateTime(2027, 12, 31),
      unitCost: ErpMoney.fromAmount(
        12.5,
        currency: ErpCurrency.sar,
      ),
    );

void main() {
  const service = GeniusInventoryService();

  test('multi-unit and fractional quantity use explicit base quantity', () {
    final line = movement(
      kind: GeniusInventoryMovementKind.receipt,
      quantity: 1.5,
      baseQuantity: 18,
    );

    expect(line.quantity, 1.5);
    expect(line.unit.code, 'BOX');
    expect(line.effectiveBaseQuantity, 18);
  });

  test('stock ledger signs receipt and issue movements', () {
    final report = service.stockLedger([
      movement(
        kind: GeniusInventoryMovementKind.receipt,
        quantity: 10,
        baseQuantity: 10,
      ),
      movement(
        kind: GeniusInventoryMovementKind.issue,
        quantity: 3,
        baseQuantity: 3,
      ),
    ]);

    expect(report.rows[0].cells['balance'], 10);
    expect(report.rows[1].cells['balance'], 7);
  });

  test('count reconciliation includes only variance rows', () {
    final report = service.countReconciliation(
      const [
        GeniusInventoryCountLine(
          itemCode: 'A',
          itemName: 'A',
          unit: ErpUnit.each,
          systemQuantity: 10,
          countedQuantity: 10,
        ),
        GeniusInventoryCountLine(
          itemCode: 'B',
          itemName: 'B',
          unit: ErpUnit.each,
          systemQuantity: 10,
          countedQuantity: 8.5,
        ),
      ],
    );

    expect(report.rows, hasLength(1));
    expect(report.rows.single.cells['variance'], -1.5);
  });

  test('availability/reorder/min-max are calculation-testable', () {
    final positions = [
      GeniusInventoryStockPosition(
        itemCode: 'SKU-1',
        itemName: 'Item',
        unit: ErpUnit.each,
        onHand: 5,
        reserved: 3,
        unitCost: ErpMoney.fromAmount(
          10,
          currency: ErpCurrency.sar,
        ),
        reorderPoint: 3,
        minimum: 4,
        maximum: 20,
      ),
    ];

    expect(positions.single.available, 2);
    expect(positions.single.needsReorder, isTrue);
    expect(service.reorderReport(positions).rows, hasLength(1));
    expect(service.minMaxReport(positions).rows, hasLength(1));
  });

  test('valuation is calculated outside renderer', () {
    final position = GeniusInventoryStockPosition(
      itemCode: 'SKU-1',
      itemName: 'Item',
      unit: ErpUnit.each,
      onHand: 2.5,
      reserved: 0,
      unitCost: ErpMoney.fromAmount(
        4,
        currency: ErpCurrency.sar,
      ),
    );

    expect(position.stockValue.toDouble(), 10);
    expect(
      service.stockValuation([position]).rows.single.cells['value'],
      10,
    );
  });

  test('batch serial expiry values coexist with Arabic name and Latin SKU', () {
    final report = service.stockLedger([
      movement(
        kind: GeniusInventoryMovementKind.receipt,
        quantity: 1,
        itemCode: 'LATIN-SKU-001',
      ),
    ]);

    final row = report.rows.single;
    expect(row.cells['item'], 'LATIN-SKU-001');
    expect(row.cells['trace'].toString(), contains('B-01'));
    expect(row.cells['trace'].toString(), contains('SN-001'));
    expect(row.cells['trace'].toString(), contains('2027-12-31'));
  });
}
