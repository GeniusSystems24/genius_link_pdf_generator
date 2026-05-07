import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/financial/financial.dart';
import '../core/pdf_config.dart';
import '../models/pdf_image.dart';
import '../models/pdf_result.dart';

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

    _drawHeader();
    _drawInfoSection();
    _drawItemsTable();
    _drawSummary();
    _drawAmountInWords();
    _drawVatBreakdown();
    _drawFooterSection();
    _drawSignature();
  }

  /// Validates financial totals then generates the PDF.
  ///
  /// Returns [GeniusPdfFailure] if validation fails (subtotal, VAT, grand total),
  /// or [GeniusPdfSuccess] with the PDF bytes on success.
  /// Pass `validateFinancials: false` to skip validation (backward-compatible opt-out).
  Future<GeniusPdfResult> generateResult({
    bool validateFinancials = true,
    GeniusFinancialValidationContext? validationContext,
  }) async {
    if (validateFinancials) {
      final policy =
          validationContext?.roundingPolicy ?? GeniusRoundingPolicy.defaults();
      final validator = GeniusFinancialValidator(policy);

      final lineTotals = invoice.items.map((i) => i.lineTotal).toList();
      final subtotalResult = validator.validateSubtotal(
        lineTotals: lineTotals,
        providedSubtotal: invoice.subtotal,
      );

      final vatResults = invoice.taxes
          .map((tax) => validator.validateVat(
                vatBase: invoice.subtotal,
                vatRate: tax.rate,
                providedVatAmount: tax.calculate(invoice.subtotal),
              ))
          .toList();

      final grandTotalResult = validator.validateGrandTotal(
        subtotal: invoice.subtotal,
        discounts: 0.0,
        vatAmount: invoice.totalTax,
        fees: 0.0,
        providedGrandTotal: invoice.grandTotal,
      );

      final combined = validator.combineResults([
        subtotalResult,
        ...vatResults,
        grandTotalResult,
      ]);

      if (!combined.isValid) return GeniusPdfFailure.fromValidation(combined);
    }

    try {
      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(generate()),
        fileName: 'invoice_${invoice.invoiceNumber}.pdf',
      );
    } catch (e, st) {
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  // ──────────────────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────────────────

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

    addReportHeader(header, height: 100, spacing: 0);
  }

  // ──────────────────────────────────────────────────────────
  // Customer & Invoice Info
  // ──────────────────────────────────────────────────────────

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
          value: config.isRTL
              ? (customer.nameAr ?? customer.name)
              : customer.name,
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
        if (customer.email != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Email',
            labelAr: 'البريد الإلكتروني',
            value: customer.email!,
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
        if (invoice.dueDate != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Due Date',
            labelAr: 'تاريخ الاستحقاق',
            value: _formatDate(invoice.dueDate!),
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

    addDualInfoBox(
      leftBox: config.isRTL ? invoiceBox : customerBox,
      rightBox: config.isRTL ? customerBox : invoiceBox,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Items Table
  // ──────────────────────────────────────────────────────────

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
        if (invoice.items.any((item) => item.discount > 0))
          GeniusPdfGridColumn.currency(
            id: 'discount',
            title: 'Discount',
            titleAr: 'الخصم',
            width: 70,
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
                'qty': '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
                'price': item.unitPrice,
                if (invoice.items.any((i) => i.discount > 0))
                  'discount': item.discount,
                'total': item.lineTotal,
              }))
          .toList(),
      style: const GeniusPdfGridStyle.classic(),
    );

    // Use drawAt + updateFromLayoutResult for multi-page grid safety.
    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      updateFromLayoutResult(result, spacing: 15);
    }
  }

  // ──────────────────────────────────────────────────────────
  // Summary & Totals
  // ──────────────────────────────────────────────────────────

  void _drawSummary() {
    final items = <GeniusPdfSummaryItem>[
      GeniusPdfSummaryItem.subtotal(
        label: 'Subtotal',
        labelAr: 'الإجمالي قبل الضريبة',
        value: _formatCurrency(invoice.subtotal),
      ),
    ];

    for (final tax in invoice.taxes) {
      items.add(GeniusPdfSummaryItem(
        label: '${tax.name} (${tax.rate}%)',
        labelAr: '${tax.nameAr ?? tax.name} (${tax.rate}%)',
        value: _formatCurrency(tax.calculate(invoice.subtotal)),
      ));
    }

    if (invoice.items.any((item) => item.discount > 0)) {
      final totalDiscount =
          invoice.items.fold(0.0, (sum, item) => sum + item.discount);
      items.add(GeniusPdfSummaryItem(
        label: 'Total Discount',
        labelAr: 'إجمالي الخصم',
        value: '(${_formatCurrency(totalDiscount)})',
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

    addSummary(summary, spacing: 5);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Amount in Words
  // ──────────────────────────────────────────────────────────

  void _drawAmountInWords() {
    final amountInWords =
        _numberToWords(invoice.grandTotal, invoice.currency);
    final amountInWordsAr =
        _numberToWordsArabic(invoice.grandTotal, invoice.currency);

    final richText = GeniusPdfRichTextBuilder(config: config)
        .bold(config.isRTL ? 'فقط ' : 'Total in Words: ')
        .text(config.isRTL ? amountInWordsAr : amountInWords)
        .build();

    addRichText(richText, spacing: 5);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // VAT Breakdown
  // ──────────────────────────────────────────────────────────

  void _drawVatBreakdown() {
    if (invoice.taxes.isEmpty) return;

    final vatText = config.isRTL
        ? 'تفصيل الضريبة: الإجمالي الخاضع (${_formatCurrency(invoice.subtotal)}), مبلغ الضريبة (${_formatCurrency(invoice.totalTax)})'
        : 'VAT Breakdown: Taxable Amount (${_formatCurrency(invoice.subtotal)}), VAT Amount (${_formatCurrency(invoice.totalTax)})';

    addLine(vatText, font: baseFont, topMargin: 5);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Footer Section (Notes + QR Code)
  // ──────────────────────────────────────────────────────────

  void _drawFooterSection() {
    final hasNotes = invoice.notes != null || invoice.notesAr != null;

    if (!hasNotes && !showQRCode) return;

    addSpace(10);

    if (hasNotes && showQRCode) {
      // Draw side-by-side: Notes (2/3) | QR (1/3)
      addTwoColumns(
        spacing: 10,
        leftFlex: config.isLTR ? 2 : 1,
        rightFlex: config.isLTR ? 1 : 2,
        leftContent: config.isLTR ? _drawNotesContent : _drawQRCodeContent,
        rightContent: config.isLTR ? _drawQRCodeContent : _drawNotesContent,
      );
    } else if (hasNotes) {
      _drawNotesInline();
    } else {
      _drawQRCodeInline();
    }

    addSpace(15);
  }

  void _drawNotesInline() {
    final displayNotes = config.isRTL
        ? (invoice.notesAr ?? invoice.notes)
        : (invoice.notes ?? invoice.notesAr);
    if (displayNotes == null) return;

    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    addLine(notesLabel, font: config.boldFont, topMargin: 5);
    addLine(displayNotes, topMargin: 3);
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes = config.isRTL
        ? (invoice.notesAr ?? invoice.notes)
        : (invoice.notes ?? invoice.notesAr);
    if (displayNotes == null) return 0;

    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText = '$notesLabel\n$displayNotes';

    final element = PdfTextElement(
      text: notesText,
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
      bounds: Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        bounds.height > 0 ? bounds.height : pageHeight - bounds.top,
      ),
    );

    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeInline() {
    if (qrCode != null) {
      addImage(
        qrCode!,
        alignment: GeniusPdfImageAlignment.center,
        spacing: 5,
      );
    } else {
      _drawGeneratedQR(currentPage, 0, currentY, pageWidth);
    }
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    if (qrCode != null) {
      const size = 80.0;
      final x = bounds.left + (bounds.width - size) / 2;
      page.graphics.drawImage(
        PdfBitmap(qrCode!.data),
        Rect.fromLTWH(x, bounds.top, size, size),
      );
      return size;
    }
    return _drawGeneratedQR(page, bounds.left, bounds.top, bounds.width);
  }

  double _drawGeneratedQR(
      PdfPage page, double x, double y, double width) {
    final qrUrl = 'https://localhost:443/invoice/${invoice.invoiceNumber}';
    final caption = 'ID: ${invoice.invoiceNumber}';
    const qrSize = 80.0;

    final captionElement = PdfTextElement(
      text: caption,
      font: config.baseFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection
      ),
    );

    final captionResult = captionElement.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, width, 20),
    );

    final captionHeight = captionResult?.bounds.height ?? 0;
    final qrX = x + (width - qrSize) / 2;
    final qrY = y + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(qrX, qrY, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
  }

  // ──────────────────────────────────────────────────────────
  // Signature
  // ──────────────────────────────────────────────────────────

  void _drawSignature() {
    if (!showSignature) return;

    // Ensure enough space for signature area.
    const signatureHeight = 70.0;
    if (remainingHeight < signatureHeight) {
      newPage();
    }

    addSpace(10);

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
        currentY,
        200,
        60,
      ),
    );

    addSpace(signatureHeight);
  }

  // ──────────────────────────────────────────────────────────
  // Formatting Utilities
  // ──────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${invoice.currency}';
  }

  // ──────────────────────────────────────────────────────────
  // Number-to-Words (English)
  // ──────────────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────────────
  // Number-to-Words (Arabic)
  // ──────────────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────────────
  // Currency Name Lookups
  // ──────────────────────────────────────────────────────────

  static String _getCurrencyName(String code) {
    const names = {
      'SAR': 'Saudi Riyals',
      'USD': 'US Dollars',
      'EUR': 'Euros',
      'GBP': 'British Pounds',
      'AED': 'UAE Dirhams',
      'KWD': 'Kuwaiti Dinars',
      'BHD': 'Bahraini Dinars',
      'OMR': 'Omani Rials',
      'QAR': 'Qatari Riyals',
      'EGP': 'Egyptian Pounds',
      'JOD': 'Jordanian Dinars',
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
      'KWD': 'Fils',
      'BHD': 'Fils',
      'OMR': 'Baisas',
      'QAR': 'Dirhams',
      'EGP': 'Piastres',
      'JOD': 'Fils',
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
      'KWD': 'ديناراً كويتياً',
      'BHD': 'ديناراً بحرينياً',
      'OMR': 'ريالاً عمانياً',
      'QAR': 'ريالاً قطرياً',
      'EGP': 'جنيهاً مصرياً',
      'JOD': 'ديناراً أردنياً',
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
      'KWD': 'فلساً',
      'BHD': 'فلساً',
      'OMR': 'بيسة',
      'QAR': 'درهماً',
      'EGP': 'قرشاً',
      'JOD': 'فلساً',
    };
    return names[code] ?? '';
  }

  // ──────────────────────────────────────────────────────────
  // English Number Conversion
  // ──────────────────────────────────────────────────────────

  static String _convertWholeToEnglish(int number) {
    if (number == 0) return 'Zero';

    const ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five',
      'Six', 'Seven', 'Eight', 'Nine', 'Ten',
      'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen',
    ];
    const tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty',
      'Sixty', 'Seventy', 'Eighty', 'Ninety',
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

  // ──────────────────────────────────────────────────────────
  // Arabic Number Conversion
  // ──────────────────────────────────────────────────────────

  static String _convertWholeToArabic(int number) {
    if (number == 0) return 'صفر';

    const ones = [
      '', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة',
      'ستة', 'سبعة', 'ثمانية', 'تسعة', 'عشرة',
      'أحد عشر', 'اثنا عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر',
      'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر',
    ];
    const tensAr = [
      '', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون',
      'ستون', 'سبعون', 'ثمانون', 'تسعون',
    ];
    const hundreds = [
      '', 'مائة', 'مائتان', 'ثلاثمائة', 'أربعمائة', 'خمسمائة',
      'ستمائة', 'سبعمائة', 'ثمانمائة', 'تسعمائة',
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
                : thousands >= 3 && thousands <= 10
                    ? '${convert(thousands)} آلاف'
                    : '${convert(thousands)} ألف';
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
                : millions >= 3 && millions <= 10
                    ? '${convert(millions)} ملايين'
                    : '${convert(millions)} مليون';
        if (remainder == 0) return millionWord;
        return '$millionWord و ${convert(remainder)}';
      }
      final billions = n ~/ 1000000000;
      final remainder = n % 1000000000;
      final billionWord = billions == 1
          ? 'مليار'
          : billions == 2
              ? 'ملياران'
              : billions >= 3 && billions <= 10
                  ? '${convert(billions)} مليارات'
                  : '${convert(billions)} مليار';
      if (remainder == 0) return billionWord;
      return '$billionWord و ${convert(remainder)}';
    }

    return convert(number);
  }
}
