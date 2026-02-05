/// Base template class for all voucher types.
///
/// Provides shared drawing methods for headers, titles, party info,
/// amounts, account entries, signatures, and footers. Concrete voucher
/// templates extend this class and override [buildVoucherContent].
library;

import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../builders/pdf_document_builder.dart';
import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/amount_to_words.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';

/// Abstract base class for all voucher templates.
///
/// Subclasses must override [buildVoucherContent] to render the
/// voucher-specific body between the header and signatures.
abstract class GeniusPdfVoucherTemplate extends GeniusPdfDocumentBuilder {
  GeniusPdfVoucherTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.style = const GeniusPdfVoucherStyle(),
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final VoucherData data;
  final GeniusPdfVoucherStyle style;

  // ── Convenience getters ──

  bool get isRTL => config.isRTL;
  PdfFont get titleFont => config.fontBuild(fontSize: style.titleFontSize);
  PdfFont get subtitleFont => config.fontBuild(fontSize: style.subtitleFontSize);
  PdfFont get bodyFont => config.fontBuild(fontSize: style.bodyFontSize);
  PdfFont get smallFont => config.fontBuild(fontSize: style.smallFontSize);
  PdfFont get boldTitleFont => config.fontBuild(
      fontSize: style.titleFontSize,
      fontBytes: config.boldFontBytes ?? config.baseFontBytes);
  PdfFont get boldBodyFont => config.fontBuild(
      fontSize: style.bodyFontSize,
      fontBytes: config.boldFontBytes ?? config.baseFontBytes);
  PdfFont get tableFont => config.fontBuild(fontSize: style.tableFontSize);
  PdfFont get boldTableFont => config.fontBuild(
      fontSize: style.tableFontSize,
      fontBytes: config.boldFontBytes ?? config.baseFontBytes);

  PdfTextDirection get textDir =>
      isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight;
  PdfTextAlignment get startAlign =>
      isRTL ? PdfTextAlignment.right : PdfTextAlignment.left;
  PdfTextAlignment get endAlign =>
      isRTL ? PdfTextAlignment.left : PdfTextAlignment.right;

  double get contentWidth => pageWidth;
  String get _formattedDate => _formatDate(data.voucherDate);
  String get _formattedAmount => _formatNumber(data.amount);

  // ── Main Build ──

  @override
  void build() {
    newPage();
    _drawPageBorder();
    drawVoucherHeader();
    drawVoucherTitle();
    drawVoucherInfo();
    buildVoucherContent();
    drawAmountInWords();
    if (data.notes != null || data.notesAr != null) {
      drawNotesBlock();
    }
    drawSignatureBlock();
    drawVoucherFooter();
  }

  /// Override in subclass to draw the voucher-specific body content.
  void buildVoucherContent();

  // ── Header ──

