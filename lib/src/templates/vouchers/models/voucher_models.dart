/// Core data models for voucher templates.
library;

import 'voucher_enums.dart';

/// Core data for all voucher types.
class VoucherData {
  const VoucherData({
    required this.serviceId,
    required this.voucherNumber,
    required this.voucherDate,
    required this.amount,
    this.currency = 'SAR',
    this.currencyAr = 'ريال',
    this.referenceNumber,
    this.fiscalPeriod,
    this.description,
    this.descriptionAr,
    this.party,
    this.paymentDetails,
    this.items = const [],
    this.accountEntries = const [],
    this.notes,
    this.notesAr,
    this.signatories = const [],
    this.customFields = const {},
    this.copyType = VoucherCopyType.original,
  });

  final VoucherServiceId serviceId;
  final String voucherNumber;
  final DateTime voucherDate;
  final double amount;
  final String currency;
  final String currencyAr;
  final String? referenceNumber;
  final String? fiscalPeriod;
  final String? description;
  final String? descriptionAr;
  final VoucherParty? party;
  final VoucherPaymentDetails? paymentDetails;
  final List<VoucherLineItem> items;
  final List<VoucherAccountEntry> accountEntries;
  final String? notes;
  final String? notesAr;
  final List<VoucherSignatory> signatories;
  final Map<String, String> customFields;
  final VoucherCopyType copyType;
}

/// Party information (customer, supplier, beneficiary, etc.).
class VoucherParty {
  const VoucherParty({
    required this.name,
    this.nameAr,
    this.code,
    this.vatNumber,
    this.idNumber,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
    this.bankName,
    this.bankAccount,
    this.iban,
  });

  final String name;
  final String? nameAr;
  final String? code;
  final String? vatNumber;
  final String? idNumber;
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? bankName;
  final String? bankAccount;
  final String? iban;

  /// Display name based on direction.
  String displayName({bool isRTL = true}) =>
      isRTL ? (nameAr ?? name) : name;
}

/// Line item for voucher detail tables.
class VoucherLineItem {
  const VoucherLineItem({
    required this.lineNumber,
    required this.description,
    this.descriptionAr,
    this.itemCode,
    this.quantity = 1,
    this.unit,
    this.unitAr,
    this.unitPrice = 0,
    this.discountPercent,
    this.discountAmount,
    this.taxRate,
    this.taxAmount,
    required this.totalAmount,
  });

  final int lineNumber;
  final String description;
  final String? descriptionAr;
  final String? itemCode;
  final double quantity;
  final String? unit;
  final String? unitAr;
  final double unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double? taxRate;
  final double? taxAmount;
  final double totalAmount;
}

/// Account entry for accounting allocation.
class VoucherAccountEntry {
  const VoucherAccountEntry({
    required this.accountCode,
    required this.accountName,
    this.accountNameAr,
    this.costCenter,
    this.costCenterAr,
    this.debitAmount = 0,
    this.creditAmount = 0,
    this.description,
    this.descriptionAr,
  });

  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final String? costCenter;
  final String? costCenterAr;
  final double debitAmount;
  final double creditAmount;
  final String? description;
  final String? descriptionAr;
}

/// Payment details for receipt/payment vouchers.
class VoucherPaymentDetails {
  const VoucherPaymentDetails({
    required this.method,
    this.bankName,
    this.bankNameAr,
    this.accountNumber,
    this.iban,
    this.transferReference,
    this.transferDate,
    this.checkNumber,
    this.draweeBankName,
    this.draweeBranch,
    this.checkDate,
    this.dueDate,
    this.gatewayName,
    this.transactionId,
    this.cardType,
    this.cardLastFour,
    this.denominations,
  });

  final VoucherPaymentMethod method;

  // Bank transfer
  final String? bankName;
  final String? bankNameAr;
  final String? accountNumber;
  final String? iban;
  final String? transferReference;
  final DateTime? transferDate;

  // Check
  final String? checkNumber;
  final String? draweeBankName;
  final String? draweeBranch;
  final DateTime? checkDate;
  final DateTime? dueDate;

  // Electronic
  final String? gatewayName;
  final String? transactionId;
  final String? cardType;
  final String? cardLastFour;

  // Cash denomination breakdown {denomination: count}
  final Map<double, int>? denominations;
}

/// Signatory block for voucher approvals.
class VoucherSignatory {
  const VoucherSignatory({
    required this.role,
    this.roleAr,
    this.name,
    this.title,
    this.titleAr,
    this.date,
    this.showSignatureLine = true,
  });

  final String role;
  final String? roleAr;
  final String? name;
  final String? title;
  final String? titleAr;
  final DateTime? date;
  final bool showSignatureLine;

  String displayRole({bool isRTL = true}) =>
      isRTL ? (roleAr ?? role) : role;

  // Common signatory factories
  factory VoucherSignatory.preparedBy({String? name}) => VoucherSignatory(
        role: 'Prepared by',
        roleAr: 'أعد بواسطة',
        name: name,
      );

  factory VoucherSignatory.reviewedBy({String? name}) => VoucherSignatory(
        role: 'Reviewed by',
        roleAr: 'راجع بواسطة',
        name: name,
      );

  factory VoucherSignatory.approvedBy({String? name}) => VoucherSignatory(
        role: 'Approved by',
        roleAr: 'اعتمد بواسطة',
        name: name,
      );

  factory VoucherSignatory.receivedBy({String? name}) => VoucherSignatory(
        role: 'Received by',
        roleAr: 'استلم بواسطة',
        name: name,
      );

  factory VoucherSignatory.cashier({String? name}) => VoucherSignatory(
        role: 'Cashier',
        roleAr: 'أمين الصندوق',
        name: name,
      );

  factory VoucherSignatory.accountant({String? name}) => VoucherSignatory(
        role: 'Accountant',
        roleAr: 'المحاسب',
        name: name,
      );

  factory VoucherSignatory.manager({String? name}) => VoucherSignatory(
        role: 'Manager',
        roleAr: 'المدير',
        name: name,
      );
}

/// Tax-specific data for tax vouchers.
class VoucherTaxData {
  const VoucherTaxData({
    required this.taxType,
    this.taxPeriodStart,
    this.taxPeriodEnd,
    this.filingDeadline,
    this.taxAuthorityName,
    this.taxAuthorityNameAr,
    this.taxAuthorityRef,
    this.taxableAmount,
    this.taxRate,
    this.taxAmount,
    this.previousPayments,
    this.balanceDue,
    this.outputVat,
    this.inputVat,
    this.netVat,
    this.adjustments,
    this.penaltyAmount,
    this.interestAmount,
    this.originalAssessment,
    this.revisedAmount,
    this.hsCode,
    this.goodsDescription,
    this.goodsDescriptionAr,
    this.customsValue,
    this.dutyRate,
  });

  final VoucherTaxType taxType;
  final DateTime? taxPeriodStart;
  final DateTime? taxPeriodEnd;
  final DateTime? filingDeadline;
  final String? taxAuthorityName;
  final String? taxAuthorityNameAr;
  final String? taxAuthorityRef;

  // Income tax
  final double? taxableAmount;
  final double? taxRate;
  final double? taxAmount;
  final double? previousPayments;
  final double? balanceDue;

  // VAT
  final double? outputVat;
  final double? inputVat;
  final double? netVat;
  final double? adjustments;

  // Settlement
  final double? penaltyAmount;
  final double? interestAmount;
  final double? originalAssessment;
  final double? revisedAmount;

  // Customs
  final String? hsCode;
  final String? goodsDescription;
  final String? goodsDescriptionAr;
  final double? customsValue;
  final double? dutyRate;
}
