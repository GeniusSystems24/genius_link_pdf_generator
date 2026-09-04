
import 'models.dart';

enum ErpDocumentDiscountTaxPolicy { beforeTax, afterTax }

class ErpCalculationConfig extends ErpValue {
  const ErpCalculationConfig({
    this.rounding = const ErpRoundingStrategy(),
    this.documentDiscountTaxPolicy =
        ErpDocumentDiscountTaxPolicy.beforeTax,
    this.allowZeroQuantity = false,
    this.allowNegativeQuantity = false,
    this.allowNegativeUnitPrice = false,
    this.allowNegativeGrandTotal = false,
    this.allowDiscountExceedsBase = false,
    this.roundingIncrementMinorUnits = 1,
  }) : assert(roundingIncrementMinorUnits > 0);

  final ErpRoundingStrategy rounding;
  final ErpDocumentDiscountTaxPolicy documentDiscountTaxPolicy;
  final bool allowZeroQuantity;
  final bool allowNegativeQuantity;
  final bool allowNegativeUnitPrice;
  final bool allowNegativeGrandTotal;
  final bool allowDiscountExceedsBase;
  final int roundingIncrementMinorUnits;

  @override
  List<Object?> get props => [
        rounding,
        documentDiscountTaxPolicy,
        allowZeroQuantity,
        allowNegativeQuantity,
        allowNegativeUnitPrice,
        allowNegativeGrandTotal,
        allowDiscountExceedsBase,
        roundingIncrementMinorUnits,
      ];
}

class ErpCalculationRequest extends ErpValue {
  const ErpCalculationRequest({
    required this.currency,
    required this.lineItems,
    this.documentDiscounts = const [],
    this.documentCharges = const [],
    this.documentTaxes = const [],
    this.paidAmount,
    this.baseCurrency,
    this.exchangeRate,
    this.config = const ErpCalculationConfig(),
  });

  factory ErpCalculationRequest.fromContext(
    ErpDocumentContext context, {
    List<ErpDiscount> documentDiscounts = const [],
    List<ErpCharge> documentCharges = const [],
    List<ErpTaxLine> documentTaxes = const [],
    ErpMoney? paidAmount,
    ErpCalculationConfig config = const ErpCalculationConfig(),
  }) =>
      ErpCalculationRequest(
        currency: context.documentCurrency,
        lineItems: context.lineItems,
        documentDiscounts: documentDiscounts,
        documentCharges: documentCharges,
        documentTaxes: documentTaxes,
        paidAmount: paidAmount,
        baseCurrency: context.baseCurrency,
        exchangeRate: context.exchangeRate,
        config: config,
      );

  final ErpCurrency currency;
  final List<ErpLineItem> lineItems;
  final List<ErpDiscount> documentDiscounts;
  final List<ErpCharge> documentCharges;
  final List<ErpTaxLine> documentTaxes;
  final ErpMoney? paidAmount;
  final ErpCurrency? baseCurrency;
  final ErpExchangeRate? exchangeRate;
  final ErpCalculationConfig config;

  @override
  List<Object?> get props => [
        currency,
        lineItems,
        documentDiscounts,
        documentCharges,
        documentTaxes,
        paidAmount,
        baseCurrency,
        exchangeRate,
        config,
      ];
}

class ErpCalculatedTax extends ErpValue {
  const ErpCalculatedTax({
    required this.tax,
    required this.taxableBase,
    required this.amount,
  });

  final ErpTaxLine tax;
  final ErpMoney taxableBase;
  final ErpMoney amount;

  @override
  List<Object?> get props => [tax, taxableBase, amount];
}

class ErpTaxTotal extends ErpValue {
  const ErpTaxTotal({
    required this.code,
    required this.ratePercent,
    required this.compound,
    required this.taxableAmount,
    required this.taxAmount,
  });

  final String code;
  final double ratePercent;
  final bool compound;
  final ErpMoney taxableAmount;
  final ErpMoney taxAmount;

  @override
  List<Object?> get props =>
      [code, ratePercent, compound, taxableAmount, taxAmount];
}

class ErpLineCalculation extends ErpValue {
  const ErpLineCalculation({
    required this.line,
    required this.subtotal,
    required this.lineDiscountTotal,
    required this.lineChargeTotal,
    required this.allocatedDocumentDiscount,
    required this.taxableAmount,
    required this.taxes,
    required this.taxTotal,
    required this.total,
  });

