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

- [x] **S04-T01** — fixed width.
- [x] **S04-T02** — weighted/flex width.
- [x] **S04-T03** — min/max width.
- [x] **S04-T04** — auto-fit.
- [x] **S04-T05** — text wrapping.
- [x] **S04-T06** — ellipsis/clip policies.
- [x] **S04-T07** — decimal/numeric alignment.

## B — Pagination

- [x] **S04-T08** — repeated headers.
- [x] **S04-T09** — keepRowTogether.
- [x] **S04-T10** — controlled row split policy.
- [x] **S04-T11** — group header repetition.
- [x] **S04-T12** — group footer/subtotal placement.
- [x] **S04-T13** — grand total placement.

## C — Grouping

- [x] **S04-T14** — group headers.
- [x] **S04-T15** — group footers.
- [x] **S04-T16** — subtotals.
- [x] **S04-T17** — grand totals.
- [x] **S04-T18** — nested groups.
- [x] **S04-T19** — tree/hierarchical indentation.
- [x] **S04-T20** — summary expressions contract.

## D — Cell structure

- [x] **S04-T21** — row span.
- [x] **S04-T22** — column span.
- [x] **S04-T23** — conditional row style.
- [x] **S04-T24** — conditional cell style.
- [x] **S04-T25** — row builder.
- [x] **S04-T26** — cell builder.
- [x] **S04-T27** — empty state.

## E — ERP format integration

- [x] **S04-T28** — money formatter hook.
- [x] **S04-T29** — percentage formatter hook.
- [x] **S04-T30** — quantity formatter hook.
- [x] **S04-T31** — date/time formatter hook.
- [x] **S04-T32** — debit/credit semantic style.
- [x] **S04-T33** — negative accounting values.
- [x] **S04-T34** — multi-currency display.

## F — Directionality

- [x] **S04-T35** — تثبيت followDirection/preserveDefinitionOrder.
- [x] **S04-T36** — per-column direction.
- [x] **S04-T37** — RTL grouping indentation.
- [x] **S04-T38** — RTL header/cell padding.
- [ ] **S04-T39** — mixed numeric/text rows.

## G — Performance

- [x] **S04-T40** — very-large-data mode.
- [x] **S04-T41** — lazy row preparation where possible.
- [x] **S04-T42** — cache measured widths.
- [x] **S04-T43** — avoid rebuilding repeated styles.
- [ ] **S04-T44** — benchmark 1k/10k rows حسب حدود البيئة.

## Manual Verification Example

- [x] **S04-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S04-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S04-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S04-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [ ] **S04-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Advanced DataGrid.
- [x] ERP formatter hooks.
- [x] Grouping/subtotals.
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

- [x] **S05-T01** — إضافة `GeniusPdfFormatter` contract.
- [x] **S05-T02** — money formatter.
- [x] **S05-T03** — number formatter.
- [x] **S05-T04** — quantity formatter.
- [x] **S05-T05** — percentage formatter.
- [x] **S05-T06** — date formatter.
- [x] **S05-T07** — time formatter.
- [x] **S05-T08** — identifier formatter.
- [x] **S05-T09** — null placeholder policy.

## B — Locale & accounting

- [x] **S05-T10** — locale-aware separators.
- [x] **S05-T11** — decimal precision rules.
- [x] **S05-T12** — currency code/symbol policy.
- [x] **S05-T13** — accounting negative format.
- [x] **S05-T14** — Arabic/English digit policy.
- [x] **S05-T15** — exchange rate formatting.
- [x] **S05-T16** — unit formatting.

## C — Theme

- [x] **S05-T17** — إضافة `GeniusPdfTheme`.
- [x] **S05-T18** — typography tokens.
- [x] **S05-T19** — spacing tokens.
- [x] **S05-T20** — border tokens.
- [x] **S05-T21** — table theme.
- [x] **S05-T22** — document theme.
- [x] **S05-T23** — semantic colors.
- [x] **S05-T24** — summary/highlight styles.

## D — Directionality-aware styling

- [x] **S05-T25** — logical spacing tokens.
- [x] **S05-T26** — leading/trailing borders عندما يكون ذلك semantic.
- [x] **S05-T27** — RTL/LTR typography alignment defaults.
- [x] **S05-T28** — عدم ربط اللون أو الوزن بالاتجاه.

## E — Migration

- [x] **S05-T29** — إزالة format snippets المكررة من components الأساسية.
- [x] **S05-T30** — إزالة hardcoded amount strings من examples.
- [x] **S05-T31** — توصيل DataGrid وSummary بالـ formatter/theme.
- [x] **S05-T32** — توفير backward-compatible defaults.

## F — Tests/docs

- [x] **S05-T33** — goldens لعملات متعددة.
- [x] **S05-T34** — اختبارات decimal precision.
- [x] **S05-T35** — اختبارات negative/accounting formats.
- [x] **S05-T36** — اختبارات Arabic digits policy.
- [x] **S05-T37** — توثيق أمثلة formatter/theme.

## Manual Verification Example

- [x] **S05-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S05-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S05-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S05-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S05-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Formatting engine.
- [x] Theme/design token model.
- [x] Component integration.
- [x] Formatting test matrix.

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

- [x] **S06-T01** — `ErpDocumentContext`.
- [x] **S06-T02** — `ErpOrganization`.
- [x] **S06-T03** — `ErpBranch`.
- [x] **S06-T04** — `ErpDocumentIdentity`.
- [x] **S06-T05** — `ErpDocumentReference`.
- [x] **S06-T06** — `ErpPrintMetadata`.
- [x] **S06-T07** — `ErpDocumentStatus`.

## B — Parties & addresses

- [x] **S06-T08** — `ErpParty`.
- [x] **S06-T09** — `ErpAddress`.
- [x] **S06-T10** — `ErpTaxIdentity`.
- [x] **S06-T11** — optional contact metadata.
- [x] **S06-T12** — billing/shipping/address roles.

## C — Monetary model

