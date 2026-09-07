
import 'dart:typed_data';

import '../src/presentation/document/components/components.dart';
import '../src/core/directionality.dart';
import '../src/core/pdf_config.dart';
import '../src/domain/erp/erp.dart';
import '../src/domain/financial/financial.dart';
import '../src/presentation/document/families/erp/erp_families.dart';
import '../src/domain/models/pdf_image.dart';
import '../src/core/compatibility/models/pdf_result.dart';
import 'erp_legacy_shared.dart';

import '../src/presentation/document/packs/sales/documents.dart';
/// Invoice line item data.
class InvoiceLineItem {
  const InvoiceLineItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.unit,
    this.discount = 0,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;

  /// Legacy compatibility getter.
  double get lineTotal => (quantity * unitPrice) - discount;
}

/// Tax information for the invoice.
class InvoiceTax {
  const InvoiceTax({
    required this.name,
    required this.rate,
    this.nameAr,
  });

  final String name;
  final String? nameAr;
  final double rate;

  /// Legacy compatibility helper retained for callers.
  double calculate(double amount) => amount * (rate / 100);
}

/// Invoice data model.
///
/// Aggregate totals now delegate to S06 via [TaxInvoiceErpAdapter].
class InvoiceData {
  const InvoiceData({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.items,
    this.poNumber,
    this.paymentTerms,
    this.paymentTermsAr,
    this.dueDate,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.currency = 'SAR',
  });

  final String invoiceNumber;
  final DateTime invoiceDate;
  final String? poNumber;
  final String? paymentTerms;
  final String? paymentTermsAr;
  final DateTime? dueDate;
  final List<InvoiceLineItem> items;
  final List<InvoiceTax> taxes;
  final String? notes;
  final String? notesAr;
  final String currency;

  ErpCalculationResult get _calculation =>
      TaxInvoiceErpAdapter.calculateData(this);

  /// Legacy subtotal is net of line discounts.
  double get subtotal =>
      (_calculation.subtotal - _calculation.lineDiscountTotal)
          .toDouble();

  double get totalTax => _calculation.taxTotal.toDouble();
  double get grandTotal => _calculation.grandTotal.toDouble();
}

/// S09 adapter from legacy Tax Invoice data to S06.
class TaxInvoiceErpAdapter
    extends GeniusErpDocumentAdapter<InvoiceData> {
  const TaxInvoiceErpAdapter({
    required this.company,
    required this.customer,
  });

  final GeniusPdfCompanyInfo company;
  final InvoiceCustomer customer;

  static ErpCurrency currencyOf(InvoiceData source) =>
      GeniusErpLegacyCompatibility.currency(source.currency);

  static List<ErpLineItem> lineItemsOf(InvoiceData source) {
    final currency = currencyOf(source);

    return source.items
        .map(
          (item) => ErpLineItem(
            id: item.itemNumber.toString(),
            description: item.description,
            descriptionAr: item.descriptionAr,
            quantity: ErpQuantity(
              value: item.quantity,
              unit: ErpUnit(
                code: item.unit ?? 'EA',
                name: item.unit ?? 'Each',
                precision: 3,
              ),
            ),
            unitPrice: ErpMoney.fromAmount(
              item.unitPrice,
              currency: currency,
            ),
            discounts: item.discount == 0
                ? const []
                : [
                    ErpDiscount.fixed(
                      amount: ErpMoney.fromAmount(
                        item.discount,
                        currency: currency,
                      ),
                    ),
                  ],
          ),
        )
        .toList(growable: false);
  }

  static List<ErpTaxLine> taxesOf(InvoiceData source) =>
      source.taxes
          .map(
            (tax) => ErpTaxLine(
              code: tax.name,
              name: tax.name,
              nameAr: tax.nameAr,
              ratePercent: tax.rate,
            ),
          )
          .toList(growable: false);

  static ErpCalculationResult calculateData(InvoiceData source) {
    return const ErpCalculationService().calculate(
      ErpCalculationRequest(
        currency:
            GeniusErpLegacyCompatibility.currency(source.currency),
        lineItems: lineItemsOf(source),
        documentTaxes: taxesOf(source),
      ),
    );
  }

  @override
  ErpDocumentContext adapt(InvoiceData source) {
    final party = GeniusErpLegacyCompatibility.party(
      id: customer.accountNumber,
      name: customer.name,
      nameAr: customer.nameAr,
      registrationNumber: customer.accountNumber,
      taxNumber: customer.vatNumber,
      address: customer.address,
      addressAr: customer.addressAr,
      phone: customer.phone,
      email: customer.email,
      addressRole: ErpAddressRole.billing,
    );

    return ErpDocumentContext(
      organization:
          GeniusErpLegacyCompatibility.organization(company),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.invoice,
        number: source.invoiceNumber,
        issueDate: source.invoiceDate,
        status: ErpDocumentStatus.issued,
      ),
      recipient: party,
      billingAddress:
          party.addressFor(ErpAddressRole.billing),
      documentCurrency: currencyOf(source),
      references: source.poNumber == null
          ? const []
          : [
              ErpDocumentReference(
                type: 'Purchase Order',
                number: source.poNumber!,
              ),
            ],
      lineItems: lineItemsOf(source),
      notes: source.notes,
      metadata: {
        if (source.paymentTerms != null)
          'paymentTerms': source.paymentTerms,
        if (source.paymentTermsAr != null)
          'paymentTermsAr': source.paymentTermsAr,
        if (source.dueDate != null)
          'dueDate': source.dueDate,
        if (source.notesAr != null)
          'notesAr': source.notesAr,
      },
    );
  }

  @override
  ErpCalculationRequest calculationRequest(
    InvoiceData source,
    ErpDocumentContext document,
  ) =>
      ErpCalculationRequest.fromContext(
        document,
        documentTaxes: taxesOf(source),
      );
}

