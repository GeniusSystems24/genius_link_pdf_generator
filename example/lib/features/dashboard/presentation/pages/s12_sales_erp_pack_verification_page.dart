
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S12Scenario {
  salesOrder,
  proforma,
  pos,
  debitNote,
  salesReturn,
  customerReceipt,
  picking,
  packing,
  backorder,
  customerAging,
  salesRegister,
  byCustomer,
  byItem,
  bySalesperson,
  priceList,
  commission,
}

class S12SalesErpPackVerificationPage extends StatefulWidget {
  const S12SalesErpPackVerificationPage({super.key});

  @override
  State<S12SalesErpPackVerificationPage> createState() =>
      _S12SalesErpPackVerificationPageState();
}

class _S12SalesErpPackVerificationPageState
    extends State<S12SalesErpPackVerificationPage> {
  _S12Scenario _scenario = _S12Scenario.salesOrder;
  bool _rtl = false;
  bool _bilingual = false;
  bool _inclusiveTax = false;
  bool _multiCurrency = false;
  bool _reprint = false;
  bool _nullOptionals = false;
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

  String _name(_S12Scenario scenario) => switch (scenario) {
        _S12Scenario.salesOrder => 'Sales Order',
        _S12Scenario.proforma => 'Proforma Invoice',
        _S12Scenario.pos => 'Simplified / POS Invoice',
        _S12Scenario.debitNote => 'Debit Note',
        _S12Scenario.salesReturn => 'Sales Return',
        _S12Scenario.customerReceipt => 'Customer Receipt',
        _S12Scenario.picking => 'Picking List',
        _S12Scenario.packing => 'Packing List',
        _S12Scenario.backorder => 'Backorder',
        _S12Scenario.customerAging => 'Customer Aging',
        _S12Scenario.salesRegister => 'Sales Register',
        _S12Scenario.byCustomer => 'Sales by Customer',
        _S12Scenario.byItem => 'Sales by Item',
        _S12Scenario.bySalesperson => 'Sales by Salesperson',
        _S12Scenario.priceList => 'Price List',
        _S12Scenario.commission => 'Commission Report',
      };

  String get _expected =>
      'Expected Result: ${_name(_scenario)} uses the public S12 pack API, '
      '${_rtl ? 'RTL' : 'LTR'} layout, $_lineCount row(s), '
      '${_inclusiveTax ? 'tax-inclusive' : 'tax-exclusive'} calculation; '
      '${_multiCurrency ? 'USD document / SAR base conversion; ' : ''}'
      '${_reprint ? 'reprint metadata; ' : 'original metadata; '}'
      'structured numbers/codes remain LTR. '
      '${_nullOptionals ? 'Null optional sections collapse.' : ''} '
      '50/500 rows must paginate without clipping.';

  Future<Uint8List> _generate() async {
    final config = _config;
    final analytics = const GeniusSalesAnalytics();
    final entries = _salesEntries(_lineCount);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S12Scenario.salesOrder:
        document = GeniusSalesOrderDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S12Scenario.proforma:
        document = GeniusProformaInvoiceDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S12Scenario.pos:
        document = GeniusPosInvoiceDocument(
          config,
          request: _request(_lineCount),
          printProfile:
              GeniusPdfPrintProfile.thermal80().toFamilyProfile(),
        );
        break;
      case _S12Scenario.debitNote:
        document = GeniusSalesDebitNoteDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case _S12Scenario.salesReturn:
        document = GeniusSalesReturnDocument(
          config,
          request: _request(_lineCount, negative: true),
        );
        break;
      case _S12Scenario.customerReceipt:
        document = GeniusCustomerReceiptDocument(
          config,
          request: _request(1, paid: true),
        );
        break;
      case _S12Scenario.picking:
        document = GeniusPickingListDocument(
          config,
          report: _fulfillmentReport(
            _lineCount,
            title: 'Picking List',
            titleAr: 'قائمة التجهيز',
          ),
        );
        break;
      case _S12Scenario.packing:
        document = GeniusPackingListDocument(
          config,
          report: _fulfillmentReport(
            _lineCount,
            title: 'Packing List',
            titleAr: 'قائمة التعبئة',
          ),
        );
        break;
      case _S12Scenario.backorder:
        document = GeniusBackorderDocument(
          config,
          report: analytics.backorders(_backorders(_lineCount)),
        );
        break;
      case _S12Scenario.customerAging:
        document = GeniusCustomerAgingDocument(
          config,
          report: analytics.customerAging(
            _openItems(_lineCount),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S12Scenario.salesRegister:
        document = GeniusSalesRegisterDocument(
          config,
          report: analytics.salesRegister(entries),
        );
        break;
      case _S12Scenario.byCustomer:
        document = GeniusSalesByCustomerReport(
          config,
          report: analytics.salesByCustomer(entries),
        );
        break;
      case _S12Scenario.byItem:
        document = GeniusSalesByItemReport(
          config,
          report: analytics.salesByItem(entries),
        );
        break;
      case _S12Scenario.bySalesperson:
        document = GeniusSalesBySalespersonReport(
          config,
          report: analytics.salesBySalesperson(entries),
        );
        break;
      case _S12Scenario.priceList:
        document = GeniusPriceListDocument(
          config,
          report: analytics.priceList(_prices(_lineCount)),
        );
        break;
      case _S12Scenario.commission:
        document = GeniusCommissionReport(
          config,
          report: analytics.commissionReport(entries),
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
    bool paid = false,
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
    final lines = List.generate(count, (index) {
      final sign = negative
          ? (index.isEven ? -1.0 : 0.0)
          : 1.0;
      return ErpLineItem(
        id: 'L${index + 1}',
        description: _bilingual
            ? 'Product ${index + 1} / منتج ${index + 1}'
            : index == 0
                ? 'Long product description for wrapping verification'
                : 'Product ${index + 1}',
        descriptionAr: _bilingual
            ? 'منتج ${index + 1} / Product ${index + 1}'
            : index == 0
                ? 'وصف منتج طويل للتحقق من التفاف النص داخل المستند'
                : 'منتج ${index + 1}',
        sku: 'SKU-${(index + 1).toString().padLeft(5, '0')}',
        quantity: ErpQuantity(
          value: sign * ((index % 4) + 1),
          unit: ErpUnit.each,
        ),
        unitPrice: ErpMoney.fromAmount(
          10 + (index % 7),
          currency: currency,
        ),
        discounts: index % 5 == 0
            ? [
                ErpDiscount.percentage(percentage: 5),
              ]
            : const [],
        taxes: const [
          ErpTaxLine(code: 'VAT', ratePercent: 15),
        ],
        batch: ErpBatchInfo(
          batchNumber: 'B-${index % 3 + 1}',
          expiryDate: DateTime(2027, 12, 31),
        ),
        serials: [
          ErpSerialInfo(
            serialNumber:
                'SN-${(100000 + index).toString()}',
          ),
        ],
      );
    });

    final context = ErpDocumentContext(
      organization: const ErpOrganization(
        id: 'ORG-01',
        legalName: 'Genius Systems',
        nameAr: 'أنظمة جينيس',
      ),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.other,
        number: 'S12-2026-0001',
        issueDate: DateTime(2026, 9, 4),
        status: ErpDocumentStatus.issued,
      ),
      recipient: const ErpParty(
        id: 'C-001',
        name: 'Acme Customer',
        nameAr: 'عميل أكمي',
        taxIdentity: ErpTaxIdentity(
          taxNumber: '310000000000003',
        ),
        addresses: [
          ErpAddress(
            role: ErpAddressRole.billing,
            line1: 'Riyadh',
            city: 'Riyadh',
            countryCode: 'SA',
          ),
        ],
      ),
      billingAddress: const ErpAddress(
        role: ErpAddressRole.billing,
        line1: 'Customer Billing Address',
        city: 'Riyadh',
        countryCode: 'SA',
      ),
      shippingAddress: _nullOptionals
          ? null
          : const ErpAddress(
              role: ErpAddressRole.shipping,
              line1: 'Warehouse Delivery Gate',
              city: 'Riyadh',
              countryCode: 'SA',
            ),
      documentCurrency: currency,
      baseCurrency: baseCurrency,
      exchangeRate: exchangeRate,
      references: const [
        ErpDocumentReference(
          type: 'delivery',
          number: 'DEL-2026-0091',
        ),
      ],
      lineItems: lines,
      printMetadata: ErpPrintMetadata(
        copyLabel: _reprint ? 'Reprint' : 'Original',
        copyNumber: _reprint ? 2 : 1,
      ),
      notes: _nullOptionals
          ? null
          : 'Long/null optional sections can be toggled by scenario data.',
      terms: _nullOptionals
          ? null
          : 'Payment due within 30 days.',
    );

    final baseRequest = GeniusErpPackTransactionRequest(
      document: context,
      taxMode: _inclusiveTax
          ? GeniusErpPackTaxMode.inclusive
          : GeniusErpPackTaxMode.exclusive,
      paymentTerms: _nullOptionals ? null : 'Net 30',
      expectedDelivery:
          _nullOptionals ? null : DateTime(2026, 9, 15),
      warehouse: _nullOptionals ? null : 'MAIN',
      site: _nullOptionals ? null : 'Riyadh',
      signatures: const [
        GeniusErpSignatureSpec(
          title: 'Prepared By',
          titleAr: 'أعده',
        ),
        GeniusErpSignatureSpec(
          title: 'Approved By',
          titleAr: 'اعتمده',
        ),
      ],
    );

    if (!paid) return baseRequest;
    final calculated =
        const GeniusErpPackCalculationService().calculate(baseRequest);
    return baseRequest.copyWith(
      paidAmount: calculated.grandTotal,
    );
  }

  List<GeniusSalesLedgerEntry> _salesEntries(int count) =>
      List.generate(
        count,
        (index) => GeniusSalesLedgerEntry(
          date: DateTime(2026, 9, 1 + (index % 4)),
          documentNumber: 'INV-${index + 1}',
          customerId: 'C${index % 5}',
          customerName: 'Customer ${index % 5}',
          customerNameAr: 'عميل ${index % 5}',
          itemId: 'I${index % 9}',
          itemName: 'Item ${index % 9}',
          itemNameAr: 'صنف ${index % 9}',
          quantity: ((index % 4) + 1).toDouble(),
          netAmount: ErpMoney.fromAmount(
            100 + index,
            currency: ErpCurrency.sar,
          ),
          taxAmount: ErpMoney.fromAmount(
            15 + index * 0.15,
            currency: ErpCurrency.sar,
          ),
          salespersonId: 'S${index % 3}',
          salespersonName: 'Salesperson ${index % 3}',
          salespersonNameAr: 'مندوب ${index % 3}',
          commissionRatePercent: 5,
        ),
      );

  List<GeniusSalesBackorderLine> _backorders(int count) =>
      List.generate(
        count,
        (index) => GeniusSalesBackorderLine(
          orderNumber: 'SO-${index + 1}',
          customerName: 'Customer ${index % 4}',
          customerNameAr: 'عميل ${index % 4}',
          itemCode: 'SKU-${index + 1}',
          description: 'Product ${index + 1}',
          descriptionAr: 'منتج ${index + 1}',
          orderedQuantity: 10,
          fulfilledQuantity: index % 2 == 0 ? 4 : 8,
          expectedDelivery: DateTime(2026, 9, 20),
          batch: 'B-${index % 3}',
          serials: ['SN-${index + 1000}'],
        ),
      );

  List<GeniusSalesPriceEntry> _prices(int count) =>
      List.generate(
        count,
        (index) => GeniusSalesPriceEntry(
          itemCode: 'SKU-${index + 1}',
          description: 'Product ${index + 1}',
          descriptionAr: 'منتج ${index + 1}',
          price: ErpMoney.fromAmount(
            20 + index,
            currency: ErpCurrency.sar,
          ),
          validFrom: DateTime(2026, 9, 1),
          validTo: DateTime(2026, 12, 31),
        ),
      );

  List<GeniusErpOpenItem> _openItems(int count) =>
      List.generate(
        count,
        (index) => GeniusErpOpenItem(
          partyId: 'C${index % 4}',
          partyName: 'Customer ${index % 4}',
          documentNumber: 'INV-${index + 1}',
          issueDate: DateTime(2026, 5, 1),
          dueDate: DateTime(2026, 6, 1 + (index % 28)),
          amount: ErpMoney.fromAmount(
            100 + index,
            currency: ErpCurrency.sar,
          ),
        ),
      );

  GeniusErpPackReportData _fulfillmentReport(
    int count, {
    required String title,
    required String titleAr,
  }) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        columns: const [
          GeniusErpPackReportColumn(
            id: 'item',
            title: 'Item',
            titleAr: 'الصنف',
          ),
          GeniusErpPackReportColumn(
            id: 'description',
            title: 'Description',
            titleAr: 'الوصف',
            flexFactor: 3,
          ),
          GeniusErpPackReportColumn(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
            kind: GeniusErpPackReportColumnKind.number,
          ),
          GeniusErpPackReportColumn(
            id: 'batch',
            title: 'Batch',
            titleAr: 'الدفعة',
          ),
          GeniusErpPackReportColumn(
            id: 'serial',
            title: 'Serial',
            titleAr: 'التسلسلي',
          ),
        ],
        rows: [
          for (var index = 0; index < count; index++)
            GeniusErpPackReportRow(
              cells: {
                'item': 'SKU-${index + 1}',
                'description': 'Product ${index + 1}',
                'qty': (index % 4) + 1,
                'batch': 'B-${index % 3}',
                'serial': 'SN-${1000 + index}',
              },
            ),
        ],
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
                    'Sprint S12 — Sales ERP Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<_S12Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Document / Report',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S12Scenario.values)
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
                        label: const Text('Bilingual values'),
                        selected: _bilingual,
                        onSelected: (value) {
                          _bilingual = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Tax inclusive'),
                        selected: _inclusiveTax,
                        onSelected: (value) {
                          _inclusiveTax = value;
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
                      FilterChip(
                        label: const Text('Reprint metadata'),
                        selected: _reprint,
                        onSelected: (value) {
                          _reprint = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Null optionals'),
                        selected: _nullOptionals,
                        onSelected: (value) {
                          _nullOptionals = value;
                          _refresh();
                        },
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's12_sales_erp_pack.pdf',
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
