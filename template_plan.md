# Template Plan — v3.0.0+

## Service Voucher Templates (سندات الخدمات)

---

## 1. Overview

Version 3.0.0 introduces a comprehensive **Service Voucher System** for generating professional, bilingual (Arabic/English) financial vouchers. Each voucher type maps to a specific service ID and generates detailed, print-ready PDF pages. Multiple vouchers can be combined into a single PDF document.

### Design Goals

- **One template class per voucher category** — each category handles its subtypes via a `serviceId` parameter
- **Multi-voucher PDF** — a single PDF file can contain multiple vouchers, each on its own page(s)
- **Bilingual support** — all labels, descriptions, and amounts render in both Arabic and English
- **RTL-aware** — full RTL layout support inherited from `GeniusPdfConfig`
- **Consistent styling** — all vouchers share a unified visual language via `GeniusPdfVoucherStyle`
- **Print-ready** — A4 format with proper margins, borders, and signature blocks

---

## 2. Architecture

### 2.1 Core Models

```
lib/src/templates/vouchers/
├── models/
│   ├── voucher_models.dart           # Core voucher data models
│   ├── voucher_style.dart            # Styling configuration
│   └── voucher_enums.dart            # Service IDs & enums
├── templates/
│   ├── accounting_entry_voucher.dart  # 00001–00004
│   ├── receipt_voucher.dart           # 00100–00103
│   ├── payment_voucher.dart           # 00200–00203
│   ├── tax_voucher.dart               # 00300–00304
│   ├── bank_deposit_voucher.dart      # 10000–10002
│   ├── bank_withdrawal_voucher.dart   # 10100–10102
│   ├── transfer_voucher.dart          # 10200–10203
│   ├── bill_payment_voucher.dart      # 10300–10305
│   ├── remittance_outgoing_voucher.dart   # 10400–10401, 10500–10501
│   ├── remittance_incoming_voucher.dart   # 10450–10451, 10550–10551
│   ├── purchase_voucher.dart          # 20000–20003
│   ├── sales_voucher.dart             # 20200–20203
│   ├── purchase_return_voucher.dart   # 20400–20403
│   ├── sales_return_voucher.dart      # 20450–20453
│   ├── gift_voucher.dart              # 20500–20501
│   └── inventory_voucher.dart         # 20600–20604
└── vouchers.dart                      # Barrel export
```

### 2.2 Base Class

```dart
abstract class GeniusPdfVoucherTemplate extends GeniusPdfDocumentBuilder {
  final String serviceId;
  final GeniusPdfVoucherData data;
  final GeniusPdfVoucherStyle style;

  // Common sections drawn by all vouchers:
  void drawVoucherHeader(...)   // Company info + voucher number + date
  void drawVoucherTitle(...)    // Bilingual title with service description
  void drawPartyInfo(...)       // Payer/payee/supplier/customer block
  void drawAmountBlock(...)     // Amount in digits + words (Arabic & English)
  void drawDetailsTable(...)    // Line items / account entries
  void drawNotesBlock(...)      // Notes / remarks
  void drawSignatureBlock(...)  // Signatures: prepared, reviewed, approved, received
  void drawStampArea(...)       // Official stamp area
  void drawVoucherFooter(...)   // Serial number, print date, page number
}
```

---

## 3. Service ID Registry

### 3.1 Accounting Entries (القيود المحاسبية) — `00001–00004`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 00001 | قيد بسيط | Simple Entry | قيد محاسبي يتكون من طرف مدين واحد وطرف دائن واحد، يستخدم لتسجيل العمليات المالية البسيطة مثل شراء أصل نقداً أو دفع مصروف |
| 00002 | قيد مركب | Compound Entry | قيد محاسبي يتكون من أكثر من طرف مدين أو أكثر من طرف دائن، يستخدم لتسجيل العمليات المالية المعقدة التي تؤثر على عدة حسابات في نفس الوقت |
| 00003 | قيد افتتاحي | Opening Entry | قيد محاسبي يسجل في بداية الفترة المالية لنقل أرصدة الحسابات من الفترة السابقة، يشمل جميع الأصول والخصوم وحقوق الملكية |
| 00004 | قيد تسوية | Adjusting Entry | قيد محاسبي يسجل في نهاية الفترة المالية لتصحيح الأخطاء أو تسوية الحسابات وفقاً لمبدأ الاستحقاق المحاسبي |

**Template: `AccountingEntryVoucher`**

Layout per voucher page:
1. **Header** — Company logo, name (AR/EN), VAT number, CR number
2. **Voucher Title** — "قيد بسيط / Simple Entry" with service ID badge
3. **Voucher Info Row** — Voucher number, date, fiscal period, reference number
4. **Entry Description** — Free-text description of the transaction (AR/EN)
5. **Accounts Table** — Columns: Account Code | Account Name (AR) | Account Name (EN) | Debit | Credit
   - For Simple (00001): exactly 1 debit row + 1 credit row
   - For Compound (00002): multiple debit/credit rows
   - For Opening (00003): all asset/liability/equity accounts
   - For Adjusting (00004): correction entries with original reference
