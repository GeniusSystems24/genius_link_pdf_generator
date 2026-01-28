import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridRow, PdfTextStyle, PdfBorderStyle, PdfGridColumn, PdfGridStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';
import '../extensions/color_extensions.dart';

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
    this.boldFont,
    this.showCategories = true,
    this.showCategorySubtotals = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final InventoryReportData data;
  final PdfFont? boldFont;
  final bool showCategories;
  final bool showCategorySubtotals;

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    newPage();

    // Header
    _drawHeader();

    // Inventory table
    _drawTable();

    // Grand total
    _drawGrandTotal();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Inventory Valuation Report',
      titleAr: 'تقرير تقييم المخزون',
      subtitle: 'As of: ${_formatDate(data.asOfDate)}',
      subtitleAr: 'كما في: ${_formatDate(data.asOfDate)}',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.standard,
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
        flexFactor: 2,
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
      ),
      GeniusPdfGridColumn.currency(
        id: 'avgCost',
        title: 'Avg Cost',
        titleAr: 'متوسط التكلفة',
        width: 80,
        currencySymbol: '',
      ),
      GeniusPdfGridColumn.currency(
        id: 'totalValue',
        title: 'Total Value',
        titleAr: 'إجمالي القيمة',
        width: 90,
        currencySymbol: '',
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
      columns: columns,
      rows: rows,
      style: const GeniusPdfGridStyle.classic(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 10);
    }
  }

  void _drawGrandTotal() {
    // Grand total bar
    final totalText = config.isRTL
        ? 'إجمالي قيمة المخزون: ${_formatCurrency(data.totalValue)}'
        : 'Total Inventory Value: ${_formatCurrency(data.totalValue)}';

    final totalBar = GeniusPdfTotalBar(
      label: config.isRTL ? 'إجمالي قيمة المخزون' : 'Total Inventory Value',
      labelAr: 'إجمالي قيمة المخزون',
      value: _formatCurrency(data.totalValue),
      backgroundColor: const Color(0xFF1565C0),
      textColor: const Color(0xFFFFFFFF),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      fontSize: 12,
    );

    totalBar.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 40),
    );

    addSpace(50);

    // Page indicator
    final pageText = config.isRTL
        ? 'صفحة ${document.pages.count} من ${document.pages.count}'
        : 'Page ${document.pages.count} of ${document.pages.count}';

    addTextAt(
      pageText,
      x: pageWidth - 100,
      y: pageHeight - 20,
      font: config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
              style: PdfFontStyle.regular),
      brush: PdfSolidBrush(const Color(0xFF757575).toPdfColor()),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${data.currency}';
  }
}
