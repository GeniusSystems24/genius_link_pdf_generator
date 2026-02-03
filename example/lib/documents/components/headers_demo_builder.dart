import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Headers demo PDF document with extended details covering all scenarios.
/// v2.12.7 - Enhanced with info groups, improved RTL support, and accurate positioning.
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

  /// Extended company info with more details
  late final _fullCompanyInfo = GeniusPdfCompanyInfo(
    name: 'Al-Amal Trading Company',
    nameAr: 'شركة الأمل للتجارة',
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    licenseNumber: 'LIC-2025-00123',
    address: 'King Fahd Road, Building 45',
    addressAr: 'طريق الملك فهد، مبنى 45',
    addressLine2: 'Floor 3, Office 301',
    addressLine2Ar: 'الطابق 3، مكتب 301',
    city: 'Riyadh',
    cityAr: 'الرياض',
    postalCode: '12345',
    country: 'Saudi Arabia',
    countryAr: 'المملكة العربية السعودية',
    phone: '+966 11 123 4567',
    phone2: '+966 11 765 4321',
    fax: '+966 11 123 4568',
    email: 'info@alamal.com',
    email2: 'support@alamal.com',
    website: 'www.alamal.com',
    slogan: 'Excellence in Trading',
    sloganAr: 'التميز في التجارة',
  );

  /// Info groups for structured header content
  late final _registrationGroup = GeniusPdfHeaderInfoGroup.registration(
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    licenseNumber: 'LIC-2025-00123',
  );

  late final _contactGroup = GeniusPdfHeaderInfoGroup.contact(
    phone: '+966 11 123 4567',
    email: 'info@alamal.com',
    website: 'www.alamal.com',
  );

  @override
  void build() {
    // 1. Invoice Header (Standard Style)
    _buildInvoiceHeader();

    // 2. Bilingual Split Header (Fixed in v2.12.7)
    _buildBilingualSplitHeader();

    // 3. Bilingual Split with RTL Config
    _buildBilingualSplitRTLHeader();

    // 4. Corporate Header with Info Groups
    _buildCorporateWithGroupsHeader();

    // 5. Saudi Style Header
    _buildSaudiStyleHeader();

    // 6. Letterhead Style
    _buildLetterheadHeader();

    // 7. Minimal Header
    _buildMinimalHeader();

    // 8. Full Company Details Header
    _buildFullDetailsHeader();
  }

  void _buildInvoiceHeader() {
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
        documentNumber: 'INV-2024-001',
        documentNumberLabel: 'Invoice No',
        documentNumberLabelAr: 'رقم الفاتورة',
        style: GeniusPdfReportHeaderStyle.invoice(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Standard invoice header with logo (if provided), company info on one side, and title/document info on the other.',
      'رأس فاتورة قياسي مع شعار (إذا توفر)، معلومات الشركة في جانب، والعنوان/معلومات المستند في الجانب الآخر.',
    );
  }

  void _buildBilingualSplitHeader() {
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
      'Split layout: English info on left, Arabic info on right, logo centered. '
      'Fixed in v2.12.7 to work correctly with both RTL and LTR configurations.',
      'تخطيط مقسم: المعلومات الإنجليزية يساراً، العربية يميناً، والشعار في المنتصف. '
      'تم إصلاحه في v2.12.7 ليعمل بشكل صحيح مع كل من إعدادات RTL و LTR.',
    );
  }

  void _buildBilingualSplitRTLHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'ثنائي اللغة (RTL) - Bilingual RTL'
          : 'Bilingual Header (RTL Config)',
      spacing: 10,
    );
    addSpace(20);

    // Create RTL config for this header specifically
    addReportHeader(
      GeniusPdfReportHeader.bilingualSplit(
        config: config,
        title: 'Financial Statement',
        titleAr: 'القوائم المالية',
        subtitle: 'For the Year Ended December 31, 2025',
        subtitleAr: 'للسنة المنتهية في 31 ديسمبر 2025',
        company: _fullCompanyInfo,
        date: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.bilingualSplit(
          primaryColor: const Color(0xFF006C35),
          accentColor: const Color(0xFF004D26),
        ),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Bilingual split header with full company details and Saudi green theme. '
      'The layout maintains correct positioning regardless of global RTL setting.',
      'رأس ثنائي اللغة مع تفاصيل الشركة الكاملة والنمط السعودي الأخضر. '
      'يحافظ التخطيط على الموضع الصحيح بغض النظر عن إعداد RTL العام.',
    );
  }

  void _buildCorporateWithGroupsHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'رأس مؤسسي مع مجموعات - Corporate with Groups'
          : 'Corporate Header with Info Groups',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Annual Report',
        titleAr: 'التقرير السنوي',
        subtitle: 'Fiscal Year 2025',
        subtitleAr: 'السنة المالية 2025',
        company: _companyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.corporate(
          primaryColor: const Color(0xFF1565C0),
          showAccentLine: true,
        ),
        infoGroups: [_registrationGroup, _contactGroup],
        layout: GeniusPdfReportHeaderLayout.standard,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Corporate header using info groups for structured display of registration '
      'and contact information. Groups can be customized with titles and styling.',
      'رأس مؤسسي يستخدم مجموعات المعلومات للعرض المنظم لمعلومات التسجيل '
      'والتواصل. يمكن تخصيص المجموعات بالعناوين والتنسيق.',
    );
  }

  void _buildSaudiStyleHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'النمط السعودي - Saudi Style' : 'Saudi Style Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Commercial License',
        titleAr: 'الرخصة التجارية',
        subtitle: 'Ministry of Commerce',
        subtitleAr: 'وزارة التجارة',
        company: _fullCompanyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.saudi(
          primaryColor: const Color(0xFF006C35),
        ),
        layout: GeniusPdfReportHeaderLayout.standard,
        showBilingualTitle: true,
        bilingualTitleOrder: GeniusPdfBilingualOrder.arabicFirst,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Saudi-themed header with green color scheme, top and bottom borders, '
      'and Arabic-first bilingual titles suitable for official Saudi documents.',
      'رأس بالنمط السعودي مع مخطط الألوان الأخضر، حدود علوية وسفلية، '
      'وعناوين ثنائية اللغة بالعربية أولاً مناسبة للمستندات السعودية الرسمية.',
    );
  }

  void _buildLetterheadHeader() {
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
        subtitle: 'Reference: REF-2025-001',
        subtitleAr: 'المرجع: REF-2025-001',
        company: _companyInfo,
        printDate: DateTime.now(),
        referenceNumber: 'REF-2025-001',
        referenceLabel: 'Reference',
        referenceLabelAr: 'المرجع',
        layout: GeniusPdfReportHeaderLayout.letterhead,
        style: GeniusPdfReportHeaderStyle.classic(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Classic letterhead style layout suitable for official correspondence '
      'with reference numbers and formal styling.',
      'نمط الورق الرسمي الكلاسيكي مناسب للمراسلات الرسمية '
      'مع أرقام المراجع والتنسيق الرسمي.',
    );
  }

  void _buildMinimalHeader() {
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
        subtitle: 'Generated Report',
        subtitleAr: 'تقرير مولد',
        date: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.minimal(
          accentColor: const Color(0xFF424242),
        ),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Simple header with just title, subtitle, and date. No company details. '
      'Ideal for internal reports or quick summaries.',
      'رأس بسيط يحتوي فقط على العنوان والعنوان الفرعي والتاريخ. بدون تفاصيل الشركة. '
      'مثالي للتقارير الداخلية أو الملخصات السريعة.',
    );
  }

  void _buildFullDetailsHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'تفاصيل كاملة - Full Details'
          : 'Full Company Details Header',
      spacing: 10,
    );
    addSpace(20);

    // Custom info groups with titles
    final customGroups = [
      GeniusPdfHeaderInfoGroup.custom(
        title: 'Registration Info',
        titleAr: 'معلومات التسجيل',
        items: [
          GeniusPdfHeaderInfoItem(
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: '300123456789003',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'CR No',
            labelAr: 'السجل التجاري',
            value: '1010123456',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'License',
            labelAr: 'الترخيص',
            value: 'LIC-2025-00123',
          ),
        ],
        showTitle: true,
      ),
      GeniusPdfHeaderInfoGroup.custom(
        title: 'Contact',
        titleAr: 'التواصل',
        items: [
          GeniusPdfHeaderInfoItem(
            label: 'Phone',
            labelAr: 'الهاتف',
            value: '+966 11 123 4567',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'Email',
            labelAr: 'البريد',
            value: 'info@alamal.com',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'Website',
            labelAr: 'الموقع',
            value: 'www.alamal.com',
          ),
        ],
        showTitle: true,
      ),
    ];

    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Comprehensive Report',
        titleAr: 'تقرير شامل',
        subtitle: 'With All Company Details',
        subtitleAr: 'مع جميع تفاصيل الشركة',
        company: _fullCompanyInfo,
        printDate: DateTime.now(),
        documentNumber: 'DOC-2025-001',
        documentNumberLabel: 'Document No',
        documentNumberLabelAr: 'رقم المستند',
        style: GeniusPdfReportHeaderStyle.modern(),
        infoGroups: customGroups,
        showPageNumber: true,
        pageNumber: 1,
        totalPages: 10,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Header with full company details, custom info groups with section titles, '
      'document number, page numbers, and modern styling. '
      'Demonstrates all available header customization options.',
      'رأس مع تفاصيل الشركة الكاملة، مجموعات معلومات مخصصة مع عناوين الأقسام، '
      'رقم المستند، أرقام الصفحات، والتنسيق الحديث. '
      'يوضح جميع خيارات تخصيص الرأس المتاحة.',
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
