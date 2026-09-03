# Genius Link PDF Generator — ERP Printing Sprint Plan

> خطة تنفيذ تفصيلية قابلة للتحويل مباشرة إلى Issues / Milestones / Pull Requests.
>
> هذه الخطة مكملة لملف `ERP_PRINTING_ROADMAP.md`، وترتب التنفيذ إلى Sprints متتابعة مع Tasks وExit Gates واضحة.
>
> **قاعدة أساسية:** لا يتم بدء Sprint لاحق قبل إغلاق Exit Gate للـ Sprint السابق، إلا إذا كانت المهمة موثقة صراحة بأنها مستقلة ولا تؤثر على الأساس المعماري.

---

# 1. قواعد الالتزام بالخطة

## 1.1 ترتيب الأولويات

- **P0 / Blocker**: اتجاه المحتوى، layout، الجداول، formatting، domain، tests، والعائلات العامة.
- **P1**: تغطية ERP العامة: Sales / Purchasing / Accounting / Inventory / POS / HR.
- **P2**: Manufacturing / Quality / Assets / Projects / Maintenance / Logistics / CRM.
- **P3**: Template Engine المتقدم، versioning، compliance، signing، archival، designer.
- **P4**: Industry-specific packs.

## 1.2 قاعدة عدم التوسع المبكر

لا يتم إنشاء عشرات القوالب كـ standalone implementations قبل اكتمال:

- Directionality.
- Flow/Layout.
- DataGrid.
- Formatting.
- ERP shared models.
- reusable ERP components.
- generic document families.

القالب الجديد يجب أن يكون **تكوينًا فوق بنية مشتركة** قدر الإمكان، وليس نسخة جديدة من نفس header/items/totals logic.

## 1.3 Definition of Ready لأي Sprint

قبل بدء أي Sprint:

- [ ] Sprint السابق أغلق Exit Gate.
- [ ] جميع failing tests المعروفة مصنفة ومقبولة أو مصلحة.
- [ ] لا توجد API decision أساسية معلقة تؤثر على Sprint.
- [ ] fixtures/sample data المطلوبة موجودة.
- [ ] public compatibility impact معروف.
- [ ] golden baselines المعنية محفوظة.
- [ ] لا توجد مهمة أساسية مخفية ضمن "refactor لاحقًا".

## 1.4 Definition of Done لأي Task

لا تعتبر Task مكتملة لمجرد أن الكود يعمل محليًا.

يلزم عند انطباقه:

- [ ] implementation.
- [ ] unit tests.
- [ ] golden/visual test.
- [ ] RTL/LTR test.
- [ ] null/optional test.
- [ ] long-content test.
- [ ] multi-page test.
- [ ] public API docs.
- [ ] example/update sample.
- [ ] إنشاء أو تحديث **Sprint Verification Example Screen** داخل `example/lib/features/dashboard/presentation/pages` لعرض ما تمت إضافته أو تطويره في الـ Sprint بصورة عملية.
- [ ] إضافة شاشة التحقق إلى Dashboard/navigation الخاصة بالـ example بحيث يمكن فتحها مباشرة.
- [ ] يجب أن تعرض شاشة التحقق الحالات الأساسية والحالات الحدّية المهمة، وليس happy path فقط.
- [ ] no analyzer errors.
- [ ] no regression في القوالب الحالية.
- [ ] لا يوجد duplicated business/layout logic غير مبرر.

## 1.5 Sprint Verification Example Screen — إلزامي في كل Sprint

الغرض من شاشة المثال ليس التوثيق فقط، بل أن تكون **Manual Acceptance Harness** يستطيع مالك المكتبة تشغيلها والتحقق بنفسه من أن المنطق والسلوك المرئي صحيحان قبل إغلاق الـ Sprint.

### الموقع الإلزامي

كل شاشة تحقق خاصة بالـ Sprint يجب أن توضع تحت:

```text
example/lib/features/dashboard/presentation/pages
```

ويجب تسجيلها في Dashboard/navigation الحالية الخاصة بتطبيق المثال بحيث يمكن الوصول إليها من الواجهة بدون تعديل الكود يدويًا.

### Naming

يفضل أن يكون الاسم واضحًا ويشير إلى الـ Sprint والميزة، مثل:

```text
s01_directionality_verification_page.dart
s02_components_rtl_verification_page.dart
s04_data_grid_verification_page.dart
s06_erp_domain_calculation_verification_page.dart
```

إذا كان للمشروع convention مختلف لأسماء الصفحات، يستخدم convention المشروع مع الحفاظ على وضوح الغرض.

### ما يجب أن تحتويه الشاشة

حسب طبيعة الـ Sprint، يجب أن تعرض الشاشة:

- السلوك القديم والسلوك الجديد جنبًا إلى جنب عندما تكون المقارنة مفيدة.
- الحالات الطبيعية.
- الحالات الحدّية.
- البيانات الاختيارية و`null`.
- المحتوى الطويل.
- multi-page أو large-data عند انطباقه.
- LTR.
- RTL.
- bilingual/mixed direction عندما يكون للمكون نصوص أو قيم.
- القيم الرقمية والمعرفات داخل RTL عند انطباقه.
- controls بسيطة لتغيير الحالات التي تساعد على التحقق، مثل direction، locale، print profile، row count، theme، أو sample scenario.
- زر/إجراء لتوليد أو Preview الـ PDF النهائي باستخدام implementation الحقيقي للمكتبة، لا mock منفصل.
- وصف مختصر داخل الشاشة لما يجب أن يراه المختبر في كل scenario.

### قاعدة مهمة

لا يجوز بناء implementation منفصل خصيصًا لشاشة المثال. يجب أن تستخدم الشاشة نفس public APIs/components/families التي سيستخدمها مستهلك المكتبة فعليًا.

### متطلبات الإغلاق

لا يغلق أي Sprint يضيف أو يغير behavior قابلًا للرؤية قبل:

- [ ] إنشاء/تحديث شاشة التحقق.
- [ ] إضافتها إلى Dashboard.
- [ ] إمكانية تشغيل جميع scenarios المطلوبة منها.
- [ ] التحقق من LTR/RTL عندما ينطبق.
- [ ] التحقق من null/edge cases عندما ينطبق.
- [ ] التحقق من PDF preview/output الفعلي.
- [ ] عدم وجود analyzer errors في example.
- [ ] توثيق Expected Result داخل الشاشة أو بجانب كل scenario بشكل مختصر.

> هذه الشاشة هي وسيلة **قبول يدوي Manual Acceptance** مكمّلة للاختبارات الآلية والـ golden tests، وليست بديلًا عنها.

## 1.6 Directionality Rule غير قابلة للتفاوض

الصور المرجعية أظهرت مشكلة مهمة: `Summary` الإنجليزي صحيح، لكن النسخة العربية تغيّر اتجاه النص دون أن تعكس **الترتيب المنطقي للـ layout**.

العقد الذي يجب الالتزام به في جميع الـ Sprints:

- `layoutDirection` مستقل عن `textDirection`.
- `textAlignment` مستقل عن كليهما.
- numeric/value runs يمكن أن تكون LTR داخل RTL.
- `start/end` و`leading/trailing` هي الأساس.
- لا يتم عكس strings يدويًا.
- لا يتم mirroring للصور أو QR أو barcode payload.
- كل component يرث direction من context ويقبل override.
- كل component يعرض أرقامًا/معرفات يملك mixed-BiDi tests.

---

# 2. Milestones

| Milestone | Sprints | النتيجة |
|---|---:|---|
| M0 — Directionality Safe | S00–S02 | جميع المكونات الأساسية صحيحة EN/AR/BiDi |
| M1 — PDF Foundation | S03–S09 | Layout + Grid + Formatting + Domain + Families + migration |
| M2 — Core ERP Coverage | S10–S17 | القوالب الحالية + Sales/Purchasing/Accounting/Inventory/POS/HR |
| M3 — Advanced ERP | S18–S21 | Manufacturing/Quality/Assets/Projects/Service/Logistics/CRM |
| M4 — Enterprise | S22–S24 | Engine vNext + compliance + hardening |
| M5 — Customization | S25–S26 | Designer + industry packs |

---

# 3. Sprints

# 3.1 قاعدة إلزامية مشتركة لكل Sprints

بالإضافة إلى Tasks الخاصة بكل Sprint، تعتبر البنود التالية جزءًا من **Exit Gate لكل Sprint دون استثناء**:

- [ ] توجد شاشة Manual Verification مناسبة داخل `example/lib/features/dashboard/presentation/pages`.
- [ ] الشاشة مضافة إلى Dashboard/navigation ويمكن الوصول إليها من تطبيق المثال.
- [ ] الشاشة تعرض الميزات/التعديلات المنفذة في ذلك الـ Sprint، لا مجرد صفحة تعريفية.
- [ ] السيناريوهات تعطي المستخدم وسيلة واضحة للتحقق من صحة المنطق والسلوك البصري.
- [ ] تستخدم الشاشة API الحقيقي للمكتبة.
- [ ] Expected Result موضح للحالات المهمة.
- [ ] إذا تغير rendering، يمكن توليد/معاينة PDF من الشاشة.
- [ ] إذا كان للميزة علاقة بالاتجاه، تتضمن الشاشة LTR وRTL وmixed-direction.
- [ ] إذا كان للميزة علاقة بالبيانات، تتضمن الشاشة normal/null/edge/long-data scenarios المناسبة.
- [ ] لا يغني نجاح الشاشة عن unit/golden/semantic tests، ولا تغني الاختبارات عن المراجعة اليدوية من الشاشة.

---

# S00 — Baseline, Regression Harness & Directionality Bug Capture

**Priority:** P0 / Blocker  
**Dependencies:** None

## Goal

تثبيت الوضع الحالي وإنشاء اختبارات تفشل بوضوح على مشكلة RTL الحالية قبل تغيير الـ implementation.

## A — Baseline

- [x] **S00-T01** — حصر public APIs الحالية للمكونات: Summary, InfoBox, ReportHeader, RichText, DataGrid, SignatureArea, QR/Barcode, Watermark.
- [x] **S00-T02** — توليد PDFs مرجعية للحالات EN/LTR وAR/RTL وbilingual.
- [x] **S00-T03** — حفظ screenshots/goldens لمخرجات `Summary` الإنجليزية والعربية الحالية.
- [x] **S00-T04** — تسجيل السلوك الحالي للقوالب الثلاثة: Quotation, PurchaseOrder, TaxInvoice.
- [x] **S00-T05** — تسجيل عدد الصفحات والأبعاد الأساسية للقوالب الحالية لمنع regressions غير المقصودة.

## B — Directionality fixtures

- [x] **S00-T06** — إنشاء fixture إنجليزي LTR.
- [x] **S00-T07** — إنشاء fixture عربي RTL.
- [x] **S00-T08** — إنشاء fixture bilingual يحتوي Arabic label + English value.
- [x] **S00-T09** — إضافة money values بصيغة `13,650.00 SAR` و`15,697.50 SAR`.
- [x] **S00-T10** — إضافة document numbers, SKU, serial, IBAN, phone, email, URL لاختبار BiDi.
- [x] **S00-T11** — إضافة long Arabic text وlong English text لاختبار wrapping.
- [x] **S00-T12** — إضافة null/empty values لاختبار collapse.

## C — Failing regression tests

