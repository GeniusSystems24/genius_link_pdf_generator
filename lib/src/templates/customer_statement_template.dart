import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridRow, PdfGridStyle, PdfGridColumn, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';
import '../extensions/color_extensions.dart';
import '../models/pdf_image.dart';

/// Transaction entry for customer statement.
class StatementTransaction {
  const StatementTransaction({
    required this.date,
    required this.description,
    this.descriptionAr,
    this.referenceNo,
    this.debit = 0,
    this.credit = 0,
    this.balance = 0,
  });

  final DateTime date;
  final String description;
  final String? descriptionAr;
  final String? referenceNo;
  final double debit;
  final double credit;
  final double balance;

  /// Gets the display description based on locale.
  String getDescription({bool isArabic = false}) {
    if (isArabic && descriptionAr != null) return descriptionAr!;
    return description;
  }
}

/// Aging analysis data.
class AgingAnalysis {
  const AgingAnalysis({
    this.current = 0,
    this.days1to30 = 0,
    this.days31to60 = 0,
    this.days61to90 = 0,
    this.over90 = 0,
  });

  final double current;
  final double days1to30;
  final double days31to60;
  final double days61to90;
  final double over90;

  double get total => current + days1to30 + days31to60 + days61to90 + over90;
}

/// Customer information for statement.
class StatementCustomer {
  const StatementCustomer({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.accountNumber,
    this.phone,
    this.email,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? accountNumber;
  final String? phone;
  final String? email;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && nameAr != null) return nameAr!;
    return name;
  }
}

/// Customer statement data.
class CustomerStatementData {
  const CustomerStatementData({
    required this.periodFrom,
    required this.periodTo,
    required this.transactions,
    this.openingBalance = 0,
    this.closingBalance = 0,
    this.aging,
    this.currency = 'SAR',
  });

  final DateTime periodFrom;
  final DateTime periodTo;
  final List<StatementTransaction> transactions;
  final double openingBalance;
  final double closingBalance;
  final AgingAnalysis? aging;
  final String currency;

  double get totalDebits => transactions.fold(0, (sum, t) => sum + t.debit);
  double get totalCredits => transactions.fold(0, (sum, t) => sum + t.credit);
}

/// A customer statement of account template.
///
/// Creates a detailed customer statement with:
/// - Customer and company information
/// - Transaction history
/// - Running balance
/// - Aging analysis
///
/// ## Example
/// ```dart
/// final statement = CustomerStatementTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   customer: customerInfo,
///   data: statementData,
/// );
///
/// final bytes = statement.generate();
/// ```
class CustomerStatementTemplate extends GeniusPdfDocumentBuilder {
  CustomerStatementTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.customer,
    required this.data,
    this.boldFont,
    this.showAging = true,
    this.showSignature = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final StatementCustomer customer;
  final CustomerStatementData data;
  final PdfFont? boldFont;
  final bool showAging;
  final bool showSignature;

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    newPage();

    // Header
    _drawHeader();

    // Customer and period info
    _drawInfoSection();

    // Transactions table
    _drawTransactionsTable();

    // Aging analysis
    if (showAging && data.aging != null) {
      _drawAgingAnalysis();
    }

    // Signature
    if (showSignature) {
      _drawSignature();
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Customer Statement of Account',
      titleAr: 'كشف حساب عميل',
      subtitle:
          'Period From: ${_formatDate(data.periodFrom)} To: ${_formatDate(data.periodTo)}',
      subtitleAr:
          'الفترة من: ${_formatDate(data.periodFrom)} إلى: ${_formatDate(data.periodTo)}',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    final height = header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(height + 10);
  }

