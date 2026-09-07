import 'dart:ui';

import '../../src/presentation/document/components/components.dart';

/// Controls whether PDF account activity is summarized or transaction-level.
enum AccountExportActivityMode {
  /// Shows opening balance, debit, credit, net movement, and closing balance.
  summary,

  /// Shows summary information plus transaction rows.
  detailed,
}

/// Defines optional grouping for multi-account exports.
enum AccountExportGrouping {
  /// Renders accounts without group sections.
  none,

  /// Groups accounts by [AccountExportAccount.group].
  accountGroup,

  /// Groups accounts by parent account.
  parentAccount,
}

/// Describes the accounting nature of a balance or account.
enum AccountBalanceNature {
  /// Debit nature.
  debit,

  /// Credit nature.
  credit,
}

/// Shared document metadata used by all account export templates.
class AccountExportDocumentMeta {
  /// Creates document metadata.
  const AccountExportDocumentMeta({
    required this.title,
    required this.issueDate,
    this.titleAr,
    this.exportingUserNumber,
    this.exportingUserName,
  });

  /// Document title used in LTR output.
  final String title;

  /// Optional Arabic document title used in RTL output.
  final String? titleAr;

  /// Date shown as the issue/export date.
  final DateTime issueDate;

  /// Optional number or identifier of the user that exported the document.
  final String? exportingUserNumber;

  /// Optional display name of the user that exported the document.
  ///
  /// Account-export templates may use this value in report headers and
  /// repeating footers where user attribution is enabled.
  final String? exportingUserName;
}

/// Controls which optional account fields are rendered.
///
/// Required fields of a template are rendered even when the corresponding
/// property in this object is `false`.
class AccountExportFieldVisibility {
  /// Creates a field-visibility configuration.
  const AccountExportFieldVisibility({
    this.parentAccountNumber = false,
    this.parentAccountName = true,
    this.group = true,
    this.accountNature = true,
    this.mobileNumber = false,
    this.personalId = false,
    this.currency = true,
  });

  /// Recommended defaults for a single-account PDF.
  static const singlePdf = AccountExportFieldVisibility(
    parentAccountName: true,
    group: true,
    accountNature: true,
    mobileNumber: true,
    personalId: true,
  );

  /// Recommended defaults for a multi-account PDF.
  static const multiPdf = AccountExportFieldVisibility(
    parentAccountNumber: true,
    parentAccountName: true,
    group: true,
    accountNature: true,
    mobileNumber: false,
    personalId: false,
  );

  /// Compact defaults for a single-account image.
  static const singleImage = AccountExportFieldVisibility(
    parentAccountName: true,
    group: true,
    accountNature: true,
  );

  /// Compact defaults for a multi-account image.
  static const multiImage = AccountExportFieldVisibility(
    parentAccountName: true,
    group: true,
    accountNature: false,
  );

  /// Whether the parent account number is shown when available.
  final bool parentAccountNumber;

  /// Whether the parent account name is shown when available.
  final bool parentAccountName;

  /// Whether the account group is shown when available.
  final bool group;

  /// Whether the account nature is shown when available.
  final bool accountNature;

  /// Whether the mobile number is shown when available.
  final bool mobileNumber;

  /// Whether the personal ID is shown when available.
  final bool personalId;

  /// Whether the currency code is shown where a compact layout can hide it.
  final bool currency;
}

/// Semantic colors used for debit and credit amount cells.
///
/// The palette is shared as configuration data only. Each account-export
/// template owns its own rendering helpers and decides how these colors are
/// applied to its cells.
class AccountExportAmountColors {
  /// Creates an amount color palette.
  const AccountExportAmountColors({
    this.debitBackground = const Color(0xFFEAF6F1),
    this.debitForeground = const Color(0xFF176B4D),
    this.creditBackground = const Color(0xFFFDF0F1),
    this.creditForeground = const Color(0xFF9B3041),
  });

  /// Subtle background for debit amount cells.
  final Color debitBackground;

  /// Foreground used for debit amount text.
  final Color debitForeground;

  /// Subtle background for credit amount cells.
  final Color creditBackground;

  /// Foreground used for credit amount text.
  final Color creditForeground;
}

/// Shared behavior configuration for account exports.
///
/// PDF templates support both [AccountExportActivityMode] values. Image
/// templates require [activityMode] to be [AccountExportActivityMode.summary].
class AccountExportConfiguration {
  /// Creates a reusable account-export configuration.
  const AccountExportConfiguration({
    this.fields = AccountExportFieldVisibility.singlePdf,
    this.periodStart,
    this.periodEnd,
    this.selectedCurrency,
    this.showBalances = true,
    this.showActivity = true,
    this.activityMode = AccountExportActivityMode.summary,
    this.grouping = AccountExportGrouping.none,
    this.showTotals = true,
    this.amountColors = const AccountExportAmountColors(),
  });