  final ErpLineItem line;
  final ErpMoney subtotal;
  final ErpMoney lineDiscountTotal;
  final ErpMoney lineChargeTotal;
  final ErpMoney allocatedDocumentDiscount;
  final ErpMoney taxableAmount;
  final List<ErpCalculatedTax> taxes;
  final ErpMoney taxTotal;
  final ErpMoney total;

  @override
  List<Object?> get props => [
        line,
        subtotal,
        lineDiscountTotal,
        lineChargeTotal,
        allocatedDocumentDiscount,
        taxableAmount,
        taxes,
        taxTotal,
        total,
      ];
}

class ErpCalculationResult extends ErpValue {
  const ErpCalculationResult({
    required this.currency,
    required this.lines,
    required this.subtotal,
    required this.lineDiscountTotal,
    required this.documentDiscountTotal,
    required this.chargeTotal,
    required this.taxableAmount,
    required this.taxTotals,
    required this.taxTotal,
    required this.totalBeforeRounding,
    required this.roundingAdjustment,
    required this.grandTotal,
    this.paidAmount,
    this.dueAmount,
    this.baseCurrency,
    this.baseGrandTotal,
    this.basePaidAmount,
    this.baseDueAmount,
  });

  final ErpCurrency currency;
  final List<ErpLineCalculation> lines;
  final ErpMoney subtotal;
  final ErpMoney lineDiscountTotal;
  final ErpMoney documentDiscountTotal;
  final ErpMoney chargeTotal;
  final ErpMoney taxableAmount;
  final List<ErpTaxTotal> taxTotals;
  final ErpMoney taxTotal;
  final ErpMoney totalBeforeRounding;
  final ErpMoney roundingAdjustment;
  final ErpMoney grandTotal;

  /// Null means payment state is not modeled for this document.
  final ErpMoney? paidAmount;
  final ErpMoney? dueAmount;

  final ErpCurrency? baseCurrency;
  final ErpMoney? baseGrandTotal;
  final ErpMoney? basePaidAmount;
  final ErpMoney? baseDueAmount;

  @override
  List<Object?> get props => [
        currency,
        lines,
        subtotal,
        lineDiscountTotal,
        documentDiscountTotal,
        chargeTotal,
        taxableAmount,
        taxTotals,
        taxTotal,
        totalBeforeRounding,
        roundingAdjustment,
        grandTotal,
        paidAmount,
        dueAmount,
        baseCurrency,
        baseGrandTotal,
        basePaidAmount,
        baseDueAmount,
      ];
}

class ErpValidationIssue extends ErpValue {
  const ErpValidationIssue({
    required this.code,
    required this.message,
    this.path,
  });

  final String code;
  final String message;
  final String? path;

  @override
  List<Object?> get props => [code, message, path];

  @override
  String toString() =>
      path == null ? '$code: $message' : '$code($path): $message';
}

class ErpValidationResult extends ErpValue {
  const ErpValidationResult(this.issues);

  final List<ErpValidationIssue> issues;
  bool get isValid => issues.isEmpty;

  @override
  List<Object?> get props => [issues];
}

class ErpDomainValidationException implements Exception {
  const ErpDomainValidationException(this.issues);
  final List<ErpValidationIssue> issues;

  @override
  String toString() =>
      'ErpDomainValidationException(${issues.join('; ')})';
}

/// T41/T43/T44/T45 — deterministic typed input validation.
class ErpDomainValidator {
  const ErpDomainValidator();

