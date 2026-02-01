import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Headers demo PDF document with extended details covering all scenarios.
class HeadersDemoBuilder extends GeniusPdfDocumentBuilder {
  HeadersDemoBuilder(super.config);

  late final _companyInfo = GeniusPdfCompanyInfo(
    name: 'Al-Amal Trading Company',
    nameAr: 'شركة الأمل للتجارة',
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    address: 'King Fahd Road',
    addressAr: 'طريق الملك فهد',
    city: 'Riyadh',
    cityAr: 'الرياض',
    country: 'Saudi Arabia',
    countryAr: 'المملكة العربية السعودية',
    phone: '+966 11 123 4567',
    email: 'info@alamal.com',
  );

  @override
  void build() {
    // 1. Invoice Header (Standard Style)
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'فاتورة ضريبية - Invoice' : 'Invoice Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Tax Invoice',
        titleAr: 'فاتورة ضريبية',
        subtitle: 'Invoice #INV-2024-001',
        subtitleAr: 'فاتورة رقم #INV-2024-001',
        company: _companyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.invoice(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Standard invoice header with logo (if provided), company info on one side, and title/document info on the other.',
      'رأس فاتورة قياسي مع شعار (إذا توفر)، معلومات الشركة في جانب، والعنوان/معلومات المستند في الجانب الآخر.',
    );

    // 2. Bilingual Split Header
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'مزدوج اللغة - Bilingual' : 'Bilingual Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader.bilingualSplit(
        config: config,
        title: 'Trial Balance',
        titleAr: 'ميزان المراجعة',
        subtitle: 'As of December 31, 2025',
        subtitleAr: 'كما في 31 ديسمبر 2025',
        company: _companyInfo,
        date: DateTime.now(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Split layout: English info on left, Arabic info on right, logo centered.',
      'تخطيط مقسم: المعلومات الإنجليزية يساراً، العربية يميناً، والشعار في المنتصف.',
    );

    // 3. Letterhead Style
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'ورق رسمي - Letterhead' : 'Letterhead Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Official Letter',
        titleAr: 'خطاب رسمي',
        company: _companyInfo,
        printDate: DateTime.now(),
        layout: GeniusPdfReportHeaderLayout.letterhead,
        style: GeniusPdfReportHeaderStyle.classic(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Classic letterhead style layout suitable for official correspondence.',
      'نمط الورق الرسمي الكلاسيكي مناسب للمراسلات الرسمية.',
    );

    // 4. Report Card Style
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'بطاقة تقرير - Report Card' : 'Report Card Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Performance Report',
        titleAr: 'تقرير الأداء',
        company: _companyInfo,
        printDate: DateTime.now(),
        layout: GeniusPdfReportHeaderLayout.reportCard,
        style: GeniusPdfReportHeaderStyle.modern(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Modern card-style layout often used in dashboards or summaries.',
      'تخطيط حديث بأسلوب البطاقة يستخدم غالباً في لوحات المعلومات أو الملخصات.',
    );

    // 5. Minimal Header
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'بسيط - Minimal' : 'Minimal Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader.simple(
        config: config,
        title: 'Quick Summary',
        titleAr: 'ملخص سريع',
        date: DateTime.now(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Simple header with just title and date, no company details.',
      'رأس بسيط يحتوي فقط على العنوان والتاريخ، بدون تفاصيل الشركة.',
    );

    // 6. Full Width Header
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'عرض كامل - Full Width' : 'Full Width Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Comprehensive Analysis',
        titleAr: 'تحليل شامل',
        company: _companyInfo,
        printDate: DateTime.now(),
        layout: GeniusPdfReportHeaderLayout.fullWidth,
        style: GeniusPdfReportHeaderStyle.corporate(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Full width layout spanning the entire page width.',
      'تخطيط بالعرض الكامل يمتد عبر عرض الصفحة بالكامل.',
    );
  }

  void _addExplanation(String en, String ar) {
    addLine(
      config.isRTL ? ar : en,
      font: baseFont,
      brush: PdfBrushes.darkGray,
    );
  }
}