  /// Optional field visibility.
  final AccountExportFieldVisibility fields;

  /// Optional start date used to label/filter the selected activity period.
  final DateTime? periodStart;

  /// Optional end date used to label/filter the selected activity period.
  final DateTime? periodEnd;

  /// Currency selected for summaries and multi-account balance columns.
  ///
  /// A null value lets single-account PDF output show all supplied currencies.
  final String? selectedCurrency;

  /// Whether balance information is rendered.
  final bool showBalances;

  /// Whether activity information is rendered.
  final bool showActivity;

  /// Summary or detailed activity mode.
  final AccountExportActivityMode activityMode;

  /// Optional grouping mode used by multi-account PDF exports.
  final AccountExportGrouping grouping;

  /// Whether subtotal/grand-total rows are rendered where supported.
  final bool showTotals;

  /// Semantic debit/credit colors applied to amount cells.
  final AccountExportAmountColors amountColors;

  /// Returns a copy with selected values replaced.
  AccountExportConfiguration copyWith({
    AccountExportFieldVisibility? fields,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? selectedCurrency,
    bool? showBalances,
    bool? showActivity,
    AccountExportActivityMode? activityMode,
    AccountExportGrouping? grouping,
    bool? showTotals,
    AccountExportAmountColors? amountColors,
  }) {
    return AccountExportConfiguration(
      fields: fields ?? this.fields,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      showBalances: showBalances ?? this.showBalances,
      showActivity: showActivity ?? this.showActivity,
      activityMode: activityMode ?? this.activityMode,
      grouping: grouping ?? this.grouping,
      showTotals: showTotals ?? this.showTotals,
      amountColors: amountColors ?? this.amountColors,
    );
  }
}

/// A currency-specific account balance.
class AccountCurrencyBalance {
  /// Creates a balance entry.
  const AccountCurrencyBalance({
    required this.currency,
    required this.amount,
    required this.nature,
  });

  /// ISO/code-like currency label, for example `YER`, `USD`, or `SAR`.
  final String currency;

  /// Absolute balance amount.
  final double amount;

  /// Debit/credit nature of [amount].
  final AccountBalanceNature nature;

  /// Signed value useful for net totals: debit is positive, credit is negative.
  double get signedAmount =>
      nature == AccountBalanceNature.debit ? amount : -amount;
}

/// Summary activity for one account and one currency.
class AccountActivitySummary {
  /// Creates account activity summary data.
  const AccountActivitySummary({
    required this.currency,
    required this.periodStart,
    required this.periodEnd,
    required this.openingBalance,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });

  /// Currency represented by this summary.
  final String currency;

  /// First date of the summary period.
  final DateTime periodStart;

  /// Last date of the summary period.
  final DateTime periodEnd;

  /// Balance before activity in the selected period.
  final double openingBalance;

  /// Sum of debit movement in the selected period.
  final double totalDebit;

  /// Sum of credit movement in the selected period.
  final double totalCredit;

  /// Balance after activity in the selected period.
  final double closingBalance;

  /// Debit movement minus credit movement.
  double get netMovement => totalDebit - totalCredit;
}

/// Transaction row used by detailed PDF account activity.
class AccountExportTransaction {
  /// Creates a transaction row.
  const AccountExportTransaction({
    required this.transactionNumber,
    required this.date,
    required this.type,
    required this.description,
    required this.currency,
    required this.balanceAfterTransaction,
    this.typeAr,
    this.descriptionAr,
    this.debit = 0,
    this.credit = 0,
  });

  /// Transaction/reference number.
  final String transactionNumber;

  /// Transaction date.
  final DateTime date;

  /// Transaction type in the default language.
  final String type;

  /// Optional Arabic transaction type.
  final String? typeAr;

  /// Transaction description in the default language.
  final String description;

  /// Optional Arabic transaction description.
  final String? descriptionAr;

  /// Transaction currency.
  final String currency;

  /// Debit amount; zero means no debit movement.
  final double debit;

  /// Credit amount; zero means no credit movement.
  final double credit;

  /// Running balance after the transaction.
  final double balanceAfterTransaction;

  /// Returns the localized transaction type.
  String displayType({required bool isRtl}) =>
      isRtl ? (typeAr ?? type) : type;

