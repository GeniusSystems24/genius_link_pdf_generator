# معايير البناء والتطوير - Genius Link PDF Generator

## نظرة عامة

هذا الملف يحتوي على المعايير والإرشادات التي يجب اتباعها عند تطوير مكتبة PDF Generator.

---

## ⭐ ملاحظات أسلوب التطوير المعتمد

### 1. نمط Factory Constructors

استخدم Factory Constructors لتوفير إعدادات جاهزة شائعة الاستخدام:

```dart
class GeniusPrintSettings {
  // المُنشئ الأساسي
  const GeniusPrintSettings({...});

  // Factory constructors للاستخدامات الشائعة
  factory GeniusPrintSettings.defaults() => ...;
  factory GeniusPrintSettings.draft() => ...;
  factory GeniusPrintSettings.highQuality() => ...;
  factory GeniusPrintSettings.eco() => ...;
}
```

### 2. نمط Singleton للخدمات

استخدم Singleton Pattern للخدمات التي تحتاج instance واحد:

```dart
class GeniusPrinterService {
  GeniusPrinterService._();

  static GeniusPrinterService? _instance;

  static GeniusPrinterService get instance {
    _instance ??= GeniusPrinterService._();
    return _instance!;
  }
}
```

### 3. نمط Result Classes

استخدم Result Classes لإرجاع نتائج العمليات:

```dart
class GeniusPdfShareResult {
  const GeniusPdfShareResult({
    required this.success,
    this.error,
    this.filePath,
  });

  factory GeniusPdfShareResult.success({String? filePath}) => ...;
  factory GeniusPdfShareResult.failure(String error) => ...;

  final bool success;
  final String? error;
  final String? filePath;
}
```

### 4. Extension Methods للاستخدام السهل

أضف Extension Methods على الأنواع الشائعة:

```dart
extension GeniusPrintBytesExtension on Uint8List {
  Future<GeniusPrintResult> print({required String documentName}) => ...;
  Future<GeniusPdfShareResult> share({required String fileName}) => ...;
  Future<Uint8List?> toThumbnail({double dpi = 72}) => ...;
}
```

### 5. دعم ثنائي اللغة (Bilingual)

كل مكون يجب أن يدعم العربية والإنجليزية:

```dart
class GeniusBarcodeValidationResult {
  final String? errorMessage;     // English
  final String? errorMessageAr;   // Arabic

  String? getErrorMessage({bool isRTL = false}) {
    return isRTL ? errorMessageAr : errorMessage;
  }
}
```

### 6. Validation قبل التنفيذ

أنشئ فئات Validator للتحقق من صحة البيانات:

```dart
class GeniusBarcodeValidator {
  static GeniusBarcodeValidationResult validate({
    required String data,
    required GeniusBarcodeType type,
  }) {
    // التحقق من صحة البيانات
    if (!isValid) {
      return GeniusBarcodeValidationResult.invalid(
        'Error message',
        'رسالة الخطأ',
      );
    }
    return GeniusBarcodeValidationResult.valid();
  }
}
```

### 7. Batch/Group Operations

وفر طرق لمعالجة مجموعات من العناصر:

```dart
class GeniusBarcodeGenerator {
  // توليد سلسلة من الباركودات
  static List<GeniusPdfBarcode> generateSequence({
    required String prefix,
    required int start,
    required int count,
    ...
  });

  // توليد من قائمة بيانات
  static List<GeniusPdfBarcode> fromDataList({
    required List<String> dataList,
    ...
  });
}
```

### 8. Layout/Grouping Components

وفر مكونات لتجميع العناصر المتشابهة:

```dart
enum GeniusBarcodeGroupLayout { horizontal, vertical, grid }

class GeniusBarcodeGroup {
  final List<GeniusPdfBarcode> barcodes;
  final GeniusBarcodeGroupLayout layout;
  final double spacing;
  final int gridColumns;

  Rect draw({required PdfPage page, required Rect bounds});
}
```

### 9. Platform Capabilities Detection

تحقق من قدرات المنصة قبل تنفيذ العمليات:

```dart
class GeniusPrintingCapabilities {
  final bool canPrint;
  final bool canShare;
  final bool canRaster;
  final bool directPrint;

  String get summaryEn => ...; // English summary
  String get summaryAr => ...; // Arabic summary
}
```

