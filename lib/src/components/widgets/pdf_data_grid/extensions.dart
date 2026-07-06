part of '../pdf_data_grid.dart';

/// Extension methods for easily adding grids to document builders.
extension PdfDataGridExtensions on GeniusPdfDataGrid {
  /// Creates a simple two-column grid from a map.
  static GeniusPdfDataGrid fromMap({
    required Map<String, dynamic> data,
    String labelHeader = 'Label',
    String labelHeaderAr = 'البيان',
    String valueHeader = 'Value',
    String valueHeaderAr = 'القيمة',
    required GeniusPdfConfig config,
    GeniusPdfGridStyle? style,
  }) {
    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: 'label',
          title: labelHeader,
          titleAr: labelHeaderAr,
          flexFactor: 2,
        ),
        GeniusPdfGridColumn(
          id: 'value',
          title: valueHeader,
          titleAr: valueHeaderAr,
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.end,
        ),
      ],
      rows: data.entries
          .map((e) =>
              GeniusPdfGridRow(cells: {'label': e.key, 'value': e.value}))
          .toList(),
      style: style ?? const GeniusPdfGridStyle.classic(),
    );
  }

  /// Creates a ledger-style grid with debit/credit columns.
  static GeniusPdfDataGrid ledger({
    required List<Map<String, dynamic>> entries,
    required String dateColumn,
    required String descriptionColumn,
    required String debitColumn,
    required String creditColumn,
    required String balanceColumn,
    String dateHeader = 'Date',
    String dateHeaderAr = 'التاريخ',
    String descriptionHeader = 'Description',
    String descriptionHeaderAr = 'البيان',
    String debitHeader = 'Debit',
    String debitHeaderAr = 'مدين',
    String creditHeader = 'Credit',
    String creditHeaderAr = 'دائن',
    String balanceHeader = 'Balance',
    String balanceHeaderAr = 'الرصيد',
    required GeniusPdfConfig config,
    GeniusPdfGridStyle? style,
  }) {
    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: dateColumn,
          title: dateHeader,
          titleAr: dateHeaderAr,
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn(
          id: descriptionColumn,
          title: descriptionHeader,
          titleAr: descriptionHeaderAr,
          flexFactor: 2,
        ),
        GeniusPdfGridColumn.currency(
          id: debitColumn,
          title: debitHeader,
          titleAr: debitHeaderAr,
          width: 80,
        ),
        GeniusPdfGridColumn.currency(
          id: creditColumn,
          title: creditHeader,
          titleAr: creditHeaderAr,
          width: 80,
        ),
        GeniusPdfGridColumn.currency(
          id: balanceColumn,
          title: balanceHeader,
          titleAr: balanceHeaderAr,
          width: 90,
        ),
      ],
      rows: entries
          .map((e) => GeniusPdfGridRow(cells: {
                dateColumn: e[dateColumn],
                descriptionColumn: e[descriptionColumn],
                debitColumn: e[debitColumn],
                creditColumn: e[creditColumn],
                balanceColumn: e[balanceColumn],
              }))
          .toList(),
      style: style ?? const GeniusPdfGridStyle.classic(),
    );
  }

  /// Creates an invoice-style grid with auto-calculated totals (v2.12.0).
  static GeniusPdfDataGrid invoice({
    required List<Map<String, dynamic>> items,
    required GeniusPdfConfig config,
    String codeColumn = 'code',
    String descColumn = 'desc',
    String qtyColumn = 'qty',
    String priceColumn = 'price',
    String totalColumn = 'total',
    double taxRate = 0.15,
    String currencySymbol = 'SAR',
    GeniusPdfGridStyle? style,
  }) {
    final dataRows = items
        .map((item) => GeniusPdfGridRow(cells: Map<String, dynamic>.from(item)))
        .toList();

    // Calculate totals
    double subtotal = 0;
    for (final item in items) {
      final total = item[totalColumn];
      if (total is num) subtotal += total;
    }
    final tax = subtotal * taxRate;
    final grandTotal = subtotal + tax;

    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: codeColumn,
          title: 'Code',
          titleAr: 'الكود',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn(
          id: descColumn,
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn.numeric(
          id: qtyColumn,
          title: 'Qty',
          titleAr: 'الكمية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: priceColumn,
          title: 'Price',
          titleAr: 'السعر',
          currencySymbol: currencySymbol,
          width: 90,
        ),
        GeniusPdfGridColumn.currency(
          id: totalColumn,
          title: 'Total',
          titleAr: 'الإجمالي',
          currencySymbol: currencySymbol,
          width: 100,
        ),
      ],
      rows: dataRows,
      footerRows: [
        GeniusPdfGridRow.subtotal({
          descColumn: config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
          totalColumn: subtotal,
        }),
        GeniusPdfGridRow(
          cells: {
            descColumn: config.isRTL
                ? 'الضريبة (${(taxRate * 100).toStringAsFixed(0)}%)'
                : 'Tax (${(taxRate * 100).toStringAsFixed(0)}%)',
            totalColumn: tax,
          },
          isSubtotal: true,
        ),
        GeniusPdfGridRow.total({
          descColumn: config.isRTL ? 'الإجمالي الكلي' : 'Grand Total',
          totalColumn: grandTotal,
        }),
      ],
      style: style ?? GeniusPdfGridStyle.invoice(),
    );
  }
}