  /// Returns the localized transaction description.
  String displayDescription({required bool isRtl}) =>
      isRtl ? (descriptionAr ?? description) : description;
}

/// Complete account data shared by all four export templates.
class AccountExportAccount {
  /// Creates an account export model.
  const AccountExportAccount({
    required this.accountNumber,
    required this.accountName,
    this.accountNameAr,
    this.parentAccountNumber,
    this.parentAccountName,
    this.parentAccountNameAr,
    this.group,
    this.groupAr,
    this.nature,
    this.mobileNumber,
    this.personalId,
    this.lastTransactionDate,
    this.balances = const <AccountCurrencyBalance>[],
    this.activitySummaries = const <AccountActivitySummary>[],
    this.transactions = const <AccountExportTransaction>[],
  });

  /// Account number/code.
  final String accountNumber;

  /// Account name in the default language.
  final String accountName;

  /// Optional Arabic account name.
  final String? accountNameAr;

  /// Optional parent account number.
  final String? parentAccountNumber;

  /// Optional parent account name in the default language.
  final String? parentAccountName;

  /// Optional Arabic parent account name.
  final String? parentAccountNameAr;

  /// Optional account group in the default language.
  final String? group;

  /// Optional Arabic account group.
  final String? groupAr;

  /// Optional accounting nature.
  final AccountBalanceNature? nature;

  /// Optional mobile number associated with the account.
  final String? mobileNumber;

  /// Optional personal/customer ID associated with the account.
  final String? personalId;

  /// Most recent known accounting transaction date for this account.
  ///
  /// Multi-account exports use this value when supplied. If it is null, a
  /// template may fall back to the latest date available in [transactions].
  /// This allows summary exports to show the last-operation date without
  /// requiring all detailed ledger rows to be loaded.
  final DateTime? lastTransactionDate;

  /// Currency balances. A single account may contain several currencies.
  final List<AccountCurrencyBalance> balances;

  /// Currency-specific activity summaries.
  final List<AccountActivitySummary> activitySummaries;

  /// Detailed transactions used only by PDF detailed activity.
  final List<AccountExportTransaction> transactions;

  /// Returns a localized account name.
  String displayName({required bool isRtl}) =>
      isRtl ? (accountNameAr ?? accountName) : accountName;

  /// Returns a localized parent account name when available.
  String? displayParentName({required bool isRtl}) => isRtl
      ? (parentAccountNameAr ?? parentAccountName)
      : parentAccountName;

  /// Returns a localized group name when available.
  String? displayGroup({required bool isRtl}) =>
      isRtl ? (groupAr ?? group) : group;

  /// Finds the balance for [currency], or the first balance when null.
  AccountCurrencyBalance? balanceFor(String? currency) {
    if (balances.isEmpty) return null;
    if (currency == null) return balances.first;
    for (final balance in balances) {
      if (balance.currency == currency) return balance;
    }
    return null;
  }

