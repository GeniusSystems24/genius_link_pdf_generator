import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';


// BEGIN ACCOUNT EXPORT LOCAL RENDERING HELPERS
GeniusPdfCellStyle _debitCellStyle(AccountExportAmountColors colors) {
  return GeniusPdfCellStyle(
    textStyle: GeniusPdfTextStyle(
      fontSize: 8.5,
      color: colors.debitForeground,
      alignment: GeniusPdfTextAlign.end,
    ),
    backgroundColor: colors.debitBackground,
    padding: const GeniusPdfCellPadding.symmetric(horizontal: 5, vertical: 4),
  );
}

GeniusPdfCellStyle _creditCellStyle(AccountExportAmountColors colors) {
  return GeniusPdfCellStyle(
    textStyle: GeniusPdfTextStyle(
      fontSize: 8.5,
      color: colors.creditForeground,
      alignment: GeniusPdfTextAlign.end,
    ),
    backgroundColor: colors.creditBackground,
    padding: const GeniusPdfCellPadding.symmetric(horizontal: 5, vertical: 4),
  );
}

GeniusPdfGridColumn _debitColumn(
  AccountExportAmountColors colors, {
  String id = 'debit',
  double width = 72,
}) {
  return GeniusPdfGridColumn.currency(
    id: id,
    title: 'Debit',
    titleAr: 'مدين',
    width: width,
    currencySymbol: '',
    cellStyle: _debitCellStyle(colors),
  );
}

GeniusPdfGridColumn _creditColumn(
  AccountExportAmountColors colors, {
  String id = 'credit',
  double width = 72,
}) {
  return GeniusPdfGridColumn.currency(
    id: id,
    title: 'Credit',
    titleAr: 'دائن',
    width: width,
    currencySymbol: '',
    cellStyle: _creditCellStyle(colors),
  );
}

String _nature(AccountBalanceNature? nature, bool isRtl) {
  return switch (nature) {
    AccountBalanceNature.debit => isRtl ? 'مدين' : 'Debit',
    AccountBalanceNature.credit => isRtl ? 'دائن' : 'Credit',
    null => '-',
  };
}

extension _AccountExportDocumentBuilderSupport on GeniusPdfDocumentBuilder {
  void _drawGrid(
    List<GeniusPdfGridColumn> columns,
    List<GeniusPdfGridRow> rows, {
    double spacing = 10,
    GeniusPdfGridStyle style = const GeniusPdfGridStyle.classic(),
  }) {
    if (rows.isEmpty) return;
    final result = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: style,
    ).drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );
    if (result != null) updateFromLayoutResult(result, spacing: spacing);
  }

  void _drawSectionTitle(String title, String titleAr) {
    addSpace(4);
    addLine(
      config.isRTL ? titleAr : title,
      font: config.boldFont,
      topMargin: 4,
    );
    addSpace(7);
  }
}
// END ACCOUNT EXPORT LOCAL RENDERING HELPERS

