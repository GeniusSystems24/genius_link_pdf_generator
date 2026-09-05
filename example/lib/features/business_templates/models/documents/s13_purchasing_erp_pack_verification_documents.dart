// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S13PurchasingErpPackVerificationPage.
enum S13PurchasingErpPackScenario {
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

/// Executes one focused S13 verification scenario.
class S13PurchasingErpPackRunner {
  S13PurchasingErpPackRunner({
    required GeniusPdfConfig baseConfig,
    required S13PurchasingErpPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S13PurchasingErpPackScenario _scenario;
bool _rtl = false;
  final bool _multiCurrency = false;
  final int _lineCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _name(S13PurchasingErpPackScenario scenario) => switch (scenario) {
        S13PurchasingErpPackScenario.requisition => 'Purchase Requisition',
        S13PurchasingErpPackScenario.rfq => 'Request for Quotation',
        S13PurchasingErpPackScenario.supplierQuotation => 'Supplier Quotation',
        S13PurchasingErpPackScenario.comparison => 'Quotation Comparison',
        S13PurchasingErpPackScenario.purchaseOrder => 'Purchase Order',
        S13PurchasingErpPackScenario.grn => 'Goods Receipt Note',
        S13PurchasingErpPackScenario.purchaseInvoice => 'Purchase Invoice',
        S13PurchasingErpPackScenario.purchaseDebit => 'Purchase Debit Note',
        S13PurchasingErpPackScenario.purchaseCredit => 'Purchase Credit Note',
        S13PurchasingErpPackScenario.supplierReturn => 'Supplier Return',
        S13PurchasingErpPackScenario.supplierStatement => 'Supplier Statement',
        S13PurchasingErpPackScenario.supplierAging => 'Supplier Aging',
        S13PurchasingErpPackScenario.purchaseRegister => 'Purchase Register',
        S13PurchasingErpPackScenario.purchaseAnalysis => 'Purchase Analysis',
        S13PurchasingErpPackScenario.outstandingPo => 'Outstanding Purchase Orders',
      };

  String get _expected =>
      'Expected Result: ${_name(_scenario)} uses the S13 public API and '
      'shared family/page-flow. ${_rtl ? 'RTL vendor captions' : 'LTR layout'}; '
      '${_multiCurrency ? 'USD document with SAR base conversion; ' : ''}'
      'mixed SKU codes remain LTR. 50/500 rows must paginate without clipping.';

  Future<Uint8List> generate() async {
    final config = _config;
    const analytics = GeniusPurchasingAnalytics();
    final entries = _entries(_lineCount);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S13PurchasingErpPackScenario.requisition:
        document = GeniusPurchaseRequisitionDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S13PurchasingErpPackScenario.rfq:
        document = GeniusRequestForQuotationDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S13PurchasingErpPackScenario.supplierQuotation:
        document = GeniusSupplierQuotationDocument(
          config,
          request: _request(_lineCount),
        );
        break;
      case S13PurchasingErpPackScenario.comparison:
        document = GeniusQuotationComparisonDocument(
          config,
          report: analytics.quotationComparison(
            _supplierQuotes(_lineCount),
          ),
        );
        break;
      case S13PurchasingErpPackScenario.purchaseOrder:
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
      case S13PurchasingErpPackScenario.grn:
        document = GeniusGoodsReceiptNoteDocument(
          config,
          report: analytics.goodsReceipt(entries),
        );
        break;
      case S13PurchasingErpPackScenario.purchaseInvoice:
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
      case S13PurchasingErpPackScenario.purchaseDebit:
        document = GeniusPurchaseAdjustmentDocument(
          config,
          request: _request(_lineCount),
          kind: GeniusPurchaseAdjustmentKind.debit,
        );
        break;
      case S13PurchasingErpPackScenario.purchaseCredit:
        document = GeniusPurchaseAdjustmentDocument(
          config,
          request: _request(_lineCount, negative: true),
          kind: GeniusPurchaseAdjustmentKind.credit,
        );
        break;
      case S13PurchasingErpPackScenario.supplierReturn:
        document = GeniusSupplierReturnDocument(
          config,
          request: _request(_lineCount, negative: true),
        );
        break;
      case S13PurchasingErpPackScenario.supplierStatement:
        document = GeniusSupplierStatementDocument(
          config,
          report: analytics.supplierStatement(
            _openItems(_lineCount),
          ),
        );
        break;
      case S13PurchasingErpPackScenario.supplierAging:
        document = GeniusSupplierAgingDocument(
          config,
          report: analytics.supplierAging(
            _openItems(_lineCount),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case S13PurchasingErpPackScenario.purchaseRegister:
        document = GeniusPurchaseRegisterDocument(
          config,
          report: analytics.purchaseRegister(entries),
        );
        break;
      case S13PurchasingErpPackScenario.purchaseAnalysis:
        document = GeniusPurchaseAnalysisReport(
          config,
          report: analytics.purchaseAnalysis(entries),
        );
        break;
      case S13PurchasingErpPackScenario.outstandingPo:
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
}


Future<Uint8List> buildS13RequisitionVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.requisition,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13RfqVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.rfq,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13SupplierQuotationVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierQuotation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13ComparisonVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.comparison,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13GrnVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.grn,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseInvoiceVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseInvoice,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseDebitVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseDebit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseCreditVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseCredit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13SupplierReturnVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierReturn,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13SupplierStatementVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierStatement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13SupplierAgingVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.supplierAging,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13PurchaseAnalysisVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.purchaseAnalysis,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS13OutstandingPoVerificationPdf(GeniusPdfConfig config) {
  final runner = S13PurchasingErpPackRunner(
    baseConfig: config,
    scenario: S13PurchasingErpPackScenario.outstandingPo,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
