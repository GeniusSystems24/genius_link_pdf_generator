// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S14AccountingFinancePackVerificationPage.
enum S14AccountingFinancePackScenario {
  generalLedger,
  journalEntry,
  journalRegister,
  accountStatement,
  arAging,
  apAging,
  customerBalances,
  supplierBalances,
  cashBook,
  bankBook,
  bankReconciliation,
  pettyCash,
  paymentRegister,
  receiptRegister,
  vatSummary,
  taxRegister,
  taxBreakdown,
  reconciliation,
  costCenterStatement,
  costCenterTrialBalance,
  projectFinancial,
  budgetVsActual,
  multiPeriod,
}

/// Executes one focused S14 verification scenario.
class S14AccountingFinancePackRunner {
  S14AccountingFinancePackRunner({
    required GeniusPdfConfig baseConfig,
    required S14AccountingFinancePackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S14AccountingFinancePackScenario _scenario;
bool _rtl = false;
  final bool _carry = false;
  final int _rowCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S14AccountingFinancePackScenario value) => switch (value) {
        S14AccountingFinancePackScenario.generalLedger => 'General Ledger',
        S14AccountingFinancePackScenario.journalEntry => 'Journal Entry',
        S14AccountingFinancePackScenario.journalRegister => 'Journal Register',
        S14AccountingFinancePackScenario.accountStatement => 'Account Statement',
        S14AccountingFinancePackScenario.arAging => 'AR Aging',
        S14AccountingFinancePackScenario.apAging => 'AP Aging',
        S14AccountingFinancePackScenario.customerBalances => 'Customer Balances',
        S14AccountingFinancePackScenario.supplierBalances => 'Supplier Balances',
        S14AccountingFinancePackScenario.cashBook => 'Cash Book',
        S14AccountingFinancePackScenario.bankBook => 'Bank Book',
        S14AccountingFinancePackScenario.bankReconciliation => 'Bank Reconciliation',
        S14AccountingFinancePackScenario.pettyCash => 'Petty Cash',
        S14AccountingFinancePackScenario.paymentRegister => 'Payment Register',
        S14AccountingFinancePackScenario.receiptRegister => 'Receipt Register',
        S14AccountingFinancePackScenario.vatSummary => 'VAT / Tax Summary',
        S14AccountingFinancePackScenario.taxRegister => 'Tax Register',
        S14AccountingFinancePackScenario.taxBreakdown => 'Tax Breakdown',
        S14AccountingFinancePackScenario.reconciliation => 'Rounding / Reconciliation',
        S14AccountingFinancePackScenario.costCenterStatement => 'Cost Center Statement',
        S14AccountingFinancePackScenario.costCenterTrialBalance => 'Cost Center Trial Balance',
        S14AccountingFinancePackScenario.projectFinancial => 'Project Financial',
        S14AccountingFinancePackScenario.budgetVsActual => 'Budget vs Actual',
        S14AccountingFinancePackScenario.multiPeriod => 'Multi-period Comparison',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} renders through the S14 public '
      'API in ${_rtl ? 'RTL' : 'LTR'} with $_rowCount prepared row(s). '
      'Debit/credit remain semantic, financial values stay LTR inside RTL, '
      'negative accounting values use parentheses, hierarchy remains logical'
      '${_carry ? ', and carried/brought-forward rows are inserted at the '
          'configured estimate.' : '.'}';