- [x] **S00-T13** — إضافة test يثبت أن Summary RTL يجب أن يضع label في logical start والـ amount في logical end.
- [x] **S00-T14** — إضافة test يثبت أن amount نفسه لا ينعكس في RTL.
- [x] **S00-T15** — إضافة test لـ InfoBox key/value mirroring.
- [x] **S00-T16** — إضافة test لـ leading/trailing icon positions.
- [x] **S00-T17** — إضافة test يثبت أن QR/Barcode payload لا يتغير بسبب RTL.
- [x] **S00-T18** — إضافة test لـ nested direction override.

## D — Tooling

- [x] **S00-T19** — توحيد helper لتوليد PDF test artifact.
- [x] **S00-T20** — توحيد helper لرندر الصفحة إلى صورة للاختبارات المرئية.
- [x] **S00-T21** — توحيد naming للـ golden files حسب component/locale/direction/case.
- [x] **S00-T22** — إضافة طريقة واضحة لتحديث golden baseline عمدًا فقط.
- [x] **S00-T23** — توثيق known failures قبل بدء S01.

## Manual Verification Example

- [x] **S00-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S00-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S00-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S00-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S00-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Directionality fixture matrix.
- [x] Golden baseline للمكونات الحالية.
- [x] Tests تعيد إنتاج مشكلة Summary/InfoBox العربية.
- [x] وثيقة قصيرة داخل tests تشرح كيفية اعتماد أو رفض golden changes.

## Exit Gate

- [x] يمكن إعادة إنتاج خطأ Summary العربي آليًا.
- [x] لا يوجد تغيير وظيفي مقصود في هذه الـ Sprint.
- [x] كل golden له اسم واضح وسيناريو معروف.
- [x] تم فصل failing RTL regressions عن أي failures غير متعلقة.

## Not in scope

- إصلاح RTL نفسه.
- إعادة تصميم القوالب.
- إضافة ERP templates جديدة.

---

# S01 — Directionality Core & Logical Layout Primitives

**Priority:** P0 / Blocker  
**Dependencies:** S00

## Goal

بناء مصدر حقيقة واحد لاتجاه المستند والعناصر بدل أن يقرر كل component الاتجاه بطريقته.

## A — Public abstractions

- [x] **S01-T01** — إضافة package-owned direction enum يدعم `auto/ltr/rtl`.
- [x] **S01-T02** — إضافة `GeniusPdfDirectionality` context.
- [x] **S01-T03** — إضافة `GeniusPdfDirectionResolver`.
- [x] **S01-T04** — تعريف precedence: element > component > template > document > locale.
- [x] **S01-T05** — تعريف value-direction policy للأرقام والعملات والمعرفات.
- [x] **S01-T06** — عدم تسريب Syncfusion-specific direction types في stable API الجديد.

## B — Logical geometry

- [x] **S01-T07** — إضافة logical alignment: start/end/center.
- [x] **S01-T08** — إضافة directional insets: start/end/top/bottom.
- [x] **S01-T09** — إضافة leading/trailing position semantics.
- [x] **S01-T10** — إنشاء helpers لتحويل logical geometry إلى physical coordinates وقت الرسم فقط.
- [x] **S01-T11** — منع استخدام left/right في APIs الجديدة عندما تكون الدلالة منطقية.

## C — BiDi value handling

- [x] **S01-T12** — إنشاء policy للقيم الرقمية لتبقى LTR داخل RTL.
- [x] **S01-T13** — تغطية money, percentage, quantity, dates, times.
- [x] **S01-T14** — تغطية document number, SKU, serial, batch, IBAN, SWIFT, tax ID.
- [x] **S01-T15** — تغطية phone, email, URL.
- [x] **S01-T16** — منع أي implementation يستخدم reverse string لعلاج RTL.
- [x] **S01-T17** — إضافة isolation/run-direction abstraction للنص المختلط.

## D — Propagation

- [x] **S01-T18** — تمرير directionality إلى GeniusPdfDocumentBuilder.
- [x] **S01-T19** — تمرير directionality إلى GeniusPdfReportComposer.
- [x] **S01-T20** — إتاحة direction override للـ custom/component blocks.
- [x] **S01-T21** — تحديد direction داخل TemplateDefinition/page settings أو context بدون كسر JSON القديم.
- [x] **S01-T22** — ضمان inheritance للـ nested content.

## E — Tests

- [x] **S01-T23** — Unit tests لكل resolver precedence.
- [x] **S01-T24** — Unit tests لتحويل start/end في LTR وRTL.
- [x] **S01-T25** — Unit tests للـ numeric value direction.
- [x] **S01-T26** — Tests لقيم mixed Arabic/Latin.
- [x] **S01-T27** — Tests لـ nested overrides.
- [x] **S01-T28** — Tests لمنع accidental image mirroring.

## Manual Verification Example

- [x] **S01-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S01-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S01-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S01-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S01-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Directionality core API.
- [x] Logical geometry helpers.
- [x] BiDi value policy.
- [x] Builder/Composer propagation.
- [x] Unit test suite.

## Exit Gate

- [x] كل اختبار resolver وlogical geometry يمر.
- [x] لا يوجد component جديد يحتاج قراءة locale مباشرة لتحديد اتجاهه.
- [x] الأرقام/العملات/IDs لا تتغير قيمتها النصية بين LTR وRTL.
- [x] stable API لا يفرض Syncfusion direction type على المستهلك.

## Not in scope

- إصلاح كل components؛ يتم في S02.
- DataGrid redesign.
- Template Engine expressions.

---

# S02 — Directionality Migration for Existing Components

**Priority:** P0 / Blocker  
**Dependencies:** S01

## Goal

إصلاح Summary وInfoBox وباقي المكونات بحيث يكون RTL صحيحًا هندسيًا ونصيًا، لا مجرد text alignment.

## A — Summary

- [x] **S02-T01** — تحويل label/value layout إلى logical start/end.
- [x] **S02-T02** — في RTL: label يمين، value يسار.
- [x] **S02-T03** — الحفاظ على amount/currency run باتجاه LTR افتراضيًا.
- [x] **S02-T04** — تطبيق direction على subtotal/tax/discount/charges/grand total.
- [x] **S02-T05** — اختبار long labels وwrapping.
- [x] **S02-T06** — اختبار negative amounts وpercentages.
- [x] **S02-T07** — اختبار optional rows بدون gaps.

## B — InfoBox

- [x] **S02-T08** — عكس key/value row منطقيًا.
- [x] **S02-T09** — تحويل icon placement إلى leading/trailing.
- [x] **S02-T10** — عكس multi-column order عند followDirection.
- [x] **S02-T11** — دعم valueDirection مستقل لكل field.
- [x] **S02-T12** — اختبار nested content.
- [x] **S02-T13** — اختبار title/subtitle في mixed language.

## C — ReportHeader & two-column layout

- [x] **S02-T14** — عكس company/document blocks منطقيًا.
- [x] **S02-T15** — تطبيق leading/trailing على logo وmetadata.
- [x] **S02-T16** — إبقاء document numbers/dates مستقرة بصريًا.
- [x] **S02-T17** — جعل two-column layout direction-aware.
- [x] **S02-T18** — إضافة preservePhysicalOrder عند الحاجة.

## D — RichText

- [x] **S02-T19** — تمرير run direction.
- [x] **S02-T20** — اختبار Arabic + Latin + punctuation.
- [x] **S02-T21** — اختبار IDs داخل Arabic sentence.
- [x] **S02-T22** — اختبار line wrapping مع mixed runs.

## E — DataGrid directionality only

- [x] **S02-T23** — إضافة `followDirection` و`preserveDefinitionOrder` لسياسة ترتيب الأعمدة.
- [x] **S02-T24** — دعم headerDirection وcontentDirection لكل عمود.
- [x] **S02-T25** — تحويل cell padding إلى logical padding.
- [x] **S02-T26** — تثبيت numeric alignment/value direction.
- [x] **S02-T27** — عدم تنفيذ advanced grid features المؤجلة إلى S04.

## F — Signature/Barcode/QR/Watermark

- [x] **S02-T28** — عكس signer blocks منطقيًا.
- [x] **S02-T29** — عدم عكس signature image.
- [x] **S02-T30** — عدم عكس QR أو barcode graphics/payload.
- [x] **S02-T31** — جعل captions direction-aware.
- [x] **S02-T32** — إضافة logical watermark/stamp placement دون تغيير physical mode.

## G — Examples/docs/goldens

- [x] **S02-T33** — تحديث أمثلة Summary وInfoBox بالعربية والإنجليزية.
- [x] **S02-T34** — إضافة صفحة/مثال Directionality Components Matrix.
- [x] **S02-T35** — تحديث docs بعقد direction inheritance/override.
- [x] **S02-T36** — اعتماد goldens الجديدة فقط بعد المراجعة البصرية.
- [x] **S02-T37** — إغلاق regression tests التي أنشئت في S00.

## Manual Verification Example

- [x] **S02-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S02-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S02-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S02-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S02-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Summary RTL مصحح.
- [x] InfoBox RTL مصحح.
- [x] ReportHeader/RichText/Grid/Signature/QR/Barcode direction-aware.
- [x] Directionality example matrix.
- [x] Updated golden baselines.

## Exit Gate

- [x] الصورة العربية المناظرة للـ Summary تضع label في اليمين والamount في اليسار.
- [x] قيمة `15,697.50 SAR` تبقى مرتبة وقابلة للقراءة داخل RTL.
- [x] كل component أساسي يملك EN/LTR وAR/RTL golden.
- [x] لا يوجد accidental mirroring للصور أو QR/barcodes.
- [x] bilingual nested blocks تعمل بدون تغيير direction للمستند كله.

## Not in scope

- Advanced grouping/pagination للـ DataGrid.
- ERP shared domain.
- قوالب جديدة.

---

# S03 — Flow Layout, Blocks, Bands & Pagination Engine

**Priority:** P0  
**Dependencies:** S02

## Goal

تحويل page flow من checks متفرقة إلى abstraction يمكن الاعتماد عليه في مستندات ERP الطويلة.

## A — Core layout model

- [x] **S03-T01** — تعريف `PdfBlock` abstraction.
- [x] **S03-T02** — تعريف `PdfBand` abstraction.
- [x] **S03-T03** — تعريف `PdfFlowSection`.
- [x] **S03-T04** — تعريف `PdfKeepTogether`.
- [x] **S03-T05** — تعريف `PdfRepeatableBand`.
- [x] **S03-T06** — تعريف `PdfPageBreakPolicy`.

## B — Pagination rules

- [x] **S03-T07** — keepTogether.
- [x] **S03-T08** — keepWithNext.
- [x] **S03-T09** — pageBreakBefore.
- [x] **S03-T10** — pageBreakAfter.
- [x] **S03-T11** — conditional page break.
- [x] **S03-T12** — orphan/widow protection للنصوص والقوائم عند الإمكان.
- [x] **S03-T13** — repeat section/group headers.
- [x] **S03-T14** — repeat table headers/footers.
- [x] **S03-T15** — section-level landscape/custom size.

## C — Measurement

- [x] **S03-T16** — إضافة measurement contract قبل الرسم عند الحاجة.
- [x] **S03-T17** — دعم two-pass layout للمكونات التي تحتاج page count أو قرار break مسبق.
- [x] **S03-T18** — عدم تكرار heavy rendering أثناء القياس.
- [x] **S03-T19** — إضافة predictable currentY updates.

## D — Header/footer/page metadata

- [x] **S03-T20** — توحيد حجز header/footer.
- [x] **S03-T21** — دعم Page X of Y.
- [x] **S03-T22** — دعم first-page header variant.
- [x] **S03-T23** — دعم last-page/footer variant.
- [x] **S03-T24** — دعم document status/original-copy marker bands.

## E — Compatibility

