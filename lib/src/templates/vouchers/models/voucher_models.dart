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
  String displayName({bool isRTL = true}) => isRTL ? (nameAr ?? name) : name;
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
    this.sourceCurrency,
    this.targetCurrency,
    this.exchangeRate,
    this.sourceAmount,
    this.targetAmount,
    this.exchangeFee,
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

  // Currency exchange
  final String? sourceCurrency;
  final String? targetCurrency;
  final double? exchangeRate;
  final double? sourceAmount;
  final double? targetAmount;
  final double? exchangeFee;
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

  String displayRole({bool isRTL = true}) => isRTL ? (roleAr ?? role) : role;

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

/// Bank account information used by banking vouchers.
class VoucherBankInfo {
  const VoucherBankInfo({
    required this.bankName,
    this.bankNameAr,
    this.branchName,
    this.branchNameAr,
    this.accountNumber,
    this.iban,
    this.swiftCode,
    this.currency = 'SAR',
    this.balanceBefore,
  });

  final String bankName;
  final String? bankNameAr;
  final String? branchName;
  final String? branchNameAr;
  final String? accountNumber;
  final String? iban;
  final String? swiftCode;
  final String currency;
  final double? balanceBefore;

  String displayBankName({bool isRTL = true}) =>
      isRTL ? (bankNameAr ?? bankName) : bankName;
}

/// Transfer-specific data for transfer vouchers.
class VoucherTransferData {
  const VoucherTransferData({
    required this.sourceAccount,
    required this.destinationAccount,
    this.beneficiaryName,
    this.beneficiaryNameAr,
    this.transferFee,
    this.commission,
    this.netAmount,
    this.processingTime,
    this.platform,
  });

  final VoucherBankInfo sourceAccount;
  final VoucherBankInfo destinationAccount;
  final String? beneficiaryName;
  final String? beneficiaryNameAr;
  final double? transferFee;
  final double? commission;
  final double? netAmount;
  final String? processingTime;
  final String? platform;
}

/// Bill payment details for bill payment vouchers.
class VoucherBillData {
  const VoucherBillData({
    required this.providerName,
    this.providerNameAr,
    this.subscriberNumber,
    this.billNumber,
    this.billingPeriod,
    this.billingPeriodAr,
    this.dueDate,
    this.serviceType,
    this.serviceTypeAr,
    this.meterNumber,
    this.consumption,
    this.consumptionUnit,
    this.rate,
    this.planName,
    this.planNameAr,
    this.mobileNumber,
    this.validity,
    this.validityAr,
    this.confirmationNumber,
  });

  final String providerName;
  final String? providerNameAr;
  final String? subscriberNumber;
  final String? billNumber;
  final String? billingPeriod;
  final String? billingPeriodAr;
  final DateTime? dueDate;
  final String? serviceType;
  final String? serviceTypeAr;
  final String? meterNumber;
  final double? consumption;
  final String? consumptionUnit;
  final double? rate;
  final String? planName;
  final String? planNameAr;
  final String? mobileNumber;
  final String? validity;
  final String? validityAr;
  final String? confirmationNumber;

  String displayProvider({bool isRTL = true}) =>
      isRTL ? (providerNameAr ?? providerName) : providerName;
}

/// Signatory factory for banking-specific roles.
extension BankingSignatories on VoucherSignatory {
  static VoucherSignatory depositor({String? name}) => VoucherSignatory(
        role: 'Depositor',
        roleAr: 'المودع',
        name: name,
      );

  static VoucherSignatory bankTeller({String? name}) => VoucherSignatory(
        role: 'Bank Teller',
        roleAr: 'موظف البنك',
        name: name,
      );

  static VoucherSignatory requester({String? name}) => VoucherSignatory(
        role: 'Requester',
        roleAr: 'مقدم الطلب',
        name: name,
      );

  static VoucherSignatory treasury({String? name}) => VoucherSignatory(
        role: 'Treasury',
        roleAr: 'الخزينة',
        name: name,
      );

  static VoucherSignatory authorizedSignatory({String? name}) =>
      VoucherSignatory(
        role: 'Authorized Signatory',
        roleAr: 'المفوض بالتوقيع',
        name: name,
      );

  static VoucherSignatory operator({String? name}) => VoucherSignatory(
        role: 'Operator',
        roleAr: 'المشغّل',
        name: name,
      );
}