  Future<Uint8List> generate() async {
    const service = GeniusAccountingService();
    final config = _config;
    final postings = _postings(_rowCount);
    final opening = ErpMoney.fromAmount(
      1000,
      currency: ErpCurrency.sar,
    );
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S14AccountingFinancePackScenario.generalLedger:
        document = GeniusGeneralLedgerDocument(
          config,
          report: service.generalLedger(
            postings,
            openingBalance: opening,
            carryPolicy: _carry
                ? GeniusAccountingCarryPolicy.estimatedPageRows
                : GeniusAccountingCarryPolicy.none,
            estimatedRowsPerPage: 30,
          ),
        );
        break;
      case S14AccountingFinancePackScenario.journalEntry:
        document = GeniusJournalEntryDocument(
          config,
          report: service.journalEntry(_balancedJournal()),
        );
        break;
      case S14AccountingFinancePackScenario.journalRegister:
        document = GeniusJournalRegisterDocument(
          config,
          report: service.journalRegister(postings),
        );
        break;
      case S14AccountingFinancePackScenario.accountStatement:
        document = GeniusAccountStatementDocument(
          config,
          report: service.accountStatement(
            postings,
            account: postings.first.account,
            openingBalance: opening,
          ),
        );
        break;
      case S14AccountingFinancePackScenario.arAging:
        document = GeniusArAgingDocument(
          config,
          report: service.arAging(
            _openItems(_rowCount, partyPrefix: 'Customer'),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.apAging:
        document = GeniusApAgingDocument(
          config,
          report: service.apAging(
            _openItems(_rowCount, partyPrefix: 'Supplier'),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.customerBalances:
        document = GeniusCustomerBalancesDocument(
          config,
          report: service.customerBalances(
            _openItems(_rowCount, partyPrefix: 'Customer'),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.supplierBalances:
        document = GeniusSupplierBalancesDocument(
          config,
          report: service.supplierBalances(
            _openItems(_rowCount, partyPrefix: 'Supplier'),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.cashBook:
        document = GeniusCashBookDocument(
          config,
          report: service.cashBook(postings),
        );
        break;
      case S14AccountingFinancePackScenario.bankBook:
        document = GeniusBankBookDocument(
          config,
          report: service.bankBook(postings),
        );
        break;
      case S14AccountingFinancePackScenario.bankReconciliation:
        document = GeniusBankReconciliationDocument(
          config,
          report: service.bankReconciliation(
            _bankLines(_rowCount),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.pettyCash:
        document = GeniusPettyCashDocument(
          config,
          report: service.pettyCash(postings),
        );
        break;
      case S14AccountingFinancePackScenario.paymentRegister:
        document = GeniusPaymentRegisterDocument(
          config,
          report: service.paymentRegister(postings),
        );
        break;
      case S14AccountingFinancePackScenario.receiptRegister:
        document = GeniusReceiptRegisterDocument(
          config,
          report: service.receiptRegister(postings),
        );
        break;
      case S14AccountingFinancePackScenario.vatSummary:
        document = GeniusVatTaxSummaryDocument(
          config,
          report: service.vatSummary(_taxRecords(_rowCount)),
        );
        break;
      case S14AccountingFinancePackScenario.taxRegister:
        document = GeniusTaxRegisterDocument(
          config,
          report: service.taxRegister(_taxRecords(_rowCount)),
        );
        break;
      case S14AccountingFinancePackScenario.taxBreakdown:
        document = GeniusTaxBreakdownDocument(
          config,
          report: service.taxBreakdown(_taxRecords(_rowCount)),
        );
        break;
      case S14AccountingFinancePackScenario.reconciliation:
        document = GeniusRoundingReconciliationDocument(
          config,
          report: service.reconciliation(
            _reconciliationRows(_rowCount),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.costCenterStatement:
        document = GeniusCostCenterStatementDocument(
          config,
          report: service.costCenterStatement(postings, 'CC-01'),
        );
        break;
      case S14AccountingFinancePackScenario.costCenterTrialBalance:
        document = GeniusCostCenterTrialBalanceDocument(
          config,
          report: service.costCenterTrialBalance(postings),
        );
        break;
      case S14AccountingFinancePackScenario.projectFinancial:
        document = GeniusProjectFinancialReport(
          config,
          report: service.projectFinancialReport(postings),
        );
        break;
      case S14AccountingFinancePackScenario.budgetVsActual:
        document = GeniusBudgetVsActualReport(
          config,
          report: service.budgetVsActual(
            _budgetLines(_rowCount),
          ),
        );
        break;
      case S14AccountingFinancePackScenario.multiPeriod:
        document = GeniusMultiPeriodComparisonReport(
          config,
          report: service.multiPeriodComparison(
            _periodValues(_rowCount),
          ),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  List<GeniusAccountingPosting> _postings(int count) =>
      List.generate(
        count,
        (index) {
          final debitSide = index.isEven;
          return GeniusAccountingPosting(
            date: DateTime(2026, 9, (index % 28) + 1),
            documentNumber: 'JV-${index + 1}',
            account: GeniusAccountingAccount(
              code: '1.${index % 5}.${index % 20}.${index + 1}',
              name: 'Account ${index % 20}',
              nameAr: 'حساب ${index % 20}',
              level: index % 8,
            ),
            description: index == 0
                ? 'Long accounting description for wrapping and hierarchy verification'
                : 'Ledger posting ${index + 1}',
            descriptionAr: index == 0
                ? 'وصف محاسبي عربي طويل للتحقق من الالتفاف والهرمية'
                : 'قيد دفتر ${index + 1}',
            debit: ErpMoney.fromAmount(
              debitSide ? 10 + index : 0,
              currency: ErpCurrency.sar,
            ),
            credit: ErpMoney.fromAmount(
              debitSide ? 0 : 10 + index,
              currency: ErpCurrency.sar,
            ),
            costCenter: 'CC-0${index % 3 + 1}',
            project: 'PRJ-0${index % 4 + 1}',
          );
        },
      );

  List<GeniusAccountingPosting> _balancedJournal() => [
        GeniusAccountingPosting(
          date: DateTime(2026, 9, 4),
          documentNumber: 'JV-BAL-1',
          account: const GeniusAccountingAccount(
            code: '1100',
            name: 'Cash',
            nameAr: 'النقدية',
          ),
          description: 'Balanced debit',
          descriptionAr: 'مدين متوازن',
          debit: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
          credit: ErpMoney.zero(ErpCurrency.sar),
        ),
        GeniusAccountingPosting(
          date: DateTime(2026, 9, 4),
          documentNumber: 'JV-BAL-1',
          account: const GeniusAccountingAccount(
            code: '4100',
            name: 'Revenue',
            nameAr: 'الإيراد',
            normalSide: GeniusAccountingEntrySide.credit,
          ),
          description: 'Balanced credit',
          descriptionAr: 'دائن متوازن',
          debit: ErpMoney.zero(ErpCurrency.sar),
          credit: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
        ),
      ];

  List<GeniusErpOpenItem> _openItems(
    int count, {
    required String partyPrefix,
  }) =>
      List.generate(
        count,
        (index) => GeniusErpOpenItem(
          partyId: '${partyPrefix[0]}-${index % 10}',
          partyName: '$partyPrefix ${index % 10}',
          partyNameAr: '${partyPrefix == 'Customer' ? 'عميل' : 'مورد'} ${index % 10}',
          documentNumber: 'DOC-${index + 1}',
          issueDate: DateTime(2026, 5, 1),
          dueDate: DateTime(2026, 5, (index % 28) + 1),
          amount: ErpMoney.fromAmount(
            100 + index,
            currency: ErpCurrency.sar,
          ),
          paidAmount: index % 3 == 0
              ? ErpMoney.fromAmount(
                  25,
                  currency: ErpCurrency.sar,
                )
              : null,
        ),
      );

  List<GeniusAccountingBankReconciliationLine> _bankLines(int count) =>
      List.generate(
        count,
        (index) => GeniusAccountingBankReconciliationLine(
          date: DateTime(2026, 9, (index % 28) + 1),
          reference: 'BANK-${index + 1}',
          description: 'Bank line ${index + 1}',
          descriptionAr: 'حركة بنك ${index + 1}',
          bookAmount: ErpMoney.fromAmount(
            100 + index,
            currency: ErpCurrency.sar,
          ),
          statementAmount: ErpMoney.fromAmount(
            100 + index + (index % 4 == 0 ? 0.01 : 0),
            currency: ErpCurrency.sar,
          ),
        ),
      );

  List<GeniusAccountingTaxRecord> _taxRecords(int count) =>
      List.generate(
        count,
        (index) {
          final category = GeniusAccountingTaxCategory
              .values[index % GeniusAccountingTaxCategory.values.length];
          final rate =
              category == GeniusAccountingTaxCategory.taxable ? 15.0 : 0.0;
          final net = 100.0 + index;
          return GeniusAccountingTaxRecord(
            date: DateTime(2026, 9, (index % 28) + 1),
            documentNumber: 'TAX-${index + 1}',
            partyName: 'Party ${index % 8}',
            partyNameAr: 'طرف ${index % 8}',
            netAmount: ErpMoney.fromAmount(
              net,
              currency: ErpCurrency.sar,
            ),
            taxAmount: ErpMoney.fromAmount(
              net * rate / 100,
              currency: ErpCurrency.sar,
            ),
            category: category,
            ratePercent: rate,
          );
        },
      );

  List<GeniusAccountingReconciliationItem> _reconciliationRows(int count) =>
      List.generate(
        count,
        (index) => GeniusAccountingReconciliationItem(
          label: 'Reconciliation ${index + 1}',
          labelAr: 'تسوية ${index + 1}',
          expected: ErpMoney.fromAmount(
            100 + index,
            currency: ErpCurrency.sar,
          ),
          actual: ErpMoney.fromAmount(
            100 + index + (index.isEven ? 0.01 : -0.01),
            currency: ErpCurrency.sar,
          ),
        ),
      );

  List<GeniusAccountingBudgetLine> _budgetLines(int count) =>
      List.generate(
        count,
        (index) => GeniusAccountingBudgetLine(
          code: 'B-${index + 1}',
          name: 'Budget Account ${index + 1}',
          nameAr: 'حساب موازنة ${index + 1}',
          budget: ErpMoney.fromAmount(
            1000 + index * 10,
            currency: ErpCurrency.sar,
          ),
          actual: ErpMoney.fromAmount(
            950 + index * 12,
            currency: ErpCurrency.sar,
          ),
          costCenter: 'CC-0${index % 3 + 1}',
          project: 'PRJ-0${index % 4 + 1}',
        ),
      );

  List<GeniusAccountingPeriodAmount> _periodValues(int count) {
    final result = <GeniusAccountingPeriodAmount>[];
    for (var index = 0; index < count; index++) {
      for (final period in ['2026-07', '2026-08', '2026-09']) {
        result.add(
          GeniusAccountingPeriodAmount(
            accountCode: 'A-${index + 1}',
            accountName: 'Account ${index + 1}',
            accountNameAr: 'حساب ${index + 1}',
            period: period,
            amount: ErpMoney.fromAmount(
              100 + index,
              currency: ErpCurrency.sar,
            ),
          ),
        );
      }
    }
    return result;
  }
}


Future<Uint8List> buildS14GeneralLedgerVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.generalLedger,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14JournalEntryVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.journalEntry,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14JournalRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.journalRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14AccountStatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.accountStatement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14ArAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.arAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14ApAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.apAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14CustomerBalancesVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.customerBalances,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14SupplierBalancesVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.supplierBalances,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14CashBookVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.cashBook,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14BankBookVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.bankBook,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14BankReconciliationVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.bankReconciliation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14PettyCashVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.pettyCash,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14PaymentRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.paymentRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14ReceiptRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.receiptRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14VatSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.vatSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14TaxRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.taxRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14TaxBreakdownVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.taxBreakdown,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14ReconciliationVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.reconciliation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14CostCenterStatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.costCenterStatement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14CostCenterTrialBalanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.costCenterTrialBalance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14ProjectFinancialVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.projectFinancial,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14BudgetVsActualVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.budgetVsActual,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS14MultiPeriodVerificationPdf(GeniusPdfConfig config) {
  final runner = S14AccountingFinancePackRunner(
    baseConfig: config,
    scenario: S14AccountingFinancePackScenario.multiPeriod,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