- [x] **S03-T25** — الإبقاء على current builder methods.
- [x] **S03-T26** — توفير adapters من APIs القديمة إلى blocks الجديدة.
- [x] **S03-T27** — عدم كسر custom callbacks الحالية.
- [x] **S03-T28** — توثيق deprecated paths فقط إذا كان البديل مستقرًا.

## F — Tests

- [x] **S03-T29** — 1-page document.
- [x] **S03-T30** — multi-page 50 rows.
- [x] **S03-T31** — 500-row stress layout.
- [x] **S03-T32** — very long notes.
- [x] **S03-T33** — keepTogether near page end.
- [x] **S03-T34** — repeated headers.
- [x] **S03-T35** — RTL/LTR pagination parity.
- [x] **S03-T36** — custom page size.

## Manual Verification Example

- [x] **S03-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S03-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S03-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S03-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S03-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Block/Band/Flow API.
- [x] Pagination policies.
- [x] Page metadata support.
- [x] Compatibility layer.
- [x] Layout test suite.

## Exit Gate

- [x] لا clipping/overlap في اختبارات long/multi-page.
- [x] لا يتغير page flow باختلاف RTL/LTR إلا بسبب المحتوى الفعلي.
- [x] Page X of Y صحيح.
- [x] الـ builder القديم يبقى صالحًا.

---

# S04 — DataGrid vNext for ERP Reports

**Priority:** P0  
**Dependencies:** S03

## Goal

جعل DataGrid قادرًا على تغطية الجداول المالية والمخزنية والكشوف الطويلة بدون نسخ implementations.

## A — Column sizing

- [ ] **S04-T01** — fixed width.
- [ ] **S04-T02** — weighted/flex width.
- [ ] **S04-T03** — min/max width.
- [ ] **S04-T04** — auto-fit.
- [ ] **S04-T05** — text wrapping.
- [ ] **S04-T06** — ellipsis/clip policies.
- [ ] **S04-T07** — decimal/numeric alignment.

## B — Pagination

- [ ] **S04-T08** — repeated headers.
- [ ] **S04-T09** — keepRowTogether.
- [ ] **S04-T10** — controlled row split policy.
- [ ] **S04-T11** — group header repetition.
- [ ] **S04-T12** — group footer/subtotal placement.
- [ ] **S04-T13** — grand total placement.

## C — Grouping

- [ ] **S04-T14** — group headers.
- [ ] **S04-T15** — group footers.
- [ ] **S04-T16** — subtotals.
- [ ] **S04-T17** — grand totals.
- [ ] **S04-T18** — nested groups.
- [ ] **S04-T19** — tree/hierarchical indentation.
- [ ] **S04-T20** — summary expressions contract.

## D — Cell structure

- [ ] **S04-T21** — row span.
- [ ] **S04-T22** — column span.
- [ ] **S04-T23** — conditional row style.
- [ ] **S04-T24** — conditional cell style.
- [ ] **S04-T25** — row builder.
- [ ] **S04-T26** — cell builder.
- [ ] **S04-T27** — empty state.

## E — ERP format integration

- [ ] **S04-T28** — money formatter hook.
- [ ] **S04-T29** — percentage formatter hook.
- [ ] **S04-T30** — quantity formatter hook.
- [ ] **S04-T31** — date/time formatter hook.
- [ ] **S04-T32** — debit/credit semantic style.
- [ ] **S04-T33** — negative accounting values.
- [ ] **S04-T34** — multi-currency display.

## F — Directionality

- [ ] **S04-T35** — تثبيت followDirection/preserveDefinitionOrder.
- [ ] **S04-T36** — per-column direction.
- [ ] **S04-T37** — RTL grouping indentation.
- [ ] **S04-T38** — RTL header/cell padding.
- [ ] **S04-T39** — mixed numeric/text rows.

## G — Performance

- [ ] **S04-T40** — very-large-data mode.
- [ ] **S04-T41** — lazy row preparation where possible.
- [ ] **S04-T42** — cache measured widths.
- [ ] **S04-T43** — avoid rebuilding repeated styles.
- [ ] **S04-T44** — benchmark 1k/10k rows حسب حدود البيئة.

## Manual Verification Example

- [ ] **S04-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S04-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S04-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S04-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S04-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Advanced DataGrid.
- [ ] ERP formatter hooks.
- [ ] Grouping/subtotals.
- [ ] Large-data benchmark.

## Exit Gate

- [ ] الجداول المالية والمخزنية لا تحتاج custom renderer للحالات الأساسية.
- [ ] RTL column order وnumeric rendering صحيحان.
- [ ] repeated headers تعمل على multi-page.
- [ ] لا overlap في long wrapped cells.
- [ ] benchmark baseline موثق.

---

# S05 — Formatting Engine & Design Tokens

**Priority:** P0  
**Dependencies:** S04

## Goal

توحيد طريقة عرض الأرقام والتواريخ والعملات والوحدات، ثم توحيد المظهر بدون hardcoded styling داخل القوالب.

## A — Formatting API

- [ ] **S05-T01** — إضافة `GeniusPdfFormatter` contract.
- [ ] **S05-T02** — money formatter.
- [ ] **S05-T03** — number formatter.
- [ ] **S05-T04** — quantity formatter.
- [ ] **S05-T05** — percentage formatter.
- [ ] **S05-T06** — date formatter.
- [ ] **S05-T07** — time formatter.
- [ ] **S05-T08** — identifier formatter.
- [ ] **S05-T09** — null placeholder policy.

## B — Locale & accounting

- [ ] **S05-T10** — locale-aware separators.
- [ ] **S05-T11** — decimal precision rules.
- [ ] **S05-T12** — currency code/symbol policy.
- [ ] **S05-T13** — accounting negative format.
- [ ] **S05-T14** — Arabic/English digit policy.
- [ ] **S05-T15** — exchange rate formatting.
- [ ] **S05-T16** — unit formatting.

## C — Theme

- [ ] **S05-T17** — إضافة `GeniusPdfTheme`.
- [ ] **S05-T18** — typography tokens.
- [ ] **S05-T19** — spacing tokens.
- [ ] **S05-T20** — border tokens.
- [ ] **S05-T21** — table theme.
- [ ] **S05-T22** — document theme.
- [ ] **S05-T23** — semantic colors.
- [ ] **S05-T24** — summary/highlight styles.

## D — Directionality-aware styling

- [ ] **S05-T25** — logical spacing tokens.
- [ ] **S05-T26** — leading/trailing borders عندما يكون ذلك semantic.
- [ ] **S05-T27** — RTL/LTR typography alignment defaults.
- [ ] **S05-T28** — عدم ربط اللون أو الوزن بالاتجاه.

## E — Migration

- [ ] **S05-T29** — إزالة format snippets المكررة من components الأساسية.
- [ ] **S05-T30** — إزالة hardcoded amount strings من examples.
- [ ] **S05-T31** — توصيل DataGrid وSummary بالـ formatter/theme.
- [ ] **S05-T32** — توفير backward-compatible defaults.

## F — Tests/docs

- [ ] **S05-T33** — goldens لعملات متعددة.
- [ ] **S05-T34** — اختبارات decimal precision.
- [ ] **S05-T35** — اختبارات negative/accounting formats.
- [ ] **S05-T36** — اختبارات Arabic digits policy.
- [ ] **S05-T37** — توثيق أمثلة formatter/theme.

## Manual Verification Example

- [ ] **S05-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S05-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S05-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S05-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S05-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Formatting engine.
- [ ] Theme/design token model.
- [ ] Component integration.
- [ ] Formatting test matrix.

## Exit Gate

- [ ] نفس القيمة تُنسق من مصدر واحد في Summary/Grid/InfoBox.
- [ ] لا يوجد اختلاف غير مقصود في separators/precision بين المكونات.
- [ ] RTL لا يفسد money/identifier formatting.
- [ ] التخصيص عبر theme لا يتطلب تعديل template source.

---

# S06 — ERP Shared Domain & Calculation Layer

**Priority:** P0  
**Dependencies:** S05

## Goal

إنشاء model موحد تستعمله عائلات القوالب بدل امتلاك كل قالب بياناته وحساباته الخاصة.

## A — Context & identity

- [ ] **S06-T01** — `ErpDocumentContext`.
- [ ] **S06-T02** — `ErpOrganization`.
- [ ] **S06-T03** — `ErpBranch`.
- [ ] **S06-T04** — `ErpDocumentIdentity`.
- [ ] **S06-T05** — `ErpDocumentReference`.
- [ ] **S06-T06** — `ErpPrintMetadata`.
- [ ] **S06-T07** — `ErpDocumentStatus`.

## B — Parties & addresses

- [ ] **S06-T08** — `ErpParty`.
- [ ] **S06-T09** — `ErpAddress`.
- [ ] **S06-T10** — `ErpTaxIdentity`.
- [ ] **S06-T11** — optional contact metadata.
- [ ] **S06-T12** — billing/shipping/address roles.

## C — Monetary model

- [ ] **S06-T13** — `ErpMoney`.
- [ ] **S06-T14** — `ErpCurrency`.
- [ ] **S06-T15** — `ErpExchangeRate`.
- [ ] **S06-T16** — rounding strategy.
- [ ] **S06-T17** — currency precision.
- [ ] **S06-T18** — base/document currency separation.

## D — Transaction details

- [ ] **S06-T19** — `ErpQuantity`.
- [ ] **S06-T20** — `ErpUnit`.
- [ ] **S06-T21** — `ErpLineItem`.
- [ ] **S06-T22** — `ErpTaxLine`.
- [ ] **S06-T23** — `ErpDiscount`.
- [ ] **S06-T24** — `ErpCharge`.
- [ ] **S06-T25** — `ErpBatchInfo`.
- [ ] **S06-T26** — `ErpSerialInfo`.

## E — Approval & attachment

- [ ] **S06-T27** — `ErpApproval`.
- [ ] **S06-T28** — `ErpSignature`.
- [ ] **S06-T29** — `ErpAttachment`.

## F — Calculation service

- [ ] **S06-T30** — subtotal calculation.
- [ ] **S06-T31** — line discount.
- [ ] **S06-T32** — document discount.
- [ ] **S06-T33** — charges.
- [ ] **S06-T34** — taxable amount.
- [ ] **S06-T35** — tax totals.
- [ ] **S06-T36** — grand total.
- [ ] **S06-T37** — rounding adjustment.
- [ ] **S06-T38** — paid/due where applicable.
- [ ] **S06-T39** — multi-currency conversion contract.

## G — Validation/tests

- [ ] **S06-T40** — immutable/value semantics where appropriate.
- [ ] **S06-T41** — input validation.
- [ ] **S06-T42** — rounding edge cases.
- [ ] **S06-T43** — zero/negative lines where allowed.
- [ ] **S06-T44** — multi-tax scenarios.
- [ ] **S06-T45** — discount-before/after-tax policies عبر explicit configuration.
- [ ] **S06-T46** — serialization only where needed; لا تفرض JSON على domain بلا سبب.

## Manual Verification Example

- [ ] **S06-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S06-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S06-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S06-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S06-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] ERP shared domain package layer.
- [ ] Typed calculation service.
- [ ] Comprehensive calculation tests.

## Exit Gate

- [ ] Quotation/PO/Invoice يمكن تمثيل بياناتها بدون models مخصصة مكررة.
- [ ] الحسابات لا تعتمد على UI/template.
- [ ] rounding/tax tests deterministic.
- [ ] null optional metadata لا يخلق dummy values.

---

# S07 — Reusable ERP Document Components

**Priority:** P0  
**Dependencies:** S06

