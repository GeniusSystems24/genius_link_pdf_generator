
import '../../domain/erp/erp.dart';
import '../shared/erp_pack_shared.dart';

/// Manufacturing lifecycle state.
enum GeniusManufacturingStatus {
  planned,
  released,
  inProgress,
  onHold,
  completed,
  cancelled,
}

/// Quality/checklist semantic state.
enum GeniusQualityStatus {
  notChecked,
  pass,
  fail,
  warning,
  notApplicable,
}

/// Inspection stage.
enum GeniusQualityInspectionStage {
  general,
  incoming,
  inProcess,
  finalInspection,
}

/// One BOM/material node.
///
/// [level] is presentation hierarchy only; [parentId] preserves actual
/// structure so multi-level BOMs never depend on indentation text.
class GeniusManufacturingMaterialNode {
  const GeniusManufacturingMaterialNode({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.unit,
    this.itemNameAr,
    this.level = 0,
    this.parentId,
    this.scrapPercent = 0,
    this.batch,
    this.serials = const [],
    this.notes,
    this.notesAr,
  })  : assert(level >= 0),
        assert(quantity >= 0),
        assert(scrapPercent >= 0);

  final String id;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final double quantity;
  final ErpUnit unit;
  final int level;
  final String? parentId;
  final double scrapPercent;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final String? notes;
  final String? notesAr;

  double get plannedQuantity =>
      quantity * (1 + scrapPercent / 100);
}

/// Material requirement linked to one operation/order.
class GeniusManufacturingMaterialRequirement {
  const GeniusManufacturingMaterialRequirement({
    required this.material,
    required this.requiredQuantity,
    this.issuedQuantity = 0,
    this.returnedQuantity = 0,
  })  : assert(requiredQuantity >= 0),
        assert(issuedQuantity >= 0),
        assert(returnedQuantity >= 0);

  final GeniusManufacturingMaterialNode material;
  final double requiredQuantity;
  final double issuedQuantity;
  final double returnedQuantity;

  double get consumedQuantity => issuedQuantity - returnedQuantity;

  double get remainingQuantity =>
      requiredQuantity - consumedQuantity;
}

/// One routing/work operation.
class GeniusManufacturingOperation {
  const GeniusManufacturingOperation({
    required this.sequence,
    required this.code,
    required this.name,
    required this.plannedHours,
    this.nameAr,
    this.workCenter,
    this.machine,
    this.actualHours = 0,
    this.laborHours = 0,
    this.status = GeniusManufacturingStatus.planned,
    this.materials = const [],
    this.instructions,
    this.instructionsAr,
  })  : assert(sequence >= 0),
        assert(plannedHours >= 0),
        assert(actualHours >= 0),
        assert(laborHours >= 0);

  final int sequence;
  final String code;
  final String name;
  final String? nameAr;
  final String? workCenter;
  final String? machine;
  final double plannedHours;
  final double actualHours;
  final double laborHours;
  final GeniusManufacturingStatus status;
  final List<GeniusManufacturingMaterialRequirement> materials;
  final String? instructions;
  final String? instructionsAr;

  double get hourVariance => actualHours - plannedHours;
}

/// Production order source.
class GeniusProductionOrderData {
  const GeniusProductionOrderData({
    required this.orderNumber,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.plannedStart,
    required this.plannedEnd,
    this.productNameAr,
    this.status = GeniusManufacturingStatus.planned,
    this.actualQuantity = 0,
    this.operations = const [],
    this.materials = const [],
    this.batch,
    this.serials = const [],
    this.warehouse,
    this.workCenter,
    this.notes,
    this.notesAr,
    this.signOffs = const [],
  })  : assert(quantity >= 0),
        assert(actualQuantity >= 0);

  final String orderNumber;
  final String productCode;
  final String productName;
  final String? productNameAr;
  final double quantity;
  final double actualQuantity;
  final ErpUnit unit;
  final DateTime plannedStart;
  final DateTime plannedEnd;
  final GeniusManufacturingStatus status;
  final List<GeniusManufacturingOperation> operations;
  final List<GeniusManufacturingMaterialRequirement> materials;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final String? warehouse;
  final String? workCenter;
  final String? notes;
  final String? notesAr;
  final List<GeniusQualitySignOff> signOffs;