  /// Draws the company header with logo, name, and basic info.
  void drawVoucherHeader() {
    final g = currentPage.graphics;
    final y = currentY;

    // Header background
    g.drawRectangle(
      brush: PdfSolidBrush(PdfColor.fromCMYK(
        _toCmyk(style.primaryColor)[0],
        _toCmyk(style.primaryColor)[1],
        _toCmyk(style.primaryColor)[2],
        _toCmyk(style.primaryColor)[3],
      )),
      bounds: Rect.fromLTWH(0, y, pageWidth, style.headerHeight),
    );

    // Company name
    final companyNameAr = company.nameAr ?? company.name;
    final companyNameEn = company.name;

    final headerFont = config.fontBuild(
        fontSize: style.titleFontSize + 2,
        fontBytes: config.boldFontBytes ?? config.baseFontBytes);
    final headerSmall = config.fontBuild(
        fontSize: style.smallFontSize,
        fontBytes: config.baseFontBytes);

    final brush = PdfSolidBrush(_pdfColor(style.headerTextColor));
    final fmt = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle,
      textDirection: PdfTextDirection.rightToLeft,
    );
    final fmtSmall = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      textDirection: PdfTextDirection.rightToLeft,
    );

    // Arabic name centered
    g.drawString(
      companyNameAr,
      headerFont,
      brush: brush,
      bounds: Rect.fromLTWH(0, y + 8, pageWidth, 22),
      format: fmt,
    );

    // English name below Arabic
    final fmtEn = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      textDirection: PdfTextDirection.leftToRight,
    );
    g.drawString(
      companyNameEn,
      headerSmall,
      brush: brush,
      bounds: Rect.fromLTWH(0, y + 30, pageWidth, 14),
      format: fmtEn,
    );

    // VAT number if available
    if (company.vatNumber != null) {
      g.drawString(
        'الرقم الضريبي: ${company.vatNumber}  |  VAT No: ${company.vatNumber}',
        smallFont,
        brush: brush,
        bounds: Rect.fromLTWH(0, y + 46, pageWidth, 12),
        format: fmtSmall,
      );
    }

    // CR number if available
    if (company.crNumber != null) {
      g.drawString(
        'س.ت: ${company.crNumber}  |  CR: ${company.crNumber}',
        smallFont,
        brush: brush,
        bounds: Rect.fromLTWH(0, y + 58, pageWidth, 12),
        format: fmtSmall,
      );
    }

    resetY(y + style.headerHeight + style.sectionSpacing);
  }

  // ── Voucher Title ──

  /// Draws the bilingual voucher title with optional service ID badge.
  void drawVoucherTitle() {
    final g = currentPage.graphics;
    final y = currentY;

    final titleAr = data.serviceId.nameAr;
    final titleEn = data.serviceId.nameEn;
    final bilingualTitle = '$titleAr  /  $titleEn';

    // Title text
    final titleFmt = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      textDirection: PdfTextDirection.rightToLeft,
    );
    g.drawString(
      bilingualTitle,
      boldTitleFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(0, y, pageWidth, 22),
      format: titleFmt,
    );

    // Service ID badge
    if (style.showServiceIdBadge) {
      final badgeText = data.serviceId.code;
      final badgeWidth = 55.0;
      final badgeHeight = 16.0;
      final badgeX = (pageWidth - badgeWidth) / 2;
      final badgeY = y + 24;

      g.drawRectangle(
        brush: PdfSolidBrush(_pdfColor(style.badgeColor)),
        bounds: Rect.fromLTWH(badgeX, badgeY, badgeWidth, badgeHeight),
      );
      g.drawString(
        badgeText,
        smallFont,
        brush: PdfSolidBrush(_pdfColor(style.badgeTextColor)),
        bounds: Rect.fromLTWH(badgeX, badgeY + 2, badgeWidth, badgeHeight),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      resetY(badgeY + badgeHeight + style.sectionSpacing);
    } else {
      resetY(y + 24 + style.sectionSpacing);
    }

    // Copy type label
    if (style.showCopyLabel) {
      final copyText = data.copyType.displayName(isRTL: isRTL);
      g.drawString(
        copyText,
        smallFont,
        brush: PdfSolidBrush(_pdfColor(style.accentColor)),
        bounds: Rect.fromLTWH(0, currentY - style.sectionSpacing, pageWidth, 12),
        format: PdfStringFormat(alignment: endAlign, textDirection: textDir),
      );
    }
  }

  // ── Voucher Info Row ──

  /// Draws the basic voucher info: number, date, reference.
  void drawVoucherInfo() {
    final y = currentY;

    final infoPairs = <_InfoPair>[
      _InfoPair('رقم السند', 'Voucher No', data.voucherNumber),
      _InfoPair('التاريخ', 'Date', _formattedDate),
      if (data.referenceNumber != null)
        _InfoPair('المرجع', 'Reference', data.referenceNumber!),
      if (data.fiscalPeriod != null)
        _InfoPair('الفترة المالية', 'Fiscal Period', data.fiscalPeriod!),
    ];

    _drawInfoRow(y, infoPairs);
    resetY(y + 28 + style.sectionSpacing);
  }

  // ── Party Info ──

  /// Draws party (customer/supplier/beneficiary) information block.
  void drawPartyInfo({
    required String labelAr,
    required String labelEn,
  }) {
    if (data.party == null) return;

    final y = currentY;
    final party = data.party!;

    _drawSectionLabel(y, labelAr, labelEn);
    var infoY = y + 16;

    final fields = <_InfoPair>[
      _InfoPair('الاسم', 'Name', party.displayName(isRTL: isRTL)),
      if (party.code != null) _InfoPair('الرمز', 'Code', party.code!),
      if (party.vatNumber != null) _InfoPair('الرقم الضريبي', 'VAT No', party.vatNumber!),
      if (party.idNumber != null) _InfoPair('رقم الهوية', 'ID No', party.idNumber!),
      if (party.phone != null) _InfoPair('الهاتف', 'Phone', party.phone!),
      if (party.address != null || party.addressAr != null)
        _InfoPair('العنوان', 'Address',
            isRTL ? (party.addressAr ?? party.address!) : party.address!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawLabelValuePair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  // ── Payment Details ──

  /// Draws payment method details block.
  void drawPaymentDetails() {
    if (data.paymentDetails == null) return;

    final y = currentY;
    final pd = data.paymentDetails!;

    _drawSectionLabel(y, 'تفاصيل الدفع', 'Payment Details');
    var infoY = y + 16;

    final fields = <_InfoPair>[
      _InfoPair('طريقة الدفع', 'Payment Method', pd.method.displayName(isRTL: isRTL)),
    ];

    switch (pd.method) {
      case VoucherPaymentMethod.bankTransfer:
        if (pd.bankName != null) fields.add(_InfoPair('البنك', 'Bank', pd.bankName!));
        if (pd.accountNumber != null) fields.add(_InfoPair('رقم الحساب', 'Account No', pd.accountNumber!));
        if (pd.iban != null) fields.add(_InfoPair('الآيبان', 'IBAN', pd.iban!));
        if (pd.transferReference != null)
          fields.add(_InfoPair('مرجع التحويل', 'Transfer Ref', pd.transferReference!));
        if (pd.transferDate != null)
          fields.add(_InfoPair('تاريخ التحويل', 'Transfer Date', _formatDate(pd.transferDate!)));
        break;
      case VoucherPaymentMethod.check:
        if (pd.checkNumber != null) fields.add(_InfoPair('رقم الشيك', 'Check No', pd.checkNumber!));
        if (pd.draweeBankName != null) fields.add(_InfoPair('البنك المسحوب عليه', 'Drawee Bank', pd.draweeBankName!));
        if (pd.checkDate != null) fields.add(_InfoPair('تاريخ الشيك', 'Check Date', _formatDate(pd.checkDate!)));
        if (pd.dueDate != null) fields.add(_InfoPair('تاريخ الاستحقاق', 'Due Date', _formatDate(pd.dueDate!)));
        break;
      case VoucherPaymentMethod.electronic:
        if (pd.gatewayName != null) fields.add(_InfoPair('بوابة الدفع', 'Gateway', pd.gatewayName!));
        if (pd.transactionId != null) fields.add(_InfoPair('رقم العملية', 'Transaction ID', pd.transactionId!));
        if (pd.cardType != null) fields.add(_InfoPair('نوع البطاقة', 'Card Type', pd.cardType!));
        if (pd.cardLastFour != null) fields.add(_InfoPair('آخر 4 أرقام', 'Last 4 Digits', '****${pd.cardLastFour}'));
        break;
      case VoucherPaymentMethod.currencyExchange:
        if (pd.sourceCurrency != null) fields.add(_InfoPair('عملة المصدر', 'Source Currency', pd.sourceCurrency!));
        if (pd.targetCurrency != null) fields.add(_InfoPair('العملة المستهدفة', 'Target Currency', pd.targetCurrency!));
        if (pd.exchangeRate != null) fields.add(_InfoPair('سعر الصرف', 'Exchange Rate', pd.exchangeRate!.toStringAsFixed(4)));
        if (pd.sourceAmount != null) fields.add(_InfoPair('المبلغ الأصلي', 'Source Amount', _formatNumber(pd.sourceAmount!)));
        if (pd.targetAmount != null) fields.add(_InfoPair('المبلغ المحوّل', 'Target Amount', _formatNumber(pd.targetAmount!)));
        if (pd.exchangeFee != null) fields.add(_InfoPair('رسوم التحويل', 'Exchange Fee', _formatNumber(pd.exchangeFee!)));
        break;
      case VoucherPaymentMethod.cash:
      case VoucherPaymentMethod.installment:
        break;
    }

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawLabelValuePair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  // ── Account Entries Table ──

  /// Draws the accounting entries table (debit/credit).
  void drawAccountEntriesTable() {
    if (data.accountEntries.isEmpty) return;

    final y = currentY;
    _drawSectionLabel(y, 'القيود المحاسبية', 'Account Entries');

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'code', title: 'Account', titleAr: 'الحساب', width: 65,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'name', title: 'Account Name', titleAr: 'اسم الحساب', flexFactor: 3,
        ),
        if (data.accountEntries.any((e) => e.costCenter != null))
          const GeniusPdfGridColumn(
            id: 'cc', title: 'Cost Center', titleAr: 'مركز تكلفة', flexFactor: 1,
          ),
        GeniusPdfGridColumn.currency(
          id: 'debit', title: 'Debit', titleAr: 'مدين', width: 85, currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'credit', title: 'Credit', titleAr: 'دائن', width: 85, currencySymbol: '',
        ),
      ],
      rows: [
        for (final entry in data.accountEntries)
          GeniusPdfGridRow(cells: {
            'code': entry.accountCode,
            'name': isRTL ? (entry.accountNameAr ?? entry.accountName) : entry.accountName,
            if (data.accountEntries.any((e) => e.costCenter != null))
              'cc': isRTL ? (entry.costCenterAr ?? entry.costCenter ?? '') : (entry.costCenter ?? ''),
            'debit': entry.debitAmount > 0 ? entry.debitAmount : '',
            'credit': entry.creditAmount > 0 ? entry.creditAmount : '',
          }),
        // Totals row
        GeniusPdfGridRow.total({
          'code': '',
          'name': isRTL ? 'الإجمالي' : 'Total',
          if (data.accountEntries.any((e) => e.costCenter != null)) 'cc': '',
          'debit': data.accountEntries.fold<double>(0, (s, e) => s + e.debitAmount),
          'credit': data.accountEntries.fold<double>(0, (s, e) => s + e.creditAmount),
        }),
      ],
      style: GeniusPdfGridStyle(
        headerStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: style.tableFontSize,
            fontWeight: FontWeight.bold,
            color: style.tableHeaderTextColor,
          ),
          backgroundColor: style.tableHeaderColor,
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        cellStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(fontSize: style.tableFontSize),
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        alternateRowStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(fontSize: style.tableFontSize),
          backgroundColor: style.tableAltRowColor,
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        borderStyle: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
      ),
    );

    resetY(y + 16);
    grid.drawAt(page: currentPage, x: 0, y: currentY, width: contentWidth);
    final gridHeight = (data.accountEntries.length + 2) * 20.0;
    resetY(currentY + gridHeight + style.sectionSpacing);
  }

  // ── Amount Block ──

  /// Draws the total amount highlight block.
  void drawAmountBlock() {
    final g = currentPage.graphics;
    final y = currentY;

    final boxHeight = 28.0;
    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.amountHighlightColor)),
      pen: PdfPen(_pdfColor(style.primaryColor), width: style.borderWidth),
      bounds: Rect.fromLTWH(0, y, contentWidth, boxHeight),
    );

    final amountLabel = isRTL ? 'المبلغ' : 'Amount';
    final amountStr = '$_formattedAmount ${data.currency}';

    g.drawString(
      '$amountLabel:  $amountStr',
      boldTitleFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(8, y + 4, contentWidth - 16, boxHeight - 8),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: textDir,
      ),
    );

    resetY(y + boxHeight + style.sectionSpacing);
  }

  // ── Amount in Words ──

  /// Draws the amount in words in both Arabic and English.
  void drawAmountInWords() {
    final g = currentPage.graphics;
    final y = currentY;

    final wordsAr = AmountToWords.toArabic(data.amount, currency: data.currency);
    final wordsEn = AmountToWords.toEnglish(data.amount, currency: data.currency);

    _drawSectionLabel(y, 'المبلغ بالحروف', 'Amount in Words');

    final fmtAr = PdfStringFormat(
      alignment: PdfTextAlignment.right,
      textDirection: PdfTextDirection.rightToLeft,
    );
    g.drawString(
      wordsAr,
      boldBodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(4, y + 16, contentWidth - 8, 14),
      format: fmtAr,
    );

    final fmtEn = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      textDirection: PdfTextDirection.leftToRight,
    );
    g.drawString(
      wordsEn,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(4, y + 32, contentWidth - 8, 14),
      format: fmtEn,
    );

    resetY(y + 48 + style.sectionSpacing);
  }

  // ── Notes ──

  void drawNotesBlock() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawSectionLabel(y, 'ملاحظات', 'Notes');

    final noteText = isRTL ? (data.notesAr ?? data.notes ?? '') : (data.notes ?? '');
    g.drawString(
      noteText,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(4, y + 16, contentWidth - 8, 30),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    resetY(y + 48 + style.sectionSpacing);
  }

  // ── Signatures ──

  /// Draws the signature blocks at the bottom of the voucher.
  void drawSignatureBlock() {
    final signatories = data.signatories.isNotEmpty
      ? data.signatories
      : defaultSignatories();

    if (signatories.isEmpty) return;

    final g = currentPage.graphics;
    var y = currentY;

    // Ensure enough space
    final neededHeight = style.signatureBlockHeight + 10;
    if (y + neededHeight > pageHeight - 40) {
      newPage();
      _drawPageBorder();
      y = currentY;
    }

    final count = signatories.length;
    final colWidth = contentWidth / count;

    for (var i = 0; i < count; i++) {
      final sig = signatories[i];
      final x = i * colWidth;

      // Role label
      final roleText = '${sig.roleAr ?? sig.role}\n${sig.role}';
      g.drawString(
        roleText,
        smallFont,
        brush: PdfSolidBrush(_pdfColor(style.accentColor)),
        bounds: Rect.fromLTWH(x + 4, y, colWidth - 8, 22),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft,
        ),
      );

      // Name (if provided)
      if (sig.name != null) {
        g.drawString(
          sig.name!,
          bodyFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(x + 4, y + 24, colWidth - 8, 12),
          format: PdfStringFormat(alignment: PdfTextAlignment.center),
        );
      }

      // Signature line
      if (sig.showSignatureLine) {
        final lineY = y + style.signatureBlockHeight - 15;
        g.drawLine(
          PdfPen(_pdfColor(style.borderColor), width: 0.5),
          Offset(x + 12, lineY),
          Offset(x + colWidth - 12, lineY),
        );
      }

      // Vertical separator
      if (i < count - 1) {
        g.drawLine(
          PdfPen(_pdfColor(style.borderColor), width: 0.3),
          Offset(x + colWidth, y),
          Offset(x + colWidth, y + style.signatureBlockHeight),
        );
      }
    }

    resetY(y + style.signatureBlockHeight + style.sectionSpacing);
  }

  // ── Footer ──

  void drawVoucherFooter() {
    final g = currentPage.graphics;
    final footerY = pageHeight - 30;

    // Separator line
    g.drawLine(
      PdfPen(_pdfColor(style.borderColor), width: 0.5),
      Offset(0, footerY),
      Offset(pageWidth, footerY),
    );

    final now = DateTime.now();
    final printDate = 'طبع: ${_formatDate(now)}  |  Printed: ${_formatDate(now)}';
    g.drawString(
      printDate,
      smallFont,
      brush: PdfSolidBrush(_pdfColor(style.borderColor)),
      bounds: Rect.fromLTWH(4, footerY + 4, pageWidth / 2 - 8, 12),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );

    final serial = 'S/N: ${data.voucherNumber}';
    g.drawString(
      serial,
      smallFont,
      brush: PdfSolidBrush(_pdfColor(style.borderColor)),
      bounds: Rect.fromLTWH(pageWidth / 2, footerY + 4, pageWidth / 2 - 4, 12),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
  }

  // ── Shared Drawing Helpers ──

  /// Draws a page border if enabled.
  void _drawPageBorder() {
    if (!style.showBorder) return;
    currentPage.graphics.drawRectangle(
      pen: PdfPen(_pdfColor(style.borderColor), width: style.borderWidth),
      bounds: Rect.fromLTWH(0, 0, pageWidth, pageHeight),
    );
  }

  /// Draws a section label with bilingual text.
  void _drawSectionLabel(double y, String labelAr, String labelEn) {
    final g = currentPage.graphics;

    // Accent line
    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(0, y, 3, 13),
    );

    g.drawString(
      '$labelAr  |  $labelEn',
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(8, y, contentWidth - 8, 13),
      format: PdfStringFormat(
        alignment: startAlign,
        textDirection: textDir,
      ),
    );
  }

  /// Draws a row of info pairs (label: value) evenly distributed.
  void _drawInfoRow(double y, List<_InfoPair> pairs) {
    final g = currentPage.graphics;
    final colWidth = contentWidth / pairs.length;

    // Background
    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.tableHeaderColor)),
      pen: PdfPen(_pdfColor(style.borderColor), width: 0.5),
      bounds: Rect.fromLTWH(0, y, contentWidth, 26),
    );

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      final x = i * colWidth;

      // Label
      final label = isRTL ? pair.labelAr : pair.labelEn;
      g.drawString(
        label,
        smallFont,
        brush: PdfSolidBrush(_pdfColor(style.accentColor)),
        bounds: Rect.fromLTWH(x + 4, y + 2, colWidth - 8, 10),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      // Value
      g.drawString(
        pair.value,
        boldBodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(x + 4, y + 13, colWidth - 8, 12),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      // Separator
      if (i < pairs.length - 1) {
        g.drawLine(
          PdfPen(_pdfColor(style.borderColor), width: 0.3),
          Offset(x + colWidth, y + 3),
          Offset(x + colWidth, y + 23),
        );
      }
    }
  }

  /// Draws a label-value pair row (1 or 2 pairs per row).
  void _drawLabelValuePair(double y, _InfoPair pair1, [_InfoPair? pair2]) {
    final g = currentPage.graphics;
    final halfWidth = contentWidth / 2;

    // First pair
    final label1 = isRTL ? pair1.labelAr : pair1.labelEn;
    g.drawString(
      '$label1: ',
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.accentColor)),
      bounds: Rect.fromLTWH(4, y, halfWidth * 0.4 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
    g.drawString(
      pair1.value,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    // Second pair
    if (pair2 != null) {
      final label2 = isRTL ? pair2.labelAr : pair2.labelEn;
      g.drawString(
        '$label2: ',
        boldBodyFont,
        brush: PdfSolidBrush(_pdfColor(style.accentColor)),
        bounds: Rect.fromLTWH(halfWidth + 4, y, halfWidth * 0.4 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
      );
      g.drawString(
        pair2.value,
        bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(halfWidth + halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
      );
    }
  }

  /// Draws a data grid for line items.
  void drawItemsTable({
    required List<GeniusPdfGridColumn> columns,
    required List<GeniusPdfGridRow> rows,
    String labelAr = 'التفاصيل',
    String labelEn = 'Details',
  }) {
    final y = currentY;
    _drawSectionLabel(y, labelAr, labelEn);
    resetY(y + 16);

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle(
        headerStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: style.tableFontSize,
            fontWeight: FontWeight.bold,
            color: style.tableHeaderTextColor,
          ),
          backgroundColor: style.tableHeaderColor,
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        cellStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(fontSize: style.tableFontSize),
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        alternateRowStyle: GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(fontSize: style.tableFontSize),
          backgroundColor: style.tableAltRowColor,
          border: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
          padding: GeniusPdfCellPadding.all(style.cellPadding),
        ),
        borderStyle: GeniusPdfBorderStyle.all(color: style.borderColor, width: 0.5),
      ),
    );

    grid.drawAt(page: currentPage, x: 0, y: currentY, width: contentWidth);
    final gridHeight = (rows.length + 1) * 20.0;
    resetY(currentY + gridHeight + style.sectionSpacing);
  }

  /// Default signatories when none are provided.
  List<VoucherSignatory> defaultSignatories() => [
        VoucherSignatory.preparedBy(),
        VoucherSignatory.reviewedBy(),
        VoucherSignatory.approvedBy(),
      ];

  // ── Utility ──

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatNumber(double n) {
    if (n == n.truncateToDouble()) return n.truncate().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return n.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  PdfColor _pdfColor(Color c) =>
      PdfColor(c.red, c.green, c.blue, c.alpha);

  List<double> _toCmyk(Color c) {
    final r = c.red / 255;
    final g = c.green / 255;
    final b = c.blue / 255;
    final k = 1.0 - [r, g, b].reduce((a, b) => a > b ? a : b);
    if (k >= 1.0) return [0, 0, 0, 100];
    return [
      ((1 - r - k) / (1 - k)) * 100,
      ((1 - g - k) / (1 - k)) * 100,
      ((1 - b - k) / (1 - k)) * 100,
      k * 100,
    ];
  }
}

/// Internal helper for info pairs.
class _InfoPair {
  const _InfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