  ErpValidationResult validateDocumentContext(
    ErpDocumentContext context,
  ) {
    final issues = <ErpValidationIssue>[];

    if (context.organization.id.trim().isEmpty) {
      issues.add(
        const ErpValidationIssue(
          code: 'organization.id.required',
          message: 'Organization id is required.',
          path: 'organization.id',
        ),
      );
    }
    if (context.organization.legalName.trim().isEmpty) {
      issues.add(
        const ErpValidationIssue(
          code: 'organization.name.required',
          message: 'Organization legal name is required.',
          path: 'organization.legalName',
        ),
      );
    }
    if (context.identity.number.trim().isEmpty) {
      issues.add(
        const ErpValidationIssue(
          code: 'document.number.required',
          message: 'Document number is required.',
          path: 'identity.number',
        ),
      );
    }

    _currency(context.documentCurrency, 'documentCurrency', issues);

    final base = context.baseCurrency;
    if (base != null) {
      _currency(base, 'baseCurrency', issues);
      if (base != context.documentCurrency) {
        final rate = context.exchangeRate;
        if (rate == null) {
          issues.add(
            const ErpValidationIssue(
              code: 'exchangeRate.required',
              message:
                  'Exchange rate is required when base/document currencies differ.',
              path: 'exchangeRate',
            ),
          );
        } else {
          _rate(
            rate,
            context.documentCurrency,
            base,
            issues,
          );
        }
      }
    }

    return ErpValidationResult(issues);
  }

  ErpValidationResult validateCalculationRequest(
    ErpCalculationRequest request,
  ) {
    final issues = <ErpValidationIssue>[];
    _currency(request.currency, 'currency', issues);

    if (request.config.roundingIncrementMinorUnits <= 0) {
      issues.add(
        const ErpValidationIssue(
          code: 'rounding.increment.invalid',
          message: 'Rounding increment must be greater than zero.',
          path: 'config.roundingIncrementMinorUnits',
        ),
      );
    }

    for (var i = 0; i < request.lineItems.length; i++) {
      _line(request.lineItems[i], i, request, issues);
    }

    for (var i = 0; i < request.documentDiscounts.length; i++) {
      _discount(
        request.documentDiscounts[i],
        request.currency,
        'documentDiscounts[$i]',
        issues,
      );
    }
    for (var i = 0; i < request.documentCharges.length; i++) {
      _charge(
        request.documentCharges[i],
        request.currency,
        'documentCharges[$i]',
        issues,
      );
    }
    for (var i = 0; i < request.documentTaxes.length; i++) {
      _tax(request.documentTaxes[i], 'documentTaxes[$i]', issues);
    }

    final paid = request.paidAmount;
    if (paid != null && paid.currency != request.currency) {
      issues.add(
        const ErpValidationIssue(
          code: 'paid.currency.mismatch',
          message: 'Paid amount must use document currency.',
          path: 'paidAmount',
        ),
      );
    }

    final base = request.baseCurrency;
    final rate = request.exchangeRate;
    if (base != null) {
      _currency(base, 'baseCurrency', issues);
      if (base != request.currency) {
        if (rate == null) {
          issues.add(
            const ErpValidationIssue(
              code: 'exchangeRate.required',
              message:
                  'Exchange rate is required when base/document currencies differ.',
              path: 'exchangeRate',
            ),
          );
        } else {
          _rate(rate, request.currency, base, issues);
        }
      }
    } else if (rate != null) {
      issues.add(
        const ErpValidationIssue(
          code: 'baseCurrency.required',
          message: 'baseCurrency is required with exchangeRate.',
          path: 'baseCurrency',
        ),
      );
    }

    return ErpValidationResult(issues);
  }

  void _line(
    ErpLineItem line,
    int index,
    ErpCalculationRequest request,
    List<ErpValidationIssue> issues,
  ) {
    final path = 'lineItems[$index]';

    if (line.id.trim().isEmpty) {
      issues.add(
        ErpValidationIssue(
          code: 'line.id.required',
          message: 'Line id is required.',
          path: '$path.id',
        ),
      );
    }

    if (line.description.trim().isEmpty) {
      issues.add(
        ErpValidationIssue(
          code: 'line.description.required',
          message: 'Description is required.',
          path: '$path.description',
        ),
      );
    }

    final q = line.quantity.value;
    if (!q.isFinite) {
      issues.add(
        ErpValidationIssue(
          code: 'line.quantity.notFinite',
          message: 'Quantity must be finite.',
          path: '$path.quantity',
        ),
      );
    } else {
      if (q == 0 && !request.config.allowZeroQuantity) {
        issues.add(
          ErpValidationIssue(
            code: 'line.quantity.zeroNotAllowed',
            message: 'Zero quantity is disabled by config.',
            path: '$path.quantity',
          ),
        );
      }
      if (q < 0 && !request.config.allowNegativeQuantity) {
        issues.add(
          ErpValidationIssue(
            code: 'line.quantity.negativeNotAllowed',
            message: 'Negative quantity is disabled by config.',
            path: '$path.quantity',
          ),
        );
      }
    }

    if (line.unitPrice.currency != request.currency) {
      issues.add(
        ErpValidationIssue(
          code: 'line.currency.mismatch',
          message:
              'Line currency ${line.unitPrice.currency.code} differs from '
              '${request.currency.code}.',
          path: '$path.unitPrice',
        ),
      );
    }

    if (line.unitPrice.isNegative &&
        !request.config.allowNegativeUnitPrice) {
      issues.add(
        ErpValidationIssue(
          code: 'line.unitPrice.negativeNotAllowed',
          message: 'Negative unit price is disabled by config.',
          path: '$path.unitPrice',
        ),
      );
    }

    for (var i = 0; i < line.discounts.length; i++) {
      _discount(
        line.discounts[i],
        request.currency,
        '$path.discounts[$i]',
        issues,
      );
    }
    for (var i = 0; i < line.charges.length; i++) {
      _charge(
        line.charges[i],
        request.currency,
        '$path.charges[$i]',
        issues,
      );
    }
    for (var i = 0; i < line.taxes.length; i++) {
      _tax(line.taxes[i], '$path.taxes[$i]', issues);
    }
  }

