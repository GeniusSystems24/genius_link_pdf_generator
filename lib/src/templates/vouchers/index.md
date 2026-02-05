# 📋 أنواع العمليات

## الفهرس

📋 Operation Types / أنواع العمليات  
│  
├── [💰 Financial Operations (00000-09999) / العمليات المالية](./financial_operations/index.md)  
│   ├── [📒 Journal Entries (00000-00099) / قيود اليومية](./financial_operations/journal_entries.md)  
│   │   ├── [00001 - Simple Entry / قيد بسيط](./financial_operations/journal_entries.md#-عملية-قيد-بسيط-ورقمها-00001)  
│   │   ├── [00002 - Compound Entry / قيد مركب](./financial_operations/journal_entries.md#-عملية-قيد-مركب-ورقمها-00002)  
│   │   ├── [00003 - Opening Entry / قيد افتتاحي](./financial_operations/journal_entries.md#-عملية-قيد-افتتاحي-ورقمها-00003)  
│   │   └── [00004 - Adjustment Entry / قيد تسوية](./financial_operations/journal_entries.md#-عملية-قيد-تسوية-ورقمها-00004)  
│   │  
│   ├── [🧾 Receipt Vouchers (00100-00199) / سندات القبض](./financial_operations/income_vouchers.md)  
│   │   ├── [00100 - Cash Receipt / سند قبض نقدي](./financial_operations/income_vouchers.md#-سند-قبض-نقدي-ورقمها-00100)  
│   │   ├── [00101 - Bank Receipt / سند قبض بنكي](./financial_operations/income_vouchers.md#-سند-قبض-بنكي-ورقمها-00101)  
│   │   ├── [00102 - Check Receipt / سند قبض بشيك](./financial_operations/income_vouchers.md#-سند-قبض-بشيك-ورقمها-00102)  
│   │   └── [00103 - Electronic Receipt / سند قبض إلكتروني](./financial_operations/income_vouchers.md#-سند-قبض-إلكتروني-ورقمها-00103)  
│   │  
│   ├── [💸 Payment Vouchers (00200-00299) / سندات الصرف](./financial_operations/outcome_vouchers.md)  
│   │   ├── [00200 - Cash Payment / سند صرف نقدي](./financial_operations/outcome_vouchers.md#-سند-صرف-نقدي-ورقمها-00200)  
│   │   ├── [00201 - Bank Payment / سند صرف بنكي](./financial_operations/outcome_vouchers.md#-سند-صرف-بنكي-ورقمها-00201)  
│   │   ├── [00202 - Check Payment / سند صرف بشيك](./financial_operations/outcome_vouchers.md#-سند-صرف-بشيك-ورقمها-00202)  
│   │   └── [00203 - Electronic Payment / سند صرف إلكتروني](./financial_operations/outcome_vouchers.md#-سند-صرف-إلكتروني-ورقمها-00203)  
│   │  
│   └── [🧾💼 Tax Vouchers (00300-00399) / سندات ضريبية](./financial_operations/tax_vouchers.md)  
│       ├── [00300 - Income Tax / سند ضريبة دخل](./financial_operations/tax_vouchers.md#-سند-ضريبة-دخل-ورقمها-00300)  
│       ├── [00301 - VAT / سند ضريبة قيمة مضافة](./financial_operations/tax_vouchers.md#-سند-ضريبة-قيمة-مضافة-ورقمها-00301)  
│       ├── [00302 - Government Fees / سند رسوم حكومية](./financial_operations/tax_vouchers.md#-سند-رسوم-حكومية-ورقمها-00302)  
│       ├── [00303 - Customs Duties / سند رسوم جمركية](./financial_operations/tax_vouchers.md#-سند-رسوم-جمركية-ورقمها-00303)  
│       └── [00304 - Tax Settlement / سند تسوية ضريبية](./financial_operations/tax_vouchers.md#-سند-تسوية-ضريبية-ورقمها-00304)  
│  
├── [🏦 Banking Operations (10000-19999) / العمليات المصرفية](./banking_operations/index.md)  
│   ├── [💰 Deposit Operations (10000-10099) / عمليات الإيداع](./banking_operations/deposit_operations.md)  
│   │   ├── [10000 - Cash Deposit / إيداع نقدي](./banking_operations/deposit_operations.md#-إيداع-نقدي-ورقمها-10000)  
│   │   ├── [10001 - Check Deposit / إيداع بشيك](./banking_operations/deposit_operations.md#-إيداع-شيك-ورقمها-10001)  
│   │   └── [10002 - Electronic Deposit / إيداع إلكتروني](./banking_operations/deposit_operations.md#-إيداع-إلكتروني-ورقمها-10002)
│   │  
│   ├── [💸 Withdrawal Operations (10100-10199) / عمليات السحب](./banking_operations/withdrawal_operations.md)  
│   │   ├── [10100 - Cash Withdrawal / سحب نقدي](./banking_operations/withdrawal_operations.md#-سحب-نقدي-ورقمها-10100)  
│   │   ├── [10101 - Check Withdrawal / سحب بشيك](./banking_operations/withdrawal_operations.md#-سحب-شيك-ورقمها-10101)  
│   │   └── [10102 - ATM Withdrawal / سحب عبر صراف آلي](./banking_operations/withdrawal_operations.md#-سحب-عبر-صراف-آلي-ورقمها-10102)  
│   │  
│   ├── [🔄 Transfer Operations (10200-10299) / عمليات التحويل](./banking_operations/transfer_operations.md)  
│   │   ├── [10200 - Inter-Bank Transfer / تحويل لحساب](./banking_operations/transfer_operations.md#-تحويل-لحساب-ورقمها-10200)  
│   │   ├── [10201 - Multi-Currency Exchange / مصارفة عملات مختلفة](./banking_operations/transfer_operations.md#-مصارفة-عملات-مختلفة-ورقمها-10201)  
│   │   └── [10202 - Electronic Transfer / تحويل إلكتروني](./banking_operations/transfer_operations.md#-تحويل-إلكتروني-ورقمها-10202)  
│   │  
│   ├── [🌐 Electronic Services (10300-10399) / خدمات الشحن والدفع الإلكتروني](./banking_operations/electronic_payment_operations.md)  
│   │   ├── [10300 - Utility Bills Payment / دفع فواتير الخدمات المنزلية](./banking_operations/electronic_payment_operations.md#-دفع-فواتير-الخدمات-المنزلية-ورقمها-10300)  
│   │   ├── [10301 - Miscellaneous Bills Payment / دفع فواتير متنوعة](./banking_operations/electronic_payment_operations.md#-دفع-فواتير-متنوعة-ورقمها-10301)  
│   │   ├── [10302 - Internet Bills Payment / دفع فواتير الإنترنت](./banking_operations/electronic_payment_operations.md#-دفع-فواتير-الإنترنت-ورقمها-10302)  
│   │   ├── [10303 - Telecom Package Renewal / تجديد باقات الاتصالات](./banking_operations/electronic_payment_operations.md#-تجديد-باقات-الاتصالات-ورقمها-10303)  
│   │   ├── [10304 - Gaming Credits Recharge / شحن ألعاب إلكترونية](./banking_operations/electronic_payment_operations.md#-شحن-ألعاب-إلكترونية-ورقمها-10304)  
│   │   └── [10305 - Entertainment Apps Recharge / شحن تطبيقات ترفيهية](./banking_operations/electronic_payment_operations.md#-شحن-تطبيقات-ترفيهية-ورقمها-10305)  
│   │  
│   ├── [🏦 Local Money Transfers (10400-10499) / الحوالات المصرفية المحلية](./banking_operations/local_transfers.md)  
│   │   ├── [📤 Outgoing Local Transfers (10400-10449) / إرسال الحوالات المحلية](./banking_operations/local_transfers.md)  
│   │   │   ├── [10400 - Send Regular Local Transfer / إرسال حوالة محلية عادية](./banking_operations/local_transfers.md#-إرسال-حوالة-محلية-عادية-ورقمها-10400)  
│   │   │   └── [10401 - Send Commercial Local Transfer / إرسال حوالة محلية تجارية](./banking_operations/local_transfers.md#-إرسال-حوالة-محلية-تجارية-ورقمها-10401)  
│   │   └── [📥 Incoming Local Transfers (10450-10499) / استلام الحوالات المحلية](./banking_operations/local_transfers.md)  
│   │       ├── [10450 - Receive Regular Local Transfer / إستلام حوالة محلية عادية](./banking_operations/local_transfers.md#-إستلام-حوالة-محلية-عادية-ورقمها-10450)  
│   │       └── [10451 - Receive Commercial Local Transfer / إستلام حوالة محلية تجارية](./banking_operations/local_transfers.md#-إستلام-حوالة-محلية-تجارية-ورقمها-10451)  
│   │  
│   └── [🌍 International Money Transfers (10500-10599) / الحوالات المصرفية الدولية](./banking_operations/international_transfers.md)  
│       ├── [📤 Outgoing International Transfers (10500-10549) / إرسال الحوالات الدولية](./banking_operations/international_transfers.md)  
│       │   ├── [10500 - Send Regular International Transfer / إرسال حوالة دولية عادية](./banking_operations/international_transfers.md#-إرسال-حوالة-دولية-عادية-ورقمها-10500)  
│       │   └── [10501 - Send Commercial International Transfer / إرسال حوالة دولية تجارية](./banking_operations/international_transfers.md#-إرسال-حوالة-دولية-تجارية-ورقمها-10501)  
│       └── [📥 Incoming International Transfers (10550-10599) / استلام الحوالات الدولية](./banking_operations/international_transfers.md)  
│           ├── [10550 - Receive Regular International Transfer / إستلام حوالة دولية عادية](./banking_operations/international_transfers.md#-إستلام-حوالة-دولية-عادية-ورقمها-10550)  
│           └── [10551 - Receive Commercial International Transfer / إستلام حوالة دولية تجارية](./banking_operations/international_transfers.md#-إستلام-حوالة-دولية-تجارية-ورقمها-10551)  
│  
└── [🛒 Commercial Operations (20000-29999) / العمليات التجارية](./commercial_operations/index.md)  
    ├── [🛍️ Purchase Operations (20000-20199) / عمليات الشراء](./commercial_operations/purchase_operations.md)  
    │   ├── [20000 - Cash Purchase / عملية شراء بضاعة نقداً](./commercial_operations/purchase_operations.md#-شراء-بضاعة-نقداً-ورقمها-20000)  
    │   ├── [20001 - Credit Purchase / عملية شراء بضاعة آجلاً](./commercial_operations/purchase_operations.md#-عملية-شراء-بضاعة-آجلاً-ورقمها-20001)  
    │   ├── [20002 - Advance Purchase / عملية شراء بضاعة مقدماً](./commercial_operations/purchase_operations.md#-عملية-شراء-بضاعة-مقدماً-ورقمها-20002)  
    │   └── [20003 - Installment Purchase / عملية شراء بضاعة بالتقسيط](./commercial_operations/purchase_operations.md#-عملية-شراء-بضاعة-بالتقسيط-ورقمها-20003)  
    │  
    ├── [🛒 Sales Operations (20200-20399) / عمليات البيع](./commercial_operations/sales_operations.md)  
    │   ├── [20200 - Cash Sale / عملية بيع بضاعة نقداً](./commercial_operations/sales_operations.md#-عملية-بيع-بضاعة-نقداً-ورقمها-20200)  
    │   ├── [20201 - Credit Sale / عملية بيع بضاعة آجلاً](./commercial_operations/sales_operations.md#-عملية-بيع-بضاعة-آجلاً-ورقمها-20201)  
    │   ├── [20202 - Advance Sale / عملية بيع بضاعة مقدماً](./commercial_operations/sales_operations.md#-عملية-بيع-بضاعة-مقدماً-ورقمها-20202)  
    │   └── [20203 - Installment Sale / عملية بيع بضاعة بالتقسيط](./commercial_operations/sales_operations.md#-عملية-بيع-بضاعة-بالتقسيط-ورقمها-20203)  
    │  
    ├── [🔄 Purchase Returns (20400-20449) / عمليات مردود الشراء](./commercial_operations/purchase_returns.md)  
    │   ├── [20400 - Cash Purchase Return / عملية مردود شراء بضاعة نقداً](./commercial_operations/purchase_returns.md#-عملية-مردود-شراء-بضاعة-نقداً-ورقمها-20400)  
    │   ├── [20401 - Credit Purchase Return / عملية مردود شراء بضاعة آجلاً](./commercial_operations/purchase_returns.md#-عملية-مردود-شراء-بضاعة-آجلاً-ورقمها-20401)  
    │   ├── [20402 - Advance Purchase Return / عملية مردود شراء بضاعة مقدماً](./commercial_operations/purchase_returns.md#-عملية-مردود-شراء-بضاعة-مقدماً-ورقمها-20402)  
    │   └── [20403 - Installment Purchase Return / عملية مردود شراء بضاعة بالتقسيط](./commercial_operations/purchase_returns.md#-عملية-مردود-شراء-بضاعة-بالتقسيط-ورقمها-20403)  
    │  
    ├── [🔄 Sales Returns (20450-20499) / عمليات مردود البيع](./commercial_operations/sales_returns.md)  
    │   ├── [20450 - Cash Sale Return / عملية مردود بيع بضاعة نقداً](./commercial_operations/sales_returns.md#-عملية-مردود-بيع-بضاعة-نقداً-ورقمها-20450)  
    │   ├── [20451 - Credit Sale Return / عملية مردود بيع بضاعة آجلاً](./commercial_operations/sales_returns.md#-عملية-مردود-بيع-بضاعة-آجلاً-ورقمها-20451)  
    │   ├── [20452 - Advance Sale Return / عملية مردود بيع بضاعة مقدماً](./commercial_operations/sales_returns.md#-عملية-مردود-بيع-بضاعة-مقدماً-ورقمها-20452)  
    │   └── [20453 - Installment Sale Return / عملية مردود بيع بضاعة بالتقسيط](./commercial_operations/sales_returns.md#-عملية-مردود-بيع-بضاعة-بالتقسيط-ورقمها-20453)  
    │  
    ├── [🎁 Gifts and Grants (20500-20599) / عمليات المنح والهدايا](./commercial_operations/grants_and_gifts.md)  
    │   ├── [20500 - Grant Products / منحة سلعية](./commercial_operations/grants_and_gifts.md#-منحة-سلعية-ورقمها-20500)  
    │   └── [20550 - Gift Products / هدية سلعية](./commercial_operations/grants_and_gifts.md#-هدية-سلعية-ورقمها-20550)
    │  
    └── [📦 Inventory Operations (20600-20699) / عمليات المخزون](./commercial_operations/inventory_operations.md)  
        ├── [20600 - Inventory Supply / عملية توريد مخزون](./commercial_operations/inventory_operations.md#-عملية-توريد-مخزون-ورقمها-20600)  
        ├── [20601 - Inventory Issue / عملية صرف مخزون](./commercial_operations/inventory_operations.md#-عملية-صرف-مخزون-ورقمها-20601)  
        ├── [20602 - Inventory Adjustment / عملية تسوية مخزون](./commercial_operations/inventory_operations.md#-عملية-تسوية-مخزون-ورقمها-20602)  
        ├── [20603 - Inventory Transfer / عملية تحويل مخزون](./commercial_operations/inventory_operations.md#-عملية-تحويل-مخزون-ورقمها-20603)  
        └── [20604 - Inventory Damage / عملية تلف مخزون](./commercial_operations/inventory_operations.md#-عملية-تلف-مخزون-ورقمها-20604)  
  
📊 Operation Numbering System / نظام ترقيم العمليات:  
├── Range 00000-09999: Financial Operations / العمليات المالية  
├── Range 10000-19999: Banking Operations / العمليات المصرفية
└── Range 20000-29999: Commercial Operations / العمليات التجارية  
  
🔍 Operation Type Categories / فئات أنواع العمليات:  
├── 💰 Financial: Direct money collection/payment without additional costs  
├── 🏦 Banking: Bank-related operations with possible fees and commissions  
└── 🛒 Commercial: Trade operations with inventory, tax, and cost implications  
  
## 🗂️ المخطط

ملاحظة: تمت إزالة المخطط واستبداله بوصف نصي وروابط الأقسام أعلاه.
