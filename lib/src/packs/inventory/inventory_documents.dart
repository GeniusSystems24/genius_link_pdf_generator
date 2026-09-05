
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';

abstract class _InventoryOperationalDocument
    extends GeniusErpOperationalForm {
  _InventoryOperationalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _InventoryRegisterDocument
    extends GeniusErpRegisterDocument {
  _InventoryRegisterDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _InventoryAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _InventoryAnalyticalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S15-T01.
class GeniusStockReceiptDocument
    extends _InventoryOperationalDocument {
  GeniusStockReceiptDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T02.
class GeniusStockIssueDocument
    extends _InventoryOperationalDocument {
  GeniusStockIssueDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T03.
class GeniusStockTransferDocument
    extends _InventoryOperationalDocument {
  GeniusStockTransferDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T04.
class GeniusWarehouseTransferDocument
    extends _InventoryOperationalDocument {
  GeniusWarehouseTransferDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T05.
class GeniusStockAdjustmentDocument
    extends _InventoryOperationalDocument {
  GeniusStockAdjustmentDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T06.
class GeniusStockCountDocument
    extends _InventoryOperationalDocument {
  GeniusStockCountDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T07.
class GeniusCycleCountDocument
    extends _InventoryOperationalDocument {
  GeniusCycleCountDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T08.
class GeniusCountReconciliationDocument
    extends _InventoryAnalyticalDocument {
  GeniusCountReconciliationDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T09.
class GeniusItemCardDocument extends _InventoryRegisterDocument {
  GeniusItemCardDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T10.
class GeniusStockLedgerDocument
    extends _InventoryRegisterDocument {
  GeniusStockLedgerDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T11.
class GeniusStockValuationDocument
    extends _InventoryAnalyticalDocument {
  GeniusStockValuationDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T12.
class GeniusStockAvailabilityDocument
    extends _InventoryRegisterDocument {
  GeniusStockAvailabilityDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T13.
class GeniusReorderReport extends _InventoryAnalyticalDocument {
  GeniusReorderReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T14.
class GeniusInventoryMinMaxReport
    extends _InventoryAnalyticalDocument {
  GeniusInventoryMinMaxReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T15.
class GeniusSlowDeadStockReport
    extends _InventoryAnalyticalDocument {
  GeniusSlowDeadStockReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T16.
class GeniusBatchReport extends _InventoryRegisterDocument {
  GeniusBatchReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T17.
class GeniusSerialReport extends _InventoryRegisterDocument {
  GeniusSerialReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S15-T18.
class GeniusExpiryReport extends _InventoryRegisterDocument {
  GeniusExpiryReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}
