import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Data Grid demo PDF document with extended details (v2.12.0).
///
/// Demonstrates:
/// 1. Basic invoice grid with percentage-based column widths
/// 2. Multiple auto-calculated total rows (subtotal, average, count)
/// 3. Explicit footer rows (tax, discount, grand total)
/// 4. Grouped data with nested subgroups
/// 5. Auto-grouping utility
class DataGridDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Basic Invoice Grid with Multiple Total Rows
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات v2.12.0 — GeniusPdfDataGrid'
          : 'Data Grid v2.12.0 — GeniusPdfDataGrid',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ١: فاتورة مع صفوف إجمالية متعددة (مجموع فرعي، ضريبة، خصم، إجمالي كلي)'
          : 'Example 1: Invoice with multiple total rows (subtotal, tax, discount, grand total)',
      topMargin: 5,
    );

    addSpace(12);

    // Invoice grid with multiple footer rows
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'code',
            title: 'Code',
            titleAr: 'الكود',
            width: 55,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'desc',
            title: 'Description',
            titleAr: 'الوصف',
            flexFactor: 3,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
            width: 45,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Unit Price',
            titleAr: 'سعر الوحدة',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
            widthPercent: 0.18,
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
            widthPercent: 0.20,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'code': 'PRD-001',
            'desc': config.isRTL ? 'حاسوب محمول - Dell Latitude' : 'Laptop - Dell Latitude',
            'qty': 3,
            'price': 4500.00,
            'total': 13500.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'PRD-002',
            'desc': config.isRTL ? 'شاشة عرض 27 بوصة' : 'Monitor 27" 4K Display',
            'qty': 5,
            'price': 1200.00,
            'total': 6000.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'PRD-003',
            'desc': config.isRTL ? 'طابعة ليزرية' : 'Laser Printer',
            'qty': 2,
            'price': 2800.00,
            'total': 5600.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'SRV-001',
            'desc': config.isRTL ? 'خدمة التركيب والتشغيل' : 'Installation & Setup Service',
            'qty': 1,
            'price': 1500.00,
            'total': 1500.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'SRV-002',
            'desc': config.isRTL ? 'ضمان ممتد - سنتان' : 'Extended Warranty - 2 Years',
            'qty': 10,
            'price': 350.00,
            'total': 3500.00,
          }),
        ],
        // Multiple explicit footer rows with different styles
        footerRows: [
          GeniusPdfGridRow.subtotal({
            'desc': config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
            'total': 30100.00,
          }),
          GeniusPdfGridRow(
            cells: {
              'desc': config.isRTL ? 'خصم (5%)' : 'Discount (5%)',
              'total': -1505.00,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow(
            cells: {
              'desc': config.isRTL ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
              'total': 4289.25,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow.total({
            'desc': config.isRTL ? 'الإجمالي المستحق' : 'Total Due',
            'total': 32884.25,
          }),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 12,
    );

    // ================================================================
    // PAGE 1: Auto-Calculated Totals
    // ================================================================
    addSpace(25);

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: إجماليات محسوبة تلقائياً'
          : 'Example 2: Auto-Calculated Totals',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'يقوم الجدول بحساب المجموع والمتوسط والعدد تلقائياً من بيانات الصفوف.'
          : 'The grid automatically calculates sum, average, and count from row data.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'employee',
            title: 'Employee',
            titleAr: 'الموظف',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn(
            id: 'dept',
            title: 'Department',
            titleAr: 'القسم',
            flexFactor: 1,
          ),
          GeniusPdfGridColumn.currency(
            id: 'salary',
            title: 'Salary',
            titleAr: 'الراتب',
            isNumeric: true,
            width: 90,
          ),
          GeniusPdfGridColumn.currency(
            id: 'bonus',
            title: 'Bonus',
            titleAr: 'المكافأة',
            isNumeric: true,
            width: 80,
          ),
          GeniusPdfGridColumn.currency(
            id: 'net',
            title: 'Net Pay',
            titleAr: 'صافي الدفع',
            isNumeric: true,
            width: 100,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'أحمد محمد' : 'Ahmed M.', 'dept': config.isRTL ? 'تقنية' : 'IT', 'salary': 12000, 'bonus': 2000, 'net': 14000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'سارة علي' : 'Sara A.', 'dept': config.isRTL ? 'مالية' : 'Finance', 'salary': 10000, 'bonus': 1500, 'net': 11500}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'خالد يوسف' : 'Khalid Y.', 'dept': config.isRTL ? 'تقنية' : 'IT', 'salary': 15000, 'bonus': 3000, 'net': 18000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'فاطمة حسن' : 'Fatima H.', 'dept': config.isRTL ? 'موارد' : 'HR', 'salary': 9000, 'bonus': 1000, 'net': 10000}),
          GeniusPdfGridRow(cells: {'employee': config.isRTL ? 'عمر سالم' : 'Omar S.', 'dept': config.isRTL ? 'مبيعات' : 'Sales', 'salary': 11000, 'bonus': 4000, 'net': 15000}),
        ],
        // Auto-calculated total rows
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total',
            labelAr: 'الإجمالي',
            labelColumnId: 'employee',
            columnIds: ['salary', 'bonus', 'net'],
          ),
          GeniusPdfAutoTotal.average(
            label: 'Average',
            labelAr: 'المتوسط',
            labelColumnId: 'employee',
            columnIds: ['salary', 'bonus', 'net'],
          ),
          GeniusPdfAutoTotal.count(
            label: 'Count',
            labelAr: 'العدد',
            labelColumnId: 'employee',
            columnIds: ['salary'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    // ================================================================
    // PAGE 2: Grouped Data with Subgroups
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٣: مجموعات مع مجموعات فرعية'
          : 'Example 3: Groups with Nested Subgroups',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'جدول مُجمَّع حسب الفئة مع مجموعات فرعية وإجماليات لكل مجموعة.'
          : 'Grouped table by category with nested subgroups and per-group totals.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'item',
            title: 'Item',
            titleAr: 'الصنف',
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
            title: 'Unit Price',
            titleAr: 'سعر الوحدة',
            width: 90,
            isNumeric: true,
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            width: 100,
            isNumeric: true,
          ),
        ],
        rows: [],
        groups: [
          // Group 1: Electronics with subgroups
          GeniusPdfGridGroup(
            title: 'Electronics',
            titleAr: 'إلكترونيات',
            level: 0,
            subgroups: [
              GeniusPdfGridGroup.withSummary(
                title: 'Computers',
                titleAr: 'حواسيب',
                level: 1,
                rows: [
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لابتوب HP' : 'HP Laptop', 'qty': 5, 'price': 3200, 'total': 16000}),
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لابتوب Dell' : 'Dell Laptop', 'qty': 3, 'price': 4500, 'total': 13500}),
                ],
                sumColumns: ['total'],
                labelColumnId: 'item',
                summaryLabel: 'Computers Subtotal',
                summaryLabelAr: 'مجموع الحواسيب',
              ),
              GeniusPdfGridGroup.withSummary(
                title: 'Accessories',
                titleAr: 'ملحقات',
                level: 1,
                rows: [
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'ماوس لاسلكي' : 'Wireless Mouse', 'qty': 20, 'price': 85, 'total': 1700}),
                  GeniusPdfGridRow(cells: {'item': config.isRTL ? 'لوحة مفاتيح' : 'Keyboard', 'qty': 15, 'price': 120, 'total': 1800}),
                ],
                sumColumns: ['total'],
                labelColumnId: 'item',
                summaryLabel: 'Accessories Subtotal',
                summaryLabelAr: 'مجموع الملحقات',
              ),
            ],
            summary: GeniusPdfGridRow.total({
              'item': config.isRTL ? 'إجمالي الإلكترونيات' : 'Electronics Total',
              'total': 33000,
            }),
          ),

          // Group 2: Furniture
          GeniusPdfGridGroup.withSummary(
            title: 'Office Furniture',
            titleAr: 'أثاث مكتبي',
            rows: [
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'مكتب خشبي' : 'Wooden Desk', 'qty': 8, 'price': 950, 'total': 7600}),
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'كرسي مكتبي' : 'Office Chair', 'qty': 12, 'price': 650, 'total': 7800}),
              GeniusPdfGridRow(cells: {'item': config.isRTL ? 'خزانة ملفات' : 'Filing Cabinet', 'qty': 5, 'price': 480, 'total': 2400}),
            ],
            sumColumns: ['total'],
            labelColumnId: 'item',
            summaryLabel: 'Furniture Subtotal',
            summaryLabelAr: 'مجموع الأثاث',
          ),
        ],
        // Grand total after all groups
        footerRows: [
          GeniusPdfGridRow.total({
            'item': config.isRTL ? 'الإجمالي الكلي' : 'Grand Total',
            'total': 50800,
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    // ================================================================
    // PAGE 2: Auto-Grouping Utility
    // ================================================================
    addSpace(20);

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٤: التجميع التلقائي بالأداة المساعدة'
          : 'Example 4: Auto-Grouping via Utility',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'يقوم GeniusDataGridUtils.autoGroup بتجميع الصفوف تلقائياً حسب عمود محدد.'
          : 'GeniusDataGridUtils.autoGroup groups rows by a specified column automatically.',
      topMargin: 5,
    );

    addSpace(10);

    // Raw data rows (mixed departments)
    final allRows = [
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'أحمد' : 'Ahmed', 'dept': config.isRTL ? 'تقنية' : 'IT', 'hours': 160, 'rate': 50, 'amount': 8000}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'سارة' : 'Sara', 'dept': config.isRTL ? 'مالية' : 'Finance', 'hours': 170, 'rate': 55, 'amount': 9350}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'خالد' : 'Khalid', 'dept': config.isRTL ? 'تقنية' : 'IT', 'hours': 155, 'rate': 60, 'amount': 9300}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'فاطمة' : 'Fatima', 'dept': config.isRTL ? 'مالية' : 'Finance', 'hours': 165, 'rate': 45, 'amount': 7425}),
      GeniusPdfGridRow(cells: {'name': config.isRTL ? 'عمر' : 'Omar', 'dept': config.isRTL ? 'مبيعات' : 'Sales', 'hours': 180, 'rate': 40, 'amount': 7200}),
    ];

    // Auto-group by department with summaries
    final autoGroups = GeniusDataGridUtils.autoGroup(
      rows: allRows,
      groupByColumn: 'dept',
      sumColumns: ['amount'],
      summaryLabelColumnId: 'name',
      summaryLabel: 'Dept Total',
      summaryLabelAr: 'مجموع القسم',
    );

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم', flexFactor: 2),
          GeniusPdfGridColumn(id: 'dept', title: 'Department', titleAr: 'القسم', width: 80),
          GeniusPdfGridColumn.numeric(id: 'hours', title: 'Hours', titleAr: 'الساعات', width: 60, alignment: GeniusPdfTextAlign.center),
          GeniusPdfGridColumn.currency(id: 'rate', title: 'Rate', titleAr: 'المعدل', width: 70, isNumeric: true),
          GeniusPdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ', width: 90, isNumeric: true),
        ],
        rows: [],
        groups: autoGroups,
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Grand Total',
            labelAr: 'الإجمالي الكلي',
            labelColumnId: 'name',
            columnIds: ['amount'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    // ================================================================
    // PAGE 3: Percentage Column Widths
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٥: أعمدة بنسب مئوية وقيود عرض'
          : 'Example 5: Percentage Columns & Width Constraints',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'widthPercent يحدد عرض العمود كنسبة مئوية من العرض المتاح مع دعم الحد الأدنى والأقصى.'
          : 'widthPercent defines column width as a percentage of available width with min/max constraints.',
      topMargin: 5,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'id',
            title: '#',
            titleAr: '#',
            widthPercent: 0.08,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'product',
            title: 'Product Name',
            titleAr: 'اسم المنتج',
            widthPercent: 0.32,
          ),
          GeniusPdfGridColumn(
            id: 'category',
            title: 'Category',
            titleAr: 'الفئة',
            widthPercent: 0.15,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'stock',
            title: 'Stock',
            titleAr: 'المخزون',
            widthPercent: 0.10,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'cost',
            title: 'Cost',
            titleAr: 'التكلفة',
            widthPercent: 0.15,
            isNumeric: true,
          ),
          GeniusPdfGridColumn.currency(
            id: 'sell',
            title: 'Sell Price',
            titleAr: 'سعر البيع',
            widthPercent: 0.20,
            isNumeric: true,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {'id': 1, 'product': config.isRTL ? 'هاتف ذكي سامسونج' : 'Samsung Phone', 'category': config.isRTL ? 'هواتف' : 'Phones', 'stock': 45, 'cost': 1800, 'sell': 2500}),
          GeniusPdfGridRow(cells: {'id': 2, 'product': config.isRTL ? 'آيفون ١٥' : 'iPhone 15', 'category': config.isRTL ? 'هواتف' : 'Phones', 'stock': 30, 'cost': 3200, 'sell': 4200}),
          GeniusPdfGridRow(cells: {'id': 3, 'product': config.isRTL ? 'سماعات بلوتوث' : 'Bluetooth Headphones', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 120, 'cost': 150, 'sell': 250}),
          GeniusPdfGridRow(cells: {'id': 4, 'product': config.isRTL ? 'حقيبة لابتوب' : 'Laptop Bag', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 80, 'cost': 95, 'sell': 180}),
          GeniusPdfGridRow(cells: {'id': 5, 'product': config.isRTL ? 'شاحن سريع' : 'Fast Charger', 'category': config.isRTL ? 'إكسسوارات' : 'Accessories', 'stock': 200, 'cost': 45, 'sell': 85}),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Stock Value',
            labelAr: 'إجمالي قيمة المخزون',
            labelColumnId: 'product',
            columnIds: ['stock', 'cost', 'sell'],
          ),
          GeniusPdfAutoTotal.min(
            label: 'Min',
            labelAr: 'الأدنى',
            labelColumnId: 'product',
            columnIds: ['cost', 'sell'],
          ),
          GeniusPdfAutoTotal.max(
            label: 'Max',
            labelAr: 'الأقصى',
            labelColumnId: 'product',
            columnIds: ['cost', 'sell'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التحسينات v2.12.0' : 'v2.12.0 Enhancements Summary',
        titleAr: 'ملخص التحسينات v2.12.0',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'أعمدة نسبية' : 'Percentage Columns',
            labelAr: 'أعمدة نسبية',
            value: config.isRTL
                ? 'widthPercent لتحديد عرض العمود كنسبة من العرض الكلي'
                : 'widthPercent to set column width as a ratio of total width',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجماليات متعددة' : 'Multi Totals',
            labelAr: 'إجماليات متعددة',
            value: config.isRTL
                ? 'footerRows + autoTotals (مجموع، متوسط، عدد، أدنى، أقصى)'
                : 'footerRows + autoTotals (sum, avg, count, min, max)',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'مجموعات فرعية' : 'Nested Groups',
            labelAr: 'مجموعات فرعية',
            value: config.isRTL
                ? 'دعم المجموعات المتداخلة مع إجماليات لكل مستوى'
                : 'Nested subgroups with per-level totals',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'حساب دقيق' : 'Accurate Widths',
            labelAr: 'حساب دقيق',
            value: config.isRTL
                ? 'خوارزمية محسّنة متعددة المراحل مع إعادة توزيع القيود'
                : 'Multi-pass algorithm with constraint redistribution',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );
  }
}
