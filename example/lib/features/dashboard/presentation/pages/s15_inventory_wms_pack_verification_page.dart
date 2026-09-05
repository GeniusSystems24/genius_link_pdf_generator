
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S15Scenario {
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

class S15InventoryWmsPackVerificationPage extends StatefulWidget {
  const S15InventoryWmsPackVerificationPage({super.key});

  @override
  State<S15InventoryWmsPackVerificationPage> createState() =>
      _S15InventoryWmsPackVerificationPageState();
}

class _S15InventoryWmsPackVerificationPageState
    extends State<S15InventoryWmsPackVerificationPage> {
  _S15Scenario _scenario = _S15Scenario.stockLedger;
  bool _rtl = false;
  int _rowCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S15Scenario value) => switch (value) {
        _S15Scenario.stockReceipt => 'Stock Receipt',
        _S15Scenario.stockIssue => 'Stock Issue',
        _S15Scenario.stockTransfer => 'Stock Transfer',
        _S15Scenario.warehouseTransfer => 'Warehouse Transfer',
        _S15Scenario.adjustment => 'Stock Adjustment',
        _S15Scenario.stockCount => 'Stock Count',
        _S15Scenario.cycleCount => 'Cycle Count',
        _S15Scenario.reconciliation => 'Count Reconciliation',
        _S15Scenario.itemCard => 'Item Card',
        _S15Scenario.stockLedger => 'Stock Ledger',
        _S15Scenario.valuation => 'Stock Valuation',
        _S15Scenario.availability => 'Stock Availability',
        _S15Scenario.reorder => 'Reorder Report',
        _S15Scenario.minMax => 'Min / Max Report',
        _S15Scenario.slowDead => 'Slow / Dead Stock',
        _S15Scenario.batchReport => 'Batch Report',
        _S15Scenario.serialReport => 'Serial Report',
        _S15Scenario.expiryReport => 'Expiry Report',
        _S15Scenario.itemLabel => 'Item Label',
        _S15Scenario.shelfLabel => 'Shelf Label',
        _S15Scenario.batchLabel => 'Batch Label',
        _S15Scenario.serialLabel => 'Serial Label',
        _S15Scenario.locationLabel => 'Location Label',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S15 public API in '
      '${_rtl ? 'RTL' : 'LTR'} with $_rowCount row(s). Arabic item names '
      'and Latin SKU/batch/serial values remain readable; fractional and '
      'multi-unit quantities are not rounded away; long/large data must '
      'paginate without clipping.';

  Future<Uint8List> _generate() async {
    const service = GeniusInventoryService();
    final config = _config;
    final movements = _movements(_rowCount);
    final positions = _positions(_rowCount);
    final traces = _traceability(_rowCount);
    final labels = _labels(_rowCount.clamp(1, 50).toInt());
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S15Scenario.stockReceipt:
        document = GeniusStockReceiptDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.receipt,
          ),
        );
        break;
      case _S15Scenario.stockIssue:
        document = GeniusStockIssueDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.issue,
          ),
        );
        break;
      case _S15Scenario.stockTransfer:
        document = GeniusStockTransferDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.stockTransfer,
          ),
        );
        break;
      case _S15Scenario.warehouseTransfer:
        document = GeniusWarehouseTransferDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.warehouseTransfer,
          ),
        );
        break;
      case _S15Scenario.adjustment:
        document = GeniusStockAdjustmentDocument(
          config,
          report: service.movementDocument(
            movements,
            kind: GeniusInventoryMovementKind.adjustment,
          ),
        );
        break;
      case _S15Scenario.stockCount:
        document = GeniusStockCountDocument(
          config,
          report: service.stockCount(_counts(_rowCount)),
        );
        break;
      case _S15Scenario.cycleCount:
        document = GeniusCycleCountDocument(
          config,
          report: service.stockCount(
            _counts(_rowCount),
            cycleCount: true,
          ),
        );
        break;
      case _S15Scenario.reconciliation:
        document = GeniusCountReconciliationDocument(
          config,
          report: service.countReconciliation(
            _counts(_rowCount),
          ),
        );
        break;
      case _S15Scenario.itemCard:
        document = GeniusItemCardDocument(
          config,
          report: service.itemCard(
            movements,
            itemCode: movements.first.itemCode,
          ),
        );
        break;
      case _S15Scenario.stockLedger:
        document = GeniusStockLedgerDocument(
          config,
          report: service.stockLedger(movements),
        );
        break;
      case _S15Scenario.valuation:
        document = GeniusStockValuationDocument(
          config,
          report: service.stockValuation(positions),
        );
        break;
      case _S15Scenario.availability:
        document = GeniusStockAvailabilityDocument(
          config,
          report: service.stockAvailability(positions),
        );
        break;
      case _S15Scenario.reorder:
        document = GeniusReorderReport(
          config,
          report: service.reorderReport(positions),
        );
        break;
      case _S15Scenario.minMax:
        document = GeniusInventoryMinMaxReport(
          config,
          report: service.minMaxReport(positions),
        );
        break;
      case _S15Scenario.slowDead:
        document = GeniusSlowDeadStockReport(
          config,
          report: service.slowDeadStock(
            positions,
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S15Scenario.batchReport:
        document = GeniusBatchReport(
          config,
          report: service.batchReport(traces),
        );
        break;
      case _S15Scenario.serialReport:
        document = GeniusSerialReport(
          config,
          report: service.serialReport(traces),
        );
        break;
      case _S15Scenario.expiryReport:
        document = GeniusExpiryReport(
          config,
          report: service.expiryReport(traces),
        );
        break;
      case _S15Scenario.itemLabel:
        document = GeniusInventoryItemLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case _S15Scenario.shelfLabel:
        document = GeniusShelfLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case _S15Scenario.batchLabel:
        document = GeniusBatchLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case _S15Scenario.serialLabel:
        document = GeniusSerialLabelDocument(
          config: config,
          records: labels,
        );
        break;
      case _S15Scenario.locationLabel:
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

  void _refresh() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S15 — Inventory & WMS Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<_S15Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S15Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 100, label: Text('100')),
                          ButtonSegment(value: 1000, label: Text('1k')),
                        ],
                        selected: {_rowCount},
                        onSelectionChanged: (value) {
                          _rowCount = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's15_inventory_wms_pack.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
