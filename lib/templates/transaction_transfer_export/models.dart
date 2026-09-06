/// Shared data models for transaction-transfer exports.
///
/// Rendering code is intentionally not placed in this file. Both public PDF
/// templates import these models while owning their drawing implementation.
library;

import 'dart:ui';

/// Metadata displayed by transaction-transfer export documents.
class TransactionTransferDocumentMeta {
  /// Creates document metadata.
  const TransactionTransferDocumentMeta({
    required this.title,
    required this.issueDate,
    this.titleAr,
    this.exportingUserName,
    this.exportingUserNumber,
  });

  /// Report title used for LTR output.
  final String title;

  /// Optional Arabic report title used for RTL output.
  final String? titleAr;

  /// Date on which the exported report was issued.
  final DateTime issueDate;

  /// Optional display name of the exporting user.
  final String? exportingUserName;

  /// Optional identifier/number of the exporting user.
  final String? exportingUserNumber;
}

/// Directory information for an account referenced by a transfer row.
///
/// The source `transaction_transfer` JSON contains account IDs only. Callers
/// can optionally provide this model to display human-readable account names.
class TransactionTransferAccountInfo {
  /// Creates account directory information.
  const TransactionTransferAccountInfo({
    required this.accountId,
    required this.name,
    this.nameAr,
  });

  /// Account identifier used by `transaction_transfer.accountId`.
  final int accountId;

  /// Account name used in LTR output.
  final String name;

  /// Optional Arabic account name used in RTL output.
  final String? nameAr;

  /// Returns the best localized account name.
  String displayName({required bool isRtl}) =>
      isRtl ? (nameAr ?? name) : name;
}

/// Bilingual service metadata resolved from the services dataset.
class TransactionTransferServiceInfo {

  /// Creates service information from a row in the services JSON dataset.
  factory TransactionTransferServiceInfo.fromJson(Map<String, dynamic> json) {
    final description = _asMap(json['description']);
    final names = _asMap(description['names']);
    final id = _asInt(json['id']);
    final english = _asNullableString(names['en']);
    final arabic = _asNullableString(names['ar']);

    return TransactionTransferServiceInfo(
      serviceId: id,
      name: english ?? arabic ?? 'Service $id',
      nameAr: arabic,
      extensionSymbol: _asNullableString(description['extensionSymbol']),
    );
  }
  /// Creates service metadata.
  const TransactionTransferServiceInfo({
    required this.serviceId,
    required this.name,
    this.nameAr,
    this.extensionSymbol,
  });

  /// Service identifier matching `transaction_transfer.serviceId`.
  final int serviceId;

  /// English/default service name.
  final String name;

  /// Optional Arabic service name.
  final String? nameAr;

  /// Optional short service symbol from `description.extensionSymbol`.
  final String? extensionSymbol;

  /// Returns the best localized service name.
  String displayName({required bool isRtl}) =>
      isRtl ? (nameAr ?? name) : name;
}

/// Counter-account reference stored in `debitAccounts` or `creditAccounts`.
class TransactionTransferCounterAccount {

  /// Creates a counter-account reference from JSON.
  factory TransactionTransferCounterAccount.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionTransferCounterAccount(
      accountId: _asInt(json['accountId']),
      currencyId: _asString(json['currencyId']),
      amount: _asDouble(json['amount']).abs(),
    );
  }
  /// Creates a counter-account reference.
  const TransactionTransferCounterAccount({
    required this.accountId,
    required this.currencyId,
    required this.amount,
  });

  /// Referenced account identifier.
  final int accountId;

  /// Currency associated with the referenced amount.
  final String currencyId;

  /// Absolute/source amount from the reference object.
  final double amount;
}

/// Structured `description` object of a transaction-transfer row.
class TransactionTransferDescription {

  /// Creates a description from JSON.
  factory TransactionTransferDescription.fromJson(
    Map<String, dynamic> json,
  ) {
    List<TransactionTransferCounterAccount> readAccounts(String key) {
      final raw = json[key];
      if (raw is! List) return const <TransactionTransferCounterAccount>[];
      return raw
          .whereType<Map>()
          .map(
            (item) => TransactionTransferCounterAccount.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);
    }

    return TransactionTransferDescription(
      note: _asNullableString(json['note']),
      type: _asNullableString(json['type']),
      creatorDeviceId: _asNullableString(json['creatorDeviceId']),
      debitAccounts: readAccounts('debitAccounts'),
      creditAccounts: readAccounts('creditAccounts'),
    );
  }
  /// Creates a transfer-row description.
  const TransactionTransferDescription({
    this.note,
    this.type,
    this.creatorDeviceId,
    this.debitAccounts = const <TransactionTransferCounterAccount>[],
    this.creditAccounts = const <TransactionTransferCounterAccount>[],
  });