6. **Totals Row** — Total Debit = Total Credit (must balance)
7. **Amount in Words** — Arabic + English representation
8. **Notes** — Optional notes/remarks
9. **Signatures** — Prepared by | Reviewed by | Approved by
10. **Footer** — Print date, page number, document serial

---

### 3.2 Receipt Vouchers (سندات القبض) — `00100–00103`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 00100 | سند قبض نقدي | Cash Receipt Voucher | مستند يثبت استلام مبلغ نقدي من عميل أو طرف آخر |
| 00101 | سند قبض تحويل بنكي | Bank Transfer Receipt | مستند يثبت استلام مبلغ عن طريق التحويل البنكي |
| 00102 | سند قبض شيك | Check Receipt Voucher | مستند يثبت استلام شيك من عميل كوسيلة دفع |
| 00103 | سند قبض إلكتروني | Electronic Receipt Voucher | مستند يثبت استلام مبلغ عن طريق وسائل الدفع الإلكترونية |

**Template: `ReceiptVoucher`**

Layout per voucher page:
1. **Header** — Company info with logo
2. **Voucher Title** — "سند قبض نقدي / Cash Receipt Voucher" + service ID
3. **Voucher Info** — Number, date, reference
4. **Received From** — Party name (AR/EN), party code, address, phone
5. **Payment Method Block** — Varies by subtype:
   - 00100 (Cash): Amount only
   - 00101 (Bank Transfer): Bank name, account number, transfer reference, transfer date
   - 00102 (Check): Check number, bank name, branch, check date, due date
   - 00103 (Electronic): Payment gateway, transaction ID, card type/last 4 digits
6. **Amount** — Numeric amount + currency + amount in words (AR/EN)
7. **Purpose** — Payment purpose / description
8. **Account Allocation** — Account code, account name, cost center, amount
9. **Notes**
10. **Signatures** — Cashier/Receiver | Accountant | Manager | Payer signature
11. **Footer** — Serial, copies indication (Original / Copy)

---

### 3.3 Payment Vouchers (سندات الصرف) — `00200–00203`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 00200 | سند صرف نقدي | Cash Payment Voucher | مستند يثبت دفع مبلغ نقدي لمورد أو موظف أو طرف آخر |
| 00201 | سند صرف تحويل بنكي | Bank Transfer Payment | مستند يثبت دفع مبلغ عن طريق التحويل البنكي |
| 00202 | سند صرف شيك | Check Payment Voucher | مستند يثبت إصدار شيك للدفع لمورد أو طرف آخر |
| 00203 | سند صرف إلكتروني | Electronic Payment Voucher | مستند يثبت دفع مبلغ عن طريق وسائل الدفع الإلكترونية |

**Template: `PaymentVoucher`**

Layout per voucher page:
1. **Header** — Company info with logo
2. **Voucher Title** — "سند صرف نقدي / Cash Payment Voucher" + service ID
3. **Voucher Info** — Number, date, reference
4. **Paid To** — Beneficiary name (AR/EN), code, address, bank details
5. **Payment Method Block** — Varies by subtype:
   - 00200 (Cash): Amount only
   - 00201 (Bank Transfer): From account, to account, bank name, transfer reference
   - 00202 (Check): Check number, bank name, check date
   - 00203 (Electronic): Payment gateway, transaction ID
6. **Amount** — Numeric + currency + words (AR/EN)
7. **Purpose** — Payment reason / invoice references
8. **Account Allocation** — Account code, name, cost center, amount
9. **Deductions** — Tax withholding, discounts, penalties (if applicable)
10. **Net Amount** — After deductions
11. **Notes**
12. **Signatures** — Prepared by | Accountant | Financial Manager | Beneficiary received
13. **Footer**

---

### 3.4 Tax Vouchers (السندات الضريبية) — `00300–00304`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 00300 | سند ضريبة دخل | Income Tax Voucher | مستند يثبت دفع أو استحقاق ضريبة الدخل المفروضة على أرباح الشركة |
| 00301 | سند ضريبة قيمة مضافة | VAT Voucher | مستند يثبت دفع أو استحقاق ضريبة القيمة المضافة |
| 00302 | سند رسوم حكومية | Government Fees Voucher | مستند يثبت دفع الرسوم الحكومية المختلفة |
| 00303 | سند رسوم جمركية | Customs Duty Voucher | مستند يثبت دفع الرسوم الجمركية |
| 00304 | سند تسوية ضريبية | Tax Settlement Voucher | مستند يثبت تسوية الفروقات الضريبية |

**Template: `TaxVoucher`**