- [x] **S06-T13** — `ErpMoney`.
- [x] **S06-T14** — `ErpCurrency`.
- [x] **S06-T15** — `ErpExchangeRate`.
- [x] **S06-T16** — rounding strategy.
- [x] **S06-T17** — currency precision.
- [x] **S06-T18** — base/document currency separation.

## D — Transaction details

- [x] **S06-T19** — `ErpQuantity`.
- [x] **S06-T20** — `ErpUnit`.
- [x] **S06-T21** — `ErpLineItem`.
- [x] **S06-T22** — `ErpTaxLine`.
- [x] **S06-T23** — `ErpDiscount`.
- [x] **S06-T24** — `ErpCharge`.
- [x] **S06-T25** — `ErpBatchInfo`.
- [x] **S06-T26** — `ErpSerialInfo`.

## E — Approval & attachment

- [x] **S06-T27** — `ErpApproval`.
- [x] **S06-T28** — `ErpSignature`.
- [x] **S06-T29** — `ErpAttachment`.

## F — Calculation service

- [x] **S06-T30** — subtotal calculation.
- [x] **S06-T31** — line discount.
- [x] **S06-T32** — document discount.
- [x] **S06-T33** — charges.
- [x] **S06-T34** — taxable amount.
- [x] **S06-T35** — tax totals.
- [x] **S06-T36** — grand total.
- [x] **S06-T37** — rounding adjustment.
- [x] **S06-T38** — paid/due where applicable.
- [x] **S06-T39** — multi-currency conversion contract.

## G — Validation/tests

- [x] **S06-T40** — immutable/value semantics where appropriate.
- [x] **S06-T41** — input validation.
- [x] **S06-T42** — rounding edge cases.
- [x] **S06-T43** — zero/negative lines where allowed.
- [x] **S06-T44** — multi-tax scenarios.
- [x] **S06-T45** — discount-before/after-tax policies عبر explicit configuration.
- [x] **S06-T46** — serialization only where needed; لا تفرض JSON على domain بلا سبب.

## Manual Verification Example

- [x] **S06-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S06-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S06-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S06-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S06-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] ERP shared domain package layer.
- [x] Typed calculation service.
- [x] Comprehensive calculation tests.

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

- [x] **S07-T01** — `GeniusPdfDocumentIdentity`.
- [x] **S07-T02** — `GeniusPdfPartyBlock`.
- [x] **S07-T03** — `GeniusPdfAddressBlock`.
- [x] **S07-T04** — `GeniusPdfReferenceBlock`.

## B — Financial

- [x] **S07-T05** — `GeniusPdfMoney`.
- [x] **S07-T06** — `GeniusPdfAmountInWords`.
- [x] **S07-T07** — `GeniusPdfTaxSummary`.
- [x] **S07-T08** — discount/charge summary block.
- [x] **S07-T09** — balance/due block.

## C — Operational

- [x] **S07-T10** — `GeniusPdfTermsSection`.
- [x] **S07-T11** — `GeniusPdfApprovalTrail`.
- [x] **S07-T12** — `GeniusPdfStamp`.
- [x] **S07-T13** — `GeniusPdfMetricCards`.
- [x] **S07-T14** — `GeniusPdfLabel`.

## D — Optional sections

- [x] **S07-T15** — كل component يقبل null data حيث منطقي.
- [x] **S07-T16** — null section collapses بالكامل.
- [x] **S07-T17** — لا padding/margin متبقٍ بعد hidden section.
- [x] **S07-T18** — empty lists لها policy واضحة: hide أو empty state.

## E — Directionality

- [x] **S07-T19** — كل component يستخدم start/end.
- [x] **S07-T20** — كل value run يملك direction مناسب.
- [x] **S07-T21** — EN/AR/bilingual examples.
- [x] **S07-T22** — mixed address/phone/ID tests.

## F — Docs

- [x] **S07-T23** — Flutter-style API docs.
- [x] **S07-T24** — usage examples.
- [x] **S07-T25** — composition examples.
- [x] **S07-T26** — do/don't guidance لمنع layout duplication.

## Manual Verification Example

- [x] **S07-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S07-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S07-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S07-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S07-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] ERP semantic component library.
- [x] Null-collapse behavior.
- [x] Directionality goldens.
- [x] Component documentation.

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

- [x] **S08-T01** — `GeniusErpTransactionDocument`.
- [x] **S08-T02** — `GeniusErpStatementDocument`.
- [x] **S08-T03** — `GeniusErpVoucherDocument`.
- [x] **S08-T04** — `GeniusErpAnalyticalReport`.
- [x] **S08-T05** — `GeniusErpOperationalForm`.
- [x] **S08-T06** — `GeniusErpRegisterDocument`.
- [x] **S08-T07** — `GeniusErpThermalReceipt`.
- [x] **S08-T08** — `GeniusErpLabelDocument`.
- [x] **S08-T09** — `GeniusErpCertificateDocument`.

## B — Slots/sections

- [x] **S08-T10** — header slot.
- [x] **S08-T11** — document identity slot.
- [x] **S08-T12** — party slots.
- [x] **S08-T13** — reference slots.
- [x] **S08-T14** — line-items/body slot.
- [x] **S08-T15** — summary slot.
- [x] **S08-T16** — notes/terms slot.
- [x] **S08-T17** — approval/signature slot.
- [x] **S08-T18** — attachments/QR/barcode slot.
- [x] **S08-T19** — footer slot.

## C — Policies

- [x] **S08-T20** — optional section collapse.
- [x] **S08-T21** — page break policy per slot.
- [x] **S08-T22** — first/last page variants.
- [x] **S08-T23** — direction override per slot.
- [x] **S08-T24** — theme override per family.
- [x] **S08-T25** — print profile hook.

## D — Extension model

- [x] **S08-T26** — custom section insertion.
- [x] **S08-T27** — before/after hooks without exposing renderer internals.
- [x] **S08-T28** — component replacement.
- [x] **S08-T29** — data adapter layer.
- [x] **S08-T30** — عدم ربط family بmodule واحد.

## E — Tests/examples

