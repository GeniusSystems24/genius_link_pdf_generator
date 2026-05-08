/// Multi-voucher batch PDF generator.
///
/// Combines multiple voucher templates into a single PDF document
/// with optional table of contents and batch summary page.
library;

import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../src/builders/pdf_document_builder.dart';
import '../../../src/components/components.dart';
import '../../../src/core/pdf_config.dart';
import '../../../src/extensions/color_extensions.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Options for batch voucher generation.
class GeniusPdfVoucherBatchOptions {
  const GeniusPdfVoucherBatchOptions({
    this.addPageBreakBetweenVouchers = true,
    this.addBatchSummary = false,
    this.batchTitle,
    this.batchTitleAr,
  });

  final bool addPageBreakBetweenVouchers;
  final bool addBatchSummary;
  final String? batchTitle;
  final String? batchTitleAr;
}

/// Generates a single PDF containing multiple vouchers.
///
/// ```dart
/// final batch = GeniusPdfVoucherBatch(
///   config: config,
///   company: companyInfo,
///   vouchers: [receiptVoucher, paymentVoucher, taxVoucher],
///   options: GeniusPdfVoucherBatchOptions(
///     addBatchSummary: true,
///     batchTitle: 'Daily Vouchers',
///     batchTitleAr: 'سندات اليوم',
///   ),
/// );
/// final bytes = batch.generate();
/// batch.dispose();
/// ```
class GeniusPdfVoucherBatch {
  GeniusPdfVoucherBatch({
    required this.config,
    required this.vouchers,
    this.options = const GeniusPdfVoucherBatchOptions(),
    this.style = const GeniusPdfVoucherStyle(),
  });

  final GeniusPdfConfig config;
  final List<GeniusPdfVoucherTemplate> vouchers;
  final GeniusPdfVoucherBatchOptions options;
  final GeniusPdfVoucherStyle style;

  /// Generates the batch PDF and returns the bytes.
  List<int> generate() {
    if (vouchers.isEmpty) return [];

    // Generate each voucher individually and merge
    final document = PdfDocument();
    _applySettings(document);

    for (var i = 0; i < vouchers.length; i++) {
      final voucher = vouchers[i];
      final voucherBytes = voucher.generate();
      final voucherDoc = PdfDocument(inputBytes: Uint8List.fromList(voucherBytes));

      // Copy pages from voucher to batch document
      for (var p = 0; p < voucherDoc.pages.count; p++) {
        final template = voucherDoc.pages[p].createTemplate();
        final batchPage = document.pages.add();
        batchPage.graphics.drawPdfTemplate(
          template,
          Offset.zero,
          Size(batchPage.getClientSize().width, batchPage.getClientSize().height),
        );
      }

      voucherDoc.dispose();
      voucher.dispose();
    }

    // Add summary page if requested
    if (options.addBatchSummary) {
      _addSummaryPage(document);
    }

    final bytes = document.saveSync();
    document.dispose();
    return bytes;
  }

  void _applySettings(PdfDocument doc) {
    doc.compressionLevel = config.compressionLevel;
    doc.pageSettings.size = config.pageSize;
    doc.pageSettings.orientation = config.orientation;
    doc.pageSettings.margins = config.margins;
  }

  void _addSummaryPage(PdfDocument doc) {
    final summaryBuilder = _VoucherBatchSummaryBuilder(
      config: config,
      vouchers: vouchers,
      options: options,
      style: style,
    );
    final bytes = summaryBuilder.generate();
    summaryBuilder.dispose();

    final summaryDoc = PdfDocument(inputBytes: Uint8List.fromList(bytes));
    final template = summaryDoc.pages[0].createTemplate();
    final page = doc.pages.add();
    page.graphics.drawPdfTemplate(
      template,
      Offset.zero,
      Size(page.getClientSize().width, page.getClientSize().height),
    );
    summaryDoc.dispose();
  }

  void dispose() {
    // Templates already disposed in generate()
  }
}

class _VoucherBatchSummaryBuilder extends GeniusPdfDocumentBuilder {
  _VoucherBatchSummaryBuilder({
    required GeniusPdfConfig config,
    required this.vouchers,
    required this.options,
    required this.style,
  }) : super(config);

  final List<GeniusPdfVoucherTemplate> vouchers;
  final GeniusPdfVoucherBatchOptions options;
  final GeniusPdfVoucherStyle style;

  @override
  void build() {
    if (style.showBorder) {
      setDefaultPageBorder(
        style.borderColor.toPdfPen(width: style.borderWidth),
      );
    }

    final titleText = _resolveTitle();
    final titleRich = GeniusPdfRichTextBuilder(
      config: config,
      defaultStyle: GeniusPdfTextStyle(
        fontSize: style.titleFontSize,
        color: style.primaryColor,
        alignment: GeniusPdfTextAlign.center,
      ),
      paragraphAlignment: GeniusPdfParagraphAlignment.center,
    ).bold(titleText, color: style.primaryColor).build();
    addRichText(titleRich, spacing: 0);
    addSpace(6);

    final subtitle =
        'عدد السندات: ${vouchers.length}  |  Total Vouchers: ${vouchers.length}';
    final subtitleRich = GeniusPdfRichTextBuilder(
      config: config,
      defaultStyle: GeniusPdfTextStyle(
        fontSize: style.bodyFontSize,
        color: style.accentColor,
        alignment: GeniusPdfTextAlign.center,
      ),
      paragraphAlignment: GeniusPdfParagraphAlignment.center,
    ).text(subtitle).build();
    addRichText(subtitleRich, spacing: 0);
    addSpace(style.sectionSpacing);

    final rows = <GeniusPdfGridRow>[];
    double totalAmount = 0;

    for (var i = 0; i < vouchers.length; i++) {
      final v = vouchers[i].data;
      totalAmount += v.amount;
      rows.add(GeniusPdfGridRow(cells: {
        'idx': i + 1,
        'number': v.voucherNumber,
        'type': v.serviceId.bilingualName(),
        'amount': '${_formatNum(v.amount)} ${v.currency}',
      }));
    }

    rows.add(GeniusPdfGridRow.total({
      'idx': '',
      'number': '',
      'type': isRTL ? 'الإجمالي' : 'Total',
      'amount': '${_formatNum(totalAmount)} ${vouchers.first.data.currency}',
    }));

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: const [
        GeniusPdfGridColumn(
          id: 'idx',
          title: '#',
          titleAr: '#',
          width: 32,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn(
          id: 'number',
          title: 'Voucher No',
          titleAr: 'رقم السند',
          flexFactor: 2,
        ),
        GeniusPdfGridColumn(
          id: 'type',
          title: 'Type',
          titleAr: 'النوع',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          flexFactor: 2,
          alignment: GeniusPdfTextAlign.end,
        ),
      ],
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
    );

    addGrid(grid, spacing: 0);
  }

  String _resolveTitle() {
    if (options.batchTitleAr != null && options.batchTitle != null) {
      return '${options.batchTitleAr}  |  ${options.batchTitle}';
    }
    if (options.batchTitleAr != null) return options.batchTitleAr!;
    if (options.batchTitle != null) return options.batchTitle!;
    return 'ملخص الدفعة  |  Batch Summary';
  }

  String _formatNum(double n) {
    return n.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}
