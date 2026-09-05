
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';

abstract class _InventoryOperationalDocument
    extends GeniusErpOperationalForm {
  _InventoryOperationalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _InventoryRegisterDocument
    extends GeniusErpRegisterDocument {
  _InventoryRegisterDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _InventoryAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _InventoryAnalyticalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S15-T01.
class GeniusStockReceiptDocument
    extends _InventoryOperationalDocument {
  GeniusStockReceiptDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T02.
class GeniusStockIssueDocument
    extends _InventoryOperationalDocument {
  GeniusStockIssueDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T03.
class GeniusStockTransferDocument
    extends _InventoryOperationalDocument {
  GeniusStockTransferDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T04.
class GeniusWarehouseTransferDocument
    extends _InventoryOperationalDocument {
  GeniusWarehouseTransferDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T05.
class GeniusStockAdjustmentDocument
    extends _InventoryOperationalDocument {
  GeniusStockAdjustmentDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T06.
class GeniusStockCountDocument
    extends _InventoryOperationalDocument {
  GeniusStockCountDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T07.
class GeniusCycleCountDocument
    extends _InventoryOperationalDocument {
  GeniusCycleCountDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T08.
class GeniusCountReconciliationDocument
    extends _InventoryAnalyticalDocument {
  GeniusCountReconciliationDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T09.
class GeniusItemCardDocument extends _InventoryRegisterDocument {
  GeniusItemCardDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T10.
class GeniusStockLedgerDocument
    extends _InventoryRegisterDocument {
  GeniusStockLedgerDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T11.
class GeniusStockValuationDocument
    extends _InventoryAnalyticalDocument {
  GeniusStockValuationDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T12.
class GeniusStockAvailabilityDocument
    extends _InventoryRegisterDocument {
  GeniusStockAvailabilityDocument(
    super.config, {
    required super.report,
  });
}

/// S15-T13.
class GeniusReorderReport extends _InventoryAnalyticalDocument {
  GeniusReorderReport(
    super.config, {
    required super.report,
  });
}

/// S15-T14.
class GeniusInventoryMinMaxReport
    extends _InventoryAnalyticalDocument {
  GeniusInventoryMinMaxReport(
    super.config, {
    required super.report,
  });
}

/// S15-T15.
class GeniusSlowDeadStockReport
    extends _InventoryAnalyticalDocument {
  GeniusSlowDeadStockReport(
    super.config, {
    required super.report,
  });
}

/// S15-T16.
class GeniusBatchReport extends _InventoryRegisterDocument {
  GeniusBatchReport(
    super.config, {
    required super.report,
  });
}

/// S15-T17.
class GeniusSerialReport extends _InventoryRegisterDocument {
  GeniusSerialReport(
    super.config, {
    required super.report,
  });
}

/// S15-T18.
class GeniusExpiryReport extends _InventoryRegisterDocument {
  GeniusExpiryReport(
    super.config, {
    required super.report,
  });
}
