import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for the Custom Color Styles DataGrid example.
///
/// The document is generated only after the user presses **Run example**. The
/// code panel below contains the actual builder source used by this example.
class DataGridCustomStylesExampleScreen extends StatelessWidget {
  const DataGridCustomStylesExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused custom-color grid-style showcase example.
class DataGridCustomStylesDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridCustomStylesDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    // ================================================================
    newPage();

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


    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٧: أنماط إضافية مع ألوان مخصصة'
          : 'Example 7: More Styles with Custom Colors',
      spacing: 10,
    );

    // --- Style 5: Elegant (Brown) ---
    addLine(
      config.isRTL
          ? 'elegant — اللون الرئيسي: بني (Brown)'
          : 'elegant — primaryColor: Brown',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.elegant(primaryColor: const Color(0xFF5D4037)),
      ),
      spacing: 8,
    );

    // --- Style 6: Pastel (Purple) ---
    addLine(
      config.isRTL
          ? 'pastel — اللون الرئيسي: بنفسجي (Purple)'
          : 'pastel — primaryColor: Purple',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.pastel(primaryColor: const Color(0xFF7E57C2)),
      ),
      spacing: 8,
    );

    // --- Style 7: Bordered (Green) ---
    addLine(
      config.isRTL
          ? 'bordered — اللون الرئيسي: أخضر (Green)'
          : 'bordered — primaryColor: Green',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.bordered(primaryColor: const Color(0xFF2E7D32)),
      ),
      spacing: 8,
    );

    // --- Style 8: Minimal (Orange) ---
    addLine(
      config.isRTL
          ? 'minimal — اللون الرئيسي: برتقالي (Orange)'
          : 'minimal — primaryColor: Orange',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.minimal(primaryColor: const Color(0xFFE65100)),
      ),
      spacing: 8,
    );

    // --- Style 9: Saudi (Default Green) ---
    addLine(
      config.isRTL
          ? 'saudi — اللون الافتراضي: أخضر سعودي'
          : 'saudi — default primaryColor: Saudi Green',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(GeniusPdfGridStyle.saudi()),
      spacing: 8,
    );

    // --- Style 10: Invoice (Custom Red) ---
    addLine(
      config.isRTL
          ? 'invoice — اللون الرئيسي: أحمر (Red)'
          : 'invoice — primaryColor: Red',
      topMargin: 6,
    );
    addSpace(4);
    addGrid(
      buildStyleGrid(
        GeniusPdfGridStyle.invoice(primaryColor: const Color(0xFFC62828)),
      ),
      spacing: 8,
    );

    addSpace(15);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL
            ? 'الأنماط المتاحة v2.12.2'
            : 'Available Styles v2.12.2',
        titleAr: 'الأنماط المتاحة v2.12.2',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'الأنماط' : 'Styles',
            labelAr: 'الأنماط',
            value: 'modern, classic, corporate, minimal, saudi, invoice, striped, dark, elegant, pastel, bordered',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'التخصيص' : 'Customization',
            labelAr: 'التخصيص',
            value: config.isRTL
                ? 'جميع الأنماط تدعم primaryColor لتخصيص اللون الرئيسي'
                : 'All styles accept primaryColor for color customization',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'data_grid_custom_styles',
      category: 'Components / Data Grid',
      title: 'Custom Color Styles',
      apiName: 'GeniusPdfDataGrid',
      description: 'Show elegant, pastel, bordered, minimal, Saudi, and invoice grid styles with their default or customized primary colors.',
      icon: Icons.table_chart_outlined,
      usageCode: dartUsageCode,
    );
  }
}
