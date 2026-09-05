
import '../../domain/erp/erp.dart';

/// Debit/credit semantic side used by S14 financial presentation.
enum GeniusAccountingEntrySide {
  debit,
  credit,
}

/// Tax classification used by S14 tax breakdown reports.
enum GeniusAccountingTaxCategory {
  taxable,
  exempt,
  zeroRated,
}

/// Optional ledger carry policy.
///
/// [estimatedPageRows] inserts deterministic carried/brought-forward rows at
/// configured row boundaries. It is opt-in because exact page boundaries vary
/// with font metrics and wrapped content.
enum GeniusAccountingCarryPolicy {
  none,
  estimatedPageRows,
}

/// Chart-of-accounts node.
class GeniusAccountingAccount {
  const GeniusAccountingAccount({
    required this.code,
    required this.name,
    this.nameAr,
    this.parentCode,
    this.level = 0,
    this.normalSide = GeniusAccountingEntrySide.debit,
  }) : assert(level >= 0);

  final String code;
  final String name;
  final String? nameAr;
  final String? parentCode;
  final int level;
  final GeniusAccountingEntrySide normalSide;
}

/// One journal/ledger posting.
///
/// Debit and credit use the same currency and one side should normally be zero.
class GeniusAccountingPosting {
  const GeniusAccountingPosting({
    required this.date,
    required this.documentNumber,
    required this.account,
    required this.description,
    required this.debit,
    required this.credit,
    this.descriptionAr,
    this.partyId,
    this.partyName,
    this.partyNameAr,
    this.costCenter,
    this.project,
    this.reference,
    this.metadata = const {},
  });

  final DateTime date;
  final String documentNumber;
  final GeniusAccountingAccount account;
  final String description;
  final String? descriptionAr;
  final ErpMoney debit;
  final ErpMoney credit;
  final String? partyId;
  final String? partyName;
  final String? partyNameAr;
  final String? costCenter;
  final String? project;
  final String? reference;
  final Map<String, Object?> metadata;

  ErpCurrency get currency => debit.currency;

  ErpMoney get movement {
    _validateCurrency();
    return debit - credit;
  }

  void validate() {
    _validateCurrency();
    if (debit.isNegative || credit.isNegative) {
      throw ArgumentError(
        'Ledger debit/credit values must be non-negative. '
        'Use the opposite semantic side instead.',
      );
    }
    if (!debit.isZero && !credit.isZero) {
      throw ArgumentError(
        'A posting cannot have non-zero debit and credit simultaneously.',
      );
    }
  }

  void _validateCurrency() {
    if (debit.currency != credit.currency) {
      throw ArgumentError(
        'Posting debit and credit currencies must match.',
      );
    }
  }
}

/// Opening/movement/closing balance row.
class GeniusAccountingBalanceRow {
  const GeniusAccountingBalanceRow({
    required this.code,
    required this.name,
    required this.opening,
    required this.debit,
    required this.credit,
    required this.closing,
    this.nameAr,
    this.level = 0,
    this.isSubtotal = false,
  });

  final String code;
  final String name;
  final String? nameAr;
  final ErpMoney opening;
  final ErpMoney debit;
  final ErpMoney credit;
  final ErpMoney closing;
  final int level;
  final bool isSubtotal;
}

/// Bank/book reconciliation row.
class GeniusAccountingBankReconciliationLine {
  const GeniusAccountingBankReconciliationLine({
    required this.date,
    required this.reference,
    required this.description,
    required this.bookAmount,
    required this.statementAmount,
    this.descriptionAr,
    this.clearedDate,
  });

  final DateTime date;
  final String reference;
  final String description;
  final String? descriptionAr;
  final ErpMoney bookAmount;
  final ErpMoney statementAmount;
  final DateTime? clearedDate;

  ErpMoney get difference => bookAmount - statementAmount;
}

/// Tax record for VAT/Tax Summary and Tax Register.
class GeniusAccountingTaxRecord {
  const GeniusAccountingTaxRecord({
    required this.date,
    required this.documentNumber,
    required this.partyName,
    required this.netAmount,
    required this.taxAmount,
    required this.category,
    this.partyNameAr,
    this.taxCode = 'VAT',
    this.ratePercent = 0,
  });

  final DateTime date;
  final String documentNumber;
  final String partyName;
  final String? partyNameAr;
  final ErpMoney netAmount;
  final ErpMoney taxAmount;
  final GeniusAccountingTaxCategory category;
  final String taxCode;
  final double ratePercent;
}

/// Budget vs actual row.
class GeniusAccountingBudgetLine {
  const GeniusAccountingBudgetLine({
    required this.code,
    required this.name,
    required this.budget,
    required this.actual,
    this.nameAr,
    this.costCenter,
    this.project,
  });

  final String code;
  final String name;
  final String? nameAr;
  final ErpMoney budget;
  final ErpMoney actual;
  final String? costCenter;
  final String? project;

  ErpMoney get variance => actual - budget;
}

/// Multi-period amount used by comparison reports.
class GeniusAccountingPeriodAmount {
  const GeniusAccountingPeriodAmount({
    required this.accountCode,
    required this.accountName,
    required this.period,
    required this.amount,
    this.accountNameAr,
  });

  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final String period;
  final ErpMoney amount;
}

/// Reconciliation pair used by rounding/reconciliation report.
class GeniusAccountingReconciliationItem {
  const GeniusAccountingReconciliationItem({
    required this.label,
    required this.expected,
    required this.actual,
    this.labelAr,
  });

  final String label;
  final String? labelAr;
  final ErpMoney expected;
  final ErpMoney actual;

  ErpMoney get difference => actual - expected;
}

/// S14 formatting helpers for accounting presentation.
class GeniusAccountingFormat {
  const GeniusAccountingFormat._();

  /// Parentheses for negatives, dash for zero, fixed currency precision.
  static String accounting(ErpMoney value) {
    if (value.isZero) return '-';
    final absolute = value.abs().toDouble().toStringAsFixed(
          value.currency.precision,
        );
    return value.isNegative
        ? '($absolute ${value.currency.code})'
        : '$absolute ${value.currency.code}';
  }

  static String hierarchyLabel(
    GeniusAccountingAccount account, {
    bool isRtl = false,
  }) {
    final name =
        isRtl ? (account.nameAr ?? account.name) : account.name;
    final indent = List.filled(account.level, '  ').join();
    return '$indent${account.code} — $name';
  }
}
