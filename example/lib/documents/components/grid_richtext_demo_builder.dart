import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Grid + Rich Text demo PDF document.
///
/// Demonstrates combining data grids with rich text:
/// 1. Analysis report with styled text and grids
/// 2. Summary sections with formatted content
class GridRichtextDemoBuilder extends GeniusPdfDocumentBuilder {
  GridRichtextDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Financial Analysis with Rich Text
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع النصوص المنسقة — Grid + Rich Text'
          : 'Data Grid with Rich Text — Grid + Rich Text',
      spacing: 10,
    );

    addLine(
      config.isRTL ? 'تقرير التحليل المالي' : 'Financial Analysis Report',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    // Introduction using rich text builder
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(config.isRTL
              ? 'يقدم هذا التقرير تحليلاً شاملاً للأداء المالي خلال الربع الأول من عام 2026. '
              : 'This report provides a comprehensive analysis of financial performance for Q1 2026. ')
          .bold(config.isRTL ? 'النتائج الرئيسية' : 'Key findings')
          .text(config.isRTL
              ? ' تظهر نمواً إيجابياً بنسبة '
              : ' show positive growth of ')
          .positive('+15.6%')
          .text(config.isRTL
              ? ' مقارنة بالفترة السابقة.'
              : ' compared to the previous period.')
          .build(),
      spacing: 10,
    );

    addSpace(15);

    // Revenue breakdown grid
    addLine(
      config.isRTL ? '١. توزيع الإيرادات' : '1. Revenue Breakdown',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'source',
            title: 'Revenue Source',
            titleAr: 'مصدر الإيرادات',
            width: 150,
          ),
          GeniusPdfGridColumn.currency(
            id: 'q1_2025',
            title: 'Q1 2025',
            titleAr: 'ر١ ٢٠٢٥',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'q1_2026',
            title: 'Q1 2026',
            titleAr: 'ر١ ٢٠٢٦',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn(
            id: 'change',
            title: 'Change',
            titleAr: 'التغيير',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'مبيعات المنتجات' : 'Product Sales',
            'q1_2025': 450000.0,
            'q1_2026': 520000.0,
            'change': '+15.6%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'خدمات الصيانة' : 'Service Revenue',
            'q1_2025': 180000.0,
            'q1_2026': 195000.0,
            'change': '+8.3%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'تراخيص البرامج' : 'Software Licensing',
            'q1_2025': 85000.0,
            'q1_2026': 112000.0,
            'change': '+31.8%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'خدمات استشارية' : 'Consulting',
            'q1_2025': 65000.0,
            'q1_2026': 58000.0,
            'change': '-10.8%',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Revenue',
            labelAr: 'إجمالي الإيرادات',
            labelColumnId: 'source',
            columnIds: ['q1_2025', 'q1_2026'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(15);

    // Analysis commentary
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold(config.isRTL ? 'تحليل الإيرادات: ' : 'Revenue Analysis: ')
          .text(config.isRTL
              ? 'شهدت الشركة نمواً ملحوظاً في قطاع '
              : 'The company experienced notable growth in ')
          .bold(config.isRTL ? 'تراخيص البرامج' : 'Software Licensing')
          .text(' (+31.8%)')
          .text(config.isRTL
              ? '، بينما شهد قطاع الاستشارات انخفاضاً طفيفاً بنسبة '
              : ', while Consulting saw a slight decline of ')
          .negative('-10.8%')
          .text(config.isRTL
              ? ' نتيجة انتهاء بعض المشاريع الكبرى.'
              : ' due to completion of major projects.')
          .build(),
      spacing: 10,
    );

    // ================================================================
    // PAGE 2: Expense Analysis with Recommendations
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: تحليل المصروفات والتوصيات'
          : 'Example 2: Expense Analysis & Recommendations',
      spacing: 10,
    );

    addSpace(15);

    // Expense grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'category',
            title: 'Expense Category',
            titleAr: 'فئة المصروفات',
            width: 150,
          ),
          GeniusPdfGridColumn.currency(
            id: 'budget',
            title: 'Budget',
            titleAr: 'الميزانية',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'actual',
            title: 'Actual',
            titleAr: 'الفعلي',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn(
            id: 'variance',
            title: 'Variance',
            titleAr: 'الفرق',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'الرواتب والأجور' : 'Salaries & Wages',
            'budget': 320000.0,
            'actual': 318500.0,
            'variance': '-0.5%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'التسويق والإعلان' : 'Marketing',
            'budget': 85000.0,
            'actual': 102000.0,
            'variance': '+20.0%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'البنية التحتية' : 'Infrastructure',
            'budget': 45000.0,
            'actual': 43200.0,
            'variance': '-4.0%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'البحث والتطوير' : 'R&D',
            'budget': 75000.0,
            'actual': 82000.0,
            'variance': '+9.3%',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Expenses',
            labelAr: 'إجمالي المصروفات',
            labelColumnId: 'category',
            columnIds: ['budget', 'actual'],
          ),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Recommendations section with rich text
    addLine(
      config.isRTL ? 'التوصيات الرئيسية' : 'Key Recommendations',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    // Recommendation 1
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('1. ')
          .bold(config.isRTL
              ? 'مراجعة ميزانية التسويق: '
              : 'Review Marketing Budget: ')
          .text(config.isRTL
              ? 'تجاوزت المصروفات الميزانية بنسبة '
              : 'Expenses exceeded budget by ')
          .negative('+20%')
          .text(config.isRTL
              ? '. يُوصى بتحليل العائد على الاستثمار للحملات الحالية.'
              : '. Recommend ROI analysis of current campaigns.')
          .build(),
      spacing: 8,
    );

    // Recommendation 2
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('2. ')
          .bold(config.isRTL
              ? 'استثمار إضافي في البحث والتطوير: '
              : 'Additional R&D Investment: ')
          .text(config.isRTL
              ? 'نظراً للنمو القوي في تراخيص البرامج '
              : 'Given strong Software Licensing growth ')
          .positive('(+31.8%)')
          .text(config.isRTL
              ? '، يُوصى بزيادة الاستثمار في هذا القطاع.'
              : ', recommend increasing investment in this sector.')
          .build(),
      spacing: 8,
    );

    // Recommendation 3
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('3. ')
          .bold(config.isRTL
              ? 'تنويع مصادر الإيرادات: '
              : 'Diversify Revenue Sources: ')
          .text(config.isRTL
              ? 'تقليل الاعتماد على قطاع واحد من خلال تطوير خدمات استشارية جديدة.'
              : 'Reduce dependence on single sector by developing new consulting services.')
          .build(),
      spacing: 8,
    );

    addSpace(15);

    // Summary info box
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التقرير' : 'Report Summary',
        titleAr: 'ملخص التقرير',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي الإيرادات' : 'Total Revenue',
            labelAr: 'إجمالي الإيرادات',
            value: config.isRTL ? '٨٨٥,٠٠٠ ر.س' : 'SAR 885,000',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي المصروفات' : 'Total Expenses',
            labelAr: 'إجمالي المصروفات',
            value: config.isRTL ? '٥٤٥,٧٠٠ ر.س' : 'SAR 545,700',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'صافي الربح' : 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.isRTL ? '٣٣٩,٣٠٠ ر.س' : 'SAR 339,300',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.success(),
      ),
      spacing: 10,
    );
  }
}
