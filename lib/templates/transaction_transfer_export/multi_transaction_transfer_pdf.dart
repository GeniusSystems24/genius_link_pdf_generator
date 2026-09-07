import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';


GeniusPdfCellStyle _debitCellStyle(TransactionTransferAmountColors colors) {
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

GeniusPdfCellStyle _creditCellStyle(TransactionTransferAmountColors colors) {
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

extension _MultiTransactionTransferBuilderSupport on GeniusPdfDocumentBuilder {
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

/// Landscape PDF report for multiple logical transaction transfers.
///
/// Each source accounting leg is rendered as its own table row so every row
/// identifies exactly one affected account. `(serviceId, transactionId)` is
/// retained as the logical transaction reference because transaction IDs are
/// reused across services in the supplied data.
///
/// The source signed `amount` is treated as the authoritative accounting
/// direction: positive is debit and negative is credit. Description-level
/// `debitAccounts`/`creditAccounts` are used only as counter-account metadata.
///
/// Example:
/// ```dart
/// final report = MultiTransactionTransferPdf(
///   config: pdfConfig,
///   meta: TransactionTransferDocumentMeta(
///     title: 'Transaction Transfers',
///     titleAr: 'حركات التحويلات',
///     issueDate: DateTime.now(),
///   ),
///   rows: TransactionTransferJsonData.rowsFromJson(decodedTransfers),
///   services: TransactionTransferJsonData.servicesFromJson(decodedServices),
/// );
/// ```
class MultiTransactionTransferPdf extends GeniusErpRegisterDocument {
  /// Creates a multi-transaction-transfer report.
  MultiTransactionTransferPdf({
    required GeniusPdfConfig config,
    required this.meta,
    required this.rows,
    this.services = const <int, TransactionTransferServiceInfo>{},
    this.accountDirectory = const <int, TransactionTransferAccountInfo>{},
    this.company,
    this.configuration = const TransactionTransferReportConfiguration(),
    this.customization = const TransactionTransferTemplateCustomization(),
    this.reportId,
    this.qrCodeUrl,
    this.showQRCode = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config.copyWith(orientation: PdfPageOrientation.landscape));

  /// Report title, issue date, and exporting-user metadata.
  final TransactionTransferDocumentMeta meta;

  /// Raw accounting-leg rows loaded from `transaction_transfer` JSON.
  final List<TransactionTransferRow> rows;

  /// Optional service lookup typically parsed from `services.json`.
  final Map<int, TransactionTransferServiceInfo> services;

  /// Optional account-name directory keyed by account ID.
  final Map<int, TransactionTransferAccountInfo> accountDirectory;

  /// Optional company data for the report header.
  final GeniusPdfCompanyInfo? company;

  /// Period/currency/service/status filters and semantic amount colors.
  final TransactionTransferReportConfiguration configuration;

  /// Reusable presentation and extension hooks for this template.
  final TransactionTransferTemplateCustomization customization;

  /// Stable report identifier displayed next to the QR code.
  final String? reportId;

  /// Optional URL encoded by the QR code.
  final String? qrCodeUrl;

  /// Whether the QR verification block is rendered.
  final bool showQRCode;

  /// Whether report notes are rendered.
  final bool showNotes;

  /// Optional LTR notes.
  final String? notes;

  /// Optional Arabic notes.
  final String? notesAr;


  @override
  void build() {
    if (customization.showFooter) _addRepeatingFooter();
    newPage();
    _drawHeader();
    final filteredRows = _filteredRows();
    final groups = TransactionTransferGroup.groupRows(
      filteredRows,
      services: services,
    );
    _drawReportDetails(filteredRows, groups);
    _drawTransfersTable(filteredRows);
    _drawFooterSection();
  }

  List<TransactionTransferRow> _filteredRows() => rows
      .where(configuration.includes)
      .toList(growable: false)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void _addRepeatingFooter() {
    addFooter(
      userName: _footerUserName(),
      userLabel: config.isRTL ? 'المستخدم: ' : 'User: ',
      printTime: config.isRTL
          ? 'تاريخ الإصدار: ${customization.formatDate(meta.issueDate)}'
          : 'Issue date: ${customization.formatDate(meta.issueDate)}',
      showPageNumber: true,
      pageNumberFormat: customization.pageNumberFormat,
    );
  }

  String _footerUserName() {
    final name = meta.exportingUserName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final number = meta.exportingUserNumber?.trim();
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

  void _drawReportDetails(
    List<TransactionTransferRow> filteredRows,
    List<TransactionTransferGroup> groups,
  ) {
    final currencies = filteredRows.map((row) => row.currencyId).toSet().toList()
      ..sort();
    final serviceIds = filteredRows.map((row) => row.serviceId).toSet();
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
        value: _periodLabel(),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Currencies',
        labelAr: 'العملات',
        value: currencies.isEmpty ? '-' : currencies.join(', '),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Transactions',
        labelAr: 'عدد العمليات',
        value: '${groups.length}',
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Accounting Legs',
        labelAr: 'عدد أطراف القيود',
        value: '${filteredRows.length}',
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Services',
        labelAr: 'الخدمات',
        value: '${serviceIds.length}',
      ),
    ];

    final detailItems = customization.buildDetails(
      TransactionTransferDetailSection.report,
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
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 118),
    );
    addSpace(result.height + 12);
  }

  String _periodLabel() {
    final start = configuration.periodStart;
    final end = configuration.periodEnd;
    if (start != null && end != null) return '${customization.formatDate(start)} — ${customization.formatDate(end)}';
    if (start != null) return config.isRTL ? 'من ${customization.formatDate(start)}' : 'From ${customization.formatDate(start)}';
    if (end != null) return config.isRTL ? 'حتى ${customization.formatDate(end)}' : 'Through ${customization.formatDate(end)}';
    return config.isRTL ? 'جميع الفترات' : 'All dates';
  }

  void _drawTransfersTable(List<TransactionTransferRow> filteredRows) {
    _drawSectionTitle('Transaction Transfers', 'حركات التحويلات');
    final gridRows = <GeniusPdfGridRow>[];
    final currencies = filteredRows.map((row) => row.currencyId).toSet().toList()
      ..sort();

    for (final currency in currencies) {
      gridRows.add(GeniusPdfGridRow.groupHeader(currency));
      final currencyRows = filteredRows
          .where((row) => row.currencyId == currency)
          .toList()
        ..sort((a, b) {
          final byDate = b.createdAt.compareTo(a.createdAt);
          if (byDate != 0) return byDate;
          final byService = a.serviceId.compareTo(b.serviceId);
          if (byService != 0) return byService;
          final byTransaction = a.transactionId.compareTo(b.transactionId);
          if (byTransaction != 0) return byTransaction;
          return a.id.compareTo(b.id);
        });

      // Each source accounting leg is rendered independently. This guarantees
      // that a table row names exactly one affected account.
      gridRows.addAll(currencyRows.map(_transferRow));

      if (configuration.showTotals) {
        final debit = currencyRows.fold<double>(
          0,
          (sum, row) => sum + row.debitAmount,
        );
        final credit = currencyRows.fold<double>(
          0,
          (sum, row) => sum + row.creditAmount,
        );
        gridRows.add(
          GeniusPdfGridRow.total(<String, dynamic>{
            'reference': config.isRTL ? 'إجمالي $currency' : '$currency Total',
            'debit': debit,
            'credit': credit,
          }),
        );
      }
    }

    _drawGrid(
      _columns(),
      gridRows,
      style: customization.gridStyle,
    );
  }

  List<GeniusPdfGridColumn> _columns() {
    final defaultColumns = <GeniusPdfGridColumn>[
        GeniusPdfGridColumn.date(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
          width: 68,
          dateFormat: 'yyyy-MM-dd',
        ),
        const GeniusPdfGridColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
          width: 68,
          wrapText: true,
        ),
        const GeniusPdfGridColumn(
          id: 'service',
          title: 'Service',
          titleAr: 'الخدمة',
          width: 112,
          wrapText: true,
        ),
        const GeniusPdfGridColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 10,
          wrapText: true,
        ),
        GeniusPdfGridColumn.currency(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          width: 76,
          currencySymbol: '',
          cellStyle: _debitCellStyle(configuration.amountColors),
        ),
        GeniusPdfGridColumn.currency(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          width: 76,
          currencySymbol: '',
          cellStyle: _creditCellStyle(configuration.amountColors),
        ),
        const GeniusPdfGridColumn(
          id: 'note',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 12,
          wrapText: true,
        ),
    ];
    return customization.buildColumns(
      TransactionTransferGridKind.transfers,
      defaultColumns,
    );
  }

  GeniusPdfGridRow _transferRow(TransactionTransferRow row) {
    final defaultRow = GeniusPdfGridRow(cells: <String, dynamic>{
      'date': row.createdAt,
      'reference': '${row.serviceId}/${row.transactionId}',
      'service': _serviceLabel(row.serviceId),
      'account': _accountLabel(row.accountId),
      'debit': row.debitAmount,
      'credit': row.creditAmount,
      'note': _descriptionLabel(row),
    });
    return customization.buildRow(
      TransactionTransferGridKind.transfers,
      row,
      defaultRow,
    );
  }

  String _descriptionLabel(TransactionTransferRow row) {
    final custom = customization.descriptionBuilder;
    if (custom != null) return custom(row, config.isRTL);
    final type = row.description.isCommission
        ? (config.isRTL ? 'عمولة' : 'Commission')
        : (config.isRTL ? 'تحويل' : 'Transfer');
    final note = row.description.note?.trim() ?? '';
    return note.isEmpty ? type : '$type — $note';
  }

  String _serviceLabel(int serviceId) {
    final service = services[serviceId];
    final custom = customization.serviceLabelBuilder;
    if (custom != null) return custom(serviceId, service, config.isRTL);
    if (service == null) {
      return config.isRTL ? 'خدمة #$serviceId' : 'Service #$serviceId';
    }
    final name = service.displayName(isRtl: config.isRTL);
    final symbol = service.extensionSymbol?.trim();
    return symbol == null || symbol.isEmpty ? name : '$name ($symbol)';
  }

  String _accountLabel(int accountId) {
    final info = accountDirectory[accountId];
    final custom = customization.accountLabelBuilder;
    if (custom != null) return custom(accountId, info, config.isRTL);
    if (info == null) return '#$accountId';
    return '${info.displayName(isRtl: config.isRTL)} (#$accountId)';
  }

  void _drawFooterSection() {
    final hasQr = showQRCode && reportId != null && reportId!.trim().isNotEmpty;
    if (!showNotes && !hasQr) return;
    if (remainingHeight < 125 && currentY > headerHeight) newPage();
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
      leftContent: (page, bounds) => config.isLTR
          ? _drawNotesContent(page, bounds)
          : _drawQRCodeContent(page, bounds),
      rightContent: (page, bounds) => config.isLTR
          ? _drawQRCodeContent(page, bounds)
          : _drawNotesContent(page, bounds),
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
    final text = config.isRTL
        ? (notesAr ?? notes ?? _defaultNotesAr)
        : (notes ?? notesAr ?? _defaultNotes);
    final result = PdfTextElement(
      text: text,
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
    addSpace(height + 10);
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    if (reportId == null || reportId!.trim().isEmpty) return 0;
    final id = reportId!.trim();
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
    GeniusPdfQRCodeGenerator.url(
      url: qrCodeUrl ?? 'https://localhost:443/report/$id',
      config: config,
      caption: null,
    ).draw(page: page, bounds: Rect.fromLTWH(x, y, qrSize, qrSize));
    return captionHeight + 5 + qrSize;
  }

  static const String _defaultNotes = '''Notes:
• Rows are grouped using Service ID + Transaction ID; Transaction ID alone is not globally unique.
• Debit/Credit direction follows the signed source amount: positive = debit, negative = credit.
• Commission rows are identified by description.type = commission.
• A non-zero Difference can indicate incomplete or unbalanced source legs and should be reviewed against the originating document.''';

  static const String _defaultNotesAr = '''ملاحظات:
• يتم تجميع الصفوف باستخدام رقم الخدمة + رقم العملية لأن رقم العملية وحده غير فريد في البيانات المصدرية.
• يعتمد اتجاه المدين/الدائن على إشارة المبلغ المصدر: الموجب مدين والسالب دائن.
• يتم تحديد صفوف العمولة من خلال description.type = commission.
• وجود فرق غير صفري قد يدل على أطراف مصدرية ناقصة أو غير متوازنة ويجب مراجعته مع المستند الأصلي.''';
}
