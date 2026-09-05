# Genius Link PDF Generator — ERP Printing Roadmap

> هدف الوثيقة: تحويل `genius_link_pdf_generator` من مكتبة PDF قوية مع مجموعة قوالب جاهزة إلى **منصة طباعة ERP عامة وقابلة للتوسع** تغطي المستندات التشغيلية والمالية والإدارية والحرارية والملصقات والتقارير، مع الحفاظ قدر الإمكان على التوافق مع الـ API الحالي.

## 1. الملخص التنفيذي

المكتبة الحالية تملك أساسًا جيدًا بالفعل:

- `GeniusPdfDocumentBuilder` مع تتبع `currentY` وكسر صفحات تلقائي.
- `GeniusPdfReportComposer` لبناء التقارير بأسلوب Fluent API.
- دعم RTL/LTR والعربية.
- مكونات قابلة لإعادة الاستخدام مثل:
  - `GeniusPdfDataGrid`
  - `GeniusPdfRichText`
  - `GeniusPdfInfoBox`
  - `GeniusPdfReportHeader`
  - `GeniusPdfSummarySection`
  - التواقيع وQR والباركود والعلامات المائية والتوقيع الرقمي.
- Template Engine قائم على JSON ويدعم:
  - text / variable
  - spacer / divider
  - container
  - row / column
  - loop / conditional
  - table
  - image
- خدمات generation / preview / save / open / share / print.
- عمليات معالجة PDF.
- Security service للتشفير والصلاحيات.
- مجموعة قوالب ERP فعلية تغطي أجزاء من:
  - المبيعات
  - المحاسبة
  - المخزون
  - الموارد البشرية
  - السندات المالية.

لكن للوصول إلى هدف **"دعم كل أنواع المطبوعات في أنظمة ERP"** لا أنصح بالاستمرار بإضافة قالب مستقل لكل حالة مباشرة.

الاتجاه الأفضل هو:

1. تقوية محرك التخطيط والطباعة أولًا.
2. إنشاء **ERP Document Domain Model** موحد.
3. إنشاء مكونات ERP عالية المستوى فوق المكونات الحالية.
4. إنشاء عدد محدود من **عائلات القوالب العامة**.
5. بناء Template Packs حسب الوحدة: Sales / Purchasing / Inventory / Accounting / HR / Manufacturing / POS / Assets / Projects / Service / Logistics / Quality.
6. جعل الاختلاف بين مستند وآخر يعتمد على البيانات والتكوين أكثر من نسخ كود القالب.

---

# 2. التقييم الحالي

## 2.1 نقاط القوة الحالية

### Builder

`GeniusPdfDocumentBuilder` يحتوي على أساس مهم جدًا لمنصة ERP:

- إدارة الصفحات.
- معرفة المساحة المتبقية.
- Header/Footer reservation.
- Auto page-break.
- رسم نصوص وصور ومكونات.
- تحديث الموضع بعد العناصر متعددة الصفحات.
- دعم اتجاه المستند.

هذا يجعل من الأفضل **تطوير Builder الحالي** بدل استبداله.

### Fluent Composer

`GeniusPdfReportComposer` يقدم API جيدًا للتقارير البسيطة والمتوسطة:

- header/footer
- text/rich text
- sections
- grid
- summary
- info box
- two-column layout
- QR
- images
- attachments
- custom actions

يجب تطويره ليصبح Composer يعتمد على **Blocks/Bands** بدل أن يبقى Queue من callbacks فقط.

### Components

المكونات الحالية توفر معظم primitives الأساسية، خصوصًا:

- DataGrid
- InfoBox
- ReportHeader
- Summary
- RichText
- Barcode/QR
- Watermark
- Digital Signature

لكنها ما زالت أقرب إلى **PDF UI Components** منها إلى **ERP Document Components**.

### Template Engine

وجود `TemplateDefinition` مع JSON serialization وvariables وconditions وloops خطوة مهمة جدًا.

هذا الجزء يمكن أن يصبح مستقبلًا أساس:

- Template Designer
- Remote templates
- Customer-specific layouts
- Versioned templates
- White-label ERP printing

لكن قبل ذلك يحتاج إلى توسيع في التعبيرات، التنسيق، التجميع، الحقول المالية، page flow، validation، والإصدارات.

### القوالب الموجودة

المكتبة لديها تغطية جيدة كبداية، ومنها:

- Tax Invoice
- Quotation
- Purchase Order
- Credit Note
- Delivery Note
- Customer Statement
- Trial Balance
- Balance Sheet
- Income Statement
- Cash Flow
- Budget Report
- Inventory Report
- Employee Report
- Attendance Report
- Leave Report
- Payslip
- مجموعة واسعة من Vouchers

هذا يعني أن المطلوب ليس البدء من الصفر، بل **إعادة تنظيم القوالب الحالية حول طبقة ERP مشتركة**.

---

# 3. المبدأ المعماري المقترح

## لا تجعل كل مطبوع Class مستقلًا بالكامل

بدلًا من:

```text
TaxInvoiceTemplate
PurchaseInvoiceTemplate
SalesInvoiceTemplate
SalesOrderTemplate
PurchaseOrderTemplate
ProformaInvoiceTemplate
...
```

مع تكرار Header + Party + Items + Totals + Notes + Signatures في كل ملف، أقترح:

```text
ERP Document Engine
│
├── Document Families
│   ├── TransactionDocument
│   ├── StatementDocument
│   ├── VoucherDocument
│   ├── AnalyticalReport
│   ├── OperationalForm
│   ├── RegisterDocument
│   ├── ThermalReceipt
│   ├── LabelDocument
│   └── CertificateDocument
│
├── ERP Components
│
├── ERP Domain Models
│
└── Template Packs
    ├── Sales
    ├── Purchasing
    ├── Inventory
    ├── Accounting
    ├── HR
    ├── Manufacturing
    ├── POS
    ├── Assets
    ├── Projects
    ├── Service
    ├── Logistics
    └── Quality
```

وبذلك يصبح `TaxInvoiceTemplate` مثلًا مجرد تكوين لـ `TransactionDocument`.

---

# 4. سلم الأولويات

| الأولوية | المعنى |
|---|---|
| **P0** | أساس يجب تنفيذه قبل توسيع مكتبة القوالب |
| **P1** | مطلوب لتغطية ERP العامة في الإنتاج |
| **P2** | مطلوب للوحدات المتقدمة والعمليات المتخصصة |
| **P3** | قدرات Enterprise / Compliance / Designer |
| **P4** | Vertical Packs لصناعات متخصصة |

---

# 5. P0 — التحسينات الأساسية المطلوبة

## P0.0 — توحيد Directionality وRTL/LTR قبل أي توسع جديد

هذه نقطة **Blocker** ويجب تنفيذها قبل إضافة عائلات وقوالب ERP جديدة.

المشكلة الظاهرة في `Summary` العربي ليست مشكلة تشكيل نص عربي فقط، بل مشكلة فصل غير صحيح بين:

