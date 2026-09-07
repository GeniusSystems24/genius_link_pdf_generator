<!-- generated-by: create_user_manager_and_toast_generation_background_doc.py -->

# توليد المستندات في الخلفية وإشعارات اكتمال العملية

هذا المستند يشرح البنية المستخدمة في تطبيق أمثلة `genius_link_pdf_generator`
لتشغيل إنشاء ملفات PDF خارج الـ UI thread قدر الإمكان، وإدارة جميع عمليات
التوليد من خلال `GeniusPdfGenerationManager` واحد على مستوى التطبيق، ثم عرض
حالة العملية للمستخدم بواسطة `SuperToast`.

الهدف من هذه البنية هو تحقيق الآتي:

- منع عمليات إنشاء PDF الثقيلة من تجميد واجهة Flutter.
- توحيد queue وconcurrency لجميع شاشات الأمثلة.
- السماح للمستخدم بالانتقال بين الشاشات أثناء استمرار عملية التوليد.
- عرض تقدم العملية من أي شاشة داخل التطبيق.
- عرض إشعار نجاح بعد اكتمال المستند مع زر لفتحه.
- منع ظهور إشعار `Document generated` أكثر من مرة لنفس job.
- إبقاء منطق إدارة التوليد منفصلًا عن منطق UI الخاص بكل شاشة.

---

## 1. الصورة العامة للبنية

```text
Example screen
    |
    | request document generation
    v
generateExamplePdf(...)
    |
    v
Global GeniusPdfGenerationManager
    |
    +-- queue / priority
    +-- max concurrent jobs
    +-- progress
    +-- lifecycle
    +-- background generation
    |
    +------------------------------+
    |                              |
    v                              v
PDF bytes / saved file       manager.jobUpdates
                                   |
                                   v
                         PdfGenerationToastObserver
                                   |
                                   v
                             SuperToastHost
                                   |
                 +-----------------+------------------+
                 |                                    |
                 v                                    v
       Starting generate document              Document generated
       + progress indicator                    + Open IconButton
```

الفكرة الأساسية هي أن شاشة المثال لا تنشئ manager خاصًا بها، ولا تراقب Toast
بنفسها. جميع الشاشات تستخدم manager عالمي واحد، وطبقة مستقلة على مستوى
التطبيق تراقب حالته وتعرض الإشعارات.

---

## 2. الـ Global `GeniusPdfGenerationManager`

الموقع:

```text
example/lib/app/dependencies/example_dependencies.dart
```

تم وضع manager داخل `ExampleDependencies` ليكون عمره مساويًا لعمر تطبيق
الأمثلة تقريبًا.

البنية المستخدمة:

```dart
final class ExampleDependencies {
  ExampleDependencies._({
    required this.pdfConfig,
    required this.files,
    required this.pdfGenerationManager,
  });

  final GeniusPdfGenerationManager pdfGenerationManager;
}
```

ويتم إنشاء manager افتراضيًا بإعدادات قريبة من:

```dart
GeniusPdfGenerationManager(
  config: GeniusPdfGenerationManagerConfig(
    maxConcurrentJobs: 2,
    defaultRunInBackground: true,
    retryFailedJobs: false,
    cleanupCompletedJobs: true,
    completedJobRetentionDuration: const Duration(minutes: 30),
  ),
);
```

كما يوجد getter عام:

```dart
GeniusPdfGenerationManager get geniusPdfGenerationManager =>
    ExampleDependencies.instance.pdfGenerationManager;
```

### لماذا Manager واحد؟

استخدام manager واحد يضمن أن جميع الشاشات تشترك في:

- نفس queue.
- نفس حد العمليات المتزامنة.
- نفس ترتيب الأولويات.
- نفس stream الخاص بحالة الـ jobs.
- نفس سياسات cleanup.
- نفس آلية التشغيل في الخلفية.
- نفس مصدر البيانات لشاشة مراقبة الـ jobs والـ Toasts.

لا يُنصح بإنشاء:

```dart
GeniusPdfGenerationManager(...)
```

داخل كل Screen، لأن ذلك يفصل الـ queues ويجعل الإشعارات ومراقبة العمليات غير
موحدة.

---

## 3. نقطة الدخول الموحدة لتوليد المستندات

الموقع:

```text
example/lib/shared/application/services/example_pdf_generation.dart
```

تمت إضافة helper موحدة:

```dart
Future<GeniusPdfSuccess> generateExamplePdf({
  required GeniusPdfDocumentBuilder builder,
  required String fileName,
  GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
  Map<String, dynamic>? metadata,
})
```

وتقوم داخليًا باستدعاء:

```dart
geniusPdfGenerationManager.addJobAndWait(
  builder: builder,
  fileName: fileName,
  priority: priority,
  runInBackground: true,
  metadata: ...,
);
```

هذا يعني أن شاشة المثال لا تحتاج إلى معرفة تفاصيل:

- إنشاء job.
- إضافتها إلى queue.
- انتظار اكتمالها.
- إدارة background flag.
- تحويل `GeniusPdfResult` إلى success/failure.

الاستخدام المعتاد من الشاشة:

```dart
final success = await generateExamplePdf(
  builder: build.builder,
  fileName: build.fileName,
  metadata: <String, dynamic>{
    'screen': 'MultiAccountPdf',
    'workflow': 'template-preview',
  },
);
```

بعد ذلك يمكن استخدام:

```dart
success.bytes
success.filePath
success.fileName
```

للعرض أو الفتح.

---

## 4. التشغيل في Background Isolate

هناك حالتان.

### 4.1 Builder يمكن للـ manager تشغيله في الخلفية

في الحالة الاعتيادية يتم تمرير:

```dart
runInBackground: true
```

إلى `GeniusPdfGenerationManager`.

بذلك تكون إدارة اختيار التنفيذ في الخلفية جزءًا من manager وليست مسؤولية
الشاشة.

### 4.2 مثال ثقيل لديه Background Generator مخصص

بعض الأمثلة تجهز بياناتها بشكل قابل للنقل بين isolates، ثم تبني المستند داخل
isolate منفصل.

لهذا تم استخدام adapter مثل:

```dart
final class ExampleBackgroundPdfBuilder
    extends GeniusPdfDocumentBuilder
    implements GeniusPdfBackgroundBuildSource {

  @override
  Future<Uint8List> generateInBackground() => _backgroundGenerator();
}
```

الفائدة من ذلك:

- manager يبقى مالكًا للـ job والـ queue.
- الشاشة لا تنفذ `builder.generate()` مباشرة.
- التنفيذ الثقيل يظل خارج UI isolate.
- progress/status ما زالا يمران عبر manager العالمي.

---

## 5. ما الذي يمكن تمريره إلى Isolate؟

لا يجب افتراض أن أي Dart object قابل للإرسال إلى isolate آخر.

يفضل تمرير بيانات بسيطة وقابلة للنقل مثل:

- `String`
- `int`
- `double`
- `bool`
- `List`
- `Map`
- `Uint8List`
- `TransferableTypedData`

ثم إعادة بناء objects الخاصة بالقالب داخل الـ isolate.

لا تمرر مباشرة:

- `BuildContext`
- Flutter widgets
- controllers مرتبطة بالـ UI
- callbacks تلتقط state من الشاشة
- objects تعتمد على platform channels

إذا كان القالب يحتوي إعدادات customization تعتمد على callbacks، يجب تحويل
الخيارات المطلوبة إلى data بسيطة ثم إعادة إنشاء callback داخل isolate.

---

## 6. مسار قوالب الصور

قوالب الصور تحتاج خطوتين مختلفتين:

```text
Build PDF source
      |
      v
Rasterize PDF pages
      |
      v
PNG / JPEG / WebP
```

الجزء الأول، أي إنشاء PDF، يمكن تشغيله في background isolate بواسطة manager.

أما rasterization الذي يعتمد على APIs مثل `Printing.raster` أو platform
channels فيبقى على root/UI isolate عندما يتطلب ذلك.

لذلك التدفق المقترح هو:

```text
Background isolate:
    build template
    generate PDF bytes
          |
          v
Root isolate:
    PdfDocument.exportToImages(...)
    Printing.raster(...)
    save/open image
```

هذا يزيل الجزء الأكبر من تكلفة إنشاء المستند من UI thread بدون استخدام
platform channels من isolate غير مناسب.

---

## 7. ربط `SuperToast` على مستوى التطبيق

الموقع:

```text
example/lib/app/presentation/genius_pdf_example_app.dart
```

تم وضع `SuperToastHost` داخل:

```dart
MaterialApp.builder
```

بنية تقريبية:

```dart
builder: (context, child) {
  return SuperToastHost(
    style: const SuperToastHostStyle(
      maxVisible: 4,
      alignment: SuperToastAlignment.topEnd,
      padding: EdgeInsets.all(12),
      expandBehavior: SuperToastExpandBehavior.always,
      expandSpacing: 8,
      collapsedProtrusion: 8,
    ),
    child: PdfGenerationToastObserver(
      manager: geniusPdfGenerationManager,
      duration: const Duration(seconds: 10),
      child: child ?? const SizedBox.shrink(),
    ),
  );
},
```

وجود host أعلى محتوى الـ Navigator مهم لأنه يسمح للـ Toast بالبقاء ظاهرًا
حتى إذا انتقل المستخدم إلى شاشة أخرى أثناء استمرار التوليد.

---

## 8. مراقبة عمليات التوليد

الموقع:

```text
example/lib/shared/presentation/widgets/pdf_generation_toast_observer.dart
```

`PdfGenerationToastObserver` لا يقوم بتوليد المستند.

مسؤوليته فقط:

1. الاشتراك في:

```dart
manager.jobUpdates
```

2. تحويل تغير حالة الـ job إلى Feedback بصري.

3. الاحتفاظ بـ progress toast واحد لكل job.

4. إغلاق progress toast عند الوصول إلى terminal state.

5. إظهار success/failure/cancelled toast.

---

## 9. Toast بدء التوليد

عندما تصبح حالة job:

```dart
GeniusPdfJobStatus.processing
```

يظهر Toast بعنوان:

```text
Starting generate document
```

ويحتوي على:

- اسم الملف.
- `CircularProgressIndicator` صغير.
- نسبة تقدم.
- زر إغلاق.
- إمكانية dismiss/swipe.
- انتهاء تلقائي بعد 10 ثوانٍ.

يتم تحديث progress من:

```dart
job.progress
```

وليس من Timer وهمي.

الحالة المحلية المستخدمة لكل job تحتوي على:

```dart
ValueNotifier<double> progress
```

وبذلك تتغير النسبة ومؤشر التقدم بدون إعادة بناء التطبيق بالكامل.

---

## 10. Toast اكتمال التوليد

عند:

```dart
GeniusPdfJobStatus.completed
```

يتم أولًا إنهاء progress toast، ثم إظهار Toast جديد:

```text
Document generated
```

ويحتوي على:

- success icon.
- اسم المستند.
- زر Open.
- زر Close.

زر Open يستخدم المسار الناتج من نفس job:

```dart
final path = result.filePath;
await const GeniusPdfService().openFile(path);
```

لا يتم إعادة إنشاء المستند عند الضغط على Open.

---

## 11. منع تكرار `Document generated`

هذه نقطة مهمة لأن manager قد ينشر terminal state نفسه أكثر من مرة أثناء
تحديث collections/listeners.

لهذا يوجد Set على مستوى observer:

```dart
final Set<String> _terminalEventsHandled = <String>{};
```

وقبل معالجة أي update:

```dart
if (_terminalEventsHandled.contains(job.id)) return;
```

وعند الوصول إلى حالة نهائية:

```dart
_terminalEventsHandled.add(job.id);
```

وبالتالي:

```text
job-123 -> completed event #1 -> show completion toast
job-123 -> completed event #2 -> ignored
job-123 -> completed event #3 -> ignored

job-124 -> completed          -> show its own completion toast
```

المفتاح هو `job.id` وليس اسم الملف، لأن عمليتين مختلفتين قد تولدان نفس اسم
الملف ويجب ألا تمنع إحداهما Toast الأخرى.

---

## 12. الحالات النهائية المدعومة

الـ observer يتعامل مع:

```dart
GeniusPdfJobStatus.completed
GeniusPdfJobStatus.failed
GeniusPdfJobStatus.cancelled
```

ويعرض:

```text
Document generated
Document generation failed
Document generation cancelled
```

كل حالة نهائية تتم معالجتها مرة واحدة لكل `job.id`.

---

## 13. إخفاء Toast لعملية محددة

إذا كانت هناك job داخلية لا ينبغي أن تعرض إشعارًا عامًا، يمكن إضافة metadata:

```dart
metadata: <String, dynamic>{
  'showGenerationToast': false,
},
```

ويقوم observer بتجاهلها:

```dart
if (job.metadata?['showGenerationToast'] == false) return;
```

هذا أفضل من إضافة شروط تعتمد على أسماء الشاشات أو أسماء الملفات.

---

## 14. تصميم Toast

تم استخدام:

```dart
SuperToast.showRaw(...)
```

بدل surface القياسي عندما احتجنا تصميمًا أكثر compact.

الموضع:

```dart
SuperToastAlignment.topEnd
```

والقيود التقريبية:

```dart
const BoxConstraints(
  minWidth: 260,
  maxWidth: 360,
)
```

الهدف هو عدم حجب مساحة كبيرة من التطبيق، خصوصًا عندما توجد أكثر من job
متزامنة.

الـ Toast يدعم:

- app-wide visibility.
- stacking.
- animations.
- swipe dismissal.
- close action.
- auto dismiss.
- semantic tones.
- RTL/LTR directional placement.

---

## 15. التعامل مع إغلاق Progress Toast قبل انتهاء Job

قد يغلق المستخدم progress toast بينما التوليد ما زال يعمل.

لا يجب إنشاء Toast تقدم جديد عند وصول update جديد لنفس job.

لذلك يحتفظ observer بحالة job المتتبعة حتى تنتهي فعليًا، حتى لو أغلق المستخدم
واجهة الـ Toast.

المبدأ:

```text
user closes progress toast
        |
        v
job is still tracked silently
        |
        v
progress events do not recreate toast
        |
        v
job completes
        |
        v
show one terminal toast
```

---

## 16. دعم العمليات المتزامنة

لأن manager عالمي، يمكن تشغيل أكثر من job من شاشات مختلفة.

مثال:

```text
Screen A -> MultiAccountPdf
Screen B -> TransactionTransferPdf
Screen C -> SingleAccountImage
```

كل واحدة تحصل على `job.id` مستقل.

الـ observer يحتفظ بـ:

```dart
Map<String, _GenerationToastState>
```

وبذلك يملك كل job:

- progress مستقل.
- toast مستقل.
- terminal de-duplication مستقل.

`maxConcurrentJobs` في manager هو الذي يحدد عدد العمليات التي تعمل فعليًا في
نفس الوقت.

---

## 17. دورة حياة Manager

الـ manager ملك لـ `ExampleDependencies` وليس للشاشات.

لذلك لا يجب أن تستدعي شاشة:

```dart
geniusPdfGenerationManager.dispose();
```

عند `dispose()` الخاص بها.

التخلص من manager يحدث فقط عندما يتم إنهاء dependencies العامة بشكل صريح:

```dart
ExampleDependencies.dispose();
```

هذا يمنع إلغاء jobs النشطة عند الانتقال بين الشاشات.

---

## 18. إضافة شاشة PDF جديدة بالطريقة الصحيحة

عند إنشاء مثال جديد، يفضل أن تكون الشاشة مسؤولة فقط عن:

1. جمع الخيارات.
2. بناء template/build request.
3. طلب التوليد.
4. عرض preview الناتج.

مثال:

```dart
Future<void> generate() async {
  final build = createMyTemplate(isRtl: isRtl);

  final result = await generateExamplePdf(
    builder: build.builder,
    fileName: build.fileName,
    metadata: <String, dynamic>{
      'screen': 'MyTemplate',
      'workflow': 'template-preview',
    },
  );

  setState(() {
    previewBytes = result.bytes;
    previewFilePath = result.filePath;
  });
}
```

لا تضف Toast داخل هذه الشاشة؛ observer العام سيعرضه تلقائيًا.

---

## 19. إضافة شاشة Heavy PDF جديدة

إذا كانت عملية بناء القالب نفسها ثقيلة ويجب تنفيذها صراحة داخل isolate:

```dart
final builder = ExampleBackgroundPdfBuilder(
  config: geniusPdfConfig,
  backgroundGenerator: () async {
    return generateMyDocumentInBackground(
      serializedOptions: options,
    );
  },
);

final result = await generateExamplePdf(
  builder: builder,
  fileName: 'my_heavy_document',
);
```

يجب أن تكون `generateMyDocumentInBackground` قادرة على العمل بدون
`BuildContext` أو platform-channel dependencies.

---

## 20. ما الذي يجب تجنبه؟

### لا تستخدم

```dart
builder.generate();
```

مباشرة داخل event handler في شاشة Flutter للمستندات الثقيلة.

### لا تنشئ manager داخل الشاشة

```dart
final manager = GeniusPdfGenerationManager(...);
```

### لا تضف Toast محليًا لكل شاشة

```dart
SuperToast.show(...);
```

لبداية/اكتمال التوليد إذا كانت job تمر أصلًا عبر manager العام.

