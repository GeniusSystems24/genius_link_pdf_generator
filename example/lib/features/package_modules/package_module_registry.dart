class PackageModuleExample {
  const PackageModuleExample({
    required this.id,
    required this.title,
    this.titleAr = '',
  });

  final String id;
  final String title;
  final String titleAr;
}

abstract final class PackageModuleRegistry {
  static List<PackageModuleExample> forModule(String moduleId) => switch (moduleId) {
    'erp-families' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'transaction-family',
        title: 'Transaction family',
        titleAr: 'عائلة المعاملات',
      ),
      PackageModuleExample(
        id: 'statement-family',
        title: 'Statement family',
        titleAr: 'عائلة الكشوفات',
      ),
      PackageModuleExample(
        id: 'voucher-family',
        title: 'Voucher family',
        titleAr: 'عائلة السندات',
      ),
      PackageModuleExample(
        id: 'analytical-report',
        title: 'Analytical report',
        titleAr: 'تقرير تحليلي',
      ),
      PackageModuleExample(
        id: 'operational-form',
        title: 'Operational form',
        titleAr: 'نموذج تشغيلي',
      ),
      PackageModuleExample(
        id: 'register',
        title: 'Register',
        titleAr: 'سجل',
      ),
      PackageModuleExample(
        id: 'thermal-receipt',
        title: 'Thermal receipt',
        titleAr: 'إيصال حراري',
      ),
      PackageModuleExample(
        id: 'label',
        title: 'Label',
        titleAr: 'ملصق',
      ),
      PackageModuleExample(
        id: 'certificate',
        title: 'Certificate',
        titleAr: 'شهادة',
      ),
      PackageModuleExample(
        id: 'replacement-custom-section',
        title: 'Replacement / custom section',
        titleAr: 'قسم بديل / مخصص',
      ),
      PackageModuleExample(
        id: 'long-multi-page-transaction',
        title: 'Long multi-page transaction',
        titleAr: 'معاملة طويلة متعددة الصفحات',
      ),
    ],
    'erp-packs' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'baseline-calculation',
        title: 'Baseline calculation',
        titleAr: 'الحساب الأساسي',
      ),
      PackageModuleExample(
        id: 'discount-before-tax',
        title: 'Discount before tax',
        titleAr: 'الخصم قبل الضريبة',
      ),
      PackageModuleExample(
        id: 'discount-after-tax',
        title: 'Discount after tax',
        titleAr: 'الخصم بعد الضريبة',
      ),
      PackageModuleExample(
        id: 'multi-tax-compound',
        title: 'Multi-tax / compound',
        titleAr: 'ضرائب متعددة / مركبة',
      ),
      PackageModuleExample(
        id: 'document-base-currency',
        title: 'Document/base currency',
        titleAr: 'عملة المستند / العملة الأساسية',
      ),
      PackageModuleExample(
        id: 'rounding-adjustment',
        title: 'Rounding adjustment',
        titleAr: 'تسوية التقريب',
      ),
      PackageModuleExample(
        id: 'paid-due',
        title: 'Paid / due',
        titleAr: 'المدفوع / المستحق',
      ),
      PackageModuleExample(
        id: 'zero-negative-policy',
        title: 'Zero / negative policy',
        titleAr: 'سياسة القيم الصفرية / السالبة',
      ),
      PackageModuleExample(
        id: 'null-optional-metadata',
        title: 'Null optional metadata',
        titleAr: 'بيانات اختيارية فارغة',
      ),
      PackageModuleExample(
        id: 'long-multi-page',
        title: 'Long / multi-page',
        titleAr: 'طويل / متعدد الصفحات',
      ),
    ],
    'sales-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'sales-order',
        title: 'Sales Order',
        titleAr: 'أمر مبيعات',
      ),
      PackageModuleExample(
        id: 'proforma-invoice',
        title: 'Proforma Invoice',
        titleAr: 'فاتورة مبدئية',
      ),
      PackageModuleExample(
        id: 'simplified-pos-invoice',
        title: 'Simplified / POS Invoice',
        titleAr: 'فاتورة مبسطة / نقاط بيع',
      ),
      PackageModuleExample(
        id: 'debit-note',
        title: 'Debit Note',
        titleAr: 'إشعار مدين',
      ),
      PackageModuleExample(
        id: 'sales-return',
        title: 'Sales Return',
        titleAr: 'مرتجع مبيعات',
      ),
      PackageModuleExample(
        id: 'customer-receipt',
        title: 'Customer Receipt',
        titleAr: 'سند قبض عميل',
      ),
      PackageModuleExample(
        id: 'picking-list',
        title: 'Picking List',
        titleAr: 'قائمة تجهيز',
      ),
      PackageModuleExample(
        id: 'packing-list',
        title: 'Packing List',
        titleAr: 'قائمة تعبئة',
      ),
      PackageModuleExample(
        id: 'backorder',
        title: 'Backorder',
        titleAr: 'طلبات مؤجلة',
      ),
      PackageModuleExample(
        id: 'customer-aging',
        title: 'Customer Aging',
        titleAr: 'أعمار ديون العملاء',
      ),
      PackageModuleExample(
        id: 'sales-register',
        title: 'Sales Register',
        titleAr: 'سجل المبيعات',
      ),
      PackageModuleExample(
        id: 'sales-by-customer',
        title: 'Sales by Customer',
        titleAr: 'المبيعات حسب العميل',
      ),
      PackageModuleExample(
        id: 'sales-by-item',
        title: 'Sales by Item',
        titleAr: 'المبيعات حسب الصنف',
      ),
      PackageModuleExample(
        id: 'sales-by-salesperson',
        title: 'Sales by Salesperson',
        titleAr: 'المبيعات حسب المندوب',
      ),
      PackageModuleExample(
        id: 'price-list',
        title: 'Price List',
        titleAr: 'قائمة الأسعار',
      ),
      PackageModuleExample(
        id: 'commission-report',
        title: 'Commission Report',
        titleAr: 'تقرير العمولات',
      ),
    ],
    'purchasing-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'purchase-requisition',
        title: 'Purchase Requisition',
        titleAr: 'طلب شراء',
      ),
      PackageModuleExample(
        id: 'request-for-quotation',
        title: 'Request for Quotation',
        titleAr: 'طلب عرض سعر',
      ),
      PackageModuleExample(
        id: 'supplier-quotation',
        title: 'Supplier Quotation',
        titleAr: 'عرض سعر مورد',
      ),
      PackageModuleExample(
        id: 'quotation-comparison',
        title: 'Quotation Comparison',
        titleAr: 'مقارنة عروض الأسعار',
      ),
      PackageModuleExample(
        id: 'purchase-order',
        title: 'Purchase Order',
        titleAr: 'أمر شراء',
      ),
      PackageModuleExample(
        id: 'goods-receipt-note',
        title: 'Goods Receipt Note',
        titleAr: 'إشعار استلام بضاعة',
      ),
      PackageModuleExample(
        id: 'purchase-invoice',
        title: 'Purchase Invoice',
        titleAr: 'فاتورة مشتريات',
      ),
      PackageModuleExample(
        id: 'purchase-debit-note',
        title: 'Purchase Debit Note',
        titleAr: 'إشعار مدين مشتريات',
      ),
      PackageModuleExample(
        id: 'purchase-credit-note',
        title: 'Purchase Credit Note',
        titleAr: 'إشعار دائن مشتريات',
      ),
      PackageModuleExample(
        id: 'supplier-return',
        title: 'Supplier Return',
        titleAr: 'مرتجع مورد',
      ),
      PackageModuleExample(
        id: 'supplier-statement',
        title: 'Supplier Statement',
        titleAr: 'كشف حساب مورد',
      ),
      PackageModuleExample(
        id: 'supplier-aging',
        title: 'Supplier Aging',
        titleAr: 'أعمار ديون الموردين',
      ),
      PackageModuleExample(
        id: 'purchase-register',
        title: 'Purchase Register',
        titleAr: 'سجل المشتريات',
      ),
      PackageModuleExample(
        id: 'purchase-analysis',
        title: 'Purchase Analysis',
        titleAr: 'تحليل المشتريات',
      ),
      PackageModuleExample(
        id: 'outstanding-purchase-orders',
        title: 'Outstanding Purchase Orders',
        titleAr: 'أوامر الشراء المعلقة',
      ),
    ],
    'accounting-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'general-ledger',
        title: 'General Ledger',
        titleAr: 'دفتر الأستاذ العام',
      ),
      PackageModuleExample(
        id: 'journal-entry',
        title: 'Journal Entry',
        titleAr: 'قيد يومية',
      ),
      PackageModuleExample(
        id: 'journal-register',
        title: 'Journal Register',
        titleAr: 'سجل اليومية',
      ),
      PackageModuleExample(
        id: 'account-statement',
        title: 'Account Statement',
        titleAr: 'كشف حساب',
      ),
      PackageModuleExample(
        id: 'ar-aging',
        title: 'AR Aging',
        titleAr: 'أعمار الذمم المدينة',
      ),
      PackageModuleExample(
        id: 'ap-aging',
        title: 'AP Aging',
        titleAr: 'أعمار الذمم الدائنة',
      ),
      PackageModuleExample(
        id: 'customer-balances',
        title: 'Customer Balances',
        titleAr: 'أرصدة العملاء',
      ),
      PackageModuleExample(
        id: 'supplier-balances',
        title: 'Supplier Balances',
        titleAr: 'أرصدة الموردين',
      ),
      PackageModuleExample(
        id: 'cash-book',
        title: 'Cash Book',
        titleAr: 'دفتر النقدية',
      ),
      PackageModuleExample(
        id: 'bank-book',
        title: 'Bank Book',
        titleAr: 'دفتر البنك',
      ),
      PackageModuleExample(
        id: 'bank-reconciliation',
        title: 'Bank Reconciliation',
        titleAr: 'تسوية بنكية',
      ),
      PackageModuleExample(
        id: 'petty-cash',
        title: 'Petty Cash',
        titleAr: 'العهدة النقدية',
      ),
      PackageModuleExample(
        id: 'payment-register',
        title: 'Payment Register',
        titleAr: 'سجل المدفوعات',
      ),
      PackageModuleExample(
        id: 'receipt-register',
        title: 'Receipt Register',
        titleAr: 'سجل المقبوضات',
      ),
      PackageModuleExample(
        id: 'vat-tax-summary',
        title: 'VAT / Tax Summary',
        titleAr: 'ملخص ضريبة القيمة المضافة / الضرائب',
      ),
      PackageModuleExample(
        id: 'tax-register',
        title: 'Tax Register',
        titleAr: 'سجل الضرائب',
      ),
      PackageModuleExample(
        id: 'tax-breakdown',
        title: 'Tax Breakdown',
        titleAr: 'تفصيل الضرائب',
      ),
      PackageModuleExample(
        id: 'rounding-reconciliation',
        title: 'Rounding / Reconciliation',
        titleAr: 'التقريب / المطابقة',
      ),
      PackageModuleExample(
        id: 'cost-center-statement',
        title: 'Cost Center Statement',
        titleAr: 'كشف مركز تكلفة',
      ),
      PackageModuleExample(
        id: 'cost-center-trial-balance',
        title: 'Cost Center Trial Balance',
        titleAr: 'ميزان مراجعة مركز تكلفة',
      ),
      PackageModuleExample(
        id: 'project-financial',
        title: 'Project Financial',
        titleAr: 'تقرير مالي للمشروع',
      ),
      PackageModuleExample(
        id: 'budget-vs-actual',
        title: 'Budget vs Actual',
        titleAr: 'الموازنة مقابل الفعلي',
      ),
      PackageModuleExample(
        id: 'multi-period-comparison',
        title: 'Multi-period Comparison',
        titleAr: 'مقارنة متعددة الفترات',
      ),
    ],
    'inventory-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'stock-receipt',
        title: 'Stock Receipt',
        titleAr: 'استلام مخزون',
      ),
      PackageModuleExample(
        id: 'stock-issue',
        title: 'Stock Issue',
        titleAr: 'صرف مخزون',
      ),
      PackageModuleExample(
        id: 'stock-transfer',
        title: 'Stock Transfer',
        titleAr: 'تحويل مخزون',
      ),
      PackageModuleExample(
        id: 'warehouse-transfer',
        title: 'Warehouse Transfer',
        titleAr: 'تحويل مستودع',
      ),
      PackageModuleExample(
        id: 'stock-adjustment',
        title: 'Stock Adjustment',
        titleAr: 'تسوية مخزون',
      ),
      PackageModuleExample(
        id: 'stock-count',
        title: 'Stock Count',
        titleAr: 'جرد مخزون',
      ),
      PackageModuleExample(
        id: 'cycle-count',
        title: 'Cycle Count',
        titleAr: 'جرد دوري',
      ),
      PackageModuleExample(
        id: 'count-reconciliation',
        title: 'Count Reconciliation',
        titleAr: 'مطابقة الجرد',
      ),
      PackageModuleExample(
        id: 'item-card',
        title: 'Item Card',
        titleAr: 'بطاقة صنف',
      ),
      PackageModuleExample(
        id: 'stock-ledger',
        title: 'Stock Ledger',
        titleAr: 'دفتر حركة المخزون',
      ),
      PackageModuleExample(
        id: 'stock-valuation',
        title: 'Stock Valuation',
        titleAr: 'تقييم المخزون',
      ),
      PackageModuleExample(
        id: 'stock-availability',
        title: 'Stock Availability',
        titleAr: 'توفر المخزون',
      ),
      PackageModuleExample(
        id: 'reorder-report',
        title: 'Reorder Report',
        titleAr: 'تقرير إعادة الطلب',
      ),
      PackageModuleExample(
        id: 'min-max-report',
        title: 'Min / Max Report',
        titleAr: 'تقرير الحد الأدنى / الأعلى',
      ),
      PackageModuleExample(
        id: 'slow-dead-stock',
        title: 'Slow / Dead Stock',
        titleAr: 'المخزون البطيء / الراكد',
      ),
      PackageModuleExample(
        id: 'batch-report',
        title: 'Batch Report',
        titleAr: 'تقرير الدفعات',
      ),
      PackageModuleExample(
        id: 'serial-report',
        title: 'Serial Report',
        titleAr: 'تقرير الأرقام التسلسلية',
      ),
      PackageModuleExample(
        id: 'expiry-report',
        title: 'Expiry Report',
        titleAr: 'تقرير الصلاحية',
      ),
      PackageModuleExample(
        id: 'item-label',
        title: 'Item Label',
        titleAr: 'ملصق صنف',
      ),
      PackageModuleExample(
        id: 'shelf-label',
        title: 'Shelf Label',
        titleAr: 'ملصق رف',
      ),
      PackageModuleExample(
        id: 'batch-label',
        title: 'Batch Label',
        titleAr: 'ملصق دفعة',
      ),
      PackageModuleExample(
        id: 'serial-label',
        title: 'Serial Label',
        titleAr: 'ملصق تسلسلي',
      ),
      PackageModuleExample(
        id: 'location-label',
        title: 'Location Label',
        titleAr: 'ملصق موقع',
      ),
    ],
    'pos-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: '58mm-receipt',
        title: '58mm Receipt',
        titleAr: 'إيصال 58 مم',
      ),
      PackageModuleExample(
        id: '80mm-receipt',
        title: '80mm Receipt',
        titleAr: 'إيصال 80 مم',
      ),
      PackageModuleExample(
        id: 'refund-receipt',
        title: 'Refund Receipt',
        titleAr: 'إيصال استرجاع',
      ),
      PackageModuleExample(
        id: 'exchange-receipt',
        title: 'Exchange Receipt',
        titleAr: 'إيصال استبدال',
      ),
      PackageModuleExample(
        id: 'gift-receipt',
        title: 'Gift Receipt',
        titleAr: 'إيصال هدية',
      ),
      PackageModuleExample(
        id: 'kitchen-order-ticket',
        title: 'Kitchen Order Ticket',
        titleAr: 'تذكرة طلب مطبخ',
      ),
      PackageModuleExample(
        id: 'shift-open',
        title: 'Shift Open',
        titleAr: 'فتح وردية',
      ),
      PackageModuleExample(
        id: 'shift-close',
        title: 'Shift Close',
        titleAr: 'إغلاق وردية',
      ),
      PackageModuleExample(
        id: 'x-report',
        title: 'X Report',
        titleAr: 'تقرير X',
      ),
      PackageModuleExample(
        id: 'z-report',
        title: 'Z Report',
        titleAr: 'تقرير Z',
      ),
      PackageModuleExample(
        id: 'cash-drawer',
        title: 'Cash Drawer',
        titleAr: 'درج النقدية',
      ),
      PackageModuleExample(
        id: 'payment-method-summary',
        title: 'Payment Method Summary',
        titleAr: 'ملخص طرق الدفع',
      ),
      PackageModuleExample(
        id: 'barcode-label',
        title: 'Barcode Label',
        titleAr: 'ملصق باركود',
      ),
      PackageModuleExample(
        id: 'price-label',
        title: 'Price Label',
        titleAr: 'ملصق سعر',
      ),
      PackageModuleExample(
        id: 'promotion-label',
        title: 'Promotion Label',
        titleAr: 'ملصق عرض ترويجي',
      ),
    ],
    'hr-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'employee-profile',
        title: 'Employee Profile',
        titleAr: 'ملف موظف',
      ),
      PackageModuleExample(
        id: 'employee-list',
        title: 'Employee List',
        titleAr: 'قائمة الموظفين',
      ),
      PackageModuleExample(
        id: 'employment-contract-form',
        title: 'Employment Contract/Form',
        titleAr: 'عقد / نموذج توظيف',
      ),
      PackageModuleExample(
        id: 'employee-action-form',
        title: 'Employee Action Form',
        titleAr: 'نموذج إجراء موظف',
      ),
      PackageModuleExample(
        id: 'attendance-report',
        title: 'Attendance Report',
        titleAr: 'تقرير الحضور',
      ),
      PackageModuleExample(
        id: 'timesheet',
        title: 'Timesheet',
        titleAr: 'كشف ساعات العمل',
      ),
      PackageModuleExample(
        id: 'overtime-report',
        title: 'Overtime Report',
        titleAr: 'تقرير العمل الإضافي',
      ),
      PackageModuleExample(
        id: 'leave-balance',
        title: 'Leave Balance',
        titleAr: 'رصيد الإجازات',
      ),
      PackageModuleExample(
        id: 'leave-request',
        title: 'Leave Request',
        titleAr: 'طلب إجازة',
      ),
      PackageModuleExample(
        id: 'payslip',
        title: 'Payslip',
        titleAr: 'قسيمة راتب',
      ),
      PackageModuleExample(
        id: 'payroll-sheet',
        title: 'Payroll Sheet',
        titleAr: 'كشف الرواتب',
      ),
      PackageModuleExample(
        id: 'payroll-summary',
        title: 'Payroll Summary',
        titleAr: 'ملخص الرواتب',
      ),
      PackageModuleExample(
        id: 'allowances-report',
        title: 'Allowances Report',
        titleAr: 'تقرير البدلات',
      ),
      PackageModuleExample(
        id: 'deductions-report',
        title: 'Deductions Report',
        titleAr: 'تقرير الاستقطاعات',
      ),
      PackageModuleExample(
        id: 'loan-advance',
        title: 'Loan / Advance',
        titleAr: 'قرض / سلفة',
      ),
      PackageModuleExample(
        id: 'salary-certificate',
        title: 'Salary Certificate',
        titleAr: 'شهادة راتب',
      ),
      PackageModuleExample(
        id: 'employment-certificate',
        title: 'Employment Certificate',
        titleAr: 'شهادة عمل',
      ),
      PackageModuleExample(
        id: 'experience-certificate',
        title: 'Experience Certificate',
        titleAr: 'شهادة خبرة',
      ),
      PackageModuleExample(
        id: 'end-of-service',
        title: 'End-of-Service',
        titleAr: 'نهاية الخدمة',
      ),
      PackageModuleExample(
        id: 'final-settlement',
        title: 'Final Settlement',
        titleAr: 'التسوية النهائية',
      ),
    ],
    'manufacturing-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'bill-of-materials',
        title: 'Bill of Materials',
        titleAr: 'قائمة المواد',
      ),
      PackageModuleExample(
        id: 'production-order',
        title: 'Production Order',
        titleAr: 'أمر إنتاج',
      ),
      PackageModuleExample(
        id: 'work-order',
        title: 'Work Order',
        titleAr: 'أمر عمل',
      ),
      PackageModuleExample(
        id: 'job-card',
        title: 'Job Card',
        titleAr: 'بطاقة عمل',
      ),
      PackageModuleExample(
        id: 'material-requirement',
        title: 'Material Requirement',
        titleAr: 'احتياج مواد',
      ),
      PackageModuleExample(
        id: 'material-issue',
        title: 'Material Issue',
        titleAr: 'صرف مواد',
      ),
      PackageModuleExample(
        id: 'material-return',
        title: 'Material Return',
        titleAr: 'مرتجع مواد',
      ),
      PackageModuleExample(
        id: 'production-receipt',
        title: 'Production Receipt',
        titleAr: 'استلام إنتاج',
      ),
      PackageModuleExample(
        id: 'routing-traveler',
        title: 'Routing / Traveler',
        titleAr: 'مسار / بطاقة مرور الإنتاج',
      ),
      PackageModuleExample(
        id: 'machine-operation',
        title: 'Machine Operation',
        titleAr: 'تشغيل آلة',
      ),
      PackageModuleExample(
        id: 'labor-report',
        title: 'Labor Report',
        titleAr: 'تقرير العمالة',
      ),
      PackageModuleExample(
        id: 'scrap-report',
        title: 'Scrap Report',
        titleAr: 'تقرير الهالك',
      ),
      PackageModuleExample(
        id: 'work-in-progress',
        title: 'Work in Progress',
        titleAr: 'إنتاج تحت التشغيل',
      ),
      PackageModuleExample(
        id: 'production-variance',
        title: 'Production Variance',
        titleAr: 'انحراف الإنتاج',
      ),
      PackageModuleExample(
        id: 'quality-inspection',
        title: 'Quality Inspection',
        titleAr: 'فحص الجودة',
      ),
      PackageModuleExample(
        id: 'incoming-inspection',
        title: 'Incoming Inspection',
        titleAr: 'فحص وارد',
      ),
      PackageModuleExample(
        id: 'in-process-inspection',
        title: 'In-process Inspection',
        titleAr: 'فحص أثناء التشغيل',
      ),
      PackageModuleExample(
        id: 'final-inspection',
        title: 'Final Inspection',
        titleAr: 'فحص نهائي',
      ),
      PackageModuleExample(
        id: 'ncr',
        title: 'NCR',
        titleAr: 'تقرير عدم مطابقة',
      ),
      PackageModuleExample(
        id: 'capa',
        title: 'CAPA',
        titleAr: 'إجراءات تصحيحية ووقائية',
      ),
      PackageModuleExample(
        id: 'certificate-of-analysis',
        title: 'Certificate of Analysis',
        titleAr: 'شهادة تحليل',
      ),
      PackageModuleExample(
        id: 'quality-checklist',
        title: 'Quality Checklist',
        titleAr: 'قائمة تحقق الجودة',
      ),
      PackageModuleExample(
        id: 'audit-form',
        title: 'Audit Form',
        titleAr: 'نموذج تدقيق',
      ),
      PackageModuleExample(
        id: 'calibration-record',
        title: 'Calibration Record',
        titleAr: 'سجل معايرة',
      ),
      PackageModuleExample(
        id: 'nested-operation-material-tables',
        title: 'Nested Operation / Material Tables',
        titleAr: 'جداول عمليات / مواد متداخلة',
      ),
    ],
    'assets-projects-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'asset-card',
        title: 'Asset Card',
        titleAr: 'بطاقة أصل',
      ),
      PackageModuleExample(
        id: 'asset-register',
        title: 'Asset Register',
        titleAr: 'سجل الأصول',
      ),
      PackageModuleExample(
        id: 'asset-label',
        title: 'Asset Label',
        titleAr: 'ملصق أصل',
      ),
      PackageModuleExample(
        id: 'asset-transfer',
        title: 'Asset Transfer',
        titleAr: 'تحويل أصل',
      ),
      PackageModuleExample(
        id: 'asset-assignment',
        title: 'Asset Assignment',
        titleAr: 'تخصيص أصل',
      ),
      PackageModuleExample(
        id: 'asset-return',
        title: 'Asset Return',
        titleAr: 'إرجاع أصل',
      ),
      PackageModuleExample(
        id: 'asset-disposal',
        title: 'Asset Disposal',
        titleAr: 'استبعاد أصل',
      ),
      PackageModuleExample(
        id: 'depreciation-report',
        title: 'Depreciation Report',
        titleAr: 'تقرير الإهلاك',
      ),
      PackageModuleExample(
        id: 'asset-maintenance',
        title: 'Asset Maintenance',
        titleAr: 'صيانة أصل',
      ),
      PackageModuleExample(
        id: 'asset-count',
        title: 'Asset Count',
        titleAr: 'جرد الأصول',
      ),
      PackageModuleExample(
        id: 'asset-movement',
        title: 'Asset Movement',
        titleAr: 'حركة الأصول',
      ),
      PackageModuleExample(
        id: 'project-summary',
        title: 'Project Summary',
        titleAr: 'ملخص المشروع',
      ),
      PackageModuleExample(
        id: 'project-budget',
        title: 'Project Budget',
        titleAr: 'موازنة المشروع',
      ),
      PackageModuleExample(
        id: 'project-cost',
        title: 'Project Cost',
        titleAr: 'تكلفة المشروع',
      ),
      PackageModuleExample(
        id: 'project-profitability',
        title: 'Project Profitability',
        titleAr: 'ربحية المشروع',
      ),
      PackageModuleExample(
        id: 'project-timesheet',
        title: 'Project Timesheet',
        titleAr: 'ساعات عمل المشروع',
      ),
      PackageModuleExample(
        id: 'project-expense',
        title: 'Project Expense',
        titleAr: 'مصروفات المشروع',
      ),
      PackageModuleExample(
        id: 'milestone-report',
        title: 'Milestone Report',
        titleAr: 'تقرير المراحل الرئيسية',
      ),
      PackageModuleExample(
        id: 'progress-report',
        title: 'Progress Report',
        titleAr: 'تقرير التقدم',
      ),
      PackageModuleExample(
        id: 'completion-certificate',
        title: 'Completion Certificate',
        titleAr: 'شهادة إنجاز',
      ),
      PackageModuleExample(
        id: 'project-billing',
        title: 'Project Billing',
        titleAr: 'فوترة المشروع',
      ),
      PackageModuleExample(
        id: 'resource-utilization',
        title: 'Resource Utilization',
        titleAr: 'استخدام الموارد',
      ),
      PackageModuleExample(
        id: 'project-purchasing',
        title: 'Project Purchasing',
        titleAr: 'مشتريات المشروع',
      ),
      PackageModuleExample(
        id: 'multi-period-financials',
        title: 'Multi-period Financials',
        titleAr: 'بيانات مالية متعددة الفترات',
      ),
    ],
    'service-logistics-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'service-order',
        title: 'Service Order',
        titleAr: 'أمر خدمة',
      ),
      PackageModuleExample(
        id: 'maintenance-work-order',
        title: 'Maintenance Work Order',
        titleAr: 'أمر عمل صيانة',
      ),
      PackageModuleExample(
        id: 'preventive-schedule',
        title: 'Preventive Schedule',
        titleAr: 'جدول صيانة وقائية',
      ),
      PackageModuleExample(
        id: 'maintenance-checklist',
        title: 'Maintenance Checklist',
        titleAr: 'قائمة تحقق الصيانة',
      ),
      PackageModuleExample(
        id: 'technician-report',
        title: 'Technician Report',
        titleAr: 'تقرير فني',
      ),
      PackageModuleExample(
        id: 'service-completion',
        title: 'Service Completion',
        titleAr: 'إتمام الخدمة',
      ),
      PackageModuleExample(
        id: 'spare-parts-usage',
        title: 'Spare Parts Usage',
        titleAr: 'استخدام قطع الغيار',
      ),
      PackageModuleExample(
        id: 'warranty-report',
        title: 'Warranty Report',
        titleAr: 'تقرير الضمان',
      ),
      PackageModuleExample(
        id: 'inspection-report',
        title: 'Inspection Report',
        titleAr: 'تقرير فحص',
      ),
      PackageModuleExample(
        id: 'calibration-service-history',
        title: 'Calibration / Service History',
        titleAr: 'سجل المعايرة / الخدمة',
      ),
      PackageModuleExample(
        id: 'shipment-document',
        title: 'Shipment Document',
        titleAr: 'مستند شحنة',
      ),
      PackageModuleExample(
        id: 'packing-list',
        title: 'Packing List',
        titleAr: 'قائمة تعبئة',
      ),
      PackageModuleExample(
        id: 'dispatch-note',
        title: 'Dispatch Note',
        titleAr: 'إشعار إرسال',
      ),
      PackageModuleExample(
        id: 'waybill',
        title: 'Waybill',
        titleAr: 'بوليصة شحن',
      ),
      PackageModuleExample(
        id: 'manifest',
        title: 'Manifest',
        titleAr: 'بيان شحنة',
      ),
      PackageModuleExample(
        id: 'trip-sheet',
        title: 'Trip Sheet',
        titleAr: 'ورقة رحلة',
      ),
      PackageModuleExample(
        id: 'trip-report',
        title: 'Trip Report',
        titleAr: 'تقرير رحلة',
      ),
      PackageModuleExample(
        id: 'shipping-label',
        title: 'Shipping Label',
        titleAr: 'ملصق شحن',
      ),
      PackageModuleExample(
        id: 'pallet-label',
        title: 'Pallet Label',
        titleAr: 'ملصق منصة',
      ),
      PackageModuleExample(
        id: 'container-list',
        title: 'Container List',
        titleAr: 'قائمة حاويات',
      ),
      PackageModuleExample(
        id: 'freight-summary',
        title: 'Freight Summary',
        titleAr: 'ملخص الشحن',
      ),
      PackageModuleExample(
        id: 'proof-of-delivery',
        title: 'Proof of Delivery',
        titleAr: 'إثبات تسليم',
      ),
      PackageModuleExample(
        id: 'label-thermal-profile-matrix',
        title: 'Label / Thermal Profile Matrix',
        titleAr: 'مصفوفة ملفات الملصقات / الطباعة الحرارية',
      ),
    ],
    'crm-pack' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'customer-profile',
        title: 'Customer Profile',
        titleAr: 'ملف عميل',
      ),
      PackageModuleExample(
        id: 'lead-report',
        title: 'Lead Report',
        titleAr: 'تقرير عميل محتمل',
      ),
      PackageModuleExample(
        id: 'opportunity-report',
        title: 'Opportunity Report',
        titleAr: 'تقرير فرصة',
      ),
      PackageModuleExample(
        id: 'pipeline-report',
        title: 'Pipeline Report',
        titleAr: 'تقرير مسار المبيعات',
      ),
      PackageModuleExample(
        id: 'activity-report',
        title: 'Activity Report',
        titleAr: 'تقرير نشاط',
      ),
      PackageModuleExample(
        id: 'visit-report',
        title: 'Visit Report',
        titleAr: 'تقرير زيارة',
      ),
      PackageModuleExample(
        id: 'call-report',
        title: 'Call Report',
        titleAr: 'تقرير اتصال',
      ),
      PackageModuleExample(
        id: 'customer-history',
        title: 'Customer History',
        titleAr: 'سجل العميل',
      ),
      PackageModuleExample(
        id: 'proposal',
        title: 'Proposal',
        titleAr: 'مقترح',
      ),
      PackageModuleExample(
        id: 'contract-summary',
        title: 'Contract Summary',
        titleAr: 'ملخص عقد',
      ),
      PackageModuleExample(
        id: 'presentation-primitives',
        title: 'Presentation Primitives',
        titleAr: 'مكونات العرض الأساسية',
      ),
    ],
    'template-engine-vnext' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'versioned-schema-elements',
        title: 'Versioned Schema + Elements',
        titleAr: 'مخطط بإصدارات + عناصر',
      ),
      PackageModuleExample(
        id: 'legacy-v1-v2-migration',
        title: 'Legacy v1 → v2 Migration',
        titleAr: 'ترحيل الإصدار القديم v1 → v2',
      ),
      PackageModuleExample(
        id: 'safe-expressions-aggregates',
        title: 'Safe Expressions + Aggregates',
        titleAr: 'تعبيرات آمنة + تجميعات',
      ),
      PackageModuleExample(
        id: 'bounded-large-loop',
        title: 'Bounded Large Loop',
        titleAr: 'حلقة كبيرة محدودة',
      ),
      PackageModuleExample(
        id: 'components-styles-subtemplate',
        title: 'Components / Styles / SubTemplate',
        titleAr: 'مكونات / أنماط / قالب فرعي',
      ),
      PackageModuleExample(
        id: 'registry-fallback-history',
        title: 'Registry Fallback / History',
        titleAr: 'بدائل السجل / السجل التاريخي',
      ),
      PackageModuleExample(
        id: 'direction-value-direction',
        title: 'Direction / Value Direction',
        titleAr: 'الاتجاه / اتجاه القيمة',
      ),
      PackageModuleExample(
        id: 'invalid-expression-rejection',
        title: 'Invalid Expression Rejection',
        titleAr: 'رفض التعبير غير الصالح',
      ),
    ],
    'compliance' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'original',
        title: 'Original',
        titleAr: 'أصل',
      ),
      PackageModuleExample(
        id: 'copy',
        title: 'Copy',
        titleAr: 'نسخة',
      ),
      PackageModuleExample(
        id: 'reprint',
        title: 'Reprint',
        titleAr: 'إعادة طباعة',
      ),
      PackageModuleExample(
        id: 'required-field-failure',
        title: 'Required-field Failure',
        titleAr: 'فشل حقل إلزامي',
      ),
      PackageModuleExample(
        id: 'country-tenant-registry',
        title: 'Country / Tenant Registry',
        titleAr: 'سجل الدولة / المستأجر',
      ),
      PackageModuleExample(
        id: 'existing-security-adapter',
        title: 'Existing Security Adapter',
        titleAr: 'موائم الأمان الحالي',
      ),
      PackageModuleExample(
        id: 'archive-audit-metadata',
        title: 'Archive / Audit Metadata',
        titleAr: 'بيانات الأرشفة / التدقيق',
      ),
    ],
    'quality' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'family-benchmark',
        title: 'Family Benchmark',
        titleAr: 'اختبار أداء العائلات',
      ),
      PackageModuleExample(
        id: 'resource-measurement-cache',
        title: 'Resource / Measurement Cache',
        titleAr: 'ذاكرة موارد / قياسات',
      ),
      PackageModuleExample(
        id: 'semantic-regression',
        title: 'Semantic Regression',
        titleAr: 'اختبار الانحدار الدلالي',
      ),
      PackageModuleExample(
        id: 'golden-coverage-manifest',
        title: 'Golden Coverage Manifest',
        titleAr: 'بيان تغطية الاختبارات الذهبية',
      ),
    ],
    'template-designer' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'designer-metadata',
        title: 'Designer Metadata',
        titleAr: 'بيانات المصمم',
      ),
      PackageModuleExample(
        id: 'drag-drop-sections',
        title: 'Drag / Drop + Sections',
        titleAr: 'سحب / إفلات + أقسام',
      ),
      PackageModuleExample(
        id: 'conditions-expressions',
        title: 'Conditions / Expressions',
        titleAr: 'شروط / تعبيرات',
      ),
      PackageModuleExample(
        id: 'components-styles',
        title: 'Components / Styles',
        titleAr: 'مكونات / أنماط',
      ),
      PackageModuleExample(
        id: 'validation-messages',
        title: 'Validation Messages',
        titleAr: 'رسائل التحقق',
      ),
      PackageModuleExample(
        id: 'multi-page-sample-preview',
        title: 'Multi-page Sample Preview',
        titleAr: 'معاينة مثال متعدد الصفحات',
      ),
    ],
    'industry-packs' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'retail',
        title: 'Retail',
        titleAr: 'تجزئة',
      ),
      PackageModuleExample(
        id: 'restaurant',
        title: 'Restaurant',
        titleAr: 'مطاعم',
      ),
      PackageModuleExample(
        id: 'construction-real-estate',
        title: 'Construction / Real Estate',
        titleAr: 'إنشاءات / عقارات',
      ),
      PackageModuleExample(
        id: 'healthcare-education-shells',
        title: 'Healthcare / Education Shells',
        titleAr: 'قوالب صحة / تعليم',
      ),
      PackageModuleExample(
        id: 'automotive-distribution-hospitality',
        title: 'Automotive / Distribution / Hospitality',
        titleAr: 'سيارات / توزيع / ضيافة',
      ),
    ],
    'ai' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'smart-text-assistance',
        title: 'Smart text assistance',
        titleAr: 'مساعدة نصية ذكية',
      ),
      PackageModuleExample(
        id: 'summarization-workflow',
        title: 'Summarization workflow',
        titleAr: 'سير عمل التلخيص',
      ),
      PackageModuleExample(
        id: 'translation-workflow',
        title: 'Translation workflow',
        titleAr: 'سير عمل الترجمة',
      ),
    ],
    'printing-module' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'a4-portrait',
        title: 'A4 portrait',
        titleAr: 'A4 عمودي',
      ),
      PackageModuleExample(
        id: 'a4-landscape',
        title: 'A4 landscape',
        titleAr: 'A4 أفقي',
      ),
      PackageModuleExample(
        id: 'a5',
        title: 'A5',
        titleAr: 'A5',
      ),
      PackageModuleExample(
        id: 'letter',
        title: 'Letter',
        titleAr: 'Letter',
      ),
      PackageModuleExample(
        id: 'legal',
        title: 'Legal',
        titleAr: 'Legal',
      ),
      PackageModuleExample(
        id: '58mm-thermal',
        title: '58mm thermal',
        titleAr: 'حراري 58 مم',
      ),
      PackageModuleExample(
        id: '80mm-thermal',
        title: '80mm thermal',
        titleAr: 'حراري 80 مم',
      ),
      PackageModuleExample(
        id: 'continuous-paper',
        title: 'Continuous paper',
        titleAr: 'ورق متصل',
      ),
      PackageModuleExample(
        id: 'single-label',
        title: 'Single label',
        titleAr: 'ملصق مفرد',
      ),
      PackageModuleExample(
        id: 'label-sheet',
        title: 'Label sheet',
        titleAr: 'ورقة ملصقات',
      ),
      PackageModuleExample(
        id: 'pre-printed-physical-anchors',
        title: 'Pre-printed physical anchors',
        titleAr: 'مواضع ثابتة على نموذج مطبوع مسبقًا',
      ),
      PackageModuleExample(
        id: 'calibration-page',
        title: 'Calibration page',
        titleAr: 'صفحة معايرة',
      ),
    ],
    'sharing-module' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'share-generated-pdf',
        title: 'Share generated PDF',
        titleAr: 'مشاركة PDF مولد',
      ),
      PackageModuleExample(
        id: 'share-with-options',
        title: 'Share with options',
        titleAr: 'مشاركة مع خيارات',
      ),
      PackageModuleExample(
        id: 'application-share-service',
        title: 'Application share service',
        titleAr: 'خدمة مشاركة التطبيق',
      ),
    ],
    'security' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'security-service',
        title: 'Security service',
        titleAr: 'خدمة الأمان',
      ),
      PackageModuleExample(
        id: 'document-protection',
        title: 'Document protection',
        titleAr: 'حماية المستند',
      ),
      PackageModuleExample(
        id: 'security-policy-adapter',
        title: 'Security policy adapter',
        titleAr: 'موائم سياسة الأمان',
      ),
    ],
    'export' => const <PackageModuleExample>[
      PackageModuleExample(
        id: 'pdf-to-text',
        title: 'PDF to text',
        titleAr: 'PDF إلى نص',
      ),
      PackageModuleExample(
        id: 'pdf-to-image',
        title: 'PDF to image',
        titleAr: 'PDF إلى صورة',
      ),
      PackageModuleExample(
        id: 'pdf-to-html',
        title: 'PDF to HTML',
        titleAr: 'PDF إلى HTML',
      ),
      PackageModuleExample(
        id: 'batch-export',
        title: 'Batch export',
        titleAr: 'تصدير دفعي',
      ),
    ],
    _ => const <PackageModuleExample>[],
  };
}
