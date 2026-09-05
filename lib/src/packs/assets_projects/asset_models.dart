
import '../../domain/erp/erp.dart';

/// Fixed-asset lifecycle state.
enum GeniusAssetStatus {
  draft,
  active,
  idle,
  assigned,
  underMaintenance,
  disposed,
}

/// Asset movement/action semantics.
enum GeniusAssetMovementKind {
  acquisition,
  transfer,
  assignment,
  returnToStore,
  disposal,
  countAdjustment,
  maintenance,
}

/// Depreciation method supported by the S19 calculation service.
enum GeniusAssetDepreciationMethod {
  straightLine,
  decliningBalance,
}

/// Core fixed-asset card.
class GeniusFixedAsset {
  const GeniusFixedAsset({
    required this.assetId,
    required this.assetTag,
    required this.name,
    required this.acquisitionDate,
    required this.inServiceDate,
    required this.acquisitionCost,
    required this.residualValue,
    required this.usefulLifeMonths,
    this.nameAr,
    this.serialNumber,
    this.category,
    this.categoryAr,
    this.location,
    this.locationAr,
    this.department,
    this.departmentAr,
    this.custodian,
    this.custodianAr,
    this.manufacturer,
    this.model,
    this.status = GeniusAssetStatus.active,
    this.notes,
    this.notesAr,
    this.metadata = const {},
  })  : assert(usefulLifeMonths > 0);

  final String assetId;

  /// Physical/printed asset tag. This is always a structured LTR value.
  final String assetTag;

  final String name;
  final String? nameAr;
  final String? serialNumber;
  final String? category;
  final String? categoryAr;
  final DateTime acquisitionDate;
  final DateTime inServiceDate;
  final ErpMoney acquisitionCost;
  final ErpMoney residualValue;
  final int usefulLifeMonths;
  final String? location;
  final String? locationAr;
  final String? department;
  final String? departmentAr;
  final String? custodian;
  final String? custodianAr;
  final String? manufacturer;
  final String? model;
  final GeniusAssetStatus status;
  final String? notes;
  final String? notesAr;
  final Map<String, Object?> metadata;

  ErpMoney get depreciableBase => acquisitionCost - residualValue;
}

/// One asset transfer/assignment/return/disposal/count movement.
class GeniusAssetMovement {
  const GeniusAssetMovement({
    required this.reference,
    required this.asset,
    required this.date,
    required this.kind,
    this.fromLocation,
    this.fromLocationAr,
    this.toLocation,
    this.toLocationAr,
    this.fromCustodian,
    this.fromCustodianAr,
    this.toCustodian,
    this.toCustodianAr,
    this.reason,
    this.reasonAr,
    this.disposalProceeds,
    this.notes,
    this.notesAr,
  });

  final String reference;
  final GeniusFixedAsset asset;
  final DateTime date;
  final GeniusAssetMovementKind kind;
  final String? fromLocation;
  final String? fromLocationAr;
  final String? toLocation;
  final String? toLocationAr;
  final String? fromCustodian;
  final String? fromCustodianAr;
  final String? toCustodian;
  final String? toCustodianAr;
  final String? reason;
  final String? reasonAr;
  final ErpMoney? disposalProceeds;
  final String? notes;
  final String? notesAr;
}

/// One planned/performed asset maintenance entry.
class GeniusAssetMaintenanceEntry {
  const GeniusAssetMaintenanceEntry({
    required this.reference,
    required this.asset,
    required this.date,
    required this.description,
    this.descriptionAr,
    this.vendor,
    this.vendorAr,
    this.cost,
    this.nextDueDate,
    this.notes,
    this.notesAr,
  });

  final String reference;
  final GeniusFixedAsset asset;
  final DateTime date;
  final String description;
  final String? descriptionAr;
  final String? vendor;
  final String? vendorAr;
  final ErpMoney? cost;
  final DateTime? nextDueDate;
  final String? notes;
  final String? notesAr;
}

/// Physical asset-count observation.
class GeniusAssetCountEntry {
  const GeniusAssetCountEntry({
    required this.asset,
    required this.countedAt,
    required this.found,
    this.location,
    this.locationAr,
    this.condition,
    this.conditionAr,
    this.countedBy,
    this.notes,
    this.notesAr,
  });

  final GeniusFixedAsset asset;
  final DateTime countedAt;
  final bool found;
  final String? location;
  final String? locationAr;
  final String? condition;
  final String? conditionAr;
  final String? countedBy;
  final String? notes;
  final String? notesAr;
}

/// One depreciation period result.
class GeniusAssetDepreciationLine {
  const GeniusAssetDepreciationLine({
    required this.periodIndex,
    required this.periodStart,
    required this.periodEnd,
    required this.openingBookValue,
    required this.depreciation,
    required this.accumulatedDepreciation,
    required this.closingBookValue,
  });

  final int periodIndex;
  final DateTime periodStart;
  final DateTime periodEnd;
  final ErpMoney openingBookValue;
  final ErpMoney depreciation;
  final ErpMoney accumulatedDepreciation;
  final ErpMoney closingBookValue;
}

/// Reconciled depreciation result.
class GeniusAssetDepreciationResult {
  const GeniusAssetDepreciationResult({
    required this.asset,
    required this.asOf,
    required this.method,
    required this.lines,
    required this.accumulatedDepreciation,
    required this.netBookValue,
  });

  final GeniusFixedAsset asset;
  final DateTime asOf;
  final GeniusAssetDepreciationMethod method;
  final List<GeniusAssetDepreciationLine> lines;
  final ErpMoney accumulatedDepreciation;
  final ErpMoney netBookValue;

  /// S19-T26 reconciliation contract.
  bool get reconciles {
    final total =
        accumulatedDepreciation.toDouble() + netBookValue.toDouble();
    final cost = asset.acquisitionCost.toDouble();
    return (total - cost).abs() < 0.01;
  }
}
