
import 'dart:math' as math;

/// Structural value-object base used by the S06 domain layer.
abstract class ErpValue {
  const ErpValue();

  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType &&
          other is ErpValue &&
          _deepEquals(props, other.props);

  @override
  int get hashCode => Object.hash(runtimeType, _deepHash(props));
}

bool _deepEquals(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_deepEquals(a[i], b[i])) return false;
    }
    return true;
  }
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (!b.containsKey(e.key) || !_deepEquals(e.value, b[e.key])) {
        return false;
      }
    }
    return true;
  }
  return a == b;
}

int _deepHash(Object? value) {
  if (value is List) return Object.hashAll(value.map(_deepHash));
  if (value is Map) {
    final entries = value.entries.toList()
      ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));
    return Object.hashAll(
      entries.map((e) => Object.hash(_deepHash(e.key), _deepHash(e.value))),
    );
  }
  return value.hashCode;
}

/// T14/T17 — currency identity and precision.
class ErpCurrency extends ErpValue {
  const ErpCurrency({
    required this.code,
    this.name,
    this.symbol,
    this.precision = 2,
  }) : assert(precision >= 0 && precision <= 8);

  static const sar = ErpCurrency(
    code: 'SAR', name: 'Saudi Riyal', symbol: 'SAR', precision: 2,
  );
  static const usd = ErpCurrency(
    code: 'USD', name: 'US Dollar', symbol: r'$', precision: 2,
  );
  static const eur = ErpCurrency(
    code: 'EUR', name: 'Euro', symbol: '€', precision: 2,
  );
  static const kwd = ErpCurrency(
    code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'KWD', precision: 3,
  );
  static const jpy = ErpCurrency(
    code: 'JPY', name: 'Japanese Yen', symbol: 'JPY', precision: 0,
  );

  final String code;
  final String? name;
  final String? symbol;
  final int precision;

  String get normalizedCode => code.trim().toUpperCase();

  @override
  List<Object?> get props => [normalizedCode, precision];

  @override
  String toString() => normalizedCode;
}

enum ErpRoundingMode { halfUp, halfEven, truncate, floor, ceiling }

/// T16/T42 — explicit deterministic rounding.
class ErpRoundingStrategy extends ErpValue {
  const ErpRoundingStrategy({this.mode = ErpRoundingMode.halfUp});

  final ErpRoundingMode mode;

  int roundScaled(double value) {
    switch (mode) {
      case ErpRoundingMode.halfUp:
        return value >= 0
            ? (value + 0.5).floor()
            : -((-value + 0.5).floor());
      case ErpRoundingMode.halfEven:
        final floorValue = value.floor();
        final fraction = value - floorValue;
        if (fraction < 0.5) return floorValue;
        if (fraction > 0.5) return floorValue + 1;
        return floorValue.isEven ? floorValue : floorValue + 1;
      case ErpRoundingMode.truncate:
        return value.truncate();
      case ErpRoundingMode.floor:
        return value.floor();
      case ErpRoundingMode.ceiling:
        return value.ceil();
    }
  }

  int roundMinorUnitsToIncrement(int units, int increment) {
    if (increment <= 0) {
      throw ArgumentError.value(increment, 'increment', 'Must be > 0.');
    }
    if (increment == 1) return units;
    return roundScaled(units / increment) * increment;
  }

  @override
  List<Object?> get props => [mode];
}

/// T13 — integer-minor-unit monetary value.
class ErpMoney extends ErpValue implements Comparable<ErpMoney> {
  const ErpMoney.fromMinorUnits(this.minorUnits, {required this.currency});

