
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S14Scenario {
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

class S14AccountingFinancePackVerificationPage
    extends StatefulWidget {
  const S14AccountingFinancePackVerificationPage({super.key});

  @override
  State<S14AccountingFinancePackVerificationPage> createState() =>
      _S14AccountingFinancePackVerificationPageState();
}

class _S14AccountingFinancePackVerificationPageState
    extends State<S14AccountingFinancePackVerificationPage> {
  _S14Scenario _scenario = _S14Scenario.generalLedger;
  bool _rtl = false;
  bool _carry = false;
  int _rowCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S14Scenario value) => switch (value) {
        _S14Scenario.generalLedger => 'General Ledger',
        _S14Scenario.journalEntry => 'Journal Entry',
        _S14Scenario.journalRegister => 'Journal Register',
        _S14Scenario.accountStatement => 'Account Statement',
        _S14Scenario.arAging => 'AR Aging',
        _S14Scenario.apAging => 'AP Aging',
        _S14Scenario.customerBalances => 'Customer Balances',
        _S14Scenario.supplierBalances => 'Supplier Balances',
        _S14Scenario.cashBook => 'Cash Book',
        _S14Scenario.bankBook => 'Bank Book',
        _S14Scenario.bankReconciliation => 'Bank Reconciliation',
        _S14Scenario.pettyCash => 'Petty Cash',
        _S14Scenario.paymentRegister => 'Payment Register',
        _S14Scenario.receiptRegister => 'Receipt Register',
        _S14Scenario.vatSummary => 'VAT / Tax Summary',
        _S14Scenario.taxRegister => 'Tax Register',
        _S14Scenario.taxBreakdown => 'Tax Breakdown',
        _S14Scenario.reconciliation => 'Rounding / Reconciliation',
        _S14Scenario.costCenterStatement => 'Cost Center Statement',
        _S14Scenario.costCenterTrialBalance => 'Cost Center Trial Balance',
        _S14Scenario.projectFinancial => 'Project Financial',
        _S14Scenario.budgetVsActual => 'Budget vs Actual',
        _S14Scenario.multiPeriod => 'Multi-period Comparison',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} renders through the S14 public '
      'API in ${_rtl ? 'RTL' : 'LTR'} with $_rowCount prepared row(s). '
      'Debit/credit remain semantic, financial values stay LTR inside RTL, '
      'negative accounting values use parentheses, hierarchy remains logical'
      '${_carry ? ', and carried/brought-forward rows are inserted at the '
          'configured estimate.' : '.'}';

  Future<Uint8List> _generate() async {
    const service = GeniusAccountingService();
    final config = _config;
    final postings = _postings(_rowCount);
    final opening = ErpMoney.fromAmount(
      1000,
      currency: ErpCurrency.sar,
    );
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S14Scenario.generalLedger:
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
      case _S14Scenario.journalEntry:
        document = GeniusJournalEntryDocument(
          config,
          report: service.journalEntry(_balancedJournal()),
        );
        break;
      case _S14Scenario.journalRegister:
        document = GeniusJournalRegisterDocument(
          config,
          report: service.journalRegister(postings),
        );
        break;
      case _S14Scenario.accountStatement:
        document = GeniusAccountStatementDocument(
          config,
          report: service.accountStatement(
            postings,
            account: postings.first.account,
            openingBalance: opening,
          ),
        );
        break;
      case _S14Scenario.arAging:
        document = GeniusArAgingDocument(
          config,
          report: service.arAging(
            _openItems(_rowCount, partyPrefix: 'Customer'),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S14Scenario.apAging:
        document = GeniusApAgingDocument(
          config,
          report: service.apAging(
            _openItems(_rowCount, partyPrefix: 'Supplier'),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S14Scenario.customerBalances:
        document = GeniusCustomerBalancesDocument(
          config,
          report: service.customerBalances(
            _openItems(_rowCount, partyPrefix: 'Customer'),
          ),
        );
        break;
      case _S14Scenario.supplierBalances:
        document = GeniusSupplierBalancesDocument(
          config,
          report: service.supplierBalances(
            _openItems(_rowCount, partyPrefix: 'Supplier'),
          ),
        );
        break;
      case _S14Scenario.cashBook:
        document = GeniusCashBookDocument(
          config,
          report: service.cashBook(postings),
        );
        break;
      case _S14Scenario.bankBook:
        document = GeniusBankBookDocument(
          config,
          report: service.bankBook(postings),
        );
        break;
      case _S14Scenario.bankReconciliation:
        document = GeniusBankReconciliationDocument(
          config,
          report: service.bankReconciliation(
            _bankLines(_rowCount),
          ),
        );
        break;
      case _S14Scenario.pettyCash:
        document = GeniusPettyCashDocument(
          config,
          report: service.pettyCash(postings),
        );
        break;
      case _S14Scenario.paymentRegister:
        document = GeniusPaymentRegisterDocument(
          config,
          report: service.paymentRegister(postings),
        );
        break;
      case _S14Scenario.receiptRegister:
        document = GeniusReceiptRegisterDocument(
          config,
          report: service.receiptRegister(postings),
        );
        break;
      case _S14Scenario.vatSummary:
        document = GeniusVatTaxSummaryDocument(
          config,
          report: service.vatSummary(_taxRecords(_rowCount)),
        );
        break;
      case _S14Scenario.taxRegister:
        document = GeniusTaxRegisterDocument(
          config,
          report: service.taxRegister(_taxRecords(_rowCount)),
        );
        break;
      case _S14Scenario.taxBreakdown:
        document = GeniusTaxBreakdownDocument(
          config,
          report: service.taxBreakdown(_taxRecords(_rowCount)),
        );
        break;
      case _S14Scenario.reconciliation:
        document = GeniusRoundingReconciliationDocument(
          config,
          report: service.reconciliation(
            _reconciliationRows(_rowCount),
          ),
        );
        break;
      case _S14Scenario.costCenterStatement:
        document = GeniusCostCenterStatementDocument(
          config,
          report: service.costCenterStatement(postings, 'CC-01'),
        );
        break;
      case _S14Scenario.costCenterTrialBalance:
        document = GeniusCostCenterTrialBalanceDocument(
          config,
          report: service.costCenterTrialBalance(postings),
        );
        break;
      case _S14Scenario.projectFinancial:
        document = GeniusProjectFinancialReport(
          config,
          report: service.projectFinancialReport(postings),
        );
        break;
      case _S14Scenario.budgetVsActual:
        document = GeniusBudgetVsActualReport(
          config,
          report: service.budgetVsActual(
            _budgetLines(_rowCount),
          ),
        );
        break;
      case _S14Scenario.multiPeriod:
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

  void _refresh() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S14 — Accounting & Finance Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 310,
                        child: DropdownButtonFormField<_S14Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S14Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 100, label: Text('100')),
                          ButtonSegment(value: 10000, label: Text('10k')),
                        ],
                        selected: {_rowCount},
                        onSelectionChanged: (value) {
                          _rowCount = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Carry forward'),
                        selected: _carry,
                        onSelected: (value) {
                          _carry = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's14_accounting_finance_pack.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