  double get completionPercent =>
      quantity == 0 ? 0 : actualQuantity / quantity * 100;
}

/// Material movement used by requirement/issue/return/receipt outputs.
class GeniusManufacturingMaterialMovement {
  const GeniusManufacturingMaterialMovement({
    required this.documentNumber,
    required this.date,
    required this.orderNumber,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.unit,
    this.itemNameAr,
    this.warehouse,
    this.location,
    this.batch,
    this.serials = const [],
    this.notes,
    this.notesAr,
  }) : assert(quantity >= 0);

  final String documentNumber;
  final DateTime date;
  final String orderNumber;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final double quantity;
  final ErpUnit unit;
  final String? warehouse;
  final String? location;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final String? notes;
  final String? notesAr;
}

/// Machine operation actual.
class GeniusManufacturingMachineEntry {
  const GeniusManufacturingMachineEntry({
    required this.date,
    required this.orderNumber,
    required this.operationCode,
    required this.machineCode,
    required this.runHours,
    this.setupHours = 0,
    this.downtimeHours = 0,
    this.reason,
    this.reasonAr,
  })  : assert(runHours >= 0),
        assert(setupHours >= 0),
        assert(downtimeHours >= 0);

  final DateTime date;
  final String orderNumber;
  final String operationCode;
  final String machineCode;
  final double runHours;
  final double setupHours;
  final double downtimeHours;
  final String? reason;
  final String? reasonAr;
}

/// Labor actual.
class GeniusManufacturingLaborEntry {
  const GeniusManufacturingLaborEntry({
    required this.date,
    required this.orderNumber,
    required this.operationCode,
    required this.employeeId,
    required this.employeeName,
    required this.hours,
    this.employeeNameAr,
    this.notes,
    this.notesAr,
  }) : assert(hours >= 0);

  final DateTime date;
  final String orderNumber;
  final String operationCode;
  final String employeeId;
  final String employeeName;
  final String? employeeNameAr;
  final double hours;
  final String? notes;
  final String? notesAr;
}

/// Scrap/reject actual.
class GeniusManufacturingScrapEntry {
  const GeniusManufacturingScrapEntry({
    required this.date,
    required this.orderNumber,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.reason,
    this.itemNameAr,
    this.reasonAr,
    this.batch,
  }) : assert(quantity >= 0);

  final DateTime date;
  final String orderNumber;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final double quantity;
  final ErpUnit unit;
  final String reason;
  final String? reasonAr;
  final ErpBatchInfo? batch;
}

/// WIP snapshot.
class GeniusManufacturingWipEntry {
  const GeniusManufacturingWipEntry({
    required this.orderNumber,
    required this.productCode,
    required this.productName,
    required this.plannedQuantity,
    required this.completedQuantity,
    required this.currentOperation,
    this.productNameAr,
    this.currentOperationAr,
  })  : assert(plannedQuantity >= 0),
        assert(completedQuantity >= 0);

  final String orderNumber;
  final String productCode;
  final String productName;
  final String? productNameAr;
  final double plannedQuantity;
  final double completedQuantity;
  final String currentOperation;
  final String? currentOperationAr;

  double get remainingQuantity =>
      plannedQuantity - completedQuantity;

  double get completionPercent =>
      plannedQuantity == 0
          ? 0
          : completedQuantity / plannedQuantity * 100;
}

/// Production variance row.
class GeniusManufacturingVariance {
  const GeniusManufacturingVariance({
    required this.orderNumber,
    required this.metric,
    required this.planned,
    required this.actual,
    this.metricAr,
    this.unit,
  });

  final String orderNumber;
  final String metric;
  final String? metricAr;
  final double planned;
  final double actual;
  final String? unit;

  double get variance => actual - planned;

  double get variancePercent =>
      planned == 0 ? 0 : variance / planned * 100;
}