1. **Layout Direction** — ترتيب العناصر والأعمدة من `start` إلى `end`.
2. **Text Direction** — اتجاه تشكيل وقراءة النص نفسه.
3. **Text Alignment** — محاذاة النص داخل المساحة المتاحة.
4. **Value Direction** — اتجاه القيم ذات البنية الثابتة مثل الأرقام والعملات والـ SKU والـ IBAN والبريد والهاتف.

في المثال الإنجليزي الحالي:

```text
Subtotal                         13,650.00 SAR
Tax (VAT)                         2,047.50 SAR
Grand Total                      15,697.50 SAR
```

هذا صحيح في LTR.

أما في العربية، فلا يكفي جعل النص نفسه RTL مع الإبقاء على ترتيب خلايا الصف LTR. السلوك المطلوب منطقيًا هو:

```text
13,650.00 SAR                         المجموع الفرعي
 2,047.50 SAR                            الضريبة (VAT)
15,697.50 SAR                         الإجمالي النهائي
```

أي:

- `label` يكون في **logical start**، وهو الجانب الأيمن في RTL.
- `value` يكون في **logical end**، وهو الجانب الأيسر في RTL.
- الأرقام وقيمة العملة نفسها تبقى في run باتجاه LTR حتى لا ينعكس ترتيب الأرقام أو رمز العملة.
- لا يتم عكس النصوص يدويًا ولا استخدام `String.reversed`.
- يجب أن يتم **mirroring للـ layout** بدل محاولة إصلاح المشكلة بمحاذاة النص فقط.

### API موحد مقترح

إضافة abstractions مملوكة للمكتبة بدل توزيع منطق الاتجاه داخل كل Widget/Template:

- `GeniusPdfDirection`
  - `auto`
  - `ltr`
  - `rtl`
- `GeniusPdfDirectionality`
- `GeniusPdfDirectionResolver`
- `GeniusPdfDirectionalAlignment`
- `GeniusPdfDirectionalInsets`
- `GeniusPdfDirectionalPosition`
- `GeniusPdfTextRunDirection`
- `GeniusPdfValueDirectionPolicy`

يجب أن يحدد `GeniusPdfDirectionality` على الأقل:

- document/layout direction.
- default text direction.
- locale.
- whether logical layout mirroring is enabled.
- numeric/value direction policy.
- mixed-content/BiDi policy.

### ترتيب Resolution

يتم تحديد الاتجاه بالترتيب التالي، من الأعلى أولوية إلى الأقل:

1. element override.
2. component override.
3. template override.
4. document context.
5. locale-derived default.

وبذلك يمكن أن تكون الصفحة عربية RTL بينما يوجد داخلها:

- رقم فاتورة LTR.
- IBAN LTR.
- بريد إلكتروني LTR.
- SKU/Barcode value LTR.
- اسم أو ملاحظة إنجليزية LTR.
- block ثنائي اللغة يحدد اتجاهه بشكل مستقل.

### قاعدة أساسية

كل APIs الخاصة بالموقع يجب أن تستخدم semantics من نوع:

- `start`
- `end`
- `leading`
- `trailing`

بدل الاعتماد المباشر على:

- `left`
- `right`

إلا عندما يكون الموضع **physical** مقصودًا صراحة، مثل موضع علامة مائية محددة هندسيًا.

---

### إصلاح `GeniusPdfSummary`

يجب أن يدعم `Summary`:

- layout mirroring الكامل عند RTL.
- بقاء العمود الدلالي `label` في logical start.
- بقاء العمود الدلالي `value` في logical end.
- محاذاة مستقلة لكل من label/value.
- `valueDirection = ltr` افتراضيًا للأرقام والعملات.
- دعم labels عربية وقيم رقمية/عملات مختلطة.
- دعم عنوان إنجليزي داخل Summary عربي بدون كسر التخطيط.
- دعم `direction` override على مستوى Summary.
- عدم ترك مساحات عند null/hidden rows.
- نفس السلوك في subtotal/tax/discount/charges/grand total.

**Golden إلزامي:**

- English/LTR.
- Arabic/RTL.
- Arabic label + Latin currency.
- Arabic label + Arabic currency text.
- mixed Arabic/English label.
- negative amount.
- percentage.
- long label wrapping.

---

### إصلاح `GeniusPdfInfoBox`

يجب أن يكون `InfoBox` direction-aware في:

- عنوان الصندوق.
- subtitle.
- label/value rows.
- icon position.
- leading/trailing accessories.
- padding start/end.
- multi-column ordering.
- nested content.
- mixed-direction values.

في RTL:

- `leading` ينتقل بصريًا إلى اليمين.
- `trailing` ينتقل بصريًا إلى اليسار.
- key/value row يتم mirroring له.
- القيم الرقمية والمعرفات يمكن أن تبقى LTR.
- لا يتم ربط direction بمحاذاة واحدة ثابتة.

---

### إصلاح باقي المكونات

#### `GeniusPdfReportHeader`

- عكس ترتيب company/document blocks عند الحاجة.
- logo position يعتمد على leading/trailing.
- document metadata يتبع layout direction.
- الرقم والتاريخ والمعرفات تملك value direction مستقل.
- العناوين الثنائية اللغة لا تغير اتجاه الصفحة بالكامل.

#### `GeniusPdfDataGrid`

إضافة سياسة واضحة لترتيب الأعمدة:

- `followDirection`
- `preserveDefinitionOrder`

ويجب أن يدعم كل column:

- content direction.
- header direction.
- alignment.
- formatter.
- numeric LTR policy.
- logical padding.

الافتراضي في مستندات ERP الموجهة RTL يجب أن يكون منطقيًا، مع إمكانية تثبيت ترتيب الأعمدة عند وجود نموذج تنظيمي يتطلب ترتيبًا physical محددًا.

#### `GeniusPdfRichText`

- direction لكل run عند الحاجة.
- mixed Arabic/Latin content.
- isolation للأرقام والمعرفات.
- عدم عكس علامات الترقيم بطريقة خاطئة.

#### `GeniusPdfSignatureArea`

- mirror signer blocks.
- استخدام leading/trailing.
- عدم عكس صورة التوقيع نفسها.
- دعم أسماء عربية مع ألقاب/معرفات إنجليزية.

#### QR / Barcode

- الصورة/الرمز نفسه **لا يتم mirroring له**.
- caption فقط يتبع direction.
- encoded payload لا يتم تغييره بسبب RTL.
- القيمة النصية الظاهرة يمكن تثبيتها LTR.

#### Watermark / Stamp

- دعم logical position عند استخدام `start/end`.
- عدم قلب الرسم أو الصورة.
- physical positioning يبقى متاحًا عند الحاجة.

#### Two-column layouts

- columns تتبع layout direction افتراضيًا.
- توفير `preservePhysicalOrder` عند الحاجة.
- nested blocks ترث context الصحيح.

---

### قواعد BiDi للقيم الخاصة بـ ERP

يجب توفير policy واضحة للقيم التالية:

- money.
- percentage.
- quantity.
- dates.
- times.
- invoice/document numbers.
- SKU.
- barcode values.
- serial numbers.
- batch numbers.
- IBAN.
- SWIFT/BIC.
- tax IDs.
- phone numbers.
- email.
- URLs.

هذه القيم يجب ألا تتشوّه عند وضعها داخل RTL paragraph.

لا يتم إصلاحها بعكس string، وإنما بعزل run واتجاهه بشكل صحيح.

---

### اتجاه القوالب الثنائية اللغة

دعم bilingual يجب ألا يعني direction واحد لكل المستند فقط.

يجب دعم:

- LTR document مع Arabic block RTL.
- RTL document مع English block LTR.
- bilingual header.
- bilingual table headers.
- bilingual notes.
- bilingual terms.
- bilingual amount-in-words.
- nested component direction override.

---

### Directionality Contract

كل Component جديد يجب أن يلتزم بالعقد التالي:

- لا يستخدم `left/right` عندما تكون الدلالة `start/end`.
- لا يفترض أن `textDirection == layoutDirection`.
- لا يفترض أن numeric content يتبع لغة label.
- يرث direction من context.
- يسمح override موضعيًا.
- يمرر direction إلى children.
- لا يعكس image/barcode/QR payload.
- لا يعكس string يدويًا.
- يملك Golden على الأقل لـ LTR وRTL.
- يملك test لمحتوى mixed-direction إذا كان يعرض قيم ERP.

**الأولوية: P0 / Blocker**

---

## P0.1 — إنشاء ERP Document Domain Model موحد

### الحالة الحالية

الكثير من القوالب تعرف Models خاصة بها، وهذا يؤدي إلى تكرار مفاهيم مثل:

- Company
- Customer/Vendor
- Address
- Document number/date
- Currency
- Lines
- Taxes
- Totals
- Notes
- Signatures

### المطلوب

إنشاء نماذج محايدة لا ترتبط بقالب واحد.

### النماذج المقترحة

```text
ErpDocumentContext
ErpOrganization
ErpBranch
ErpParty
ErpAddress
ErpTaxIdentity
ErpDocumentIdentity
ErpDocumentReference
ErpMoney
ErpCurrency
ErpExchangeRate
ErpTaxLine
ErpDiscount
ErpCharge
ErpQuantity
ErpUnit
ErpLineItem
ErpBatchInfo
ErpSerialInfo
ErpApproval
ErpSignature
ErpAttachment
ErpPrintMetadata
ErpDocumentStatus
```

### الفائدة

نفس `ErpParty` يستخدم في:

- Customer
- Vendor
- Employee
- Bank
- Warehouse contact
- Carrier

ونفس `ErpLineItem` يستخدم في:

- Invoice
- Quotation
- Order
- Delivery
- Receipt
- Transfer
- Return

**الأولوية: P0**

---

## P0.2 — ترقية محرك Page Flow / Layout

هذه أهم نقطة تقنية في المشروع.

المطلوب إضافة abstraction أعلى من `currentY`:

```text
PdfBlock
PdfBand
PdfFlowSection
PdfKeepTogether
PdfRepeatableBand
PdfPageBreakPolicy
```

### الخصائص المطلوبة

- `keepTogether`
- `keepWithNext`
- `pageBreakBefore`
- `pageBreakAfter`
- الحد الأدنى لعدد الصفوف قبل كسر الجدول.
- منع فصل عنوان section عن أول صف.
- repeating group headers.
- repeating table header/footer.
- conditional page break.
- manual page break.
- nested flow blocks.
- two-pass layout عند الحاجة.
- دعم `"Page X of Y"` بدون حلول خاصة بكل قالب.
- orphan/widow control للنصوص الطويلة.
- دعم landscape section داخل مستند portrait عند الحاجة.
- دعم custom page size لكل section عند الضرورة.

### لماذا P0؟

لأن إضافة 100 قالب فوق Page Flow محدود ستكرر حلول pagination داخل كل قالب.

**الأولوية: P0**

---

## P0.3 — تطوير `GeniusPdfDataGrid`

الـ DataGrid هو أكثر مكون سيُستخدم داخل ERP.

### يجب تحسينه ليشمل

- Repeat header on every page.
- Group headers.
- Group footers.
- Group subtotals.
- Grand totals.
- Nested grouping.
- Row span.
- Column span.
- Fixed / weighted / min-max widths.
- Auto-fit policies.
- Text wrapping.
- Ellipsis / clip policies.
- `keepRowTogether`.
- منع انقسام صف غير مناسب بين صفحتين.
- Conditional cell styles.
- Conditional row styles.
- Alternate rows.
- Cell formatters.
- Currency format.
- Percentage format.
- Quantity/unit format.
- Date/time format.
- Nullable value rendering.
- Decimal alignment.
- Negative number styles.
- Debit/Credit styles.
- Hierarchical rows.
- Tree / indentation mode.
- Summary expressions.
- Table caption.
- Empty-state rendering.
- Very-large-dataset mode.
- Row builder / cell builder extensibility.

### مطلوب أيضًا

إنشاء طبقة أعلى:

```dart
GeniusErpLineItemsTable
GeniusErpLedgerTable
GeniusErpAgingTable
GeniusErpGroupedReportTable
```

**الأولوية: P0**

---

## P0.4 — نظام Formatting موحد

حاليًا يجب ألا يعتمد Template Engine على `value.toString()` للحقول المهمة.

### إضافة

```text
GeniusPdfFormatter
GeniusMoneyFormatter
GeniusNumberFormatter
GeniusQuantityFormatter
GeniusDateFormatter
GeniusTimeFormatter
GeniusPercentageFormatter
GeniusIdentifierFormatter
```

### يجب أن يدعم

- locale
- Arabic/English digits policy
- currency symbol/code
- decimal places
- accounting negatives
- thousand separator
- date calendars عند الحاجة
- null placeholder
- unit formatting
- percentage
- exchange rate

### مثال

```dart
value.format(
  currency: 'SAR',
  locale: 'ar-SA',
  decimals: 2,
);
```

**الأولوية: P0**

---

## P0.5 — نظام Themes / Design Tokens

بدل تعريف ألوان وأحجام وخطوط في كل قالب:

```text
GeniusPdfTheme
GeniusPdfTypography
GeniusPdfSpacing
GeniusPdfBorders
GeniusPdfTableTheme
GeniusPdfDocumentTheme
GeniusPdfSemanticColors
```

### Semantic colors

```text
primary
secondary
surface
outline
success
warning
danger
debit
credit
muted
highlight
```

### يجب دعم

- default ERP theme
- compact theme
- formal theme
- thermal theme
- government theme
- customer-specific theme

**الأولوية: P0**

---

## P0.6 — تطوير Template Engine

الـ Template Engine الحالي بداية جيدة، لكنه يحتاج إلى الانتقال من Layout JSON بسيط إلى ERP Template DSL.

### عناصر جديدة

