import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/financial/financial.dart';
import '../core/pdf_config.dart';
import '../models/pdf_result.dart';

/// Note type enum for credit/debit notes.
enum NoteType {
  credit,
  debit,
}

/// Credit/Debit note line item.
class NoteLineItem {
  const NoteLineItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.reason,
    this.reasonAr,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final double unitPrice;
  final String? reason;
  final String? reasonAr;

  double get lineTotal => quantity * unitPrice;
}

/// Credit/Debit note reason.
enum NoteReason {
  returnedGoods,
  damagedGoods,
  priceAdjustment,
  discountAllowed,
  overcharge,
  shortDelivery,
  other,
}

/// Customer/Vendor info for notes.
class NoteParty {
  const NoteParty({
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

/// Credit/Debit note data model.
class CreditDebitNoteData {
  const CreditDebitNoteData({
    required this.noteNumber,
    required this.noteDate,
    required this.noteType,
    required this.items,
    this.originalInvoiceNumber,
    this.originalInvoiceDate,
    this.reason,
    this.reasonAr,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.currency = 'SAR',
  });

  final String noteNumber;
  final DateTime noteDate;
  final NoteType noteType;
  final String? originalInvoiceNumber;
  final DateTime? originalInvoiceDate;
  final String? reason;
  final String? reasonAr;
  final List<NoteLineItem> items;
  final List<({String name, String? nameAr, double rate})> taxes;
  final String? notes;
  final String? notesAr;
  final String currency;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get totalTax =>
      taxes.fold(0.0, (sum, tax) => sum + (subtotal * tax.rate / 100));
  double get grandTotal => subtotal + totalTax;

  String get noteTypeTitle =>
      noteType == NoteType.credit ? 'Credit Note' : 'Debit Note';
  String get noteTypeTitleAr =>
      noteType == NoteType.credit ? 'إشعار دائن' : 'إشعار مدين';
}

/// A professional credit note template.
///
/// Creates credit notes for returns, discounts, or adjustments.
///
/// ## Example
/// ```dart
/// final creditNote = CreditNoteTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   party: customerInfo,
///   note: creditNoteData,
/// );
///
/// final bytes = creditNote.generate();
/// ```
class CreditNoteTemplate extends GeniusPdfDocumentBuilder {
  CreditNoteTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.party,
    required this.note,
    this.boldFont,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final NoteParty party;
  final CreditDebitNoteData note;
  final PdfFont? boldFont;

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  PdfColor get _accentColor => note.noteType == NoteType.credit
      ? PdfColor(0, 100, 180)
      : PdfColor(180, 100, 0);

  @override
  void build() {
    newPage();

    _drawHeader();
    _drawInfoSection();

    if (note.reason != null || note.reasonAr != null) {
      _drawReasonSection();
    }

    _drawItemsTable();
    _drawSummary();

    if (note.notes != null || note.notesAr != null) {
      _drawNotes();
    }

    _drawSignatureSection();
  }

  /// Validates financial totals then generates the PDF.
  ///
  /// Returns [GeniusPdfFailure] if subtotal, VAT, or grand total validation
  /// fails. Pass `validateFinancials: false` to skip validation.
  Future<GeniusPdfResult> generateResult({
    bool validateFinancials = true,
    GeniusFinancialValidationContext? validationContext,
  }) async {
    if (validateFinancials) {
      final policy =
          validationContext?.roundingPolicy ?? GeniusRoundingPolicy.defaults();
      final validator = GeniusFinancialValidator(policy);

      final lineTotals = note.items.map((i) => i.lineTotal).toList();
      final subtotalResult = validator.validateSubtotal(
        lineTotals: lineTotals,
        providedSubtotal: note.subtotal,
      );

      final vatResults = note.taxes
          .map((tax) => validator.validateVat(
                vatBase: note.subtotal,
                vatRate: tax.rate,
                providedVatAmount: note.subtotal * tax.rate / 100,
              ))
          .toList();

      final grandTotalResult = validator.validateGrandTotal(
        subtotal: note.subtotal,
        discounts: 0.0,
        vatAmount: note.totalTax,
        fees: 0.0,
        providedGrandTotal: note.grandTotal,
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
        fileName: 'note_${note.noteNumber}.pdf',
      );
    } catch (e, st) {
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  void _drawHeader() {
    // Note type badge
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(_accentColor),
      bounds: Rect.fromLTWH(pageWidth - 100, 5, 95, 22),
    );

    currentPage.graphics.drawString(
      config.isRTL ? note.noteTypeTitleAr : note.noteTypeTitle,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(pageWidth - 100, 5, 95, 22),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection),
    );

    final header = GeniusPdfReportHeader(
      config: config,
      title: note.noteTypeTitle,
      titleAr: note.noteTypeTitleAr,
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 20),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(105);
  }

  void _drawInfoSection() {
    final partyTitle = note.noteType == NoteType.credit
        ? (config.isRTL ? 'إلى (العميل)' : 'To (Customer)')
        : (config.isRTL ? 'من (المورد)' : 'From (Vendor)');

    final partyBox = GeniusPdfInfoBox(
      config: config,
      title: partyTitle,
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL ? (party.nameAr ?? party.name) : party.name,
        ),
        if (party.address != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Address',
            labelAr: 'العنوان',
            value: config.isRTL
                ? (party.addressAr ?? party.address!)
                : party.address!,
          ),
        if (party.vatNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: party.vatNumber!,
          ),
        if (party.accountNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Account No',
            labelAr: 'رقم الحساب',
            value: party.accountNumber!,
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final noteBox = GeniusPdfInfoBox(
      config: config,
      title: 'Note Details',
      titleAr: 'تفاصيل الإشعار',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Note No',
          labelAr: 'رقم الإشعار',
          value: note.noteNumber,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: _formatDate(note.noteDate),
        ),
        if (note.originalInvoiceNumber != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Original Invoice',
            labelAr: 'الفاتورة الأصلية',
            value: note.originalInvoiceNumber!,
          ),
        if (note.originalInvoiceDate != null)
          GeniusPdfLabeledValue(
            config: config,
            label: 'Invoice Date',
            labelAr: 'تاريخ الفاتورة',
            value: _formatDate(note.originalInvoiceDate!),
          ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: config.isRTL ? noteBox : partyBox,
      rightBox: config.isRTL ? partyBox : noteBox,
      spacing: 20,
    );

    final result = dualBox.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 130),
    );

    addSpace(result.height + 20);
  }

  void _drawReasonSection() {
    final reasonTitle = config.isRTL ? 'سبب الإشعار' : 'Reason for Note';
    final reasonText =
        config.isRTL ? (note.reasonAr ?? note.reason!) : note.reason!;

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(250, 250, 220)),
      pen: PdfPen(_accentColor),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 40),
    );

