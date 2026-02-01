import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors, PdfColor;

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfGridStyle, PdfBorderStyle, PdfGridColumn, PdfGridRow;

class CustomReportData {
  final String reportTitle;
  final String reportTitleAr;
  final String companyName;
  final String companyNameAr;
  final GeniusPdfConfig config;
  final bool includeHeader;
  final bool includeFooter;
  final bool includeLogo;
  final bool includeInfoBox;
  final bool includeDataGrid;
  final bool includeRichText;
  final bool includeSummary;
  final String infoBoxTitle;
  final String infoBoxContent;
  final String infoBoxStyleType;
  final int gridRows;
  final int gridColumns;
  final bool gridShowTotals;
  final double subtotal;
  final double tax;
  final double discount;

  const CustomReportData({
    required this.reportTitle,
    required this.reportTitleAr,
    required this.companyName,
    required this.companyNameAr,
    required this.config,
    required this.includeHeader,
    required this.includeFooter,
    required this.includeLogo,
    required this.includeInfoBox,
    required this.includeDataGrid,
    required this.includeRichText,
    required this.includeSummary,
    required this.infoBoxTitle,
    required this.infoBoxContent,
    required this.infoBoxStyleType,
    required this.gridRows,
    required this.gridColumns,
    required this.gridShowTotals,
    required this.subtotal,
    required this.tax,
    required this.discount,
  });
}