Layout per voucher page:
1. **Header** — Company info + Tax Registration Number (TIN/VAT Number)
2. **Voucher Title** — Tax type specific title
3. **Tax Period** — From date / To date / Filing deadline
4. **Tax Authority Info** — Authority name, reference number
5. **Tax Calculation Table** — Varies by subtype:
   - 00300 (Income Tax): Taxable income, tax rate, tax amount, previous payments, balance due
   - 00301 (VAT): Output VAT, Input VAT, Net VAT, adjustments
   - 00302 (Gov Fees): Fee type, fee amount, service description
   - 00303 (Customs): HS code, goods description, customs value, duty rate, duty amount
   - 00304 (Settlement): Original assessment, revised amount, difference, penalty/interest
6. **Payment Details** — Payment method, reference, date
7. **Amount** — Total tax/fee amount + words
8. **Notes** — Regulatory notes, compliance references
9. **Signatures** — Tax accountant | Financial manager | Authorized signatory
10. **Footer** — With tax authority reference numbers

---

### 3.5 Bank Deposit Vouchers (إيداعات بنكية) — `10000–10002`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10000 | إيداع نقدي | Cash Deposit | عملية إيداع مبلغ نقدي في الحساب البنكي |
| 10001 | إيداع شيك | Check Deposit | عملية إيداع شيك في الحساب البنكي |
| 10002 | إيداع إلكتروني | Electronic Deposit | عملية إيداع عن طريق التحويل الإلكتروني |

**Template: `BankDepositVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Deposit type title
3. **Bank Info** — Bank name, branch, account number, IBAN
4. **Deposit Details** — Varies by subtype:
   - 10000 (Cash): Denomination breakdown table (500, 200, 100, 50, 20, 10, 5, 1 + coins)
   - 10001 (Check): Check number, issuing bank, drawer name, check date, due date
   - 10002 (Electronic): Transfer source, reference number, transaction ID
5. **Amount** — Total deposit amount + words
6. **Purpose** — Deposit reason
7. **Account Entry** — Debit: Bank Account | Credit: Cash/Receivable
8. **Signatures** — Depositor | Cashier | Bank teller stamp
9. **Footer**

---

### 3.6 Bank Withdrawal Vouchers (سحوبات بنكية) — `10100–10102`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10100 | سحب نقدي | Cash Withdrawal | عملية سحب مبلغ نقدي من الحساب البنكي |
| 10101 | سحب بشيك | Check Withdrawal | عملية إصدار شيك للسحب من الحساب البنكي |
| 10102 | سحب عبر الصراف | ATM Withdrawal | عملية سحب نقدي باستخدام بطاقة الصراف الآلي |

**Template: `BankWithdrawalVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Withdrawal type title
3. **Bank Info** — Bank name, branch, account number, IBAN
4. **Withdrawal Details** — Varies by subtype:
   - 10100 (Cash): Amount, purpose, authorized person
   - 10101 (Check): Check number, payee name, check date
   - 10102 (ATM): ATM location, card number (masked), transaction reference
5. **Amount** — Total withdrawal + words
6. **Purpose** — Withdrawal reason
7. **Account Entry** — Debit: Cash/Expense | Credit: Bank Account
8. **Signatures** — Requester | Accountant | Authorized signatory
9. **Footer**

---

### 3.7 Transfer Vouchers (التحويلات) — `10200–10203`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10200 | تحويل بنكي | Bank Transfer | عملية تحويل مبلغ من حساب بنكي إلى حساب آخر |
| 10201 | تحويل بين حسابات | Inter-Account Transfer | عملية تحويل بين حسابات مختلفة |
| 10202 | تحويل إلكتروني | Electronic Transfer | عملية تحويل باستخدام الأنظمة الإلكترونية |
| 10203 | تحويل عملات | Currency Exchange | عملية تحويل مبلغ من عملة إلى أخرى |

**Template: `TransferVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Transfer type title
3. **Source Account** — Bank, account number, IBAN, currency, balance before
4. **Destination Account** — Bank, account number, IBAN, currency, balance before
5. **Transfer Details** — Varies by subtype:
   - 10200 (Bank): Amount, transfer reference, beneficiary name
   - 10201 (Inter-Account): From account code, to account code, reason
   - 10202 (Electronic): Platform, transaction ID, processing time
   - 10203 (Currency Exchange): Source currency, target currency, exchange rate, source amount, target amount, exchange fee
6. **Fees** — Transfer fees, commission
7. **Net Amount** — After fees
8. **Amount in Words** — (For currency exchange: both currencies)
9. **Signatures** — Requester | Treasury | Financial manager
10. **Footer**

---

### 3.8 Bill Payment Vouchers (دفع الفواتير) — `10300–10305`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10300 | دفع فواتير خدمات | Utility Bill Payment | دفع فواتير الكهرباء والماء والغاز والهاتف |
| 10301 | دفع فواتير متنوعة | General Bill Payment | دفع مختلف أنواع الفواتير والمستحقات |
| 10302 | دفع فواتير إنترنت | Internet Bill Payment | دفع فواتير خدمات الإنترنت |
| 10303 | شحن اتصالات | Telecom Recharge | تجديد وشراء باقات الاتصالات |
| 10304 | شحن ألعاب | Game Credit Recharge | شراء وشحن رصيد الألعاب الإلكترونية |
| 10305 | شحن ترفيه | Entertainment Recharge | شراء اشتراكات التطبيقات الترفيهية |

**Template: `BillPaymentVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Bill type title
3. **Service Provider** — Provider name, account/subscriber number
4. **Bill Details** — Varies by subtype:
   - 10300 (Utility): Service type (electricity/water/gas/phone), meter number, billing period, consumption, rate, amount
   - 10301 (General): Bill type, bill number, due date, amount
   - 10302 (Internet): ISP name, plan, billing period, amount
   - 10303 (Telecom): Operator, mobile number, package name, validity, amount
   - 10304 (Game): Platform, game name, credit type, amount
   - 10305 (Entertainment): Platform, subscription plan, validity, amount
