import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Sample data for demonstrating PDF templates.
class SampleData {
  SampleData._();

  // ============================================================
  // COMPANY INFO
  // ============================================================

  static const companyInfo = GeniusPdfCompanyInfo(
    name: 'Integrated Solutions Co.',
    nameAr: 'شركة الحلول المتكاملة',
    address: 'Riyadh, Kingdom of Saudi Arabia',
    addressAr: 'الرياض، المملكة العربية السعودية',
    vatNumber: '300012345678903',
    phone: '+966 11 234 5678',
    email: 'info@integrated-solutions.com',
  );

  // ============================================================
  // TAX INVOICE DATA
  // ============================================================

  static const invoiceCustomer = InvoiceCustomer(
    name: 'Modern Retailers Co.',
    nameAr: 'شركة التجزئة الحديثة',
    address: 'Jeddah, King Fahd Road',
    addressAr: 'جدة، طريق الملك فهد',
    vatNumber: '311122233344455',
    phone: '+966 12 345 6789',
  );

  static final invoiceData = InvoiceData(
    invoiceNumber: 'SINV-2025-1001',
    invoiceDate: DateTime(2025, 1, 19),
    poNumber: 'PO-250',
    paymentTerms: 'Cash on Delivery',
    paymentTermsAr: 'نقداً عند الاستلام',
    items: [
      const InvoiceLineItem(
        itemNumber: 1,
        description: 'Smartphone Model Z (ITM-101)',
        descriptionAr: 'هاتف ذكي موديل Z',
        quantity: 5,
        unitPrice: 3200,
      ),
      const InvoiceLineItem(
        itemNumber: 2,
        description: 'Laptop Pro X1 (ITM-001)',
        descriptionAr: 'لابتوب برو X1',
        quantity: 2,
        unitPrice: 4500,
      ),
      const InvoiceLineItem(
        itemNumber: 3,
        description: '4K Monitor (ITM-105)',
        descriptionAr: 'شاشة 4K',
        quantity: 3,
        unitPrice: 1200,
      ),
      const InvoiceLineItem(
        itemNumber: 4,
        description: 'Wireless Keyboard (ITM-200)',
        descriptionAr: 'لوحة مفاتيح لاسلكية',
        quantity: 10,
        unitPrice: 150,
      ),
    ],
    taxes: [
      const InvoiceTax(
        name: 'VAT',
        nameAr: 'ضريبة القيمة المضافة',
        rate: 15,
      ),
    ],
    currency: 'SAR',
  );

  // ============================================================
  // TRIAL BALANCE DATA
  // ============================================================

