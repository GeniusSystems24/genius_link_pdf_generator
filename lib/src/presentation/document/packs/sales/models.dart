
import '../../../../domain/erp/erp.dart';

/// One posted/issued sales line used by S12 analytical reports.
class GeniusSalesLedgerEntry {
  const GeniusSalesLedgerEntry({
    required this.date,
    required this.documentNumber,
    required this.customerId,
    required this.customerName,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.netAmount,
    required this.taxAmount,
    this.customerNameAr,
    this.itemNameAr,
    this.salespersonId,
    this.salespersonName,
    this.salespersonNameAr,
    this.costAmount,
    this.commissionRatePercent = 0,
  });

  final DateTime date;
  final String documentNumber;
  final String customerId;
  final String customerName;
  final String? customerNameAr;
  final String itemId;
  final String itemName;
  final String? itemNameAr;
  final double quantity;
  final ErpMoney netAmount;
  final ErpMoney taxAmount;
  final ErpMoney? costAmount;
  final String? salespersonId;
  final String? salespersonName;
  final String? salespersonNameAr;
  final double commissionRatePercent;
}

/// Fulfillment/backorder line for S12.
class GeniusSalesBackorderLine {
  const GeniusSalesBackorderLine({
    required this.orderNumber,
    required this.customerName,
    required this.itemCode,
    required this.description,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    this.customerNameAr,
    this.descriptionAr,
    this.expectedDelivery,
    this.batch,
    this.serials = const [],
  });

  final String orderNumber;
  final String customerName;
  final String? customerNameAr;
  final String itemCode;
  final String description;
  final String? descriptionAr;
  final double orderedQuantity;
  final double fulfilledQuantity;
  final DateTime? expectedDelivery;
  final String? batch;
  final List<String> serials;

  double get outstandingQuantity =>
      orderedQuantity - fulfilledQuantity;
}

/// One price-list row.
class GeniusSalesPriceEntry {
  const GeniusSalesPriceEntry({
    required this.itemCode,
    required this.description,
    required this.price,
    this.descriptionAr,
    this.unit = 'EA',
    this.validFrom,
    this.validTo,
  });

  final String itemCode;
  final String description;
  final String? descriptionAr;
  final ErpMoney price;
  final String unit;
  final DateTime? validFrom;
  final DateTime? validTo;
}
