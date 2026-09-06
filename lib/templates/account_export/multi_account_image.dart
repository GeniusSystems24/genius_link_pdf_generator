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

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

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

/// Compact summary-only multi-account layout intended for image export.
///
/// The template uses landscape pages, a bilingual split header, a three-column
/// minimal report-details box, a compact account grid with last-transaction
/// date, and the same notes/QR composition used by `TrialBalanceTemplate`.
/// Detailed transaction rows are intentionally unsupported.
///
/// [maxAccountsPerImage] keeps every image readable. Use [split] for larger
/// datasets; each returned builder remains one compact PDF source page that can
/// be rasterized through the package's existing `PdfDocument.exportToImages`
/// flow.
class MultiAccountImage extends GeniusErpRegisterDocument {
  /// Creates one compact landscape multi-account image source document.
  ///
  /// [configuration] must use [AccountExportActivityMode.summary]. When
  /// balances or activity are visible, [AccountExportConfiguration.selectedCurrency]
  /// must identify the currency rendered in the image.
  MultiAccountImage({
    required GeniusPdfConfig config,
    required this.meta,
    required this.accounts,
    this.company,
    this.configuration = const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.multiImage,
      activityMode: AccountExportActivityMode.summary,
    ),
    this.maxAccountsPerImage = 12,
    this.imageIndex = 0,
    this.totalAccountCount,
    this.reportId,
    this.qrCodeUrl,
    this.showQRCode = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
    this.showLastTransactionDate = true,
  }) : super(
          config.copyWith(
            orientation: PdfPageOrientation.landscape,
          ),
        ) {
    if (configuration.activityMode != AccountExportActivityMode.summary) {
      throw ArgumentError.value(
        configuration.activityMode,
        'configuration.activityMode',
        'MultiAccountImage supports summary activity only.',
      );
    }
    if ((configuration.showBalances || configuration.showActivity) &&
        configuration.selectedCurrency == null) {
      throw ArgumentError(
        'MultiAccountImage requires selectedCurrency when balance or activity is shown.',
      );
    }
    if (maxAccountsPerImage < 1) {
      throw ArgumentError.value(maxAccountsPerImage, 'maxAccountsPerImage');
    }
    if (accounts.length > maxAccountsPerImage) {
      throw ArgumentError(
        'accounts contains ${accounts.length} rows, but maxAccountsPerImage is '
        '$maxAccountsPerImage. Use MultiAccountImage.split(...) for larger data.',
      );
    }
    if (totalAccountCount != null && totalAccountCount! < accounts.length) {
      throw ArgumentError.value(
        totalAccountCount,
        'totalAccountCount',
        'Must be greater than or equal to the accounts rendered in this image.',
      );
    }
  }

  /// Document title, issue date, and exporting-user metadata.
  final AccountExportDocumentMeta meta;

  /// Accounts rendered in this image source page.
  final List<AccountExportAccount> accounts;

  /// Optional company information for the bilingual report header.
  final GeniusPdfCompanyInfo? company;

  /// Compact fields, selected currency, and summary visibility.
  final AccountExportConfiguration configuration;

  /// Maximum account rows allowed in one image.
  final int maxAccountsPerImage;

  /// Zero-based index of this image when generated by [split].
  final int imageIndex;

  /// Total account count in the complete export before splitting.
  ///
  /// Direct callers can leave this null; [accounts.length] is then used.
  final int? totalAccountCount;

  /// Stable report/export identifier displayed with the QR code.
  ///
  /// [split] appends a one-based image suffix so each exported image receives
  /// its own reference, for example `REPORT-1`, `REPORT-2`, and so on.
  final String? reportId;

  /// Optional absolute URL encoded by the QR code.
  final String? qrCodeUrl;

  /// Whether the QR verification section is rendered.
  final bool showQRCode;

  /// Whether the report notes section is rendered.
  final bool showNotes;

  /// Optional LTR notes rendered near the QR code.
  final String? notes;

  /// Optional Arabic notes rendered near the QR code.
  final String? notesAr;

  /// Whether the compact table includes the latest transaction date column.
  final bool showLastTransactionDate;

  /// Splits [accounts] into one [MultiAccountImage] builder per image.
  ///
  /// The returned builders share the report configuration and receive a unique
  /// report ID suffix when [reportId] is provided. This method only builds PDF
  /// source pages; rasterization remains the responsibility of the package's
  /// existing `exportToImages` flow.
  static List<MultiAccountImage> split({
    required GeniusPdfConfig config,
    required AccountExportDocumentMeta meta,
    required List<AccountExportAccount> accounts,
    GeniusPdfCompanyInfo? company,
    AccountExportConfiguration configuration = const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.multiImage,
      activityMode: AccountExportActivityMode.summary,
    ),
    int maxAccountsPerImage = 12,
    String? reportId,
    String? qrCodeUrl,
    bool showQRCode = true,
    bool showNotes = true,
    String? notes,
    String? notesAr,
    bool showLastTransactionDate = true,
  }) {
    if (maxAccountsPerImage < 1) {
      throw ArgumentError.value(maxAccountsPerImage, 'maxAccountsPerImage');
    }

    final result = <MultiAccountImage>[];
    for (var start = 0; start < accounts.length; start += maxAccountsPerImage) {
      final end = (start + maxAccountsPerImage < accounts.length)
          ? start + maxAccountsPerImage
          : accounts.length;
      final currentIndex = result.length;
      final imageReportId = reportId == null || reportId.trim().isEmpty
          ? reportId
          : '${reportId.trim()}-${currentIndex + 1}';

      result.add(
        MultiAccountImage(
          config: config,
          meta: meta,
          accounts: accounts.sublist(start, end),
          company: company,
          configuration: configuration,
          maxAccountsPerImage: maxAccountsPerImage,
          imageIndex: currentIndex,
          totalAccountCount: accounts.length,
          reportId: imageReportId,
          qrCodeUrl: qrCodeUrl,
          showQRCode: showQRCode,
          showNotes: showNotes,
          notes: notes,
          notesAr: notesAr,
          showLastTransactionDate: showLastTransactionDate,
        ),
      );
    }
    return result;
  }

  /// Builds the compact summary-only multi-account source page.
  @override
  void build() {
    _addRepeatingFooter();

    newPage();
    _drawHeader();
    _drawReportDetails();
    _drawCompactTable();
    _drawFooterSection();
  }

  void _addRepeatingFooter() {
    addFooter(
      userName: _footerUserName(),
      userLabel: config.isRTL ? 'المستخدم: ' : 'User: ',
      printTime: _footerIssueDate(),
      showPageNumber: true,
      pageNumberFormat: '{0}/{1}',
    );
  }

  String _footerUserName() {
    final name = meta.exportingUserName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final number = meta.exportingUserNumber?.trim();
    if (number != null && number.isNotEmpty) return number;
    return config.isRTL ? 'غير محدد' : 'Not specified';
  }

  String _footerIssueDate() {
    final value = _date(meta.issueDate);
    return config.isRTL ? 'تاريخ الإصدار: $value' : 'Issue date: $value';
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
      bounds: Rect.fromLTWH(0, 0, pageWidth, 104),
    );
    addSpace(height + 8);
  }

  void _drawReportDetails() {
    final total = totalAccountCount ?? accounts.length;
    final totalImages = total == 0 ? 1 : (total + maxAccountsPerImage - 1) ~/ maxAccountsPerImage;
    final currency = configuration.selectedCurrency?.trim();

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
        label: 'Report Currency',
        labelAr: 'عملة التقرير',
        value: currency == null || currency.isEmpty ? '-' : currency,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Accounts',
        labelAr: 'الحسابات',
        value: '${accounts.length} / $total',
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Image',
        labelAr: 'الصورة',
        value: '${imageIndex + 1} / $totalImages',
      ),
    ];

    final result = GeniusPdfInfoBox(
      config: config,
      title: 'Report Details',
      titleAr: 'تفاصيل التقرير',
      items: values,
      columns: 3,
      columnSpacing: 12,
      style: GeniusPdfInfoBoxStyle.minimal(),
    ).draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 76),
    );
    addSpace(result.height + 8);
  }

  String _reportPeriodLabel() {
    final start = configuration.periodStart;
    final end = configuration.periodEnd;
    if (start != null && end != null) return '${_date(start)} — ${_date(end)}';
    if (start != null) return config.isRTL ? 'من ${_date(start)}' : 'From ${_date(start)}';
    if (end != null) return config.isRTL ? 'حتى ${_date(end)}' : 'Through ${_date(end)}';
    return config.isRTL ? 'جميع الفترات' : 'All dates';
  }

  void _drawCompactTable() {
    final fields = configuration.fields;
    final columns = <GeniusPdfGridColumn>[
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
      if (fields.parentAccountName)
        const GeniusPdfGridColumn(
          id: 'parent',
          title: 'Parent',
          titleAr: 'الحساب الأب',
          width: 86,
          wrapText: true,
        ),
      if (fields.group)
        const GeniusPdfGridColumn(
          id: 'group',
          title: 'Group',
          titleAr: 'المجموعة',
          width: 72,
          wrapText: true,
        ),
      if (showLastTransactionDate)
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
          width: 74,
          currencySymbol: '',
        ),
      if (configuration.showActivity)
        _debitColumn(configuration.amountColors, width: 70),
      if (configuration.showActivity)
        _creditColumn(configuration.amountColors, width: 70),
    ];

    final rows = accounts.map((account) {
      final balance = account.balanceFor(configuration.selectedCurrency);
      final summary = account.summaryFor(configuration.selectedCurrency);
      return GeniusPdfGridRow(cells: <String, dynamic>{
        'number': account.accountNumber,
        'name': account.displayName(isRtl: config.isRTL),
        'parent': account.displayParentName(isRtl: config.isRTL),
        'group': account.displayGroup(isRtl: config.isRTL),
        'lastTransactionDate': _lastTransactionDate(account),
        'balance': balance?.amount,
        'debit': summary?.totalDebit,
        'credit': summary?.totalCredit,
      });
    }).toList();

    if (configuration.showTotals && rows.isNotEmpty) {
      double balanceTotal = 0;
      double debitTotal = 0;
      double creditTotal = 0;
      for (final account in accounts) {
        balanceTotal +=
            account.balanceFor(configuration.selectedCurrency)?.signedAmount ?? 0;
        final summary = account.summaryFor(configuration.selectedCurrency);
        debitTotal += summary?.totalDebit ?? 0;
        creditTotal += summary?.totalCredit ?? 0;
      }
      rows.add(
        GeniusPdfGridRow.total(<String, dynamic>{
          'number': config.isRTL
              ? 'الإجمالي (${accounts.length})'
              : 'Total (${accounts.length})',
          'name': config.isRTL ? 'الحسابات المعروضة' : 'Displayed accounts',
          'balance': configuration.showBalances ? balanceTotal : null,
          'debit': configuration.showActivity ? debitTotal : null,
          'credit': configuration.showActivity ? creditTotal : null,
        }),
      );
    }

    _drawSectionTitle('Accounts', 'الحسابات');
    _drawGrid(columns, rows, spacing: 4);
  }

  DateTime? _lastTransactionDate(AccountExportAccount account) {
    if (account.lastTransactionDate != null) return account.lastTransactionDate;
    if (account.transactions.isEmpty) return null;

    DateTime? latest;
    for (final transaction in account.transactions) {
      if (latest == null || transaction.date.isAfter(latest)) {
        latest = transaction.date;
      }
    }
    return latest;
  }

  void _drawFooterSection() {
    final hasQr = showQRCode && reportId != null && reportId!.trim().isNotEmpty;
    if (!showNotes && !hasQr) return;

    addSpace(8);

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
        if (config.isLTR) return _drawNotesContent(page, bounds);
        return _drawQRCodeContent(page, bounds);
      },
      rightContent: (page, bounds) {
        if (config.isLTR) return _drawQRCodeContent(page, bounds);
        return _drawNotesContent(page, bounds);
      },
    );
  }

  void _drawNotes({required double width}) {
    final height = _drawNotesContent(
      currentPage,
      Rect.fromLTWH(0, currentY, width, 0),
    );
    addSpace(height + 6);
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes = config.isRTL
        ? (notesAr ?? notes ?? _defaultNotesAr)
        : (notes ?? notesAr ?? _defaultNotes);

    final result = PdfTextElement(
      text: displayNotes,
      font: config.baseFont,
      format: config.isLTR
          ? null
          : PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right,
            ),
    ).draw(page: page, bounds: bounds);

    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeSection({required double width}) {
    final height = _drawQRCodeContent(
      currentPage,
      Rect.fromLTWH(0, currentY, width, 0),
    );
    addSpace(height + 6);
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    final id = reportId?.trim();
    if (id == null || id.isEmpty) return 0;

    final captionLayout = PdfTextElement(
      text: 'ID: $id',
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
    const qrSize = 60.0;
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 4;

    GeniusPdfQRCodeGenerator.url(
      url: _effectiveQrCodeUrl(id),
      config: config,
      caption: null,
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 4 + qrSize;
  }

  String _effectiveQrCodeUrl(String id) {
    final custom = qrCodeUrl?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    return 'https://localhost:443/report/${Uri.encodeComponent(id)}';
  }

  static const String _defaultNotes = '''Notes:
• This image contains summary balances and movements only; detailed transaction rows are intentionally excluded.
• Last-transaction dates and account totals should be reconciled with the underlying ledger before the image is used for control or audit support.
• The QR code identifies this exported image/report copy only and does not replace journal references, approvals, signatures, or source documents.''';

  static const String _defaultNotesAr = '''ملاحظات:
• تحتوي هذه الصورة على ملخص الأرصدة والحركات فقط، ولا تعرض صفوف الحركات التفصيلية.
• يجب مطابقة تواريخ آخر عملية وإجماليات الحسابات مع دفتر الأستاذ قبل استخدام الصورة لأغراض الرقابة أو دعم المراجعة.
• رمز QR يعرّف نسخة الصورة/التقرير المصدرة فقط، ولا يحل محل أرقام القيود أو الاعتمادات أو التواقيع أو المستندات المصدرية.''';
}