Future<Uint8List> buildCustomReportPdf(CustomReportData data) async {
  final isRtl = data.config.textDirection == TextDirection.rtl;
  final document = PdfDocument();
  final page = document.pages.add();
  final graphics = page.graphics;
  final pageSize = page.getClientSize();

  double yOffset = 0;
  const double margin = 20;
  final contentWidth = pageSize.width - (margin * 2);

  // Use fonts from GeniusPdfConfig
  final PdfFont regularFont = data.config.baseFont;
  final PdfFont boldFont = data.config.boldFont;
  final PdfFont titleFont = data.config.headerFont;
  final PdfFont subtitleFont = data.config.smallFont;

  // Draw Header
  if (data.includeHeader) {
    final headerBounds = Rect.fromLTWH(margin, yOffset, contentWidth, 80);

    // Company name and title
    final displayTitle = isRtl ? data.reportTitleAr : data.reportTitle;
    final displayCompany = isRtl ? data.companyNameAr : data.companyName;

    // Draw header background
    graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(99, 102, 241)), // Indigo primary
      bounds: headerBounds,
    );

    // Draw title
    graphics.drawString(
      displayCompany,
      titleFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(margin + 10, yOffset + 15, contentWidth - 20, 30),
      format: PdfStringFormat(
        alignment: isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection:
            isRtl ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      ),
    );

    graphics.drawString(
      displayTitle,
      subtitleFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(margin + 10, yOffset + 45, contentWidth - 20, 20),
      format: PdfStringFormat(
        alignment: isRtl ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection:
            isRtl ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      ),
    );

    // Draw date
    final dateStr = DateTime.now().toString().substring(0, 10);
    graphics.drawString(
      dateStr,
      regularFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(margin + 10, yOffset + 45, contentWidth - 20, 20),
      format: PdfStringFormat(
        alignment: isRtl ? PdfTextAlignment.left : PdfTextAlignment.right,
      ),
    );

    yOffset += 100;
  }

  // Draw Info Box
  if (data.includeInfoBox) {
    final infoBoxStyle = _getInfoBoxStyle(data.infoBoxStyleType);
    final infoBox = GeniusPdfInfoBox(
      config: data.config,
      title: data.infoBoxTitle,
      items: [
        GeniusPdfLabeledValue(
          config: data.config,
          label: data.infoBoxTitle,
          value: data.infoBoxContent,
        ),
      ],
      style: infoBoxStyle,
    );

    final result = infoBox.draw(
      page: page,
      bounds: Rect.fromLTWH(margin, yOffset, contentWidth, 0),
    );
    yOffset = result.bottom + 20;
  }

  // Draw Rich Text Section
  if (data.includeRichText) {
    final richText = GeniusPdfRichTextBuilder(
            config: data.config,
            baseFont: regularFont,
            boldFont: boldFont,
            isRTL: isRtl)
        .text('This is a ')
        .bold('custom report ')
        .text('generated using the ')
        .bold('Genius Link PDF Generator', color: const Color(0xFF6366F1))
        .text(' library. ')
        .text('It supports ')
        .colored('colored text', Colors.green)
        .text(', ')
        .bold('bold')
        .text(', ')
        .italic('italic')
        .text(', ')
        .highlight('highlighted')
        .text(', ')
        .strikethrough('deleted text')
        .text(', ')
        .code('inline code')
        .text(', ')
        .superscript('superscript')
        .text(', and ')
        .link('clickable links', 'https://example.com')
        .text('.')
        .build();

    final textResult = richText.draw(
      page: page,
      bounds: Rect.fromLTWH(margin, yOffset, contentWidth, 60),
    );
    yOffset = (textResult?.bounds.bottom ?? 0) + 20;
  }

  // Draw Data Grid
  if (data.includeDataGrid) {
    final columns = _generateColumns(data.gridColumns);
    final rows = _generateRows(data.gridRows);

    final dataGrid = GeniusPdfDataGrid(
      config: data.config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle(
        headerStyle:
            GeniusPdfCellStyle(backgroundColor: const Color(0xFF6366F1)),
        alternateRowStyle:
            GeniusPdfCellStyle(backgroundColor: const Color(0xFFF8FAFC)),
        borderStyle: GeniusPdfBorderStyle.all(color: const Color(0xFFE2E8F0)),
      ),
    );

    final gridResult = dataGrid.draw(
      page: page,
      bounds: Rect.fromLTWH(margin, yOffset, contentWidth, 0),
    );
    yOffset = (gridResult?.bounds.bottom ?? 0) + 20;
  }

  // Draw Summary Section
  if (data.includeSummary) {
    final summary = GeniusPdfSummarySection(
      config: data.config,
      items: [
        GeniusPdfSummaryItem(
          label: 'Subtotal',
          labelAr: 'المجموع الفرعي',
          value: 'SAR ${data.subtotal.toStringAsFixed(2)}',
        ),
        GeniusPdfSummaryItem(
          label: 'Tax (15%)',
          labelAr: 'الضريبة (15%)',
          value: 'SAR ${data.tax.toStringAsFixed(2)}',
        ),
        GeniusPdfSummaryItem(
          label: 'Discount',
          labelAr: 'الخصم',
          value: '- SAR ${data.discount.toStringAsFixed(2)}',
          valueColor: Colors.red,
        ),
      ],
      title: 'Total',
      titleAr: 'الإجمالي',
      alignment: GeniusPdfSummaryAlignment.right,
      width: contentWidth / 2,
    );

    final summaryBounds = Rect.fromLTWH(
      isRtl ? margin : margin + contentWidth / 2,
      yOffset,
      contentWidth / 2,
      0,
    );

    final summaryResult = summary.draw(page: page, bounds: summaryBounds);
    yOffset = (summaryResult.bottom) + 20;
  }

  // Draw Footer
  if (data.includeFooter) {
    final footerY = pageSize.height - 30;

    graphics.drawLine(
      PdfPen(PdfColor(200, 200, 200)),
      Offset(margin, footerY - 10),
      Offset(pageSize.width - margin, footerY - 10),
    );

    graphics.drawString(
      'Generated by Genius Link PDF Generator',
      regularFont,
      brush: PdfBrushes.gray,
      bounds: Rect.fromLTWH(margin, footerY, contentWidth / 2, 20),
    );

    graphics.drawString(
      'Page 1 of 1',
      regularFont,
      brush: PdfBrushes.gray,
      bounds: Rect.fromLTWH(
          margin + contentWidth / 2, footerY, contentWidth / 2, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
  }

  final bytes = await document.save();
  document.dispose();
  return Uint8List.fromList(bytes);
}

GeniusPdfInfoBoxStyle _getInfoBoxStyle(String styleType) {
  switch (styleType) {
    case 'Highlighted':
      return const GeniusPdfInfoBoxStyle.highlighted();
    case 'Header Content':
      return const GeniusPdfInfoBoxStyle.headerContent();
    case 'Card':
    default:
      return const GeniusPdfInfoBoxStyle.card();
  }
}

List<GeniusPdfGridColumn> _generateColumns(int gridColumns) {
  final columnNames = [
    ('Item', 'البند'),
    ('Description', 'الوصف'),
    ('Quantity', 'الكمية'),
    ('Unit Price', 'سعر الوحدة'),
    ('Total', 'الإجمالي'),
    ('Notes', 'ملاحظات'),
  ];

  return List.generate(
    gridColumns.clamp(1, 6),
    (index) => GeniusPdfGridColumn(
      id: columnNames[index].$1.toLowerCase().replaceAll(' ', '_'),
      title: columnNames[index].$1,
      titleAr: columnNames[index].$2,
      width: index == 0 ? 80 : (index == 1 ? 120 : 80),
      alignment:
          index >= 2 ? GeniusPdfTextAlign.center : GeniusPdfTextAlign.left,
    ),
  );
}

List<GeniusPdfGridRow> _generateRows(int gridRows) {
  final sampleItems = [
    'Product A',
    'Product B',
    'Product C',
    'Service X',
    'Service Y',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  return List.generate(
    gridRows.clamp(1, 20),
    (rowIndex) {
      final qty = (rowIndex + 1) * 2;
      final price = 100.0 + (rowIndex * 25);
      final total = qty * price;

      final values = <String, dynamic>{
        'item': sampleItems[rowIndex % sampleItems.length],
        'description': 'Sample description for row ${rowIndex + 1}',
        'quantity': qty.toString(),
        'unit_price': 'SAR ${price.toStringAsFixed(2)}',
        'total': 'SAR ${total.toStringAsFixed(2)}',
        'notes': rowIndex % 2 == 0 ? 'In stock' : 'On order',
      };

      return GeniusPdfGridRow(cells: values);
    },
  );
}
