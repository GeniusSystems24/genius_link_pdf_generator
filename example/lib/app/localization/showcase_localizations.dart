import 'package:flutter/widgets.dart';

/// Lightweight localization used by the example showcase.
///
/// The example intentionally keeps localization source-local and codegen-free so
/// package consumers can inspect the implementation without running generators.
class ShowcaseL10n {
  const ShowcaseL10n(this.locale);

  final Locale locale;

  bool get isArabic => locale.languageCode.toLowerCase() == 'ar';

  static ShowcaseL10n of(BuildContext context) =>
      ShowcaseL10n(Localizations.localeOf(context));

  String tr(String english) => isArabic ? (_commonAr[english] ?? english) : english;

  String destinationTitle(String id, String fallback) {
    if (!isArabic) return fallback;
    return _destinationAr[id]?.$1 ?? fallback;
  }

  String destinationDescription(String id, String fallback) {
    if (!isArabic) return fallback;
    return _destinationAr[id]?.$2 ?? fallback;
  }

  String exampleTitle(String english, String arabic) =>
      isArabic && arabic.isNotEmpty ? arabic : english;

  static const Map<String, (String, String)> _destinationAr = {
    'previous-examples': ('الأمثلة السابقة', 'كل تغطية أمثلة التطبيق السابق باستثناء شاشات التحقق S00-S26.'),

    'dashboard': ('نظرة عامة', 'قدرات الحزمة ونقاط الوصول السريعة.'),
    'getting-started': ('البدء', 'تحميل الخطوط وتهيئة المستند وتوليد PDF ومعاينته.'),
    'document-builder': ('GeniusPdfDocumentBuilder', 'إنشاء المستندات وتتبع الموضع وتقسيم الصفحات ودورة حياة الصفحة.'),
    'configuration': ('الإعدادات والصفحة', 'حجم الصفحة والاتجاه والهوامش والخطوط واتجاه النص والثيم والتنسيق.'),
    'typography': ('النصوص والطباعة', 'النص العادي والغني وأدوار الخطوط وأنماط المحتوى.'),
    'directionality': ('العربية وRTL وثنائية اللغة', 'توليد مستندات عربية وRTL/LTR وثنائية اللغة.'),
    'headers-footers': ('الرؤوس والتذييلات', 'رؤوس التقارير وتذييلات الصفحات وأرقام الصفحات.'),
    'tables-reports': ('الجداول والتقارير', 'شبكات البيانات والمجموعات والإجماليات والملخصات.'),
    'media': ('الصور وQR والباركود والمرفقات', 'وسائط المستند وأكواد QR والباركود والمرفقات.'),
    'reusable-components': ('مكونات PDF قابلة لإعادة الاستخدام', 'مكونات تركيب قابلة لإعادة الاستخدام داخل المستندات.'),
    'report-composer': ('منشئ التقارير المرن', 'بناء تقارير مقسمة إلى صفحات من أقسام وجداول وملخصات.'),
    'custom-reports': ('تقارير مخصصة', 'تجميع مكونات الحزمة لإنشاء تقارير خاصة بالتطبيق.'),
    'templates': ('القوالب', 'استكشاف قوالب الفواتير والميزان والكشوفات والمخزون.'),
    'business-documents': ('مستندات الأعمال', 'نماذج عملية للمبيعات والمالية والموارد البشرية والتشغيل.'),
    'preview': ('معاينة PDF', 'معاينة البايتات المولدة مباشرة داخل التطبيق.'),
    'delivery': ('حفظ وفتح ومشاركة وطباعة', 'تجربة مسارات تسليم المستند من واجهة واحدة.'),
    'pdf-operations': ('عمليات PDF', 'فحص ودمج وتقسيم واستخراج وتدوير وإضافة علامة مائية.'),
    'background-generation': ('التوليد في الخلفية', 'مقارنة التوليد المباشر والتوليد في الخلفية.'),
    'batch-generation': ('التوليد الدفعي', 'توليد عدة مستندات مستقلة في طلب واحد.'),
    'job-queues': ('قوائم الانتظار والمهام', 'إدارة مهام التوليد والأولوية والإلغاء والحالة.'),
    'architecture-di': ('المعمارية وحقن الاعتماديات', 'تنظيم التكامل مع الحزمة وعزل الخدمات.'),
    'testing': ('الاختبار', 'اختبار المستندات والخدمات والتكامل بدون ربط الواجهة.'),
    'erp-families': ('عائلات مستندات ERP', 'عائلات ERP العامة وعقود المستندات الدلالية.'),
    'erp-packs': ('حزم ERP', 'عقود ومكونات حزم ERP المشتركة.'),
    'sales-pack': ('حزمة المبيعات', 'مستندات المبيعات والتقارير وسير العمل المرتبط بها.'),
    'purchasing-pack': ('حزمة المشتريات', 'مستندات الشراء والتوريد والموردين.'),
    'accounting-pack': ('حزمة المحاسبة والمالية', 'مستندات المحاسبة والمالية والكشوفات.'),
    'inventory-pack': ('حزمة المخزون والمستودعات', 'مستندات المخزون والمستودعات والملصقات.'),
    'pos-pack': ('حزمة نقاط البيع والتجزئة', 'الإيصالات والملصقات وتقارير نقاط البيع.'),
    'hr-pack': ('حزمة الموارد البشرية والرواتب', 'مستندات الموظفين والحضور والرواتب.'),
    'manufacturing-pack': ('حزمة التصنيع والجودة', 'مستندات التصنيع والإنتاج وفحوصات الجودة.'),
    'assets-projects-pack': ('حزمة الأصول والمشاريع', 'مستندات الأصول الثابتة والمشاريع والتكاليف.'),
    'service-logistics-pack': ('حزمة الخدمات واللوجستيات', 'الصيانة والشحن والتتبع والخدمات اللوجستية.'),
    'crm-pack': ('حزمة CRM', 'مستندات العملاء والفرص والأنشطة التجارية.'),
    'template-engine-vnext': ('محرك القوالب vNext', 'قوالب معتمدة على المخطط والربط وخط العرض.'),
    'compliance': ('الامتثال والأرشفة', 'الامتثال والتوقيع والتدقيق وملفات الأرشفة.'),
    'quality': ('الجودة والانحدار', 'أدوات قياس الأداء والتحقق والانحدار.'),
    'template-designer': ('مصمم القوالب', 'نماذج تصميم القوالب والتخطيط برمجيًا.'),
    'industry-packs': ('حزم القطاعات', 'واجهات حزم القطاعات والإضافات الاختيارية.'),
    'ai': ('ميزات الذكاء الاصطناعي', 'قدرات مساعدة اختيارية مرتبطة بمعالجة النصوص.'),
    'printing-module': ('وحدة الطباعة', 'ملفات الطباعة المتقدمة وتكامل الطابعات.'),
    'sharing-module': ('وحدة المشاركة', 'مسارات مشاركة PDF وخيارات المشاركة.'),
    'security': ('الأمان', 'مسارات أمان PDF وسياسات حماية المستند.'),
    'export': ('التصدير', 'خدمات التصدير والصيغ المدعومة.'),
  };

