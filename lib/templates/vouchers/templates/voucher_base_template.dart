/// Base template class for all voucher types.
///
/// Provides shared drawing methods for headers, titles, party info,
/// amounts, account entries, signatures, and footers. Concrete voucher
/// templates extend this class and override [buildVoucherContent].
library;

import 'dart:typed_data';

import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../src/builders/pdf_document_builder.dart';
import '../../../src/components/components.dart';
import '../../../src/domain/financial/financial.dart';
import '../../../src/core/pdf_config.dart';
import '../../../src/extensions/color_extensions.dart';
import '../../../src/models/pdf_result.dart';
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

  @override
  bool get isRTL => config.isRTL;
  PdfFont get titleFont => config.fontBuild(fontSize: style.titleFontSize);
  PdfFont get subtitleFont =>
      config.fontBuild(fontSize: style.subtitleFontSize);
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
    final now = DateTime.now();
    addFooter(
      userName: data.voucherNumber,
      userLabel: isRTL ? 'الرقم التسلسلي: ' : 'S/N: ',
      printTime: 'طباعة: ${_formatDate(now)}  |  Printed: ${_formatDate(now)}',
      font: smallFont,
    );

    if (style.showBorder) {
      setDefaultPageBorder(
        style.borderColor.toPdfPen(width: style.borderWidth),
      );
    } else {
      setDefaultPageBorder(null);
    }

    newPage();
    drawVoucherHeader();
    drawVoucherTitle();
    drawVoucherInfo();
    buildVoucherContent();
    drawAmountInWords();
    if (data.notes != null || data.notesAr != null) {
      drawNotesBlock();
    }
    drawSignatureBlock();
  }

  /// Override in subclass to draw the voucher-specific body content.
  void buildVoucherContent();

  /// Validates accounting entries and currency conversion (if present),
  /// then generates the PDF.
  ///
  /// Returns [GeniusPdfFailure] if validation fails.
  /// Pass `validateFinancials: false` to skip validation.
  Future<GeniusPdfResult> generateResult({
    bool validateFinancials = true,
    GeniusFinancialValidationContext? validationContext,
  }) async {
    if (validateFinancials) {
      final policy =
          validationContext?.roundingPolicy ?? GeniusRoundingPolicy.defaults();
      final validator = GeniusFinancialValidator(policy);
      final results = <GeniusFinancialValidationResult>[];

      if (data.accountEntries.isNotEmpty) {
        results.add(validator.validateAccountingEntries(
          debits: data.accountEntries.map((e) => e.debitAmount).toList(),
          credits: data.accountEntries.map((e) => e.creditAmount).toList(),
        ));
      }

      final pd = data.paymentDetails;
      if (pd != null &&
          pd.exchangeRate != null &&
          pd.sourceAmount != null &&
          pd.targetAmount != null) {
        results.add(validator.validateCurrencyConversion(
          sourceAmount: pd.sourceAmount!,
          exchangeRate: pd.exchangeRate!,
          providedTargetAmount: pd.targetAmount!,
          sourceCurrencyPolicy: validationContext?.sourceCurrencyPolicy,
        ));
      }

      if (results.isNotEmpty) {
        final combined = validator.combineResults(results);
        if (!combined.isValid) return GeniusPdfFailure.fromValidation(combined);
      }
    }

    try {
      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(generate()),
        fileName: 'voucher_${data.voucherNumber}.pdf',
      );
    } catch (e, st) {
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  // ── Header ──

  /// Draws the report-style header (company info + bilingual title).
  void drawVoucherHeader() {
    final header = GeniusPdfReportHeader(
      title: data.serviceId.nameEn,
      titleAr: data.serviceId.nameAr,
      company: company,
      config: config.copyWith(textDirection: m.TextDirection.ltr),
      style: const GeniusPdfReportHeaderStyle.classic(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );

    addReportHeader(header, height: 100, spacing: 0);
    addSpace(style.sectionSpacing);
  }

  // ── Voucher Title ──

  /// Draws optional service ID badge and copy label below the header.
  void drawVoucherTitle() {
    // Removed: "Original" indicator and badge
  }

  // ── Voucher Info Row ──

  /// Draws the basic voucher info: number, date, reference.
  void drawVoucherInfo() {
    final infoPairs = <_InfoPair>[
      _InfoPair('رقم السند', 'Voucher No', data.voucherNumber),
      _InfoPair('التاريخ', 'Date', _formattedDate),
      if (data.referenceNumber != null)
        _InfoPair('المرجع', 'Reference', data.referenceNumber!),
      if (data.fiscalPeriod != null)
        _InfoPair('الفترة المالية', 'Fiscal Period', data.fiscalPeriod!),
    ];
    if (infoPairs.isEmpty) return;

    final columns = <GeniusPdfGridColumn>[
      for (var i = 0; i < infoPairs.length; i++)
        GeniusPdfGridColumn(
          id: 'c$i',
          title: infoPairs[i].labelEn,
          titleAr: infoPairs[i].labelAr,
          alignment: GeniusPdfTextAlign.center,
          flexFactor: 1,
        ),
    ];

    final row = GeniusPdfGridRow(
      cells: {
        for (var i = 0; i < infoPairs.length; i++) 'c$i': infoPairs[i].value,
      },
    );

    final headerStyle = GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: style.smallFontSize,
        fontWeight: m.FontWeight.w600,
        color: style.accentColor,
        alignment: GeniusPdfTextAlign.center,
      ),
      backgroundColor: style.tableHeaderColor,
      border: GeniusPdfBorderStyle.all(
        color: style.borderColor,
        width: style.borderWidth,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 4, vertical: 3),
    );

    final cellStyle = GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        fontWeight: m.FontWeight.bold,
        alignment: GeniusPdfTextAlign.center,
      ),
      border: GeniusPdfBorderStyle.all(
        color: style.borderColor,
        width: style.borderWidth,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 4, vertical: 4),
    );

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: [row],
      style: const GeniusPdfGridStyle.classic().copyWith(
        headerStyle: headerStyle,
        cellStyle: cellStyle,
        showHeader: true,
        repeatHeaderOnPages: false,
        alternateRowColors: false,
        gridLineColor: style.borderColor,
        gridLineWidth: style.borderWidth,
      ),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
  }

  // ── Party Info ──

  /// Draws party (customer/supplier/beneficiary) information block.
  void drawPartyInfo({
    required String labelAr,
    required String labelEn,
  }) {
    if (data.party == null) return;

    final party = data.party!;
    final items = <GeniusPdfLabeledValue>[
      _labeledValue('الاسم', 'Name', party.displayName(isRTL: isRTL)),
      if (party.code != null) _labeledValue('الرمز', 'Code', party.code!),
      if (party.vatNumber != null)
        _labeledValue('الرقم الضريبي', 'VAT No', party.vatNumber!),
      if (party.idNumber != null)
        _labeledValue('رقم الهوية', 'ID No', party.idNumber!),
      if (party.phone != null) _labeledValue('الهاتف', 'Phone', party.phone!),
      if (party.address != null || party.addressAr != null)
        _labeledValue(
          'العنوان',
          'Address',
          isRTL ? (party.addressAr ?? party.address!) : party.address!,
        ),
    ];

    addInfoSection(
      labelAr: labelAr,
      labelEn: labelEn,
      items: items,
      columns: 2,
    );
  }

  // ── Payment Details ──

  /// Draws payment method details block.
  void drawPaymentDetails() {
    if (data.paymentDetails == null) return;

    final pd = data.paymentDetails!;
    final fields = <GeniusPdfLabeledValue>[
      _labeledValue(
        'طريقة الدفع',
        'Payment Method',
        pd.method.displayName(isRTL: isRTL),
      ),
    ];

    switch (pd.method) {
      case VoucherPaymentMethod.bankTransfer:
        if (pd.bankName != null) {
          fields.add(_labeledValue('البنك', 'Bank', pd.bankName!));
        }
        if (pd.accountNumber != null) {
          fields.add(
              _labeledValue('رقم الحساب', 'Account No', pd.accountNumber!));
        }
        if (pd.iban != null) {
          fields.add(_labeledValue('الآيبان', 'IBAN', pd.iban!));
        }
        if (pd.transferReference != null) {
          fields.add(_labeledValue(
              'مرجع التحويل', 'Transfer Ref', pd.transferReference!));
        }
        if (pd.transferDate != null) {
          fields.add(_labeledValue(
            'تاريخ التحويل',
            'Transfer Date',
            _formatDate(pd.transferDate!),
          ));
        }
        break;
      case VoucherPaymentMethod.check:
        if (pd.checkNumber != null) {
          fields.add(_labeledValue('رقم الشيك', 'Check No', pd.checkNumber!));
        }
        if (pd.draweeBankName != null) {
          fields.add(_labeledValue(
            'البنك المسحوب عليه',
            'Drawee Bank',
            pd.draweeBankName!,
          ));
        }
        if (pd.checkDate != null) {
          fields.add(_labeledValue(
            'تاريخ الشيك',
            'Check Date',
            _formatDate(pd.checkDate!),
          ));
        }
        if (pd.dueDate != null) {
          fields.add(_labeledValue(
            'تاريخ الاستحقاق',
            'Due Date',
            _formatDate(pd.dueDate!),
          ));
        }
        break;
      case VoucherPaymentMethod.electronic:
        if (pd.gatewayName != null) {
          fields.add(_labeledValue('بوابة الدفع', 'Gateway', pd.gatewayName!));
        }
        if (pd.transactionId != null) {
          fields.add(_labeledValue(
            'رقم العملية',
            'Transaction ID',
            pd.transactionId!,
          ));
        }
        if (pd.cardType != null) {
          fields.add(_labeledValue('نوع البطاقة', 'Card Type', pd.cardType!));
        }
        if (pd.cardLastFour != null) {
          fields.add(_labeledValue(
            'آخر 4 أرقام',
            'Last 4 Digits',
            '****${pd.cardLastFour}',
          ));
        }
        break;
      case VoucherPaymentMethod.currencyExchange:
        if (pd.sourceCurrency != null) {
          fields.add(_labeledValue(
            'عملة المصدر',
            'Source Currency',
            pd.sourceCurrency!,
          ));
        }
        if (pd.targetCurrency != null) {
          fields.add(_labeledValue(
            'العملة المستهدفة',
            'Target Currency',
            pd.targetCurrency!,
          ));
        }
        if (pd.exchangeRate != null) {
          fields.add(_labeledValue(
            'سعر الصرف',
            'Exchange Rate',
            pd.exchangeRate!.toStringAsFixed(4),
          ));
        }
        if (pd.sourceAmount != null) {
          fields.add(_labeledValue(
            'المبلغ الأصلي',
            'Source Amount',
            _formatNumber(pd.sourceAmount!),
          ));
        }
        if (pd.targetAmount != null) {
          fields.add(_labeledValue(
            'المبلغ المحوّل',
            'Target Amount',
            _formatNumber(pd.targetAmount!),
          ));
        }
        if (pd.exchangeFee != null) {
          fields.add(_labeledValue(
            'رسوم التحويل',
            'Exchange Fee',
            _formatNumber(pd.exchangeFee!),
          ));
        }
        break;
      case VoucherPaymentMethod.cash:
      case VoucherPaymentMethod.installment:
        break;
    }

    addInfoSection(
      labelAr: 'تفاصيل الدفع',
      labelEn: 'Payment Details',
      items: fields,
      columns: 2,
    );
  }

  // ── Account Entries Table ──

  /// Draws the accounting entries table (debit/credit).
  void drawAccountEntriesTable() {
    if (data.accountEntries.isEmpty) return;

    addSectionHeading('القيود المحاسبية', 'Account Entries');
    addSpace(4);
    final hasCostCenter = data.accountEntries.any((e) => e.costCenter != null);

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'code',
          title: 'Account',
          titleAr: 'الحساب',
          width: 65,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'name',
          title: 'Account Name',
          titleAr: 'اسم الحساب',
          flexFactor: 3,
        ),
        if (hasCostCenter)
          const GeniusPdfGridColumn(
            id: 'cc',
            title: 'Cost Center',
            titleAr: 'مركز تكلفة',
            flexFactor: 1,
          ),
        GeniusPdfGridColumn.currency(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          width: 85,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          width: 85,
          currencySymbol: '',
        ),
      ],
      rows: [
        for (final entry in data.accountEntries)
          GeniusPdfGridRow(cells: {
            'code': entry.accountCode,
            'name': isRTL
                ? (entry.accountNameAr ?? entry.accountName)
                : entry.accountName,
            if (hasCostCenter)
              'cc': isRTL
                  ? (entry.costCenterAr ?? entry.costCenter ?? '')
                  : (entry.costCenter ?? ''),
            'debit': entry.debitAmount > 0 ? entry.debitAmount : '',
            'credit': entry.creditAmount > 0 ? entry.creditAmount : '',
          }),
        // Totals row
        GeniusPdfGridRow.total({
          'code': '',
          'name': isRTL ? 'الإجمالي' : 'Total',
          if (hasCostCenter) 'cc': '',
          'debit':
              data.accountEntries.fold<double>(0, (s, e) => s + e.debitAmount),
          'credit':
              data.accountEntries.fold<double>(0, (s, e) => s + e.creditAmount),
        }),
      ],
      style: const GeniusPdfGridStyle.classic(),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
  }

  // ── Amount Block ──

  /// Draws the total amount highlight block.
  void drawAmountBlock() {
    final amountLabel = isRTL ? 'المبلغ' : 'Amount';
    final amountStr = '$_formattedAmount ${data.currency}';
    final box = GeniusPdfInfoBox(
      config: config,
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: amountLabel,
          labelAr: 'المبلغ',
          value: amountStr,
        ),
      ],
      style: _highlightBoxStyle(),
      columns: 1,
    );

    addInfoBox(box, spacing: 0);
    addSpace(style.sectionSpacing);
  }

  // ── Amount in Words ──

  /// Draws the amount in words in both Arabic and English.
  void drawAmountInWords() {
    final wordsAr =
        AmountToWords.toArabic(data.amount, currency: data.currency);
    final wordsEn =
        AmountToWords.toEnglish(data.amount, currency: data.currency);
    addSectionHeading('المبلغ بالحروف', 'Amount in Words');
    addLine(wordsAr, font: boldBodyFont, topMargin: 2);
    addLine(wordsEn, font: bodyFont, topMargin: 2);
    addSpace(style.sectionSpacing);
  }

  // ── Notes ──

  void drawNotesBlock() {
    final noteText =
        isRTL ? (data.notesAr ?? data.notes ?? '') : (data.notes ?? '');
    addSectionHeading('ملاحظات', 'Notes');
    addLine(noteText, font: bodyFont, topMargin: 2);
    addSpace(style.sectionSpacing);
  }

  // ── Signatures ──

  /// Draws the signature blocks at the bottom of the voucher.
  void drawSignatureBlock() {
    final signatories =
        data.signatories.isNotEmpty ? data.signatories : defaultSignatories();

    if (signatories.isEmpty) return;

    final neededHeight = style.signatureBlockHeight + style.sectionSpacing;
    if (!canFit(neededHeight)) {
      newPage();
    }

    final columns = <GeniusPdfGridColumn>[
      for (var i = 0; i < signatories.length; i++)
        GeniusPdfGridColumn(
          id: 's$i',
          title: '',
          alignment: GeniusPdfTextAlign.center,
          flexFactor: 1,
        ),
    ];

    final roleStyle = GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: style.smallFontSize,
        fontWeight: m.FontWeight.w600,
        color: style.accentColor,
        alignment: GeniusPdfTextAlign.center,
      ),
      border: const GeniusPdfBorderStyle.none(),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 4, vertical: 2),
    );

    final nameStyle = GeniusPdfCellStyle(
      textStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        alignment: GeniusPdfTextAlign.center,
      ),
      border: const GeniusPdfBorderStyle.none(),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 4, vertical: 2),
    );

    final lineStyle = GeniusPdfCellStyle(
      textStyle:
          const GeniusPdfTextStyle(fontSize: 1, color: m.Color(0x00000000)),
      border: GeniusPdfBorderStyle.bottom(
        color: style.borderColor,
        width: 0.5,
      ),
      padding:
          const GeniusPdfCellPadding.symmetric(horizontal: 12, vertical: 6),
    );

    final hasNames = signatories.any(
      (s) => s.name != null && s.name!.trim().isNotEmpty,
    );

    final rows = <GeniusPdfGridRow>[
      GeniusPdfGridRow(
        cells: {
          for (var i = 0; i < signatories.length; i++)
            's$i': _signatureRole(signatories[i]),
        },
        style: roleStyle,
      ),
      if (hasNames)
        GeniusPdfGridRow(
          cells: {
            for (var i = 0; i < signatories.length; i++)
              's$i': signatories[i].name ?? '',
          },
          style: nameStyle,
        ),
      GeniusPdfGridRow(
        cells: {
          for (var i = 0; i < signatories.length; i++) 's$i': '',
        },
        style: lineStyle,
        height: 18,
      ),
    ];

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle().copyWith(
        showHeader: false,
        borderStyle: const GeniusPdfBorderStyle.none(),
        outerBorderStyle: const GeniusPdfBorderStyle.none(),
        showGridLines: false,
        showVerticalLines: false,
        showHorizontalLines: false,
        alternateRowColors: false,
      ),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
  }

  // Shared Layout Helpers

  void addSectionHeading(String labelAr, String labelEn) {
    final title = isRTL ? labelAr : labelEn;
    addLine(
      title,
      font: boldBodyFont,
      brush: style.primaryColor.toPdfBrush(),
      topMargin: 0,
    );
  }

  void addInfoSection({
    required String labelAr,
    required String labelEn,
    required List<GeniusPdfLabeledValue> items,
    int columns = 2,
    GeniusPdfInfoBoxStyle? styleOverride,
  }) {
    if (items.isEmpty) return;

    final box = GeniusPdfInfoBox(
      config: config,
      title: labelEn,
      titleAr: labelAr,
      items: items,
      columns: columns,
      style: styleOverride ?? _sectionBoxStyle(),
    );

    addInfoBox(box, spacing: 0);
    addSpace(style.sectionSpacing);
  }

  GeniusPdfInfoBoxStyle _sectionBoxStyle() {
    return const GeniusPdfInfoBoxStyle.headerContent().copyWith(
      borderStyle: GeniusPdfBorderStyle.all(
        color: style.borderColor,
        width: style.borderWidth,
      ),
      headerBackgroundColor: style.tableHeaderColor,
      headerPadding:
          const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      dividerColor: style.borderColor,
      dividerWidth: style.borderWidth,
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: style.bodyFontSize,
        color: style.primaryColor,
        alignment: GeniusPdfTextAlign.start,
      ),
      contentStyle: GeniusPdfTextStyle.body(fontSize: style.bodyFontSize),
      labelStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        fontWeight: m.FontWeight.w600,
        color: style.accentColor,
      ),
      valueStyle: GeniusPdfTextStyle(fontSize: style.bodyFontSize),
      labelAlign: GeniusPdfTextAlign.start,
      valueAlign: GeniusPdfTextAlign.end,
      labelValueLayout: GeniusPdfLabelValueLayout.horizontal,
    );
  }

  GeniusPdfInfoBoxStyle _highlightBoxStyle() {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: style.amountHighlightColor,
      borderStyle: GeniusPdfBorderStyle.all(
        color: style.primaryColor,
        width: style.borderWidth,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: style.bodyFontSize,
        color: style.primaryColor,
        alignment: GeniusPdfTextAlign.start,
      ),
      contentStyle: GeniusPdfTextStyle.body(fontSize: style.bodyFontSize),
      labelStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        fontWeight: m.FontWeight.w600,
        color: style.primaryColor,
      ),
      valueStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        fontWeight: m.FontWeight.bold,
        color: style.primaryColor,
      ),
      labelAlign: GeniusPdfTextAlign.start,
      valueAlign: GeniusPdfTextAlign.end,
      labelValueLayout: GeniusPdfLabelValueLayout.horizontal,
      showDivider: false,
    );
  }

  GeniusPdfLabeledValue _labeledValue(
    String labelAr,
    String labelEn,
    String value,
  ) {
    return GeniusPdfLabeledValue(
      config: config,
      label: labelEn,
      labelAr: labelAr,
      value: value,
    );
  }

  String _signatureRole(VoucherSignatory sig) {
    final roleAr = sig.roleAr ?? sig.role;
    if (roleAr == sig.role) return sig.role;
    return '$roleAr\n${sig.role}';
  }

  /// Draws a data grid for line items.
  void drawItemsTable({
    required List<GeniusPdfGridColumn> columns,
    required List<GeniusPdfGridRow> rows,
    String labelAr = 'التفاصيل',
    String labelEn = 'Details',
  }) {
    addSectionHeading(labelAr, labelEn);
    addSpace(4);
    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
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
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}

/// Internal helper for info pairs.
class _InfoPair {
  const _InfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