  void _discount(
    ErpDiscount value,
    ErpCurrency currency,
    String path,
    List<ErpValidationIssue> issues,
  ) {
    if (value.type == ErpAdjustmentType.fixed) {
      final amount = value.fixedAmount;
      if (amount == null ||
          amount.currency != currency ||
          amount.isNegative) {
        issues.add(
          ErpValidationIssue(
            code: 'discount.fixed.invalid',
            message:
                'Fixed discount needs a non-negative amount in document currency.',
            path: path,
          ),
        );
      }
      return;
    }

    final p = value.percentage;
    if (p == null || !p.isFinite || p < 0 || p > 100) {
      issues.add(
        ErpValidationIssue(
          code: 'discount.percentage.invalid',
          message: 'Discount percentage must be 0..100.',
          path: path,
        ),
      );
    }
  }

  void _charge(
    ErpCharge value,
    ErpCurrency currency,
    String path,
    List<ErpValidationIssue> issues,
  ) {
    if (value.type == ErpAdjustmentType.fixed) {
      final amount = value.fixedAmount;
      if (amount == null ||
          amount.currency != currency ||
          amount.isNegative) {
        issues.add(
          ErpValidationIssue(
            code: 'charge.fixed.invalid',
            message:
                'Fixed charge needs a non-negative amount in document currency.',
            path: path,
          ),
        );
      }
      return;
    }

    final p = value.percentage;
    if (p == null || !p.isFinite || p < 0) {
      issues.add(
        ErpValidationIssue(
          code: 'charge.percentage.invalid',
          message: 'Charge percentage must be non-negative.',
          path: path,
        ),
      );
    }
  }

  void _tax(
    ErpTaxLine tax,
    String path,
    List<ErpValidationIssue> issues,
  ) {
    if (tax.code.trim().isEmpty) {
      issues.add(
        ErpValidationIssue(
          code: 'tax.code.required',
          message: 'Tax code is required.',
          path: '$path.code',
        ),
      );
    }
    if (!tax.ratePercent.isFinite || tax.ratePercent < 0) {
      issues.add(
        ErpValidationIssue(
          code: 'tax.rate.invalid',
          message: 'Tax rate must be non-negative and finite.',
          path: '$path.ratePercent',
        ),
      );
    }
  }

  void _currency(
    ErpCurrency currency,
    String path,
    List<ErpValidationIssue> issues,
  ) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency.code.trim())) {
      issues.add(
        ErpValidationIssue(
          code: 'currency.code.invalid',
          message: 'Currency code must be 3 uppercase letters.',
          path: '$path.code',
        ),
      );
    }
    if (currency.precision < 0 || currency.precision > 8) {
      issues.add(
        ErpValidationIssue(
          code: 'currency.precision.invalid',
          message: 'Currency precision must be 0..8.',
          path: '$path.precision',
        ),
      );
    }
  }

  void _rate(
    ErpExchangeRate rate,
    ErpCurrency from,
    ErpCurrency to,
    List<ErpValidationIssue> issues,
  ) {
    if (!rate.rate.isFinite || rate.rate <= 0) {
      issues.add(
        const ErpValidationIssue(
          code: 'exchangeRate.rate.invalid',
          message: 'Exchange rate must be positive and finite.',
          path: 'exchangeRate.rate',
        ),
      );
    }
    if (rate.from != from || rate.to != to) {
      issues.add(
        ErpValidationIssue(
          code: 'exchangeRate.pair.mismatch',
          message: 'Exchange rate must convert ${from.code} to ${to.code}.',
          path: 'exchangeRate',
        ),
      );
    }
  }
}

