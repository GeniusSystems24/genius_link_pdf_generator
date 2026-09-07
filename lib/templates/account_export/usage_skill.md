# Account Export Usage Skill

## Purpose

Use the templates in `lib/templates/account_export` to export account master data,
balances, account activity, and compact image-ready account reports.

The four rendering templates remain independent. They share domain/configuration
models from `models.dart`, but they do not call each other's rendering helpers.
This makes each document safe to evolve or customize without changing another
account-export layout.

## Templates

- `SingleAccountPdf`: one account, one or more currencies, summary or detailed
  activity.
- `MultiAccountPdf`: many accounts, optional grouping/totals, summary-level
  debit/credit movement.
- `SingleAccountImage`: compact one-account, one-currency, summary-only image
  source.
- `MultiAccountImage`: compact multi-account, one-currency, summary-only image
  source; split large lists with `MultiAccountImage.split`.

## Shared models

Prefer these reusable models instead of passing loosely structured maps:

- `AccountExportDocumentMeta`
- `AccountExportAccount`
- `AccountCurrencyBalance`
- `AccountActivitySummary`
- `AccountExportTransaction`
- `AccountExportConfiguration`
- `AccountExportFieldVisibility`
- `AccountExportAmountColors`
- `AccountExportCustomization`

## Basic usage

```dart
final report = SingleAccountPdf(
  config: pdfConfig,
  meta: AccountExportDocumentMeta(
    title: 'Account Statement',
    titleAr: 'كشف حساب',
    issueDate: DateTime.now(),
    exportingUserName: 'Ahmed',
  ),
  account: account,
  configuration: AccountExportConfiguration(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    activityMode: AccountExportActivityMode.detailed,
  ),
);
```

## Customization without forking a template

Pass `AccountExportCustomization` when the application needs presentation or
extension changes while retaining the package's document flow.

```dart
final customization = AccountExportCustomization(
  headerLayout: GeniusPdfReportHeaderLayout.compact,
  gridStyle: const GeniusPdfGridStyle.classic(
    primaryColor: Color(0xFF263238),
  ),
  reportDetailsColumns: 2,
  accountDetailsColumns: 2,
  dateFormatter: (date) => '${date.day}/${date.month}/${date.year}',
  amountFormatter: (value, currency) => value.toStringAsFixed(3),
  columnsBuilder: (kind, columns) {
    if (kind != AccountExportGridKind.transactions) return columns;
    return columns.where((column) => column.id != 'type').toList();
  },
  rowBuilder: (kind, source, row) {
    if (kind != AccountExportGridKind.transactions) return row;
    return GeniusPdfGridRow(
      cells: <String, dynamic>{
        ...row.cells,
        'description': '[ERP] ${row.cells['description'] ?? ''}',
      },
      style: row.style,
    );
  },
);
```

Then pass it to any of the four account templates:

```dart
final report = MultiAccountPdf(
  config: pdfConfig,
  meta: meta,
  accounts: accounts,
  customization: customization,
);
```

### Details builder

`detailsBuilder` can add, remove, or reorder labeled values without editing the
rendering file.

```dart
detailsBuilder: (section, items) {
  if (section == AccountExportDetailSection.report) {
    return <GeniusPdfLabeledValue>[
      ...items,
      GeniusPdfLabeledValue(
        config: pdfConfig,
        label: 'Branch',
        labelAr: 'الفرع',
        value: 'HQ',
      ),
    ];
  }
  return items;
},
```

### Column and row hooks

Use `columnsBuilder` for structural grid changes and `rowBuilder` for data/style
changes. Column IDs used by the default templates are part of the relevant
rendering file; inspect that template before removing a column required by a
total row.

Do not share private rendering helpers between the four templates. If a new
business concept is common to multiple templates, add a model/configuration API
to `models.dart`; keep drawing code local to each template.

## Multi-currency rules

`SingleAccountPdf` can render all supplied currencies when
`selectedCurrency == null`. Currency sections remain separate.

Image templates are intentionally compact and require one selected currency
when balances/activity are visible. Do not emulate detailed transaction pages
inside image templates.

## Debit and credit semantics

Use `AccountExportAmountColors` to change semantic colors. Debit and credit
styles must remain visually distinct but subtle, and styling belongs to amount
cells as well as totals.

## Grouping

`MultiAccountPdf` supports:

- `AccountExportGrouping.none`
- `AccountExportGrouping.accountGroup`
- `AccountExportGrouping.parentAccount`

`showTotals` controls group/grand totals. Keep group names visible in their total
rows when customizing columns.

## Image splitting

Never pass an unbounded account list to `MultiAccountImage`. Use:

```dart
final pages = MultiAccountImage.split(
  config: pdfConfig,
  meta: meta,
  accounts: accounts,
  configuration: imageConfiguration,
  maxAccountsPerImage: 10,
);
```

Rasterize the generated PDF source pages with the package's existing
`PdfDocument.exportToImages(...)` flow.

## QR, notes, footer, RTL/LTR

The templates already support QR and notes. `AccountExportCustomization` can
turn the standard repeating footer off when the caller needs to provide a
higher-level document wrapper. Do not add duplicated footer or rasterization
implementations.

Always test custom columns and custom text in both RTL and LTR configurations.