  /// Optional free-form transaction note.
  final String? note;

  /// Optional row type such as `commission`.
  final String? type;

  /// Optional source device identifier.
  final String? creatorDeviceId;

  /// Accounts referenced by the source `debitAccounts` array.
  final List<TransactionTransferCounterAccount> debitAccounts;

  /// Accounts referenced by the source `creditAccounts` array.
  final List<TransactionTransferCounterAccount> creditAccounts;

  /// Whether this row represents a commission leg.
  bool get isCommission => type?.toLowerCase() == 'commission';

  /// All referenced counterpart accounts without assuming which source array
  /// is authoritative for debit/credit direction.
  ///
  /// This deliberately preserves the source data because the sample includes
  /// rows where the `debitAccounts`/`creditAccounts` array does not reliably
  /// match the sign of the current row.
  List<TransactionTransferCounterAccount> get counterAccounts =>
      <TransactionTransferCounterAccount>[
        ...debitAccounts,
        ...creditAccounts,
      ];
}

/// One accounting leg from the `transaction_transfer` JSON dataset.
///
/// A transaction ID is not globally unique in the supplied data. Use
/// [compositeTransactionKey], which combines [serviceId] and [transactionId],
/// when grouping rows into logical transactions.
class TransactionTransferRow {

  /// Creates a transaction-transfer row from source JSON.
  factory TransactionTransferRow.fromJson(Map<String, dynamic> json) {
    return TransactionTransferRow(
      rowNo: _asNullableInt(json['rowNo']),
      tenantId: _asNullableInt(json['tenantId']),
      serviceId: _asInt(json['serviceId']),
      transactionId: _asInt(json['transactionId']),
      id: _asInt(json['id']),
      accountId: _asInt(json['accountId']),
      currencyId: _asString(json['currencyId']),
      amount: _asDouble(json['amount']),
      description: TransactionTransferDescription.fromJson(
        _asMap(json['description']),
      ),
      status: _asInt(json['status']),
      creatorUserId: _asInt(json['creatorUserId']),
      createdAt: _asDateTime(json['createdAt']),
      updatorUserId: _asNullableInt(json['updatorUserId']),
      updatedAt: _asNullableDateTime(json['updatedAt']),
    );
  }
  /// Creates a transaction-transfer row.
  const TransactionTransferRow({
    required this.serviceId,
    required this.transactionId,
    required this.id,
    required this.accountId,
    required this.currencyId,
    required this.amount,
    required this.description,
    required this.status,
    required this.creatorUserId,
    required this.createdAt,
    this.rowNo,
    this.tenantId,
    this.updatorUserId,
    this.updatedAt,
  });

  /// Optional source row number.
  final int? rowNo;

  /// Optional tenant identifier.
  final int? tenantId;

  /// Service that produced this accounting movement.
  final int serviceId;

  /// Transaction identifier scoped by [serviceId].
  final int transactionId;

  /// Line/leg identifier inside the source transaction.
  final int id;

  /// Account affected by this row.
  final int accountId;

  /// Currency code such as `YER`.
  final String currencyId;

  /// Signed source amount.
  ///
  /// The observed transaction-transfer schema uses positive amounts for debit
  /// movement and negative amounts for credit movement. Templates preserve
  /// that sign convention rather than deriving direction from description
  /// counter-account arrays.
  final double amount;

  /// Structured description and counter-account references.
  final TransactionTransferDescription description;

  /// Numeric source status.
  ///
  /// The source files do not define the semantic meaning of status codes, so
  /// templates display the number unless the caller supplies a label builder.
  final int status;

  /// User that created this row.
  final int creatorUserId;

  /// Source creation timestamp.
  final DateTime createdAt;

  /// Optional user that last updated this row.
  final int? updatorUserId;

  /// Optional source update timestamp.
  final DateTime? updatedAt;

  /// Composite logical transaction identity.
  String get compositeTransactionKey => '$serviceId:$transactionId';