### 10. Filtered Lists/Getters

وفر getters للحصول على قوائم مفلترة:

```dart
class GeniusPrinterDiscoveryResult {
  final List<GeniusPrinterInfo> printers;

  // Filtered getters
  List<GeniusPrinterInfo> get availablePrinters =>
      printers.where((p) => p.isAvailable).toList();
  List<GeniusPrinterInfo> get networkPrinters =>
      printers.where((p) => p.connectionType == ConnectionType.network).toList();
  List<GeniusPrinterInfo> get colorPrinters =>
      printers.where((p) => p.capabilities.supportsColor).toList();
}
```

### 11. Progress Callbacks

وفر callbacks لتتبع التقدم في العمليات الطويلة:

```dart
Future<GeniusPdfRasterResult> rasterPdf({
  required Uint8List pdfBytes,
  double dpi = 150,
  void Function(int current, int total)? onProgress,
});
```

### 12. Enhanced UI Widgets

أنشئ versions محسنة من الـ widgets مع ميزات إضافية:

```dart
// Widget أساسي
class GeniusPrintPreview extends StatefulWidget { ... }

// Widget محسن مع ميزات إضافية
class GeniusPrintPreviewEnhanced extends StatefulWidget {
  final bool showShareButton;
  final bool showSaveButton;
  final void Function()? onShare;
  final void Function()? onSave;
  ...
}
```

---

## قواعد إلزامية لكل طلب تطوير

### 1. تحديث الملفات الأساسية

> **مهم جداً:** في كل طلب تطوير يجب تحديث الملفات التالية:

| الملف | الوصف | متى يتم التحديث |
|-------|-------|-----------------|
| `CHANGELOG.md` | سجل التغييرات | عند كل تغيير (ميزة، إصلاح، تحسين) |
| `README.md` | توثيق المكتبة | عند إضافة ميزة جديدة أو تغيير API |
| `example/` | مشروع الأمثلة | عند إضافة مكون أو قالب أو خدمة جديدة |

### 2. تنسيق CHANGELOG.md

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- ميزة جديدة

### Changed
- تغيير في سلوك موجود

### Fixed
- إصلاح خطأ

### Deprecated
- ميزة ستُزال مستقبلاً

### Removed
- ميزة تم إزالتها

### Security
- إصلاح أمني
```

### 3. تحديث README.md

عند إضافة ميزة جديدة، يجب:
- إضافة وصف الميزة في قسم Features
- إضافة مثال استخدام في قسم Usage
- تحديث قسم API Reference إن وجد

### 4. تحديث Example Project

عند إضافة مكون أو قالب جديد:
- إضافة شاشة عرض للمكون في `example/lib/screens/`
- إضافة بيانات تجريبية في `example/lib/data/sample_data.dart`
- تحديث `home_screen.dart` لإضافة رابط للشاشة الجديدة

---

## بنية المشروع

```
lib/
├── genius_link_pdf_generator.dart    # الملف الرئيسي للتصدير
└── src/
    ├── core/                         # النواة الأساسية
    │   ├── pdf_config.dart
    │   ├── pdf_assets.dart
    │   └── pdf_result.dart
    ├── models/                       # نماذج البيانات
    │   ├── app_pdf_image.dart
    │   └── app_pdf_page_size.dart
    ├── builders/                     # بناة المستندات
    │   └── pdf_document_builder.dart
    ├── services/                     # الخدمات
    │   ├── pdf_service.dart
    │   └── pdf_generation_manager.dart
    ├── components/                   # المكونات
    │   ├── models/                   # نماذج المكونات
    │   │   ├── pdf_styles.dart
    │   │   └── grid_models.dart
    │   └── widgets/                  # عناصر PDF
    │       ├── pdf_data_grid.dart
    │       ├── pdf_rich_text.dart
    │       ├── pdf_info_box.dart
    │       ├── pdf_report_header.dart
    │       └── pdf_summary.dart
    ├── templates/                    # القوالب الجاهزة
    │   ├── tax_invoice_template.dart
    │   ├── trial_balance_template.dart
    │   ├── customer_statement_template.dart
    │   └── inventory_report_template.dart
    ├── widgets/                      # عناصر Flutter للمعاينة
    │   └── pdf_preview.dart
    └── extensions/                   # الإضافات
        └── pdf_extensions.dart