## Goal

بناء مكونات دلالية عالية المستوى تستخدم domain + formatter + directionality.

## A — Identity & party

- [ ] **S07-T01** — `GeniusPdfDocumentIdentity`.
- [ ] **S07-T02** — `GeniusPdfPartyBlock`.
- [ ] **S07-T03** — `GeniusPdfAddressBlock`.
- [ ] **S07-T04** — `GeniusPdfReferenceBlock`.

## B — Financial

- [ ] **S07-T05** — `GeniusPdfMoney`.
- [ ] **S07-T06** — `GeniusPdfAmountInWords`.
- [ ] **S07-T07** — `GeniusPdfTaxSummary`.
- [ ] **S07-T08** — discount/charge summary block.
- [ ] **S07-T09** — balance/due block.

## C — Operational

- [ ] **S07-T10** — `GeniusPdfTermsSection`.
- [ ] **S07-T11** — `GeniusPdfApprovalTrail`.
- [ ] **S07-T12** — `GeniusPdfStamp`.
- [ ] **S07-T13** — `GeniusPdfMetricCards`.
- [ ] **S07-T14** — `GeniusPdfLabel`.

## D — Optional sections

- [ ] **S07-T15** — كل component يقبل null data حيث منطقي.
- [ ] **S07-T16** — null section collapses بالكامل.
- [ ] **S07-T17** — لا padding/margin متبقٍ بعد hidden section.
- [ ] **S07-T18** — empty lists لها policy واضحة: hide أو empty state.

## E — Directionality

- [ ] **S07-T19** — كل component يستخدم start/end.
- [ ] **S07-T20** — كل value run يملك direction مناسب.
- [ ] **S07-T21** — EN/AR/bilingual examples.
- [ ] **S07-T22** — mixed address/phone/ID tests.

## F — Docs

- [ ] **S07-T23** — Flutter-style API docs.
- [ ] **S07-T24** — usage examples.
- [ ] **S07-T25** — composition examples.
- [ ] **S07-T26** — do/don't guidance لمنع layout duplication.

## Manual Verification Example

- [ ] **S07-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S07-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S07-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S07-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S07-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] ERP semantic component library.
- [ ] Null-collapse behavior.
- [ ] Directionality goldens.
- [ ] Component documentation.

## Exit Gate

- [ ] قالب ERP جديد لا يحتاج إعادة بناء party/identity/tax/terms من الصفر.
- [ ] كل component يمر LTR/RTL/bilingual tests.
- [ ] null sections لا تترك gaps.

---

# S08 — Generic ERP Document Families

**Priority:** P0  
**Dependencies:** S07

## Goal

إنشاء عائلات عامة تشكل الهيكل المشترك للمستندات بدلاً من template class مستقل لكل حالة.

## A — Families

- [ ] **S08-T01** — `GeniusErpTransactionDocument`.
- [ ] **S08-T02** — `GeniusErpStatementDocument`.
- [ ] **S08-T03** — `GeniusErpVoucherDocument`.
- [ ] **S08-T04** — `GeniusErpAnalyticalReport`.
- [ ] **S08-T05** — `GeniusErpOperationalForm`.
- [ ] **S08-T06** — `GeniusErpRegisterDocument`.
- [ ] **S08-T07** — `GeniusErpThermalReceipt`.
- [ ] **S08-T08** — `GeniusErpLabelDocument`.
- [ ] **S08-T09** — `GeniusErpCertificateDocument`.

## B — Slots/sections

- [ ] **S08-T10** — header slot.
- [ ] **S08-T11** — document identity slot.
- [ ] **S08-T12** — party slots.
- [ ] **S08-T13** — reference slots.
- [ ] **S08-T14** — line-items/body slot.
- [ ] **S08-T15** — summary slot.
- [ ] **S08-T16** — notes/terms slot.
- [ ] **S08-T17** — approval/signature slot.
- [ ] **S08-T18** — attachments/QR/barcode slot.
- [ ] **S08-T19** — footer slot.

## C — Policies

- [ ] **S08-T20** — optional section collapse.
- [ ] **S08-T21** — page break policy per slot.
- [ ] **S08-T22** — first/last page variants.
- [ ] **S08-T23** — direction override per slot.
- [ ] **S08-T24** — theme override per family.
- [ ] **S08-T25** — print profile hook.

## D — Extension model

- [ ] **S08-T26** — custom section insertion.
- [ ] **S08-T27** — before/after hooks without exposing renderer internals.
- [ ] **S08-T28** — component replacement.
- [ ] **S08-T29** — data adapter layer.
- [ ] **S08-T30** — عدم ربط family بmodule واحد.

## E — Tests/examples

- [ ] **S08-T31** — minimal transaction.
- [ ] **S08-T32** — full transaction.
- [ ] **S08-T33** — statement.
- [ ] **S08-T34** — voucher.
- [ ] **S08-T35** — analytical report.
- [ ] **S08-T36** — RTL/bilingual family examples.
- [ ] **S08-T37** — multi-page family examples.

## Manual Verification Example

- [ ] **S08-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S08-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S08-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S08-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S08-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Generic document family layer.
- [ ] Extension/slot contract.
- [ ] Examples for each family.

## Exit Gate

- [ ] يمكن بناء مستندات متعددة بدون نسخ الهيكل العام.
- [ ] القوالب تبقى optional convenience layer.
- [ ] كل family direction-aware وpage-flow aware.

---

# S09 — Migrate Quotation, Purchase Order & Tax Invoice

**Priority:** P0  
**Dependencies:** S08

## Goal

إثبات نجاح الأساس الجديد عبر نقل أهم ثلاثة قوالب حالية مع الحفاظ على public behavior.

## A — Quotation

- [ ] **S09-T01** — تحويله إلى Transaction family.
- [ ] **S09-T02** — استخدام shared identity/party/items/summary/terms/signatures.
- [ ] **S09-T03** — إزالة الحسابات المكررة لصالح calculation layer.
- [ ] **S09-T04** — الحفاظ على QR والnotes والterms.

## B — Purchase Order

- [ ] **S09-T05** — تحويل vendor/order details إلى shared components.
- [ ] **S09-T06** — تحويل items/summary إلى shared implementation.
- [ ] **S09-T07** — الحفاظ على shipping/notes/terms/signatures.
- [ ] **S09-T08** — عدم كسر constructor/public API إن أمكن.

## C — Tax Invoice

- [ ] **S09-T09** — تحويل header/info/items/tax summary إلى shared components.
- [ ] **S09-T10** — الحفاظ على amount-in-words.
- [ ] **S09-T11** — الحفاظ على VAT details وQR.
- [ ] **S09-T12** — التأكد من bilingual/RTL correctness.

## D — Compatibility

- [ ] **S09-T13** — Adapters للـ legacy models إن لزم.
- [ ] **S09-T14** — deprecation فقط عند وجود بديل واضح.
- [ ] **S09-T15** — عدم تغيير output الحسابي.
- [ ] **S09-T16** — توثيق أي intentional visual difference ناتج عن إصلاح RTL.

## E — Duplication audit

- [ ] **S09-T17** — قياس duplicated code قبل/بعد.
- [ ] **S09-T18** — إزالة helpers الخاصة بالقالب إذا أصبحت shared.
- [ ] **S09-T19** — منع local formatting/calculation duplicates.

## F — Goldens

- [ ] **S09-T20** — EN/LTR لكل قالب.
- [ ] **S09-T21** — AR/RTL لكل قالب.
- [ ] **S09-T22** — bilingual where supported.
- [ ] **S09-T23** — 1/50/500 line scenarios.
- [ ] **S09-T24** — long notes/party names.
- [ ] **S09-T25** — null optional sections.

## Manual Verification Example

- [ ] **S09-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S09-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S09-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S09-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S09-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] 3 migrated templates.
- [ ] Compatibility adapters.
- [ ] Golden comparison report.
- [ ] Duplication audit.

## Exit Gate

- [ ] القوالب الثلاثة تعمل فوق نفس Transaction family.
- [ ] لا فقد وظيفي.
- [ ] Summary العربي صحيح في جميعها.
- [ ] لا يوجد header/party/items/totals duplication جوهري بينها.
- [ ] الحسابات مطابقة للاختبارات.

---

# S10 — Consolidate Existing Templates & Voucher Family

**Priority:** P1  
**Dependencies:** S09

## Goal

نقل بقية القوالب الحالية إلى العائلات المشتركة قبل إضافة packs جديدة.

## A — Financial reports

- [ ] **S10-T01** — Balance Sheet.
- [ ] **S10-T02** — Budget Report.
- [ ] **S10-T03** — Cash Flow.
- [ ] **S10-T04** — Income Statement.
- [ ] **S10-T05** — Trial Balance.
- [ ] **S10-T06** — Customer Statement.

## B — HR/current operational

- [ ] **S10-T07** — Attendance Report.
- [ ] **S10-T08** — Employee Report.
- [ ] **S10-T09** — Leave Report.
- [ ] **S10-T10** — Payslip.

## C — Inventory/delivery

- [ ] **S10-T11** — Inventory Report.
- [ ] **S10-T12** — Delivery Note.

## D — Voucher consolidation

- [ ] **S10-T13** — Accounting Entry Voucher.
- [ ] **S10-T14** — Bank Deposit Voucher.
- [ ] **S10-T15** — Bank Withdrawal Voucher.
- [ ] **S10-T16** — Bill Payment Voucher.
- [ ] **S10-T17** — Gift Voucher.
- [ ] **S10-T18** — Inventory Voucher.
- [ ] **S10-T19** — Modern Voucher.
- [ ] **S10-T20** — Payment Voucher.
- [ ] **S10-T21** — Purchase Return Voucher.
- [ ] **S10-T22** — Purchase Voucher.
- [ ] **S10-T23** — Receipt Voucher.
- [ ] **S10-T24** — Incoming Remittance Voucher.
- [ ] **S10-T25** — Outgoing Remittance Voucher.
- [ ] **S10-T26** — Sales Return Voucher.
- [ ] **S10-T27** — Sales Voucher.
- [ ] **S10-T28** — Tax Voucher.
- [ ] **S10-T29** — Transfer Voucher.

## E — Voucher architecture

- [ ] **S10-T30** — توحيد account entries table.
- [ ] **S10-T31** — توحيد party/payment details.
- [ ] **S10-T32** — توحيد amount highlight.
- [ ] **S10-T33** — توحيد amount-in-words.
- [ ] **S10-T34** — توحيد signature/notes/footer/page border.
- [ ] **S10-T35** — الإبقاء على voucher-specific fields كconfiguration/extension.

## F — Cleanup

- [ ] **S10-T36** — إزالة duplicated private render helpers.
- [ ] **S10-T37** — تحديث template registry.
- [ ] **S10-T38** — تحديث examples.
- [ ] **S10-T39** — تحديث docs.
- [ ] **S10-T40** — goldens لكل template EN/AR حيث ينطبق.

## Manual Verification Example

- [ ] **S10-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S10-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S10-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S10-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S10-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] All current templates mapped to families.
- [ ] Unified voucher implementation.
- [ ] Updated template registry/examples/docs.

## Exit Gate

- [ ] لا يوجد template حالي خارج family بدون مبرر موثق.
- [ ] public APIs الحالية تعمل أو تملك migration واضحة.
- [ ] RTL/LTR goldens مستقرة.
- [ ] voucher common code مركزي.

---

# S11 — Print Profiles, Thermal & Labels Foundation

**Priority:** P1  
**Dependencies:** S10

## Goal

