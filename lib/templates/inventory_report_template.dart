import 'dart:ui';
import 'package:flutter/material.dart' as m;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:intl/intl.dart';

import '../src/builders/pdf_document_builder.dart';
import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

/// Inventory item data.
class InventoryItem {
  const InventoryItem({
    required this.itemCode,
    required this.itemName,
    this.itemNameAr,
    required this.warehouse,
    this.warehouseAr,
    required this.quantityOnHand,
    required this.averageCost,
    this.unit,
    this.category,
    this.categoryAr,
  });

  final String itemCode;
  final String itemName;
  final String? itemNameAr;
  final String warehouse;
  final String? warehouseAr;
  final double quantityOnHand;
  final double averageCost;
  final String? unit;
  final String? category;
  final String? categoryAr;

  double get totalValue => quantityOnHand * averageCost;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && itemNameAr != null) return itemNameAr!;
    return itemName;
  }

  /// Gets the display warehouse based on locale.
  String getWarehouse({bool isArabic = false}) {
    if (isArabic && warehouseAr != null) return warehouseAr!;
    return warehouse;
  }

  /// Gets the display category based on locale.
  String? getCategory({bool isArabic = false}) {
    if (isArabic && categoryAr != null) return categoryAr;
    return category;
  }
}

/// Inventory category with items.
class InventoryCategory {
  const InventoryCategory({
    required this.name,
    required this.items,
    this.nameAr,
  });

  final String name;
  final String? nameAr;
  final List<InventoryItem> items;

  /// Gets the display name based on locale.
  String getName({bool isArabic = false}) {
    if (isArabic && nameAr != null) return nameAr!;
    return name;
  }

  double get totalValue => items.fold(0, (sum, item) => sum + item.totalValue);
  double get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantityOnHand);
}

/// Inventory report data.
class InventoryReportData {
  const InventoryReportData({
    required this.asOfDate,
    required this.categories,
    this.currency = 'SAR',
  });

  final DateTime asOfDate;
  final List<InventoryCategory> categories;
  final String currency;

  List<InventoryItem> get allItems =>
      categories.expand((c) => c.items).toList();

  double get totalValue => categories.fold(0, (sum, c) => sum + c.totalValue);
  double get totalQuantity =>
      categories.fold(0, (sum, c) => sum + c.totalQuantity);
}

/// An inventory valuation report template.
///
/// Creates a detailed inventory report with:
/// - Item listing by category
/// - Quantity and cost information
/// - Total valuations
///
/// ## Example
/// ```dart
/// final report = InventoryReportTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: inventoryData,
/// );
///
/// final bytes = report.generate();
/// ```
class InventoryReportTemplate extends GeniusPdfDocumentBuilder {
  InventoryReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.showCategories = true,
    this.showCategorySubtotals = true,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final InventoryReportData data;
  final bool showCategories;
  final bool showCategorySubtotals;

  /// Report ID for QR code URL (e.g., "INV-2024-001")
  final String? reportId;

  /// User who printed the report
  final String? printedBy;

  /// Whether to show QR code with report link
  final bool showQRCode;

  /// Whether to show signature areas
  final bool showSignatures;

  /// Whether to show notes section
  final bool showNotes;

  /// Custom notes to display
  final String? notes;
  final String? notesAr;