```text
ComponentElement
SectionElement
PageBreakElement
BarcodeElement
QrElement
SignatureElement
SummaryElement
MetricElement
ChartElement
AttachmentElement
StampElement
LabelElement
GroupElement
SubTemplateElement
```

### Expression Engine

دعم expressions آمنة مثل:

```text
invoice.total > 0
customer.vatNumber != null
items.length > 10
line.quantity * line.unitPrice
sum(items.total)
```

### المطلوب

- nested paths
- calculations
- aggregates
- `sum`
- `count`
- `min`
- `max`
- `avg`
- boolean expressions
- null-safe expressions
- formatters
- localization keys
- nested loops
- groups
- subtemplates
- reusable components
- named sections
- template inheritance
- template composition
- template schema version
- migration between template versions
- strict validation
- informative validation errors

**الأولوية: P0**

---

## P0.7 — توحيد Public API

حاليًا هناك:

- Stable focused API.
- Full backward-compatible API.
- Full API يعيد تصدير Syncfusion.

الهدف طويل المدى يجب أن يكون أن يستطيع المستهلك تنفيذ كل عمليات ERP المعتادة بدون الاعتماد المباشر على Syncfusion.

### المطلوب

إنشاء package-owned abstractions لـ:

- page size
- orientation
- colors
- alignment
- border
- typography
- layout
- table styles

ثم إبقاء Syncfusion كـ implementation detail.

### لا يتم كسر API مباشرة

يتم التنفيذ تدريجيًا:

1. إضافة package-owned types.
2. Deprecate legacy Syncfusion-based overloads.
3. توفير migration adapters.
4. إزالة re-export فقط في major release مستقبلية.

**الأولوية: P0**

---

# 6. P0 — مكونات ERP جديدة

هذه المكونات يجب أن تكون مستقلة عن أسماء المبيعات أو المشتريات.

## `GeniusPdfDocumentIdentity`

يعرض:

- document type
- document number
- date
- due date
- status
- reference
- branch

---

## `GeniusPdfPartyBlock`

طرف عام:

- name
- code
- tax number
- registration number
- address
- contact
- phone
- email

يستخدم للعملاء والموردين وغيرهم.

---

## `GeniusPdfAddressBlock`

دعم:

- billing address
- shipping address
- warehouse
- branch
- service location

---

## `GeniusPdfReferenceBlock`

لإظهار العلاقات بين المستندات:

- quotation
- sales order
- purchase order
- delivery note
- invoice
- return
- project
- contract

---

## `GeniusPdfMoney`

مكون عرض مبلغ موحد، يدعم:

- currency
- precision
- debit/credit semantics
- accounting negative style

---

## `GeniusPdfAmountInWords`

يدعم:

- Arabic
- English
- currency major/minor units

---

## `GeniusPdfTaxSummary`

يدعم:

- subtotal
- line discounts
- document discount
- charges
- tax categories
- tax inclusive/exclusive
- rounding
- withholding
- grand total

---

## `GeniusPdfTermsSection`

لـ:

- payment terms
- delivery terms
- warranty
- notes
- policies
- terms and conditions

---

## `GeniusPdfApprovalTrail`

يعرض workflow:

```text
Created → Reviewed → Approved → Posted
```

مع:

- user
- role
- date/time
- status
- comment

---

## `GeniusPdfStamp`

أنواع:

- PAID
- DRAFT
- CANCELLED
- COPY
- ORIGINAL
- APPROVED
- VOID

مع نص عربي/إنجليزي.

---

## `GeniusPdfMetricCards`

للتقارير الإدارية:

- KPI
- count
- amount
- percentage
- variance

---

## `GeniusPdfLabel`

أساس لـ:

- item labels
- shelf labels
- asset labels
- serial labels
- batch labels
- shipping labels

**الأولوية لكل المكونات السابقة: P0 / بداية P1**

---

# 7. P0 — عائلات القوالب العامة

## 7.1 `GeniusErpTransactionDocument`

الأساس لـ:

- Invoice
- Order
- Quotation
- Delivery
- Receipt
- Return
- Transfer

### Sections

```text
Header
Document Identity
Primary Party
Secondary Party
References
Line Items
Tax/Total Summary
Payment/Delivery Data
Notes
Terms
Attachments
Approval Trail
Signatures
Footer
```

---

## 7.2 `GeniusErpStatementDocument`

الأساس لـ:

- Customer Statement
- Supplier Statement
- Account Statement
- Bank Statement-like reports
- Employee loan statement

### يدعم

- opening balance
- movements
- debit
- credit
- running balance
- closing balance
- aging

---

## 7.3 `GeniusErpVoucherDocument`

يوحد بنية Vouchers الحالية.

### يستخدم لـ

- payment
- receipt
- bank deposit
- withdrawal
- journal
- transfer
- inventory
- remittance
- returns

يجب إعادة استخدام ما هو موجود بدل إعادة بنائه.

---

## 7.4 `GeniusErpAnalyticalReport`

الأساس لـ:

- Trial Balance
- Income Statement
- Balance Sheet
- Sales Analysis
- Inventory Analysis
- HR reports

### يدعم

- filters header
- grouped data
- summaries
- charts
- KPIs
- comparisons
- previous period
- variance

---

## 7.5 `GeniusErpOperationalForm`

الأساس لـ:

- checklists
- inspection forms
- receiving forms
- maintenance forms
- approvals
- warehouse forms

---

## 7.6 `GeniusErpRegisterDocument`

الأساس لـ:

- asset register
- employee register
- item register
- tax register
- document register

---

## 7.7 `GeniusErpThermalReceipt`

مخصص لـ:

- 58 mm
- 80 mm
- custom roll widths

مع:

- compact typography
- automatic height
- optional logo
- QR
- barcode
- payment breakdown
- change
- cashier
- shift
- footer message

---

## 7.8 `GeniusErpLabelDocument`

يدعم:

- single label
- sheet labels
- continuous labels
- barcode labels
- QR labels
- product labels
- serial/batch labels

---

## 7.9 `GeniusErpCertificateDocument`

لـ:

- employment certificate
- salary certificate
- experience certificate
- quality certificate
- inspection certificate
- completion certificate

---

# 8. P1 — Print Profiles

لا يمكن دعم ERP كامل إذا كانت الافتراضات مبنية على A4 فقط.

إنشاء:

```text
GeniusPdfPrintProfile
```

### Profiles أساسية

- A4 portrait
- A4 landscape
- A5
- Letter
- Legal
- 58mm thermal
- 80mm thermal
- continuous paper
- custom label
- label sheet
- pre-printed form

### خصائص

- page size
- margins
- printable area
- density
- font scale
- table density
- header/footer behavior
- cut spacing
- label gap
- number of columns
- copy count

**الأولوية: P1**

---

# 9. P1 — قوالب المبيعات

## الموجود

- Quotation
- Tax Invoice
- Credit Note
- Delivery Note
- Customer Statement
- بعض Sales Vouchers

## المطلوب إضافته