دعم واقع ERP خارج A4: thermal, labels, continuous paper, pre-printed forms.

## A — Print profiles

- [ ] **S11-T01** — A4 portrait.
- [ ] **S11-T02** — A4 landscape.
- [ ] **S11-T03** — A5.
- [ ] **S11-T04** — Letter.
- [ ] **S11-T05** — Legal.
- [ ] **S11-T06** — 58mm thermal.
- [ ] **S11-T07** — 80mm thermal.
- [ ] **S11-T08** — continuous paper.
- [ ] **S11-T09** — custom label.
- [ ] **S11-T10** — label sheet.
- [ ] **S11-T11** — pre-printed form.

## B — Profile properties

- [ ] **S11-T12** — page dimensions.
- [ ] **S11-T13** — margins.
- [ ] **S11-T14** — safe area.
- [ ] **S11-T15** — density.
- [ ] **S11-T16** — default font scale.
- [ ] **S11-T17** — header/footer policy.
- [ ] **S11-T18** — cut spacing.
- [ ] **S11-T19** — label gaps.
- [ ] **S11-T20** — copies/original-copy metadata.

## C — Thermal receipt engine

- [ ] **S11-T21** — compact typography.
- [ ] **S11-T22** — variable-height content.
- [ ] **S11-T23** — minimal margins.
- [ ] **S11-T24** — QR/barcode placement.
- [ ] **S11-T25** — receipt totals.
- [ ] **S11-T26** — cash/payment lines.
- [ ] **S11-T27** — RTL thermal layout.

## D — Labels

- [ ] **S11-T28** — single label.
- [ ] **S11-T29** — sheet grid.
- [ ] **S11-T30** — gap/bleed handling.
- [ ] **S11-T31** — barcode/QR.
- [ ] **S11-T32** — SKU/batch/serial/expiry.
- [ ] **S11-T33** — RTL/English captions.
- [ ] **S11-T34** — print calibration offsets.

## E — Pre-printed

- [ ] **S11-T35** — physical-coordinate opt-in.
- [ ] **S11-T36** — field anchor positions.
- [ ] **S11-T37** — no logical mirroring when profile explicitly requires physical placement.
- [ ] **S11-T38** — calibration test page.

## Manual Verification Example

- [ ] **S11-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S11-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S11-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S11-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S11-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] `GeniusPdfPrintProfile`.
- [ ] Thermal receipt foundation.
- [ ] Label foundation.
- [ ] Calibration example.

## Exit Gate

- [ ] نفس document data يمكن طباعتها وفق profiles مختلفة حيث منطقي.
- [ ] 58/80mm لا تحتوي clipping.
- [ ] RTL thermal/labels صحيحة.
- [ ] physical pre-printed mode موثق بوضوح.

---

# S12 — Sales ERP Pack

**Priority:** P1  
**Dependencies:** S11

## Goal

تغطية دورة المبيعات الأساسية والتحليلية فوق Transaction/Statement/Register families.

## A — Transaction documents

- [ ] **S12-T01** — Sales Order.
- [ ] **S12-T02** — Proforma Invoice.
- [ ] **S12-T03** — Simplified/POS Invoice.
- [ ] **S12-T04** — Debit Note.
- [ ] **S12-T05** — Sales Return Document.
- [ ] **S12-T06** — Customer Receipt.

## B — Fulfillment

- [ ] **S12-T07** — Picking List.
- [ ] **S12-T08** — Packing List.
- [ ] **S12-T09** — Backorder document/report.

## C — Statements/reports

- [ ] **S12-T10** — Customer Aging.
- [ ] **S12-T11** — Sales Register.
- [ ] **S12-T12** — Sales by Customer.
- [ ] **S12-T13** — Sales by Item.
- [ ] **S12-T14** — Sales by Salesperson.
- [ ] **S12-T15** — Price List.
- [ ] **S12-T16** — Commission Report.

## D — Shared behaviors

- [ ] **S12-T17** — discounts/charges/taxes.
- [ ] **S12-T18** — multi-currency.
- [ ] **S12-T19** — payment terms.
- [ ] **S12-T20** — shipping/delivery references.
- [ ] **S12-T21** — original/copy/reprint metadata.
- [ ] **S12-T22** — batch/serial fields عند الحاجة.

## E — QA

- [ ] **S12-T23** — EN/AR/bilingual.
- [ ] **S12-T24** — short/long orders.
- [ ] **S12-T25** — multi-page items.
- [ ] **S12-T26** — zero/negative return values.
- [ ] **S12-T27** — tax inclusive/exclusive configuration.
- [ ] **S12-T28** — null optional sections.

## Manual Verification Example

- [ ] **S12-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S12-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S12-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S12-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S12-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Sales template pack.
- [ ] Sales examples.
- [ ] Sales golden matrix.

## Exit Gate

- [ ] كل Sales template يستخدم families/components المشتركة.
- [ ] لا توجد calculations داخل template rendering.
- [ ] RTL Summary/Info/Grid صحيحة.
- [ ] register/aging outputs قابلة للاختبار الحسابي.

---

# S13 — Purchasing ERP Pack

**Priority:** P1  
**Dependencies:** S12

## Goal

تغطية دورة المشتريات من الطلب حتى الفاتورة والمرتجع وكشوف المورد.

## A — Source-to-order

- [ ] **S13-T01** — Purchase Requisition.
- [ ] **S13-T02** — Request for Quotation (RFQ).
- [ ] **S13-T03** — Supplier Quotation.
- [ ] **S13-T04** — Quotation Comparison.

## B — Order/receipt/invoice

- [ ] **S13-T05** — Purchase Order.
- [ ] **S13-T06** — Goods Receipt Note (GRN).
- [ ] **S13-T07** — Purchase Invoice.
- [ ] **S13-T08** — Purchase Debit/Credit Note حسب model.
- [ ] **S13-T09** — Supplier Return.

## C — Supplier statements

- [ ] **S13-T10** — Supplier Statement.
- [ ] **S13-T11** — Supplier Aging.
- [ ] **S13-T12** — Purchase Register.
- [ ] **S13-T13** — Purchase Analysis.
- [ ] **S13-T14** — Outstanding Purchase Orders.

## D — Shared behaviors

- [ ] **S13-T15** — vendor addresses/tax IDs.
- [ ] **S13-T16** — expected delivery.
- [ ] **S13-T17** — warehouse/site reference.
- [ ] **S13-T18** — landed charges hooks.
- [ ] **S13-T19** — multi-currency/exchange rate.
- [ ] **S13-T20** — approval trail.

## E — QA

- [ ] **S13-T21** — partial receipt scenarios.
- [ ] **S13-T22** — long vendor terms.
- [ ] **S13-T23** — multi-page items.
- [ ] **S13-T24** — Arabic/English mixed item codes.
- [ ] **S13-T25** — tax/discount validation.
- [ ] **S13-T26** — null shipping fields.

## Manual Verification Example

- [ ] **S13-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S13-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S13-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S13-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S13-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Purchasing pack.
- [ ] Supplier statement/aging.
- [ ] Comparison document.

## Exit Gate

- [ ] PO الحالي يستخدم نفس pack/family بدون fork logic.
- [ ] RFQ/Quotation Comparison لا تحتاج custom page-flow engine.
- [ ] Arabic vendor documents صحيحة.

---

# S14 — Accounting & Finance Pack

**Priority:** P1  
**Dependencies:** S13

## Goal

تغطية مطبوعات المحاسبة العامة والذمم والبنوك والضرائب والتقارير المقارنة.

## A — Ledger/journal

- [ ] **S14-T01** — General Ledger.
- [ ] **S14-T02** — Journal Entry.
- [ ] **S14-T03** — Journal Register.
- [ ] **S14-T04** — Account Statement.

## B — Receivables/payables

- [ ] **S14-T05** — AR Aging.
- [ ] **S14-T06** — AP Aging.
- [ ] **S14-T07** — Customer Balances.
- [ ] **S14-T08** — Supplier Balances.

## C — Cash/bank

- [ ] **S14-T09** — Cash Book.
- [ ] **S14-T10** — Bank Book.
- [ ] **S14-T11** — Bank Reconciliation.
- [ ] **S14-T12** — Petty Cash.
- [ ] **S14-T13** — Payment Register.
- [ ] **S14-T14** — Receipt Register.

## D — Tax

- [ ] **S14-T15** — VAT/Tax Summary.
- [ ] **S14-T16** — Tax Register.
- [ ] **S14-T17** — taxable/exempt/zero-rated breakdown configuration.
- [ ] **S14-T18** — rounding/reconciliation report.

## E — Cost/project/budget

- [ ] **S14-T19** — Cost Center Statement.
- [ ] **S14-T20** — Cost Center Trial Balance.
- [ ] **S14-T21** — Project Financial Report.
- [ ] **S14-T22** — Budget vs Actual.
- [ ] **S14-T23** — Multi-period Comparison.

## F — Financial presentation

- [ ] **S14-T24** — debit/credit semantic styles.
- [ ] **S14-T25** — accounting negatives.
- [ ] **S14-T26** — opening/movement/closing balances.
- [ ] **S14-T27** — group/subtotal hierarchy.
- [ ] **S14-T28** — page-level carry/brought-forward policy where required.

## G — QA

- [ ] **S14-T29** — calculation reconciliation tests.
- [ ] **S14-T30** — decimal precision tests.
- [ ] **S14-T31** — multi-currency tests.
- [ ] **S14-T32** — long chart-of-accounts hierarchy.
- [ ] **S14-T33** — RTL ledger column policy.
- [ ] **S14-T34** — 10k-row performance sample.

## Manual Verification Example

- [ ] **S14-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S14-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S14-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S14-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S14-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Accounting pack.
- [ ] Reconciliation/calculation tests.
- [ ] Hierarchical ledger reports.

## Exit Gate

- [ ] كل تقرير مالي يمكن reconciliation له آليًا.
- [ ] DataGrid grouping/subtotals يغطي use cases بدون renderer خاص.
- [ ] RTL لا يغير معنى debit/credit أو ترتيب الأرقام.

---

# S15 — Inventory & WMS Pack

**Priority:** P1  
**Dependencies:** S14

## Goal

تغطية حركات وتقارير المخزون والمستودعات والدفعات/السيريال والملصقات.

## A — Movement docs

- [ ] **S15-T01** — Stock Receipt.
- [ ] **S15-T02** — Stock Issue.
- [ ] **S15-T03** — Stock Transfer.
- [ ] **S15-T04** — Warehouse Transfer.
- [ ] **S15-T05** — Stock Adjustment.

## B — Count docs

- [ ] **S15-T06** — Stock Count.
- [ ] **S15-T07** — Cycle Count.
- [ ] **S15-T08** — variance/count reconciliation.

## C — Reports

- [ ] **S15-T09** — Item Card.
- [ ] **S15-T10** — Stock Ledger.
- [ ] **S15-T11** — Stock Valuation.
- [ ] **S15-T12** — Stock Availability.
- [ ] **S15-T13** — Reorder Report.
- [ ] **S15-T14** — Min/Max Report.
- [ ] **S15-T15** — Slow/Dead Stock.

## D — Traceability

- [ ] **S15-T16** — Batch Report.
- [ ] **S15-T17** — Serial Report.
- [ ] **S15-T18** — Expiry Report.
- [ ] **S15-T19** — lot/batch references داخل movement docs.

## E — Labels

- [ ] **S15-T20** — Item Label.
- [ ] **S15-T21** — Shelf Label.
- [ ] **S15-T22** — Batch Label.
- [ ] **S15-T23** — Serial Label.
- [ ] **S15-T24** — Location Label.