- [x] **S08-T31** — minimal transaction.
- [x] **S08-T32** — full transaction.
- [x] **S08-T33** — statement.
- [x] **S08-T34** — voucher.
- [x] **S08-T35** — analytical report.
- [x] **S08-T36** — RTL/bilingual family examples.
- [x] **S08-T37** — multi-page family examples.

## Manual Verification Example

- [x] **S08-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S08-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S08-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S08-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S08-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Generic document family layer.
- [x] Extension/slot contract.
- [x] Examples for each family.

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

- [x] **S09-T01** — تحويله إلى Transaction family.
- [x] **S09-T02** — استخدام shared identity/party/items/summary/terms/signatures.
- [x] **S09-T03** — إزالة الحسابات المكررة لصالح calculation layer.
- [x] **S09-T04** — الحفاظ على QR والnotes والterms.

## B — Purchase Order

- [x] **S09-T05** — تحويل vendor/order details إلى shared components.
- [x] **S09-T06** — تحويل items/summary إلى shared implementation.
- [x] **S09-T07** — الحفاظ على shipping/notes/terms/signatures.
- [x] **S09-T08** — عدم كسر constructor/public API إن أمكن.

## C — Tax Invoice

- [x] **S09-T09** — تحويل header/info/items/tax summary إلى shared components.
- [x] **S09-T10** — الحفاظ على amount-in-words.
- [x] **S09-T11** — الحفاظ على VAT details وQR.
- [x] **S09-T12** — التأكد من bilingual/RTL correctness.

## D — Compatibility

- [x] **S09-T13** — Adapters للـ legacy models إن لزم.
- [x] **S09-T14** — deprecation فقط عند وجود بديل واضح.
- [x] **S09-T15** — عدم تغيير output الحسابي.
- [x] **S09-T16** — توثيق أي intentional visual difference ناتج عن إصلاح RTL.

## E — Duplication audit

- [x] **S09-T17** — قياس duplicated code قبل/بعد.
- [x] **S09-T18** — إزالة helpers الخاصة بالقالب إذا أصبحت shared.
- [x] **S09-T19** — منع local formatting/calculation duplicates.

## F — Goldens

- [x] **S09-T20** — EN/LTR لكل قالب.
- [x] **S09-T21** — AR/RTL لكل قالب.
- [x] **S09-T22** — bilingual where supported.
- [x] **S09-T23** — 1/50/500 line scenarios.
- [x] **S09-T24** — long notes/party names.
- [x] **S09-T25** — null optional sections.

## Manual Verification Example

- [x] **S09-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S09-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S09-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S09-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S09-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] 3 migrated templates.
- [x] Compatibility adapters.
- [x] Golden comparison report.
- [x] Duplication audit.

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

- [x] **S10-T01** — Balance Sheet.
- [x] **S10-T02** — Budget Report.
- [x] **S10-T03** — Cash Flow.
- [x] **S10-T04** — Income Statement.
- [x] **S10-T05** — Trial Balance.
- [x] **S10-T06** — Customer Statement.

## B — HR/current operational

- [x] **S10-T07** — Attendance Report.
- [x] **S10-T08** — Employee Report.
- [x] **S10-T09** — Leave Report.
- [x] **S10-T10** — Payslip.

## C — Inventory/delivery

- [x] **S10-T11** — Inventory Report.
- [x] **S10-T12** — Delivery Note.

## D — Voucher consolidation

- [x] **S10-T13** — Accounting Entry Voucher.
- [x] **S10-T14** — Bank Deposit Voucher.
- [x] **S10-T15** — Bank Withdrawal Voucher.
- [x] **S10-T16** — Bill Payment Voucher.
- [x] **S10-T17** — Gift Voucher.
- [x] **S10-T18** — Inventory Voucher.
- [x] **S10-T19** — Modern Voucher.
- [x] **S10-T20** — Payment Voucher.
- [x] **S10-T21** — Purchase Return Voucher.
- [x] **S10-T22** — Purchase Voucher.
- [x] **S10-T23** — Receipt Voucher.
- [x] **S10-T24** — Incoming Remittance Voucher.
- [x] **S10-T25** — Outgoing Remittance Voucher.
- [x] **S10-T26** — Sales Return Voucher.
- [x] **S10-T27** — Sales Voucher.
- [x] **S10-T28** — Tax Voucher.
- [x] **S10-T29** — Transfer Voucher.

## E — Voucher architecture

- [x] **S10-T30** — توحيد account entries table.
- [x] **S10-T31** — توحيد party/payment details.
- [x] **S10-T32** — توحيد amount highlight.
- [x] **S10-T33** — توحيد amount-in-words.
- [x] **S10-T34** — توحيد signature/notes/footer/page border.
- [x] **S10-T35** — الإبقاء على voucher-specific fields كconfiguration/extension.

## F — Cleanup

- [x] **S10-T36** — إزالة duplicated private render helpers.
- [x] **S10-T37** — تحديث template registry.
- [x] **S10-T38** — تحديث examples.
- [x] **S10-T39** — تحديث docs.
- [x] **S10-T40** — goldens لكل template EN/AR حيث ينطبق.

## Manual Verification Example

- [x] **S10-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S10-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S10-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S10-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S10-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] All current templates mapped to families.
- [x] Unified voucher implementation.
- [x] Updated template registry/examples/docs.

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

- [x] **S11-T01** — A4 portrait.
- [x] **S11-T02** — A4 landscape.
- [x] **S11-T03** — A5.
- [x] **S11-T04** — Letter.
- [x] **S11-T05** — Legal.
- [x] **S11-T06** — 58mm thermal.
- [x] **S11-T07** — 80mm thermal.
- [x] **S11-T08** — continuous paper.
- [x] **S11-T09** — custom label.
- [x] **S11-T10** — label sheet.
- [x] **S11-T11** — pre-printed form.

## B — Profile properties

