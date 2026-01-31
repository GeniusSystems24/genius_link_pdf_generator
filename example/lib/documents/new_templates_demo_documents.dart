import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../data/sample_data.dart';
import '../main.dart' show geniusPdfConfig;

class NewTemplatesDemoBuild {
  final GeniusPdfDocumentBuilder builder;
  final String fileName;

  const NewTemplatesDemoBuild({
    required this.builder,
    required this.fileName,
  });
}

GeniusPdfConfig createNewTemplatesDemoConfig({required bool isRtl}) {
  return GeniusPdfConfig(
    baseFont: PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 10),
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}

NewTemplatesDemoBuild buildBalanceSheetDemo({required bool isRtl}) {
  final data = BalanceSheetData(
    reportDate: DateTime.now(),
    assets: BalanceSheetSection(
      title: 'Assets',
      titleAr: 'الأصول',
      items: const [
        BalanceSheetItem(
          accountCode: '1100',
          accountName: 'Cash and Bank',
          accountNameAr: 'النقد والبنوك',
          amount: 150000,
        ),
        BalanceSheetItem(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'المدينون',
          amount: 85000,
        ),
        BalanceSheetItem(
          accountCode: '1300',
          accountName: 'Inventory',
          accountNameAr: 'المخزون',
          amount: 120000,
        ),
        BalanceSheetItem(
          accountCode: '1500',
          accountName: 'Fixed Assets',
          accountNameAr: 'الأصول الثابتة',
          amount: 200000,
        ),
      ],
    ),
    liabilities: BalanceSheetSection(
      title: 'Liabilities',
      titleAr: 'الالتزامات',
      items: const [
        BalanceSheetItem(
          accountCode: '2100',
          accountName: 'Accounts Payable',
          accountNameAr: 'الدائنون',
          amount: 65000,
        ),
        BalanceSheetItem(
          accountCode: '2200',
          accountName: 'Short-term Loans',
          accountNameAr: 'قروض قصيرة الأجل',
          amount: 100000,
        ),
      ],
    ),
    equity: BalanceSheetSection(
      title: 'Equity',
      titleAr: 'حقوق الملكية',
      items: const [
        BalanceSheetItem(
          accountCode: '3100',
          accountName: 'Share Capital',
          accountNameAr: 'رأس المال',
          amount: 300000,
        ),
        BalanceSheetItem(
          accountCode: '3200',
          accountName: 'Retained Earnings',
          accountNameAr: 'الأرباح المحتجزة',
          amount: 90000,
        ),
      ],
    ),
  );

  final template = BalanceSheetTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'balance_sheet_demo',
  );
}

NewTemplatesDemoBuild buildIncomeStatementDemo({required bool isRtl}) {
  final data = IncomeStatementData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    revenue: IncomeStatementSection(
      title: 'Revenue',
      titleAr: 'الإيرادات',
      items: const [
        IncomeStatementItem(
          accountCode: '4100',
          accountName: 'Sales Revenue',
          accountNameAr: 'إيرادات المبيعات',
          amount: 500000,
        ),
        IncomeStatementItem(
          accountCode: '4200',
          accountName: 'Service Revenue',
          accountNameAr: 'إيرادات الخدمات',
          amount: 150000,
        ),
      ],
    ),
    costOfSales: IncomeStatementSection(
      title: 'Cost of Sales',
      titleAr: 'تكلفة المبيعات',
      items: const [
        IncomeStatementItem(
          accountCode: '5100',
          accountName: 'Cost of Goods Sold',
          accountNameAr: 'تكلفة البضاعة المباعة',
          amount: 280000,
        ),
      ],
    ),
    operatingExpenses: IncomeStatementSection(
      title: 'Operating Expenses',
      titleAr: 'المصروفات التشغيلية',
      items: const [
        IncomeStatementItem(
          accountCode: '6100',
          accountName: 'Salaries & Wages',
          accountNameAr: 'الرواتب والأجور',
          amount: 120000,
        ),
        IncomeStatementItem(
          accountCode: '6200',
          accountName: 'Rent Expense',
          accountNameAr: 'مصروف الإيجار',
          amount: 25000,
        ),
      ],
    ),
    taxExpense: 25000,
  );

  final template = IncomeStatementTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'income_statement_demo',
  );
}

