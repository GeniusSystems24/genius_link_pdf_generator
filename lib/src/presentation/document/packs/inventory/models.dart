
import '../../../../domain/erp/erp.dart';

/// S15 stock movement semantics.
enum GeniusInventoryMovementKind {
  receipt,
  issue,
  stockTransfer,
  warehouseTransfer,
  adjustment,
}

/// Inventory movement line with multi-unit and traceability metadata.
class GeniusInventoryMovementLine {
  const GeniusInventoryMovementLine({
    required this.date,
    required this.documentNumber,
    required this.kind,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.unit,
    this.itemNameAr,
    this.baseQuantity,
    this.baseUnit,
    this.sourceWarehouse,
    this.sourceLocation,
    this.destinationWarehouse,
    this.destinationLocation,
    this.batch,
    this.serials = const [],
    this.expiryDate,
    this.unitCost,
    this.notes,
    this.notesAr,
  });

  final DateTime date;
  final String documentNumber;
  final GeniusInventoryMovementKind kind;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;

  /// Transaction-unit quantity; may be fractional.
  final double quantity;
  final ErpUnit unit;

  /// Optional normalized/base-unit quantity for multi-unit reporting.
  final double? baseQuantity;
  final ErpUnit? baseUnit;

  final String? sourceWarehouse;
  final String? sourceLocation;
  final String? destinationWarehouse;
  final String? destinationLocation;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final DateTime? expiryDate;
  final ErpMoney? unitCost;
  final String? notes;
  final String? notesAr;

  double get effectiveBaseQuantity => baseQuantity ?? quantity;

  String get traceabilityText {
    final values = <String>[
      if (batch != null) 'Batch ${batch!.batchNumber}',
      if (serials.isNotEmpty)
        'Serial ${serials.map((e) => e.serialNumber).join(', ')}',
      if (expiryDate != null)
        'Exp ${expiryDate!.toIso8601String().split('T').first}',
    ];
    return values.join(' · ');
  }
}

/// Count/cycle-count line.
class GeniusInventoryCountLine {
  const GeniusInventoryCountLine({
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.systemQuantity,
    required this.countedQuantity,
    this.itemNameAr,
    this.warehouse,
    this.location,
    this.batch,
    this.serial,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final ErpUnit unit;
  final double systemQuantity;
  final double countedQuantity;
  final String? warehouse;
  final String? location;
  final String? batch;
  final String? serial;

  double get variance => countedQuantity - systemQuantity;
}

/// Snapshot used by stock valuation/availability/reorder/min-max reports.
class GeniusInventoryStockPosition {
  const GeniusInventoryStockPosition({
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.onHand,
    required this.reserved,
    required this.unitCost,
    this.itemNameAr,
    this.warehouse,
    this.location,
    this.reorderPoint = 0,
    this.minimum = 0,
    this.maximum,
    this.lastMovementAt,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final ErpUnit unit;
  final double onHand;
  final double reserved;
  final ErpMoney unitCost;
  final String? warehouse;
  final String? location;
  final double reorderPoint;
  final double minimum;
  final double? maximum;
  final DateTime? lastMovementAt;

  double get available => onHand - reserved;

  ErpMoney get stockValue => unitCost.multiply(onHand);

  bool get needsReorder => available <= reorderPoint;

  bool get belowMinimum => available < minimum;

  bool get aboveMaximum =>
      maximum != null && available > maximum!;
}

/// Traceability record for batch/serial/expiry reporting.
class GeniusInventoryTraceabilityRecord {
  const GeniusInventoryTraceabilityRecord({
    required this.itemCode,
    required this.itemName,
    this.itemNameAr,
    this.batch,
    this.serial,
    this.expiryDate,
    this.warehouse,
    this.location,
    this.quantity,
    this.unit,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final String? batch;
  final String? serial;
  final DateTime? expiryDate;
  final String? warehouse;
  final String? location;
  final double? quantity;
  final ErpUnit? unit;
}

/// Semantic inventory label payload used by S15 label documents.
class GeniusInventoryLabelRecord {
  const GeniusInventoryLabelRecord({
    required this.itemCode,
    required this.itemName,
    this.itemNameAr,
    this.shelf,
    this.location,
    this.batch,
    this.serial,
    this.expiryDate,
    this.price,
    this.qrData,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final String? shelf;
  final String? location;
  final String? batch;
  final String? serial;
  final DateTime? expiryDate;
  final ErpMoney? price;
  final String? qrData;
}