5. **Payment Method** — Cash / bank / electronic
6. **Amount** — Total + words
7. **Transaction Reference** — Confirmation number
8. **Account Entry** — Debit: Expense Account | Credit: Cash/Bank
9. **Signatures** — Requester | Accountant
10. **Footer**

---

### 3.9 Outgoing Remittance Vouchers (حوالات صادرة) — `10400–10401`, `10500–10501`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10400 | حوالة محلية شخصية صادرة | Domestic Personal Outgoing | إرسال حوالة مالية داخل الدولة للأفراد |
| 10401 | حوالة محلية تجارية صادرة | Domestic Commercial Outgoing | إرسال حوالة مالية داخل الدولة للأغراض التجارية |
| 10500 | حوالة دولية شخصية صادرة | International Personal Outgoing | إرسال حوالة مالية إلى خارج الدولة للأفراد |
| 10501 | حوالة دولية تجارية صادرة | International Commercial Outgoing | إرسال حوالة مالية دولية للأغراض التجارية |

**Template: `RemittanceOutgoingVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Remittance type title + Domestic/International badge
3. **Sender Info** — Name (AR/EN), ID number, phone, address
4. **Beneficiary Info** — Name (AR/EN), ID/passport, phone, address, country (for international)
5. **Remittance Details** — Varies:
   - Domestic (10400/10401): Amount, bank name, account number, purpose
   - International (10500/10501): Source currency, target currency, exchange rate, source amount, target amount, SWIFT/BIC code, correspondent bank, purpose code
6. **Fees** — Transfer fee, exchange margin, total cost
7. **Compliance** — AML reference, purpose of transfer declaration
8. **Amount** — Net amount + words
9. **Tracking** — Reference number, expected delivery date
10. **Signatures** — Sender | Operator | Compliance officer | Manager
11. **Footer**

---

### 3.10 Incoming Remittance Vouchers (حوالات واردة) — `10450–10451`, `10550–10551`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 10450 | حوالة محلية شخصية واردة | Domestic Personal Incoming | استلام حوالة مالية من داخل الدولة |
| 10451 | حوالة محلية تجارية واردة | Domestic Commercial Incoming | استلام حوالة مالية تجارية من داخل الدولة |
| 10550 | حوالة دولية شخصية واردة | International Personal Incoming | استلام حوالة مالية من خارج الدولة |
| 10551 | حوالة دولية تجارية واردة | International Commercial Incoming | استلام حوالة مالية دولية تجارية |

**Template: `RemittanceIncomingVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Remittance type title + Domestic/International badge
3. **Sender Info** — Name, country (for international), bank, reference
4. **Beneficiary Info** — Name (AR/EN), ID number, account number
5. **Remittance Details** — Varies:
   - Domestic (10450/10451): Amount, source bank, reference
   - International (10550/10551): Original currency, converted currency, exchange rate, original amount, converted amount, SWIFT reference
6. **Fees** — Receiving fees, exchange difference
7. **Net Amount** — Amount credited + words
8. **Disbursement Method** — To account / cash / check
9. **Signatures** — Beneficiary | Operator | Manager
10. **Footer**

---

### 3.11 Purchase Vouchers (سندات الشراء) — `20000–20003`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20000 | شراء نقدي | Cash Purchase | شراء بضائع مع الدفع الفوري نقداً |
| 20001 | شراء آجل | Credit Purchase | شراء بضائع مع تأجيل الدفع |
| 20002 | شراء بدفعة مقدمة | Advance Purchase | دفع مبلغ مقدم للمورد قبل استلام البضاعة |
| 20003 | شراء بالتقسيط | Installment Purchase | شراء بضائع مع الدفع على دفعات |