- [x] **S11-T12** — page dimensions.
- [x] **S11-T13** — margins.
- [x] **S11-T14** — safe area.
- [x] **S11-T15** — density.
- [x] **S11-T16** — default font scale.
- [x] **S11-T17** — header/footer policy.
- [x] **S11-T18** — cut spacing.
- [x] **S11-T19** — label gaps.
- [x] **S11-T20** — copies/original-copy metadata.

## C — Thermal receipt engine

- [x] **S11-T21** — compact typography.
- [x] **S11-T22** — variable-height content.
- [x] **S11-T23** — minimal margins.
- [x] **S11-T24** — QR/barcode placement.
- [x] **S11-T25** — receipt totals.
- [x] **S11-T26** — cash/payment lines.
- [x] **S11-T27** — RTL thermal layout.

## D — Labels

- [x] **S11-T28** — single label.
- [x] **S11-T29** — sheet grid.
- [x] **S11-T30** — gap/bleed handling.
- [x] **S11-T31** — barcode/QR.
- [x] **S11-T32** — SKU/batch/serial/expiry.
- [x] **S11-T33** — RTL/English captions.
- [x] **S11-T34** — print calibration offsets.

## E — Pre-printed

- [x] **S11-T35** — physical-coordinate opt-in.
- [x] **S11-T36** — field anchor positions.
- [x] **S11-T37** — no logical mirroring when profile explicitly requires physical placement.
- [x] **S11-T38** — calibration test page.

## Manual Verification Example

- [x] **S11-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S11-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S11-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S11-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S11-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] `GeniusPdfPrintProfile`.
- [x] Thermal receipt foundation.
- [x] Label foundation.
- [x] Calibration example.

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

- [x] **S12-T01** — Sales Order.
- [x] **S12-T02** — Proforma Invoice.
- [x] **S12-T03** — Simplified/POS Invoice.
- [x] **S12-T04** — Debit Note.
- [x] **S12-T05** — Sales Return Document.
- [x] **S12-T06** — Customer Receipt.

## B — Fulfillment

- [x] **S12-T07** — Picking List.
- [x] **S12-T08** — Packing List.
- [x] **S12-T09** — Backorder document/report.

## C — Statements/reports

- [x] **S12-T10** — Customer Aging.
- [x] **S12-T11** — Sales Register.
- [x] **S12-T12** — Sales by Customer.
- [x] **S12-T13** — Sales by Item.
- [x] **S12-T14** — Sales by Salesperson.
- [x] **S12-T15** — Price List.
- [x] **S12-T16** — Commission Report.

## D — Shared behaviors

- [x] **S12-T17** — discounts/charges/taxes.
- [x] **S12-T18** — multi-currency.
- [x] **S12-T19** — payment terms.
- [x] **S12-T20** — shipping/delivery references.
- [x] **S12-T21** — original/copy/reprint metadata.
- [x] **S12-T22** — batch/serial fields عند الحاجة.

## E — QA

- [x] **S12-T23** — EN/AR/bilingual.
- [x] **S12-T24** — short/long orders.
- [x] **S12-T25** — multi-page items.
- [x] **S12-T26** — zero/negative return values.
- [x] **S12-T27** — tax inclusive/exclusive configuration.
- [x] **S12-T28** — null optional sections.

## Manual Verification Example

- [x] **S12-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S12-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S12-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S12-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S12-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Sales template pack.
- [x] Sales examples.
- [x] Sales golden matrix.

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

- [x] **S13-T01** — Purchase Requisition.
- [x] **S13-T02** — Request for Quotation (RFQ).
- [x] **S13-T03** — Supplier Quotation.
- [x] **S13-T04** — Quotation Comparison.

## B — Order/receipt/invoice

- [x] **S13-T05** — Purchase Order.
- [x] **S13-T06** — Goods Receipt Note (GRN).
- [x] **S13-T07** — Purchase Invoice.
- [x] **S13-T08** — Purchase Debit/Credit Note حسب model.
- [x] **S13-T09** — Supplier Return.

## C — Supplier statements

- [x] **S13-T10** — Supplier Statement.
- [x] **S13-T11** — Supplier Aging.
- [x] **S13-T12** — Purchase Register.
- [x] **S13-T13** — Purchase Analysis.
- [x] **S13-T14** — Outstanding Purchase Orders.

## D — Shared behaviors

- [x] **S13-T15** — vendor addresses/tax IDs.
- [x] **S13-T16** — expected delivery.
- [x] **S13-T17** — warehouse/site reference.
- [x] **S13-T18** — landed charges hooks.
- [x] **S13-T19** — multi-currency/exchange rate.
- [x] **S13-T20** — approval trail.

## E — QA

- [x] **S13-T21** — partial receipt scenarios.
- [x] **S13-T22** — long vendor terms.
- [x] **S13-T23** — multi-page items.
- [x] **S13-T24** — Arabic/English mixed item codes.
- [x] **S13-T25** — tax/discount validation.
- [x] **S13-T26** — null shipping fields.

## Manual Verification Example

- [x] **S13-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S13-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S13-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S13-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S13-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Purchasing pack.
- [x] Supplier statement/aging.
- [x] Comparison document.

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

- [x] **S14-T01** — General Ledger.
- [x] **S14-T02** — Journal Entry.
- [x] **S14-T03** — Journal Register.
- [x] **S14-T04** — Account Statement.

## B — Receivables/payables

- [x] **S14-T05** — AR Aging.
- [x] **S14-T06** — AP Aging.
- [x] **S14-T07** — Customer Balances.
- [x] **S14-T08** — Supplier Balances.

## C — Cash/bank

- [x] **S14-T09** — Cash Book.
- [x] **S14-T10** — Bank Book.
- [x] **S14-T11** — Bank Reconciliation.
- [x] **S14-T12** — Petty Cash.
- [x] **S14-T13** — Payment Register.
- [x] **S14-T14** — Receipt Register.

## D — Tax

- [x] **S14-T15** — VAT/Tax Summary.
- [x] **S14-T16** — Tax Register.
- [x] **S14-T17** — taxable/exempt/zero-rated breakdown configuration.
- [x] **S14-T18** — rounding/reconciliation report.

## E — Cost/project/budget