/// Shared quality checklist primitive — S18-T26/T27.
class GeniusQualityChecklistItem {
  const GeniusQualityChecklistItem({
    required this.code,
    required this.label,
    this.labelAr,
    this.status = GeniusQualityStatus.notChecked,
    this.comment,
    this.commentAr,
    this.required = true,
  });

  final String code;
  final String label;
  final String? labelAr;
  final GeniusQualityStatus status;
  final String? comment;
  final String? commentAr;
  final bool required;
}

/// Measurement/specification/value/tolerance row — S18-T28.
class GeniusQualityMeasurement {
  const GeniusQualityMeasurement({
    required this.code,
    required this.name,
    required this.value,
    this.nameAr,
    this.specification,
    this.specificationAr,
    this.minimum,
    this.maximum,
    this.unit,
    this.overrideStatus,
  });

  final String code;
  final String name;
  final String? nameAr;
  final double value;
  final String? specification;
  final String? specificationAr;
  final double? minimum;
  final double? maximum;
  final String? unit;
  final GeniusQualityStatus? overrideStatus;

  GeniusQualityStatus get status {
    if (overrideStatus != null) return overrideStatus!;
    if (minimum != null && value < minimum!) {
      return GeniusQualityStatus.fail;
    }
    if (maximum != null && value > maximum!) {
      return GeniusQualityStatus.fail;
    }
    return GeniusQualityStatus.pass;
  }

  String get toleranceText {
    if (minimum != null && maximum != null) {
      return '${minimum!.toStringAsFixed(3)} .. '
          '${maximum!.toStringAsFixed(3)}';
    }
    if (minimum != null) return '>= ${minimum!.toStringAsFixed(3)}';
    if (maximum != null) return '<= ${maximum!.toStringAsFixed(3)}';
    return '';
  }
}

/// Approval/sign-off primitive — S18-T30.
class GeniusQualitySignOff {
  const GeniusQualitySignOff({
    required this.role,
    required this.name,
    required this.signedAt,
    this.roleAr,
    this.nameAr,
    this.status = GeniusQualityStatus.pass,
    this.comment,
    this.commentAr,
  });

  final String role;
  final String? roleAr;
  final String name;
  final String? nameAr;
  final DateTime signedAt;
  final GeniusQualityStatus status;
  final String? comment;
  final String? commentAr;
}

/// Generic quality inspection.
class GeniusQualityInspection {
  const GeniusQualityInspection({
    required this.inspectionNumber,
    required this.date,
    required this.subjectCode,
    required this.subjectName,
    required this.stage,
    this.subjectNameAr,
    this.orderNumber,
    this.supplier,
    this.supplierAr,
    this.batch,
    this.serials = const [],
    this.checklist = const [],
    this.measurements = const [],
    this.signOffs = const [],
    this.notes,
    this.notesAr,
  });

  final String inspectionNumber;
  final DateTime date;
  final String subjectCode;
  final String subjectName;
  final String? subjectNameAr;
  final GeniusQualityInspectionStage stage;
  final String? orderNumber;
  final String? supplier;
  final String? supplierAr;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final List<GeniusQualityChecklistItem> checklist;
  final List<GeniusQualityMeasurement> measurements;
  final List<GeniusQualitySignOff> signOffs;
  final String? notes;
  final String? notesAr;