  /// Debit amount represented by this row, or zero for a credit row.
  double get debitAmount => amount > 0 ? amount : 0;

  /// Credit amount represented by this row, or zero for a debit row.
  double get creditAmount => amount < 0 ? amount.abs() : 0;

  /// Whether this row is a debit movement according to the signed amount.
  bool get isDebit => amount > 0;

  /// Whether this row is a credit movement according to the signed amount.
  bool get isCredit => amount < 0;
}

/// Semantic colors for debit/credit amount cells.
class TransactionTransferAmountColors {
  /// Creates the default subtle accounting palette.
  const TransactionTransferAmountColors({
    this.debitBackground = const Color(0xFFEAF6F1),
    this.debitForeground = const Color(0xFF176B4D),
    this.creditBackground = const Color(0xFFFDF0F1),
    this.creditForeground = const Color(0xFF9B3041),
  });

  /// Subtle debit-cell background.
  final Color debitBackground;

  /// Debit amount foreground.
  final Color debitForeground;

  /// Subtle credit-cell background.
  final Color creditBackground;

  /// Credit amount foreground.
  final Color creditForeground;
}

/// Shared filters and rendering data configuration.
class TransactionTransferReportConfiguration {
  /// Creates report configuration.
  const TransactionTransferReportConfiguration({
    this.periodStart,
    this.periodEnd,
    this.selectedCurrency,
    this.serviceIds = const <int>{},
    this.statuses = const <int>{},
    this.includeCommission = true,
    this.showTotals = true,
    this.amountColors = const TransactionTransferAmountColors(),
  });

  /// Inclusive first calendar date of the report period.
  final DateTime? periodStart;

  /// Inclusive last calendar date of the report period.
  final DateTime? periodEnd;

  /// Optional selected currency. Null includes all currencies.
  final String? selectedCurrency;

  /// Optional allowed service IDs. Empty includes all services.
  final Set<int> serviceIds;

  /// Optional allowed numeric statuses. Empty includes all statuses.
  final Set<int> statuses;

  /// Whether rows with `description.type == commission` are included.
  final bool includeCommission;

  /// Whether currency total rows/summary totals are shown.
  final bool showTotals;

  /// Semantic debit and credit amount colors.
  final TransactionTransferAmountColors amountColors;

  /// Returns whether [row] belongs to this report configuration.
  bool includes(TransactionTransferRow row) {
    if (selectedCurrency != null &&
        selectedCurrency!.trim().isNotEmpty &&
        row.currencyId != selectedCurrency!.trim()) {
      return false;
    }
    if (serviceIds.isNotEmpty && !serviceIds.contains(row.serviceId)) {
      return false;
    }
    if (statuses.isNotEmpty && !statuses.contains(row.status)) {
      return false;
    }
    if (!includeCommission && row.description.isCommission) {
      return false;
    }

    final rowDate = DateTime(
      row.createdAt.year,
      row.createdAt.month,
      row.createdAt.day,
    );
    if (periodStart != null) {
      final start = DateTime(
        periodStart!.year,
        periodStart!.month,
        periodStart!.day,
      );
      if (rowDate.isBefore(start)) return false;
    }
    if (periodEnd != null) {
      final end = DateTime(
        periodEnd!.year,
        periodEnd!.month,
        periodEnd!.day,
      );
      if (rowDate.isAfter(end)) return false;
    }
    return true;
  }
}

/// Logical transaction assembled from accounting legs sharing service and
/// transaction IDs.
class TransactionTransferGroup {
  /// Creates an already-grouped transfer transaction.
  const TransactionTransferGroup({
    required this.serviceId,
    required this.transactionId,
    required this.rows,
    this.service,
  });

  /// Service identifier shared by [rows].
  final int serviceId;

  /// Transaction identifier shared by [rows].
  final int transactionId;

  /// Accounting legs belonging to this logical transaction.
  final List<TransactionTransferRow> rows;

  /// Optional bilingual service information.
  final TransactionTransferServiceInfo? service;

  /// Composite transaction key.
  String get key => '$serviceId:$transactionId';

  /// Earliest creation time among all accounting legs.
  DateTime get createdAt {
    var result = rows.first.createdAt;
    for (final row in rows.skip(1)) {
      if (row.createdAt.isBefore(result)) result = row.createdAt;
    }
    return result;
  }