- [x] **S14-T19** — Cost Center Statement.
- [x] **S14-T20** — Cost Center Trial Balance.
- [x] **S14-T21** — Project Financial Report.
- [x] **S14-T22** — Budget vs Actual.
- [x] **S14-T23** — Multi-period Comparison.

## F — Financial presentation

- [x] **S14-T24** — debit/credit semantic styles.
- [x] **S14-T25** — accounting negatives.
- [x] **S14-T26** — opening/movement/closing balances.
- [x] **S14-T27** — group/subtotal hierarchy.
- [x] **S14-T28** — page-level carry/brought-forward policy where required.

## G — QA

- [x] **S14-T29** — calculation reconciliation tests.
- [x] **S14-T30** — decimal precision tests.
- [x] **S14-T31** — multi-currency tests.
- [x] **S14-T32** — long chart-of-accounts hierarchy.
- [x] **S14-T33** — RTL ledger column policy.
- [x] **S14-T34** — 10k-row performance sample.

## Manual Verification Example

- [x] **S14-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S14-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S14-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S14-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S14-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Accounting pack.
- [x] Reconciliation/calculation tests.
- [x] Hierarchical ledger reports.

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

- [x] **S15-T01** — Stock Receipt.
- [x] **S15-T02** — Stock Issue.
- [x] **S15-T03** — Stock Transfer.
- [x] **S15-T04** — Warehouse Transfer.
- [x] **S15-T05** — Stock Adjustment.

## B — Count docs

- [x] **S15-T06** — Stock Count.
- [x] **S15-T07** — Cycle Count.
- [x] **S15-T08** — variance/count reconciliation.

## C — Reports

- [x] **S15-T09** — Item Card.
- [x] **S15-T10** — Stock Ledger.
- [x] **S15-T11** — Stock Valuation.
- [x] **S15-T12** — Stock Availability.
- [x] **S15-T13** — Reorder Report.
- [x] **S15-T14** — Min/Max Report.
- [x] **S15-T15** — Slow/Dead Stock.

## D — Traceability

- [x] **S15-T16** — Batch Report.
- [x] **S15-T17** — Serial Report.
- [x] **S15-T18** — Expiry Report.
- [x] **S15-T19** — lot/batch references داخل movement docs.

## E — Labels

- [x] **S15-T20** — Item Label.
- [x] **S15-T21** — Shelf Label.
- [x] **S15-T22** — Batch Label.
- [x] **S15-T23** — Serial Label.
- [x] **S15-T24** — Location Label.

## F — QA

- [x] **S15-T25** — multi-unit quantities.
- [x] **S15-T26** — fractional quantities.
- [x] **S15-T27** — large item counts.
- [x] **S15-T28** — long item names.
- [x] **S15-T29** — Arabic item names + Latin SKU.
- [x] **S15-T30** — batch/serial/expiry mixed values.

## Manual Verification Example

- [x] **S15-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S15-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S15-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S15-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S15-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Inventory/WMS pack.
- [x] Traceability reports.
- [x] Label set.

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

- [x] **S16-T01** — 58mm receipt.
- [x] **S16-T02** — 80mm receipt.
- [x] **S16-T03** — Refund Receipt.
- [x] **S16-T04** — Exchange Receipt.
- [x] **S16-T05** — Gift Receipt.

## B — Operations

- [x] **S16-T06** — Kitchen Order Ticket (KOT) كقالب اختياري مناسب للمطاعم.
- [x] **S16-T07** — Shift Open report.
- [x] **S16-T08** — Shift Close report.
- [x] **S16-T09** — X Report.
- [x] **S16-T10** — Z Report.
- [x] **S16-T11** — Cash Drawer report.
- [x] **S16-T12** — Payment Method Summary.

## C — Labels

- [x] **S16-T13** — Barcode label.
- [x] **S16-T14** — Price label.
- [x] **S16-T15** — Promotion label.

## D — Receipt behaviors

- [x] **S16-T16** — tax summary.
- [x] **S16-T17** — discounts/promotions.
- [x] **S16-T18** — cash/change.
- [x] **S16-T19** — multiple payment methods.
- [x] **S16-T20** — QR/barcode.
- [x] **S16-T21** — copy/reprint marker.
- [x] **S16-T22** — compact Arabic typography.

## E — QA

- [x] **S16-T23** — thermal width stress.
- [x] **S16-T24** — very long product names.
- [x] **S16-T25** — Arabic notes under line item.
- [x] **S16-T26** — high item count.
- [x] **S16-T27** — no cut-off at end.
- [x] **S16-T28** — RTL/LTR receipts.

## Manual Verification Example

- [x] **S16-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S16-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S16-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S16-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S16-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] POS/Retail pack.
- [x] 58/80mm golden samples.
- [x] Shift/X/Z reports.

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

- [x] **S17-T01** — Employee Profile.
- [x] **S17-T02** — Employee List.
- [x] **S17-T03** — Employment Contract/Form support where applicable.
- [x] **S17-T04** — Employee Action Form.

## B — Time/attendance

- [x] **S17-T05** — Attendance Report.
- [x] **S17-T06** — Timesheet.
- [x] **S17-T07** — Overtime Report.
- [x] **S17-T08** — Leave Balance.
- [x] **S17-T09** — Leave Request.

## C — Payroll

- [x] **S17-T10** — Payslip.
- [x] **S17-T11** — Payroll Sheet.
- [x] **S17-T12** — Payroll Summary.
- [x] **S17-T13** — Allowances Report.
- [x] **S17-T14** — Deductions Report.
- [x] **S17-T15** — Employee Loan/Advance Report.

## D — Certificates/settlement

- [x] **S17-T16** — Salary Certificate.
- [x] **S17-T17** — Employment Certificate.
- [x] **S17-T18** — Experience Certificate.
- [x] **S17-T19** — End-of-Service calculation/report.
- [x] **S17-T20** — Final Settlement.

## E — Privacy/security

- [x] **S17-T21** — field visibility policies.
- [x] **S17-T22** — masking of sensitive identifiers where configured.
- [x] **S17-T23** — watermark/confidential marker.
- [x] **S17-T24** — role-specific printable variant hooks.