NewTemplatesDemoBuild buildCashFlowDemo({required bool isRtl}) {
  final data = CashFlowData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    operatingActivities: CashFlowSection(
      type: CashFlowActivityType.operating,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Cash received from customers',
          descriptionAr: 'النقد المستلم من العملاء',
          amount: 480000,
        ),
        CashFlowItem(
          description: 'Cash paid to suppliers',
          descriptionAr: 'النقد المدفوع للموردين',
          amount: -250000,
        ),
        CashFlowItem(
          description: 'Cash paid to employees',
          descriptionAr: 'النقد المدفوع للموظفين',
          amount: -120000,
        ),
      ],
    ),
    investingActivities: CashFlowSection(
      type: CashFlowActivityType.investing,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Purchase of equipment',
          descriptionAr: 'شراء معدات',
          amount: -50000,
        ),
      ],
    ),
    financingActivities: CashFlowSection(
      type: CashFlowActivityType.financing,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Bank loan received',
          descriptionAr: 'قرض بنكي مستلم',
          amount: 100000,
        ),
      ],
    ),
    beginningCashBalance: 100000,
  );

  final template = CashFlowTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'cash_flow_demo',
  );
}

NewTemplatesDemoBuild buildBudgetReportDemo({required bool isRtl}) {
  final data = BudgetReportData(
    reportTitle: 'Monthly Budget Report',
    reportTitleAr: 'تقرير الميزانية الشهرية',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    sections: [
      BudgetSection(
        title: 'Revenue',
        titleAr: 'الإيرادات',
        items: const [
          BudgetItem(
            category: 'Product Sales',
            categoryAr: 'مبيعات المنتجات',
            budgetedAmount: 400000,
            actualAmount: 420000,
          ),
          BudgetItem(
            category: 'Service Revenue',
            categoryAr: 'إيرادات الخدمات',
            budgetedAmount: 100000,
            actualAmount: 95000,
          ),
        ],
      ),
      BudgetSection(
        title: 'Expenses',
        titleAr: 'المصروفات',
        isExpense: true,
        items: const [
          BudgetItem(
            category: 'Salaries',
            categoryAr: 'الرواتب',
            budgetedAmount: 120000,
            actualAmount: 125000,
          ),
          BudgetItem(
            category: 'Marketing',
            categoryAr: 'التسويق',
            budgetedAmount: 50000,
            actualAmount: 42000,
          ),
        ],
      ),
    ],
  );

  final template = BudgetReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'budget_report_demo',
  );
}