**Template: `PurchaseVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Purchase type title
3. **Supplier Info** — Name (AR/EN), code, VAT number, address, phone
4. **Purchase Order Reference** — PO number, PO date
5. **Items Table** — Columns: # | Item Code | Description (AR) | Description (EN) | Qty | Unit | Unit Price | Discount | Tax | Total
6. **Summary Block**:
   - Subtotal
   - Total Discount
   - Taxable Amount
   - VAT (15%)
   - Grand Total
7. **Payment Terms** — Varies by subtype:
   - 20000 (Cash): Paid in full
   - 20001 (Credit): Due date, credit period, payment terms
   - 20002 (Advance): Advance amount, remaining balance, delivery date
   - 20003 (Installment): Number of installments, installment amount, schedule table (Date | Amount | Status)
8. **Amount in Words** — AR/EN
9. **Warehouse** — Receiving warehouse, received by, date
10. **Signatures** — Purchasing dept | Warehouse | Accountant | Manager
11. **Footer**

---

### 3.12 Sales Vouchers (سندات البيع) — `20200–20203`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20200 | بيع نقدي | Cash Sale | بيع بضائع مع استلام الدفع فوراً نقداً |
| 20201 | بيع آجل | Credit Sale | بيع بضائع مع تأجيل استلام الدفع |
| 20202 | بيع بدفعة مقدمة | Advance Sale | استلام مبلغ مقدم من العميل |
| 20203 | بيع بالتقسيط | Installment Sale | بيع بضائع مع استلام الدفع على دفعات |

**Template: `SalesVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Sale type title
3. **Customer Info** — Name (AR/EN), code, VAT number, address, phone
4. **Sales Order Reference** — SO number, SO date, salesperson
5. **Items Table** — Columns: # | Item Code | Description (AR) | Description (EN) | Qty | Unit | Unit Price | Discount | Tax | Total
6. **Summary Block**:
   - Subtotal
   - Total Discount
   - Taxable Amount
   - VAT (15%)
   - Grand Total
7. **Payment Terms** — Varies by subtype:
   - 20200 (Cash): Received in full
   - 20201 (Credit): Due date, credit period, payment terms
   - 20202 (Advance): Advance amount, remaining balance, expected delivery
   - 20203 (Installment): Number of installments, amount, schedule table
8. **Amount in Words** — AR/EN
9. **Delivery** — Delivery method, shipping address, expected date
10. **Signatures** — Sales dept | Warehouse | Accountant | Customer
11. **Footer**

---

### 3.13 Purchase Return Vouchers (مرتجعات مشتريات) — `20400–20403`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20400 | مرتجع شراء نقدي | Cash Purchase Return | إرجاع بضائع تم شراؤها نقداً |
| 20401 | مرتجع شراء آجل | Credit Purchase Return | إرجاع بضائع تم شراؤها آجلاً |
| 20402 | مرتجع شراء بدفعة مقدمة | Advance Purchase Return | إلغاء طلب شراء تم دفع مقدم له |
| 20403 | مرتجع شراء بالتقسيط | Installment Purchase Return | إرجاع بضائع تم شراؤها بالتقسيط |

**Template: `PurchaseReturnVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Return type title
3. **Supplier Info** — Name (AR/EN), code, VAT number
4. **Original Purchase Reference** — Original voucher number, date, type
5. **Return Reason** — Reason code + description (defective, wrong item, quality issue, order cancellation)
6. **Returned Items Table** — Columns: # | Item Code | Description (AR/EN) | Original Qty | Returned Qty | Unit Price | Tax | Total
7. **Summary Block** — Subtotal, Tax adjustment, Grand Total
8. **Refund/Settlement** — Varies by subtype:
   - 20400 (Cash): Refund amount, refund method
   - 20401 (Credit): Liability reduction amount
   - 20402 (Advance): Advance refund amount, refund method
   - 20403 (Installment): Installment adjustment, remaining balance update
9. **Amount in Words** — AR/EN
10. **Warehouse** — Returned to warehouse, inspected by
11. **Signatures** — Purchasing | Warehouse | Quality | Accountant | Manager
12. **Footer**

---

### 3.14 Sales Return Vouchers (مرتجعات مبيعات) — `20450–20453`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20450 | مرتجع بيع نقدي | Cash Sales Return | استرجاع بضائع بيعت نقداً مع رد المبلغ |
| 20451 | مرتجع بيع آجل | Credit Sales Return | استرجاع بضائع بيعت آجلاً |
| 20452 | مرتجع بيع بدفعة مقدمة | Advance Sales Return | إلغاء طلب بيع تم استلام مقدم له |
| 20453 | مرتجع بيع بالتقسيط | Installment Sales Return | استرجاع بضائع بيعت بالتقسيط |

**Template: `SalesReturnVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Return type title
3. **Customer Info** — Name (AR/EN), code, VAT number
4. **Original Sale Reference** — Original voucher number, date, type
5. **Return Reason** — Reason code + description
6. **Returned Items Table** — Same structure as purchase return
7. **Summary Block** — Subtotal, Tax adjustment, Grand Total
8. **Refund/Settlement** — Varies by subtype:
   - 20450 (Cash): Refund amount, refund method
   - 20451 (Credit): Receivable reduction amount
   - 20452 (Advance): Advance refund to customer
   - 20453 (Installment): Installment adjustment, balance update
9. **Amount in Words** — AR/EN
10. **Warehouse** — Received to warehouse, inspected by
11. **Signatures** — Customer | Sales | Warehouse | Accountant | Manager
12. **Footer**

