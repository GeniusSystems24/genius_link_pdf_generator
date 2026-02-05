/// Multi-voucher batch PDF generator.
///
/// Combines multiple voucher templates into a single PDF document
/// with optional table of contents and batch summary page.
library;

import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/pdf_config.dart';
import '../models/voucher_models.dart';
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
    final page = doc.pages.add();
    final g = page.graphics;
    final font = config.fontBuild(fontSize: style.titleFontSize);
    final bodyFont = config.fontBuild(fontSize: style.bodyFontSize);
    final boldFont = config.fontBuild(
        fontSize: style.bodyFontSize,
        fontBytes: config.boldFontBytes ?? config.baseFontBytes);
    final w = page.getClientSize().width;
    var y = 20.0;

    // Title
    final title = options.batchTitleAr ?? options.batchTitle ?? 'ملخص الدفعة  |  Batch Summary';
    g.drawString(
      title,
      font,
      brush: PdfSolidBrush(PdfColor.fromCMYK(80, 60, 0, 40)),
      bounds: Rect.fromLTWH(0, y, w, 22),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    y += 30;

    // Subtitle
    g.drawString(
      'عدد السندات: ${vouchers.length}  |  Total Vouchers: ${vouchers.length}',
      bodyFont,
      bounds: Rect.fromLTWH(0, y, w, 14),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
    y += 24;

    // Voucher list
    final headerColor = PdfSolidBrush(PdfColor.fromCMYK(80, 60, 0, 40));
    g.drawString('#', boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(0, y, 30, 14));
    g.drawString('Voucher No / رقم السند', boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(30, y, 150, 14));
    g.drawString('Type / النوع', boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(180, y, 180, 14));
    g.drawString('Amount / المبلغ', boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(360, y, w - 360, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.right));
    y += 16;

    g.drawLine(PdfPen(PdfColor(180, 180, 180), width: 0.5),
        Offset(0, y), Offset(w, y));
    y += 4;

    double totalAmount = 0;
    for (var i = 0; i < vouchers.length; i++) {
      final v = vouchers[i].data;
      totalAmount += v.amount;

      g.drawString('${i + 1}', bodyFont, bounds: Rect.fromLTWH(0, y, 30, 14));
      g.drawString(v.voucherNumber, bodyFont, bounds: Rect.fromLTWH(30, y, 150, 14));
      g.drawString(v.serviceId.bilingualName(), bodyFont,
          bounds: Rect.fromLTWH(180, y, 180, 14));
      g.drawString('${_formatNum(v.amount)} ${v.currency}', bodyFont,
          bounds: Rect.fromLTWH(360, y, w - 360, 14),
          format: PdfStringFormat(alignment: PdfTextAlignment.right));
      y += 16;
    }

    // Total
    y += 4;
    g.drawLine(PdfPen(PdfColor(180, 180, 180), width: 0.5),
        Offset(0, y), Offset(w, y));
    y += 6;
    g.drawString('الإجمالي  |  Total', boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(0, y, 360, 14));
    g.drawString('${_formatNum(totalAmount)} ${vouchers.first.data.currency}',
        boldFont, brush: headerColor,
        bounds: Rect.fromLTWH(360, y, w - 360, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.right));
  }

  String _formatNum(double n) {
    return n.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  void dispose() {
    // Templates already disposed in generate()
  }
}
