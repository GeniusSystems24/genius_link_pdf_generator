
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusHrEmployee employee({
  String id = 'EMP-001',
  String name = 'Ahmed Ali',
  String? nameAr = 'أحمد علي',
}) =>
    GeniusHrEmployee(
      employeeId: id,
      name: name,
      nameAr: nameAr,
      joinDate: DateTime(2018, 1, 1),
      department: 'Finance',
      departmentAr: 'المالية',
      jobTitle: 'Accountant',
      jobTitleAr: 'محاسب',
      nationalId: '1234567890',
      bankAccount: '9876543210123456',
      iban: 'SA0380000000608010167519',
      baseSalary: ErpMoney.fromAmount(
        10000,
        currency: ErpCurrency.sar,
      ),
    );

GeniusHrPayrollEntry payroll({
  int allowanceCount = 2,
  int deductionCount = 2,
}) {
  final person = employee();
  return GeniusHrPayrollEntry(
    employee: person,
    period: '2026-09',
    baseSalary: ErpMoney.fromAmount(
      10000,
      currency: ErpCurrency.sar,
    ),
    earnings: List.generate(
      allowanceCount,
      (index) => GeniusHrPayrollEarning(
        code: 'ALW-$index',
        label: 'Allowance $index',
        labelAr: 'بدل $index',
        amount: ErpMoney.fromAmount(
          100 + index,
          currency: ErpCurrency.sar,
        ),
      ),
    ),
    deductions: List.generate(
      deductionCount,
      (index) => GeniusHrPayrollDeduction(
        code: 'DED-$index',
        label: 'Deduction $index',
        labelAr: 'استقطاع $index',
        amount: ErpMoney.fromAmount(
          10 + index,
          currency: ErpCurrency.sar,
        ),
      ),
    ),
  );
}

void main() {
  const service = GeniusHrPayrollService();

  test('payroll totals reconcile before rendering', () {
    final result = service.calculatePayroll(payroll());

    expect(result.source.baseSalary.toDouble(), 10000);
    expect(result.totalEarnings.toDouble(), 201);
    expect(result.totalDeductions.toDouble(), 21);
    expect(result.gross.toDouble(), 10201);
    expect(result.net.toDouble(), 10180);

    final summary = service.payrollSummary([payroll()]);
    expect(summary.rows.last.isTotal, isTrue);
    expect(summary.rows.last.cells['amount'], 10180);
  });

  test('long allowance and deduction lists stay in report data', () {
    final entry = payroll(
      allowanceCount: 80,
      deductionCount: 90,
    );

    final payslip = service.payslip(entry);
    final allowances = service.allowancesReport([entry]);
    final deductions = service.deductionsReport([entry]);

    // base + allowances + deductions + net
    expect(payslip.rows.length, 172);
    expect(allowances.rows, hasLength(80));
    expect(deductions.rows, hasLength(90));
  });

  test('sensitive IDs and IBAN are masked by default', () {
    const policy = GeniusHrPrintPolicy();
    final person = employee();

    expect(
      policy.protect(
        GeniusHrField.nationalId,
        person.nationalId,
      ),
      '••••••7890',
    );
    expect(
      policy.protect(
        GeniusHrField.iban,
        person.iban,
      ),
      endsWith('7519'),
    );
    expect(
      policy.protect(
        GeniusHrField.iban,
        person.iban,
      ),
      isNot(person.iban),
    );
  });

  test('role visibility can suppress bank/loan fields', () {
    const employeePolicy = GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.employee,
    );
    const payrollPolicy = GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    );

    expect(
      employeePolicy.isVisible(GeniusHrField.bankAccount),
      isFalse,
    );
    expect(
      employeePolicy.isVisible(GeniusHrField.loanBalance),
      isFalse,
    );
    expect(
      payrollPolicy.isVisible(GeniusHrField.bankAccount),
      isTrue,
    );
  });

  test('Arabic employee + Latin IDs remain separate semantic values', () {
    final report = service.employeeList([
      employee(
        id: 'EMP-LATIN-009',
        name: 'Arabic User',
        nameAr: 'موظف عربي',
      ),
    ]);

    expect(report.rows.single.cells['id'], 'EMP-LATIN-009');
    expect(
      report.rows.single.cells['name'],
      isA<GeniusErpPackLocalizedValue>(),
    );
  });

  test('end-of-service formula is policy driven and deterministic', () {
    final person = GeniusHrEmployee(
      employeeId: 'EOS-1',
      name: 'Employee',
      joinDate: DateTime(2020, 1, 1),
    );

    final result = service.calculateEndOfService(
      employee: person,
      serviceEndDate: DateTime(2026, 1, 1),
      monthlySalary: ErpMoney.fromAmount(
        9000,
        currency: ErpCurrency.sar,
      ),
      policy: const GeniusHrEndOfServicePolicy(
        thresholdYears: 5,
        firstYearsDaysPerYear: 15,
        laterYearsDaysPerYear: 30,
        includePartialYear: false,
      ),
    );

    expect(result.serviceYears, 6);
    expect(result.eligibleDays, 105);
    expect(result.dailyRate.toDouble(), 300);
    expect(result.benefit.toDouble(), 31500);
  });

  test('final settlement reconciles all earning/deduction components', () {
    final settlement = service.calculateFinalSettlement(
      employee: employee(),
      endDate: DateTime(2026, 9, 30),
      salaryDue: ErpMoney.fromAmount(
        5000,
        currency: ErpCurrency.sar,
      ),
      leaveEncashment: ErpMoney.fromAmount(
        1200,
        currency: ErpCurrency.sar,
      ),
      endOfService: ErpMoney.fromAmount(
        20000,
        currency: ErpCurrency.sar,
      ),
      otherEarnings: ErpMoney.fromAmount(
        300,
        currency: ErpCurrency.sar,
      ),
      deductions: ErpMoney.fromAmount(
        2500,
        currency: ErpCurrency.sar,
      ),
    );

    expect(settlement.netSettlement.toDouble(), 24000);
  });

  test('certificate single-page guard rejects oversized payload', () {
    final certificate = GeniusHrCertificateData(
      certificateNumber: 'CERT-1',
      employee: employee(),
      issueDate: DateTime(2026, 9, 4),
      body: List.filled(2000, 'x').join(),
    );

    expect(
      () => service.validateCertificate(
        certificate,
        const GeniusHrCertificatePolicy(
          maxBodyCharacters: 1000,
        ),
      ),
      throwsArgumentError,
    );
  });

  test('certificate normal content satisfies single-page contract', () {
    final certificate = GeniusHrCertificateData(
      certificateNumber: 'CERT-OK',
      employee: employee(),
      issueDate: DateTime(2026, 9, 4),
      body: 'This is to certify employment and salary information.',
      bodyAr: 'تشهد الشركة ببيانات العمل والراتب.',
    );

    expect(
      () => service.validateCertificate(
        certificate,
        const GeniusHrCertificatePolicy(),
      ),
      returnsNormally,
    );
  });
}