## F — QA

- [x] **S17-T25** — Arabic employee names.
- [x] **S17-T26** — mixed IDs/bank data.
- [x] **S17-T27** — long allowance/deduction lists.
- [x] **S17-T28** — payroll total reconciliation.
- [x] **S17-T29** — certificate single-page constraints.

## Manual Verification Example

- [x] **S17-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S17-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S17-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S17-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S17-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] HR/Payroll pack.
- [x] Certificates.
- [x] Payroll reconciliation tests.

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

- [x] **S18-T01** — Bill of Materials (BOM).
- [x] **S18-T02** — Production Order.
- [x] **S18-T03** — Work Order.
- [x] **S18-T04** — Job Card.
- [x] **S18-T05** — Material Requirement.
- [x] **S18-T06** — Material Issue.
- [x] **S18-T07** — Material Return.
- [x] **S18-T08** — Production Receipt.
- [x] **S18-T09** — Routing/Traveler.
- [x] **S18-T10** — Machine Operation Report.
- [x] **S18-T11** — Labor Report.
- [x] **S18-T12** — Scrap Report.
- [x] **S18-T13** — Work in Progress.
- [x] **S18-T14** — Production Variance.

## B — Quality

- [x] **S18-T15** — Quality Inspection.
- [x] **S18-T16** — Incoming Inspection.
- [x] **S18-T17** — In-process Inspection.
- [x] **S18-T18** — Final Inspection.
- [x] **S18-T19** — Non-Conformance Report (NCR).
- [x] **S18-T20** — Corrective/Preventive Action (CAPA).
- [x] **S18-T21** — Certificate of Analysis (COA).
- [x] **S18-T22** — Quality Checklist.
- [x] **S18-T23** — Audit Form.
- [x] **S18-T24** — Calibration Record.

## C — Shared mechanics

- [x] **S18-T25** — nested operation/material tables.
- [x] **S18-T26** — checklist primitives.
- [x] **S18-T27** — pass/fail/status cells.
- [x] **S18-T28** — measurement/specification/value/tolerance rows.
- [x] **S18-T29** — batch/serial traceability.
- [x] **S18-T30** — approval/sign-off.

## D — QA

- [x] **S18-T31** — multi-level BOM.
- [x] **S18-T32** — long routing.
- [x] **S18-T33** — mixed units.
- [x] **S18-T34** — RTL technical terms + Latin codes.
- [x] **S18-T35** — multi-page checklists.

## Manual Verification Example

- [x] **S18-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S18-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S18-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S18-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S18-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Manufacturing pack.
- [x] Quality pack.
- [x] Checklist/measurement primitives.

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

- [x] **S19-T01** — Asset Card.
- [x] **S19-T02** — Asset Register.
- [x] **S19-T03** — Asset Label.
- [x] **S19-T04** — Asset Transfer.
- [x] **S19-T05** — Asset Assignment.
- [x] **S19-T06** — Asset Return.
- [x] **S19-T07** — Asset Disposal.
- [x] **S19-T08** — Depreciation Report.
- [x] **S19-T09** — Asset Maintenance Report.
- [x] **S19-T10** — Asset Count.
- [x] **S19-T11** — Asset Movement Report.

## B — Projects

- [x] **S19-T12** — Project Summary.
- [x] **S19-T13** — Project Budget.
- [x] **S19-T14** — Project Cost.
- [x] **S19-T15** — Project Profitability.
- [x] **S19-T16** — Project Timesheet.
- [x] **S19-T17** — Project Expense Report.
- [x] **S19-T18** — Milestone Report.
- [x] **S19-T19** — Progress Report.
- [x] **S19-T20** — Completion Certificate.
- [x] **S19-T21** — Project Billing.
- [x] **S19-T22** — Resource Utilization.
- [x] **S19-T23** — Project Purchasing Report.

## C — QA

- [x] **S19-T24** — asset serial/tag BiDi.
- [x] **S19-T25** — label profiles.
- [x] **S19-T26** — depreciation reconciliation.
- [x] **S19-T27** — multi-period project financials.
- [x] **S19-T28** — long milestone notes.
- [x] **S19-T29** — Arabic/English project codes.

## Manual Verification Example

- [x] **S19-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S19-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S19-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S19-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S19-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Fixed Assets pack.
- [x] Projects pack.
- [x] Asset labels/certificates.

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

- [x] **S20-T01** — Service Order.
- [x] **S20-T02** — Maintenance Work Order.
- [x] **S20-T03** — Preventive Maintenance Schedule.
- [x] **S20-T04** — Maintenance Checklist.
- [x] **S20-T05** — Technician Report.
- [x] **S20-T06** — Service Completion Report.
- [x] **S20-T07** — Spare Parts Usage.
- [x] **S20-T08** — Warranty Report.
- [x] **S20-T09** — Inspection Report.
- [x] **S20-T10** — Calibration/Service History.

## B — Logistics

- [x] **S20-T11** — Shipment Document.
- [x] **S20-T12** — Packing List variant.
- [x] **S20-T13** — Dispatch Note.
- [x] **S20-T14** — Waybill.
- [x] **S20-T15** — Manifest.
- [x] **S20-T16** — Trip Sheet.
- [x] **S20-T17** — Trip Report.
- [x] **S20-T18** — Shipping Label.
- [x] **S20-T19** — Pallet Label.
- [x] **S20-T20** — Container List.
- [x] **S20-T21** — Freight Summary.
- [x] **S20-T22** — Proof of Delivery.

## C — Shared mechanics

- [x] **S20-T23** — route/reference blocks.
- [x] **S20-T24** — vehicle/driver/technician identity blocks.
- [x] **S20-T25** — checklists.
- [x] **S20-T26** — signature/proof blocks.
- [x] **S20-T27** — geo/time metadata fields.
- [x] **S20-T28** — attachments/photos reference slots.

## D — QA