---

### 3.15 Gift/Grant Vouchers (الهدايا والمنح) — `20500–20501`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20500 | هدية واردة | Received Gift/Grant | استلام بضائع أو أصول كمنحة أو هدية من مورد |
| 20501 | هدية صادرة | Given Gift | تقديم بضائع أو خدمات كهدية للعميل |

**Template: `GiftVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Gift direction title (Received/Given)
3. **Party Info**:
   - 20500: Donor name, reason for gift/grant
   - 20501: Recipient name, occasion/reason
4. **Items Table** — Item code | Description (AR/EN) | Qty | Fair Market Value
5. **Total Value** — Estimated fair value + words
6. **Accounting Treatment**:
   - 20500: Debit: Asset account | Credit: Revenue/Gift income
   - 20501: Debit: Marketing/Promotional expense | Credit: Inventory
7. **Tax Implications** — VAT treatment note
8. **Authorization** — Approval reference
9. **Signatures** — Varies by direction
10. **Footer**

---

### 3.16 Inventory Vouchers (سندات المخزون) — `20600–20604`

| ID | Arabic Name | English Name | Description |
|-------|-------------|-------------|-------------|
| 20600 | إضافة مخزون | Inventory Addition | إضافة بضائع جديدة للمخزون |
| 20601 | صرف مخزون | Inventory Issue | إخراج بضائع من المخزون |
| 20602 | تسوية مخزون | Inventory Adjustment | تصحيح أرصدة المخزون |
| 20603 | تحويل مخزون | Inventory Transfer | نقل بضائع بين مخازن |
| 20604 | إتلاف مخزون | Inventory Damage/Write-off | تسجيل تلف أو فقدان بضائع |

**Template: `InventoryVoucher`**

Layout per voucher page:
1. **Header** — Company info
2. **Voucher Title** — Inventory operation title
3. **Warehouse Info** — Varies by subtype:
   - 20600 (Add): Destination warehouse
   - 20601 (Issue): Source warehouse, department/project requesting
   - 20602 (Adjust): Warehouse, adjustment reason (count, error, revaluation)
   - 20603 (Transfer): Source warehouse → Destination warehouse, transfer reason
   - 20604 (Damage): Warehouse, damage type (expired, broken, lost, obsolete)
4. **Reference** — PO/SO reference, adjustment authorization, transfer order number
5. **Items Table** — Columns: # | Item Code | Description (AR/EN) | Unit | Qty Before | Qty Change | Qty After | Unit Cost | Total Value
   - For 20602 (Adjust): additional column for Variance
   - For 20603 (Transfer): columns for Source Qty / Destination Qty
   - For 20604 (Damage): additional column for Damage Type
6. **Total Value Impact** — Net increase/decrease in inventory value
7. **Accounting Entry**:
   - 20600: Debit: Inventory | Credit: Purchase/WIP
   - 20601: Debit: COGS/Expense | Credit: Inventory
   - 20602: Debit/Credit: Inventory | Credit/Debit: Adjustment account
   - 20603: Debit: Destination Inventory | Credit: Source Inventory
   - 20604: Debit: Loss/Write-off | Credit: Inventory
8. **Notes** — Special handling instructions, disposal method (for damage)
9. **Signatures** — Warehouse keeper | Requesting dept | Accountant | Manager | (For damage: Insurance officer)
10. **Footer**

---

## 4. Common Data Models

### 4.1 `GeniusPdfVoucherData`

```dart
class GeniusPdfVoucherData {
  final String serviceId;          // e.g., "00100"
  final String voucherNumber;      // e.g., "RV-2026-00142"
  final DateTime voucherDate;
  final String? referenceNumber;   // External reference
  final String? fiscalPeriod;      // e.g., "2026-Q1"

  // Party information
  final VoucherParty? party;       // Customer/Supplier/Beneficiary

  // Financial
  final double amount;
  final String currency;           // e.g., "SAR"
  final String? amountInWordsAr;   // Auto-generated if null
  final String? amountInWordsEn;   // Auto-generated if null

  // Line items
  final List<VoucherLineItem> items;

  // Payment details
  final VoucherPaymentDetails? paymentDetails;

  // Account allocation
  final List<VoucherAccountEntry> accountEntries;

  // Metadata
  final String? notes;
  final String? notesAr;
  final Map<String, String> customFields;

  // Signatures
  final List<VoucherSignatory> signatories;
}
```

### 4.2 `VoucherParty`

```dart
class VoucherParty {
  final String name;
  final String? nameAr;
  final String? code;          // Customer/Supplier code
  final String? vatNumber;
  final String? idNumber;      // National ID / CR number
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? bankName;
  final String? bankAccount;
  final String? iban;
}
```

### 4.3 `VoucherLineItem`

```dart
class VoucherLineItem {
  final int lineNumber;
  final String? itemCode;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double? taxRate;
  final double? taxAmount;
  final double totalAmount;
}
```

### 4.4 `VoucherPaymentDetails`

```dart
class VoucherPaymentDetails {
  final VoucherPaymentMethod method;