  GeniusQualityStatus get overallStatus {
    if (checklist.any(
          (item) =>
              item.required &&
              item.status == GeniusQualityStatus.fail,
        ) ||
        measurements.any(
          (measurement) =>
              measurement.status == GeniusQualityStatus.fail,
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

/// Non-conformance report.
class GeniusQualityNcr {
  const GeniusQualityNcr({
    required this.ncrNumber,
    required this.date,
    required this.subject,
    required this.description,
    this.subjectAr,
    this.descriptionAr,
    this.orderNumber,
    this.batch,
    this.disposition,
    this.dispositionAr,
    this.owner,
    this.dueDate,
    this.status = GeniusQualityStatus.fail,
  });

  final String ncrNumber;
  final DateTime date;
  final String subject;
  final String? subjectAr;
  final String description;
  final String? descriptionAr;
  final String? orderNumber;
  final ErpBatchInfo? batch;
  final String? disposition;
  final String? dispositionAr;
  final String? owner;
  final DateTime? dueDate;
  final GeniusQualityStatus status;
}

/// CAPA action.
class GeniusQualityCapa {
  const GeniusQualityCapa({
    required this.capaNumber,
    required this.date,
    required this.problem,
    required this.rootCause,
    required this.correctiveAction,
    required this.preventiveAction,
    this.problemAr,
    this.rootCauseAr,
    this.correctiveActionAr,
    this.preventiveActionAr,
    this.owner,
    this.dueDate,
    this.signOffs = const [],
  });

  final String capaNumber;
  final DateTime date;
  final String problem;
  final String? problemAr;
  final String rootCause;
  final String? rootCauseAr;
  final String correctiveAction;
  final String? correctiveActionAr;
  final String preventiveAction;
  final String? preventiveActionAr;
  final String? owner;
  final DateTime? dueDate;
  final List<GeniusQualitySignOff> signOffs;
}

/// COA test/result.
class GeniusQualityCoaResult {
  const GeniusQualityCoaResult({
    required this.testCode,
    required this.testName,
    required this.specification,
    required this.result,
    required this.status,
    this.testNameAr,
    this.specificationAr,
    this.resultAr,
  });

  final String testCode;
  final String testName;
  final String? testNameAr;
  final String specification;
  final String? specificationAr;
  final String result;
  final String? resultAr;
  final GeniusQualityStatus status;
}

/// Certificate of Analysis payload.
class GeniusQualityCoaData {
  const GeniusQualityCoaData({
    required this.certificateNumber,
    required this.date,
    required this.itemCode,
    required this.itemName,
    required this.results,
    this.itemNameAr,
    this.batch,
    this.expiryDate,
    this.manufacturingDate,
    this.signOffs = const [],
  });

  final String certificateNumber;
  final DateTime date;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final List<GeniusQualityCoaResult> results;
  final ErpBatchInfo? batch;
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;
  final List<GeniusQualitySignOff> signOffs;
}

/// Audit form.
class GeniusQualityAuditData {
  const GeniusQualityAuditData({
    required this.auditNumber,
    required this.date,
    required this.area,
    required this.checklist,
    this.areaAr,
    this.auditor,
    this.auditorAr,
    this.notes,
    this.notesAr,
  });

  final String auditNumber;
  final DateTime date;
  final String area;
  final String? areaAr;
  final String? auditor;
  final String? auditorAr;
  final List<GeniusQualityChecklistItem> checklist;
  final String? notes;
  final String? notesAr;
}

/// Calibration record.
class GeniusQualityCalibrationRecord {
  const GeniusQualityCalibrationRecord({
    required this.recordNumber,
    required this.date,
    required this.instrumentCode,
    required this.instrumentName,
    required this.result,
    this.instrumentNameAr,
    this.standardReference,
    this.nextDueDate,
    this.measurements = const [],
    this.signOffs = const [],
  });

  final String recordNumber;
  final DateTime date;
  final String instrumentCode;
  final String instrumentName;
  final String? instrumentNameAr;
  final GeniusQualityStatus result;
  final String? standardReference;
  final DateTime? nextDueDate;
  final List<GeniusQualityMeasurement> measurements;
  final List<GeniusQualitySignOff> signOffs;
}

/// One section for S18 nested operation/material tables.
class GeniusManufacturingNestedTableSection {
  const GeniusManufacturingNestedTableSection({
    required this.title,
    required this.rows,
    this.titleAr,
    this.level = 0,
  }) : assert(level >= 0);

  final String title;
  final String? titleAr;
  final int level;
  final List<Map<String, Object?>> rows;
}

/// Public nested-table payload.
class GeniusManufacturingNestedTableData {
  const GeniusManufacturingNestedTableData({
    required this.title,
    required this.columns,
    required this.sections,
    this.titleAr,
  });

  final String title;
  final String? titleAr;
  final List<GeniusErpPackReportColumn> columns;
  final List<GeniusManufacturingNestedTableSection> sections;
}
