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

String _date(DateTime value) => '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

String _amount(double value) => value.toStringAsFixed(2);

String _nature(AccountBalanceNature? nature, bool isRtl) {
  return switch (nature) {
    AccountBalanceNature.debit => isRtl ? 'مدين' : 'Debit',
    AccountBalanceNature.credit => isRtl ? 'دائن' : 'Credit',
    null => '-',
  };
}

List<AccountCurrencyBalance> _selectedBalances(
  AccountExportAccount account,
  AccountExportConfiguration configuration,
) {
  final currency = configuration.selectedCurrency;
  if (currency == null) return account.balances;
  return account.balances
      .where((balance) => balance.currency == currency)
      .toList(growable: false);
}

List<AccountActivitySummary> _selectedSummaries(
  AccountExportAccount account,
  AccountExportConfiguration configuration,
) {
  final currency = configuration.selectedCurrency;
  if (currency == null) return account.activitySummaries;
  return account.activitySummaries
      .where((summary) => summary.currency == currency)
      .toList(growable: false);
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

List<GeniusPdfGridRow> _summaryRows(
  List<AccountActivitySummary> summaries,
  AccountExportAmountColors colors,
  bool isRtl,
) {
  return summaries
      .map(
        (summary) => GeniusPdfGridRow(
          cells: <String, dynamic>{
            'currency': summary.currency,
            'period':
                '${_date(summary.periodStart)} — ${_date(summary.periodEnd)}',
            'opening': summary.openingBalance,
            'debit': summary.totalDebit,
            'credit': summary.totalCredit,
            'net': summary.netMovement,
            'closing': summary.closingBalance,
          },
        ),
      )
      .toList(growable: false);
}

List<GeniusPdfGridColumn> _summaryColumns(AccountExportAmountColors colors) {
  return <GeniusPdfGridColumn>[
    const GeniusPdfGridColumn(
      id: 'currency',
      title: 'Currency',
      titleAr: 'العملة',
      width: 48,
    ),
    const GeniusPdfGridColumn(
      id: 'period',
      title: 'Period',
      titleAr: 'الفترة',
      flexFactor: 2,
      wrapText: true,
    ),
    GeniusPdfGridColumn.currency(
      id: 'opening',
      title: 'Opening',
      titleAr: 'افتتاحي',
      width: 72,
      currencySymbol: '',
    ),
    _debitColumn(colors, width: 72),
    _creditColumn(colors, width: 72),
    GeniusPdfGridColumn.currency(
      id: 'net',
      title: 'Net movement',
      titleAr: 'صافي الحركة',
      width: 78,
      currencySymbol: '',
    ),
    GeniusPdfGridColumn.currency(
      id: 'closing',
      title: 'Closing',
      titleAr: 'ختامي',
      width: 72,
      currencySymbol: '',
    ),
  ];
}
// END ACCOUNT EXPORT LOCAL RENDERING HELPERS

/// Detailed or summary PDF export for a single account.
///
/// The document uses portrait pages and keeps account activity separated by
/// currency. Each currency section renders its balance, a card-style activity
/// summary, and optional detailed transactions.
///
/// The document footer is repeated on every page and contains exporting-user
/// information and page numbering.
///
/// Notes and the QR verification reference intentionally follow the same
/// layout approach used by `TrialBalanceTemplate`: notes and QR are rendered
/// side by side when both are enabled, and the QR uses
/// [GeniusPdfQRCodeGenerator.url].
///
/// Example:
/// ```dart
/// final template = SingleAccountPdf(
///   config: pdfConfig,
///   meta: const AccountExportDocumentMeta(
///     title: 'Account Statement',
///     issueDate: DateTime(2026, 9, 6),
///     exportingUserNumber: 'USR-0074',
///     exportingUserName: 'Ahmed Al-Hakimi',
///   ),
///   account: account,
///   reportId: 'ACC-EXP-20260906-1101001',
///   configuration: const AccountExportConfiguration(
///     activityMode: AccountExportActivityMode.detailed,
///   ),
/// );
/// final bytes = template.generate();
/// template.dispose();
/// ```
class SingleAccountPdf extends GeniusErpStatementDocument {
  /// Creates a portrait single-account PDF template.
  ///
  /// [reportId] identifies the exported report and is displayed above the QR
  /// code. [qrCodeUrl] can be supplied by the host application when scanning
  /// should open a real verification endpoint. When it is omitted, a local
  /// report URL is constructed in the same manner as `TrialBalanceTemplate`.
  ///
  SingleAccountPdf({
    required GeniusPdfConfig config,
    required this.meta,
    required this.account,
    this.company,
    this.configuration = const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.singlePdf,
    ),
    String? reportId,
    this.qrCodeUrl,
    bool showQRCode = true,
    this.showNotes = true,
    String? notes,
    String? notesAr,
    @Deprecated('Use showQRCode instead.') bool? showVerificationBarcode,
    @Deprecated('Use reportId or qrCodeUrl instead.')
    String? verificationBarcodeData,
    @Deprecated('Use notes instead.') String? verificationNote,
    @Deprecated('Use notesAr instead.') String? verificationNoteAr,
  })  : reportId = reportId ?? verificationBarcodeData,
        showQRCode = showVerificationBarcode ?? showQRCode,
        notes = notes ?? verificationNote,
        notesAr = notesAr ?? verificationNoteAr,
        super(
          config.copyWith(
            orientation: PdfPageOrientation.portrait,
          ),
        );

  /// Document title, issue date, and exporting-user metadata.
  final AccountExportDocumentMeta meta;

  /// Account rendered by this document.
  final AccountExportAccount account;

  /// Optional company information for the bilingual report header.
  final GeniusPdfCompanyInfo? company;

  /// Visibility, period, currency, and activity-mode configuration.
  final AccountExportConfiguration configuration;

  /// Stable report/export identifier displayed with the QR code.
  final String? reportId;

  /// Optional absolute URL encoded by the QR code.
  ///
  /// When null, the template builds `https://localhost:443/report/<reportId>`
  /// to match the current trial-balance example behavior.
  final String? qrCodeUrl;

  /// Whether to render the QR verification section.
  final bool showQRCode;

  /// Whether to render the accounting notes section.
  final bool showNotes;

  /// Optional LTR notes shown near the QR code.
  final String? notes;

  /// Optional Arabic notes shown near the QR code.
  final String? notesAr;

  /// Backward-compatible alias for [showQRCode].
  @Deprecated('Use showQRCode instead.')
  bool get showVerificationBarcode => showQRCode;

  /// Backward-compatible alias for [reportId].
  @Deprecated('Use reportId or qrCodeUrl instead.')
  String? get verificationBarcodeData => reportId;

  /// Backward-compatible alias for [notes].
  @Deprecated('Use notes instead.')
  String? get verificationNote => notes;

  /// Backward-compatible alias for [notesAr].
  @Deprecated('Use notesAr instead.')
  String? get verificationNoteAr => notesAr;

  /// Builds the document using the configured account data and visibility.
  @override
  void build() {
    _addRepeatingFooter();

    newPage();
    _drawHeader();
    _drawAccountDetails();

    if (configuration.showBalances) {
      _drawBalanceNatureSummary();
    }

    _drawCurrencies();
    _drawFooterSection();
  }

  void _addRepeatingFooter() {
    addFooter(
      userName: _footerUserInfo(),
      userLabel: config.isRTL ? 'المستخدم: ' : 'User: ',
      showPageNumber: true,
      pageNumberFormat: '{0}/{1}',
    );
  }

  String _footerUserInfo() {
    final name = meta.exportingUserName?.trim();
    final number = meta.exportingUserNumber?.trim();

    if (name != null &&
        name.isNotEmpty &&
        number != null &&
        number.isNotEmpty) {
      return '$name ($number)';
    }
    if (name != null && name.isNotEmpty) return name;
    if (number != null && number.isNotEmpty) return number;
    return config.isRTL ? 'غير محدد' : 'Not specified';
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: meta.title,
      titleAr: meta.titleAr ?? meta.title,
      company: company,
      printDate: meta.issueDate,
      config: config,
      style: GeniusPdfReportHeaderStyle.classic(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
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

  void _drawAccountDetails() {
    final fields = configuration.fields;
    final values = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Account No.',
        labelAr: 'رقم الحساب',
        value: account.accountNumber,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Account Name',
        labelAr: 'اسم الحساب',
        value: account.displayName(isRtl: config.isRTL),
      ),
      if (fields.parentAccountName && account.parentAccountName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Parent Account',
          labelAr: 'الحساب الأب',
          value: account.displayParentName(isRtl: config.isRTL)!,
        ),
      if (fields.group && account.group != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Group',
          labelAr: 'المجموعة',
          value: account.displayGroup(isRtl: config.isRTL)!,
        ),
      if (fields.accountNature && account.nature != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account Nature',
          labelAr: 'طبيعة الحساب',
          value: _nature(account.nature, config.isRTL),
        ),
      if (fields.mobileNumber && account.mobileNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Mobile',
          labelAr: 'الجوال',
          value: account.mobileNumber!,
        ),
      if (fields.personalId && account.personalId != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Personal ID',
          labelAr: 'الرقم الشخصي',
          value: account.personalId!,
        ),
    ];

    final box = GeniusPdfInfoBox(
      config: config,
      title: 'Account Details',
      titleAr: 'بيانات الحساب',
      items: values,
      columns: 3,
      columnSpacing: 14,
      style: GeniusPdfInfoBoxStyle.minimal(),
    );

    final result = box.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 108),
    );
    addSpace(result.height + 12);
  }

  void _drawBalanceNatureSummary() {
    final balances = _selectedBalances(account, configuration);
    if (balances.isEmpty) return;

    final colors = configuration.amountColors;
    final items = balances
        .map(
          (balance) => GeniusPdfSummaryItem(
            label: '${balance.currency} balance',
            labelAr: 'رصيد ${balance.currency}',
            value: '${_amount(balance.amount)} ${balance.currency} — '
                '${_nature(balance.nature, config.isRTL)}',
            valueColor: balance.nature == AccountBalanceNature.debit
                ? colors.debitForeground
                : colors.creditForeground,
            isBold: true,
          ),
        )
        .toList(growable: false);

    final summary = GeniusPdfSummarySection(
      config: config,
      title: 'Balance overview by currency',
      titleAr: 'ملخص الرصيد حسب العملة',
      items: items,
      style: const GeniusPdfSummaryStyle.card(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.58,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );
    addSpace(result.height + 14);
  }

  void _drawCurrencies() {
    for (final currency in _visibleCurrencies()) {
      _ensureCurrencySectionSpace();
      _drawCurrencyHeading(currency);

      if (configuration.showBalances) {
        _drawCurrencyBalance(currency);
      }

      if (configuration.showActivity) {
        _drawCurrencySummaryActivity(currency);

        if (configuration.activityMode == AccountExportActivityMode.detailed) {
          _drawCurrencyDetailedActivity(currency);
        }
      }
    }
  }

  List<String> _visibleCurrencies() {
    final selected = configuration.selectedCurrency;
    if (selected != null && selected.trim().isNotEmpty) {
      return <String>[selected];
    }

    final currencies = <String>[];

    void addCurrency(String currency) {
      if (!currencies.contains(currency)) currencies.add(currency);
    }

    if (configuration.showBalances) {
      for (final balance in account.balances) {
        addCurrency(balance.currency);
      }
    }

    if (configuration.showActivity) {
      for (final summary in account.activitySummaries) {
        addCurrency(summary.currency);
      }
      if (configuration.activityMode == AccountExportActivityMode.detailed) {
        for (final transaction in account.transactions) {
          addCurrency(transaction.currency);
        }
      }
    }

    return currencies;
  }

  void _ensureCurrencySectionSpace() {
    if (remainingHeight < 190 && currentY > headerHeight) {
      newPage();
    }
  }

  void _drawCurrencyHeading(String currency) {
    addSpace(5);
    addLine(
      config.isRTL ? 'العملة: $currency' : 'Currency: $currency',
      font: config.boldFont,
      topMargin: 4,
    );
    addSpace(8);
  }

  void _drawCurrencyBalance(String currency) {
    final balances = _selectedBalances(account, configuration)
        .where((balance) => balance.currency == currency)
        .toList(growable: false);
    if (balances.isEmpty) return;

    final balance = balances.first;
    final box = GeniusPdfInfoBox(
      config: config,
      title: 'Account balance in $currency',
      titleAr: 'رصيد الحساب بعملة $currency',
      columns: 3,
      columnSpacing: 14,
      style: GeniusPdfInfoBoxStyle.minimal(),
      items: <GeniusPdfLabeledValue>[
        GeniusPdfLabeledValue(
          config: config,
          label: 'Currency',
          labelAr: 'العملة',
          value: currency,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Balance',
          labelAr: 'الرصيد',
          value: _amount(balance.amount),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Nature',
          labelAr: 'الطبيعة',
          value: _nature(balance.nature, config.isRTL),
        ),
      ],
    );

    final result = box.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 64),
    );
    addSpace(result.height + 10);
  }

  void _drawCurrencySummaryActivity(String currency) {
    final summaries = _selectedSummaries(account, configuration)
        .where((summary) => summary.currency == currency)
        .toList(growable: false);
    if (summaries.isEmpty) return;

    _drawSectionTitle(
      'Account activity in $currency',
      'حركة الحساب بعملة $currency',
    );
    _drawGrid(
      _summaryColumns(configuration.amountColors),
      _summaryRows(
        summaries,
        configuration.amountColors,
        config.isRTL,
      ),
      spacing: 12,
    );
  }

  void _drawCurrencyDetailedActivity(String currency) {
    final rows = _transactionRowsForCurrency(currency);
    if (rows.isEmpty) return;

    _drawSectionTitle(
      'Detailed transactions in $currency',
      'الحركات التفصيلية بعملة $currency',
    );
    _drawGrid(
      _portraitTransactionColumns(configuration.amountColors),
      rows,
      spacing: 16,
    );
  }

  List<GeniusPdfGridRow> _transactionRowsForCurrency(String currency) {
    final start = configuration.periodStart;
    final end = configuration.periodEnd;
    final transactions = account.transactions.where((transaction) {
      if (transaction.currency != currency) return false;
      if (start != null && transaction.date.isBefore(start)) return false;
      if (end != null && transaction.date.isAfter(end)) return false;
      return true;
    }).toList(growable: false)
      ..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        return a.transactionNumber.compareTo(b.transactionNumber);
      });

    return transactions
        .map(
          (transaction) => GeniusPdfGridRow(
            cells: <String, dynamic>{
              'number': transaction.transactionNumber,
              'date': transaction.date,
              'type': transaction.displayType(isRtl: config.isRTL),
              'description':
                  transaction.displayDescription(isRtl: config.isRTL),
              'currency': transaction.currency,
              'debit': transaction.debit == 0 ? null : transaction.debit,
              'credit': transaction.credit == 0 ? null : transaction.credit,
              'balance': transaction.balanceAfterTransaction,
            },
          ),
        )
        .toList(growable: false);
  }

  List<GeniusPdfGridColumn> _portraitTransactionColumns(
    AccountExportAmountColors colors,
  ) {
    return <GeniusPdfGridColumn>[
      const GeniusPdfGridColumn(
        id: 'number',
        title: 'Transaction No.',
        titleAr: 'رقم الحركة',
        width: 52,
        wrapText: true,
      ),
      GeniusPdfGridColumn.date(
        id: 'date',
        title: 'Date',
        titleAr: 'التاريخ',
        width: 46,
        dateFormat: 'yyyy-MM-dd',
      ),
      const GeniusPdfGridColumn(
        id: 'type',
        title: 'Type',
        titleAr: 'النوع',
        width: 58,
        wrapText: true,
      ),
      const GeniusPdfGridColumn(
        id: 'description',
        title: 'Full description',
        titleAr: 'البيان الكامل',
        flexFactor: 6,
        wrapText: true,
      ),
      const GeniusPdfGridColumn(
        id: 'currency',
        title: 'Curr.',
        titleAr: 'العملة',
        width: 38,
      ),
      _debitColumn(colors, width: 55),
      _creditColumn(colors, width: 55),
      GeniusPdfGridColumn.currency(
        id: 'balance',
        title: 'Balance',
        titleAr: 'الرصيد',
        width: 65,
        currencySymbol: '',
      ),
    ];
  }

  void _drawFooterSection() {
    final hasQr = showQRCode && reportId != null && reportId!.trim().isNotEmpty;
    if (!showNotes && !hasQr) return;

    if (remainingHeight < 125 && currentY > headerHeight) {
      newPage();
    }
    addSpace(16);

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

    addSpace(16);
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
• This export presents the account ledger for the selected period, separated by transaction currency.
• Balances of different currencies are not netted against each other unless an authorized conversion or settlement entry exists.
• Opening balance, movements, and closing balance should be reconciled to the subsidiary ledger, general ledger, and supporting source documents.
• The QR code is a report-copy verification/reference aid only; it is not a journal number, approval, signature, or substitute for source documents.''';

  static const String _defaultNotesAr = '''ملاحظات:
• يعرض هذا التصدير حركة الحساب للفترة المحددة مع فصل الحركات والأرصدة حسب عملة المعاملة.
• لا تتم مقاصة أرصدة العملات المختلفة مع بعضها إلا بموجب قيد تحويل أو تسوية معتمد ومثبت محاسبياً.
• يجب مطابقة الرصيد الافتتاحي والحركات والرصيد الختامي مع الأستاذ المساعد والأستاذ العام والمستندات المصدرية المؤيدة.
• رمز QR وسيلة مرجعية للتحقق من نسخة التقرير فقط، ولا يعد رقم قيد أو اعتماداً أو توقيعاً ولا يحل محل المستندات المصدرية.''';
}