class _PreLine {
  const _PreLine({
    required this.line,
    required this.subtotal,
    required this.net,
    required this.discount,
    required this.charges,
    required this.taxableCharges,
    required this.taxableBeforeDocumentDiscount,
  });

  final ErpLineItem line;
  final ErpMoney subtotal;
  final ErpMoney net;
  final ErpMoney discount;
  final ErpMoney charges;
  final ErpMoney taxableCharges;
  final ErpMoney taxableBeforeDocumentDiscount;
}

/// T30..T39 — typed ERP calculation service.
class ErpCalculationService {
  const ErpCalculationService({
    this.validator = const ErpDomainValidator(),
  });

  final ErpDomainValidator validator;

  ErpCalculationResult calculate(ErpCalculationRequest request) {
    final validation = validator.validateCalculationRequest(request);
    if (!validation.isValid) {
      throw ErpDomainValidationException(validation.issues);
    }

    final c = request.currency;
    final zero = ErpMoney.zero(c);
    final rounding = request.config.rounding;

    final pre = request.lineItems
        .map((line) => _precalculate(line, request))
        .toList(growable: false);

    final subtotal = _sum(pre.map((e) => e.subtotal), c);
    final lineDiscount = _sum(pre.map((e) => e.discount), c);
    final netBase = _sum(pre.map((e) => e.net), c);
    final documentDiscount = _resolveDiscounts(
      request.documentDiscounts,
      netBase,
      request,
      'document',
    );

    final allocations =
        request.config.documentDiscountTaxPolicy ==
                ErpDocumentDiscountTaxPolicy.beforeTax
            ? _allocate(documentDiscount, pre, request)
            : List<ErpMoney>.filled(pre.length, zero, growable: false);

    final lines = <ErpLineCalculation>[];
    final allTaxes = <ErpCalculatedTax>[];

    for (var i = 0; i < pre.length; i++) {
      final p = pre[i];
      final allocated = allocations[i];
      final taxableReduction =
          allocated.min(p.taxableBeforeDocumentDiscount);
      final taxable =
          p.taxableBeforeDocumentDiscount - taxableReduction;
      final taxes = _taxes(taxable, p.line.taxes, rounding);
      allTaxes.addAll(taxes);
      final taxTotal = _sum(taxes.map((e) => e.amount), c);
      final total = p.net + p.charges - allocated + taxTotal;

      lines.add(
        ErpLineCalculation(
          line: p.line,
          subtotal: p.subtotal,
          lineDiscountTotal: p.discount,
          lineChargeTotal: p.charges,
          allocatedDocumentDiscount: allocated,
          taxableAmount: taxable,
          taxes: List.unmodifiable(taxes),
          taxTotal: taxTotal,
          total: total,
        ),
      );
    }

    final chargeBase = netBase - documentDiscount;
    final docCharges = _resolveCharges(
      request.documentCharges,
      chargeBase,
      request,
      'document',
    );
    final documentChargeTotal = _sum(docCharges.map((e) => e.$2), c);
    final taxableDocumentCharge = _sum(
      docCharges.where((e) => e.$1.taxable).map((e) => e.$2),
      c,
    );

    final lineTaxable = _sum(lines.map((e) => e.taxableAmount), c);
    final taxableAmount = lineTaxable + taxableDocumentCharge;
    final documentTaxes = _taxes(
      taxableAmount,
      request.documentTaxes,
      rounding,
    );
    allTaxes.addAll(documentTaxes);

    final lineTax = _sum(lines.map((e) => e.taxTotal), c);
    final documentTax = _sum(documentTaxes.map((e) => e.amount), c);
    final taxTotal = lineTax + documentTax;
    final lineCharges = _sum(lines.map((e) => e.lineChargeTotal), c);
    final chargeTotal = lineCharges + documentChargeTotal;

    var totalBeforeRounding =
        _sum(lines.map((e) => e.total), c) +
        documentChargeTotal +
        documentTax;

    if (request.config.documentDiscountTaxPolicy ==
        ErpDocumentDiscountTaxPolicy.afterTax) {
      totalBeforeRounding = totalBeforeRounding - documentDiscount;
    }

    if (totalBeforeRounding.isNegative &&
        !request.config.allowNegativeGrandTotal) {
      throw const ErpDomainValidationException([
        ErpValidationIssue(
          code: 'grandTotal.negativeNotAllowed',
          message: 'Negative grand total is disabled by config.',
          path: 'grandTotal',
        ),
      ]);
    }

    final roundedUnits = rounding.roundMinorUnitsToIncrement(
      totalBeforeRounding.minorUnits,
      request.config.roundingIncrementMinorUnits,
    );
    final grand = ErpMoney.fromMinorUnits(roundedUnits, currency: c);
    final roundingAdjustment = grand - totalBeforeRounding;

    final paid = request.paidAmount;
    final due = paid == null ? null : grand - paid;

    ErpMoney? baseGrand;
    ErpMoney? basePaid;
    ErpMoney? baseDue;
    final base = request.baseCurrency;

    if (base != null) {
      if (base == c) {
        baseGrand = grand;
        basePaid = paid;
        baseDue = due;
      } else {
        final rate = request.exchangeRate!;
        baseGrand = rate.convert(grand, rounding: rounding);
        basePaid = paid == null ? null : rate.convert(paid, rounding: rounding);
        baseDue = due == null ? null : rate.convert(due, rounding: rounding);
      }
    }

    return ErpCalculationResult(
      currency: c,
      lines: List.unmodifiable(lines),
      subtotal: subtotal,
      lineDiscountTotal: lineDiscount,
      documentDiscountTotal: documentDiscount,
      chargeTotal: chargeTotal,
      taxableAmount: taxableAmount,
      taxTotals: List.unmodifiable(_aggregateTaxes(allTaxes, c)),
      taxTotal: taxTotal,
      totalBeforeRounding: totalBeforeRounding,
      roundingAdjustment: roundingAdjustment,
      grandTotal: grand,
      paidAmount: paid,
      dueAmount: due,
      baseCurrency: base,
      baseGrandTotal: baseGrand,
      basePaidAmount: basePaid,
      baseDueAmount: baseDue,
    );
  }