  @override
  void build() {
    // Add repeating footer with user info on all pages
    if (printedBy != null || showQRCode) {
      addFooter(
        userName: printedBy,
        printTime: _formatDate(DateTime.now()),
        showPageNumber: true,
      );
    }

    newPage();

    // Header
    _drawHeader();

    // Inventory table
    _drawTable();

    // Grand total
    _drawGrandTotal();

    // Summary section with report info
    _drawSummary();

    // Draw Footer Section (Notes + QR Code)
    _drawFooterSection();

    // Signatures section (without QR code since it's in footer)
    if (showSignatures) {
      _drawSignatures();
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: config.isLTR
          ? 'Inventory Valuation Report As of ${_formatDateLong(data.asOfDate)}'
          : 'تقرير تقييم المخزون كما في ${_formatDateArabic(data.asOfDate)}',
      company: company,
      config: config.copyWith(textDirection: m.TextDirection.ltr),
      style: const GeniusPdfReportHeaderStyle.classic(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
    );

    final height = header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(height + 10);
  }

  void _drawTable() {
    final columns = [
      const GeniusPdfGridColumn(
        id: 'code',
        title: 'Item Code',
        titleAr: 'رمز الصنف',
        width: 70,
      ),
      const GeniusPdfGridColumn(
        id: 'name',
        title: 'Item Name',
        titleAr: 'اسم الصنف',
      ),
      const GeniusPdfGridColumn(
        id: 'warehouse',
        title: 'Warehouse',
        titleAr: 'المستودع',
        width: 90,
      ),
      GeniusPdfGridColumn.numeric(
        id: 'qty',
        title: 'Qty on Hand',
        titleAr: 'الكمية المتوفرة',
        width: 70,
        alignment: GeniusPdfTextAlign.end,
      ),
      GeniusPdfGridColumn.currency(
        id: 'avgCost',
        title: 'Avg Cost',
        titleAr: 'متوسط التكلفة',
        width: 80,
        currencySymbol: '',
        alignment: GeniusPdfTextAlign.end,
      ),
      GeniusPdfGridColumn.currency(
        id: 'totalValue',
        title: 'Total Value',
        titleAr: 'إجمالي القيمة',
        width: 90,
        currencySymbol: '',
        alignment: GeniusPdfTextAlign.end,
      ),
    ];

    final rows = <GeniusPdfGridRow>[];

    for (final category in data.categories) {
      // Add category header
      if (showCategories) {
        rows.add(GeniusPdfGridRow.groupHeader(
          category.getName(isArabic: config.isRTL),
          style: const GeniusPdfCellStyle(
            textStyle: GeniusPdfTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
            backgroundColor: Color(0xFFE3F2FD),
            border: GeniusPdfBorderStyle.all(),
            padding: GeniusPdfCellPadding.all(5),
          ),
        ));
      }

      // Add items
      for (final item in category.items) {
        rows.add(GeniusPdfGridRow(cells: {
          'code': item.itemCode,
          'name': item.getName(isArabic: config.isRTL),
          'warehouse': item.getWarehouse(isArabic: config.isRTL),
          'qty': item.quantityOnHand.toInt(),
          'avgCost': item.averageCost,
          'totalValue': item.totalValue,
        }));
      }

      // Add category subtotal
      if (showCategorySubtotals && category.items.length > 1) {
        rows.add(GeniusPdfGridRow(
          cells: {
            'code': '',
            'name': '',
            'warehouse': '',
            'qty': '',
            'avgCost': '',
            'totalValue': category.totalValue,
          },
          style: const GeniusPdfCellStyle(
            textStyle: GeniusPdfTextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Color(0xFFF5F5F5),
            border: GeniusPdfBorderStyle.horizontal(),
            padding: GeniusPdfCellPadding.all(4),
          ),
        ));
      }
    }

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
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
      // This handles multi-page grids correctly by synchronizing the builder's
      // state with where the grid actually ended
      updateFromLayoutResult(result, spacing: 10);
    }
  }

