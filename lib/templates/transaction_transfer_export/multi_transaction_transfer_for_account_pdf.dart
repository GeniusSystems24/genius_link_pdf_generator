import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../src/components/components.dart';
import '../../src/core/pdf_config.dart';
import '../../src/families/erp/erp_families.dart';
import 'models.dart';

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

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

extension _AccountTransactionTransferBuilderSupport on GeniusPdfDocumentBuilder {
  void _drawGrid(
    List<GeniusPdfGridColumn> columns,
    List<GeniusPdfGridRow> rows, {
    double spacing = 10,
  }) {
    if (rows.isEmpty) return;
    final result = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
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

/// Landscape PDF report of transaction-transfer movements for one account.
///
/// This template filters the source dataset by [accountId] and renders one row
/// per matching accounting leg. It does not invent opening/closing balances,
/// because the supplied transaction-transfer JSON contains movements only.
///
/// Counter-account display uses both `description.debitAccounts` and
/// `description.creditAccounts` without treating either array as the source of
/// truth for the current row direction. Debit/Credit direction follows the
/// signed `amount` field instead.
class MultiTransactionTransferForAccountPdf extends GeniusErpRegisterDocument {
  /// Creates a transaction-transfer movement report for [accountId].
  MultiTransactionTransferForAccountPdf({
    required GeniusPdfConfig config,
    required this.meta,
    required this.rows,
    required this.accountId,
    this.account,
    this.services = const <int, TransactionTransferServiceInfo>{},
    this.accountDirectory = const <int, TransactionTransferAccountInfo>{},
    this.company,
    this.configuration = const TransactionTransferReportConfiguration(),
    this.openingBalances = const <String, double>{},
    this.reportId,
    this.qrCodeUrl,
    this.showQRCode = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config.copyWith(orientation: PdfPageOrientation.landscape));

  /// Report title, issue date, and exporting-user metadata.
  final TransactionTransferDocumentMeta meta;

  /// Raw transaction-transfer rows before filtering by [accountId].
  final List<TransactionTransferRow> rows;

  /// Account whose transfer movements are rendered.
  final int accountId;

  /// Optional primary account information.
  final TransactionTransferAccountInfo? account;

  /// Optional service lookup typically parsed from `services.json`.
  final Map<int, TransactionTransferServiceInfo> services;

  /// Optional account-name lookup for counterpart accounts.
  final Map<int, TransactionTransferAccountInfo> accountDirectory;

  /// Optional company information for the header.
  final GeniusPdfCompanyInfo? company;

  /// Shared period/currency/service/status filters and amount colors.
  final TransactionTransferReportConfiguration configuration;

  /// Opening account balance keyed by currency code.
  ///
  /// Values use the same signed convention as transaction rows: positive
  /// values are debit balances and negative values are credit balances.
  /// The source transaction-transfer JSON does not contain opening balances,
  /// so callers should provide the ledger balance immediately before
  /// [TransactionTransferReportConfiguration.periodStart]. When a currency
  /// is present in the report but absent from this map, the opening row is
  /// still rendered with blank amount cells and an explanatory note.
  final Map<String, double> openingBalances;

  /// Stable report identifier displayed by the QR section.
  final String? reportId;

  /// Optional URL encoded by the QR code.
  final String? qrCodeUrl;

  /// Whether the QR block is shown.
  final bool showQRCode;

  /// Whether report notes are shown.
  final bool showNotes;

  /// Optional LTR notes.
  final String? notes;

  /// Optional Arabic notes.
  final String? notesAr;


  @override
  void build() {
    _addRepeatingFooter();
    newPage();
    _drawHeader();
    final filteredRows = _filteredRows();
    _drawAccountDetails(filteredRows);
    _drawMovementTable(filteredRows);
    _drawFooterSection();
  }

  List<TransactionTransferRow> _filteredRows() => rows
      .where((row) => row.accountId == accountId)
      .where(configuration.includes)
      .toList(growable: false)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void _addRepeatingFooter() {
    addFooter(
      userName: _footerUserName(),
      userLabel: config.isRTL ? 'المستخدم: ' : 'User: ',
      printTime: config.isRTL
          ? 'تاريخ الإصدار: ${_date(meta.issueDate)}'
          : 'Issue date: ${_date(meta.issueDate)}',
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
      bounds: Rect.fromLTWH(0, 0, pageWidth, 116),
    );
    addSpace(height + 12);
  }

  void _drawAccountDetails(List<TransactionTransferRow> filteredRows) {
    final accountInfo = account ?? accountDirectory[accountId];
    final currencies = filteredRows.map((row) => row.currencyId).toSet().toList()
      ..sort();
    final transactions = filteredRows.map((row) => row.compositeTransactionKey).toSet();
    final serviceIds = filteredRows.map((row) => row.serviceId).toSet();

    final values = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Account No.',
        labelAr: 'رقم الحساب',
        value: '$accountId',
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Account Name',
        labelAr: 'اسم الحساب',
        value: accountInfo?.displayName(isRtl: config.isRTL) ?? '-',
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
        value: '${transactions.length}',
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Services',
        labelAr: 'الخدمات',
        value: '${serviceIds.length}',
      ),
    ];

    final box = GeniusPdfInfoBox(
      config: config,
      title: 'Account Transfer Details',
      titleAr: 'تفاصيل تحويلات الحساب',
      items: values,
      columns: 3,
      columnSpacing: 14,
      style: GeniusPdfInfoBoxStyle.minimal(),
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
    if (start != null && end != null) return '${_date(start)} — ${_date(end)}';
    if (start != null) return config.isRTL ? 'من ${_date(start)}' : 'From ${_date(start)}';
    if (end != null) return config.isRTL ? 'حتى ${_date(end)}' : 'Through ${_date(end)}';
    return config.isRTL ? 'جميع الفترات' : 'All dates';
  }

  void _drawMovementTable(List<TransactionTransferRow> filteredRows) {
    _drawSectionTitle('Account Transfer Movements', 'حركات تحويلات الحساب');
    final gridRows = <GeniusPdfGridRow>[];
    final currencies = <String>{
      ...filteredRows.map((row) => row.currencyId),
      ...openingBalances.keys,
    }.toList()
      ..sort();

    for (final currency in currencies) {
      gridRows.add(GeniusPdfGridRow.groupHeader(currency));
      gridRows.add(_openingBalanceRow(currency));

      final currencyRows = filteredRows
          .where((row) => row.currencyId == currency)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // A true running balance can only be derived when the caller provides
      // the opening balance for the currency. Keep it blank otherwise rather
      // than silently assuming a zero opening balance.
      double? runningBalance = openingBalances[currency];
      for (final row in currencyRows) {
        if (runningBalance != null) {
          runningBalance += row.amount;
        }
        gridRows.add(
          _movementRow(row, currentBalance: runningBalance),
        );
      }

      if (configuration.showTotals && currencyRows.isNotEmpty) {
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
            'reference': config.isRTL ? 'إجمالي الحركة' : 'Movement Total',
            'debit': debit,
            'credit': credit,
            'currentBalance': runningBalance,
          }),
        );
      }
    }

