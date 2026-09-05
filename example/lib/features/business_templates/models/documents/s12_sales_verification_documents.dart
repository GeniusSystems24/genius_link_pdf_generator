// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S12SalesErpPackVerificationPage.
enum S12SalesErpPackScenario {
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

/// Executes one focused S12 verification scenario.
class S12SalesErpPackRunner {
  S12SalesErpPackRunner({
    required GeniusPdfConfig baseConfig,
    required S12SalesErpPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S12SalesErpPackScenario _scenario;
bool _rtl = false;
  final bool _bilingual = false;
  final bool _inclusiveTax = false;
  final bool _multiCurrency = false;
  final bool _reprint = false;
  final bool _nullOptionals = false;
  final int _lineCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _name(S12SalesErpPackScenario scenario) => switch (scenario) {
        S12SalesErpPackScenario.salesOrder => 'Sales Order',
        S12SalesErpPackScenario.proforma => 'Proforma Invoice',
        S12SalesErpPackScenario.pos => 'Simplified / POS Invoice',
        S12SalesErpPackScenario.debitNote => 'Debit Note',
        S12SalesErpPackScenario.salesReturn => 'Sales Return',
        S12SalesErpPackScenario.customerReceipt => 'Customer Receipt',
        S12SalesErpPackScenario.picking => 'Picking List',
        S12SalesErpPackScenario.packing => 'Packing List',
        S12SalesErpPackScenario.backorder => 'Backorder',
        S12SalesErpPackScenario.customerAging => 'Customer Aging',
        S12SalesErpPackScenario.salesRegister => 'Sales Register',
        S12SalesErpPackScenario.byCustomer => 'Sales by Customer',
        S12SalesErpPackScenario.byItem => 'Sales by Item',
        S12SalesErpPackScenario.bySalesperson => 'Sales by Salesperson',
        S12SalesErpPackScenario.priceList => 'Price List',
        S12SalesErpPackScenario.commission => 'Commission Report',
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

  Future<Uint8List> generate() async {
    final config = _config;
    final analytics = const GeniusSalesAnalytics();
    final entries = _salesEntries(_lineCount);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S12SalesErpPackScenario.salesOrder:
        document = GeniusSalesOrderDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S12SalesErpPackScenario.proforma:
        document = GeniusProformaInvoiceDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S12SalesErpPackScenario.pos:
        document = GeniusPosInvoiceDocument(
          config,
          request: _request(_lineCount),
          printProfile:
              GeniusPdfPrintProfile.thermal80().toFamilyProfile(),
        );
        break;
      case S12SalesErpPackScenario.debitNote:
        document = GeniusSalesDebitNoteDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S12SalesErpPackScenario.salesReturn:
        document = GeniusSalesReturnDocument(
          config,
          request: _request(_lineCount, negative: true),
        );
        break;
      case S12SalesErpPackScenario.customerReceipt:
        document = GeniusCustomerReceiptDocument(
          config,
          request: _request(1, paid: true),
        );
        break;
      case S12SalesErpPackScenario.picking:
        document = GeniusPickingListDocument(
          config,
          report: _fulfillmentReport(
            _lineCount,
            title: 'Picking List',
            titleAr: 'قائمة التجهيز',
          ),
        );
        break;
      case S12SalesErpPackScenario.packing:
        document = GeniusPackingListDocument(
          config,
          report: _fulfillmentReport(
            _lineCount,
            title: 'Packing List',
            titleAr: 'قائمة التعبئة',
          ),
        );
        break;
      case S12SalesErpPackScenario.backorder:
        document = GeniusBackorderDocument(
          config,
          report: analytics.backorders(_backorders(_lineCount)),
        );
        break;
      case S12SalesErpPackScenario.customerAging:
        document = GeniusCustomerAgingDocument(
          config,
          report: analytics.customerAging(
            _openItems(_lineCount),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case S12SalesErpPackScenario.salesRegister:
        document = GeniusSalesRegisterDocument(
          config,
          report: analytics.salesRegister(entries),
        );
        break;
      case S12SalesErpPackScenario.byCustomer:
        document = GeniusSalesByCustomerReport(
          config,
          report: analytics.salesByCustomer(entries),
        );
        break;
      case S12SalesErpPackScenario.byItem:
        document = GeniusSalesByItemReport(
          config,
          report: analytics.salesByItem(entries),
        );
        break;
      case S12SalesErpPackScenario.bySalesperson:
        document = GeniusSalesBySalespersonReport(
          config,
          report: analytics.salesBySalesperson(entries),
        );
        break;
      case S12SalesErpPackScenario.priceList:
        document = GeniusPriceListDocument(
          config,
          report: analytics.priceList(_prices(_lineCount)),
        );
        break;
      case S12SalesErpPackScenario.commission:
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
}


Future<Uint8List> buildS12SalesOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.salesOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12ProformaVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.proforma,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12PosVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.pos,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12DebitNoteVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.debitNote,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12SalesReturnVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.salesReturn,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12CustomerReceiptVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.customerReceipt,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12PickingVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.picking,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12PackingVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.packing,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12BackorderVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.backorder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12CustomerAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.customerAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12SalesRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.salesRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12ByCustomerVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.byCustomer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12ByItemVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.byItem,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12BySalespersonVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.bySalesperson,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12PriceListVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.priceList,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS12CommissionVerificationPdf(GeniusPdfConfig config) {
  final runner = S12SalesErpPackRunner(
    baseConfig: config,
    scenario: S12SalesErpPackScenario.commission,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