/// Remittance-specific data for outgoing/incoming remittance vouchers.
class VoucherRemittanceData {
  const VoucherRemittanceData({
    required this.senderName,
    this.senderNameAr,
    this.senderIdNumber,
    this.senderIdType,
    this.senderIdTypeAr,
    this.senderPhone,
    this.senderAddress,
    this.senderAddressAr,
    this.senderCountry,
    this.senderCountryAr,
    required this.beneficiaryName,
    this.beneficiaryNameAr,
    this.beneficiaryIdNumber,
    this.beneficiaryIdType,
    this.beneficiaryIdTypeAr,
    this.beneficiaryPhone,
    this.beneficiaryAddress,
    this.beneficiaryAddressAr,
    this.beneficiaryCountry,
    this.beneficiaryCountryAr,
    this.beneficiaryBankName,
    this.beneficiaryBankNameAr,
    this.beneficiaryAccountNumber,
    this.beneficiaryIban,
    this.beneficiarySwiftCode,
    this.correspondentBank,
    this.correspondentBankAr,
    this.sourceCurrency,
    this.targetCurrency,
    this.exchangeRate,
    this.sourceAmount,
    this.targetAmount,
    this.transferFee,
    this.exchangeMargin,
    this.totalCost,
    this.purposeCode,
    this.purposeDescription,
    this.purposeDescriptionAr,
    this.amlReference,
    this.trackingNumber,
    this.expectedDeliveryDate,
    this.disbursementMethod,
    this.disbursementMethodAr,
  });

  // Sender
  final String senderName;
  final String? senderNameAr;
  final String? senderIdNumber;
  final String? senderIdType;
  final String? senderIdTypeAr;
  final String? senderPhone;
  final String? senderAddress;
  final String? senderAddressAr;
  final String? senderCountry;
  final String? senderCountryAr;

  // Beneficiary
  final String beneficiaryName;
  final String? beneficiaryNameAr;
  final String? beneficiaryIdNumber;
  final String? beneficiaryIdType;
  final String? beneficiaryIdTypeAr;
  final String? beneficiaryPhone;
  final String? beneficiaryAddress;
  final String? beneficiaryAddressAr;
  final String? beneficiaryCountry;
  final String? beneficiaryCountryAr;
  final String? beneficiaryBankName;
  final String? beneficiaryBankNameAr;
  final String? beneficiaryAccountNumber;
  final String? beneficiaryIban;
  final String? beneficiarySwiftCode;
  final String? correspondentBank;
  final String? correspondentBankAr;

  // Currency & exchange (for international)
  final String? sourceCurrency;
  final String? targetCurrency;
  final double? exchangeRate;
  final double? sourceAmount;
  final double? targetAmount;

  // Fees
  final double? transferFee;
  final double? exchangeMargin;
  final double? totalCost;

  // Compliance
  final String? purposeCode;
  final String? purposeDescription;
  final String? purposeDescriptionAr;
  final String? amlReference;

  // Tracking
  final String? trackingNumber;
  final DateTime? expectedDeliveryDate;

  // Disbursement (for incoming)
  final String? disbursementMethod;
  final String? disbursementMethodAr;

  /// Whether this is an international remittance (based on service IDs 10500/10501/10550/10551).
  bool isInternational(VoucherServiceId serviceId) {
    return serviceId == VoucherServiceId.internationalPersonalOutgoing ||
        serviceId == VoucherServiceId.internationalCommercialOutgoing ||
        serviceId == VoucherServiceId.internationalPersonalIncoming ||
        serviceId == VoucherServiceId.internationalCommercialIncoming;
  }

  /// Whether this is a commercial remittance.
  bool isCommercial(VoucherServiceId serviceId) {
    return serviceId == VoucherServiceId.domesticCommercialOutgoing ||
        serviceId == VoucherServiceId.internationalCommercialOutgoing ||
        serviceId == VoucherServiceId.domesticCommercialIncoming ||
        serviceId == VoucherServiceId.internationalCommercialIncoming;
  }
}

/// Trade-specific data for purchase, sales, and return vouchers.
class VoucherTradeData {
  const VoucherTradeData({
    this.orderNumber,
    this.orderDate,
    this.salesperson,
    this.salespersonAr,
    this.subtotal,
    this.totalDiscount,
    this.taxableAmount,
    this.vatRate = 15.0,
    this.vatAmount,
    this.grandTotal,
    this.dueDate,
    this.creditPeriodDays,
    this.advanceAmount,
    this.remainingBalance,
    this.deliveryDate,
    this.numberOfInstallments,
    this.installmentAmount,
    this.warehouseName,
    this.warehouseNameAr,
    this.receivedBy,
    this.receivedByAr,
    this.dispatchedBy,
    this.dispatchedByAr,
    this.shippingAddress,
    this.shippingAddressAr,
    this.deliveryMethod,
    this.deliveryMethodAr,
    this.originalVoucherNumber,
    this.originalVoucherDate,
    this.returnReason,
    this.returnReasonDescription,
    this.returnReasonDescriptionAr,
    this.refundMethod,
    this.refundMethodAr,
    this.refundAmount,
    this.inspectedBy,
    this.inspectedByAr,
  });