```

---

## معايير كتابة الكود

### 1. التسمية

```dart
// الملفات: snake_case
pdf_data_grid.dart
tax_invoice_template.dart

// الكلاسات: PascalCase
class PdfDataGrid {}
class TaxInvoiceTemplate {}

// المتغيرات والدوال: camelCase
final gridStyle = PdfGridStyle();
void drawHeader() {}

// الثوابت: camelCase أو SCREAMING_SNAKE_CASE
const defaultMargin = 20.0;
const MAX_PAGE_COUNT = 100;
```

### 2. دعم اللغة العربية

كل مكون يجب أن يدعم:
- خاصية `title` و `titleAr` للعناوين
- خاصية `label` و `labelAr` للتسميات
- خاصية `isRtl` لاتجاه النص

```dart
class PdfGridColumn {
  final String title;
  final String? titleAr;  // اختياري للعربية
  final bool isRtl;

  PdfGridColumn({
    required this.title,
    this.titleAr,
    this.isRtl = false,
  });
}
```

### 3. التوثيق

كل كلاس عام يجب أن يحتوي:

```dart
/// وصف مختصر للكلاس
///
/// وصف تفصيلي إن لزم الأمر
///
/// ## مثال
/// ```dart
/// final grid = PdfDataGrid(
///   columns: [...],
///   rows: [...],
/// );
/// ```
class PdfDataGrid {
  /// وصف الخاصية
  final List<PdfGridColumn> columns;

  /// وصف الدالة
  ///
  /// [page] الصفحة المراد الرسم عليها
  /// [bounds] حدود الرسم
  ///
  /// يُرجع [PdfLayoutResult] نتيجة الرسم
  PdfLayoutResult draw(PdfPage page, Rect bounds) {
    // ...
  }
}
```

### 4. معالجة الأخطاء

```dart
// استخدم PdfResult للنتائج
sealed class PdfResult<T> {}
class PdfSuccess<T> extends PdfResult<T> {
  final T data;
}
class PdfFailure<T> extends PdfResult<T> {
  final String message;
  final Object? error;
}

// مثال الاستخدام
Future<PdfResult<Uint8List>> generatePdf() async {
  try {
    final bytes = await _buildPdf();
    return PdfSuccess(bytes);
  } catch (e) {
    return PdfFailure('فشل في إنشاء PDF', error: e);
  }
}
```

---

## معايير المكونات

### 1. واجهة المكون

كل مكون PDF يجب أن يحتوي على:

```dart
class PdfComponent {
  // الخصائص المطلوبة
  final double? width;
  final bool isRtl;

  // دالة الرسم الأساسية
  PdfLayoutResult draw(
    PdfPage page,
    Rect bounds, {
    PdfLayoutFormat? layoutFormat,
  });
}
```

### 2. الأنماط (Styles)

```dart
// كل مكون له كلاس أنماط خاص
class PdfComponentStyle {
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  // ...

  // أنماط جاهزة
  factory PdfComponentStyle.classic() => ...;
  factory PdfComponentStyle.modern() => ...;
}
```

### 3. قابلية التخصيص

```dart
// توفير قيم افتراضية معقولة
class PdfInfoBox {
  final String title;
  final String content;
  final PdfInfoBoxStyle style;
  final Color? backgroundColor;  // اختياري
  final double? width;           // اختياري

  PdfInfoBox({
    required this.title,
    required this.content,
    this.style = PdfInfoBoxStyle.card,  // قيمة افتراضية
    this.backgroundColor,
    this.width,
  });
}
```

---

## معايير القوالب

### 1. بنية القالب

```dart
// نموذج البيانات
class TemplateData {
  // بيانات مطلوبة
  // بيانات اختيارية مع قيم افتراضية
}

// القالب
class ReportTemplate {
  final TemplateData data;
  final bool isRtl;

  // إنشاء المستند
  Future<PdfDocument> build();

  // توليد البايتات
  Future<Uint8List> generate();