  void _drawGrandTotal() {
    // Grand total bar
    final totalBar = GeniusPdfTotalBar(
      config: config,
      label: 'Total Inventory Value',
      labelAr: 'إجمالي قيمة المخزون',
      value: _formatCurrency(data.totalValue),
      backgroundColor: const Color.fromARGB(255, 147, 197, 255),
      textColor: const Color.fromARGB(255, 0, 0, 0),
      fontSize: 12,
    );

    totalBar.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 40),
    );

    addSpace(50);
  }

  String _formatDateLong(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateArabic(DateTime date) {
    return '${date.day} ${_arabicMonth(date.month)} ${date.year}';
  }

  String _arabicMonth(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${data.currency}';
  }

  void _drawSummary() {
    // Summary section with key metrics
    final summaryItems = <GeniusPdfSummaryItem>[
      GeniusPdfSummaryItem(
        label: 'Total Items',
        labelAr: 'إجمالي الأصناف',
        value: '${data.allItems.length}',
      ),
      GeniusPdfSummaryItem(
        label: 'Total Quantity',
        labelAr: 'إجمالي الكميات',
        value: _formatNumber(data.totalQuantity),
      ),
      GeniusPdfSummaryItem(
        label: 'Categories',
        labelAr: 'التصنيفات',
        value: '${data.categories.length}',
      ),
      GeniusPdfSummaryItem.total(
        label: 'Total Value',
        labelAr: 'إجمالي القيمة',
        value: _formatCurrency(data.totalValue),
      ),
    ];

    final summary = GeniusPdfSummarySection(
      config: config,
      items: summaryItems,
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.45,
    );

    final result = summary.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 120),
    );

    addSpace(result.height + 15);
  }

  void _drawFooterSection() {
    if (!showNotes && (!showQRCode || reportId == null)) {
      return;
    }

    addSpace(20);

    // If only one section is shown, draw it normally
    if (showNotes && (!showQRCode || reportId == null)) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && (showQRCode && reportId != null)) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    // Draw side-by-side if both are present
    // RTL: QR (Left/End) - Notes (Right/Start) -> distinct from standard LTR
    // But addTwoColumns lays out Left then Right.
    // LTR: Notes (2/3) | QR (1/3)
    // RTL: QR (1/3)    | Notes (2/3)

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
    // Legacy single column drawer wrapper
    _drawNotesContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    // Notes section with benefits
    final displayNotes = notes ?? (config.isRTL ? notesAr : notes);
    final defaultNotes = config.isRTL
        ? '''ملاحظات:
• هذا التقرير يعرض حالة المخزون الفعلية كما في تاريخ التقرير
• القيم المعروضة تستند إلى متوسط التكلفة المرجحة
• يرجى مراجعة الجرد الفعلي للتأكد من دقة البيانات
• للاستفسارات، يرجى التواصل مع إدارة المخازن'''
        : '''Notes:
• This report reflects the actual inventory status as of the report date
• Values are based on weighted average cost method
• Please verify with physical count for data accuracy
• For inquiries, contact the Warehouse Department''';

    final notesText = displayNotes ?? defaultNotes;

    // We can't use addLine here because it modifies _currentY of the builder
    // We must use PdfTextElement directly with the provided bounds

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
    if (reportId == null) return 0;

    final qrUrl = 'https://localhost:443/report/$reportId';
    final qrId = 'ID: $reportId';
    final captionFont = config.baseFont;

    // Draw Caption
    final captionLayout = PdfTextElement(
      text: qrId,
      font: captionFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection
      ),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0));

    final captionHeight = captionLayout?.bounds.height ?? 0;

    // Draw QR Code
    const qrSize = 80.0; // Reduced size
    // Center it in the available bounds
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
      // We draw caption manually to control layout better in the column
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
  }

  void _drawSignatures() {
    // Ensure enough space for signatures
    if (currentY > pageHeight - 100) {
      newPage();
    }

    addSpace(20);

    // Draw separator line
    addHorizontalLine(spacing: 10);

    // Signature areas side by side
    final signatureY = currentY;

    // Prepared by signature
    final preparedBy = GeniusPdfSignatureArea(
      config: config,
      title: 'Prepared By',
      titleAr: 'أعده',
      lineWidth: 120,
      showDate: false,
    );

    preparedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? pageWidth - 150 : 0,
        signatureY,
        150,
        60,
      ),
    );

    // Approved by signature
    final approvedBy = GeniusPdfSignatureArea(
      config: config,
      title: 'Approved By',
      titleAr: 'اعتمده',
      lineWidth: 120,
      showDate: false,
    );

    approvedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? 0 : pageWidth - 150,
        signatureY,
        150,
        60,
      ),
    );

    addSpace(70);
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
