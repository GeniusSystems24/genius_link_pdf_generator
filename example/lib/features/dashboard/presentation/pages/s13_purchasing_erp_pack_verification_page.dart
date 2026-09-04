
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S13Scenario {
  requisition,
  rfq,
  supplierQuotation,
  comparison,
  purchaseOrder,
  grn,
  purchaseInvoice,
  purchaseDebit,
  purchaseCredit,
  supplierReturn,
  supplierStatement,
  supplierAging,
  purchaseRegister,
  purchaseAnalysis,
  outstandingPo,
}

class S13PurchasingErpPackVerificationPage extends StatefulWidget {
  const S13PurchasingErpPackVerificationPage({super.key});

  @override
  State<S13PurchasingErpPackVerificationPage> createState() =>
      _S13PurchasingErpPackVerificationPageState();
}

class _S13PurchasingErpPackVerificationPageState
    extends State<S13PurchasingErpPackVerificationPage> {
  _S13Scenario _scenario = _S13Scenario.purchaseOrder;
  bool _rtl = false;
  bool _multiCurrency = false;
  int _lineCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _name(_S13Scenario scenario) => switch (scenario) {
        _S13Scenario.requisition => 'Purchase Requisition',
        _S13Scenario.rfq => 'Request for Quotation',
        _S13Scenario.supplierQuotation => 'Supplier Quotation',
        _S13Scenario.comparison => 'Quotation Comparison',
        _S13Scenario.purchaseOrder => 'Purchase Order',
        _S13Scenario.grn => 'Goods Receipt Note',
        _S13Scenario.purchaseInvoice => 'Purchase Invoice',
        _S13Scenario.purchaseDebit => 'Purchase Debit Note',
        _S13Scenario.purchaseCredit => 'Purchase Credit Note',
        _S13Scenario.supplierReturn => 'Supplier Return',
        _S13Scenario.supplierStatement => 'Supplier Statement',
        _S13Scenario.supplierAging => 'Supplier Aging',
        _S13Scenario.purchaseRegister => 'Purchase Register',
        _S13Scenario.purchaseAnalysis => 'Purchase Analysis',
        _S13Scenario.outstandingPo => 'Outstanding Purchase Orders',
      };

  String get _expected =>
      'Expected Result: ${_name(_scenario)} uses the S13 public API and '
      'shared family/page-flow. ${_rtl ? 'RTL vendor captions' : 'LTR layout'}; '
      '${_multiCurrency ? 'USD document with SAR base conversion; ' : ''}'
      'mixed SKU codes remain LTR. 50/500 rows must paginate without clipping.';

  Future<Uint8List> _generate() async {
    final config = _config;
    const analytics = GeniusPurchasingAnalytics();
    final entries = _entries(_lineCount);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S13Scenario.requisition:
        document = GeniusPurchaseRequisitionDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S13Scenario.rfq:
        document = GeniusRequestForQuotationDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S13Scenario.supplierQuotation:
        document = GeniusSupplierQuotationDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S13Scenario.comparison:
        document = GeniusQuotationComparisonDocument(
          config,
          report: analytics.quotationComparison(
            _supplierQuotes(_lineCount),
          ),
        );
        break;
      case _S13Scenario.purchaseOrder:
        document = GeniusPurchaseOrderDocument(
          config,
          request: _request(_lineCount),
          landedChargesHook: (request) => [
            ErpCharge.fixed(
              amount: ErpMoney.fromAmount(
                25,
                currency: request.document.documentCurrency,
              ),
              label: 'Freight',
              labelAr: 'شحن',
            ),
          ],
        );
        break;
      case _S13Scenario.grn:
        document = GeniusGoodsReceiptNoteDocument(
          config,
          report: analytics.goodsReceipt(entries),
        );
        break;
      case _S13Scenario.purchaseInvoice:
        document = GeniusPurchaseInvoiceDocument(
          config,
          request: _request(_lineCount),
          landedChargesHook: (request) => [
            ErpCharge.percentage(
              percentage: 1.5,
              label: 'Landed Cost',
              labelAr: 'تكلفة وصول',
            ),
          ],
        );
        break;
      case _S13Scenario.purchaseDebit:
        document = GeniusPurchaseAdjustmentDocument(
          config,
          request: _request(_lineCount),
          kind: GeniusPurchaseAdjustmentKind.debit,
        );
        break;
      case _S13Scenario.purchaseCredit:
        document = GeniusPurchaseAdjustmentDocument(
          config,
          request: _request(_lineCount, negative: true),
          kind: GeniusPurchaseAdjustmentKind.credit,
        );
        break;
      case _S13Scenario.supplierReturn:
        document = GeniusSupplierReturnDocument(
          config,
          request: _request(_lineCount, negative: true),
        );
        break;
      case _S13Scenario.supplierStatement:
        document = GeniusSupplierStatementDocument(
          config,
          report: analytics.supplierStatement(
            _openItems(_lineCount),
          ),
        );
        break;
      case _S13Scenario.supplierAging:
        document = GeniusSupplierAgingDocument(
          config,
          report: analytics.supplierAging(
            _openItems(_lineCount),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S13Scenario.purchaseRegister:
        document = GeniusPurchaseRegisterDocument(
          config,
          report: analytics.purchaseRegister(entries),
        );
        break;
      case _S13Scenario.purchaseAnalysis:
        document = GeniusPurchaseAnalysisReport(
          config,
          report: analytics.purchaseAnalysis(entries),
        );
        break;
      case _S13Scenario.outstandingPo:
        document = GeniusOutstandingPurchaseOrdersReport(
          config,
          report: analytics.outstandingPurchaseOrders(entries),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  GeniusErpPackTransactionRequest _request(
    int count, {
    bool negative = false,
  }) {
    final currency =
        _multiCurrency ? ErpCurrency.usd : ErpCurrency.sar;
    final baseCurrency =
        _multiCurrency ? ErpCurrency.sar : null;
    final exchangeRate = _multiCurrency
        ? const ErpExchangeRate(
            from: ErpCurrency.usd,
            to: ErpCurrency.sar,
            rate: 3.75,
          )
        : null;
    final sign = negative ? -1.0 : 1.0;

    final lines = List.generate(
      count,
      (index) => ErpLineItem(
        id: 'P${index + 1}',
        description: index == 0
            ? 'Long vendor item description for wrapping verification'
            : 'Purchase item ${index + 1}',
        descriptionAr: index == 0
            ? 'وصف طويل لصنف المورد للتحقق من التفاف النص'
            : 'صنف مشتريات ${index + 1}',
        sku: index.isEven
            ? 'SKU-AR-${index + 1}'
            : 'صنف-${index + 1}-EN',
        quantity: ErpQuantity(
          value: sign * ((index % 5) + 1),
          unit: ErpUnit.each,
        ),
        unitPrice: ErpMoney.fromAmount(
          20 + (index % 9),
          currency: currency,
        ),
        discounts: index % 4 == 0
            ? [ErpDiscount.percentage(percentage: 3)]
            : const [],
        taxes: const [
          ErpTaxLine(code: 'VAT', ratePercent: 15),
        ],
        batch: ErpBatchInfo(
          batchNumber: 'PB-${index % 4}',
          expiryDate: DateTime(2028, 1, 31),
        ),
      ),
    );

    return GeniusErpPackTransactionRequest(
      document: ErpDocumentContext(
        organization: const ErpOrganization(
          id: 'ORG-01',
          legalName: 'Genius Systems',
          nameAr: 'أنظمة جينيس',
        ),
        identity: ErpDocumentIdentity(
          kind: ErpDocumentKind.purchaseOrder,
          number: 'S13-PO-2026-0001',
          issueDate: DateTime(2026, 9, 4),
          status: ErpDocumentStatus.approved,
        ),
        recipient: const ErpParty(
          id: 'V-001',
          name: 'Global Supplier',
          nameAr: 'المورد العالمي',
          registrationNumber: 'CR-10001',
          taxIdentity: ErpTaxIdentity(
            taxNumber: '310000000000010',
          ),
          addresses: [
            ErpAddress(
              role: ErpAddressRole.registered,
              line1: 'Supplier HQ',
              city: 'Jeddah',
              countryCode: 'SA',
            ),
          ],
        ),
        shippingAddress: count.isEven
            ? null
            : const ErpAddress(
                role: ErpAddressRole.warehouse,
                line1: 'Main Receiving Dock',
                city: 'Riyadh',
                countryCode: 'SA',
              ),
        documentCurrency: currency,
        baseCurrency: baseCurrency,
        exchangeRate: exchangeRate,
        references: const [
          ErpDocumentReference(
            type: 'requisition',
            number: 'PR-2026-001',
          ),
        ],
        lineItems: lines,
        approvals: const [
          ErpApproval(
            stage: 'Procurement',
            status: ErpApprovalStatus.approved,
            approverName: 'Procurement Manager',
          ),
          ErpApproval(
            stage: 'Finance',
            status: ErpApprovalStatus.approved,
            approverName: 'Finance Manager',
          ),
        ],
        notes: 'Vendor notes may be null or very long.',
        terms:
            'Supplier terms: delivery, warranty, inspection and payment conditions.',
      ),
      allowNegativeValues: negative,
      paymentTerms: 'Net 45',
      expectedDelivery: DateTime(2026, 9, 25),
      warehouse: 'MAIN-WH',
      site: 'Riyadh',
      extraDetails: const [
        GeniusErpDetailField(
          label: 'Buyer',
          labelAr: 'المشتري',
          value: 'PROC-01',
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      ],
    );
  }

  List<GeniusPurchaseLedgerEntry> _entries(int count) =>
      List.generate(
        count,
        (index) => GeniusPurchaseLedgerEntry(
          date: DateTime(2026, 9, 1 + (index % 4)),
          documentNumber: 'PO-${index + 1}',
          supplierId: 'V${index % 5}',
          supplierName: 'Supplier ${index % 5}',
          supplierNameAr: 'مورد ${index % 5}',
          itemCode: index.isEven
              ? 'SKU-${index + 1}'
              : 'رمز-${index + 1}-EN',
          itemName: 'Item ${index + 1}',
          itemNameAr: 'صنف ${index + 1}',
          orderedQuantity: 10,
          receivedQuantity: index % 3 == 0 ? 10 : 4,
          netAmount: ErpMoney.fromAmount(
            150 + index,
            currency: ErpCurrency.sar,
          ),
          taxAmount: ErpMoney.fromAmount(
            22.5 + index * 0.15,
            currency: ErpCurrency.sar,
          ),
          expectedDelivery: DateTime(2026, 9, 20),
          warehouse: 'MAIN-WH',
          site: 'Riyadh',
        ),
      );

  List<GeniusSupplierQuoteLine> _supplierQuotes(int count) {
    final rows = <GeniusSupplierQuoteLine>[];
    for (var index = 0; index < count; index++) {
      for (var supplier = 0; supplier < 3; supplier++) {
        rows.add(
          GeniusSupplierQuoteLine(
            supplierId: 'V$supplier',
            supplierName: 'Supplier $supplier',
            supplierNameAr: 'مورد $supplier',
            itemCode: 'SKU-${index + 1}',
            itemDescription: 'Item ${index + 1}',
            itemDescriptionAr: 'صنف ${index + 1}',
            unitPrice: ErpMoney.fromAmount(
              100 + index + supplier * 5,
              currency: ErpCurrency.sar,
            ),
            leadTimeDays: 5 + supplier,
            validUntil: DateTime(2026, 10, 31),
          ),
        );
      }
    }
    return rows;
  }

  List<GeniusErpOpenItem> _openItems(int count) =>
      List.generate(
        count,
        (index) => GeniusErpOpenItem(
          partyId: 'V${index % 4}',
          partyName: 'Supplier ${index % 4}',
          documentNumber: 'PI-${index + 1}',
          issueDate: DateTime(2026, 5, 1),
          dueDate: DateTime(2026, 6, 1 + (index % 28)),
          amount: ErpMoney.fromAmount(
            200 + index,
            currency: ErpCurrency.sar,
          ),
        ),
      );

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
                    'Sprint S13 — Purchasing ERP Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<_S13Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Document / Report',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S13Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_name(value)),
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
                          ButtonSegment(value: 1, label: Text('1 row')),
                          ButtonSegment(value: 50, label: Text('50 rows')),
                          ButtonSegment(value: 500, label: Text('500 rows')),
                        ],
                        selected: {_lineCount},
                        onSelectionChanged: (values) {
                          _lineCount = values.first;
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
                        label: const Text('Multi-currency'),
                        selected: _multiCurrency,
                        onSelected: (value) {
                          _multiCurrency = value;
                          _refresh();
                        },
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's13_purchasing_erp_pack.pdf',
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