- [x] **S20-T29** — multi-stop manifests.
- [x] **S20-T30** — long shipment items.
- [x] **S20-T31** — Arabic addresses + Latin tracking numbers.
- [x] **S20-T32** — label/thermal profiles.
- [x] **S20-T33** — proof-of-delivery signatures.

## Manual Verification Example

- [x] **S20-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S20-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S20-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S20-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S20-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Maintenance/Service pack.
- [x] Logistics pack.
- [x] Shipping/pallet labels.

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

- [x] **S21-T01** — Customer Profile.
- [x] **S21-T02** — Lead Report.
- [x] **S21-T03** — Opportunity Report.
- [x] **S21-T04** — Pipeline Report.
- [x] **S21-T05** — Activity Report.
- [x] **S21-T06** — Visit Report.
- [x] **S21-T07** — Call Report.
- [x] **S21-T08** — Customer History.
- [x] **S21-T09** — Proposal.
- [x] **S21-T10** — Contract summary/document shell.

## B — Presentation

- [x] **S21-T11** — metric cards.
- [x] **S21-T12** — stage/status visualization without depending on charts only.
- [x] **S21-T13** — timeline/history list.
- [x] **S21-T14** — contact/party blocks.
- [x] **S21-T15** — attachments/reference list.

## C — QA

- [x] **S21-T16** — long activity histories.
- [x] **S21-T17** — Arabic notes + Latin emails/phones.
- [x] **S21-T18** — pipeline totals.
- [x] **S21-T19** — multi-page proposals.
- [x] **S21-T20** — confidential watermark variants.

## Manual Verification Example

- [x] **S21-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S21-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S21-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S21-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S21-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] CRM pack.
- [x] Customer-history/timeline components where reusable.
- [x] Proposal/contract shells.

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

- [x] **S22-T01** — إضافة explicit schemaVersion.
- [x] **S22-T02** — تعريف migration strategy بين schema versions.
- [x] **S22-T03** — validation errors قابلة للفهم.
- [x] **S22-T04** — backward compatibility للـ current definitions.

## B — New elements

- [x] **S22-T05** — Component.
- [x] **S22-T06** — Section.
- [x] **S22-T07** — PageBreak.
- [x] **S22-T08** — Barcode.
- [x] **S22-T09** — QRCode.
- [x] **S22-T10** — Signature.
- [x] **S22-T11** — Summary.
- [x] **S22-T12** — Metric.
- [x] **S22-T13** — Chart.
- [x] **S22-T14** — Attachment.
- [x] **S22-T15** — Stamp.
- [x] **S22-T16** — Label.
- [x] **S22-T17** — Group.
- [x] **S22-T18** — SubTemplate.

## C — Expression engine

- [x] **S22-T19** — safe nested property access.
- [x] **S22-T20** — arithmetic.
- [x] **S22-T21** — boolean/null-safe conditions.
- [x] **S22-T22** — aggregates.
- [x] **S22-T23** — group aggregates.
- [x] **S22-T24** — formatters.
- [x] **S22-T25** — localization keys.
- [x] **S22-T26** — no arbitrary code execution.

## D — Composition

- [x] **S22-T27** — subtemplates.
- [x] **S22-T28** — inheritance/composition.
- [x] **S22-T29** — named reusable components.
- [x] **S22-T30** — style inheritance.
- [x] **S22-T31** — document-family binding.

## E — Registry/versioning

- [x] **S22-T32** — TemplateId.
- [x] **S22-T33** — TemplateVersion.
- [x] **S22-T34** — TemplatePack.
- [x] **S22-T35** — Variant.
- [x] **S22-T36** — Locale.
- [x] **S22-T37** — Country.
- [x] **S22-T38** — Organization.
- [x] **S22-T39** — Branch.
- [x] **S22-T40** — EffectiveFrom/EffectiveTo.
- [x] **S22-T41** — fallback hierarchy.
- [x] **S22-T42** — draft/published state.
- [x] **S22-T43** — history/checksum/rollback.

## F — Directionality

- [x] **S22-T44** — direction property في schema.
- [x] **S22-T45** — element override.
- [x] **S22-T46** — component inheritance.
- [x] **S22-T47** — bilingual nested sections.
- [x] **S22-T48** — value-direction formatting.

## G — Tests/security

- [x] **S22-T49** — invalid expression tests.
- [x] **S22-T50** — schema migration tests.
- [x] **S22-T51** — unknown element tests.
- [x] **S22-T52** — large-loop tests.
- [x] **S22-T53** — no renderer-specific objects in serialized schema.

## Manual Verification Example

- [x] **S22-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S22-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S22-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S22-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S22-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Template Engine vNext.
- [x] Versioned schema.
- [x] Safe expression engine.
- [x] Template registry/versioning.

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

- [x] **S23-T01** — `GeniusPdfComplianceProfile`.
- [x] **S23-T02** — country/tenant plugin contract.
- [x] **S23-T03** — required-field validation hooks.
- [x] **S23-T04** — structured QR payload hooks.
- [x] **S23-T05** — original/copy/reprint policies.

## B — Security/signing

- [x] **S23-T06** — business approval منفصل عن cryptographic signature.
- [x] **S23-T07** — signing metadata model.
- [x] **S23-T08** — certificate signature integration contract.
- [x] **S23-T09** — timestamp integration contract.
- [x] **S23-T10** — document hash metadata.
- [x] **S23-T11** — UUID/document fingerprint.

## C — Archival/document metadata

- [x] **S23-T12** — XMP metadata abstraction.
- [x] **S23-T13** — embedded attachments hook.
- [x] **S23-T14** — archive profile capability flags.
- [x] **S23-T15** — source transaction/audit metadata.
- [x] **S23-T16** — document generation timestamp/version.

## D — Existing security integration

- [x] **S23-T17** — توحيد encryption/password/permissions مع higher-level policy.
- [x] **S23-T18** — عدم كسر current security service.
- [x] **S23-T19** — اختبارات protected/unprotected flows.

## E — Compliance packs

