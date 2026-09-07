import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../src/presentation/document/components/components.dart';
import '../models/amount_to_words.dart';
import '../models/models.dart';
import '../models/style.dart';
import 'voucher_base.dart';

/// Modern voucher template matching the "Official" layout style (B5).
///
/// Features:
/// - 3-Column Header (English | Logo | Arabic)
/// - B5 Page Layout
/// - Specific Grid with "Yield To" support
/// - 6-Signature Footer
abstract class ModernVoucherTemplate extends GeniusPdfVoucherTemplate {
  ModernVoucherTemplate({
    required super.config,
    required super.company,
    required super.data,
    super.style = const GeniusPdfVoucherStyle(
      headerHeight: 100,
      showBorder: true,
      borderWidth: 1.0,
      // Optimized font sizes for B5
      titleFontSize: 14,
      bodyFontSize: 10,
      tableFontSize: 9,
      smallFontSize: 8,
    ),
  });

  /// Override to provide specific trade data for the template.
  VoucherTradeData get tradeData;

  @override
  void build() {
    // 1. Page Border
    setDefaultPageBorder(PdfPens.black);

    // 2. Start Page
    newPage();

    // 3. Custom Header (Company Info + Logo)
    _drawModernHeader();

    // 4. Voucher Title Strip (Info Box)
    drawInfoStrip();

    // 5. Party Info "Yield To / Paid To"
    drawPartyRow();

    // 6. Main Content (Grid/Details)
    // Subclasses implement this (e.g. PaymentVoucher)
    buildVoucherContent();

    // 7. Footer (Summary + Signatures)
    drawModernFooter();
  }

  // ---------------------------------------------------------------------------
  // Header Implementation
  // ---------------------------------------------------------------------------