/// Customer information for the invoice.
class InvoiceCustomer {
  const InvoiceCustomer({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.vatNumber,
    this.phone,
    this.email,
    this.accountNumber,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? vatNumber;
  final String? phone;
  final String? email;
  final String? accountNumber;
}

/// Tax invoice migrated to the S08 Transaction family.
///
/// Constructor and public legacy models are preserved while header/identity,
/// party, item grid, tax summary, amount-in-words, notes, QR and signature are
/// composed by the shared S08/S07 layers.
class TaxInvoiceTemplate extends GeniusSalesTransactionDocument {
  TaxInvoiceTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.customer,
    required this.invoice,
    this.qrCode,
    this.showQRCode = true,
    this.showSignature = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final InvoiceCustomer customer;
  final InvoiceData invoice;
  final GeniusPdfImage? qrCode;
  final bool showQRCode;
  final bool showSignature;

  TaxInvoiceErpAdapter get _adapter =>
      TaxInvoiceErpAdapter(
        company: company,
        customer: customer,
      );

  ErpDocumentContext get erpContext =>
      _adapter.adapt(invoice);

  ErpCalculationResult get erpCalculation {
    final context = erpContext;
    return const ErpCalculationService().calculate(
      _adapter.calculationRequest(
        invoice,
        context,
      ),
    );
  }

  @override
  GeniusErpFamilyPlan createFamilyPlan() {
    final context = erpContext;
    final calculation = const ErpCalculationService().calculate(
      _adapter.calculationRequest(
        invoice,
        context,
      ),
    );

    return GeniusErpFamilyPlan(
      document: context,
      calculation: calculation,
      company: company,
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      primaryParty: context.recipient,
      primaryPartyTitle: 'To',
      primaryPartyTitleAr: 'إلى',
      addresses: [
        GeniusErpAddressSection(
          title: 'Billing Address',
          titleAr: 'عنوان الفوترة',
          address: context.billingAddress,
        ),
      ],
      detailFields: [
        if (invoice.dueDate != null)
          GeniusErpDetailField(
            label: 'Due Date',
            labelAr: 'تاريخ الاستحقاق',
            value: config.formatter.formatDate(invoice.dueDate),
            valueKind: GeniusPdfValueKind.date,
          ),
        if (invoice.paymentTerms != null)
          GeniusErpDetailField(
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (invoice.paymentTermsAr ??
                    invoice.paymentTerms!)
                : invoice.paymentTerms!,
          ),
        if (invoice.poNumber != null)
          GeniusErpDetailField(
            label: 'PO No',
            labelAr: 'رقم الطلب',
            value: invoice.poNumber!,
            valueKind: GeniusPdfValueKind.documentNumber,
          ),
      ],
      notes: invoice.notes,
      notesAr: invoice.notesAr,
      amountInWords:
          GeniusErpLegacyAmountInWords.english(
        calculation.grandTotal,
      ),
      amountInWordsAr:
          GeniusErpLegacyAmountInWords.arabic(
        calculation.grandTotal,
      ),
      code: showQRCode
          ? GeniusErpCodeSpec(
              image: qrCode,
              data: qrCode == null
                  ? 'https://localhost:443/invoice/'
                      '${invoice.invoiceNumber}'
                  : null,
              caption: 'ID: ${invoice.invoiceNumber}',
              captionAr: 'ID: ${invoice.invoiceNumber}',
            )
          : null,
      signatures: showSignature
          ? const [
              GeniusErpSignatureSpec(
                title: 'Authorized Signature',
                titleAr: 'التوقيع المعتمد',
              ),
            ]
          : const [],
      slotPolicies: const {
        GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
          estimatedHeight: 140,
        ),
        GeniusErpFamilySlot.summary: GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
          estimatedHeight: 150,
        ),
        GeniusErpFamilySlot.approvalsSignatures:
            GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
          estimatedHeight: 90,
        ),
      },
    );
  }

  Future<GeniusPdfResult> generateResult({
    bool validateFinancials = true,
    GeniusFinancialValidationContext? validationContext,
  }) async {
    if (validateFinancials) {
      try {
        erpCalculation;
      } catch (error, stackTrace) {
        return GeniusPdfFailure.fromException(
          error,
          stackTrace,
        );
      }
    }

    try {
      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(generate()),
        fileName: 'invoice_${invoice.invoiceNumber}.pdf',
      );
    } catch (error, stackTrace) {
      return GeniusPdfFailure.fromException(
        error,
        stackTrace,
      );
    }
  }
}
