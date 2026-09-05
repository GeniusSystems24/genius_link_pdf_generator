// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S15InventoryWmsPackVerificationPage.
enum S15InventoryWmsPackScenario {
  stockReceipt,
  stockIssue,
  stockTransfer,
  warehouseTransfer,
  adjustment,
  stockCount,
  cycleCount,
  reconciliation,
  itemCard,
  stockLedger,
  valuation,
  availability,
  reorder,
  minMax,
  slowDead,
  batchReport,
  serialReport,
  expiryReport,
  itemLabel,
  shelfLabel,
  batchLabel,
  serialLabel,
  locationLabel,
}

/// Executes one focused S15 verification scenario.
class S15InventoryWmsPackRunner {
  S15InventoryWmsPackRunner({
    required GeniusPdfConfig baseConfig,
    required S15InventoryWmsPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S15InventoryWmsPackScenario _scenario;
bool _rtl = false;
  final int _rowCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S15InventoryWmsPackScenario value) => switch (value) {
        S15InventoryWmsPackScenario.stockReceipt => 'Stock Receipt',
        S15InventoryWmsPackScenario.stockIssue => 'Stock Issue',
        S15InventoryWmsPackScenario.stockTransfer => 'Stock Transfer',
        S15InventoryWmsPackScenario.warehouseTransfer => 'Warehouse Transfer',
        S15InventoryWmsPackScenario.adjustment => 'Stock Adjustment',
        S15InventoryWmsPackScenario.stockCount => 'Stock Count',
        S15InventoryWmsPackScenario.cycleCount => 'Cycle Count',
        S15InventoryWmsPackScenario.reconciliation => 'Count Reconciliation',
        S15InventoryWmsPackScenario.itemCard => 'Item Card',
        S15InventoryWmsPackScenario.stockLedger => 'Stock Ledger',
        S15InventoryWmsPackScenario.valuation => 'Stock Valuation',
        S15InventoryWmsPackScenario.availability => 'Stock Availability',
        S15InventoryWmsPackScenario.reorder => 'Reorder Report',
        S15InventoryWmsPackScenario.minMax => 'Min / Max Report',
        S15InventoryWmsPackScenario.slowDead => 'Slow / Dead Stock',
        S15InventoryWmsPackScenario.batchReport => 'Batch Report',
        S15InventoryWmsPackScenario.serialReport => 'Serial Report',
        S15InventoryWmsPackScenario.expiryReport => 'Expiry Report',
        S15InventoryWmsPackScenario.itemLabel => 'Item Label',
        S15InventoryWmsPackScenario.shelfLabel => 'Shelf Label',
        S15InventoryWmsPackScenario.batchLabel => 'Batch Label',
        S15InventoryWmsPackScenario.serialLabel => 'Serial Label',
        S15InventoryWmsPackScenario.locationLabel => 'Location Label',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S15 public API in '
      '${_rtl ? 'RTL' : 'LTR'} with $_rowCount row(s). Arabic item names '
      'and Latin SKU/batch/serial values remain readable; fractional and '
      'multi-unit quantities are not rounded away; long/large data must '
      'paginate without clipping.';

  Future<Uint8List> generate() async {
    const service = GeniusInventoryService();
    final config = _config;
    final movements = _movements(_rowCount);
    final positions = _positions(_rowCount);
    final traces = _traceability(_rowCount);
    final labels = _labels(_rowCount.clamp(1, 50).toInt());
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S15InventoryWmsPackScenario.stockReceipt:
        document = GeniusStockReceiptDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.receipt,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.stockIssue:
        document = GeniusStockIssueDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.issue,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.stockTransfer:
        document = GeniusStockTransferDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.stockTransfer,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.warehouseTransfer:
        document = GeniusWarehouseTransferDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.warehouseTransfer,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.adjustment:
        document = GeniusStockAdjustmentDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.adjustment,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.stockCount:
        document = GeniusStockCountDocument(
          config,
          report: service.stockCount(_counts(_rowCount)),
        );
        break;
      case S15InventoryWmsPackScenario.cycleCount:
        document = GeniusCycleCountDocument(
          config,
          report: service.stockCount(
            _counts(_rowCount),
            cycleCount: true,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.reconciliation:
        document = GeniusCountReconciliationDocument(
          config,
          report: service.countReconciliation(
            _counts(_rowCount),
          ),
        );
        break;
      case S15InventoryWmsPackScenario.itemCard:
        document = GeniusItemCardDocument(
          config,
          report: service.itemCard(
            movements,
            itemCode: movements.first.itemCode,
          ),
        );
        break;
      case S15InventoryWmsPackScenario.stockLedger:
        document = GeniusStockLedgerDocument(
          config,
          report: service.stockLedger(movements),
        );
        break;
      case S15InventoryWmsPackScenario.valuation:
        document = GeniusStockValuationDocument(
          config,
          report: service.stockValuation(positions),
        );
        break;
      case S15InventoryWmsPackScenario.availability:
        document = GeniusStockAvailabilityDocument(
          config,
          report: service.stockAvailability(positions),
        );
        break;
      case S15InventoryWmsPackScenario.reorder:
        document = GeniusReorderReport(
          config,
          report: service.reorderReport(positions),
        );
        break;
      case S15InventoryWmsPackScenario.minMax:
        document = GeniusInventoryMinMaxReport(
          config,
          report: service.minMaxReport(positions),
        );
        break;
      case S15InventoryWmsPackScenario.slowDead:
        document = GeniusSlowDeadStockReport(
          config,
          report: service.slowDeadStock(
            positions,
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case S15InventoryWmsPackScenario.batchReport:
        document = GeniusBatchReport(
          config,
          report: service.batchReport(traces),
        );
        break;
      case S15InventoryWmsPackScenario.serialReport:
        document = GeniusSerialReport(
          config,
          report: service.serialReport(traces),
        );
        break;
      case S15InventoryWmsPackScenario.expiryReport:
        document = GeniusExpiryReport(
          config,
          report: service.expiryReport(traces),
        );
        break;
      case S15InventoryWmsPackScenario.itemLabel:
        document = GeniusInventoryItemLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case S15InventoryWmsPackScenario.shelfLabel:
        document = GeniusShelfLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case S15InventoryWmsPackScenario.batchLabel:
        document = GeniusBatchLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case S15InventoryWmsPackScenario.serialLabel:
        document = GeniusSerialLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case S15InventoryWmsPackScenario.locationLabel:
        document = GeniusLocationLabelDocument(
          config: config,
          records: labels,
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  List<GeniusInventoryMovementLine> _movements(int count) {
    const box = ErpUnit(
      code: 'BOX',
      name: 'Box',
      nameAr: 'كرتون',
      precision: 3,
    );

    return List.generate(
      count,
      (index) {
        final kind = GeniusInventoryMovementKind
            .values[index % GeniusInventoryMovementKind.values.length];
        final quantity = 1.25 + (index % 5);
        final baseQuantity = quantity * 12;

        return GeniusInventoryMovementLine(
          date: DateTime(2026, 9, (index % 28) + 1),
          documentNumber: 'MOV-${index + 1}',
          kind: kind,
          itemCode: 'SKU-${(index + 1).toString().padLeft(6, '0')}',
          itemName: index == 0
              ? 'Very long inventory item name for wrapping and pagination verification'
              : 'Inventory Item ${index + 1}',
          itemNameAr: index == 0
              ? 'اسم صنف مخزون عربي طويل جداً للتحقق من التفاف النص وترقيم الصفحات'
              : 'صنف مخزون ${index + 1}',
          quantity: quantity,
          unit: box,
          baseQuantity: baseQuantity,
          baseUnit: ErpUnit.each,
          sourceWarehouse: 'WH-A',
          sourceLocation: 'A-${index % 20}',
          destinationWarehouse: 'WH-B',
          destinationLocation: 'B-${index % 20}',
          batch: ErpBatchInfo(
            batchNumber: 'BATCH-${index % 10}',
            expiryDate: DateTime(2027, 12, 31),
          ),
          serials: [
            ErpSerialInfo(
              serialNumber: 'SN-${100000 + index}',
            ),
          ],
          expiryDate: DateTime(2027, 12, 31),
          unitCost: ErpMoney.fromAmount(
            12.5 + index % 5,
            currency: ErpCurrency.sar,
          ),
          notes: 'Movement note ${index + 1}',
          notesAr: 'ملاحظة حركة ${index + 1}',
        );
      },
    );
  }

  List<GeniusInventoryCountLine> _counts(int count) =>
      List.generate(
        count,
        (index) => GeniusInventoryCountLine(
          itemCode: 'SKU-${index + 1}',
          itemName: 'Count Item ${index + 1}',
          itemNameAr: 'صنف جرد ${index + 1}',
          unit: ErpUnit.each,
          systemQuantity: 10 + index % 4,
          countedQuantity:
              10 + index % 4 + (index.isEven ? 0.5 : -1.25),
          warehouse: 'WH-A',
          location: 'A-${index % 20}',
          batch: 'BATCH-${index % 10}',
          serial: 'SN-${100000 + index}',
        ),
      );

  List<GeniusInventoryStockPosition> _positions(int count) =>
      List.generate(
        count,
        (index) => GeniusInventoryStockPosition(
          itemCode: 'SKU-${index + 1}',
          itemName: 'Stock Item ${index + 1}',
          itemNameAr: 'صنف مخزون ${index + 1}',
          unit: ErpUnit.each,
          onHand: 2.5 + index % 20,
          reserved: index % 5,
          unitCost: ErpMoney.fromAmount(
            4.25 + index % 7,
            currency: ErpCurrency.sar,
          ),
          warehouse: 'WH-${index % 3 + 1}',
          location: 'LOC-${index % 30}',
          reorderPoint: 5,
          minimum: 3,
          maximum: 18,
          lastMovementAt: DateTime(
            2026,
            index % 3 == 0 ? 1 : 8,
            (index % 28) + 1,
          ),
        ),
      );

  List<GeniusInventoryTraceabilityRecord> _traceability(int count) =>
      List.generate(
        count,
        (index) => GeniusInventoryTraceabilityRecord(
          itemCode: 'LATIN-SKU-${index + 1}',
          itemName: 'Trace Item ${index + 1}',
          itemNameAr: 'صنف تتبع ${index + 1}',
          batch: 'BATCH-${index % 10}',
          serial: 'SN-${100000 + index}',
          expiryDate: DateTime(2027, 12, 31),
          warehouse: 'WH-A',
          location: 'A-${index % 20}',
          quantity: 1.25 + index % 3,
          unit: ErpUnit.each,
        ),
      );

  List<GeniusInventoryLabelRecord> _labels(int count) =>
      List.generate(
        count,
        (index) => GeniusInventoryLabelRecord(
          itemCode: 'SKU-${index + 1}',
          itemName: 'Label Item ${index + 1}',
          itemNameAr: 'صنف ملصق ${index + 1}',
          shelf: 'S-${index % 10}',
          location: 'A-${index % 20}',
          batch: 'B-${index % 6}',
          serial: 'SN-${100000 + index}',
          expiryDate: DateTime(2027, 12, 31),
          price: ErpMoney.fromAmount(
            25 + index,
            currency: ErpCurrency.sar,
          ),
          qrData: 'https://example.com/items/${index + 1}',
        ),
      );
}


Future<Uint8List> buildS15StockReceiptVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockReceipt,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15StockIssueVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockIssue,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15StockTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15WarehouseTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.warehouseTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15AdjustmentVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.adjustment,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15StockCountVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockCount,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15CycleCountVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.cycleCount,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ReconciliationVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.reconciliation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ItemCardVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.itemCard,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15StockLedgerVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.stockLedger,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ValuationVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.valuation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15AvailabilityVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.availability,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ReorderVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.reorder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15MinMaxVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.minMax,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15SlowDeadVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.slowDead,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15BatchReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.batchReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15SerialReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.serialReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ExpiryReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.expiryReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ItemLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.itemLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15ShelfLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.shelfLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15BatchLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.batchLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15SerialLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.serialLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS15LocationLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S15InventoryWmsPackRunner(
    baseConfig: config,
    scenario: S15InventoryWmsPackScenario.locationLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