  static final trialBalanceData = TrialBalanceData(
    asOfDate: DateTime(2025, 12, 31),
    categories: [
      const TrialBalanceCategory(
        name: 'Assets',
        nameAr: 'الأصول',
        entries: [
          TrialBalanceEntry(
            accountName: 'Cash & Cash Equivalents',
            accountNameAr: 'النقد وما في حكمه',
            debit: 2500000,
          ),
          TrialBalanceEntry(
            accountName: 'Accounts Receivable',
            accountNameAr: 'الذمم المدينة',
            debit: 1800000,
          ),
          TrialBalanceEntry(
            accountName: 'Inventory',
            accountNameAr: 'المخزون',
            debit: 3200000,
          ),
          TrialBalanceEntry(
            accountName: 'Property, Plant & Equipment',
            accountNameAr: 'الممتلكات والمعدات',
            debit: 5000000,
          ),
          TrialBalanceEntry(
            accountName: 'Accumulated Depreciation',
            accountNameAr: 'مجمع الإهلاك',
            credit: 1500000,
          ),
        ],
      ),
      const TrialBalanceCategory(
        name: 'Liabilities',
        nameAr: 'الخصوم',
        entries: [
          TrialBalanceEntry(
            accountName: 'Accounts Payable',
            accountNameAr: 'الذمم الدائنة',
            credit: 1200000,
          ),
          TrialBalanceEntry(
            accountName: 'Short-term Loans',
            accountNameAr: 'قروض قصيرة الأجل',
            credit: 500000,
          ),
          TrialBalanceEntry(
            accountName: 'Long-term Loans',
            accountNameAr: 'قروض طويلة الأجل',
            credit: 3000000,
          ),
        ],
      ),
      const TrialBalanceCategory(
        name: 'Equity',
        nameAr: 'حقوق الملكية',
        entries: [
          TrialBalanceEntry(
            accountName: 'Capital',
            accountNameAr: 'رأس المال',
            credit: 5000000,
          ),
          TrialBalanceEntry(
            accountName: 'Retained Earnings',
            accountNameAr: 'الأرباح المبقاة',
            credit: 1300000,
          ),
        ],
      ),
      const TrialBalanceCategory(
        name: 'Income',
        nameAr: 'الإيرادات',
        entries: [
          TrialBalanceEntry(
            accountName: 'Sales Revenue',
            accountNameAr: 'إيرادات المبيعات',
            credit: 8500000,
          ),
          TrialBalanceEntry(
            accountName: 'Other Income',
            accountNameAr: 'إيرادات أخرى',
            credit: 200000,
          ),
        ],
      ),
      const TrialBalanceCategory(
        name: 'Expenses',
        nameAr: 'المصروفات',
        entries: [
          TrialBalanceEntry(
            accountName: 'Cost of Goods Sold',
            accountNameAr: 'تكلفة البضاعة المباعة',
            debit: 4500000,
          ),
          TrialBalanceEntry(
            accountName: 'Salaries Expense',
            accountNameAr: 'مصروفات الرواتب',
            debit: 2000000,
          ),
          TrialBalanceEntry(
            accountName: 'Rent Expense',
            accountNameAr: 'مصروفات الإيجار',
            debit: 1200000,
          ),
          TrialBalanceEntry(
            accountName: 'Depreciation Expense',
            accountNameAr: 'مصروفات الاستهلاك',
            debit: 500000,
          ),
          TrialBalanceEntry(
            accountName: 'G&A Expenses',
            accountNameAr: 'مصروفات عمومية وإدارية',
            debit: 800000,
          ),
        ],
      ),
    ],
    currency: 'SAR',
  );

  // ============================================================
  // CUSTOMER STATEMENT DATA
  // ============================================================

  static const statementCustomer = StatementCustomer(
    name: 'Modern Retailers Co.',
    nameAr: 'شركة التجزئة الحديثة',
    address: 'Jeddah, King Fahd Road',
    addressAr: 'جدة، طريق الملك فهد',
    accountNumber: 'CUST-1001',
    phone: '+966 12 345 6789',
  );

  static final statementData = CustomerStatementData(
    periodFrom: DateTime(2025, 1, 1),
    periodTo: DateTime(2025, 12, 31),
    openingBalance: 0,
    closingBalance: 20000,
    transactions: [
      StatementTransaction(
        date: DateTime(2025, 1, 15),
        description: 'Sales Invoice',
        descriptionAr: 'فاتورة مبيعات',
        referenceNo: 'SINV-1001',
        debit: 16000,
        balance: 16000,
      ),
      StatementTransaction(
        date: DateTime(2025, 1, 20),
        description: 'Payment Received',
        descriptionAr: 'استلام دفعة',
        referenceNo: 'RV-1001',
        credit: 10000,
        balance: 6000,
      ),
      StatementTransaction(
        date: DateTime(2025, 2, 10),
        description: 'Sales Invoice',
        descriptionAr: 'فاتورة مبيعات',
        referenceNo: 'SINV-1005',
        debit: 25500,
        balance: 31500,
      ),
      StatementTransaction(
        date: DateTime(2025, 2, 25),
        description: 'Payment Received',
        descriptionAr: 'استلام دفعة',
        referenceNo: 'RV-1002',
        credit: 31500,
        balance: 0,
      ),
      StatementTransaction(
        date: DateTime(2025, 3, 5),
        description: 'Sales Invoice',
        descriptionAr: 'فاتورة مبيعات',
        referenceNo: 'SINV-1010',
        debit: 12000,
        balance: 12000,
      ),
      StatementTransaction(
        date: DateTime(2025, 3, 15),
        description: 'Sales Invoice',
        descriptionAr: 'فاتورة مبيعات',
        referenceNo: 'SINV-1015',
        debit: 8000,
        balance: 20000,
      ),
    ],
    aging: const AgingAnalysis(
      days1to30: 5000,
      days31to60: 10000,
      days61to90: 5000,
      over90: 0,
    ),
    currency: 'SAR',
  );

