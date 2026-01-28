import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';
import '../models/pdf_image.dart';

/// Invoice line item data.
class InvoiceLineItem {
  const InvoiceLineItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.unit,
    this.discount = 0,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;

  double get lineTotal => (quantity * unitPrice) - discount;
}

/// Tax information for the invoice.
class InvoiceTax {
  const InvoiceTax({
    required this.name,
    required this.rate,
    this.nameAr,
  });

  final String name;
  final String? nameAr;
  final double rate; // as percentage (e.g., 15 for 15%)

  double calculate(double amount) => amount * (rate / 100);
}

/// Invoice data model.
class InvoiceData {
  const InvoiceData({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.items,
    this.poNumber,
    this.paymentTerms,
    this.paymentTermsAr,
    this.dueDate,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.currency = 'SAR',
  });

  final String invoiceNumber;
  final DateTime invoiceDate;
  final String? poNumber;
  final String? paymentTerms;
  final String? paymentTermsAr;
  final DateTime? dueDate;
  final List<InvoiceLineItem> items;
  final List<InvoiceTax> taxes;
  final String? notes;
  final String? notesAr;
  final String currency;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  double get totalTax =>
      taxes.fold(0, (sum, tax) => sum + tax.calculate(subtotal));

  double get grandTotal => subtotal + totalTax;
}

