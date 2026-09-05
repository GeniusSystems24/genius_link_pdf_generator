import 'dart:ui';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused core grid-style showcase example.
class DataGridStyleShowcaseDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridStyleShowcaseDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٦: عرض أنماط الجدول v2.12.2'
          : 'Example 6: Grid Styles Showcase v2.12.2',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'جميع الأنماط تدعم اللون الرئيسي القابل للتخصيص عبر primaryColor.'
          : 'All styles support customizable primary color via the primaryColor parameter.',
      topMargin: 5,
    );

    // Shared sample data for style demos
    final styleColumns = [
      GeniusPdfGridColumn(
        id: 'name',
        title: 'Product',
        titleAr: 'المنتج',
        flexFactor: 2,
      ),
      GeniusPdfGridColumn.numeric(
        id: 'qty',
        title: 'Qty',
        titleAr: 'الكمية',
        width: 50,
        alignment: GeniusPdfTextAlign.center,
      ),
      GeniusPdfGridColumn.currency(
        id: 'price',
        title: 'Price',
        titleAr: 'السعر',
        width: 80,
        isNumeric: true,
      ),
      GeniusPdfGridColumn.currency(
        id: 'total',
        title: 'Total',
        titleAr: 'الإجمالي',
        width: 90,
        isNumeric: true,
      ),
    ];

    final styleRows = [
      GeniusPdfGridRow(cells: {
        'name': config.isRTL ? 'لابتوب' : 'Laptop',
        'qty': 3,
        'price': 4500,
        'total': 13500,
      }),
      GeniusPdfGridRow(cells: {
        'name': config.isRTL ? 'شاشة' : 'Monitor',
        'qty': 5,
        'price': 1200,
        'total': 6000,
      }),
      GeniusPdfGridRow(cells: {
        'name': config.isRTL ? 'طابعة' : 'Printer',
        'qty': 2,
        'price': 2800,
        'total': 5600,
      }),
    ];

    final styleFooter = [
      GeniusPdfGridRow.total({
        'name': config.isRTL ? 'الإجمالي' : 'Total',
        'total': 25100,
      }),
    ];

    // Helper to build a styled grid
    GeniusPdfDataGrid buildStyleGrid(GeniusPdfGridStyle gridStyle) {
      return GeniusPdfDataGrid(
        config: config,
        columns: styleColumns,
        rows: styleRows,
        footerRows: styleFooter,
        style: gridStyle,
      );
    }

    addSpace(10);

    // --- Style 1: Modern (Teal) ---
    addLine(
      config.isRTL
          ? 'modern — اللون الرئيسي: أزرق مخضر (Teal)'
          : 'modern — primaryColor: Teal',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.modern(primaryColor: const Color(0xFF00897B)),
      ),
      spacing: 8,
    );

    // --- Style 2: Classic (Indigo) ---
    addLine(
      config.isRTL
          ? 'classic — اللون الرئيسي: نيلي (Indigo)'
          : 'classic — primaryColor: Indigo',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.classic(primaryColor: const Color(0xFF3F51B5)),
      ),
      spacing: 8,
    );

    // --- Style 3: Striped (Blue Grey) ---
    addLine(
      config.isRTL
          ? 'striped — اللون الرئيسي: رمادي مُزرق'
          : 'striped — primaryColor: Blue Grey',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.striped(primaryColor: const Color(0xFF546E7A)),
      ),
      spacing: 8,
    );

    // --- Style 4: Dark (Dark Blue) ---
    addLine(
      config.isRTL
          ? 'dark — اللون الرئيسي: أزرق داكن'
          : 'dark — primaryColor: Dark Blue',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.dark(primaryColor: const Color(0xFF1A237E)),
      ),
      spacing: 8,
    );

    // ================================================================
  }
}