  void _drawModernHeader() {
    // 3-Column Grid:
    // | English Info (Left) | Logo (Center) | Arabic Info (Right) |

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
            id: 'left',
            title: '',
            flexFactor: 3,
            alignment: GeniusPdfTextAlign.start), // English aligned start
        const GeniusPdfGridColumn(
            id: 'center',
            title: '',
            flexFactor: 2,
            alignment: GeniusPdfTextAlign.center),
        const GeniusPdfGridColumn(
            id: 'right',
            title: '',
            flexFactor: 3,
            alignment: GeniusPdfTextAlign.end), // Arabic aligned end
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'left': _buildLeftHeaderNode(),
          'center': _buildLogoNode(),
          'right': _buildRightHeaderNode(),
        })
      ],
      style: const GeniusPdfGridStyle(
          borderStyle: GeniusPdfBorderStyle.all(width: 0.5), // Header Box
          outerBorderStyle: GeniusPdfBorderStyle.all(width: 0.5),
          showGridLines: false, // Clean look inside
          cellStyle: GeniusPdfCellStyle(
            padding: GeniusPdfCellPadding.all(5),
          )),
    );

    addGrid(grid, spacing: 5);
  }

  String _buildLeftHeaderNode() {
    final buffer = StringBuffer();
    // English Side
    buffer.writeln(company.name);
    if (company.phone != null) buffer.writeln('Phone: ${company.phone}');
    if (company.fax != null) buffer.writeln('Fax: ${company.fax}');
    if (company.email != null) buffer.writeln('Email: ${company.email}');
    return buffer.toString();
  }

  String _buildRightHeaderNode() {
    final buffer = StringBuffer();
    // Arabic Side
    if (company.nameAr != null) buffer.writeln(company.nameAr);
    if (company.phone != null) buffer.writeln('${company.phone} :تلفون');
    if (company.fax != null) buffer.writeln('${company.fax} :فاكس');
    // Add more Arabic fields if needed
    return buffer.toString();
  }

  dynamic _buildLogoNode() {
    // Return logo if valid, else Title
    if (config.hasAssets && config.assets.logo != null) {
      return config.assets
          .logo; // The grid handles image rendering if implemented types match
    }
    // Fallback to text title if no logo
    return '\n${data.serviceId.nameAr}\n${data.serviceId.nameEn}';
  }

  @override
  void drawVoucherHeader() {
    // Disable default header
  }

  // ---------------------------------------------------------------------------
  // Info Strip
  // ---------------------------------------------------------------------------

  // Made public for subclasses
  void drawInfoStrip() {
    // Format: | Voucher No | Date | ... |
    // Matching the image:
    // [ Date: ... ] [ Voucher No: ... ] [ Value: ... ]
    // actually image has: Date | Amount | Voucher No #

    final items = [
      _InfoPair('التاريخ', 'Date', _formattedDate),
      _InfoPair('المبلغ', 'Amount', _fmtNum(data.amount)), // Prominent Amount
      _InfoPair('رقم السند', 'No #', data.voucherNumber),
    ];

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: items
          .map((item) => GeniusPdfGridColumn(
              id: item.labelEn,
              title: '',
              flexFactor: 1,
              alignment: GeniusPdfTextAlign.center))
          .toList(),
      rows: [
        GeniusPdfGridRow(cells: {
          for (var i in items) i.labelEn: '${i.labelAr} : ${i.value}'
        })
      ],
      style: const GeniusPdfGridStyle(
        borderStyle:
            GeniusPdfBorderStyle.all(color: m.Colors.black, width: 0.5),
        cellStyle: GeniusPdfCellStyle(
          padding: GeniusPdfCellPadding.symmetric(vertical: 5, horizontal: 2),
        ),
        alternateRowColors: false,
      ),
    );

    // Title Block "سند قبض حوالة"
    final titleBlock = GeniusPdfInfoBox(
        config: config,
        items: [
          GeniusPdfLabeledValue(
              config: config,
              label: '',
              value: data.serviceId.nameAr,
              valueStyle: const GeniusPdfTextStyle(
                  fontSize: 16,
                  fontWeight: m.FontWeight.bold,
                  alignment: GeniusPdfTextAlign.center))
        ],
        style: const GeniusPdfInfoBoxStyle(
            borderStyle: GeniusPdfBorderStyle.all(width: 0.5),
            padding: GeniusPdfCellPadding.all(5)),
        columns: 1);

    addInfoBox(titleBlock, spacing: 5);
    addGrid(grid, spacing: 10);
  }

  // ---------------------------------------------------------------------------
  // Party Info
  // ---------------------------------------------------------------------------

  void drawPartyRow() {
    final name = isRTL
        ? (data.party?.nameAr ?? data.party?.name ?? '')
        : (data.party?.name ?? '');

    // Prominent "Received from / Paid to" line
    // Image says: "مبلغ الحوالة كتابة" (Amount in words) followed by details?
    // Actually typically:
    // "Received from: ..."
    // "Sum of: ..."

    // Let's stick to a generic "Party" line for now, specific templates overlap this.
    // In PaymentVoucher, it will populate this.

    // For now we add a spacer or the "Amount in Words" here if it's central.
    // The image usually has the "Amount in Words" prominently in the middle.

    final words = isRTL
        ? AmountToWords.toArabic(data.amount, currency: data.currency)
        : AmountToWords.toEnglish(data.amount, currency: data.currency);

    final String label =
        isRTL ? 'يقيد على / استلمنا من' : 'Received From / Charge To';

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [const GeniusPdfGridColumn(id: 'c1', title: '', flexFactor: 1)],
      rows: [
        GeniusPdfGridRow(
            cells: {'c1': '$label: $name\n\nمبلغ وقدره: $words فقط لا غير'},
            style: const GeniusPdfCellStyle(
                textStyle: GeniusPdfTextStyle(
                    fontWeight: m.FontWeight.bold, fontSize: 11),
                backgroundColor: m.Color(0xFFF0F0F0))) // Light grey background
      ],
      style: const GeniusPdfGridStyle(
          borderStyle: GeniusPdfBorderStyle.all(width: 0.5),
          cellStyle: GeniusPdfCellStyle(
            padding: GeniusPdfCellPadding.symmetric(vertical: 6, horizontal: 8),
          )),
    );
    addGrid(grid, spacing: 10);
  }

  // ---------------------------------------------------------------------------
  // Footer Implementation
  // ---------------------------------------------------------------------------

  void drawModernFooter() {
    // Footer Structure from Image:
    // 1. Totals / Summary (if trade)
    // 2. Signatures (6 blocks)
    // 3. Bottom Strip (Phone/User/Time)

    // Signatures
    // Titles from image:
    // مدير المبيعات , مدير الحسابات , المخازن , مندوب المبيعات , المحاسب , العميل
    final sigs = [
      'العميل',
      'المحاسب',
      'مندوب المبيعات',
      'المخازن',
      'مدير الحسابات',
      'مدير المبيعات',
    ];

    drawCustomSignatures(sigs);

    // QR Code would typically go here or bottom left.
    // We can add it if `data` supports link/string for QR.
  }

  void drawCustomSignatures(List<String> titles) {
    // We want them distributed evenly. 6 items.
    // 2 Rows of 3? Or 1 Row of 6?
    // B5 is narrow (176mm). 6 cols might be tight.
    // Image shows 1 row.

    final cols = titles
        .map((t) => GeniusPdfGridColumn(
            id: t, title: t, alignment: GeniusPdfTextAlign.center))
        .toList();

    // Empty row for signature space
    final row =
        GeniusPdfGridRow(cells: {for (var t in titles) t: ''}, height: 40);

    final grid = GeniusPdfDataGrid(
        config: config,
        columns: cols,
        rows: [row],
        style: const GeniusPdfGridStyle(
          showHeader: true,
          headerStyle: GeniusPdfCellStyle(
              textStyle: GeniusPdfTextStyle(
                  fontWeight: m.FontWeight.bold, fontSize: 9), // Smaller font
              border: GeniusPdfBorderStyle.none()),
          borderStyle: GeniusPdfBorderStyle.top(width: 0.5), // Separator line
        ));

    // Add spacing before footer
    addSpace(20);
    addGrid(grid, spacing: 5);
  }

  // Helpers
  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String get _formattedDate =>
      '${data.voucherDate.year}/${data.voucherDate.month.toString().padLeft(2, '0')}/${data.voucherDate.day.toString().padLeft(2, '0')}';
}

class _InfoPair {
  const _InfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