1. Sales Order
2. Proforma Invoice
3. Simplified Tax Invoice / POS Invoice
4. Debit Note
5. Sales Return Document
6. Picking List
7. Packing List
8. Customer Receipt
9. Customer Aging Report
10. Sales Register
11. Sales By Customer Report
12. Sales By Item Report
13. Sales By Salesperson Report
14. Backorder Report
15. Price List
16. Commission Statement

**الأولوية: P1**

---

# 10. P1 — قوالب المشتريات

## الموجود

- Purchase Order
- بعض Purchase Vouchers

## المطلوب

1. Purchase Requisition
2. Request For Quotation — RFQ
3. Supplier Quotation
4. Quotation Comparison
5. Purchase Order
6. Goods Receipt Note — GRN
7. Purchase Invoice
8. Purchase Debit Note
9. Purchase Credit Note
10. Return To Supplier
11. Supplier Statement
12. Supplier Aging Report
13. Purchase Register
14. Purchase By Supplier
15. Purchase By Item
16. Outstanding Purchase Orders

**الأولوية: P1**

---

# 11. P1 — قوالب المخزون والمستودعات

## الموجود

- Inventory Report
- Inventory Voucher

## المطلوب

1. Stock Receipt
2. Stock Issue
3. Stock Transfer
4. Warehouse Transfer
5. Inventory Adjustment
6. Stock Count Sheet
7. Cycle Count Sheet
8. Item Card
9. Stock Ledger
10. Stock Valuation
11. Stock Availability
12. Reorder Report
13. Minimum/Maximum Stock Report
14. Batch Report
15. Serial Number Report
16. Expiry Report
17. Slow Moving Items
18. Dead Stock Report
19. Item Barcode Label
20. Shelf Label
21. Batch/Serial Label
22. Warehouse Location Label

**الأولوية: P1**

---

# 12. P1 — قوالب المحاسبة والمالية

## الموجود

- Trial Balance
- Balance Sheet
- Income Statement
- Cash Flow
- Budget
- Customer Statement
- مجموعة Vouchers

## المطلوب

1. General Ledger
2. Journal Entry
3. Journal Register
4. Account Statement
5. Accounts Receivable Aging
6. Accounts Payable Aging
7. Customer Balance Report
8. Supplier Balance Report
9. Cash Book
10. Bank Book
11. Bank Reconciliation
12. Petty Cash Statement
13. Payment Register
14. Receipt Register
15. VAT/Tax Summary
16. Tax Transaction Register
17. Cost Center Statement
18. Cost Center Trial Balance
19. Project Financial Statement
20. Budget vs Actual
21. Multi-period Financial Comparison

**الأولوية: P1**

---

# 13. P1 — الموارد البشرية والرواتب

## الموجود

- Employee Report
- Attendance Report
- Leave Report
- Payslip

## المطلوب

1. Employee Profile
2. Employee List
3. Attendance Sheet
4. Timesheet
5. Overtime Report
6. Leave Balance
7. Leave Request
8. Payroll Sheet
9. Payroll Summary
10. Salary Certificate
11. Employment Certificate
12. Experience Certificate
13. Employee Loan Statement
14. Employee Advance Statement
15. Deduction Report
16. Allowance Report
17. End-of-Service Statement
18. Employee Settlement
19. Contract Summary
20. HR Action Form

**الأولوية: P1/P2**

---

# 14. P1 — POS و Retail

هذه الفئة مهمة لأن تصميمها يختلف جذريًا عن تقارير A4.

## المطلوب

1. 58mm Receipt
2. 80mm Receipt
3. Refund Receipt
4. Exchange Receipt
5. Gift Receipt
6. Kitchen Order Ticket
7. Cashier Shift Opening
8. Cashier Shift Closing
9. X Report
10. Z Report
11. Cash Drawer Report
12. Payment Summary
13. Product Barcode Label
14. Price Label
15. Promotion Label

**الأولوية: P1**

---

# 15. P2 — التصنيع

إنشاء `ManufacturingTemplatePack`.

## القوالب

1. Bill Of Materials — BOM
2. Production Order
3. Work Order
4. Job Card
5. Material Requirement
6. Material Issue
7. Material Return
8. Production Receipt
9. Routing Sheet
10. Production Traveler
11. Machine Operation Sheet
12. Labor Sheet
13. Scrap Report
14. WIP Report
15. Production Variance
16. Quality Inspection
17. Batch Production Record

**الأولوية: P2**

---

# 16. P2 — الأصول الثابتة

1. Asset Card
2. Asset Register
3. Asset Label
4. Asset Transfer
5. Asset Assignment
6. Asset Return
7. Asset Disposal
8. Depreciation Schedule
9. Depreciation Report
10. Asset Maintenance History
11. Asset Physical Count
12. Asset Movement Report

**الأولوية: P2**

---

# 17. P2 — المشاريع

1. Project Summary
2. Project Budget
3. Project Cost Report
4. Project Profitability
5. Project Timesheet
6. Expense Report
7. Milestone Report
8. Progress Certificate
9. Work Completion Certificate
10. Project Billing Statement
11. Resource Utilization
12. Project Purchase Summary

**الأولوية: P2**

---

# 18. P2 — الصيانة والخدمات

1. Service Request
2. Work Order
3. Maintenance Work Order
4. Preventive Maintenance Schedule
5. Maintenance Checklist
6. Technician Service Report
7. Service Completion
8. Spare Parts Consumption
9. Warranty Certificate
10. Equipment Inspection
11. Calibration Certificate
12. Service History

**الأولوية: P2**

---

# 19. P2 — النقل واللوجستيات

1. Shipment Document
2. Packing List
3. Dispatch Note
4. Waybill
5. Delivery Manifest
6. Driver Trip Sheet
7. Vehicle Trip Report
8. Shipping Label
9. Pallet Label
10. Container Packing List
11. Freight Statement
12. Delivery Proof

**الأولوية: P2**

---

# 20. P2 — CRM

1. Customer Profile
2. Lead Report
3. Opportunity Report
4. Sales Pipeline
5. Activity Report
6. Visit Report
7. Call Report
8. Customer Interaction History
9. Proposal
10. Contract Summary

**الأولوية: P2**

---

# 21. P2 — الجودة

1. Inspection Form
2. Incoming Quality Inspection
3. Production Quality Inspection
4. Final Inspection
5. Non-Conformance Report — NCR
6. Corrective Action Report
7. Certificate Of Analysis — COA
8. Quality Checklist
9. Audit Checklist
10. Calibration Record

**الأولوية: P2**

---

# 22. P3 — Compliance Architecture

لا أنصح بوضع قواعد دولة محددة مباشرة داخل `TaxInvoiceTemplate`.

الأفضل:

```text
GeniusPdfComplianceProfile
```

ثم plugins منفصلة.

### أمثلة

```text
SaudiEInvoiceCompliance
UaeTaxInvoiceCompliance
EuInvoiceCompliance
PdfArchiveCompliance
```

### القدرات المطلوبة