  // Cash
  final Map<double, int>? denominations;  // For cash denomination breakdown

  // Bank Transfer
  final String? bankName;
  final String? accountNumber;
  final String? iban;
  final String? transferReference;
  final DateTime? transferDate;

  // Check
  final String? checkNumber;
  final String? draweeBankName;
  final String? draweeBranch;
  final DateTime? checkDate;
  final DateTime? dueDate;

  // Electronic
  final String? gatewayName;
  final String? transactionId;
  final String? cardType;
  final String? cardLastFour;

  // Installment
  final int? numberOfInstallments;
  final double? installmentAmount;
  final List<InstallmentScheduleItem>? schedule;

  // Currency Exchange
  final String? sourceCurrency;
  final String? targetCurrency;
  final double? exchangeRate;
  final double? sourceAmount;
  final double? targetAmount;
  final double? exchangeFee;
}

enum VoucherPaymentMethod {
  cash,
  bankTransfer,
  check,
  electronic,
  installment,
  currencyExchange,
}
```

### 4.5 `VoucherAccountEntry`

```dart
class VoucherAccountEntry {
  final String accountCode;
  final String accountName;
  final String? accountNameAr;
  final String? costCenter;
  final double debitAmount;
  final double creditAmount;
  final String? description;
}
```

### 4.6 `VoucherSignatory`

```dart
class VoucherSignatory {
  final String role;           // "Prepared by", "Approved by", etc.
  final String? roleAr;       // "أعد بواسطة", "اعتمد بواسطة"
  final String? name;
  final String? title;
  final DateTime? date;
  final bool showSignatureLine;
}
```

### 4.7 `GeniusPdfVoucherStyle`

```dart
class GeniusPdfVoucherStyle {
  // Colors
  final Color headerColor;
  final Color headerTextColor;
  final Color borderColor;
  final Color tableHeaderColor;
  final Color tableAltRowColor;
  final Color accentColor;
  final Color amountHighlightColor;

  // Layout
  final double headerHeight;
  final double marginTop;
  final double marginBottom;
  final double marginLeft;
  final double marginRight;
  final double sectionSpacing;
  final double signatureBlockHeight;

  // Typography
  final double titleFontSize;
  final double subtitleFontSize;
  final double bodyFontSize;
  final double smallFontSize;

  // Options
  final bool showBorder;
  final bool showLogo;
  final bool showWatermark;
  final String? watermarkText;
  final bool showServiceIdBadge;
  final bool showCopyLabel;         // "Original" / "Copy"
  final int numberOfCopies;         // 1 = original only, 2 = original + copy

  // Pre-built styles
  factory GeniusPdfVoucherStyle.standard();
  factory GeniusPdfVoucherStyle.formal();
  factory GeniusPdfVoucherStyle.minimal();
  factory GeniusPdfVoucherStyle.colorful();
}
```

---

## 5. Multi-Voucher PDF Generation

### 5.1 `GeniusPdfVoucherBatch`

A utility class that generates multiple vouchers in a single PDF:

```dart
class GeniusPdfVoucherBatch extends GeniusPdfDocumentBuilder {
  final List<GeniusPdfVoucherTemplate> vouchers;
  final GeniusPdfVoucherBatchOptions options;

  GeniusPdfVoucherBatch({
    required GeniusPdfConfig config,
    required this.vouchers,
    this.options = const GeniusPdfVoucherBatchOptions(),
  });
}

class GeniusPdfVoucherBatchOptions {
  final bool addPageBreakBetweenVouchers;
  final bool addTableOfContents;
  final bool addBatchSummary;         // Summary page with totals
  final bool groupByServiceId;        // Group vouchers by type
  final String? batchTitle;
  final String? batchTitleAr;
}
```

### 5.2 Usage Example

```dart
final config = GeniusPdfConfig(baseFontBytes: fontBytes, textDirection: TextDirection.rtl);

final batch = GeniusPdfVoucherBatch(
  config: config,
  vouchers: [
    ReceiptVoucher(
      config: config,
      data: GeniusPdfVoucherData(
        serviceId: '00100',
        voucherNumber: 'RV-2026-001',
        voucherDate: DateTime.now(),
        amount: 15000,
        currency: 'SAR',
        party: VoucherParty(name: 'Ahmed Mohammed', nameAr: 'أحمد محمد'),
        items: [...],
        signatories: [...],
      ),
    ),
    PaymentVoucher(
      config: config,
      data: GeniusPdfVoucherData(
        serviceId: '00201',
        voucherNumber: 'PV-2026-042',
        voucherDate: DateTime.now(),
        amount: 8500,
        currency: 'SAR',
        party: VoucherParty(name: 'ABC Supplies', nameAr: 'مؤسسة أبك للتوريدات'),
        paymentDetails: VoucherPaymentDetails(
          method: VoucherPaymentMethod.bankTransfer,
          bankName: 'Al Rajhi Bank',
          transferReference: 'TRF-20260204-001',
        ),
        items: [...],
        signatories: [...],
      ),
    ),
  ],
  options: GeniusPdfVoucherBatchOptions(
    addPageBreakBetweenVouchers: true,
    addBatchSummary: true,
    batchTitle: 'Daily Vouchers - Feb 4, 2026',
    batchTitleAr: 'سندات اليوم - 4 فبراير 2026',
  ),
);