  void _drawInfoSection() {
    final customerBox = GeniusPdfInfoBox(
      title: 'Customer Details',
      titleAr: 'تفاصيل العميل',
      items: [
        GeniusPdfLabeledValue(
          label: 'Customer Name',
          labelAr: 'اسم العميل',
          value: customer.getName(isArabic: config.isRTL),
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        if (customer.address != null)
          GeniusPdfLabeledValue(
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (customer.addressAr ?? customer.address!)
                : customer.address!,
            baseFont: baseFont,
            boldFont: _boldFont,
            isRTL: config.isRTL,
          ),
        if (customer.accountNumber != null)
          GeniusPdfLabeledValue(
            label: 'Account No',
            labelAr: 'رقم الحساب',
            value: customer.accountNumber!,
            baseFont: baseFont,
            boldFont: _boldFont,
            isRTL: config.isRTL,
          ),
        if (customer.phone != null)
          GeniusPdfLabeledValue(
            label: 'Phone',
            labelAr: 'رقم الهاتف',
            value: customer.phone!,
            baseFont: baseFont,
            boldFont: _boldFont,
            isRTL: config.isRTL,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final periodBox = GeniusPdfInfoBox(
      title: 'Statement Details',
      titleAr: 'تفاصيل الكشف',
      items: [
        GeniusPdfLabeledValue(
          label: 'Period From',
          labelAr: 'من تاريخ',
          value: _formatDate(data.periodFrom),
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        GeniusPdfLabeledValue(
          label: 'Period To',
          labelAr: 'إلى تاريخ',
          value: _formatDate(data.periodTo),
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        GeniusPdfLabeledValue(
          label: 'Opening Balance',
          labelAr: 'الرصيد الافتتاحي',
          value: _formatNumber(data.openingBalance),
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        GeniusPdfLabeledValue(
          label: 'Currency',
          labelAr: 'العملة',
          value: data.currency,
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: config.isRTL ? periodBox : customerBox,
      rightBox: config.isRTL ? customerBox : periodBox,
      spacing: 20,
    );

    final result = dualBox.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 100),
    );

    addSpace(result.height + 15);
  }

  void _drawTransactionsTable() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'date',
        title: 'Date',
        titleAr: 'التاريخ',
        width: 70,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'ref',
        title: 'Ref No.',
        titleAr: 'رقم المرجع',
        width: 70,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'description',
        title: 'Description',
        titleAr: 'الوصف',
        flexFactor: 2,
      ),
      GeniusPdfGridColumn.currency(
        id: 'debit',
        title: 'Debit',
        titleAr: 'مدين',
        width: 80,
        currencySymbol: '',
      ),
      GeniusPdfGridColumn.currency(
        id: 'credit',
        title: 'Credit',
        titleAr: 'دائن',
        width: 80,
        currencySymbol: '',
      ),
      GeniusPdfGridColumn.currency(
        id: 'balance',
        title: 'Balance',
        titleAr: 'الرصيد',
        width: 90,
        currencySymbol: '',
      ),
    ];

    final rows = <GeniusPdfGridRow>[];

    // Opening balance
    rows.add(GeniusPdfGridRow(
      cells: {
        'date': _formatDate(data.periodFrom),
        'ref': '-',
        'description': config.isRTL ? 'رصيد افتتاحي' : 'Opening Balance',
        'debit': data.openingBalance > 0 ? data.openingBalance : null,
        'credit': data.openingBalance < 0 ? -data.openingBalance : null,
        'balance': data.openingBalance,
      },
      style: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(0xFFF5F5F5),
      ),
    ));

    // Transactions
    for (final transaction in data.transactions) {
      rows.add(GeniusPdfGridRow(cells: {
        'date': _formatDate(transaction.date),
        'ref': transaction.referenceNo ?? '-',
        'description': transaction.getDescription(isArabic: config.isRTL),
        'debit': transaction.debit > 0 ? transaction.debit : null,
        'credit': transaction.credit > 0 ? transaction.credit : null,
        'balance': transaction.balance,
      }));
    }

    // Closing balance
    rows.add(GeniusPdfGridRow(
      cells: {
        'date': _formatDate(data.periodTo),
        'ref': '-',
        'description': config.isRTL ? 'الرصيد الختامي' : 'Closing Balance',
        'debit': null,
        'credit': null,
        'balance': data.closingBalance,
      },
      style: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(0xFFE8E8E8),
      ),
    ));

    final grid = GeniusPdfDataGrid(
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 15);
    }
  }

  void _drawAgingAnalysis() {
    final aging = data.aging!;

    // Draw aging title
    addLine(
      config.isRTL ? 'تحليل أعمار الذمم:' : 'Aging Analysis:',
      font: _boldFont,
      topMargin: 10,
    );

    addSpace(5);

    // Aging table
    final agingGrid = GeniusPdfDataGrid(
      columns: [
        const GeniusPdfGridColumn(
          id: 'period',
          title: '0-30 Days',
          titleAr: '0-30 يوم',
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: '31-60',
          title: '31-60 Days',
          titleAr: '31-60 يوم',
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: '61-90',
          title: '61-90 Days',
          titleAr: '61-90 يوم',
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'over90',
          title: '+90 Days',
          titleAr: '+90 يوم',
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.center,
        ),
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'period': _formatNumber(aging.days1to30),
          '31-60': _formatNumber(aging.days31to60),
          '61-90': _formatNumber(aging.days61to90),
          'over90': _formatNumber(aging.over90),
          'total': _formatNumber(aging.total),
        }),
      ],
      style: const GeniusPdfGridStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = agingGrid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 20);
    }
  }

  void _drawSignature() {
    final signature = GeniusPdfSignatureArea(
      title: 'Authorized Signature',
      titleAr: 'التوقيع المعتمد',
      baseFont: baseFont,
      isRTL: config.isRTL,
    );

    signature.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, pageHeight - 80, pageWidth, 60),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
