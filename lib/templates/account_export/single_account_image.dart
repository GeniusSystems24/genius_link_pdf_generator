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

String _amount(double value) => value.toStringAsFixed(2);

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
            'period': '${_date(summary.periodStart)} — ${_date(summary.periodEnd)}',
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

/// Compact summary-only export for a single account image.
///
/// The template follows the same visual language as [SingleAccountPdf] while
/// preserving the image-export limitation: one selected currency and summary
/// activity only. It uses a bilingual split report header, a three-column
/// minimal account-details box, a semantic balance summary, a grid for period
/// movement, and the same notes/QR composition used by `TrialBalanceTemplate`.
///
/// The generated document remains a PDF source page. Convert it with the
/// package's existing `PdfDocument.exportToImages(...)` flow.
class SingleAccountImage extends GeniusErpRegisterDocument {
  /// Creates a compact portrait single-account image source document.
  ///
  /// [configuration] must use [AccountExportActivityMode.summary]. When
  /// balances or activity are visible, [AccountExportConfiguration.selectedCurrency]
  /// must identify the single currency rendered in the image.
  ///
  /// [reportId] is shown with the QR section when [showQRCode] is true. If
  /// [qrCodeUrl] is omitted, a local report URL is derived from [reportId].
  SingleAccountImage({
    required GeniusPdfConfig config,
    required this.meta,
    required this.account,
    this.company,
    this.configuration = const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.singleImage,
      activityMode: AccountExportActivityMode.summary,
    ),
    this.reportId,
    this.qrCodeUrl,
    this.showQRCode = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(
          config.copyWith(
            orientation: PdfPageOrientation.portrait,
          ),
        ) {
    if (configuration.activityMode != AccountExportActivityMode.summary) {
      throw ArgumentError.value(
        configuration.activityMode,
        'configuration.activityMode',
        'SingleAccountImage supports summary activity only.',
      );
    }
    if ((configuration.showBalances || configuration.showActivity) &&
        configuration.selectedCurrency == null) {
      throw ArgumentError(
        'SingleAccountImage requires selectedCurrency when balance or activity is shown.',
      );
    }
  }

  /// Document title, issue date, and exporting-user metadata.
  final AccountExportDocumentMeta meta;

  /// Account rendered in the image.
  final AccountExportAccount account;

  /// Optional company information for the bilingual header.
  final GeniusPdfCompanyInfo? company;

  /// Compact field, currency, balance, and summary configuration.
  final AccountExportConfiguration configuration;

  /// Stable report/export identifier displayed with the QR code.
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

  /// Builds the single compact image source page.
  @override
  void build() {
    _addRepeatingFooter();

    newPage();
    _drawHeader();
    _drawAccountDetails();
    if (configuration.showBalances) _drawBalanceSummary();
    if (configuration.showActivity) _drawActivityGrid();
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
      style: const GeniusPdfReportHeaderStyle.classic(),
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
      bounds: Rect.fromLTWH(0, 0, pageWidth, 108),
    );
    addSpace(height + 10);
  }

  void _drawAccountDetails() {
    final fields = configuration.fields;
    final items = <GeniusPdfLabeledValue>[
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
          label: 'Nature',
          labelAr: 'الطبيعة',
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

    final result = GeniusPdfInfoBox(
      config: config,
      title: 'Account Details',
      titleAr: 'بيانات الحساب',
      items: items,
      columns: 3,
      columnSpacing: 12,
      style: GeniusPdfInfoBoxStyle.minimal(),
    ).draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 94),
    );
    addSpace(result.height + 10);
  }

  void _drawBalanceSummary() {
    final balance = account.balanceFor(configuration.selectedCurrency);
    if (balance == null) return;

    final colors = configuration.amountColors;
    final result = GeniusPdfSummarySection(
      config: config,
      title: 'Account Balance',
      titleAr: 'رصيد الحساب',
      items: <GeniusPdfSummaryItem>[
        GeniusPdfSummaryItem(
          label: 'Currency',
          labelAr: 'العملة',
          value: balance.currency,
        ),
        GeniusPdfSummaryItem(
          label: 'Balance',
          labelAr: 'الرصيد',
          value: '${_amount(balance.amount)} ${balance.currency}',
          valueColor: balance.nature == AccountBalanceNature.debit
              ? colors.debitForeground
              : colors.creditForeground,
          isBold: true,
        ),
        GeniusPdfSummaryItem(
          label: 'Nature',
          labelAr: 'الطبيعة',
          value: _nature(balance.nature, config.isRTL),
          valueColor: balance.nature == AccountBalanceNature.debit
              ? colors.debitForeground
              : colors.creditForeground,
          isBold: true,
        ),
      ],
      style: const GeniusPdfSummaryStyle.card(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.68,
    ).draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 100),
    );
    addSpace(result.height + 10);
  }

  void _drawActivityGrid() {
    final summary = account.summaryFor(configuration.selectedCurrency);
    if (summary == null) return;

    _drawSectionTitle('Account Activity', 'حركة الحساب');
    _drawGrid(
      _summaryColumns(configuration.amountColors),
      _summaryRows(
        <AccountActivitySummary>[summary],
        configuration.amountColors,
        config.isRTL,
      ),
      spacing: 6,
    );
  }

  void _drawFooterSection() {
    final hasQr = showQRCode && reportId != null && reportId!.trim().isNotEmpty;
    if (!showNotes && !hasQr) return;

    addSpace(12);

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
    addSpace(height + 8);
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
    addSpace(height + 8);
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
    const qrSize = 64.0;
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
• This image is a compact account summary for the selected currency and reporting period.
• Reconcile the balance and debit/credit movement with the ledger before relying on the exported image as accounting evidence.
• The QR code identifies this exported report copy only; it is not a journal number, approval, signature, or substitute for source documents.''';

  static const String _defaultNotesAr = '''ملاحظات:
• هذه الصورة ملخص مختصر للحساب بالعملة والفترة المحددتين.
• يجب مطابقة الرصيد وحركة المدين والدائن مع دفتر الأستاذ قبل الاعتماد على الصورة المصدرة كدليل محاسبي.
• رمز QR يعرّف نسخة التقرير المصدرة فقط، ولا يعد رقم قيد أو اعتماداً أو توقيعاً ولا يغني عن المستندات المصدرية.''';
}