    _drawGrid(_columns(), gridRows);
  }

  List<GeniusPdfGridColumn> _columns() => <GeniusPdfGridColumn>[
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
          width: 82,
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
          id: 'counterAccounts',
          title: 'Counter Accounts',
          titleAr: 'الحسابات المقابلة',
          flexFactor: 9,
          wrapText: true,
        ),
        GeniusPdfGridColumn.currency(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          width: 78,
          currencySymbol: '',
          cellStyle: _debitCellStyle(configuration.amountColors),
        ),
        GeniusPdfGridColumn.currency(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          width: 78,
          currencySymbol: '',
          cellStyle: _creditCellStyle(configuration.amountColors),
        ),
        GeniusPdfGridColumn.currency(
          id: 'currentBalance',
          title: 'Current Balance',
          titleAr: 'الرصيد الحالي',
          width: 88,
          currencySymbol: '',
        ),
        const GeniusPdfGridColumn(
          id: 'note',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 10,
          wrapText: true,
        ),
      ];

  GeniusPdfGridRow _openingBalanceRow(String currency) {
    final openingBalance = openingBalances[currency];
    final hasBalance = openingBalance != null;
    final debit = openingBalance != null && openingBalance >= 0
        ? openingBalance
        : null;
    final credit = openingBalance != null && openingBalance < 0
        ? openingBalance.abs()
        : null;

    return GeniusPdfGridRow.subtotal(<String, dynamic>{
      'date': configuration.periodStart,
      'reference': config.isRTL ? 'رصيد افتتاحي' : 'Opening Balance',
      'service': '-',
      'counterAccounts': '-',
      'debit': debit,
      'credit': credit,
      'currentBalance': openingBalance,
      'note': hasBalance
          ? (config.isRTL ? 'رصيد افتتاحي' : 'Opening balance')
          : (config.isRTL
              ? 'لم يتم توفير الرصيد الافتتاحي لهذه العملة'
              : 'Opening balance was not provided for this currency'),
    });
  }

  GeniusPdfGridRow _movementRow(
    TransactionTransferRow row, {
    required double? currentBalance,
  }) {
    return GeniusPdfGridRow(cells: <String, dynamic>{
      'date': row.createdAt,
      'reference': '${row.serviceId}/${row.transactionId}',
      'service': _serviceLabel(row.serviceId),
      'counterAccounts': _counterAccountsLabel(row),
      'debit': row.debitAmount,
      'credit': row.creditAmount,
      'currentBalance': currentBalance,
      'note': _descriptionLabel(row),
    });
  }

  String _descriptionLabel(TransactionTransferRow row) {
    final type = row.description.isCommission
        ? (config.isRTL ? 'عمولة' : 'Commission')
        : (config.isRTL ? 'تحويل' : 'Transfer');
    final note = row.description.note?.trim() ?? '';
    return note.isEmpty ? type : '$type — $note';
  }

  String _counterAccountsLabel(TransactionTransferRow row) {
    final refs = row.description.counterAccounts;
    if (refs.isEmpty) return '-';
    final seen = <String>{};
    final labels = <String>[];
    for (final ref in refs) {
      final key = '${ref.accountId}:${ref.currencyId}:${ref.amount}';
      if (!seen.add(key)) continue;
      final info = accountDirectory[ref.accountId];
      final accountLabel = info == null
          ? '#${ref.accountId}'
          : '${info.displayName(isRtl: config.isRTL)} (#${ref.accountId})';
      labels.add('$accountLabel — ${_amount(ref.amount)} ${ref.currencyId}');
    }
    return labels.join('\n');
  }

  String _serviceLabel(int serviceId) {
    final service = services[serviceId];
    if (service == null) {
      return config.isRTL ? 'خدمة #$serviceId' : 'Service #$serviceId';
    }
    final name = service.displayName(isRtl: config.isRTL);
    final symbol = service.extensionSymbol?.trim();
    return symbol == null || symbol.isEmpty ? name : '$name ($symbol)';
  }

  String _amount(double value) => value.toStringAsFixed(2);

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
• This report shows transaction-transfer movements recorded against the selected account; it is not an account balance statement.
• Debit/Credit direction follows the signed source amount: positive = debit, negative = credit.
• Counter accounts come from the source description arrays and are displayed for traceability without redefining accounting direction.
• Source documents should be reviewed for any incomplete transfer whose matching accounting leg is not present in the dataset.''';

  static const String _defaultNotesAr = '''ملاحظات:
• يعرض هذا التقرير حركات التحويل المسجلة على الحساب المحدد ولا يمثل كشف رصيد للحساب.
• يعتمد اتجاه المدين/الدائن على إشارة المبلغ المصدر: الموجب مدين والسالب دائن.
• يتم عرض الحسابات المقابلة من مصفوفات الوصف المصدرية لأغراض التتبع دون استخدامها لإعادة تحديد اتجاه القيد.
• يجب الرجوع إلى المستند المصدر عند وجود حوالة ناقصة لا تتوفر جميع أطرافها المحاسبية في البيانات.''';
}