- structured invoice QR payloads.
- embedded machine-readable invoice data.
- document hashes.
- signing metadata.
- certificate-based signatures.
- timestamp support.
- audit metadata.
- document UUID.
- original/copy semantics.
- archival profile support عند الحاجة.
- PDF metadata/XMP.
- attachment embedding.

بهذا يمكن تحديث قواعد دولة بدون تعديل كل القوالب.

**الأولوية: P3، مع تنفيذ ما يلزم لعملاء الإنتاج أبكر عند الحاجة.**

---

# 23. P3 — التوقيعات والاعتمادات

المكتبة لديها Digital Signature، لكن ERP يحتاج طبقتين منفصلتين:

## Business Approval

```text
Prepared By
Reviewed By
Approved By
Posted By
Received By
Delivered By
```

## Cryptographic Signature

- certificate
- signing reason
- signing location
- signer
- timestamp
- validation state

يجب عدم الخلط بينهما.

**الأولوية: P3**

---

# 24. P3 — Template Registry & Versioning

تطوير Registry ليصبح:

```text
TemplateId
TemplateVersion
TemplatePack
TemplateVariant
Locale
Country
Organization
Branch
EffectiveFrom
EffectiveTo
```

### lookup مثال

```text
sales.invoice
→ country: SA
→ organization: 10
→ branch: 2
→ locale: ar
→ version: 3
```

### المطلوب

- fallback hierarchy
- active/inactive templates
- draft/published state
- version history
- template migration
- checksum
- rollback

**الأولوية: P3**

---

# 25. P3 — Template Designer

لا يبدأ العمل به قبل استقرار P0/P1.

عندها يمكن بناء Designer فوق Template Engine:

### الخصائص

- drag/drop sections
- variable browser
- sample data preview
- Arabic/English preview
- page preview
- table configuration
- conditions
- expressions
- styling
- template validation
- version publish
- import/export JSON

الهدف أن يستطيع عميل ERP تخصيص الفاتورة بدون fork للمكتبة.

**الأولوية: P3**

---

# 26. P0/P1 — Testing المطلوب قبل التوسع

## Golden PDF Tests

كل قالب أساسي يجب أن يملك baseline.

اختبارات:

- EN/LTR
- AR/RTL
- bilingual
- empty fields
- long names
- long addresses
- 1 line item
- 50 lines
- 500 lines
- multi-page
- very long notes
- null optional sections

---

## Visual Regression

رندر صفحات PDF إلى صور ثم مقارنة:

- dimensions
- clipping
- overlaps
- unexpected page count
- misplaced RTL text
- incorrect logical start/end mirroring
- components that changed text direction but did not mirror layout order
- reversed or visually corrupted numbers/currency/IDs inside RTL content
- incorrect icon leading/trailing positions
- accidental mirroring of QR/barcode/images
- incorrect mixed Arabic/English punctuation or ordering

### Directionality Regression Matrix

يجب تنفيذ Golden/visual tests على الأقل للمكونات:

- Summary
- InfoBox
- ReportHeader
- DataGrid
- RichText
- SignatureArea
- QR/Barcode captions
- two-column layout

وفي الحالات:

- EN/LTR.
- AR/RTL.
- bilingual.
- Arabic label + Latin amount/currency.
- Arabic sentence + document number.
- Arabic sentence + SKU.
- Arabic sentence + IBAN.
- Arabic sentence + email/URL.
- long wrapping content.
- nested direction override.

---

## Semantic Tests

استخراج النص والتأكد من:

- document number
- totals
- tax
- page number
- customer/vendor
- currency

---

## Calculation Tests

التأكد من:

```text
subtotal
discount
charges
tax
rounding
grandTotal
debit
credit
balance
```

---

## Performance Tests

سيناريوهات:

- 1,000 rows
- 10,000 rows
- batch generation
- multiple documents
- image-heavy documents
- QR/barcode-heavy labels

قياس:

- generation time
- peak memory
- output size
- pages/second

**الأولوية: P0**

---

# 27. P0 — تحسين الأداء

المكتبة تحتوي بالفعل على background generation وbatch jobs وcache في أجزاء منها، لكن ERP يحتاج قياسات واضحة.

### المطلوب

- lazy image decoding.
- font caching.
- barcode caching.
- repeated style caching.
- avoid unnecessary object creation per cell.
- streaming/chunked data preparation.
- efficient large grids.
- deterministic resource disposal.
- batch concurrency limit.
- benchmark suite.
- memory budget per 1,000 rows.

### هدف مبدئي

لا يتم تعريف رقم performance نهائي قبل benchmark baseline، لكن يجب أن تصبح المقارنات جزءًا من CI.

**الأولوية: P0/P1**

---

# 28. P0 — معالجة Nullability وOptional Sections

جميع ERP templates يجب أن تتبع قاعدة:

> إذا لم توجد بيانات لقسم اختياري فلا يظهر القسم ولا يترك فراغًا غير مبرر.

ينطبق على:

- tax
- discounts
- shipping
- payment details
- notes
- terms
- approvals
- signatures
- references
- batch
- serial
- project
- cost center

يجب دعم ذلك على مستوى `Section` وليس يدويًا داخل كل قالب.

**الأولوية: P0**

---

# 29. P1 — Multi-Currency

إضافة دعم أصلي لـ:

```text
documentCurrency
baseCurrency
exchangeRate
foreignAmount
baseAmount
```

مطلوب في:

- invoices
- vouchers
- statements
- ledgers
- financial reports

مع Summary قادر على إظهار العملتين.

**الأولوية: P1**

---

# 30. P1 — Multi-Unit / Batch / Serial

ERP inventory يحتاج line model أقوى من:

```text
description + qty + price
```

يجب أن يدعم:

```text
itemCode
barcode
description
variant
unit
quantity
secondaryUnit
conversionFactor
batch
serials
expiryDate
warehouse
location
project
costCenter
```

**الأولوية: P1**

---

# 31. P1 — Tax / Discount / Charge Engine

لا تربط الحسابات بنوع فاتورة واحد.

إنشاء:

```text
ErpDocumentCalculation
```

### يدعم

- line discount
- document discount
- fixed discount
- percentage discount
- tax per line
- multiple taxes
- tax inclusive
- tax exclusive
- withholding
- service charges
- freight
- rounding
- taxable subtotal
- exempt subtotal
- zero-rated subtotal

القالب يقرأ Calculated Snapshot ولا يعيد الحساب داخل draw methods.

**الأولوية: P1**

---

# 32. P1 — Charts

للتقارير التحليلية أضف:

```text
GeniusPdfChart
```

### البداية

- bar
- line
- pie/donut
- stacked bar
- sparkline

لكن لا تستخدم charts في المستندات transactional إلا عند الحاجة.

**الأولوية: P1/P2**

---

# 33. P1 — Forms & Checkboxes

للمستندات التشغيلية:

```text
GeniusPdfCheckbox
GeniusPdfRadioGroup
GeniusPdfFormField
GeniusPdfChecklist
GeniusPdfApprovalBox
```

يمكن أن تكون:

- static printable
- أو interactive PDF كقدرة اختيارية

مهم لـ:

- Quality
- Maintenance
- HR
- Inspections

**الأولوية: P1/P2**

---

# 34. P1 — Original / Copy / Duplicate / Reprint

ERP يحتاج Print Metadata موحد:

```text
Original
Copy
Duplicate
Reprint
Draft
Cancelled
Archived
```

إضافة:

```text
ErpPrintCopyType
ErpPrintReason
ErpPrintSequence
```

ويظهر تلقائيًا في:

- watermark
- header
- footer

مع:

- printedBy
- printedAt
- workstation
- copy number

**الأولوية: P1**

---

# 35. P2 — Pre-Printed Forms

بعض الشركات تطبع على نماذج جاهزة مسبقًا.

إضافة وضع:

```text
prePrintedForm
```

### الخصائص

- لا يرسم background/header عند عدم الحاجة.
- absolute anchors.
- calibrated offsets.
- printer-specific profile.
- test calibration page.

**الأولوية: P2**

---

# 36. P2 — Label Engine

لا يكفي تغيير `pageSize`.

المطلوب:

```text
GeniusPdfLabelSheet
GeniusPdfLabelLayout
GeniusPdfLabelCell
```

### الخصائص

- columns
- rows
- horizontal gap
- vertical gap
- sheet margins
- start index
- skip used labels
- repeated copies
- barcode fit
- QR fit
- text truncation

**الأولوية: P2**

---

# 37. P2 — Attachments & Evidence

المكتبة تدعم image attachments على مستوى Builder.

نحتاج abstraction أعلى:

```text
ErpDocumentAttachment
```

أنواع:

- image
- PDF
- scanned proof
- signature image
- delivery photo
- supporting document

مع:

- title
- type
- reference
- timestamp

**الأولوية: P2**

---

# 38. بنية الملفات المقترحة

```text
lib/
├── genius_link_pdf_generator.dart
├── genius_link_pdf_generator_api.dart
│
├── src/
│   ├── erp/
│   │   ├── domain/
│   │   │   ├── document/
│   │   │   ├── party/
│   │   │   ├── money/
│   │   │   ├── tax/
│   │   │   ├── inventory/
│   │   │   └── approval/
│   │   │
│   │   ├── components/
│   │   ├── calculation/
│   │   ├── formatting/
│   │   ├── layout/
│   │   └── print_profiles/
│   │
│   ├── components/
│   ├── builders/
│   ├── services/
│   └── ...
│
└── templates/
    ├── core/
    │   ├── transaction/
    │   ├── statement/
    │   ├── voucher/
    │   ├── analytical/
    │   ├── operational/
    │   ├── thermal/
    │   ├── label/
    │   └── certificate/
    │
    ├── packs/
    │   ├── sales/
    │   ├── purchasing/
    │   ├── inventory/
    │   ├── accounting/
    │   ├── hr/
    │   ├── manufacturing/
    │   ├── pos/
    │   ├── assets/
    │   ├── projects/
    │   ├── service/
    │   ├── logistics/
    │   └── quality/
    │
    └── engine/
```

---

# 39. ترتيب التنفيذ المقترح

## المرحلة 1 — Foundation

### الهدف

منع التكرار قبل إضافة قوالب جديدة.

### التنفيذ

1. Directionality foundation + RTL/LTR logical layout fixes.
2. إصلاح `Summary` و`InfoBox` وبقية المكونات الحالية بحيث تعتمد `start/end` بدل `left/right`.
3. Directionality golden tests لـ EN/LTR وAR/RTL وbilingual/mixed-content.
4. ERP domain models.
5. Formatting.
6. Theme tokens.
7. Flow blocks.
8. DataGrid upgrades.
9. Optional section behavior.
10. tests + golden framework.
11. benchmark baseline.

### الناتج

لا حاجة بعد هذه المرحلة لقوالب كثيرة، لكن الأساس يصبح مستقرًا.

---

## المرحلة 2 — Core Document Families

تنفيذ:

1. Transaction
2. Statement
3. Voucher
4. Analytical Report
5. Thermal Receipt
6. Label

ثم نقل القوالب الحالية إليها تدريجيًا بدون تغيير public constructors إن أمكن.

---

## المرحلة 3 — ERP Core Pack

أولوية القوالب:

### Sales

- Sales Order
- Proforma Invoice
- Simplified Invoice
- Debit Note
- Picking/Packing
- Aging

### Purchasing

- Purchase Requisition
- RFQ
- GRN
- Purchase Invoice
- Supplier Return
- Supplier Statement/Aging

### Inventory

- Receipt
- Issue
- Transfer
- Count
- Adjustment
- Ledger
- Labels

### Accounting

- General Ledger
- Journal
- AR/AP Aging
- Bank Reconciliation
- Tax Register

### POS

- 58/80mm Receipt
- Refund
- X/Z reports

---

## المرحلة 4 — Advanced ERP Packs

- Manufacturing
- Fixed Assets
- Projects
- Maintenance
- Logistics
- CRM
- Quality
- Advanced HR

---

## المرحلة 5 — Enterprise

- Compliance plugins.
- template registry/versioning.
- remote/custom templates.
- template designer.
- archival profiles.
- advanced signing.
- tenant/branch template overrides.

---

# 40. قائمة العمل حسب الأولوية

## P0 — يجب البدء بها

- [ ] Directionality core (`auto/ltr/rtl`) + resolver
- [ ] Logical layout primitives (`start/end`, `leading/trailing`)
- [ ] Fix Arabic `Summary` row mirroring while keeping numeric values LTR
- [ ] Fix `InfoBox`, `ReportHeader`, `DataGrid`, `RichText`, `SignatureArea` directionality
- [ ] Mixed-direction/BiDi value policy for money, IDs, SKU, IBAN, phone, email, dates
- [ ] Directionality golden/regression matrix
- [ ] ERP shared domain models
- [ ] Flow/Band layout abstraction
- [ ] DataGrid advanced pagination/grouping
- [ ] Formatting engine
- [ ] Theme/design tokens
- [ ] Template Engine expressions and formatters
- [ ] Optional section abstraction
- [ ] Typed calculation layer
- [ ] Package-owned public abstractions
- [ ] Golden/visual regression tests
- [ ] Performance baseline
- [ ] Transaction family
- [ ] Statement family
- [ ] Voucher family consolidation

---

## P1 — ERP General Coverage

- [ ] Print Profiles
- [ ] Thermal receipts
- [ ] Label foundation
- [ ] Sales core templates
- [ ] Purchasing core templates
- [ ] Inventory core templates
- [ ] Accounting missing templates
- [ ] POS core templates
- [ ] HR payroll/timesheet additions
- [ ] Multi-currency
- [ ] Multi-unit
- [ ] Batch/serial
- [ ] Tax/discount/charge model
- [ ] Original/Copy/Reprint metadata
- [ ] Chart primitive
- [ ] Checklist/Form primitives

---

## P2 — Advanced Modules