### لا تستخدم اسم الملف لمنع التكرار

استخدم:

```dart
job.id
```

### لا تتخلص من الـ global manager عند مغادرة الشاشة

عمر manager على مستوى التطبيق.

---

## 21. الملفات الرئيسية في التطبيق

```text
example/lib/app/dependencies/example_dependencies.dart
    Global GeniusPdfGenerationManager

example/lib/shared/application/services/example_pdf_generation.dart
    Manager-backed generation helper
    Background builder adapter

example/lib/app/presentation/genius_pdf_example_app.dart
    SuperToastHost
    PdfGenerationToastObserver

example/lib/shared/presentation/widgets/pdf_generation_toast_observer.dart
    Progress/completion/failure/cancelled notifications
    Terminal-event de-duplication

example/lib/features/templates/presentation/widgets/
template_example_detail_screen.dart
    Shared PDF example execution flow

example/lib/features/export/presentation/widgets/
template_image_export_detail_screen.dart
    Shared image-export flow

example/lib/features/templates/models/documents/
export_template_background_generators.dart
    Isolate-safe generators for heavy export examples
```

---

## 22. تسلسل عملية PDF كاملة

```text
User presses Generate
        |
        v
Screen creates builder/options
        |
        v
generateExamplePdf()
        |
        v
GeniusPdfGenerationManager.addJobAndWait()
        |
        +----> jobUpdates: processing
        |             |
        |             v
        |       progress toast appears
        |
        v
background PDF generation
        |
        +----> jobUpdates: progress
        |             |
        |             v
        |       toast progress updates
        |
        v
file generated
        |
        +----> jobUpdates: completed
                      |
                      v
              dismiss progress toast
                      |
                      v
              terminal id marked handled
                      |
                      v
              show "Document generated"
                      |
                      v
                 Open button
```

---

## 23. لماذا هذه البنية قابلة للتوسع؟

عند إضافة Template جديد، لا نحتاج إلى إعادة تنفيذ:

- queue.
- concurrency.
- isolate lifecycle.
- progress tracking.
- completion handling.
- toast placement.
- open action.
- duplicate-event protection.

القالب الجديد يحتاج فقط إلى توفير builder أو background bytes generator ثم
تمريره إلى المسار الموحد.

وهذا يحافظ على separation of concerns:

```text
Template
    -> يعرف كيف يبني المستند

Screen
    -> يعرف متى يطلب التوليد وكيف يعرض النتيجة

Generation Manager
    -> يعرف كيف يدير الـ jobs

Toast Observer
    -> يعرف كيف يعرض feedback للمستخدم

App Root
    -> يوفر lifetime عالمي للـ manager والـ toast host
```

---

## 24. Checklist عند إضافة Generator جديد

- [ ] يستخدم `geniusPdfGenerationManager` العالمي.
- [ ] لا ينشئ manager محليًا.
- [ ] يمر عبر `generateExamplePdf(...)` أو helper manager-backed مماثلة.
- [ ] يستخدم `runInBackground: true` للمستندات الثقيلة.
- [ ] البيانات المرسلة إلى isolate قابلة للنقل.
- [ ] لا يستخدم `BuildContext` داخل background generator.
- [ ] لا يستخدم platform channels من isolate غير مدعوم.
- [ ] لا ينشئ Toast توليد محليًا.
- [ ] يضع metadata مناسبة للـ job.
- [ ] يستخدم `showGenerationToast: false` فقط للعمليات التي يجب إخفاؤها.
- [ ] لا يعيد توليد المستند عند Open إذا كان المسار الناتج متوفرًا.
- [ ] لا يتخلص من الـ global manager من داخل الشاشة.

---

## 25. النتيجة النهائية

بعد هذه التعديلات أصبح تطبيق الأمثلة قادرًا على بدء إنشاء مستند من أي شاشة،
ثم يسمح للمستخدم بمتابعة استخدام التطبيق بينما تستمر العملية في الخلفية.

يظهر Toast صغير في `TopEnd` يعرض تقدم العملية. وعند الاكتمال يتم استبداله
بإشعار نجاح واحد فقط لنفس `job.id` مع زر لفتح المستند الناتج.

وبذلك أصبح مسار إنشاء المستندات موحدًا على مستوى التطبيق وقابلًا لإعادة
الاستخدام مع أي Template جديد بدون تكرار منطق الـ background execution أو
إشعارات المستخدم.