  // حفظ إلى ملف
  Future<File> saveToFile(String path);
}
```

### 2. مكونات القالب

كل قالب يجب أن يستخدم المكونات الموجودة:
- `PdfReportHeader` للترويسة
- `PdfDataGrid` للجداول
- `PdfSummarySection` للملخصات
- `PdfInfoBox` لصناديق المعلومات

---

## معايير الاختبار

### 1. اختبارات الوحدة

```dart
void main() {
  group('PdfDataGrid', () {
    test('should create grid with columns', () {
      final grid = PdfDataGrid(
        columns: [PdfGridColumn(name: 'id', title: 'ID')],
        rows: [],
      );
      expect(grid.columns.length, 1);
    });

    test('should support RTL', () {
      final grid = PdfDataGrid(
        columns: [],
        rows: [],
        isRtl: true,
      );
      expect(grid.isRtl, true);
    });
  });
}
```

### 2. اختبارات التكامل

```dart
void main() {
  testWidgets('should generate PDF', (tester) async {
    final template = TaxInvoiceTemplate(data: sampleData);
    final result = await template.generate();

    expect(result, isNotEmpty);
  });
}
```

---

## إرشادات Git

### 1. رسائل Commit

```
feat: إضافة ميزة جديدة
fix: إصلاح خطأ
docs: تحديث التوثيق
style: تنسيق الكود
refactor: إعادة هيكلة
test: إضافة اختبارات
chore: مهام صيانة
```

### 2. فروع Git

```
main              # الإصدار المستقر
develop           # التطوير الجاري
feature/xxx       # ميزة جديدة
fix/xxx           # إصلاح خطأ
release/x.x.x     # إعداد إصدار
```

---

## قائمة التحقق قبل الدمج

- [ ] تم تحديث `CHANGELOG.md`
- [ ] تم تحديث `README.md` (إن لزم)
- [ ] تم تحديث مشروع `example/`
- [ ] تم إضافة التوثيق للكود الجديد
- [ ] تم دعم RTL/LTR
- [ ] تم دعم اللغة العربية
- [ ] تم كتابة الاختبارات
- [ ] تم تشغيل الاختبارات بنجاح
- [ ] تم مراجعة الكود

---

## الموارد

- [Syncfusion Flutter PDF](https://pub.dev/packages/syncfusion_flutter_pdf)
- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Keep a Changelog](https://keepachangelog.com)
- [Semantic Versioning](https://semver.org)

---

---

## معايير جدول البيانات (v2.12.0+)

### 1. صفوف الإجمالي المتعددة

استخدم `autoTotals` للإجماليات المحسوبة تلقائياً و `footerRows` للصفوف الصريحة:

```dart
GeniusPdfDataGrid(
  columns: columns,
  rows: dataRows,
  autoTotals: [
    GeniusPdfAutoTotal.sum(label: 'Total', labelColumnId: 'desc'),
    GeniusPdfAutoTotal.average(label: 'Average', labelColumnId: 'desc'),
  ],
  footerRows: [
    GeniusPdfGridRow.total({'desc': 'Grand Total', 'amount': total}),
  ],
);
```

### 2. عرض الأعمدة

أولوية تحديد العرض: `width` (ثابت) > `widthPercent` (نسبة) > `flexFactor` (مرن)

```dart
GeniusPdfGridColumn(id: 'name', title: 'Name', widthPercent: 0.30);
GeniusPdfGridColumn(id: 'desc', title: 'Desc', flexFactor: 2);
GeniusPdfGridColumn(id: 'code', title: 'Code', width: 60);
```

### 3. المجموعات المتداخلة

استخدم `subgroups` للمجموعات الفرعية مع `summary` و `summaries`:

```dart
GeniusPdfGridGroup(
  title: 'Category',
  subgroups: [
    GeniusPdfGridGroup.withSummary(title: 'Sub A', rows: rows, sumColumns: ['total']),
  ],
  summary: GeniusPdfGridRow.total({'desc': 'Category Total', 'total': total}),
);
```

### 4. التجميع التلقائي

استخدم `GeniusDataGridUtils.autoGroup()` لتجميع البيانات المسطحة:

```dart
final groups = GeniusDataGridUtils.autoGroup(
  rows: allRows,
  groupByColumn: 'department',
  sumColumns: ['salary'],
);
```

---

*آخر تحديث: فبراير 2026*