- [x] **S23-T20** — بناء framework فقط للـ jurisdiction-specific requirements.
- [x] **S23-T21** — عدم hardcode قوانين دولة داخل base templates.
- [x] **S23-T22** — كل country profile له version/effective date.
- [x] **S23-T23** — توثيق أن المتطلبات القانونية يجب تحديثها حسب المصدر الرسمي وقت التنفيذ.

## Manual Verification Example

- [x] **S23-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S23-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S23-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S23-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S23-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Compliance plugin architecture.
- [x] Signing/audit metadata layer.
- [x] Archival capability abstraction.

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

- [x] **S24-T01** — baseline لكل document family.
- [x] **S24-T02** — cache fonts/resources حيث آمن.
- [x] **S24-T03** — cache images/barcodes/QR where appropriate.
- [x] **S24-T04** — avoid repeated measurement.
- [x] **S24-T05** — large-grid memory profiling.
- [x] **S24-T06** — background generation benchmark.
- [x] **S24-T07** — batch generation benchmark.

## B — Visual regression

- [x] **S24-T08** — goldens لكل component أساسي.
- [x] **S24-T09** — goldens لكل family.
- [x] **S24-T10** — goldens لكل core ERP pack.
- [x] **S24-T11** — EN/LTR.
- [x] **S24-T12** — AR/RTL.
- [x] **S24-T13** — bilingual.
- [x] **S24-T14** — thermal.
- [x] **S24-T15** — labels.

## C — Semantic regression

- [x] **S24-T16** — text extraction checks.
- [x] **S24-T17** — document number.
- [x] **S24-T18** — party.
- [x] **S24-T19** — totals.
- [x] **S24-T20** — tax.
- [x] **S24-T21** — page number.
- [x] **S24-T22** — currency.
- [x] **S24-T23** — required compliance metadata where configured.

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

- [x] **S24-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S24-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S24-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S24-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S24-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Release regression matrix.
- [x] Performance report.
- [x] Quality gate checklist.
- [x] Updated architecture/docs.

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

- [x] **S25-T01** — تعريف designer document state فوق Template Engine vNext.
- [x] **S25-T02** — drag/drop component metadata.
- [x] **S25-T03** — properties panel schema.
- [x] **S25-T04** — style editor schema.
- [x] **S25-T05** — data binding editor.

## B — Preview

- [x] **S25-T06** — sample data preview.
- [x] **S25-T07** — EN/AR direction switch.
- [x] **S25-T08** — bilingual preview.
- [x] **S25-T09** — page profile switch.
- [x] **S25-T10** — multi-page preview.
- [x] **S25-T11** — validation messages.

## C — Authoring

- [x] **S25-T12** — tables.
- [x] **S25-T13** — sections.
- [x] **S25-T14** — conditions.
- [x] **S25-T15** — expressions.
- [x] **S25-T16** — subtemplates.
- [x] **S25-T17** — components.
- [x] **S25-T18** — styles.
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

- [x] **S25-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S25-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S25-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S25-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S25-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Designer-ready schema/UI contract.
- [x] Preview/validation workflow.
- [x] Publish/version lifecycle.

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

- [x] **S26-T01** — تعريف package/plugin boundaries.
- [x] **S26-T02** — template pack manifest.
- [x] **S26-T03** — required domain extensions.
- [x] **S26-T04** — optional compliance hooks.
- [x] **S26-T05** — version compatibility rules.

## B — Retail

- [x] **S26-T06** — retail-specific labels/promotions/receipts فوق POS pack.
- [x] **S26-T07** — لا تكرار core POS.

## C — Restaurant

- [x] **S26-T08** — KOT variants.
- [x] **S26-T09** — table/order tickets.
- [x] **S26-T10** — kitchen sections.
- [x] **S26-T11** — delivery receipt variants.

## D — Construction/Real Estate

- [x] **S26-T12** — progress certificates.
- [x] **S26-T13** — measurement/BOQ-style reports.
- [x] **S26-T14** — property/unit/customer documents.
- [x] **S26-T15** — project billing extensions.

## E — Healthcare/Education

- [x] **S26-T16** — industry report shells فقط حيث لا تتطلب domain regulated غير مدروس.
- [x] **S26-T17** — استخدام plugin-specific models وعدم إضافتها إلى core.

## F — Automotive/Distribution/Hospitality

- [x] **S26-T18** — service/vehicle variants.
- [x] **S26-T19** — route/distribution variants.
- [x] **S26-T20** — guest/folio operational variants.
- [x] **S26-T21** — إعادة استخدام service/logistics/transaction families.

## G — Governance

- [ ] **S26-T22** — كل pack يملك owner/version.
- [ ] **S26-T23** — كل pack يملك EN/AR tests عند الدعم.
- [ ] **S26-T24** — كل pack يعلن dependencies.
- [ ] **S26-T25** — لا pack يعدل core renderer مباشرة.

## Manual Verification Example

- [x] **S26-VX01** — إنشاء/تحديث شاشة تحقق مخصصة لهذا الـ Sprint داخل `example/lib/features/dashboard/presentation/pages` تعرض عمليًا كل ما تمت إضافته أو تطويره.
- [x] **S26-VX02** — إضافة الشاشة إلى Dashboard/navigation الخاصة بتطبيق المثال لتكون قابلة للفتح مباشرة.
- [x] **S26-VX03** — تضمين scenarios كافية للتحقق اليدوي من المنطق، بما فيها الحالات الطبيعية والحدّية وLTR/RTL وnull/long-content/multi-page عندما تنطبق على هذا الـ Sprint.
- [x] **S26-VX04** — جعل الشاشة تستخدم implementation/public API الحقيقي للمكتبة مع Preview/Generate للـ PDF عندما يكون الـ Sprint متعلقًا بالرسم أو المستندات.
- [x] **S26-VX05** — كتابة Expected Result مختصر وواضح لكل scenario مهم داخل شاشة المثال حتى يمكن مقارنة الناتج يدويًا.

## Deliverables

- [x] Plugin/pack contract.
- [x] Initial vertical pack skeletons.
- [x] Governance documentation.

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
