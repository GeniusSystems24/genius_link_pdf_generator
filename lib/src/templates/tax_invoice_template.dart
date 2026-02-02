import 'dart:ui';
import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
    this.showQRCode = true,
    this.showSignature = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final InvoiceCustomer customer;
  final InvoiceData invoice;
  final GeniusPdfImage? qrCode;
  final bool showQRCode;
  final bool showSignature;

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

    // Draw Footer Section (Notes + QR Code)
    _drawFooterSection();

    // Signature
    _drawSignature();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      company: company,
      printDate: DateTime.now(),
      config: config.copyWith(textDirection: m.TextDirection.ltr),
      style: const GeniusPdfReportHeaderStyle.classic(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(100);
  }

  void _drawInfoSection() {
    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'To',
      titleAr: 'إلى',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Customer Name',
          labelAr: 'اسم العميل',
          value:
              config.isRTL ? (customer.nameAr ?? customer.name) : customer.name,
        ),
        if (customer.address != null || customer.addressAr != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (customer.addressAr ?? customer.address!)
                : customer.address!,
          ),
        if (customer.vatNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: customer.vatNumber!,
          ),
        if (customer.phone != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Phone',
            labelAr: 'رقم الهاتف',
            value: customer.phone!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final invoiceBox = GeniusPdfInfoBox(
      config: config,
      title: 'Invoice Details',
      titleAr: 'بيانات الفاتورة',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Invoice No',
          labelAr: 'رقم الفاتورة',
          value: invoice.invoiceNumber,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(invoice.invoiceDate),
        ),
        if (invoice.paymentTerms != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (invoice.paymentTermsAr ?? invoice.paymentTerms!)
                : invoice.paymentTerms!,
          ),
        if (invoice.poNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'PO No',
            labelAr: 'رقم الطلب',
            value: invoice.poNumber!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
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
      config: config,
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
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      // Update current page and Y position from the grid result
      // This handles multi-page grids correctly in both RTL and LTR modes
      updateFromLayoutResult(result, spacing: 15);
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
      config: config,
      items: items,
      style: const GeniusPdfSummaryStyle.bordered(),
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
      config: config,
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
    if (!showQRCode) {
      if (invoice.notes != null || invoice.notesAr != null) {
        _drawNotes(width: pageWidth);
      }
      return;
    }

    addSpace(20);

    // Notes Section check
    final hasNotes = invoice.notes != null || invoice.notesAr != null;

    if (!hasNotes && showQRCode) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    if (hasNotes && !showQRCode) {
      _drawNotes(width: pageWidth);
      return;
    }

    // Draw side-by-side if both are present
    // LTR: Notes (2/3) | QR (1/3)
    addTwoColumns(
      spacing: 10,
      leftFlex: config.isLTR ? 2 : 1,
      rightFlex: config.isLTR ? 1 : 2,
      leftContent: (page, bounds) {
        if (config.isLTR) {
          return _drawNotesContent(page, bounds);
        } else {
          return _drawQRCodeContent(page, bounds);
        }
      },
      rightContent: (page, bounds) {
        if (config.isLTR) {
          return _drawQRCodeContent(page, bounds);
        } else {
          return _drawNotesContent(page, bounds);
        }
      },
    );

    addSpace(20);
  }

  void _drawNotes({required double width}) {
    _drawNotesContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes =
        invoice.notes ?? (config.isRTL ? invoice.notesAr : invoice.notes);
    final defaultNotes = config.isRTL ? 'ملاحظات:' : 'Notes:';

    final notesText =
        displayNotes != null ? '$defaultNotes\n$displayNotes' : null;

    if (notesText == null) return 0;

    final font = config.baseFont;
    final element = PdfTextElement(
      text: notesText,
      font: font,
      format: config.isLTR
          ? null
          : PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right),
    );

    final result = element.draw(
      page: page,
      bounds: bounds,
    );

    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeSection({required double width}) {
    _drawQRCodeContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    if (qrCode == null && !showQRCode) return 0;

    // Use passed QR code image or generate URL QR if needed, but template takes nullable image
    // If qrCode is provided as image, we use it.
    // If not, we generate standard URL QR.

    // For this template, `qrCode` is `GeniusPdfImage?`.
    // We should prefer that if available, otherwise fallback to URL generation logic
    // similar to inventory/trial balance if distinct logic is needed.
    // However, existing `_drawQRCodeSection` used `_drawQRCodeSection` (logic below) which used URL generation
    // BUT the property `qrCode` exists in class.
    // OLD code: `final qrUrl = 'https://localhost:443/invoice/${invoice.invoiceNumber}';`
    // It ignored `this.qrCode` property? Let's check old code again.
    // Old code generated URL. The property `qrCode` seems unused/optional override.
    // I will stick to URL generation for consistency with old code, unless `qrCode` image is set.

    if (qrCode != null) {
      // Draw image
      // Center it
      final size = 80.0;
      final x = bounds.left + (bounds.width - size) / 2;
      return _drawQRImage(page, x, bounds.top, size);
    }

    final qrUrl = 'https://localhost:443/invoice/${invoice.invoiceNumber}';
    final caption = 'ID: ${invoice.invoiceNumber}';

    final captionFont = config.baseFont;
    final captionLayout = PdfTextElement(
      text: caption,
      font: captionFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.isRTL
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0));

    final captionHeight = captionLayout?.bounds.height ?? 0;
    final qrSize = 80.0;
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
  }

  double _drawQRImage(PdfPage page, double x, double y, double size) {
    if (qrCode == null) return 0;
    final image = qrCode!;
    page.graphics.drawImage(
      PdfBitmap(image.data),
      Rect.fromLTWH(x, y, size, size),
    );
    return size;
  }

  void _drawSignature() {
    final bottomY = pageHeight - 80;

    // Signature area on the left
    if (showSignature) {
      final signature = GeniusPdfSignatureArea(
        config: config,
        title: 'Authorized Signature',
        titleAr: 'التوقيع المعتمد',
        showDate: false,
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
    final currencyName = _getArabicCurrencyName(currency);
    final subName = _getArabicSubCurrencyName(currency);
    if (fractionalPart > 0) {
      final fracWords = _convertWholeToArabic(fractionalPart);
      return '$wholeWords $currencyName و $fracWords $subName لا غير';
    }
    return '$wholeWords $currencyName لا غير';
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

  static String _getArabicCurrencyName(String code) {
    const names = {
      'SAR': 'ريالاً سعودياً',
      'USD': 'دولاراً أمريكياً',
      'EUR': 'يورو',
      'GBP': 'جنيهاً إسترلينياً',
      'AED': 'درهماً إماراتياً',
    };
    return names[code] ?? code;
  }

  static String _getArabicSubCurrencyName(String code) {
    const names = {
      'SAR': 'هللة',
      'USD': 'سنتاً',
      'EUR': 'سنتاً',
      'GBP': 'بنساً',
      'AED': 'فلساً',
    };
    return names[code] ?? '';
  }

  static String _convertWholeToEnglish(int number) {
    if (number == 0) return 'Zero';

    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
    ];
    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety',
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
      '',
      'واحد',
      'اثنان',
      'ثلاثة',
      'أربعة',
      'خمسة',
      'ستة',
      'سبعة',
      'ثمانية',
      'تسعة',
      'عشرة',
      'أحد عشر',
      'اثنا عشر',
      'ثلاثة عشر',
      'أربعة عشر',
      'خمسة عشر',
      'ستة عشر',
      'سبعة عشر',
      'ثمانية عشر',
      'تسعة عشر',
    ];
    const tensAr = [
      '',
      '',
      'عشرون',
      'ثلاثون',
      'أربعون',
      'خمسون',
      'ستون',
      'سبعون',
      'ثمانون',
      'تسعون',
    ];
    const hundreds = [
      '',
      'مائة',
      'مائتان',
      'ثلاثمائة',
      'أربعمائة',
      'خمسمائة',
      'ستمائة',
      'سبعمائة',
      'ثمانمائة',
      'تسعمائة',
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