NewTemplatesDemoBuild buildQuotationDemo({required bool isRtl}) {
  final customer = const QuotationCustomer(
    name: 'ABC Trading Company',
    nameAr: 'شركة ABC للتجارة',
    company: 'ABC Trading Co. Ltd',
    address: '456 Commercial Street, Jeddah',
    phone: '+966 12 345 6789',
    email: 'purchasing@abctrading.com',
  );

  final quotation = QuotationData(
    quotationNumber: 'QT-2026-0001',
    quotationDate: DateTime.now(),
    validUntil: DateTime.now().add(const Duration(days: 30)),
    paymentTerms: 'Net 30',
    paymentTermsAr: 'صافي 30 يوم',
    items: const [
      QuotationItem(
        itemNumber: 1,
        description: 'Office Desk - Executive Model',
        descriptionAr: 'مكتب تنفيذي',
        quantity: 5,
        unitPrice: 2500,
      ),
      QuotationItem(
        itemNumber: 2,
        description: 'Executive Chair',
        descriptionAr: 'كرسي تنفيذي',
        quantity: 5,
        unitPrice: 1800,
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = QuotationTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    customer: customer,
    quotation: quotation,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'quotation_demo',
  );
}

NewTemplatesDemoBuild buildPurchaseOrderDemo({required bool isRtl}) {
  final vendor = const PurchaseOrderVendor(
    name: 'Tech Supplies Co.',
    nameAr: 'شركة مستلزمات التقنية',
    vendorCode: 'VND-001',
    address: '789 Industrial Area, Dammam',
    vatNumber: '300098765400001',
  );

  final po = PurchaseOrderData(
    poNumber: 'PO-2026-0042',
    poDate: DateTime.now(),
    expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
    paymentTerms: 'Net 45',
    status: 'Approved',
    items: const [
      PurchaseOrderItem(
        itemNumber: 1,
        productCode: 'LAP-001',
        description: 'Laptop - Business Model',
        descriptionAr: 'لابتوب - موديل الأعمال',
        quantity: 10,
        unitPrice: 4500,
      ),
      PurchaseOrderItem(
        itemNumber: 2,
        productCode: 'MON-002',
        description: 'Monitor 27" 4K',
        descriptionAr: 'شاشة 27 بوصة 4K',
        quantity: 10,
        unitPrice: 1200,
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = PurchaseOrderTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    vendor: vendor,
    purchaseOrder: po,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'purchase_order_demo',
  );
}

NewTemplatesDemoBuild buildDeliveryNoteDemo({required bool isRtl}) {
  final recipient = const DeliveryRecipient(
    name: 'Ahmed Al-Farsi',
    nameAr: 'أحمد الفارسي',
    company: 'XYZ Corp',
    companyAr: 'شركة XYZ',
    address: '321 Business Park, Riyadh',
    phone: '+966 55 123 4567',
  );

  final delivery = DeliveryNoteData(
    deliveryNumber: 'DN-2026-0089',
    deliveryDate: DateTime.now(),
    salesOrderRef: 'SO-2026-0156',
    driverName: 'Khalid Mohammed',
    vehicleNumber: 'ABC 1234',
    items: const [
      DeliveryItem(
        itemNumber: 1,
        productCode: 'PROD-001',
        description: 'Widget A',
        descriptionAr: 'منتج أ',
        orderedQty: 100,
        deliveredQty: 100,
        unit: 'pcs',
      ),
      DeliveryItem(
        itemNumber: 2,
        productCode: 'PROD-002',
        description: 'Widget B',
        descriptionAr: 'منتج ب',
        orderedQty: 50,
        deliveredQty: 45,
        unit: 'pcs',
      ),
    ],
  );

  final template = DeliveryNoteTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    recipient: recipient,
    delivery: delivery,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'delivery_note_demo',
  );
}

NewTemplatesDemoBuild buildCreditNoteDemo({required bool isRtl}) {
  final party = const NoteParty(
    name: 'Customer ABC',
    nameAr: 'العميل ABC',
    address: '123 Customer Street, Riyadh',
    vatNumber: '300011112200001',
  );

  final note = CreditDebitNoteData(
    noteNumber: 'CN-2026-0015',
    noteDate: DateTime.now(),
    noteType: NoteType.credit,
    originalInvoiceNumber: 'INV-2026-0189',
    reason: 'Goods returned',
    reasonAr: 'إرجاع بضاعة',
    items: const [
      NoteLineItem(
        itemNumber: 1,
        description: 'Defective Product A',
        descriptionAr: 'منتج أ معيب',
        quantity: 5,
        unitPrice: 500,
        reason: 'Quality issue',
        reasonAr: 'مشكلة جودة',
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = CreditNoteTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    party: party,
    note: note,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'credit_note_demo',
  );
}

NewTemplatesDemoBuild buildPayslipDemo({required bool isRtl}) {
  final employee = PayslipEmployee(
    employeeId: 'EMP-001',
    name: 'Mohammed Al-Ahmed',
    nameAr: 'محمد الأحمد',
    department: 'Engineering',
    departmentAr: 'الهندسة',
    designation: 'Senior Developer',
    designationAr: 'مطور أول',
    joiningDate: DateTime(2022, 3, 15),
    bankName: 'Al Rajhi Bank',
    bankAccount: 'SA12345678901234567890',
  );

  final payslip = PayslipData(
    payPeriod: 'January 2026',
    payDate: DateTime(2026, 1, 28),
    workingDays: 22,
    paidDays: 22,
    earnings: const [
      EarningsItem(
        description: 'Basic Salary',
        descriptionAr: 'الراتب الأساسي',
        amount: 15000,
      ),
      EarningsItem(
        description: 'Housing Allowance',
        descriptionAr: 'بدل السكن',
        amount: 3750,
      ),
      EarningsItem(
        description: 'Transportation',
        descriptionAr: 'بدل المواصلات',
        amount: 1500,
      ),
    ],
    deductions: const [
      DeductionsItem(
        description: 'GOSI',
        descriptionAr: 'التأمينات',
        amount: 1462.50,
      ),
    ],
  );

  final template = PayslipTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    employee: employee,
    payslip: payslip,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'payslip_demo',
  );
}

NewTemplatesDemoBuild buildEmployeeReportDemo({required bool isRtl}) {
  final data = EmployeeReportData(
    reportTitle: 'Employee Report',
    reportTitleAr: 'تقرير الموظفين',
    reportDate: DateTime.now(),
    showSalary: true,
    employees: [
      EmployeeRecord(
        employeeId: 'EMP-001',
        name: 'Mohammed Al-Ahmed',
        nameAr: 'محمد الأحمد',
        department: 'Engineering',
        departmentAr: 'الهندسة',
        designation: 'Senior Developer',
        joiningDate: DateTime(2022, 3, 15),
        status: EmployeeStatus.active,
        salary: 21450,
      ),
      EmployeeRecord(
        employeeId: 'EMP-002',
        name: 'Sara Al-Qahtani',
        nameAr: 'سارة القحطاني',
        department: 'HR',
        departmentAr: 'الموارد البشرية',
        designation: 'HR Manager',
        joiningDate: DateTime(2021, 6, 1),
        status: EmployeeStatus.active,
        salary: 25000,
      ),
    ],
  );

  final template = EmployeeReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'employee_report_demo',
  );
}

NewTemplatesDemoBuild buildAttendanceReportDemo({required bool isRtl}) {
  final data = AttendanceReportData(
    reportTitle: 'Attendance Report',
    reportTitleAr: 'تقرير الحضور',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 15),
    showDailyDetails: false,
    employees: [
      AttendanceEmployeeSummary(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        employeeNameAr: 'محمد الأحمد',
        attendance: List.generate(
          11,
          (i) => DailyAttendance(
            date: DateTime(2026, 1, 1).add(Duration(days: i)),
            status: i % 7 == 5 || i % 7 == 6
                ? AttendanceStatus.weekend
                : AttendanceStatus.present,
            workingHours: 8,
          ),
        ),
      ),
    ],
  );

  final template = AttendanceReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'attendance_report_demo',
  );
}

NewTemplatesDemoBuild buildLeaveReportDemo({required bool isRtl}) {
  final data = LeaveReportData(
    reportTitle: 'Leave Report',
    reportTitleAr: 'تقرير الإجازات',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 12, 31),
    leaveBalances: const [
      LeaveBalance(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        employeeNameAr: 'محمد الأحمد',
        annualEntitlement: 21,
        annualUsed: 5,
        sickUsed: 2,
        carryForward: 3,
      ),
    ],
    leaveRequests: [
      LeaveRecord(
        leaveId: 'LV-001',
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        leaveType: LeaveType.annual,
        startDate: DateTime(2026, 2, 15),
        endDate: DateTime(2026, 2, 19),
        status: LeaveStatus.approved,
      ),
    ],
  );

  final template = LeaveReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'leave_report_demo',
  );
}