  static const Map<String, String> _commonAr = {
    'Previous examples': 'الأمثلة السابقة',
    'Previous example catalog': 'كتالوج الأمثلة السابقة',
    'All previous examples are represented here except S00-S26 verification screens.': 'جميع أمثلة الإصدار السابق ممثلة هنا باستثناء شاشات التحقق S00-S26.',
    'Search previous examples': 'البحث في الأمثلة السابقة',
    'All': 'الكل',
    'Components': 'المكونات',
    'Templates': 'القوالب',
    'Business Templates': 'قوالب الأعمال',
    'Examples Showcase': 'عرض الأمثلة',
    'Modern Vouchers': 'السندات الحديثة',
    'Previous Screens': 'الشاشات السابقة',
    'No matching examples.': 'لا توجد أمثلة مطابقة.',
    'Preserved previous screen': 'شاشة سابقة محفوظة',
    'The previous implementation source is preserved outside example/lib so it remains inspectable without reintroducing obsolete dependencies.': 'تم حفظ مصدر التنفيذ السابق خارج example/lib ليبقى قابلاً للمراجعة دون إعادة الاعتماديات القديمة.',
    'Current coverage': 'التغطية الحالية',
    'Full screen': 'ملء الشاشة',
    'Preview full screen': 'معاينة بملء الشاشة',
    'Open completed file': 'فتح الملف المكتمل',
    'Choose any template, direction and priority before adding it to the queue.': 'اختر أي قالب واتجاه وأولوية قبل إضافته إلى قائمة الانتظار.',
    'Template': 'القالب',
    'Priority': 'الأولوية',
    'Add selected template': 'إضافة القالب المحدد',
    'Selected template': 'القالب المحدد',
    'active': 'نشطة',
    'completed': 'مكتملة',
    'low': 'منخفضة',
    'normal': 'عادية',
    'high': 'عالية',
    'urgent': 'عاجلة',
    'queued': 'في الانتظار',
    'processing': 'قيد التنفيذ',
    'failed': 'فشلت',
    'cancelled': 'ملغاة',

    'Genius PDF Showcase': 'عرض Genius PDF',
    'Navigation': 'التنقل',
    'Theme': 'المظهر',
    'Language': 'اللغة',
    'Text direction': 'اتجاه النص',
    'Automatic': 'تلقائي',
    'Left to right': 'من اليسار إلى اليمين',
    'Right to left': 'من اليمين إلى اليسار',
    'Start': 'ابدأ',
    'Build PDFs': 'إنشاء PDF',
    'Authoring': 'الإنشاء',
    'Content & layout': 'المحتوى والتخطيط',
    'Reports & templates': 'التقارير والقوالب',
    'Workflows': 'مسارات العمل',
    'Preview & delivery': 'المعاينة والتسليم',
    'Scale & queues': 'التوسع وقوائم الانتظار',
    'Integration': 'التكامل',
    'Advanced & optional': 'متقدم واختياري',
    'Package modules': 'وحدات الحزمة',
    'Explore the package': 'استكشف الحزمة',
    'Focused entry points — the complete feature tree remains in the sidebar.': 'نقاط وصول مركزة — تبقى شجرة الميزات الكاملة في الشريط الجانبي.',
    'Capability summary': 'ملخص القدرات',
    'Open example': 'فتح المثال',
    'Working example': 'مثال تفاعلي',
    'Generate a fresh builder for every action.': 'يتم إنشاء Builder جديد لكل عملية.',
    'Usage': 'الاستخدام',
    'Current public API used by this example.': 'واجهة API العامة المستخدمة في هذا المثال.',
    'API focus': 'تركيز API',
    'Package module examples': 'أمثلة وحدة الحزمة',
    'Every example shown below has its own Generate action.': 'كل مثال ظاهر أدناه يحتوي على إجراء توليد مستقل.',
    'Generate': 'توليد',
    'Generating…': 'جارٍ التوليد…',
    'Save': 'حفظ',
    'Open': 'فتح',
    'Share': 'مشاركة',
    'Print': 'طباعة',
    'PDF preview': 'معاينة PDF',
    'Generate this example to render it here.': 'قم بتوليد المثال لعرضه هنا.',
    'Generate a document to populate the preview.': 'قم بتوليد مستند لعرض المعاينة.',
    'Generating PDF…': 'جارٍ توليد PDF…',
    'Generating in background…': 'جارٍ التوليد في الخلفية…',
    'Generating and saving…': 'جارٍ التوليد والحفظ…',
    'Generating and opening…': 'جارٍ التوليد والفتح…',
    'Generating and sharing…': 'جارٍ التوليد والمشاركة…',
    'Opening print workflow…': 'جارٍ فتح مسار الطباعة…',
    'Print workflow completed.': 'اكتمل مسار الطباعة.',
    'Print workflow was cancelled or unavailable.': 'تم إلغاء الطباعة أو أنها غير متاحة.',
    'Generated successfully': 'تم التوليد بنجاح',
    'Close': 'إغلاق',
    'Example': 'مثال',
    'Module': 'الوحدة',
    'Direction': 'الاتجاه',
    'Interface language': 'لغة الواجهة',
    'The selected text direction is also used as the default direction for newly generated showcase documents.': 'يُستخدم اتجاه النص المحدد أيضًا كاتجاه افتراضي لمستندات العرض الجديدة.',
    'Operations workbench': 'مساحة عمليات PDF',
    'All actions operate on generated in-memory PDF bytes.': 'تعمل جميع الإجراءات على بيانات PDF مولدة في الذاكرة.',
    'Document info': 'معلومات المستند',
    'Merge': 'دمج',
    'Split': 'تقسيم',
    'Extract': 'استخراج',
    'Rotate': 'تدوير',
    'Watermark': 'علامة مائية',
    'Transformed PDF preview appears here.': 'تظهر هنا معاينة PDF بعد تنفيذ العملية.',
    'Queue controls': 'عناصر تحكم قائمة الانتظار',
    'Add normal job': 'إضافة مهمة عادية',
    'Add high priority': 'إضافة أولوية عالية',
    'Add urgent job': 'إضافة مهمة عاجلة',
    'Jobs': 'المهام',
    'No jobs yet.': 'لا توجد مهام بعد.',
    'Cancel': 'إلغاء',
    'Document gallery': 'معرض المستندات',
    'Dart usage': 'استخدام Dart',
    'Source extracted from the implementation used by this repository.': 'تم استخراج المصدر من التنفيذ الفعلي المستخدم في هذا المستودع.',
    'Exact builder and generation path used by this screen.': 'مسار الـ builder والتوليد الفعلي المستخدم في هذه الشاشة.',
    'Copy code': 'نسخ الكود',
    'Code copied': 'تم نسخ الكود',
    'Tax invoice': 'فاتورة ضريبية',
    'Trial balance': 'ميزان مراجعة',
    'Customer statement': 'كشف حساب عميل',
    'Inventory report': 'تقرير مخزون',
    'Quotation': 'عرض سعر',
    'Purchase order': 'أمر شراء',
    'Delivery note': 'إشعار تسليم',
    'Balance sheet': 'ميزانية عمومية',
    'Income statement': 'قائمة دخل',
    'Payslip': 'قسيمة راتب',
  };
}

String showcaseTr(BuildContext context, String english) =>
    ShowcaseL10n.of(context).tr(english);
