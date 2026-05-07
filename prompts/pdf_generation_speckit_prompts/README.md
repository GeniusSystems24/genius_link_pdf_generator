# PDF Generation Engine Stability — Spec Kit Prompts

هذه الحزمة تحتوي على برومبتات Markdown منفصلة لكل مرحلة من مراحل Spec Kit، مخصصة لمراجعة وتحسين مكتبة Flutter/Dart PDF Generation Library.

## الهدف

إصلاح وتحسين الأخطاء المتعلقة بآلية توليد ملفات PDF فقط، مثل:

- إنشاء المستند PDF lifecycle
- إدارة الصفحات
- تتبع `currentY`
- منع تداخل المحتوى مع `header` و `footer`
- page-break
- العناصر متعددة الصفحات مثل grids
- الصور والـ QR/barcodes
- توليد bytes صالحة وغير فارغة
- معالجة أخطاء التوليد والتصدير

## خارج النطاق

لا تدخل هذه المهمة في:

- التحقق من صحة البيانات المالية
- التحقق من صحة الضرائب أو المجاميع
- تصحيح الحسابات المحاسبية
- تفسير أو تعديل محتوى المستخدم
- تغيير منطق القوالب التجاري
- إعادة تصميم الهوية البصرية للمطبوعات

مسؤولية صحة البيانات تقع على المستخدم أو النظام الذي يمرر البيانات للمكتبة.

## ترتيب الاستخدام المقترح

1. `000-speckit-init.md`
2. `001-speckit-constitution.md`
3. `002-speckit-specify.md`
4. `003-speckit-clarify.md`
5. `004-speckit-plan.md`
6. `005-speckit-tasks.md`
7. `006-speckit-analyze.md`
8. `007-speckit-implement.md`
9. `008-post-implementation-review.md`

## ملاحظة حول الأوامر

معظم الوكلاء يستخدمون صيغة:

```text
/speckit.constitution
/speckit.specify
/speckit.clarify
/speckit.plan
/speckit.tasks
/speckit.analyze
/speckit.implement
```

أما عند استخدام Codex CLI في وضع skills فقد تحتاج إلى صيغة شبيهة بـ:

```text
$speckit-constitution
$speckit-specify
$speckit-clarify
$speckit-plan
$speckit-tasks
$speckit-analyze
$speckit-implement
```

استخدم الصيغة المناسبة للأداة التي تعمل بها.