  _PreLine _precalculate(
    ErpLineItem line,
    ErpCalculationRequest request,
  ) {
    final c = request.currency;
    final subtotal = line.grossAmount(rounding: request.config.rounding);
    final discount = _resolveDiscounts(
      line.discounts,
      subtotal,
      request,
      'line ${line.id}',
    );
    final net = subtotal - discount;
    final resolvedCharges =
        _resolveCharges(line.charges, net, request, 'line ${line.id}');
    final charges = _sum(resolvedCharges.map((e) => e.$2), c);
    final taxableCharges = _sum(
      resolvedCharges.where((e) => e.$1.taxable).map((e) => e.$2),
      c,
    );
    return _PreLine(
      line: line,
      subtotal: subtotal,
      net: net,
      discount: discount,
      charges: charges,
      taxableCharges: taxableCharges,
      taxableBeforeDocumentDiscount: net + taxableCharges,
    );
  }

  ErpMoney _resolveDiscounts(
    List<ErpDiscount> discounts,
    ErpMoney base,
    ErpCalculationRequest request,
    String source,
  ) {
    var remaining = base;
    var total = ErpMoney.zero(base.currency);

    for (final discount in discounts) {
      final amount = discount.resolve(
        remaining,
        rounding: request.config.rounding,
      );
      if (amount.compareTo(remaining) > 0 &&
          !request.config.allowDiscountExceedsBase) {
        throw ErpDomainValidationException([
          ErpValidationIssue(
            code: 'discount.exceedsBase',
            message: 'Discount exceeds calculation base for $source.',
            path: source,
          ),
        ]);
      }
      final effective =
          request.config.allowDiscountExceedsBase
              ? amount
              : amount.min(remaining);
      total = total + effective;
      remaining = remaining - effective;
    }

    return total;
  }

