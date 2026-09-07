
import '../../../../domain/erp/erp.dart';

/// S16 receipt semantics.
enum GeniusPosReceiptKind {
  sale,
  refund,
  exchange,
  gift,
}

/// POS payment method.
enum GeniusPosPaymentMethod {
  cash,
  card,
  bank,
  wallet,
  voucher,
  other,
}

/// One POS receipt item.
class GeniusPosReceiptLine {
  const GeniusPosReceiptLine({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.sku,
    this.discount = 0,
    this.tax = 0,
    this.promotion,
    this.promotionAr,
    this.note,
    this.noteAr,
  });

  final String description;
  final String? descriptionAr;
  final String? sku;
  final double quantity;
  final double unitPrice;
  final double discount;
  final double tax;
  final String? promotion;
  final String? promotionAr;
  final String? note;
  final String? noteAr;

  double get lineSubtotal => quantity * unitPrice;
  double get lineTotal => lineSubtotal - discount + tax;
}

/// One tender/payment line.
class GeniusPosPayment {
  const GeniusPosPayment({
    required this.method,
    required this.amount,
    this.label,
    this.labelAr,
    this.reference,
  });

  final GeniusPosPaymentMethod method;
  final double amount;
  final String? label;
  final String? labelAr;
  final String? reference;
}

/// Tax bucket shown in POS tax summary.
class GeniusPosTaxSummaryLine {
  const GeniusPosTaxSummaryLine({
    required this.code,
    required this.ratePercent,
    required this.taxableAmount,
    required this.taxAmount,
  });

  final String code;
  final double ratePercent;
  final double taxableAmount;
  final double taxAmount;
}

/// Complete POS receipt input.
class GeniusPosReceiptRequest {
  const GeniusPosReceiptRequest({
    required this.merchantName,
    required this.receiptNumber,
    required this.date,
    required this.lines,
    this.merchantNameAr,
    this.title,
    this.titleAr,
    this.kind = GeniusPosReceiptKind.sale,
    this.currency = 'SAR',
    this.documentDiscount = 0,
    this.payments = const [],
    this.taxSummary = const [],
    this.cashReceived,
    this.change,
    this.qrData,
    this.barcodeData,
    this.copyLabel,
    this.copyLabelAr,
    this.reprint = false,
    this.footer,
    this.footerAr,
  });

  final String merchantName;
  final String? merchantNameAr;
  final String? title;
  final String? titleAr;
  final String receiptNumber;
  final DateTime date;
  final GeniusPosReceiptKind kind;
  final List<GeniusPosReceiptLine> lines;
  final String currency;
  final double documentDiscount;
  final List<GeniusPosPayment> payments;
  final List<GeniusPosTaxSummaryLine> taxSummary;
  final double? cashReceived;
  final double? change;
  final String? qrData;
  final String? barcodeData;
  final String? copyLabel;
  final String? copyLabelAr;
  final bool reprint;
  final String? footer;
  final String? footerAr;

  double get subtotal =>
      lines.fold<double>(0, (sum, line) => sum + line.lineSubtotal);

  double get lineDiscount =>
      lines.fold<double>(0, (sum, line) => sum + line.discount);

  double get taxTotal =>
      lines.fold<double>(0, (sum, line) => sum + line.tax);

  double get total =>
      subtotal - lineDiscount - documentDiscount + taxTotal;
}

/// POS shift summary used by Shift Open/Close and X/Z reports.
class GeniusPosShiftSummary {
  const GeniusPosShiftSummary({
    required this.shiftId,
    required this.openedAt,
    required this.openingCash,
    required this.sales,
    required this.refunds,
    required this.discounts,
    required this.tax,
    required this.expectedCash,
    required this.actualCash,
    required this.payments,
    this.closedAt,
    this.cashier,
    this.terminal,
  });

  final String shiftId;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? cashier;
  final String? terminal;
  final ErpMoney openingCash;
  final ErpMoney sales;
  final ErpMoney refunds;
  final ErpMoney discounts;
  final ErpMoney tax;
  final ErpMoney expectedCash;
  final ErpMoney actualCash;
  final List<GeniusPosPaymentSummary> payments;

  ErpMoney get cashVariance => actualCash - expectedCash;
}

/// Aggregated payment method result.
class GeniusPosPaymentSummary {
  const GeniusPosPaymentSummary({
    required this.method,
    required this.amount,
    required this.transactionCount,
  });

  final GeniusPosPaymentMethod method;
  final ErpMoney amount;
  final int transactionCount;
}

/// Retail label payload.
class GeniusPosRetailLabel {
  const GeniusPosRetailLabel({
    required this.itemCode,
    required this.itemName,
    required this.price,
    this.itemNameAr,
    this.oldPrice,
    this.promotion,
    this.promotionAr,
    this.qrData,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final ErpMoney price;
  final ErpMoney? oldPrice;
  final String? promotion;
  final String? promotionAr;
  final String? qrData;
}