  factory ErpMoney.fromAmount(
    num amount, {
    required ErpCurrency currency,
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) {
    if (!amount.toDouble().isFinite) {
      throw ArgumentError.value(amount, 'amount', 'Must be finite.');
    }
    final factor = math.pow(10, currency.precision).toDouble();
    return ErpMoney.fromMinorUnits(
      rounding.roundScaled(amount.toDouble() * factor),
      currency: currency,
    );
  }

  factory ErpMoney.zero(ErpCurrency currency) =>
      ErpMoney.fromMinorUnits(0, currency: currency);

  final int minorUnits;
  final ErpCurrency currency;

  bool get isZero => minorUnits == 0;
  bool get isNegative => minorUnits < 0;
  bool get isPositive => minorUnits > 0;

  double toDouble() =>
      minorUnits / math.pow(10, currency.precision);

  ErpMoney abs() =>
      ErpMoney.fromMinorUnits(minorUnits.abs(), currency: currency);

  ErpMoney operator -() =>
      ErpMoney.fromMinorUnits(-minorUnits, currency: currency);

  ErpMoney operator +(ErpMoney other) {
    _same(other);
    return ErpMoney.fromMinorUnits(
      minorUnits + other.minorUnits, currency: currency,
    );
  }

  ErpMoney operator -(ErpMoney other) {
    _same(other);
    return ErpMoney.fromMinorUnits(
      minorUnits - other.minorUnits, currency: currency,
    );
  }

  ErpMoney multiply(
    num factor, {
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) =>
      ErpMoney.fromAmount(
        toDouble() * factor.toDouble(),
        currency: currency,
        rounding: rounding,
      );

  ErpMoney percentage(
    num percent, {
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) =>
      multiply(percent.toDouble() / 100, rounding: rounding);

  ErpMoney min(ErpMoney other) {
    _same(other);
    return minorUnits <= other.minorUnits ? this : other;
  }

  void _same(ErpMoney other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: ${currency.code}/${other.currency.code}.',
      );
    }
  }

  @override
  int compareTo(ErpMoney other) {
    _same(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  @override
  List<Object?> get props => [minorUnits, currency];

  @override
  String toString() =>
      '${toDouble().toStringAsFixed(currency.precision)} ${currency.code}';
}

/// T15/T18/T39 — explicit document→base currency conversion.
class ErpExchangeRate extends ErpValue {
  const ErpExchangeRate({
    required this.from,
    required this.to,
    required this.rate,
    this.effectiveAt,
    this.source,
    this.reference,
  });

  final ErpCurrency from;
  final ErpCurrency to;
  final double rate;
  final DateTime? effectiveAt;
  final String? source;
  final String? reference;

  ErpMoney convert(
    ErpMoney amount, {
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) {
    if (amount.currency != from) {
      throw ArgumentError(
        'Expected ${from.code}; received ${amount.currency.code}.',
      );
    }
    if (!rate.isFinite || rate <= 0) {
      throw StateError('Exchange rate must be positive and finite.');
    }
    return ErpMoney.fromAmount(
      amount.toDouble() * rate,
      currency: to,
      rounding: rounding,
    );
  }

  ErpExchangeRate reverse() => ErpExchangeRate(
        from: to,
        to: from,
        rate: 1 / rate,
        effectiveAt: effectiveAt,
        source: source,
        reference: reference,
      );

  @override
  List<Object?> get props =>
      [from, to, rate, effectiveAt, source, reference];
}

enum ErpAddressRole { registered, billing, shipping, warehouse, other }

/// T09/T12 — reusable semantic address.
class ErpAddress extends ErpValue {
  const ErpAddress({
    this.id,
    this.role = ErpAddressRole.other,
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
    this.attentionTo,
  });

  final String? id;
  final ErpAddressRole role;
  final String? line1;
  final String? line2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? countryCode;
  final String? attentionTo;

  bool get isEmpty => [
        line1, line2, city, state, postalCode, countryCode, attentionTo,
      ].every((v) => v == null || v.trim().isEmpty);

  @override
  List<Object?> get props => [
        id, role, line1, line2, city, state, postalCode, countryCode, attentionTo,
      ];
}

/// T10 — tax/legal identity.
class ErpTaxIdentity extends ErpValue {
  const ErpTaxIdentity({
    required this.taxNumber,
    this.scheme = 'VAT',
    this.countryCode,
    this.legalRegistrationNumber,
  });

  final String taxNumber;
  final String scheme;
  final String? countryCode;
  final String? legalRegistrationNumber;

  @override
  List<Object?> get props =>
      [taxNumber, scheme, countryCode, legalRegistrationNumber];
}

/// T11 — optional contact metadata.
class ErpContactMetadata extends ErpValue {
  const ErpContactMetadata({
    this.contactName,
    this.position,
    this.phone,
    this.mobile,
    this.email,
    this.website,
    this.metadata = const {},
  });

  final String? contactName;
  final String? position;
  final String? phone;
  final String? mobile;
  final String? email;
  final String? website;
  final Map<String, Object?> metadata;

  bool get isEmpty =>
      contactName == null &&
      position == null &&
      phone == null &&
      mobile == null &&
      email == null &&
      website == null &&
      metadata.isEmpty;

  @override
  List<Object?> get props =>
      [contactName, position, phone, mobile, email, website, metadata];
}

/// T08 — customer/supplier/other counterparty.
class ErpParty extends ErpValue {
  const ErpParty({
    this.id,
    required this.name,
    this.nameAr,
    this.registrationNumber,
    this.taxIdentity,
    this.addresses = const [],
    this.contacts = const [],
    this.metadata = const {},
  });

  final String? id;
  final String name;
  final String? nameAr;
  final String? registrationNumber;
  final ErpTaxIdentity? taxIdentity;
  final List<ErpAddress> addresses;
  final List<ErpContactMetadata> contacts;
  final Map<String, Object?> metadata;

  ErpAddress? addressFor(ErpAddressRole role) {
    for (final address in addresses) {
      if (address.role == role) return address;
    }
    return null;
  }

  String displayName({bool isRtl = false}) =>
      isRtl && nameAr != null ? nameAr! : name;

  @override
  List<Object?> get props => [
        id, name, nameAr, registrationNumber, taxIdentity,
        addresses, contacts, metadata,
      ];
}

/// T02 — organization shared by ERP documents.
class ErpOrganization extends ErpValue {
  const ErpOrganization({
    required this.id,
    required this.legalName,
    this.nameAr,
    this.tradeName,
    this.taxIdentity,
    this.registeredAddress,
    this.contacts = const [],
    this.metadata = const {},
  });

  final String id;
  final String legalName;
  final String? nameAr;
  final String? tradeName;
  final ErpTaxIdentity? taxIdentity;
  final ErpAddress? registeredAddress;
  final List<ErpContactMetadata> contacts;
  final Map<String, Object?> metadata;

  String displayName({bool isRtl = false}) =>
      isRtl && nameAr != null ? nameAr! : legalName;

  @override
  List<Object?> get props => [
        id, legalName, nameAr, tradeName, taxIdentity,
        registeredAddress, contacts, metadata,
      ];
}

/// T03 — optional organization branch.
class ErpBranch extends ErpValue {
  const ErpBranch({
    required this.id,
    required this.name,
    this.nameAr,
    this.organizationId,
    this.address,
    this.taxIdentity,
    this.contacts = const [],
    this.metadata = const {},
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? organizationId;
  final ErpAddress? address;
  final ErpTaxIdentity? taxIdentity;
  final List<ErpContactMetadata> contacts;
  final Map<String, Object?> metadata;

  @override
  List<Object?> get props => [
        id, name, nameAr, organizationId, address, taxIdentity, contacts, metadata,
      ];
}

class ErpUnit extends ErpValue {
  const ErpUnit({
    required this.code,
    required this.name,
    this.nameAr,
    this.precision = 3,
  });

  static const each =
      ErpUnit(code: 'EA', name: 'Each', nameAr: 'قطعة', precision: 3);

  final String code;
  final String name;
  final String? nameAr;
  final int precision;

  @override
  List<Object?> get props => [code, name, nameAr, precision];
}

class ErpQuantity extends ErpValue {
  const ErpQuantity({required this.value, required this.unit});
  final double value;
  final ErpUnit unit;

  @override
  List<Object?> get props => [value, unit];
}

enum ErpAdjustmentType { fixed, percentage }

class ErpDiscount extends ErpValue {
  const ErpDiscount._({
    required this.type,
    this.fixedAmount,
    this.percentage,
    this.code,
    this.label,
    this.labelAr,
  });

  factory ErpDiscount.fixed({
    required ErpMoney amount,
    String? code,
    String? label,
    String? labelAr,
  }) =>
      ErpDiscount._(
        type: ErpAdjustmentType.fixed,
        fixedAmount: amount,
        code: code,
        label: label,
        labelAr: labelAr,
      );

  factory ErpDiscount.percentage({
    required double percentage,
    String? code,
    String? label,
    String? labelAr,
  }) =>
      ErpDiscount._(
        type: ErpAdjustmentType.percentage,
        percentage: percentage,
        code: code,
        label: label,
        labelAr: labelAr,
      );

  final ErpAdjustmentType type;
  final ErpMoney? fixedAmount;
  final double? percentage;
  final String? code;
  final String? label;
  final String? labelAr;

  ErpMoney resolve(
    ErpMoney base, {
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) {
    if (type == ErpAdjustmentType.fixed) {
      final value = fixedAmount!;
      if (value.currency != base.currency) {
        throw ArgumentError('Discount currency mismatch.');
      }
      return value;
    }
    return base.percentage(percentage!, rounding: rounding);
  }

  @override
  List<Object?> get props =>
      [type, fixedAmount, percentage, code, label, labelAr];
}

class ErpCharge extends ErpValue {
  const ErpCharge._({
    required this.type,
    this.fixedAmount,
    this.percentage,
    this.code,
    this.label,
    this.labelAr,
    this.taxable = true,
  });

  factory ErpCharge.fixed({
    required ErpMoney amount,
    String? code,
    String? label,
    String? labelAr,
    bool taxable = true,
  }) =>
      ErpCharge._(
        type: ErpAdjustmentType.fixed,
        fixedAmount: amount,
        code: code,
        label: label,
        labelAr: labelAr,
        taxable: taxable,
      );

  factory ErpCharge.percentage({
    required double percentage,
    String? code,
    String? label,
    String? labelAr,
    bool taxable = true,
  }) =>
      ErpCharge._(
        type: ErpAdjustmentType.percentage,
        percentage: percentage,
        code: code,
        label: label,
        labelAr: labelAr,
        taxable: taxable,
      );

  final ErpAdjustmentType type;
  final ErpMoney? fixedAmount;
  final double? percentage;
  final String? code;
  final String? label;
  final String? labelAr;
  final bool taxable;

  ErpMoney resolve(
    ErpMoney base, {
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) {
    if (type == ErpAdjustmentType.fixed) {
      final value = fixedAmount!;
      if (value.currency != base.currency) {
        throw ArgumentError('Charge currency mismatch.');
      }
      return value;
    }
    return base.percentage(percentage!, rounding: rounding);
  }

  @override
  List<Object?> get props =>
      [type, fixedAmount, percentage, code, label, labelAr, taxable];
}

class ErpTaxLine extends ErpValue {
  const ErpTaxLine({
    required this.code,
    required this.ratePercent,
    this.name,
    this.nameAr,
    this.compound = false,
  });

  final String code;
  final double ratePercent;
  final String? name;
  final String? nameAr;
  final bool compound;

  @override
  List<Object?> get props =>
      [code, ratePercent, name, nameAr, compound];
}

class ErpBatchInfo extends ErpValue {
  const ErpBatchInfo({
    required this.batchNumber,
    this.productionDate,
    this.expiryDate,
    this.manufacturerLot,
  });

  final String batchNumber;
  final DateTime? productionDate;
  final DateTime? expiryDate;
  final String? manufacturerLot;

  @override
  List<Object?> get props =>
      [batchNumber, productionDate, expiryDate, manufacturerLot];
}

class ErpSerialInfo extends ErpValue {
  const ErpSerialInfo({
    required this.serialNumber,
    this.imei,
    this.assetTag,
    this.metadata = const {},
  });

  final String serialNumber;
  final String? imei;
  final String? assetTag;
  final Map<String, Object?> metadata;

  @override
  List<Object?> get props => [serialNumber, imei, assetTag, metadata];
}

class ErpLineItem extends ErpValue {
  const ErpLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.sku,
    this.discounts = const [],
    this.charges = const [],
    this.taxes = const [],
    this.batch,
    this.serials = const [],
    this.notes,
    this.metadata = const {},
  });

  final String id;
  final String description;
  final String? descriptionAr;
  final String? sku;
  final ErpQuantity quantity;
  final ErpMoney unitPrice;
  final List<ErpDiscount> discounts;
  final List<ErpCharge> charges;
  final List<ErpTaxLine> taxes;
  final ErpBatchInfo? batch;
  final List<ErpSerialInfo> serials;
  final String? notes;
  final Map<String, Object?> metadata;

  ErpMoney grossAmount({
    ErpRoundingStrategy rounding = const ErpRoundingStrategy(),
  }) =>
      unitPrice.multiply(quantity.value, rounding: rounding);

  @override
  List<Object?> get props => [
        id, description, descriptionAr, sku, quantity, unitPrice,
        discounts, charges, taxes, batch, serials, notes, metadata,
      ];
}

enum ErpApprovalStatus { pending, approved, rejected }

class ErpApproval extends ErpValue {
  const ErpApproval({
    required this.stage,
    required this.status,
    this.approverId,
    this.approverName,
    this.decidedAt,
    this.comment,
  });

  final String stage;
  final ErpApprovalStatus status;
  final String? approverId;
  final String? approverName;
  final DateTime? decidedAt;
  final String? comment;

  @override
  List<Object?> get props =>
      [stage, status, approverId, approverName, decidedAt, comment];
}

class ErpSignature extends ErpValue {
  const ErpSignature({
    required this.signerName,
    this.signerId,
    this.signedAt,
    this.method,
    this.digest,
    this.imageReference,
  });

  final String signerName;
  final String? signerId;
  final DateTime? signedAt;
  final String? method;
  final String? digest;
  final String? imageReference;

  @override
  List<Object?> get props =>
      [signerName, signerId, signedAt, method, digest, imageReference];
}

class ErpAttachment extends ErpValue {
  const ErpAttachment({
    required this.id,
    required this.name,
    this.mimeType,
    this.uri,
    this.description,
    this.sizeBytes,
    this.sha256,
  });

  final String id;
  final String name;
  final String? mimeType;
  final Uri? uri;
  final String? description;
  final int? sizeBytes;
  final String? sha256;

  @override
  List<Object?> get props =>
      [id, name, mimeType, uri, description, sizeBytes, sha256];
}

enum ErpDocumentKind {
  quotation,
  purchaseOrder,
  invoice,
  creditNote,
  debitNote,
  receipt,
  statement,
  other,
}

enum ErpDocumentStatus {
  draft,
  issued,
  approved,
  posted,
  partiallyPaid,
  paid,
  cancelled,
  voided,
}

class ErpDocumentIdentity extends ErpValue {
  const ErpDocumentIdentity({
    required this.kind,
    required this.number,
    required this.issueDate,
    this.status = ErpDocumentStatus.draft,
    this.id,
    this.uuid,
    this.series,
    this.externalId,
  });

  final ErpDocumentKind kind;
  final String number;
  final DateTime issueDate;
  final ErpDocumentStatus status;
  final String? id;
  final String? uuid;
  final String? series;
  final String? externalId;

  @override
  List<Object?> get props =>
      [kind, number, issueDate, status, id, uuid, series, externalId];
}

class ErpDocumentReference extends ErpValue {
  const ErpDocumentReference({
    required this.type,
    required this.number,
    this.date,
    this.id,
    this.externalId,
  });

  final String type;
  final String number;
  final DateTime? date;
  final String? id;
  final String? externalId;

  @override
  List<Object?> get props => [type, number, date, id, externalId];
}

class ErpPrintMetadata extends ErpValue {
  const ErpPrintMetadata({
    this.printedAt,
    this.printedBy,
    this.locale,
    this.copyLabel,
    this.copyNumber,
    this.profile,
    this.generatedBy,
  });

  final DateTime? printedAt;
  final String? printedBy;
  final String? locale;
  final String? copyLabel;
  final int? copyNumber;
  final String? profile;
  final String? generatedBy;

  bool get isEmpty =>
      printedAt == null &&
      printedBy == null &&
      locale == null &&
      copyLabel == null &&
      copyNumber == null &&
      profile == null &&
      generatedBy == null;

  @override
  List<Object?> get props =>
      [printedAt, printedBy, locale, copyLabel, copyNumber, profile, generatedBy];
}

/// T01 — shared context for Quotation/PO/Invoice and later families.
class ErpDocumentContext extends ErpValue {
  const ErpDocumentContext({
    required this.organization,
    required this.identity,
    required this.documentCurrency,
    this.branch,
    this.issuer,
    this.recipient,
    this.billingAddress,
    this.shippingAddress,
    this.baseCurrency,
    this.exchangeRate,
    this.references = const [],
    this.lineItems = const [],
    this.approvals = const [],
    this.signatures = const [],
    this.attachments = const [],
    this.printMetadata,
    this.notes,
    this.terms,
    this.metadata = const {},
  });

  final ErpOrganization organization;
  final ErpBranch? branch;
  final ErpDocumentIdentity identity;
  final ErpParty? issuer;
  final ErpParty? recipient;
  final ErpAddress? billingAddress;
  final ErpAddress? shippingAddress;
  final ErpCurrency documentCurrency;
  final ErpCurrency? baseCurrency;
  final ErpExchangeRate? exchangeRate;
  final List<ErpDocumentReference> references;
  final List<ErpLineItem> lineItems;
  final List<ErpApproval> approvals;
  final List<ErpSignature> signatures;
  final List<ErpAttachment> attachments;
  final ErpPrintMetadata? printMetadata;
  final String? notes;
  final String? terms;
  final Map<String, Object?> metadata;

  @override
  List<Object?> get props => [
        organization, branch, identity, issuer, recipient,
        billingAddress, shippingAddress, documentCurrency, baseCurrency,
        exchangeRate, references, lineItems, approvals, signatures,
        attachments, printMetadata, notes, terms, metadata,
      ];
}