- [ ] Manufacturing pack
- [ ] Fixed Assets pack
- [ ] Projects pack
- [ ] Maintenance pack
- [ ] Logistics pack
- [ ] CRM pack
- [ ] Quality pack
- [ ] Label sheet engine
- [ ] Pre-printed forms
- [ ] Advanced attachments/evidence

---

## P3 — Enterprise

- [ ] Compliance profile/plugin architecture
- [ ] Advanced cryptographic signing
- [ ] Archival document profiles
- [ ] Template registry
- [ ] Template versions
- [ ] Template fallback by tenant/branch/country
- [ ] Template Designer
- [ ] Publish/rollback lifecycle
- [ ] Template import/export

---

## P4 — Industry Packs

بعد اكتمال البنية العامة يمكن إنشاء packs منفصلة حسب الصناعة بدل إدخالها داخل core:

- Retail
- Restaurant
- Construction
- Real Estate
- Healthcare
- Education
- Automotive
- Distribution
- Hospitality

---

# 41. ما الذي لا أنصح به؟

## 1. إضافة 100 Template قبل تطوير الـ Core

سيؤدي إلى:

- duplicated layouts
- duplicated totals
- duplicated headers
- duplicated pagination fixes

---

## 2. وضع منطق الحساب داخل Template

القالب يجب أن يعرض:

```text
CalculatedDocument
```

ولا يحسب ضريبة أو خصم بنفسه.

---

## 3. ربط جميع الـ API مباشرة بـ Syncfusion

يجب أن تبقى المكتبة قادرة على تغيير أو تغليف renderer مستقبلًا.

---

## 4. Template Engine غير versioned

أي JSON templates في production يجب أن يكون لها schema version واضح.

---

## 5. جعل كل دولة Fork

يجب استخدام Compliance Profiles / Plugins.

---

## 6. تجاهل Thermal وLabels

أنظمة ERP الواقعية لا تستخدم A4 فقط.

---

# 42. Definition of Done لقالب ERP جديد

لا يعتبر القالب مكتملًا إلا إذا اجتاز:

- [ ] LTR
- [ ] RTL
- [ ] Correct logical `start/end` mirroring
- [ ] Numeric/currency values remain readable and stable inside RTL
- [ ] Mixed Arabic/English BiDi content is correct
- [ ] Icons/accessories use correct `leading/trailing`
- [ ] QR/barcode/image payload is not mirrored
- [ ] Bilingual
- [ ] Light data
- [ ] Long data
- [ ] Multi-page data
- [ ] Null optional sections
- [ ] Long party names
- [ ] Long item descriptions
- [ ] Different currency
- [ ] Different print profile
- [ ] Golden visual regression
- [ ] Calculation verification
- [ ] No clipping
- [ ] No overlap
- [ ] Correct page numbering
- [ ] Correct repeated headers
- [ ] Stable performance

---

# 43. Architecture Acceptance Criteria

بعد تنفيذ P0 يجب أن يكون من الممكن إنشاء مطبوع ERP جديد بهذه الصورة تقريبًا:

```dart
final document = GeniusErpTransactionDocument(
  context: context,
  identity: identity,
  primaryParty: customer,
  references: references,
  lines: lines,
  calculation: calculation,
  options: const ErpTransactionPrintOptions(
    showTax: true,
    showQRCode: true,
    showApprovalTrail: true,
  ),
);
```

ثم تحديد الاختلاف:

```dart
TaxInvoiceTemplate(...)
SalesOrderTemplate(...)
PurchaseInvoiceTemplate(...)
DeliveryNoteTemplate(...)
```

بدون أن تعيد هذه classes تنفيذ:

- company header
- party layout
- line-item grid
- page flow
- totals layout
- notes
- signatures
- print metadata

---

# 44. النتيجة المستهدفة

بعد تطبيق الخطة، تصبح المكتبة مقسمة ذهنيًا إلى أربع طبقات:

```text
PDF Engine
    ↓
Reusable PDF Components
    ↓
ERP Document Platform
    ↓
ERP Template Packs
```

ويكون إضافة مطبوع جديد في معظم الحالات:

1. اختيار Document Family.
2. تحديد Domain Data.
3. اختيار Sections.
4. تخصيص Columns.
5. تخصيص Theme.
6. إضافة Compliance Profile عند الحاجة.

بدل كتابة قالب كامل من الصفر.

---

# 45. القرار المقترح للبدء

## أول Sprint معماري

أقترح أن يكون أول نطاق تنفيذي:

1. `ErpDocumentContext`
2. `ErpParty`
3. `ErpDocumentIdentity`
4. `ErpMoney`
5. `ErpLineItem`
6. `ErpDocumentCalculation`
7. `GeniusPdfPartyBlock`
8. `GeniusPdfDocumentIdentity`
9. `GeniusPdfTaxSummary`
10. `GeniusErpTransactionDocument`
11. نقل `QuotationTemplate`
12. نقل `PurchaseOrderTemplate`
13. نقل `TaxInvoiceTemplate`

### معيار النجاح

إذا أمكن تنفيذ القوالب الثلاثة السابقة فوق نفس `TransactionDocument` بدون تكرار كبير وبدون خسارة أي سلوك حالي، فالبنية المقترحة مناسبة ويمكن الانتقال لبقية ERP packs.

---

# 46. أولويات مختصرة جدًا

```text
P0
Core layout + ERP models + shared components + tests

P1
Sales + Purchasing + Inventory + Accounting + POS

P2
HR advanced + Manufacturing + Assets + Projects + Service + Logistics + Quality

P3
Compliance + Template Registry + Designer + Enterprise signing

P4
Industry-specific packs
```

---

# 47. ملفات المصدر التي بُني عليها هذا التقييم

تمت مراجعة البنية الحالية، وبشكل خاص:

- `README.md`
- `lib/genius_link_pdf_generator.dart`
- `lib/genius_link_pdf_generator_api.dart`
- `lib/src/builders/pdf_document_builder.dart`
- `lib/src/builders/pdf_document_builder/document_builder.dart`
- `lib/src/builders/pdf_document_builder/report_composer.dart`
- `lib/src/components/components.dart`
- `lib/src/components/widgets/*`
- `lib/src/services/pdf_security_service.dart`
- `lib/templates/*`
- `lib/templates/engine/template_definition.dart`
- `lib/templates/engine/template_elements.dart`
- `lib/templates/vouchers/*`

---

# 48. الخلاصة

المكتبة الحالية **قوية بما يكفي لتكون الأساس** لمنصة طباعة ERP واسعة، لكن أهم تحسين الآن ليس عدد القوالب.

الأولوية هي تحويلها من:

> PDF Generator + Templates

إلى:

> **ERP Document Rendering Platform**

وأفضل ترتيب للعمل هو:

**Layout → Domain Models → ERP Components → Document Families → ERP Packs → Compliance/Designer**

بهذا الترتيب ستكون كل إضافة لاحقة أقل تكلفة، أكثر اتساقًا، وأقل عرضة للأخطاء والتكرار.