  /// Finds the activity summary for [currency], or the first summary when null.
  AccountActivitySummary? summaryFor(String? currency) {
    if (activitySummaries.isEmpty) return null;
    if (currency == null) return activitySummaries.first;
    for (final summary in activitySummaries) {
      if (summary.currency == currency) return summary;
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
// Reusable/customizable export API
// ---------------------------------------------------------------------------

/// Identifies a labeled-value section that can be customized by an account
/// export consumer.
enum AccountExportDetailSection {
  /// Report-level metadata such as period, currency, and account count.
  report,

  /// Account identity/details such as number, name, parent, and group.
  account,

  /// Currency-specific balance details.
  currency,
}

/// Identifies a grid owned by an account-export template.
enum AccountExportGridKind {
  /// Currency/activity summary grid.
  activitySummary,

  /// Detailed transaction grid for one account.
  transactions,

  /// Multi-account grid used by PDF exports.
  accounts,

  /// Compact multi-account grid used by image exports.
  compactAccounts,
}

/// Rewrites the default labeled values for a template section.
typedef AccountExportDetailsBuilder = List<GeniusPdfLabeledValue> Function(
  AccountExportDetailSection section,
  List<GeniusPdfLabeledValue> defaultItems,
);

/// Rewrites, removes, reorders, or adds columns for an account-export grid.
typedef AccountExportColumnsBuilder = List<GeniusPdfGridColumn> Function(
  AccountExportGridKind kind,
  List<GeniusPdfGridColumn> defaultColumns,
);

/// Rewrites a generated grid row.
///
/// [source] is the domain object that produced the row when one exists, such
/// as [AccountExportAccount] or [AccountExportTransaction]. Total/group rows
/// can pass another useful source object or `null`.
typedef AccountExportRowBuilder = GeniusPdfGridRow Function(
  AccountExportGridKind kind,
  Object? source,
  GeniusPdfGridRow defaultRow,
);

/// Formats a date used by surrounding report metadata.
typedef AccountExportDateFormatter = String Function(DateTime value);

/// Formats an amount used in non-grid text.
typedef AccountExportAmountFormatter = String Function(
  double value,
  String? currency,
);

/// Presentation and extension hooks shared by the four account-export
/// templates.
///
/// Defaults preserve the package's current rendering. Consumers can opt into
/// only the hooks they need; no subclassing is required.
class AccountExportCustomization {
  /// Creates account-export presentation/customization settings.
  const AccountExportCustomization({
    this.headerLayout = GeniusPdfReportHeaderLayout.bilingualSplit,
    this.headerStyle,
    this.infoBoxStyle,
    this.gridStyle = const GeniusPdfGridStyle.classic(),
    this.reportDetailsColumns = 3,
    this.accountDetailsColumns = 3,
    this.showFooter = true,
    this.pageNumberFormat = '{0}/{1}',
    this.dateFormatter,
    this.amountFormatter,
    this.detailsBuilder,
    this.columnsBuilder,
    this.rowBuilder,
  })  : assert(reportDetailsColumns > 0),
        assert(accountDetailsColumns > 0);

  /// Layout used by [GeniusPdfReportHeader].
  final GeniusPdfReportHeaderLayout headerLayout;

  /// Optional header style. Null preserves the template's bilingual style.
  final GeniusPdfReportHeaderStyle? headerStyle;

  /// Optional details-box style. Null preserves `minimal()`.
  final GeniusPdfInfoBoxStyle? infoBoxStyle;

  /// Grid style used by generated account-export tables.
  final GeniusPdfGridStyle gridStyle;

  /// Number of columns used by report-level details boxes.
  final int reportDetailsColumns;

  /// Number of columns used by account/currency detail boxes.
  final int accountDetailsColumns;

  /// Whether templates should install their standard repeating footer.
  final bool showFooter;

  /// Page-number format passed to the package footer helper.
  final String pageNumberFormat;

  /// Optional surrounding-report date formatter.
  final AccountExportDateFormatter? dateFormatter;

  /// Optional non-grid amount formatter.
  final AccountExportAmountFormatter? amountFormatter;

  /// Optional labeled-value section transformer.
  final AccountExportDetailsBuilder? detailsBuilder;

  /// Optional grid-column transformer.
  final AccountExportColumnsBuilder? columnsBuilder;

  /// Optional generated-row transformer.
  final AccountExportRowBuilder? rowBuilder;

  /// Resolves the effective details style.
  GeniusPdfInfoBoxStyle get effectiveInfoBoxStyle =>
      infoBoxStyle ?? GeniusPdfInfoBoxStyle.minimal();

  /// Formats [value] using [dateFormatter] or the package-friendly ISO date.
  String formatDate(DateTime value) {
    final custom = dateFormatter;
    if (custom != null) return custom(value);
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }

  /// Formats [value] for text outside data-grid currency cells.
  String formatAmount(double value, [String? currency]) {
    final custom = amountFormatter;
    if (custom != null) return custom(value, currency);
    return value.toStringAsFixed(2);
  }

  /// Applies [detailsBuilder] while protecting the template's default list.
  List<GeniusPdfLabeledValue> buildDetails(
    AccountExportDetailSection section,
    List<GeniusPdfLabeledValue> defaultItems,
  ) {
    final builder = detailsBuilder;
    if (builder == null) return defaultItems;
    return builder(section, List<GeniusPdfLabeledValue>.of(defaultItems));
  }

  /// Applies [columnsBuilder] to a copy of the default columns.
  List<GeniusPdfGridColumn> buildColumns(
    AccountExportGridKind kind,
    List<GeniusPdfGridColumn> defaultColumns,
  ) {
    final builder = columnsBuilder;
    if (builder == null) return defaultColumns;
    return builder(kind, List<GeniusPdfGridColumn>.of(defaultColumns));
  }

  /// Applies [rowBuilder] to a generated row.
  GeniusPdfGridRow buildRow(
    AccountExportGridKind kind,
    Object? source,
    GeniusPdfGridRow defaultRow,
  ) {
    return rowBuilder?.call(kind, source, defaultRow) ?? defaultRow;
  }
}

