
import '../../domain/erp/erp.dart';
import '../manufacturing_quality/manufacturing_quality.dart';

/// Service/maintenance lifecycle.
enum GeniusServiceOrderStatus {
  draft,
  scheduled,
  dispatched,
  inProgress,
  waitingParts,
  completed,
  cancelled,
}

/// Shipment/trip lifecycle.
enum GeniusLogisticsStatus {
  planned,
  packed,
  dispatched,
  inTransit,
  delivered,
  exception,
  cancelled,
}

/// S20 reuses the S18 checklist primitive instead of copying pass/fail logic.
typedef GeniusServiceChecklistItem = GeniusQualityChecklistItem;

/// S20 checklist status is the same shared semantic status introduced in S18.
typedef GeniusServiceChecklistStatus = GeniusQualityStatus;

/// Technician/driver/person identity block — S20-T24.
class GeniusServicePersonIdentity {
  const GeniusServicePersonIdentity({
    required this.id,
    required this.name,
    this.nameAr,
    this.role,
    this.roleAr,
    this.phone,
    this.email,
    this.licenseNumber,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? role;
  final String? roleAr;
  final String? phone;
  final String? email;
  final String? licenseNumber;
}

/// Vehicle identity block — S20-T24.
class GeniusLogisticsVehicleIdentity {
  const GeniusLogisticsVehicleIdentity({
    required this.vehicleId,
    this.plateNumber,
    this.trailerNumber,
    this.make,
    this.model,
    this.capacity,
    this.capacityUnit,
  });

  final String vehicleId;
  final String? plateNumber;
  final String? trailerNumber;
  final String? make;
  final String? model;
  final double? capacity;
  final String? capacityUnit;
}

/// Geo/time metadata — S20-T27.
class GeniusGeoTimeMetadata {
  const GeniusGeoTimeMetadata({
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.locationName,
    this.locationNameAr,
    this.timeZone,
  });

  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? locationNameAr;
  final String? timeZone;

  String get coordinateText {
    if (latitude == null || longitude == null) return '';
    return '${latitude!.toStringAsFixed(6)}, '
        '${longitude!.toStringAsFixed(6)}';
  }
}

/// Attachment/photo reference slot — S20-T28.
class GeniusServiceAttachmentReference {
  const GeniusServiceAttachmentReference({
    required this.reference,
    required this.label,
    this.labelAr,
    this.uri,
    this.isPhoto = false,
    this.capturedAt,
  });

  final String reference;
  final String label;
  final String? labelAr;
  final String? uri;
  final bool isPhoto;
  final DateTime? capturedAt;
}

/// Route/reference block — S20-T23.
class GeniusLogisticsRouteReference {
  const GeniusLogisticsRouteReference({
    required this.routeCode,
    this.routeName,
    this.routeNameAr,
    this.origin,
    this.originAr,
    this.destination,
    this.destinationAr,
    this.externalReference,
  });

  final String routeCode;
  final String? routeName;
  final String? routeNameAr;
  final String? origin;
  final String? originAr;
  final String? destination;
  final String? destinationAr;
  final String? externalReference;
}

/// One route/manifest stop.
class GeniusLogisticsRouteStop {
  const GeniusLogisticsRouteStop({
    required this.sequence,
    required this.stopCode,
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.plannedArrival,
    this.actualArrival,
    this.metadata,
    this.reference,
    this.notes,
    this.notesAr,
  }) : assert(sequence >= 0);

  final int sequence;
  final String stopCode;
  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final DateTime? plannedArrival;
  final DateTime? actualArrival;
  final GeniusGeoTimeMetadata? metadata;
  final String? reference;
  final String? notes;
  final String? notesAr;
}

/// Service Order / Maintenance Work Order source.
class GeniusServiceOrderData {
  const GeniusServiceOrderData({
    required this.orderNumber,
    required this.openedAt,
    required this.subjectCode,
    required this.subjectName,
    this.subjectNameAr,
    this.customer,
    this.customerAr,
    this.assetTag,
    this.serialNumber,
    this.location,
    this.locationAr,
    this.problem,
    this.problemAr,
    this.requestedWork,
    this.requestedWorkAr,
    this.status = GeniusServiceOrderStatus.scheduled,
    this.priority,
    this.technician,
    this.scheduledAt,
    this.completedAt,
    this.checklist = const [],
    this.attachments = const [],
    this.notes,
    this.notesAr,
  });

  final String orderNumber;
  final DateTime openedAt;
  final String subjectCode;
  final String subjectName;
  final String? subjectNameAr;
  final String? customer;
  final String? customerAr;
  final String? assetTag;
  final String? serialNumber;
  final String? location;
  final String? locationAr;
  final String? problem;
  final String? problemAr;
  final String? requestedWork;
  final String? requestedWorkAr;
  final GeniusServiceOrderStatus status;
  final String? priority;
  final GeniusServicePersonIdentity? technician;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final List<GeniusServiceChecklistItem> checklist;
  final List<GeniusServiceAttachmentReference> attachments;
  final String? notes;
  final String? notesAr;
}

/// Preventive-maintenance schedule row.
class GeniusPreventiveMaintenanceEntry {
  const GeniusPreventiveMaintenanceEntry({
    required this.scheduleCode,
    required this.subjectCode,
    required this.subjectName,
    required this.nextDueDate,
    required this.frequencyDays,
    this.subjectNameAr,
    this.assetTag,
    this.location,
    this.locationAr,
    this.lastCompletedAt,
    this.assignedTechnician,
    this.checklist = const [],
  }) : assert(frequencyDays > 0);

  final String scheduleCode;
  final String subjectCode;
  final String subjectName;
  final String? subjectNameAr;
  final String? assetTag;
  final String? location;
  final String? locationAr;
  final DateTime nextDueDate;
  final int frequencyDays;
  final DateTime? lastCompletedAt;
  final GeniusServicePersonIdentity? assignedTechnician;
  final List<GeniusServiceChecklistItem> checklist;
}

/// Technician work report.
class GeniusTechnicianReportEntry {
  const GeniusTechnicianReportEntry({
    required this.serviceOrderNumber,
    required this.technician,
    required this.startedAt,
    required this.finishedAt,
    required this.workPerformed,
    this.workPerformedAr,
    this.diagnosis,
    this.diagnosisAr,
    this.laborHours,
    this.metadata,
    this.notes,
    this.notesAr,
  });

  final String serviceOrderNumber;
  final GeniusServicePersonIdentity technician;
  final DateTime startedAt;
  final DateTime finishedAt;
  final String workPerformed;
  final String? workPerformedAr;
  final String? diagnosis;
  final String? diagnosisAr;
  final double? laborHours;
  final GeniusGeoTimeMetadata? metadata;
  final String? notes;
  final String? notesAr;
}

/// Spare-part usage line.
class GeniusServiceSparePartUsage {
  const GeniusServiceSparePartUsage({
    required this.serviceOrderNumber,
    required this.partCode,
    required this.partName,
    required this.quantity,
    required this.unit,
    this.partNameAr,
    this.serialNumber,
    this.batchNumber,
    this.unitCost,
    this.notes,
    this.notesAr,
  }) : assert(quantity >= 0);

  final String serviceOrderNumber;
  final String partCode;
  final String partName;
  final String? partNameAr;
  final double quantity;
  final ErpUnit unit;
  final String? serialNumber;
  final String? batchNumber;
  final ErpMoney? unitCost;
  final String? notes;
  final String? notesAr;

  ErpMoney? get totalCost =>
      unitCost == null ? null : unitCost!.multiply(quantity);
}

/// Warranty row.
class GeniusServiceWarrantyEntry {
  const GeniusServiceWarrantyEntry({
    required this.reference,
    required this.subjectCode,
    required this.startDate,
    required this.endDate,
    this.subjectName,
    this.subjectNameAr,
    this.customer,
    this.customerAr,
    this.serialNumber,
    this.coverage,
    this.coverageAr,
    this.status,
  });

  final String reference;
  final String subjectCode;
  final String? subjectName;
  final String? subjectNameAr;
  final String? customer;
  final String? customerAr;
  final String? serialNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String? coverage;
  final String? coverageAr;
  final String? status;

  bool activeAt(DateTime value) =>
      !value.isBefore(startDate) && !value.isAfter(endDate);
}

/// Service inspection, reusing S18 quality measurement/checklist primitives.
class GeniusServiceInspectionData {
  const GeniusServiceInspectionData({
    required this.inspectionNumber,
    required this.date,
    required this.subjectCode,
    required this.subjectName,
    this.subjectNameAr,
    this.serviceOrderNumber,
    this.inspector,
    this.checklist = const [],
    this.measurements = const [],
    this.attachments = const [],
    this.notes,
    this.notesAr,
  });

  final String inspectionNumber;
  final DateTime date;
  final String subjectCode;
  final String subjectName;
  final String? subjectNameAr;
  final String? serviceOrderNumber;
  final GeniusServicePersonIdentity? inspector;
  final List<GeniusServiceChecklistItem> checklist;
  final List<GeniusQualityMeasurement> measurements;
  final List<GeniusServiceAttachmentReference> attachments;
  final String? notes;
  final String? notesAr;

  GeniusQualityStatus get overallStatus {
    if (checklist.any(
          (item) =>
              item.required &&
              item.status == GeniusQualityStatus.fail,
        ) ||
        measurements.any(
          (item) => item.status == GeniusQualityStatus.fail,
        )) {
      return GeniusQualityStatus.fail;
    }
    if (checklist.any(
      (item) => item.status == GeniusQualityStatus.warning,
    )) {
      return GeniusQualityStatus.warning;
    }
    return GeniusQualityStatus.pass;
  }
}

/// One calibration/service-history event.
class GeniusServiceHistoryEntry {
  const GeniusServiceHistoryEntry({
    required this.reference,
    required this.date,
    required this.subjectCode,
    required this.eventType,
    required this.description,
    this.descriptionAr,
    this.serviceOrderNumber,
    this.technician,
    this.measurements = const [],
    this.nextDueDate,
    this.notes,
    this.notesAr,
  });

  final String reference;
  final DateTime date;
  final String subjectCode;
  final String eventType;
  final String description;
  final String? descriptionAr;
  final String? serviceOrderNumber;
  final GeniusServicePersonIdentity? technician;
  final List<GeniusQualityMeasurement> measurements;
  final DateTime? nextDueDate;
  final String? notes;
  final String? notesAr;
}

/// Shipment/package line.
class GeniusShipmentItem {
  const GeniusShipmentItem({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unit,
    this.descriptionAr,
    this.packageCount = 1,
    this.weight,
    this.weightUnit,
    this.volume,
    this.volumeUnit,
    this.batchNumber,
    this.serialNumbers = const [],
    this.notes,
    this.notesAr,
  })  : assert(quantity >= 0),
        assert(packageCount >= 0);

  final String itemCode;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final ErpUnit unit;
  final int packageCount;
  final double? weight;
  final String? weightUnit;
  final double? volume;
  final String? volumeUnit;
  final String? batchNumber;
  final List<String> serialNumbers;
  final String? notes;
  final String? notesAr;
}

/// Shared Shipment/Packing/Dispatch/Waybill data.
class GeniusShipmentData {
  const GeniusShipmentData({
    required this.shipmentNumber,
    required this.trackingNumber,
    required this.shipDate,
    required this.route,
    required this.items,
    this.status = GeniusLogisticsStatus.planned,
    this.shipper,
    this.shipperAr,
    this.consignee,
    this.consigneeAr,
    this.shipperAddress,
    this.shipperAddressAr,
    this.consigneeAddress,
    this.consigneeAddressAr,
    this.carrier,
    this.carrierAr,
    this.vehicle,
    this.driver,
    this.stops = const [],
    this.references = const [],
    this.attachments = const [],
    this.notes,
    this.notesAr,
  });

  final String shipmentNumber;
  final String trackingNumber;
  final DateTime shipDate;
  final GeniusLogisticsRouteReference route;
  final GeniusLogisticsStatus status;
  final String? shipper;
  final String? shipperAr;
  final String? consignee;
  final String? consigneeAr;
  final String? shipperAddress;
  final String? shipperAddressAr;
  final String? consigneeAddress;
  final String? consigneeAddressAr;
  final String? carrier;
  final String? carrierAr;
  final GeniusLogisticsVehicleIdentity? vehicle;
  final GeniusServicePersonIdentity? driver;
  final List<GeniusLogisticsRouteStop> stops;
  final List<String> references;
  final List<GeniusShipmentItem> items;
  final List<GeniusServiceAttachmentReference> attachments;
  final String? notes;
  final String? notesAr;

  int get totalPackages =>
      items.fold(0, (sum, item) => sum + item.packageCount);

  double get totalWeight => items.fold<double>(
        0,
        (sum, item) => sum + (item.weight ?? 0),
      );
}

/// One container/pallet group.
class GeniusLogisticsContainerEntry {
  const GeniusLogisticsContainerEntry({
    required this.containerNumber,
    required this.containerType,
    required this.shipmentNumber,
    this.sealNumber,
    this.palletCount = 0,
    this.packageCount = 0,
    this.weight,
    this.weightUnit,
    this.notes,
    this.notesAr,
  })  : assert(palletCount >= 0),
        assert(packageCount >= 0);

  final String containerNumber;
  final String containerType;
  final String shipmentNumber;
  final String? sealNumber;
  final int palletCount;
  final int packageCount;
  final double? weight;
  final String? weightUnit;
  final String? notes;
  final String? notesAr;
}

/// Freight-cost summary.
class GeniusFreightSummaryEntry {
  const GeniusFreightSummaryEntry({
    required this.shipmentNumber,
    required this.chargeType,
    required this.amount,
    this.chargeTypeAr,
    this.carrier,
    this.carrierAr,
    this.reference,
  });

  final String shipmentNumber;
  final String chargeType;
  final String? chargeTypeAr;
  final ErpMoney amount;
  final String? carrier;
  final String? carrierAr;
  final String? reference;
}

/// Trip Sheet/Report source.
class GeniusTripData {
  const GeniusTripData({
    required this.tripNumber,
    required this.route,
    required this.departureAt,
    required this.vehicle,
    required this.driver,
    this.returnAt,
    this.shipmentNumbers = const [],
    this.stops = const [],
    this.openingOdometer,
    this.closingOdometer,
    this.fuelQuantity,
    this.fuelUnit,
    this.attachments = const [],
    this.notes,
    this.notesAr,
  });

  final String tripNumber;
  final GeniusLogisticsRouteReference route;
  final DateTime departureAt;
  final DateTime? returnAt;
  final GeniusLogisticsVehicleIdentity vehicle;
  final GeniusServicePersonIdentity driver;
  final List<String> shipmentNumbers;
  final List<GeniusLogisticsRouteStop> stops;
  final double? openingOdometer;
  final double? closingOdometer;
  final double? fuelQuantity;
  final String? fuelUnit;
  final List<GeniusServiceAttachmentReference> attachments;
  final String? notes;
  final String? notesAr;

  double? get distance =>
      openingOdometer == null || closingOdometer == null
          ? null
          : closingOdometer! - openingOdometer!;
}

/// Signature/proof block — S20-T26/T33.
class GeniusDeliveryProofSignature {
  const GeniusDeliveryProofSignature({
    required this.signerName,
    required this.signedAt,
    this.signerNameAr,
    this.role,
    this.roleAr,
    this.signatureReference,
    this.metadata,
  });

  final String signerName;
  final String? signerNameAr;
  final String? role;
  final String? roleAr;
  final DateTime signedAt;
  final String? signatureReference;
  final GeniusGeoTimeMetadata? metadata;
}

/// Proof-of-delivery payload.
class GeniusProofOfDeliveryData {
  const GeniusProofOfDeliveryData({
    required this.deliveryNumber,
    required this.shipment,
    required this.deliveredAt,
    required this.recipientName,
    this.recipientNameAr,
    this.signatures = const [],
    this.metadata,
    this.attachments = const [],
    this.condition,
    this.conditionAr,
    this.notes,
    this.notesAr,
  });

  final String deliveryNumber;
  final GeniusShipmentData shipment;
  final DateTime deliveredAt;
  final String recipientName;
  final String? recipientNameAr;
  final List<GeniusDeliveryProofSignature> signatures;
  final GeniusGeoTimeMetadata? metadata;
  final List<GeniusServiceAttachmentReference> attachments;
  final String? condition;
  final String? conditionAr;
  final String? notes;
  final String? notesAr;
}