/// Customer information for the invoice.
class InvoiceCustomer {
  const InvoiceCustomer({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.vatNumber,
    this.phone,
    this.email,
    this.accountNumber,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? vatNumber;
  final String? phone;
  final String? email;
  final String? accountNumber;
}

/// A professional tax invoice template.
///
/// This template creates invoices compliant with Saudi Arabia's
/// ZATCA requirements, with bilingual support (Arabic/English).
///
/// ## Example
/// ```dart
/// final invoice = TaxInvoiceTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   customer: customerInfo,
///   invoice: invoiceData,
///   qrCode: qrCodeImage,
/// );
///
/// final bytes = invoice.generate();
/// ```
class TaxInvoiceTemplate extends GeniusPdfDocumentBuilder {
  TaxInvoiceTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.customer,
    required this.invoice,
    this.qrCode,
    this.boldFont,
    this.showQRCode = true,
    this.showSignature = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final InvoiceCustomer customer;
  final InvoiceData invoice;
  final GeniusPdfImage? qrCode;
  final PdfFont? boldFont;
  final bool showQRCode;
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

    // Customer and Invoice Info boxes
    _drawInfoSection();

    // Items table
    _drawItemsTable();

    // Summary and totals
    _drawSummary();

    // Amount in words
    _drawAmountInWords();

    // VAT breakdown
    _drawVatBreakdown();

    // QR Code and Signature
    _drawFooterSection();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(100);
  }

  void _drawInfoSection() {
    final customerBox = GeniusPdfInfoBox(
      title: 'To',
      titleAr: 'إلى',
      items: [
        GeniusPdfLabeledValue(
          label: 'Customer Name',
          labelAr: 'اسم العميل',
          value:
              config.isRTL ? (customer.nameAr ?? customer.name) : customer.name,
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        if (customer.address != null || customer.addressAr != null)
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
        if (customer.vatNumber != null)
          GeniusPdfLabeledValue(
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: customer.vatNumber!,
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

    final invoiceBox = GeniusPdfInfoBox(
      title: 'Invoice Details',
      titleAr: 'بيانات الفاتورة',
      items: [
        GeniusPdfLabeledValue(
          label: 'Invoice No',
          labelAr: 'رقم الفاتورة',
          value: invoice.invoiceNumber,
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        GeniusPdfLabeledValue(
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(invoice.invoiceDate),
          baseFont: baseFont,
          boldFont: _boldFont,
          isRTL: config.isRTL,
        ),
        if (invoice.paymentTerms != null)
          GeniusPdfLabeledValue(
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (invoice.paymentTermsAr ?? invoice.paymentTerms!)
                : invoice.paymentTerms!,
            baseFont: baseFont,
            boldFont: _boldFont,
            isRTL: config.isRTL,
          ),
        if (invoice.poNumber != null)
          GeniusPdfLabeledValue(
            label: 'PO No',
            labelAr: 'رقم الطلب',
            value: invoice.poNumber!,
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
      leftBox: config.isRTL ? invoiceBox : customerBox,
      rightBox: config.isRTL ? customerBox : invoiceBox,
      spacing: 20,
    );

    final result = dualBox.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY + 10, pageWidth, 150),
    );

    addSpace(result.height + 20);
  }

  void _drawItemsTable() {
    final grid = GeniusPdfDataGrid(
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: 'No.',
          titleAr: 'رقم',
          width: 35,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
          flexFactor: 3,
        ),
        const GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Price',
          titleAr: 'السعر',
          width: 80,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 90,
          currencySymbol: '',
        ),
      ],
      rows: invoice.items
          .map((item) => GeniusPdfGridRow(cells: {
                'no': item.itemNumber,
                'item': config.isRTL
                    ? (item.descriptionAr ?? item.description)
                    : item.description,
                'qty': item.quantity,
                'price': item.unitPrice,
                'total': item.lineTotal,
              }))
          .toList(),
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

  void _drawSummary() {
    final items = <GeniusPdfSummaryItem>[
      GeniusPdfSummaryItem.subtotal(
        label: 'Subtotal',
        labelAr: 'الإجمالي قبل الضريبة',
        value: _formatCurrency(invoice.subtotal),
      ),
    ];

    // Add each tax
    for (final tax in invoice.taxes) {
      items.add(GeniusPdfSummaryItem(
        label: '${tax.name} (${tax.rate}%)',
        labelAr: '${tax.nameAr ?? tax.name} (${tax.rate}%)',
        value: _formatCurrency(tax.calculate(invoice.subtotal)),
      ));
    }

    items.add(GeniusPdfSummaryItem.total(
      label: 'Total Amount',
      labelAr: 'الإجمالي الكلي',
      value: _formatCurrency(invoice.grandTotal),
    ));

    final summary = GeniusPdfSummarySection(
      items: items,
      style: const GeniusPdfSummaryStyle.bordered(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.4,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );

    addSpace(result.height + 15);
  }

  void _drawAmountInWords() {
    final amountInWords = _numberToWords(invoice.grandTotal, invoice.currency);
    final amountInWordsAr =
        _numberToWordsArabic(invoice.grandTotal, invoice.currency);

    final richText = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    )
        .bold(config.isRTL ? 'فقط ' : 'Total in Words: ')
        .text(config.isRTL ? amountInWordsAr : amountInWords)
        .build();

    richText.drawSimple(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 30),
    );

    addSpace(25);
  }

  void _drawVatBreakdown() {
    if (invoice.taxes.isEmpty) return;

    final vatText = config.isRTL
        ? 'تفصيل الضريبة: الإجمالي الخاضع (${_formatCurrency(invoice.subtotal)}), مبلغ الضريبة (${_formatCurrency(invoice.totalTax)})'
        : 'VAT Breakdown: Taxable Amount (${_formatCurrency(invoice.subtotal)}), VAT Amount (${_formatCurrency(invoice.totalTax)})';

    addLine(
      vatText,
      font: baseFont,
      topMargin: 5,
    );

    addSpace(15);
  }

  void _drawFooterSection() {
    final bottomY = pageHeight - 80;

    // Signature area on the left
    if (showSignature) {
      final signature = GeniusPdfSignatureArea(
        title: 'Authorized Signature',
        titleAr: 'التوقيع المعتمد',
        baseFont: baseFont,
        isRTL: config.isRTL,
      );

      signature.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          config.isRTL ? pageWidth - 200 : 0,
          bottomY,
          200,
          60,
        ),
      );
    }

    // QR Code on the right
    if (showQRCode && qrCode != null) {
      final qr = GeniusPdfQRCode(
        image: qrCode!,
        size: 70,
        baseFont: baseFont,
        isRTL: config.isRTL,
      );

      qr.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          config.isRTL ? 0 : pageWidth - 80,
          bottomY,
          80,
          90,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${invoice.currency}';
  }

  String _numberToWords(double amount, String currency) {
    final wholePart = amount.floor();
    final fractionalPart = ((amount - wholePart) * 100).round();
    final wholeWords = _convertWholeToEnglish(wholePart);
    final currencyName = _getCurrencyName(currency);
    final subName = _getSubCurrencyName(currency);
    if (fractionalPart > 0) {
      final fracWords = _convertWholeToEnglish(fractionalPart);
      return '$wholeWords $currencyName and $fracWords $subName Only';
    }
    return '$wholeWords $currencyName Only';
  }

  String _numberToWordsArabic(double amount, String currency) {
    final wholePart = amount.floor();
    final fractionalPart = ((amount - wholePart) * 100).round();
    final wholeWords = _convertWholeToArabic(wholePart);
    if (fractionalPart > 0) {
      final fracWords = _convertWholeToArabic(fractionalPart);
      return '$wholeWords ريالاً و $fracWords هللة لا غير';
    }
    return '$wholeWords ريالاً سعودياً لا غير';
  }

  static String _getCurrencyName(String code) {
    const names = {
      'SAR': 'Saudi Riyals',
      'USD': 'US Dollars',
      'EUR': 'Euros',
      'GBP': 'British Pounds',
      'AED': 'UAE Dirhams',
    };
    return names[code] ?? code;
  }

  static String _getSubCurrencyName(String code) {
    const names = {
      'SAR': 'Halalas',
      'USD': 'Cents',
      'EUR': 'Cents',
      'GBP': 'Pence',
      'AED': 'Fils',
    };
    return names[code] ?? 'units';
  }

  static String _convertWholeToEnglish(int number) {
    if (number == 0) return 'Zero';

    const ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
      'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen',
    ];
    const tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy',
      'Eighty', 'Ninety',
    ];

    String convert(int n) {
      if (n == 0) return '';
      if (n < 20) return ones[n];
      if (n < 100) {
        final remainder = n % 10;
        return '${tens[n ~/ 10]}${remainder > 0 ? ' ${ones[remainder]}' : ''}';
      }
      if (n < 1000) {
        final remainder = n % 100;
        return '${ones[n ~/ 100]} Hundred${remainder > 0 ? ' and ${convert(remainder)}' : ''}';
      }
      if (n < 1000000) {
        final remainder = n % 1000;
        return '${convert(n ~/ 1000)} Thousand${remainder > 0 ? ' ${convert(remainder)}' : ''}';
      }
      if (n < 1000000000) {
        final remainder = n % 1000000;
        return '${convert(n ~/ 1000000)} Million${remainder > 0 ? ' ${convert(remainder)}' : ''}';
      }
      final remainder = n % 1000000000;
      return '${convert(n ~/ 1000000000)} Billion${remainder > 0 ? ' ${convert(remainder)}' : ''}';
    }

    return convert(number);
  }

  static String _convertWholeToArabic(int number) {
    if (number == 0) return 'صفر';

    const ones = [
      '', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة',
      'ثمانية', 'تسعة', 'عشرة', 'أحد عشر', 'اثنا عشر', 'ثلاثة عشر',
      'أربعة عشر', 'خمسة عشر', 'ستة عشر', 'سبعة عشر', 'ثمانية عشر',
      'تسعة عشر',
    ];
    const tensAr = [
      '', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون', 'ستون', 'سبعون',
      'ثمانون', 'تسعون',
    ];
    const hundreds = [
      '', 'مائة', 'مائتان', 'ثلاثمائة', 'أربعمائة', 'خمسمائة', 'ستمائة',
      'سبعمائة', 'ثمانمائة', 'تسعمائة',
    ];

    String convert(int n) {
      if (n == 0) return '';
      if (n < 20) return ones[n];
      if (n < 100) {
        final remainder = n % 10;
        if (remainder == 0) return tensAr[n ~/ 10];
        return '${ones[remainder]} و ${tensAr[n ~/ 10]}';
      }
      if (n < 1000) {
        final remainder = n % 100;
        if (remainder == 0) return hundreds[n ~/ 100];
        return '${hundreds[n ~/ 100]} و ${convert(remainder)}';
      }
      if (n < 1000000) {
        final thousands = n ~/ 1000;
        final remainder = n % 1000;
        final thousandWord = thousands == 1
            ? 'ألف'
            : thousands == 2
                ? 'ألفان'
                : '${convert(thousands)} آلاف';
        if (remainder == 0) return thousandWord;
        return '$thousandWord و ${convert(remainder)}';
      }
      if (n < 1000000000) {
        final millions = n ~/ 1000000;
        final remainder = n % 1000000;
        final millionWord = millions == 1
            ? 'مليون'
            : millions == 2
                ? 'مليونان'
                : '${convert(millions)} ملايين';
        if (remainder == 0) return millionWord;
        return '$millionWord و ${convert(remainder)}';
      }
      final billions = n ~/ 1000000000;
      final remainder = n % 1000000000;
      final billionWord = billions == 1
          ? 'مليار'
          : billions == 2
              ? 'ملياران'
              : '${convert(billions)} مليارات';
      if (remainder == 0) return billionWord;
      return '$billionWord و ${convert(remainder)}';
    }

    return convert(number);
  }
}