final bytes = batch.generate();
```

---

## 6. Amount to Words Utility

A built-in utility for converting numeric amounts to Arabic and English words:

```dart
class AmountToWords {
  /// Converts amount to Arabic words
  /// e.g., 15750.50 → "خمسة عشر ألفاً وسبعمائة وخمسون ريالاً وخمسون هللة"
  static String toArabic(double amount, {String currency = 'SAR'});

  /// Converts amount to English words
  /// e.g., 15750.50 → "Fifteen Thousand Seven Hundred Fifty Riyals and Fifty Halalas"
  static String toEnglish(double amount, {String currency = 'SAR'});

  /// Supported currencies with their subunit names
  static const Map<String, CurrencyInfo> currencies;
}

class CurrencyInfo {
  final String nameEn;
  final String nameAr;
  final String subunitEn;
  final String subunitAr;
  final int decimalPlaces;
}
```

---

## 7. Implementation Phases

### Phase 1: Core Infrastructure (v3.0.0)
- [ ] `GeniusPdfVoucherTemplate` base class
- [ ] `GeniusPdfVoucherData` and related models
- [ ] `GeniusPdfVoucherStyle` with pre-built styles
- [ ] `AmountToWords` utility (Arabic + English)
- [ ] `VoucherSignatory` and signature block rendering
- [ ] `GeniusPdfVoucherBatch` for multi-voucher PDFs

### Phase 2: Financial Vouchers (v3.1.0)
- [ ] `AccountingEntryVoucher` (00001–00004)
- [ ] `ReceiptVoucher` (00100–00103)
- [ ] `PaymentVoucher` (00200–00203)
- [ ] `TaxVoucher` (00300–00304)

### Phase 3: Banking Vouchers (v3.2.0)
- [ ] `BankDepositVoucher` (10000–10002)
- [ ] `BankWithdrawalVoucher` (10100–10102)
- [ ] `TransferVoucher` (10200–10203)
- [ ] `BillPaymentVoucher` (10300–10305)

### Phase 4: Remittance Vouchers (v3.3.0)
- [ ] `RemittanceOutgoingVoucher` (10400–10401, 10500–10501)
- [ ] `RemittanceIncomingVoucher` (10450–10451, 10550–10551)

### Phase 5: Trade Vouchers (v3.4.0)
- [ ] `PurchaseVoucher` (20000–20003)
- [ ] `SalesVoucher` (20200–20203)
- [ ] `PurchaseReturnVoucher` (20400–20403)
- [ ] `SalesReturnVoucher` (20450–20453)

### Phase 6: Auxiliary Vouchers (v3.5.0)
- [ ] `GiftVoucher` (20500–20501)
- [ ] `InventoryVoucher` (20600–20604)

### Phase 7: Examples & Documentation (v3.6.0)
- [ ] Example app with all voucher types
- [ ] README documentation
- [ ] CHANGELOG updates
- [ ] Batch generation examples

---

## 8. Template Count Summary

| Category | Template Class | Service IDs | Subtypes |
|----------|---------------|-------------|----------|
| Accounting Entries | `AccountingEntryVoucher` | 00001–00004 | 4 |
| Receipt Vouchers | `ReceiptVoucher` | 00100–00103 | 4 |
| Payment Vouchers | `PaymentVoucher` | 00200–00203 | 4 |
| Tax Vouchers | `TaxVoucher` | 00300–00304 | 5 |
| Bank Deposits | `BankDepositVoucher` | 10000–10002 | 3 |
| Bank Withdrawals | `BankWithdrawalVoucher` | 10100–10102 | 3 |
| Transfers | `TransferVoucher` | 10200–10203 | 4 |
| Bill Payments | `BillPaymentVoucher` | 10300–10305 | 6 |
| Outgoing Remittances | `RemittanceOutgoingVoucher` | 10400–10501 | 4 |
| Incoming Remittances | `RemittanceIncomingVoucher` | 10450–10551 | 4 |
| Purchases | `PurchaseVoucher` | 20000–20003 | 4 |
| Sales | `SalesVoucher` | 20200–20203 | 4 |
| Purchase Returns | `PurchaseReturnVoucher` | 20400–20403 | 4 |
| Sales Returns | `SalesReturnVoucher` | 20450–20453 | 4 |
| Gifts/Grants | `GiftVoucher` | 20500–20501 | 2 |
| Inventory | `InventoryVoucher` | 20600–20604 | 5 |
| **Total** | **16 template classes** | | **64 subtypes** |
