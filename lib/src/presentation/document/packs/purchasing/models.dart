
import '../../../../domain/erp/erp.dart';

/// One purchasing ledger/order line used by S13 reports.
class GeniusPurchaseLedgerEntry {
  const GeniusPurchaseLedgerEntry({
    required this.date,
    required this.documentNumber,
    required this.supplierId,
    required this.supplierName,
    required this.itemCode,
    required this.itemName,
    required this.orderedQuantity,
    required this.receivedQuantity,
    required this.netAmount,
    required this.taxAmount,
    this.supplierNameAr,
    this.itemNameAr,
    this.expectedDelivery,
    this.warehouse,
    this.site,
  });

  final DateTime date;
  final String documentNumber;
  final String supplierId;
  final String supplierName;
  final String? supplierNameAr;
  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final double orderedQuantity;
  final double receivedQuantity;
  final ErpMoney netAmount;
  final ErpMoney taxAmount;
  final DateTime? expectedDelivery;
  final String? warehouse;
  final String? site;

  double get outstandingQuantity =>
      orderedQuantity - receivedQuantity;

  bool get isPartiallyReceived =>
      receivedQuantity > 0 && receivedQuantity < orderedQuantity;
}

/// One supplier quotation line for S13 comparison.
class GeniusSupplierQuoteLine {
  const GeniusSupplierQuoteLine({
    required this.supplierId,
    required this.supplierName,
    required this.itemCode,
    required this.itemDescription,
    required this.unitPrice,
    this.supplierNameAr,
    this.itemDescriptionAr,
    this.leadTimeDays,
    this.validUntil,
    this.notes,
  });

  final String supplierId;
  final String supplierName;
  final String? supplierNameAr;
  final String itemCode;
  final String itemDescription;
  final String? itemDescriptionAr;
  final ErpMoney unitPrice;
  final int? leadTimeDays;
  final DateTime? validUntil;
  final String? notes;
}

/// Explicit Purchase Debit/Credit Note mode.
enum GeniusPurchaseAdjustmentKind {
  debit,
  credit,
}