  // ============================================================
  // INVENTORY DATA
  // ============================================================

  static final inventoryData = InventoryReportData(
    asOfDate: DateTime(2025, 1, 19),
    categories: [
      const InventoryCategory(
        name: 'Electronics',
        nameAr: 'الإلكترونيات',
        items: [
          InventoryItem(
            itemCode: 'ITM-101',
            itemName: 'Smartphone Model Z',
            itemNameAr: 'هاتف ذكي موديل Z',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 150,
            averageCost: 2500,
          ),
          InventoryItem(
            itemCode: 'ITM-001',
            itemName: 'Laptop Pro X1',
            itemNameAr: 'لابتوب برو X1',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 75,
            averageCost: 3800,
          ),
          InventoryItem(
            itemCode: 'ITM-105',
            itemName: '4K Monitor',
            itemNameAr: 'شاشة 4K',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 100,
            averageCost: 900,
          ),
          InventoryItem(
            itemCode: 'ITM-200',
            itemName: 'Wireless Keyboard',
            itemNameAr: 'لوحة مفاتيح لاسلكية',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 250,
            averageCost: 120,
          ),
          InventoryItem(
            itemCode: 'ITM-205',
            itemName: 'Gaming Mouse',
            itemNameAr: 'ماوس ألعاب',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 300,
            averageCost: 80,
          ),
          InventoryItem(
            itemCode: 'ITM-210',
            itemName: 'External SSD 1TB',
            itemNameAr: 'قرص SSD خارجي 1 تيرا',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 120,
            averageCost: 450,
          ),
          InventoryItem(
            itemCode: 'ITM-211',
            itemName: 'USB-C Hub 7-Port',
            itemNameAr: 'موزع USB-C 7 منافذ',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 200,
            averageCost: 85,
          ),
          InventoryItem(
            itemCode: 'ITM-212',
            itemName: 'Webcam HD 1080p',
            itemNameAr: 'كاميرا ويب HD 1080p',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 180,
            averageCost: 150,
          ),
          InventoryItem(
            itemCode: 'ITM-213',
            itemName: 'Wireless Earbuds Pro',
            itemNameAr: 'سماعات لاسلكية برو',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 400,
            averageCost: 220,
          ),
          InventoryItem(
            itemCode: 'ITM-214',
            itemName: 'Tablet Pro 12 inch',
            itemNameAr: 'تابلت برو 12 بوصة',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 90,
            averageCost: 1800,
          ),
        ],
      ),
      const InventoryCategory(
        name: 'Office Furniture',
        nameAr: 'الأثاث المكتبي',
        items: [
          InventoryItem(
            itemCode: 'ITM-003',
            itemName: 'Office Chair',
            itemNameAr: 'كرسي مكتب',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 200,
            averageCost: 600,
          ),
          InventoryItem(
            itemCode: 'ITM-008',
            itemName: 'Desk Lamp',
            itemNameAr: 'مصباح مكتب',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 150,
            averageCost: 80,
          ),
          InventoryItem(
            itemCode: 'ITM-012',
            itemName: 'Whiteboard',
            itemNameAr: 'لوح أبيض',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 50,
            averageCost: 250,
          ),
          InventoryItem(
            itemCode: 'ITM-015',
            itemName: 'Ergonomic Desk',
            itemNameAr: 'مكتب مريح',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 80,
            averageCost: 1200,
          ),
          InventoryItem(
            itemCode: 'ITM-020',
            itemName: 'Conference Table 8-Seater',
            itemNameAr: 'طاولة اجتماعات 8 مقاعد',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 15,
            averageCost: 3500,
          ),
          InventoryItem(
            itemCode: 'ITM-021',
            itemName: 'Bookshelf Large',
            itemNameAr: 'رف كتب كبير',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 45,
            averageCost: 450,
          ),
          InventoryItem(
            itemCode: 'ITM-022',
            itemName: 'Visitor Chair',
            itemNameAr: 'كرسي زوار',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 180,
            averageCost: 280,
          ),
          InventoryItem(
            itemCode: 'ITM-023',
            itemName: 'Standing Desk',
            itemNameAr: 'مكتب وقوف',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 40,
            averageCost: 1800,
          ),
          InventoryItem(
            itemCode: 'ITM-024',
            itemName: 'Reception Counter',
            itemNameAr: 'كاونتر استقبال',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 12,
            averageCost: 2800,
          ),
          InventoryItem(
            itemCode: 'ITM-025',
            itemName: 'Office Sofa 3-Seater',
            itemNameAr: 'كنبة مكتب 3 مقاعد',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 25,
            averageCost: 1500,
          ),
          InventoryItem(
            itemCode: 'ITM-026',
            itemName: 'Mobile Pedestal',
            itemNameAr: 'وحدة أدراج متحركة',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 100,
            averageCost: 380,
          ),
        ],
      ),
      const InventoryCategory(
        name: 'Stationery',
        nameAr: 'القرطاسية',
        items: [
          InventoryItem(
            itemCode: 'ITM-301',
            itemName: 'A4 Paper Ream',
            itemNameAr: 'رزمة ورق A4',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 1000,
            averageCost: 15,
          ),
          InventoryItem(
            itemCode: 'ITM-305',
            itemName: 'Ballpoint Pens (Box of 12)',
            itemNameAr: 'أقلام حبر (علبة 12)',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 500,
            averageCost: 10,
          ),
          InventoryItem(
            itemCode: 'ITM-310',
            itemName: 'Notebook A5',
            itemNameAr: 'دفتر A5',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 800,
            averageCost: 8,
          ),
          InventoryItem(
            itemCode: 'ITM-311',
            itemName: 'Highlighters Set (6 Colors)',
            itemNameAr: 'مجموعة أقلام تحديد (6 ألوان)',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 600,
            averageCost: 18,
          ),
          InventoryItem(
            itemCode: 'ITM-315',
            itemName: 'Sticky Notes Pack (5 Colors)',
            itemNameAr: 'ملاحظات لاصقة (5 ألوان)',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 900,
            averageCost: 12,
          ),
          InventoryItem(
            itemCode: 'ITM-316',
            itemName: 'Calculator Desktop Solar',
            itemNameAr: 'آلة حاسبة مكتبية شمسية',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 200,
            averageCost: 45,
          ),
          InventoryItem(
            itemCode: 'ITM-317',
            itemName: 'Paper Clips Box (100 pcs)',
            itemNameAr: 'علبة مشابك ورق (100 قطعة)',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 1200,
            averageCost: 5,
          ),
          InventoryItem(
            itemCode: 'ITM-318',
            itemName: 'Hole Puncher 2-Hole',
            itemNameAr: 'خرامة ورق ثنائية',
            warehouse: 'Jeddah Branch',
            warehouseAr: 'فرع جدة',
            quantityOnHand: 180,
            averageCost: 32,
          ),
          InventoryItem(
            itemCode: 'ITM-319',
            itemName: 'Envelope A4 Brown (50 pcs)',
            itemNameAr: 'ظروف A4 بني (50 قطعة)',
            warehouse: 'Dammam Branch',
            warehouseAr: 'فرع الدمام',
            quantityOnHand: 500,
            averageCost: 25,
          ),
          InventoryItem(
            itemCode: 'ITM-320',
            itemName: 'Whiteboard Marker Set',
            itemNameAr: 'مجموعة أقلام سبورة',
            warehouse: 'Riyadh Main',
            warehouseAr: 'الرياض الرئيسي',
            quantityOnHand: 700,
            averageCost: 15,
          ),
        ],
      ),
    ],
    currency: 'SAR',
  );
}