/// Structured landscape PDF export for multiple accounts.
///
/// The document starts with a bilingual split report header and a compact
/// three-column report-information box. The account grid can be grouped by
/// account group or parent account and includes the most recent known
/// transaction date for each account.
///
/// Account activity remains summarized in the main account grid through
/// Debit/Credit movement columns. Per-account detailed transaction grids
/// are intentionally not appended by this template.
///
/// Notes and the QR reference follow the same layout approach used by
/// `TrialBalanceTemplate`: when both sections are enabled, notes and QR are
/// rendered side by side with [GeniusPdfQRCodeGenerator.url].
///
/// Example:
/// ```dart
/// final report = MultiAccountPdf(
///   config: pdfConfig,
///   meta: AccountExportDocumentMeta(
///     title: 'Accounts Report',
///     titleAr: 'تقرير الحسابات',
///     issueDate: DateTime(2026, 9, 6),
///   ),
///   accounts: accounts,
///   reportId: 'MULTI-ACC-20260906-001',
///   configuration: AccountExportConfiguration(
///     periodStart: DateTime(2026, 8, 1),
///     periodEnd: DateTime(2026, 8, 31),
///     selectedCurrency: 'YER',
///     grouping: AccountExportGrouping.accountGroup,
///   ),
/// );
/// ```
class MultiAccountPdf extends GeniusErpRegisterDocument {
  /// Creates a landscape multi-account PDF template.
  ///
  /// [reportId] is shown with the QR section when [showQRCode] is true.
  /// [qrCodeUrl] can override the default report verification URL encoded in
  /// the QR code.
  MultiAccountPdf({
    required GeniusPdfConfig config,
    required this.meta,
    required this.accounts,
    this.company,
    this.configuration = const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.multiPdf,
    ),
    this.customization = const AccountExportCustomization(),
    this.reportId,
    this.qrCodeUrl,
    this.showQRCode = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(
          config.copyWith(
            orientation: PdfPageOrientation.landscape,
          ),
        );

  /// Document title, issue date, and exporting-user metadata.
  final AccountExportDocumentMeta meta;

  /// Accounts rendered by the document.
  final List<AccountExportAccount> accounts;

  /// Optional company information for the bilingual report header.
  final GeniusPdfCompanyInfo? company;

  /// Shared visibility, period, currency, grouping, and activity configuration.
  final AccountExportConfiguration configuration;

  /// Reusable presentation and extension hooks for this template.
  final AccountExportCustomization customization;

  /// Stable report/export identifier displayed above the QR code.
  final String? reportId;

  /// Optional absolute URL encoded by the QR code.
  ///
  /// When null, the template uses
  /// `https://localhost:443/report/<reportId>`, matching the current
  /// trial-balance example behavior.
  final String? qrCodeUrl;

  /// Whether to render the QR reference section.
  final bool showQRCode;

  /// Whether to render the report notes section.
  final bool showNotes;

  /// Optional LTR report notes.
  final String? notes;

  /// Optional Arabic report notes.
  final String? notesAr;

  /// Builds the report-information box, account grid, grouped totals,
  /// and report notes/QR section.
  ///
  /// Account activity is intentionally kept at summary level in the main grid;
  /// this template does not append per-account detailed transaction tables.
  @override
  void build() {
    if (customization.showFooter) _addRepeatingFooter();

    newPage();
    _drawHeader();
    _drawReportDetails();
    _drawAccountsTable();
    _drawFooterSection();
  }

  void _addRepeatingFooter() {
    addFooter(
      userName: _footerUserName(),
      userLabel: config.isRTL ? 'المستخدم: ' : 'User: ',
      printTime: _footerIssueDate(),
      showPageNumber: true,
      pageNumberFormat: customization.pageNumberFormat,
    );
  }

  String _footerUserName() {
    final name = meta.exportingUserName?.trim();
    if (name != null && name.isNotEmpty) return name;

    // Keep a useful fallback for older callers that only supplied a user No.
    final number = meta.exportingUserNumber?.trim();
    if (number != null && number.isNotEmpty) return number;

    return config.isRTL ? 'غير محدد' : 'Not specified';
  }

  String _footerIssueDate() {
    final value = customization.formatDate(meta.issueDate);
    return config.isRTL ? 'تاريخ الإصدار: $value' : 'Issue date: $value';
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: meta.title,
      titleAr: meta.titleAr ?? meta.title,
      company: company,
      printDate: meta.issueDate,
      config: config,
      style: const GeniusPdfReportHeaderStyle.classic(),
      layout: customization.headerLayout,
      showCompanyInfo: company != null,
      showBilingualTitle: true,
      customFields: <String, String>{
        if (meta.exportingUserName?.trim().isNotEmpty ?? false)
          'Exported by / المصدّر بواسطة': meta.exportingUserName!.trim(),
        if (meta.exportingUserNumber?.trim().isNotEmpty ?? false)
          'User No. / رقم المستخدم': meta.exportingUserNumber!.trim(),
      },
    );

    final height = header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 116),
    );
    addSpace(height + 12);
  }

  void _drawReportDetails() {
    final currencies = _reportCurrencies();
    final values = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Report Name',
        labelAr: 'اسم التقرير',
        value: config.isRTL ? (meta.titleAr ?? meta.title) : meta.title,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Report Period',
        labelAr: 'فترة التقرير',
        value: _reportPeriodLabel(),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Report Currencies',
        labelAr: 'عملات التقرير',
        value: currencies.isEmpty ? '-' : currencies.join(', '),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Account Count',
        labelAr: 'عدد الحسابات',
        value: '${accounts.length}',
      ),
    ];

    final detailItems = customization.buildDetails(
      AccountExportDetailSection.report,
      values,
    );

    final box = GeniusPdfInfoBox(
      config: config,
      title: 'Report Details',
      titleAr: 'تفاصيل التقرير',
      items: detailItems,
      columns: customization.reportDetailsColumns,
      columnSpacing: 14,
      style: customization.effectiveInfoBoxStyle,
    );

    final result = box.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 96),
    );
    addSpace(result.height + 12);
  }

  String _reportPeriodLabel() {
    final start = configuration.periodStart;
    final end = configuration.periodEnd;

    if (start != null && end != null) {
      return '${customization.formatDate(start)} — ${customization.formatDate(end)}';
    }
    if (start != null) {
      return config.isRTL ? 'من ${customization.formatDate(start)}' : 'From ${customization.formatDate(start)}';
    }
    if (end != null) {
      return config.isRTL ? 'حتى ${customization.formatDate(end)}' : 'Through ${customization.formatDate(end)}';
    }
    return config.isRTL ? 'جميع الفترات' : 'All dates';
  }

  List<String> _reportCurrencies() {
    final selected = configuration.selectedCurrency?.trim();
    if (selected != null && selected.isNotEmpty) {
      return <String>[selected];
    }

    final currencies = <String>{};
    for (final account in accounts) {
      currencies.addAll(account.balances.map((item) => item.currency));
      currencies.addAll(account.activitySummaries.map((item) => item.currency));
      currencies.addAll(account.transactions.map((item) => item.currency));
    }

    final result = currencies.toList(growable: false)..sort();
    return result;
  }

  void _drawAccountsTable() {
    _drawSectionTitle('Accounts', 'الحسابات');
    final columns = _accountColumns();
    final rows = <GeniusPdfGridRow>[];

    if (configuration.grouping == AccountExportGrouping.none) {
      rows.addAll(accounts.map(_accountRow));
      if (configuration.showTotals) {
        rows.add(_totalRow(accounts, 'Grand Total', 'الإجمالي'));
      }
    } else {
      final groups = <String, List<AccountExportAccount>>{};
      for (final account in accounts) {
        final key = switch (configuration.grouping) {
          AccountExportGrouping.accountGroup =>
            account.displayGroup(isRtl: config.isRTL) ??
                (config.isRTL ? 'بدون مجموعة' : 'Ungrouped'),
          AccountExportGrouping.parentAccount =>
            account.displayParentName(isRtl: config.isRTL) ??
                (config.isRTL ? 'بدون حساب أب' : 'No parent'),
          AccountExportGrouping.none => '',
        };
        groups.putIfAbsent(key, () => <AccountExportAccount>[]).add(account);
      }

      for (final entry in groups.entries) {
        rows.add(GeniusPdfGridRow.groupHeader(entry.key));
        rows.addAll(entry.value.map(_accountRow));
        if (configuration.showTotals) {
          rows.add(
            _totalRow(
              entry.value,
              'Group total',
              'إجمالي المجموعة',
              groupName: entry.key,
            ),
          );
        }
      }

      if (configuration.showTotals) {
        rows.add(_totalRow(accounts, 'Grand Total', 'الإجمالي'));
      }
    }

    _drawGrid(
      customization.buildColumns(AccountExportGridKind.accounts, columns),
      rows,
      style: customization.gridStyle,
    );
  }

  List<GeniusPdfGridColumn> _accountColumns() {
    final fields = configuration.fields;
    return <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'number',
        title: 'Account No.',
        titleAr: 'رقم الحساب',
        width: 66,
        wrapText: true,
      ),
      const GeniusPdfGridColumn(
        id: 'name',
        title: 'Account Name',
        titleAr: 'اسم الحساب',
        flexFactor: 2,
        wrapText: true,
      ),
      if (fields.parentAccountNumber)
        const GeniusPdfGridColumn(
          id: 'parentNumber',
          title: 'Parent No.',
          titleAr: 'رقم الأب',
          width: 58,
          wrapText: true,
        ),
      if (fields.parentAccountName)
        const GeniusPdfGridColumn(
          id: 'parentName',
          title: 'Parent Account',
          titleAr: 'الحساب الأب',
          width: 92,
          wrapText: true,
        ),
      if (fields.group)
        const GeniusPdfGridColumn(
          id: 'group',
          title: 'Group',
          titleAr: 'المجموعة',
          width: 76,
          wrapText: true,
        ),
      if (fields.accountNature)
        const GeniusPdfGridColumn(
          id: 'nature',
          title: 'Nature',
          titleAr: 'الطبيعة',
          width: 54,
        ),
      if (fields.mobileNumber)
        const GeniusPdfGridColumn(
          id: 'mobile',
          title: 'Mobile',
          titleAr: 'الجوال',
          width: 76,
        ),
      if (fields.personalId)
        const GeniusPdfGridColumn(
          id: 'personalId',
          title: 'Personal ID',
          titleAr: 'الرقم الشخصي',
          width: 74,
        ),
      GeniusPdfGridColumn.date(
        id: 'lastTransactionDate',
        title: 'Last Transaction',
        titleAr: 'تاريخ آخر عملية',
        width: 72,
        dateFormat: 'yyyy-MM-dd',
      ),
      if (configuration.showBalances)
        GeniusPdfGridColumn.currency(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
          width: 76,
          currencySymbol: '',
        ),
      if (configuration.showActivity)
        _debitColumn(configuration.amountColors, width: 72),
      if (configuration.showActivity)
        _creditColumn(configuration.amountColors, width: 72),
    ];
  }

  GeniusPdfGridRow _accountRow(AccountExportAccount account) {
    final balance = account.balanceFor(configuration.selectedCurrency);
    final summary = account.summaryFor(configuration.selectedCurrency);
    final defaultRow = GeniusPdfGridRow(cells: <String, dynamic>{
      'number': account.accountNumber,
      'name': account.displayName(isRtl: config.isRTL),
      'parentNumber': account.parentAccountNumber,
      'parentName': account.displayParentName(isRtl: config.isRTL),
      'group': account.displayGroup(isRtl: config.isRTL),
      'nature': _nature(account.nature, config.isRTL),
      'mobile': account.mobileNumber,
      'personalId': account.personalId,
      'lastTransactionDate': _lastTransactionDate(account),
      'balance': balance?.amount,
      'debit': summary?.totalDebit,
      'credit': summary?.totalCredit,
    });
    return customization.buildRow(
      AccountExportGridKind.accounts,
      account,
      defaultRow,
    );
  }

  DateTime? _lastTransactionDate(AccountExportAccount account) {
    if (account.lastTransactionDate != null) {
      return account.lastTransactionDate;
    }
    if (account.transactions.isEmpty) return null;

    DateTime? latest;
    for (final transaction in account.transactions) {
      if (latest == null || transaction.date.isAfter(latest)) {
        latest = transaction.date;
      }
    }
    return latest;
  }

  GeniusPdfGridRow _totalRow(
    List<AccountExportAccount> subset,
    String label,
    String labelAr, {
    String? groupName,
  }) {
    double balances = 0;
    double debit = 0;
    double credit = 0;

    for (final account in subset) {
      balances +=
          account.balanceFor(configuration.selectedCurrency)?.signedAmount ?? 0;
      final summary = account.summaryFor(configuration.selectedCurrency);
      debit += summary?.totalDebit ?? 0;
      credit += summary?.totalCredit ?? 0;
    }

    return GeniusPdfGridRow.total(<String, dynamic>{
      'number': '${config.isRTL ? labelAr : label} (${subset.length})',
      'name': groupName ?? '',
      'lastTransactionDate': null,
      'balance': configuration.showBalances ? balances : null,
      'debit': configuration.showActivity ? debit : null,
      'credit': configuration.showActivity ? credit : null,
    });
  }

  void _drawFooterSection() {
    final hasQr = showQRCode && reportId != null && reportId!.trim().isNotEmpty;
    if (!showNotes && !hasQr) return;

    if (remainingHeight < 125 && currentY > headerHeight) {
      newPage();
    }
    addSpace(18);

    if (showNotes && !hasQr) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && hasQr) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    addTwoColumns(
      spacing: 10,
      leftFlex: config.isLTR ? 2 : 1,
      rightFlex: config.isLTR ? 1 : 2,
      leftContent: (page, bounds) {
        if (config.isLTR) {
          return _drawNotesContent(page, bounds);
        }
        return _drawQRCodeContent(page, bounds);
      },
      rightContent: (page, bounds) {
        if (config.isLTR) {
          return _drawQRCodeContent(page, bounds);
        }
        return _drawNotesContent(page, bounds);
      },
    );

    addSpace(18);
  }

  void _drawNotes({required double width}) {
    final height = _drawNotesContent(
      currentPage,
      Rect.fromLTWH(0, currentY, width, 0),
    );
    addSpace(height + 10);
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes = config.isRTL
        ? (notesAr ?? notes ?? _defaultNotesAr)
        : (notes ?? notesAr ?? _defaultNotes);

    final element = PdfTextElement(
      text: displayNotes,
      font: config.baseFont,
      format: config.isLTR
          ? null
          : PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right,
            ),
    );

    final result = element.draw(
      page: page,
      bounds: bounds,
    );
    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeSection({required double width}) {
    final height = _drawQRCodeContent(
      currentPage,
      Rect.fromLTWH(0, currentY, width, 0),
    );
    addSpace(height + 10);
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    final id = reportId?.trim();
    if (id == null || id.isEmpty) return 0;

    final caption = 'ID: $id';
    final captionLayout = PdfTextElement(
      text: caption,
      font: config.baseFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection,
      ),
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0),
    );

    final captionHeight = captionLayout?.bounds.height ?? 0;
    const qrSize = 80.0;
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: _effectiveQrCodeUrl(id),
      config: config,
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
  }

  String _effectiveQrCodeUrl(String id) {
    final custom = qrCodeUrl?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    return 'https://localhost:443/report/${Uri.encodeComponent(id)}';
  }

  static const String _defaultNotes = '''Notes:
• This report lists the selected accounts and their balances/movements for the configured reporting scope.
• The last-transaction date is the latest transaction date supplied for the account and should be reconciled with the underlying ledger when used for control purposes.
• Balance, debit, and credit totals should be reconciled with the general ledger and relevant subsidiary ledgers before the report is relied upon as accounting evidence.
• The QR code is a report-copy reference/verification aid only; it is not a journal number, approval, signature, or substitute for source documents.''';

  static const String _defaultNotesAr = '''ملاحظات:
• يعرض هذا التقرير الحسابات المحددة وأرصدتها وحركاتها وفق نطاق التقرير المختار.
• تاريخ آخر عملية هو أحدث تاريخ عملية تم توفيره للحساب، ويجب مطابقته مع دفتر الأستاذ عند استخدامه لأغراض الرقابة.
• يجب مطابقة إجماليات الرصيد والمدين والدائن مع دفتر الأستاذ العام ودفاتر الأستاذ المساعدة ذات الصلة قبل الاعتماد على التقرير كدليل محاسبي.
• رمز QR هو مرجع للمطابقة والتحقق من نسخة التقرير فقط، ولا يعد رقم قيد أو اعتماداً أو توقيعاً ولا يغني عن المستندات المصدرية.''';
}