    currentPage.graphics.drawString(
      '$reasonTitle: $reasonText',
      _boldFont,
      bounds: Rect.fromLTWH(10, currentY + 12, pageWidth - 20, 20),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(50);
  }

  void _drawItemsTable() {
    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'no',
          title: '#',
          titleAr: '#',
          width: 30,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        const GeniusPdfGridColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
        const GeniusPdfGridColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Unit Price',
          titleAr: 'سعر الوحدة',
          width: 85,
          currencySymbol: '',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Amount',
          titleAr: 'المبلغ',
          width: 95,
          currencySymbol: '',
        ),
      ],
      rows: note.items
          .map((item) => GeniusPdfGridRow(cells: {
                'no': item.itemNumber,
                'description': config.isRTL
                    ? (item.descriptionAr ?? item.description)
                    : item.description,
                'reason': config.isRTL
                    ? (item.reasonAr ?? item.reason ?? '')
                    : (item.reason ?? ''),
                'qty': item.quantity,
                'price': item.unitPrice,
                'total': item.lineTotal,
              }))
          .toList(),
      style: GeniusPdfGridStyle.modern(),
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
        labelAr: 'المجموع الفرعي',
        value: _formatCurrency(note.subtotal),
      ),
    ];

    for (final tax in note.taxes) {
      items.add(GeniusPdfSummaryItem(
        label: '${tax.name} (${tax.rate}%)',
        labelAr: '${tax.nameAr ?? tax.name} (${tax.rate}%)',
        value: _formatCurrency(note.subtotal * tax.rate / 100),
      ));
    }

    final totalLabel = note.noteType == NoteType.credit
        ? 'Total Credit Amount'
        : 'Total Debit Amount';
    final totalLabelAr = note.noteType == NoteType.credit
        ? 'إجمالي المبلغ الدائن'
        : 'إجمالي المبلغ المدين';

    items.add(GeniusPdfSummaryItem.total(
      label: totalLabel,
      labelAr: totalLabelAr,
      value: _formatCurrency(note.grandTotal),
    ));

    final summary = GeniusPdfSummarySection(
      config: config,
      items: items,
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.45,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 150),
    );

    addSpace(result.height + 15);
  }

  void _drawNotes() {
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText =
        config.isRTL ? (note.notesAr ?? note.notes!) : note.notes!;

    currentPage.graphics.drawString(
      '$notesLabel\n$notesText',
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 50),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    addSpace(55);
  }

  void _drawSignatureSection() {
    final bottomY = pageHeight - 80;

    // Prepared by
    final preparedBy = GeniusPdfSignatureArea(config: config,
      title: 'Prepared By',
      titleAr: 'أعده',
    );

    preparedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, bottomY, 180, 60),
    );

    // Approved by
    final approvedBy = GeniusPdfSignatureArea(config: config,
      title: 'Approved By',
      titleAr: 'اعتمده',
    );

    approvedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(pageWidth - 180, bottomY, 180, 60),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${note.currency}';
  }
}

/// Convenience alias for DebitNoteTemplate (uses same class with different type).
typedef DebitNoteTemplate = CreditNoteTemplate;