  /// Latest available update timestamp, falling back to creation time.
  DateTime get updatedAt {
    var result = rows.first.updatedAt ?? rows.first.createdAt;
    for (final row in rows.skip(1)) {
      final candidate = row.updatedAt ?? row.createdAt;
      if (candidate.isAfter(result)) result = candidate;
    }
    return result;
  }

  /// Sorted currencies represented by this transaction.
  List<String> get currencies {
    final values = rows.map((row) => row.currencyId).toSet().toList()..sort();
    return values;
  }

  /// First non-empty note found on the transaction legs.
  String? get note {
    for (final row in rows) {
      final value = row.description.note?.trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  /// Shared status when all rows use the same code; otherwise null.
  int? get uniformStatus {
    if (rows.isEmpty) return null;
    final value = rows.first.status;
    return rows.every((row) => row.status == value) ? value : null;
  }

  /// Rows for one currency.
  List<TransactionTransferRow> rowsForCurrency(String currency) =>
      rows.where((row) => row.currencyId == currency).toList(growable: false);

  /// Debit total for one currency.
  double debitTotal(String currency) => rowsForCurrency(currency)
      .fold<double>(0, (sum, row) => sum + row.debitAmount);

  /// Credit total for one currency.
  double creditTotal(String currency) => rowsForCurrency(currency)
      .fold<double>(0, (sum, row) => sum + row.creditAmount);

  /// Debit minus credit for one currency.
  double difference(String currency) =>
      debitTotal(currency) - creditTotal(currency);

  /// Commission magnitude for one currency without double-counting the debit
  /// and credit legs of a balanced commission posting.
  double commissionAmount(String currency) {
    final commissionRows = rowsForCurrency(currency)
        .where((row) => row.description.isCommission);
    final debit = commissionRows.fold<double>(
      0,
      (sum, row) => sum + row.debitAmount,
    );
    final credit = commissionRows.fold<double>(
      0,
      (sum, row) => sum + row.creditAmount,
    );
    return debit > credit ? debit : credit;
  }

  /// Groups [source] by the composite `(serviceId, transactionId)` identity.
  static List<TransactionTransferGroup> groupRows(
    Iterable<TransactionTransferRow> source, {
    Map<int, TransactionTransferServiceInfo> services =
        const <int, TransactionTransferServiceInfo>{},
  }) {
    final grouped = <String, List<TransactionTransferRow>>{};
    for (final row in source) {
      grouped.putIfAbsent(
        row.compositeTransactionKey,
        () => <TransactionTransferRow>[],
      ).add(row);
    }

    final result = grouped.values.map((rows) {
      final first = rows.first;
      return TransactionTransferGroup(
        serviceId: first.serviceId,
        transactionId: first.transactionId,
        rows: List<TransactionTransferRow>.unmodifiable(rows),
        service: services[first.serviceId],
      );
    }).toList();

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }
}

/// JSON parsing helpers for transaction-transfer and service datasets.
abstract final class TransactionTransferJsonData {
  /// Parses a decoded JSON array into transaction-transfer rows.
  static List<TransactionTransferRow> rowsFromJson(Object? json) {
    if (json is! List) {
      throw const FormatException(
        'transaction_transfer JSON must be a top-level array.',
      );
    }
    return json
        .whereType<Map>()
        .map(
          (item) => TransactionTransferRow.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);
  }

  /// Parses a decoded services JSON array into a service-ID lookup.
  static Map<int, TransactionTransferServiceInfo> servicesFromJson(
    Object? json,
  ) {
    if (json is! List) {
      throw const FormatException('services JSON must be a top-level array.');
    }
    final result = <int, TransactionTransferServiceInfo>{};
    for (final item in json.whereType<Map>()) {
      final service = TransactionTransferServiceInfo.fromJson(
        Map<String, dynamic>.from(item),
      );
      result[service.serviceId] = service;
    }
    return result;
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

String _asString(Object? value) {
  if (value == null) return '';
  return value.toString();
}

String? _asNullableString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}

int? _asNullableInt(Object? value) {
  if (value == null) return null;
  return _asInt(value);
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}

DateTime _asDateTime(Object? value) {
  if (value is DateTime) return value;
  return DateTime.parse(value.toString());
}

DateTime? _asNullableDateTime(Object? value) {
  if (value == null) return null;
  return _asDateTime(value);
}