## F — QA

- [ ] **S15-T25** — multi-unit quantities.
- [ ] **S15-T26** — fractional quantities.
- [ ] **S15-T27** — large item counts.
- [ ] **S15-T28** — long item names.
- [ ] **S15-T29** — Arabic item names + Latin SKU.
- [ ] **S15-T30** — batch/serial/expiry mixed values.

## Manual Verification Example

- [ ] **S15-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S15-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S15-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S15-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S15-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Inventory/WMS pack.
- [ ] Traceability reports.
- [ ] Label set.

## Exit Gate

- [ ] SKU/serial/batch لا تتشوّه داخل RTL.
- [ ] stock calculations متسقة.
- [ ] labels تعمل على custom print profiles.

---

# S16 — POS & Retail Pack

**Priority:** P1  
**Dependencies:** S15

## Goal

تغطية thermal retail printing وتقارير الورديات والصندوق.

## A — Receipts

- [ ] **S16-T01** — 58mm receipt.
- [ ] **S16-T02** — 80mm receipt.
- [ ] **S16-T03** — Refund Receipt.
- [ ] **S16-T04** — Exchange Receipt.
- [ ] **S16-T05** — Gift Receipt.

## B — Operations

- [ ] **S16-T06** — Kitchen Order Ticket (KOT) كقالب اختياري مناسب للمطاعم.
- [ ] **S16-T07** — Shift Open report.
- [ ] **S16-T08** — Shift Close report.
- [ ] **S16-T09** — X Report.
- [ ] **S16-T10** — Z Report.
- [ ] **S16-T11** — Cash Drawer report.
- [ ] **S16-T12** — Payment Method Summary.

## C — Labels

- [ ] **S16-T13** — Barcode label.
- [ ] **S16-T14** — Price label.
- [ ] **S16-T15** — Promotion label.

## D — Receipt behaviors

- [ ] **S16-T16** — tax summary.
- [ ] **S16-T17** — discounts/promotions.
- [ ] **S16-T18** — cash/change.
- [ ] **S16-T19** — multiple payment methods.
- [ ] **S16-T20** — QR/barcode.
- [ ] **S16-T21** — copy/reprint marker.
- [ ] **S16-T22** — compact Arabic typography.

## E — QA

- [ ] **S16-T23** — thermal width stress.
- [ ] **S16-T24** — very long product names.
- [ ] **S16-T25** — Arabic notes under line item.
- [ ] **S16-T26** — high item count.
- [ ] **S16-T27** — no cut-off at end.
- [ ] **S16-T28** — RTL/LTR receipts.

## Manual Verification Example

- [ ] **S16-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S16-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S16-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S16-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S16-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] POS/Retail pack.
- [ ] 58/80mm golden samples.
- [ ] Shift/X/Z reports.

## Exit Gate

- [ ] لا clipping على thermal widths.
- [ ] Arabic line items/notes سليمة.
- [ ] cash/change/payment totals reconcile.

---

# S17 — HR & Payroll Pack

**Priority:** P1  
**Dependencies:** S16

## Goal

تغطية المستندات التشغيلية للموظفين والدوام والرواتب والشهادات.

## A — Employee

- [ ] **S17-T01** — Employee Profile.
- [ ] **S17-T02** — Employee List.
- [ ] **S17-T03** — Employment Contract/Form support where applicable.
- [ ] **S17-T04** — Employee Action Form.

## B — Time/attendance

- [ ] **S17-T05** — Attendance Report.
- [ ] **S17-T06** — Timesheet.
- [ ] **S17-T07** — Overtime Report.
- [ ] **S17-T08** — Leave Balance.
- [ ] **S17-T09** — Leave Request.

## C — Payroll

- [ ] **S17-T10** — Payslip.
- [ ] **S17-T11** — Payroll Sheet.
- [ ] **S17-T12** — Payroll Summary.
- [ ] **S17-T13** — Allowances Report.
- [ ] **S17-T14** — Deductions Report.
- [ ] **S17-T15** — Employee Loan/Advance Report.

## D — Certificates/settlement

- [ ] **S17-T16** — Salary Certificate.
- [ ] **S17-T17** — Employment Certificate.
- [ ] **S17-T18** — Experience Certificate.
- [ ] **S17-T19** — End-of-Service calculation/report.
- [ ] **S17-T20** — Final Settlement.

## E — Privacy/security

- [ ] **S17-T21** — field visibility policies.
- [ ] **S17-T22** — masking of sensitive identifiers where configured.
- [ ] **S17-T23** — watermark/confidential marker.
- [ ] **S17-T24** — role-specific printable variant hooks.

## F — QA

- [ ] **S17-T25** — Arabic employee names.
- [ ] **S17-T26** — mixed IDs/bank data.
- [ ] **S17-T27** — long allowance/deduction lists.
- [ ] **S17-T28** — payroll total reconciliation.
- [ ] **S17-T29** — certificate single-page constraints.

## Manual Verification Example

- [ ] **S17-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S17-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S17-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S17-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S17-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] HR/Payroll pack.
- [ ] Certificates.
- [ ] Payroll reconciliation tests.

## Exit Gate

- [ ] payslip الحالي migrated بدون duplication.
- [ ] sensitive-field configuration واضحة.
- [ ] RTL employee docs صحيحة.

---

# S18 — Manufacturing & Quality Pack

**Priority:** P2  
**Dependencies:** S17

## Goal

تغطية مستندات الإنتاج والتتبع والجودة التي تعتمد على بنية تشغيلية أكثر تعقيدًا.

## A — Manufacturing

- [ ] **S18-T01** — Bill of Materials (BOM).
- [ ] **S18-T02** — Production Order.
- [ ] **S18-T03** — Work Order.
- [ ] **S18-T04** — Job Card.
- [ ] **S18-T05** — Material Requirement.
- [ ] **S18-T06** — Material Issue.
- [ ] **S18-T07** — Material Return.
- [ ] **S18-T08** — Production Receipt.
- [ ] **S18-T09** — Routing/Traveler.
- [ ] **S18-T10** — Machine Operation Report.
- [ ] **S18-T11** — Labor Report.
- [ ] **S18-T12** — Scrap Report.
- [ ] **S18-T13** — Work in Progress.
- [ ] **S18-T14** — Production Variance.

## B — Quality

- [ ] **S18-T15** — Quality Inspection.
- [ ] **S18-T16** — Incoming Inspection.
- [ ] **S18-T17** — In-process Inspection.
- [ ] **S18-T18** — Final Inspection.
- [ ] **S18-T19** — Non-Conformance Report (NCR).
- [ ] **S18-T20** — Corrective/Preventive Action (CAPA).
- [ ] **S18-T21** — Certificate of Analysis (COA).
- [ ] **S18-T22** — Quality Checklist.
- [ ] **S18-T23** — Audit Form.
- [ ] **S18-T24** — Calibration Record.

## C — Shared mechanics

- [ ] **S18-T25** — nested operation/material tables.
- [ ] **S18-T26** — checklist primitives.
- [ ] **S18-T27** — pass/fail/status cells.
- [ ] **S18-T28** — measurement/specification/value/tolerance rows.
- [ ] **S18-T29** — batch/serial traceability.
- [ ] **S18-T30** — approval/sign-off.

## D — QA

- [ ] **S18-T31** — multi-level BOM.
- [ ] **S18-T32** — long routing.
- [ ] **S18-T33** — mixed units.
- [ ] **S18-T34** — RTL technical terms + Latin codes.
- [ ] **S18-T35** — multi-page checklists.

## Manual Verification Example

- [ ] **S18-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S18-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S18-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S18-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S18-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Manufacturing pack.
- [ ] Quality pack.
- [ ] Checklist/measurement primitives.

## Exit Gate

- [ ] nested tables تبقى مستقرة على multi-page.
- [ ] technical IDs/units صحيحة داخل RTL.
- [ ] quality forms قابلة للتكوين بدون custom renderer لكل form.

---

# S19 — Fixed Assets & Projects Pack

**Priority:** P2  
**Dependencies:** S18

## Goal

تغطية دورة الأصل الثابت ومطبوعات المشاريع والتكلفة والتقدم.

## A — Fixed assets

- [ ] **S19-T01** — Asset Card.
- [ ] **S19-T02** — Asset Register.
- [ ] **S19-T03** — Asset Label.
- [ ] **S19-T04** — Asset Transfer.
- [ ] **S19-T05** — Asset Assignment.
- [ ] **S19-T06** — Asset Return.
- [ ] **S19-T07** — Asset Disposal.
- [ ] **S19-T08** — Depreciation Report.
- [ ] **S19-T09** — Asset Maintenance Report.
- [ ] **S19-T10** — Asset Count.
- [ ] **S19-T11** — Asset Movement Report.

## B — Projects

- [ ] **S19-T12** — Project Summary.
- [ ] **S19-T13** — Project Budget.
- [ ] **S19-T14** — Project Cost.
- [ ] **S19-T15** — Project Profitability.
- [ ] **S19-T16** — Project Timesheet.
- [ ] **S19-T17** — Project Expense Report.
- [ ] **S19-T18** — Milestone Report.
- [ ] **S19-T19** — Progress Report.
- [ ] **S19-T20** — Completion Certificate.
- [ ] **S19-T21** — Project Billing.
- [ ] **S19-T22** — Resource Utilization.
- [ ] **S19-T23** — Project Purchasing Report.

## C — QA

- [ ] **S19-T24** — asset serial/tag BiDi.
- [ ] **S19-T25** — label profiles.
- [ ] **S19-T26** — depreciation reconciliation.
- [ ] **S19-T27** — multi-period project financials.
- [ ] **S19-T28** — long milestone notes.
- [ ] **S19-T29** — Arabic/English project codes.

## Manual Verification Example

- [ ] **S19-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S19-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S19-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S19-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S19-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Fixed Assets pack.
- [ ] Projects pack.
- [ ] Asset labels/certificates.

## Exit Gate

- [ ] asset/project calculations قابلة للتحقق.
- [ ] labels and certificates تستخدم families المشتركة.
- [ ] لا duplicated identity/approval blocks.

---

# S20 — Maintenance, Service & Logistics Pack

**Priority:** P2  
**Dependencies:** S19

## Goal

تغطية أوامر الخدمة والصيانة والشحن والتسليم والنقل.

## A — Maintenance/service

- [ ] **S20-T01** — Service Order.
- [ ] **S20-T02** — Maintenance Work Order.
- [ ] **S20-T03** — Preventive Maintenance Schedule.
- [ ] **S20-T04** — Maintenance Checklist.
- [ ] **S20-T05** — Technician Report.
- [ ] **S20-T06** — Service Completion Report.
- [ ] **S20-T07** — Spare Parts Usage.
- [ ] **S20-T08** — Warranty Report.
- [ ] **S20-T09** — Inspection Report.
- [ ] **S20-T10** — Calibration/Service History.

## B — Logistics

- [ ] **S20-T11** — Shipment Document.
- [ ] **S20-T12** — Packing List variant.
- [ ] **S20-T13** — Dispatch Note.
- [ ] **S20-T14** — Waybill.
- [ ] **S20-T15** — Manifest.
- [ ] **S20-T16** — Trip Sheet.
- [ ] **S20-T17** — Trip Report.
- [ ] **S20-T18** — Shipping Label.
- [ ] **S20-T19** — Pallet Label.
- [ ] **S20-T20** — Container List.
- [ ] **S20-T21** — Freight Summary.
- [ ] **S20-T22** — Proof of Delivery.

## C — Shared mechanics