  // Order reference
  final String? orderNumber;
  final DateTime? orderDate;
  final String? salesperson;
  final String? salespersonAr;

  // Summary calculations
  final double? subtotal;
  final double? totalDiscount;
  final double? taxableAmount;
  final double vatRate;
  final double? vatAmount;
  final double? grandTotal;

  // Payment terms
  final DateTime? dueDate;
  final int? creditPeriodDays;
  final double? advanceAmount;
  final double? remainingBalance;
  final DateTime? deliveryDate;
  final int? numberOfInstallments;
  final double? installmentAmount;

  // Warehouse
  final String? warehouseName;
  final String? warehouseNameAr;
  final String? receivedBy;
  final String? receivedByAr;
  final String? dispatchedBy;
  final String? dispatchedByAr;

  // Delivery (sales)
  final String? shippingAddress;
  final String? shippingAddressAr;
  final String? deliveryMethod;
  final String? deliveryMethodAr;

  // Return-specific
  final String? originalVoucherNumber;
  final DateTime? originalVoucherDate;
  final VoucherReturnReason? returnReason;
  final String? returnReasonDescription;
  final String? returnReasonDescriptionAr;
  final String? refundMethod;
  final String? refundMethodAr;
  final double? refundAmount;
  final String? inspectedBy;
  final String? inspectedByAr;

  /// Whether this is a credit/deferred payment type.
  bool isCredit(VoucherServiceId serviceId) {
    return serviceId == VoucherServiceId.creditPurchase ||
        serviceId == VoucherServiceId.creditSale ||
        serviceId == VoucherServiceId.creditPurchaseReturn ||
        serviceId == VoucherServiceId.creditSalesReturn;
  }

  /// Whether this is an advance payment type.
  bool isAdvance(VoucherServiceId serviceId) {
    return serviceId == VoucherServiceId.advancePurchase ||
        serviceId == VoucherServiceId.advanceSale ||
        serviceId == VoucherServiceId.advancePurchaseReturn ||
        serviceId == VoucherServiceId.advanceSalesReturn;
  }

  /// Whether this is an installment type.
  bool isInstallment(VoucherServiceId serviceId) {
    return serviceId == VoucherServiceId.installmentPurchase ||
        serviceId == VoucherServiceId.installmentSale ||
        serviceId == VoucherServiceId.installmentPurchaseReturn ||
        serviceId == VoucherServiceId.installmentSalesReturn;
  }
}

/// Signatory factory for trade-specific roles.
extension TradeSignatories on VoucherSignatory {
  static VoucherSignatory purchasing({String? name}) => VoucherSignatory(
        role: 'Purchasing Dept',
        roleAr: 'قسم المشتريات',
        name: name,
      );

  static VoucherSignatory salesDept({String? name}) => VoucherSignatory(
        role: 'Sales Dept',
        roleAr: 'قسم المبيعات',
        name: name,
      );

  static VoucherSignatory warehouseKeeper({String? name}) => VoucherSignatory(
        role: 'Warehouse Keeper',
        roleAr: 'أمين المستودع',
        name: name,
      );

  static VoucherSignatory qualityInspector({String? name}) => VoucherSignatory(
        role: 'Quality Inspector',
        roleAr: 'مفتش الجودة',
        name: name,
      );

  static VoucherSignatory customer({String? name}) => VoucherSignatory(
        role: 'Customer',
        roleAr: 'العميل',
        name: name,
      );

  static VoucherSignatory supplier({String? name}) => VoucherSignatory(
        role: 'Supplier',
        roleAr: 'المورد',
        name: name,
      );
}

/// Signatory factory for remittance-specific roles.
extension RemittanceSignatories on VoucherSignatory {
  static VoucherSignatory sender({String? name}) => VoucherSignatory(
        role: 'Sender',
        roleAr: 'المرسل',
        name: name,
      );

  static VoucherSignatory beneficiary({String? name}) => VoucherSignatory(
        role: 'Beneficiary',
        roleAr: 'المستفيد',
        name: name,
      );

  static VoucherSignatory complianceOfficer({String? name}) => VoucherSignatory(
        role: 'Compliance Officer',
        roleAr: 'مسؤول الامتثال',
        name: name,
      );
}