  List<(ErpCharge, ErpMoney)> _resolveCharges(
    List<ErpCharge> charges,
    ErpMoney base,
    ErpCalculationRequest request,
    String source,
  ) {
    final result = <(ErpCharge, ErpMoney)>[];
    for (final charge in charges) {
      final amount = charge.resolve(
        base,
        rounding: request.config.rounding,
      );
      if (amount.isNegative) {
        throw ErpDomainValidationException([
          ErpValidationIssue(
            code: 'charge.negative',
            message: 'Negative charge resolved for $source.',
            path: source,
          ),
        ]);
      }
      result.add((charge, amount));
    }
    return result;
  }

  List<ErpMoney> _allocate(
    ErpMoney discount,
    List<_PreLine> lines,
    ErpCalculationRequest request,
  ) {
    final c = request.currency;
    if (lines.isEmpty || discount.isZero) {
      return List.filled(lines.length, ErpMoney.zero(c), growable: false);
    }

    final base = _sum(lines.map((e) => e.net), c);
    if (discount.compareTo(base) > 0 &&
        !request.config.allowDiscountExceedsBase) {
      throw const ErpDomainValidationException([
        ErpValidationIssue(
          code: 'documentDiscount.exceedsBase',
          message: 'Document discount exceeds aggregate line net.',
          path: 'documentDiscounts',
        ),
      ]);
    }

    final effective =
        request.config.allowDiscountExceedsBase
            ? discount
            : discount.min(base);

    final result =
        List<ErpMoney>.filled(lines.length, ErpMoney.zero(c), growable: false);
    final eligible = <int>[
      for (var i = 0; i < lines.length; i++)
        if (!lines[i].net.isZero) i,
    ];
    if (eligible.isEmpty) return result;

    var remaining = effective;
    for (var order = 0; order < eligible.length; order++) {
      final index = eligible[order];
      final lineBase = lines[index].net;

      if (order == eligible.length - 1) {
        result[index] = remaining;
        break;
      }

      var allocation = ErpMoney.fromAmount(
        effective.toDouble() * (lineBase.toDouble() / base.toDouble()),
        currency: c,
        rounding: request.config.rounding,
      );
      if (allocation.compareTo(remaining) > 0) allocation = remaining;
      if (!request.config.allowDiscountExceedsBase &&
          allocation.compareTo(lineBase) > 0) {
        allocation = lineBase;
      }

      result[index] = allocation;
      remaining = remaining - allocation;
    }

    return result;
  }

  List<ErpCalculatedTax> _taxes(
    ErpMoney taxable,
    List<ErpTaxLine> taxes,
    ErpRoundingStrategy rounding,
  ) {
    if (taxes.isEmpty || taxable.isZero) return const [];

    final result = <ErpCalculatedTax>[];
    var accumulated = ErpMoney.zero(taxable.currency);

    for (final tax in taxes) {
      final base = tax.compound ? taxable + accumulated : taxable;
      final amount = base.percentage(tax.ratePercent, rounding: rounding);
      result.add(
        ErpCalculatedTax(tax: tax, taxableBase: base, amount: amount),
      );
      accumulated = accumulated + amount;
    }
    return result;
  }

  List<ErpTaxTotal> _aggregateTaxes(
    List<ErpCalculatedTax> taxes,
    ErpCurrency currency,
  ) {
    final bases = <String, ErpMoney>{};
    final amounts = <String, ErpMoney>{};
    final definitions = <String, ErpTaxLine>{};

    for (final item in taxes) {
      final tax = item.tax;
      final key = '${tax.code}|${tax.ratePercent}|${tax.compound}';
      definitions[key] = tax;
      bases[key] = (bases[key] ?? ErpMoney.zero(currency)) + item.taxableBase;
      amounts[key] = (amounts[key] ?? ErpMoney.zero(currency)) + item.amount;
    }

    return [
      for (final key in definitions.keys)
        ErpTaxTotal(
          code: definitions[key]!.code,
          ratePercent: definitions[key]!.ratePercent,
          compound: definitions[key]!.compound,
          taxableAmount: bases[key]!,
          taxAmount: amounts[key]!,
        ),
    ];
  }

  ErpMoney _sum(Iterable<ErpMoney> values, ErpCurrency currency) {
    var total = ErpMoney.zero(currency);
    for (final value in values) {
      total = total + value;
    }
    return total;
  }
}