- [ ] **S20-T23** — route/reference blocks.
- [ ] **S20-T24** — vehicle/driver/technician identity blocks.
- [ ] **S20-T25** — checklists.
- [ ] **S20-T26** — signature/proof blocks.
- [ ] **S20-T27** — geo/time metadata fields.
- [ ] **S20-T28** — attachments/photos reference slots.

## D — QA

- [ ] **S20-T29** — multi-stop manifests.
- [ ] **S20-T30** — long shipment items.
- [ ] **S20-T31** — Arabic addresses + Latin tracking numbers.
- [ ] **S20-T32** — label/thermal profiles.
- [ ] **S20-T33** — proof-of-delivery signatures.

## Manual Verification Example

- [ ] **S20-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S20-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S20-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S20-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S20-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Maintenance/Service pack.
- [ ] Logistics pack.
- [ ] Shipping/pallet labels.

## Exit Gate

- [ ] tracking/reference IDs محفوظة في RTL.
- [ ] multi-stop manifests paginate correctly.
- [ ] service forms reuse checklist/approval components.

---

# S21 — CRM & Customer-Facing Documents

**Priority:** P2  
**Dependencies:** S20

## Goal

تغطية التقارير والمستندات التي تخرج من CRM وتتكامل مع sales/customer history.

## A — CRM

- [ ] **S21-T01** — Customer Profile.
- [ ] **S21-T02** — Lead Report.
- [ ] **S21-T03** — Opportunity Report.
- [ ] **S21-T04** — Pipeline Report.
- [ ] **S21-T05** — Activity Report.
- [ ] **S21-T06** — Visit Report.
- [ ] **S21-T07** — Call Report.
- [ ] **S21-T08** — Customer History.
- [ ] **S21-T09** — Proposal.
- [ ] **S21-T10** — Contract summary/document shell.

## B — Presentation

- [ ] **S21-T11** — metric cards.
- [ ] **S21-T12** — stage/status visualization without depending on charts only.
- [ ] **S21-T13** — timeline/history list.
- [ ] **S21-T14** — contact/party blocks.
- [ ] **S21-T15** — attachments/reference list.

## C — QA

- [ ] **S21-T16** — long activity histories.
- [ ] **S21-T17** — Arabic notes + Latin emails/phones.
- [ ] **S21-T18** — pipeline totals.
- [ ] **S21-T19** — multi-page proposals.
- [ ] **S21-T20** — confidential watermark variants.

## Manual Verification Example

- [ ] **S21-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S21-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S21-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S21-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S21-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] CRM pack.
- [ ] Customer-history/timeline components where reusable.
- [ ] Proposal/contract shells.

## Exit Gate

- [ ] CRM outputs reuse party/metric/reference components.
- [ ] mixed phone/email/URL content correct in RTL.
- [ ] no duplicated sales document logic.

---

# S22 — Template Engine vNext, Schema Versioning & Registry

**Priority:** P3  
**Dependencies:** S21

## Goal

ترقية JSON/template layer لتصبح آمنة وقابلة للتوسع والتخصيص المؤسسي.

## A — Schema

- [ ] **S22-T01** — إضافة explicit schemaVersion.
- [ ] **S22-T02** — تعريف migration strategy بين schema versions.
- [ ] **S22-T03** — validation errors قابلة للفهم.
- [ ] **S22-T04** — backward compatibility للـ current definitions.

## B — New elements

- [ ] **S22-T05** — Component.
- [ ] **S22-T06** — Section.
- [ ] **S22-T07** — PageBreak.
- [ ] **S22-T08** — Barcode.
- [ ] **S22-T09** — QRCode.
- [ ] **S22-T10** — Signature.
- [ ] **S22-T11** — Summary.
- [ ] **S22-T12** — Metric.
- [ ] **S22-T13** — Chart.
- [ ] **S22-T14** — Attachment.
- [ ] **S22-T15** — Stamp.
- [ ] **S22-T16** — Label.
- [ ] **S22-T17** — Group.
- [ ] **S22-T18** — SubTemplate.

## C — Expression engine

- [ ] **S22-T19** — safe nested property access.
- [ ] **S22-T20** — arithmetic.
- [ ] **S22-T21** — boolean/null-safe conditions.
- [ ] **S22-T22** — aggregates.
- [ ] **S22-T23** — group aggregates.
- [ ] **S22-T24** — formatters.
- [ ] **S22-T25** — localization keys.
- [ ] **S22-T26** — no arbitrary code execution.

## D — Composition

- [ ] **S22-T27** — subtemplates.
- [ ] **S22-T28** — inheritance/composition.
- [ ] **S22-T29** — named reusable components.
- [ ] **S22-T30** — style inheritance.
- [ ] **S22-T31** — document-family binding.

## E — Registry/versioning

- [ ] **S22-T32** — TemplateId.
- [ ] **S22-T33** — TemplateVersion.
- [ ] **S22-T34** — TemplatePack.
- [ ] **S22-T35** — Variant.
- [ ] **S22-T36** — Locale.
- [ ] **S22-T37** — Country.
- [ ] **S22-T38** — Organization.
- [ ] **S22-T39** — Branch.
- [ ] **S22-T40** — EffectiveFrom/EffectiveTo.
- [ ] **S22-T41** — fallback hierarchy.
- [ ] **S22-T42** — draft/published state.
- [ ] **S22-T43** — history/checksum/rollback.

## F — Directionality

- [ ] **S22-T44** — direction property في schema.
- [ ] **S22-T45** — element override.
- [ ] **S22-T46** — component inheritance.
- [ ] **S22-T47** — bilingual nested sections.
- [ ] **S22-T48** — value-direction formatting.

## G — Tests/security

- [ ] **S22-T49** — invalid expression tests.
- [ ] **S22-T50** — schema migration tests.
- [ ] **S22-T51** — unknown element tests.
- [ ] **S22-T52** — large-loop tests.
- [ ] **S22-T53** — no renderer-specific objects in serialized schema.

## Manual Verification Example

- [ ] **S22-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S22-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S22-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S22-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S22-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Template Engine vNext.
- [ ] Versioned schema.
- [ ] Safe expression engine.
- [ ] Template registry/versioning.

## Exit Gate

- [ ] templates القديمة يمكن تحميلها أو migrate لها.
- [ ] لا arbitrary code execution.
- [ ] directionality محفوظة في nested template composition.
- [ ] registry fallback deterministic.

---

# S23 — Compliance, Signing, Audit & Archival Profiles

**Priority:** P3  
**Dependencies:** S22

## Goal

فصل المتطلبات التنظيمية والأمنية عن القوالب العامة عبر profiles/plugins قابلة للتخصيص.

## A — Compliance abstraction

- [ ] **S23-T01** — `GeniusPdfComplianceProfile`.
- [ ] **S23-T02** — country/tenant plugin contract.
- [ ] **S23-T03** — required-field validation hooks.
- [ ] **S23-T04** — structured QR payload hooks.
- [ ] **S23-T05** — original/copy/reprint policies.

## B — Security/signing

- [ ] **S23-T06** — business approval منفصل عن cryptographic signature.
- [ ] **S23-T07** — signing metadata model.
- [ ] **S23-T08** — certificate signature integration contract.
- [ ] **S23-T09** — timestamp integration contract.
- [ ] **S23-T10** — document hash metadata.
- [ ] **S23-T11** — UUID/document fingerprint.

## C — Archival/document metadata

- [ ] **S23-T12** — XMP metadata abstraction.
- [ ] **S23-T13** — embedded attachments hook.
- [ ] **S23-T14** — archive profile capability flags.
- [ ] **S23-T15** — source transaction/audit metadata.
- [ ] **S23-T16** — document generation timestamp/version.

## D — Existing security integration

- [ ] **S23-T17** — توحيد encryption/password/permissions مع higher-level policy.
- [ ] **S23-T18** — عدم كسر current security service.
- [ ] **S23-T19** — اختبارات protected/unprotected flows.

## E — Compliance packs

- [ ] **S23-T20** — بناء framework فقط للـ jurisdiction-specific requirements.
- [ ] **S23-T21** — عدم hardcode قوانين دولة داخل base templates.
- [ ] **S23-T22** — كل country profile له version/effective date.
- [ ] **S23-T23** — توثيق أن المتطلبات القانونية يجب تحديثها حسب المصدر الرسمي وقت التنفيذ.

## Manual Verification Example

- [ ] **S23-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S23-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S23-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S23-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S23-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Compliance plugin architecture.
- [ ] Signing/audit metadata layer.
- [ ] Archival capability abstraction.

## Exit Gate

- [ ] base templates لا تحتوي country-specific forks.
- [ ] security/compliance policies قابلة للاختبار.
- [ ] business signatures لا تختلط بالcryptographic signatures.

---

# S24 — Performance, Visual Regression & Release Hardening

**Priority:** P0/P3  
**Dependencies:** S23

## Goal

تحويل الجودة والأداء من اختبارات متفرقة إلى Release Gate ملزم للمكتبة.

## A — Performance

- [ ] **S24-T01** — baseline لكل document family.
- [ ] **S24-T02** — cache fonts/resources حيث آمن.
- [ ] **S24-T03** — cache images/barcodes/QR where appropriate.
- [ ] **S24-T04** — avoid repeated measurement.
- [ ] **S24-T05** — large-grid memory profiling.
- [ ] **S24-T06** — background generation benchmark.
- [ ] **S24-T07** — batch generation benchmark.

## B — Visual regression

- [ ] **S24-T08** — goldens لكل component أساسي.
- [ ] **S24-T09** — goldens لكل family.
- [ ] **S24-T10** — goldens لكل core ERP pack.
- [ ] **S24-T11** — EN/LTR.
- [ ] **S24-T12** — AR/RTL.
- [ ] **S24-T13** — bilingual.
- [ ] **S24-T14** — thermal.
- [ ] **S24-T15** — labels.

## C — Semantic regression

- [ ] **S24-T16** — text extraction checks.
- [ ] **S24-T17** — document number.
- [ ] **S24-T18** — party.
- [ ] **S24-T19** — totals.
- [ ] **S24-T20** — tax.
- [ ] **S24-T21** — page number.
- [ ] **S24-T22** — currency.
- [ ] **S24-T23** — required compliance metadata where configured.

## D — Stress matrix

- [ ] **S24-T24** — empty.
- [ ] **S24-T25** — 1 line.
- [ ] **S24-T26** — 50 lines.
- [ ] **S24-T27** — 500 lines.
- [ ] **S24-T28** — very long notes.
- [ ] **S24-T29** — very long addresses.
- [ ] **S24-T30** — null optional sections.
- [ ] **S24-T31** — mixed Arabic/English.
- [ ] **S24-T32** — multi-currency.
- [ ] **S24-T33** — custom print profile.

## E — Release gates

- [ ] **S24-T34** — no clipping.
- [ ] **S24-T35** — no overlap.
- [ ] **S24-T36** — no unexpected page count jump.
- [ ] **S24-T37** — correct repeated headers.
- [ ] **S24-T38** — stable page numbering.
- [ ] **S24-T39** — correct logical RTL mirroring.
- [ ] **S24-T40** — no broken numeric/ID BiDi.
- [ ] **S24-T41** — no significant undocumented performance regression.

## F — Documentation

- [ ] **S24-T42** — architecture docs.
- [ ] **S24-T43** — migration docs.
- [ ] **S24-T44** — template author guide.
- [ ] **S24-T45** — directionality guide.
- [ ] **S24-T46** — performance guide.
- [ ] **S24-T47** — golden update policy.

## Manual Verification Example