/// Gift/Grant voucher-specific data.
class VoucherGiftData {
  const VoucherGiftData({
    required this.direction,
    this.occasion,
    this.occasionAr,
    this.donorName,
    this.donorNameAr,
    this.recipientName,
    this.recipientNameAr,
    this.giftReason,
    this.giftReasonAr,
    this.fairMarketValue,
    this.taxTreatment,
    this.taxTreatmentAr,
    this.authorizationReference,
  });

  /// Gift direction: received or given.
  final GiftDirection direction;

  /// Occasion for the gift (e.g., "Annual Partner Appreciation").
  final String? occasion;
  final String? occasionAr;

  /// For received gifts: donor's name.
  final String? donorName;
  final String? donorNameAr;

  /// For given gifts: recipient's name.
  final String? recipientName;
  final String? recipientNameAr;

  /// Reason for the gift.
  final String? giftReason;
  final String? giftReasonAr;

  /// Estimated fair market value for accounting.
  final double? fairMarketValue;

  /// Tax treatment notes (e.g., "VAT exempt", "Deductible expense").
  final String? taxTreatment;
  final String? taxTreatmentAr;

  /// Authorization/approval reference.
  final String? authorizationReference;
}

/// Inventory voucher-specific data.
class VoucherInventoryData {
  const VoucherInventoryData({
    required this.operationType,
    this.sourceWarehouse,
    this.sourceWarehouseAr,
    this.destinationWarehouse,
    this.destinationWarehouseAr,
    this.requestingDepartment,
    this.requestingDepartmentAr,
    this.projectCode,
    this.adjustmentReason,
    this.damageType,
    this.damageDescription,
    this.damageDescriptionAr,
    this.transferOrderNumber,
    this.authorizationReference,
    this.inspectedBy,
    this.inspectedByAr,
    this.disposalMethod,
    this.disposalMethodAr,
    this.insuranceClaim,
    this.insuranceClaimNumber,
  });

  /// Type of inventory operation.
  final InventoryOperationType operationType;

  /// Source warehouse (for issue, transfer, damage).
  final String? sourceWarehouse;
  final String? sourceWarehouseAr;

  /// Destination warehouse (for addition, transfer).
  final String? destinationWarehouse;
  final String? destinationWarehouseAr;

  /// Department/project requesting the issue.
  final String? requestingDepartment;
  final String? requestingDepartmentAr;
  final String? projectCode;

  /// Adjustment reason (for adjustment operations).
  final InventoryAdjustmentReason? adjustmentReason;

  /// Damage type (for damage/write-off operations).
  final InventoryDamageType? damageType;
  final String? damageDescription;
  final String? damageDescriptionAr;

  /// Transfer order number (for transfers).
  final String? transferOrderNumber;

  /// Authorization reference.
  final String? authorizationReference;

  /// Inspector for damage vouchers.
  final String? inspectedBy;
  final String? inspectedByAr;

  /// Disposal method for damaged goods.
  final String? disposalMethod;
  final String? disposalMethodAr;

  /// Whether insurance claim is filed.
  final bool? insuranceClaim;
  final String? insuranceClaimNumber;
}

/// Signatory factory for gift voucher-specific roles.
extension GiftSignatories on VoucherSignatory {
  static VoucherSignatory donor({String? name}) => VoucherSignatory(
        role: 'Donor',
        roleAr: 'المانح',
        name: name,
      );

  static VoucherSignatory recipient({String? name}) => VoucherSignatory(
        role: 'Recipient',
        roleAr: 'المستلم',
        name: name,
      );

  static VoucherSignatory marketing({String? name}) => VoucherSignatory(
        role: 'Marketing Dept',
        roleAr: 'قسم التسويق',
        name: name,
      );
}

/// Signatory factory for inventory voucher-specific roles.
extension InventorySignatories on VoucherSignatory {
  static VoucherSignatory warehouseManager({String? name}) => VoucherSignatory(
        role: 'Warehouse Manager',
        roleAr: 'مدير المستودع',
        name: name,
      );

  static VoucherSignatory storekeeper({String? name}) => VoucherSignatory(
        role: 'Storekeeper',
        roleAr: 'أمين المخزن',
        name: name,
      );

  static VoucherSignatory requestor({String? name}) => VoucherSignatory(
        role: 'Requestor',
        roleAr: 'مقدم الطلب',
        name: name,
      );

  static VoucherSignatory insuranceOfficer({String? name}) => VoucherSignatory(
        role: 'Insurance Officer',
        roleAr: 'مسؤول التأمين',
        name: name,
      );
}