- [ ] **S24-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S24-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S24-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S24-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S24-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Release regression matrix.
- [ ] Performance report.
- [ ] Quality gate checklist.
- [ ] Updated architecture/docs.

## Exit Gate

- [ ] كل P0/P1 template يمر release matrix.
- [ ] لا known directionality regression.
- [ ] benchmarks محفوظة كbaseline.
- [ ] أي intentional visual change موثق ومراجع.

---

# S25 — Template Designer Foundation

**Priority:** P3  
**Dependencies:** S24

## Goal

بناء designer فقط بعد استقرار schema/layout/components حتى لا يصبح الdesigner مرتبطًا ببنية متغيرة.

## A — Designer model

- [ ] **S25-T01** — تعريف designer document state فوق Template Engine vNext.
- [ ] **S25-T02** — drag/drop component metadata.
- [ ] **S25-T03** — properties panel schema.
- [ ] **S25-T04** — style editor schema.
- [ ] **S25-T05** — data binding editor.

## B — Preview

- [ ] **S25-T06** — sample data preview.
- [ ] **S25-T07** — EN/AR direction switch.
- [ ] **S25-T08** — bilingual preview.
- [ ] **S25-T09** — page profile switch.
- [ ] **S25-T10** — multi-page preview.
- [ ] **S25-T11** — validation messages.

## C — Authoring

- [ ] **S25-T12** — tables.
- [ ] **S25-T13** — sections.
- [ ] **S25-T14** — conditions.
- [ ] **S25-T15** — expressions.
- [ ] **S25-T16** — subtemplates.
- [ ] **S25-T17** — components.
- [ ] **S25-T18** — styles.
- [ ] **S25-T19** — headers/footers.
- [ ] **S25-T20** — labels/thermal.

## D — Lifecycle

- [ ] **S25-T21** — draft save.
- [ ] **S25-T22** — validate.
- [ ] **S25-T23** — publish.
- [ ] **S25-T24** — version.
- [ ] **S25-T25** — rollback.
- [ ] **S25-T26** — import/export JSON.
- [ ] **S25-T27** — organization/branch overrides.

## E — Guardrails

- [ ] **S25-T28** — designer cannot emit invalid schema.
- [ ] **S25-T29** — safe expressions only.
- [ ] **S25-T30** — directionality defaults shown explicitly.
- [ ] **S25-T31** — preview uses same renderer as production.

## Manual Verification Example

- [ ] **S25-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S25-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S25-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S25-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S25-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Designer-ready schema/UI contract.
- [ ] Preview/validation workflow.
- [ ] Publish/version lifecycle.

## Exit Gate

- [ ] designer لا يحتاج special renderer.
- [ ] preview والproduction يستخدمان نفس template semantics.
- [ ] RTL/LTR preview مطابق للgoldens.

---

# S26 — Industry Packs & Plugin Ecosystem

**Priority:** P4  
**Dependencies:** S25

## Goal

توسيع المكتبة إلى قطاعات ERP المختلفة بدون تلويث الـ core بمنطق خاص بكل صناعة.

## A — Pack contract

- [ ] **S26-T01** — تعريف package/plugin boundaries.
- [ ] **S26-T02** — template pack manifest.
- [ ] **S26-T03** — required domain extensions.
- [ ] **S26-T04** — optional compliance hooks.
- [ ] **S26-T05** — version compatibility rules.

## B — Retail

- [ ] **S26-T06** — retail-specific labels/promotions/receipts فوق POS pack.
- [ ] **S26-T07** — لا تكرار core POS.

## C — Restaurant

- [ ] **S26-T08** — KOT variants.
- [ ] **S26-T09** — table/order tickets.
- [ ] **S26-T10** — kitchen sections.
- [ ] **S26-T11** — delivery receipt variants.

## D — Construction/Real Estate

- [ ] **S26-T12** — progress certificates.
- [ ] **S26-T13** — measurement/BOQ-style reports.
- [ ] **S26-T14** — property/unit/customer documents.
- [ ] **S26-T15** — project billing extensions.

## E — Healthcare/Education

- [ ] **S26-T16** — industry report shells فقط حيث لا تتطلب domain regulated غير مدروس.
- [ ] **S26-T17** — استخدام plugin-specific models وعدم إضافتها إلى core.

## F — Automotive/Distribution/Hospitality

- [ ] **S26-T18** — service/vehicle variants.
- [ ] **S26-T19** — route/distribution variants.
- [ ] **S26-T20** — guest/folio operational variants.
- [ ] **S26-T21** — إعادة استخدام service/logistics/transaction families.

## G — Governance

- [ ] **S26-T22** — كل pack يملك owner/version.
- [ ] **S26-T23** — كل pack يملك EN/AR tests عند الدعم.
- [ ] **S26-T24** — كل pack يعلن dependencies.
- [ ] **S26-T25** — لا pack يعدل core renderer مباشرة.

## Manual Verification Example

- [ ] **S26-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [ ] **S26-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [ ] **S26-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [ ] **S26-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S26-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [ ] Plugin/pack contract.
- [ ] Initial vertical pack skeletons.
- [ ] Governance documentation.

## Exit Gate

- [ ] الـ core يبقى ERP-general.
- [ ] vertical logic معزول.
- [ ] كل pack يعيد استخدام families/components ويضيف فقط domain-specific pieces.

---

# 4. Cross-Sprint Mandatory Test Matrix

يجب تشغيل هذه المصفوفة في كل Sprint يغيّر rendering أو components أو templates.

## Direction

- [ ] EN/LTR.
- [ ] AR/RTL.
- [ ] bilingual.
- [ ] RTL parent + LTR child.
- [ ] LTR parent + RTL child.
- [ ] Arabic label + Latin numeric value.
- [ ] Arabic sentence + document number/SKU/IBAN/email.

## Data size

- [ ] empty.
- [ ] one row.
- [ ] normal sample.
- [ ] long text.
- [ ] 50 rows.
- [ ] 500 rows عند انطباقه.
- [ ] very-large-data benchmark عند انطباقه.

## Pagination

- [ ] one page.
- [ ] multi-page.
- [ ] row near page boundary.
- [ ] keepTogether.
- [ ] repeated headers.
- [ ] notes/terms spanning pages.
- [ ] Page X of Y.

## Optional data

- [ ] null header extra data.
- [ ] null party sub-fields.
- [ ] null notes.
- [ ] null terms.
- [ ] null approval/signature.
- [ ] empty list.
- [ ] hidden section leaves no gap.

## Financial

- [ ] subtotal.
- [ ] discount.
- [ ] charges.
- [ ] tax.
- [ ] grand total.
- [ ] negative values where valid.
- [ ] precision/rounding.
- [ ] multi-currency where applicable.

## Print profiles

- [ ] A4 portrait.
- [ ] A4 landscape where relevant.
- [ ] 58/80mm for POS.
- [ ] label profile for labels.
- [ ] custom/pre-printed only where relevant.

---

# 5. Mandatory Directionality Acceptance Matrix by Component

| Component | LTR | RTL mirror | Numeric LTR in RTL | Mixed text | Nested override | No image/code mirroring |
|---|---|---|---|---|---|---|
| Summary | [ ] | [ ] | [ ] | [ ] | [ ] | N/A |
| InfoBox | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| ReportHeader | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| DataGrid | [ ] | [ ] | [ ] | [ ] | [ ] | N/A |
| RichText | [ ] | [ ] | [ ] | [ ] | [ ] | N/A |
| SignatureArea | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| QR | [ ] | [ ] caption | [ ] caption | [ ] | [ ] | [ ] |
| Barcode | [ ] | [ ] caption | [ ] caption | [ ] | [ ] | [ ] |
| Two-column | [ ] | [ ] | N/A | [ ] | [ ] | N/A |
| PartyBlock | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| DocumentIdentity | [ ] | [ ] | [ ] | [ ] | [ ] | N/A |
| TaxSummary | [ ] | [ ] | [ ] | [ ] | [ ] | N/A |
| ApprovalTrail | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |

---

# 6. Release Checkpoints

## Checkpoint A — after S02

لا يتم الانتقال إلى layout work إلا إذا:

- [ ] Summary العربي صحيح هندسيًا.
- [ ] InfoBox العربي صحيح.
- [ ] mixed numeric values لا تنعكس.
- [ ] components الأساسية تملك goldens.
- [ ] no manual string reversal.

## Checkpoint B — after S09

لا يتم إضافة ERP packs واسعة إلا إذا:

- [ ] layout blocks مستقرة.
- [ ] DataGrid يغطي pagination/grouping.
- [ ] formatting موحد.
- [ ] ERP domain/calculation منفصل عن UI.
- [ ] shared components موجودة.
- [ ] families موجودة.
- [ ] Quotation/PO/TaxInvoice migrated.
- [ ] لا regression في public behavior.

## Checkpoint C — after S17

- [ ] Sales مكتمل.
- [ ] Purchasing مكتمل.
- [ ] Accounting core مكتمل.
- [ ] Inventory/WMS core مكتمل.
- [ ] POS core مكتمل.
- [ ] HR/Payroll core مكتمل.
- [ ] release matrix يمر لهذه الحزم.

## Checkpoint D — after S21

- [ ] Manufacturing/Quality.
- [ ] Assets/Projects.
- [ ] Maintenance/Service/Logistics.
- [ ] CRM.
- [ ] advanced document families لم تحتج forks غير مبررة.

## Checkpoint E — after S24

- [ ] Template Engine vNext versioned.
- [ ] compliance/plugin architecture.
- [ ] signing/audit/archival abstractions.
- [ ] performance baselines.
- [ ] full visual regression gate.

---

# 7. Rule for Adding Any New Template

قبل قبول أي Template جديد، يجب الإجابة بنعم على الآتي:

- [ ] هل ينتمي إلى family موجودة؟
- [ ] هل يستخدم shared ERP models؟
- [ ] هل الحسابات خارج renderer؟
- [ ] هل يستخدم shared formatter؟
- [ ] هل يستخدم theme tokens؟
- [ ] هل يستخدم logical start/end؟
- [ ] هل يعمل في LTR؟
- [ ] هل يعمل في RTL؟
- [ ] هل القيم الرقمية/IDs صحيحة داخل RTL؟
- [ ] هل optional sections تنهار بدون gaps؟
- [ ] هل multi-page صحيح؟
- [ ] هل له golden test؟
- [ ] هل له Manual Verification screen داخل `example/lib/features/dashboard/presentation/pages` ومضافة إلى Dashboard؟
- [ ] هل له calculation/semantic tests عند الحاجة؟
- [ ] هل لا يكرر party/header/items/summary logic؟
- [ ] هل لا يضيف country-specific logic إلى core template؟

إذا كانت أي إجابة أساسية "لا"، فلا يعتبر القالب جاهزًا للدمج.

---

# 8. أول ترتيب تنفيذي يجب الالتزام به الآن

ابدأ فعليًا بالترتيب التالي دون القفز إلى packs الجديدة:

1. S00 — capture regressions.
2. S01 — directionality core.
3. S02 — إصلاح Summary/InfoBox وبقية المكونات.
4. S03 — layout blocks.
5. S04 — DataGrid.
6. S05 — formatting/theme.
7. S06 — ERP domain/calculations.
8. S07 — ERP components.
9. S08 — document families.
10. S09 — migrate Quotation/PO/TaxInvoice.

بعد نجاح Checkpoint B فقط، ابدأ S10 وما بعده.

هذا الترتيب هو أهم جزء في الخطة، لأنه يمنع بناء عشرات المطبوعات فوق Directionality/Layout API غير مستقرة.
