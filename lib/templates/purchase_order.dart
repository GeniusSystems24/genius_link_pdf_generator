
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../src/presentation/document/components/components.dart';
import '../src/core/directionality.dart';
import '../src/core/pdf_config.dart';
import '../src/domain/erp/erp.dart';
import '../src/domain/financial/financial.dart';
import '../src/presentation/document/families/erp/erp_families.dart';
import '../src/core/compatibility/models/pdf_result.dart';
import 'erp_legacy_shared.dart';

import '../src/presentation/document/packs/purchasing/documents.dart';
/// Purchase order line item.
class PurchaseOrderItem {
  const PurchaseOrderItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.descriptionAr,
    this.unit,
    this.productCode,
    this.discount = 0,
    this.deliveryDate,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final String? productCode;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;
  final DateTime? deliveryDate;

  /// Legacy compatibility getter.
  double get lineTotal => (quantity * unitPrice) - discount;
}

/// Supplier/Vendor information.
class PurchaseOrderVendor {
  const PurchaseOrderVendor({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.vatNumber,
    this.phone,
    this.email,
    this.contactPerson,
    this.vendorCode,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? vatNumber;
  final String? phone;
  final String? email;
  final String? contactPerson;
  final String? vendorCode;
}

/// Shipping information.
class ShippingInfo {
  const ShippingInfo({
    required this.address,
    this.addressAr,
    this.contactPerson,
    this.phone,
    this.instructions,
    this.instructionsAr,
  });

  final String address;
  final String? addressAr;
  final String? contactPerson;
  final String? phone;
  final String? instructions;
  final String? instructionsAr;
}

/// Purchase order data model.
class PurchaseOrderData {
  const PurchaseOrderData({
    required this.poNumber,
    required this.poDate,
    required this.items,
    this.expectedDeliveryDate,
    this.quotationRef,
    this.paymentTerms,
    this.paymentTermsAr,
    this.shippingInfo,
    this.taxes = const [],
    this.notes,
    this.notesAr,
    this.termsAndConditions,
    this.termsAndConditionsAr,
    this.currency = 'SAR',
    this.status = 'Draft',
  });

  final String poNumber;
  final DateTime poDate;
  final DateTime? expectedDeliveryDate;
  final String? quotationRef;
  final String? paymentTerms;
  final String? paymentTermsAr;
  final ShippingInfo? shippingInfo;
  final List<PurchaseOrderItem> items;
  final List<({String name, String? nameAr, double rate})> taxes;
  final String? notes;
  final String? notesAr;
  final String? termsAndConditions;
  final String? termsAndConditionsAr;
  final String currency;
  final String status;

  ErpCalculationResult get _calculation =>
      PurchaseOrderErpAdapter.calculateData(this);

  double get subtotal =>
      (_calculation.subtotal - _calculation.lineDiscountTotal)
          .toDouble();
  double get totalTax => _calculation.taxTotal.toDouble();
  double get grandTotal => _calculation.grandTotal.toDouble();
}

/// S09 adapter from PurchaseOrder legacy models into the S06 domain.
class PurchaseOrderErpAdapter
    extends GeniusErpDocumentAdapter<PurchaseOrderData> {
  const PurchaseOrderErpAdapter({
    required this.company,
    required this.vendor,
  });

  final GeniusPdfCompanyInfo company;
  final PurchaseOrderVendor vendor;

  static ErpCurrency currencyOf(PurchaseOrderData source) =>
      GeniusErpLegacyCompatibility.currency(source.currency);

  static List<ErpLineItem> lineItemsOf(PurchaseOrderData source) {
    final currency = currencyOf(source);

    return source.items
        .map(
          (item) => ErpLineItem(
            id: item.itemNumber.toString(),
            description: item.description,
            descriptionAr: item.descriptionAr,
            sku: item.productCode,
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
            metadata: {
              if (item.deliveryDate != null)
                'deliveryDate': item.deliveryDate,
            },
          ),
        )
        .toList(growable: false);
  }

  static List<ErpTaxLine> taxesOf(PurchaseOrderData source) =>
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

  static ErpCalculationResult calculateData(
    PurchaseOrderData source,
  ) {
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
  ErpDocumentContext adapt(PurchaseOrderData source) {
    final vendorParty = GeniusErpLegacyCompatibility.party(
      id: vendor.vendorCode,
      name: vendor.name,
      nameAr: vendor.nameAr,
      registrationNumber: vendor.vendorCode,
      taxNumber: vendor.vatNumber,
      address: vendor.address,
      addressAr: vendor.addressAr,
      phone: vendor.phone,
      email: vendor.email,
      contactName: vendor.contactPerson,
      addressRole: ErpAddressRole.billing,
    );

    final shipping = source.shippingInfo;
    final shippingAddress = shipping == null
        ? null
        : GeniusErpLegacyCompatibility.address(
            line1: shipping.address,
            line1Ar: shipping.addressAr,
            attentionTo: shipping.contactPerson,
            role: ErpAddressRole.shipping,
          );

    return ErpDocumentContext(
      organization:
          GeniusErpLegacyCompatibility.organization(company),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.purchaseOrder,
        number: source.poNumber,
        issueDate: source.poDate,
        status: _documentStatus(source.status),
      ),
      recipient: vendorParty,
      billingAddress:
          vendorParty.addressFor(ErpAddressRole.billing),
      shippingAddress: shippingAddress,
      documentCurrency: currencyOf(source),
      references: source.quotationRef == null
          ? const []
          : [
              ErpDocumentReference(
                type: 'Quotation',
                number: source.quotationRef!,
              ),
            ],
      lineItems: lineItemsOf(source),
      notes: source.notes,
      terms: source.termsAndConditions,
      metadata: {
        if (source.expectedDeliveryDate != null)
          'expectedDeliveryDate': source.expectedDeliveryDate,
        if (source.paymentTerms != null)
          'paymentTerms': source.paymentTerms,
        if (source.paymentTermsAr != null)
          'paymentTermsAr': source.paymentTermsAr,
        if (source.notesAr != null) 'notesAr': source.notesAr,
        if (source.termsAndConditionsAr != null)
          'termsAr': source.termsAndConditionsAr,
        if (shipping?.phone != null)
          'shippingPhone': shipping!.phone,
        if (shipping?.instructions != null)
          'shippingInstructions': shipping!.instructions,
        if (shipping?.instructionsAr != null)
          'shippingInstructionsAr': shipping!.instructionsAr,
      },
    );
  }

  @override
  ErpCalculationRequest calculationRequest(
    PurchaseOrderData source,
    ErpDocumentContext document,
  ) =>
      ErpCalculationRequest.fromContext(
        document,
        documentTaxes: taxesOf(source),
      );

  static ErpDocumentStatus _documentStatus(String status) {
    return switch (status.trim().toLowerCase()) {
      'approved' => ErpDocumentStatus.approved,
      'sent' || 'received' => ErpDocumentStatus.issued,
      'cancelled' || 'canceled' => ErpDocumentStatus.cancelled,
      _ => ErpDocumentStatus.draft,
    };
  }
}

/// Purchase order template migrated to the S08 Transaction family.
///
/// The constructor/public fields remain source-compatible with the legacy
/// template.
class PurchaseOrderTemplate extends GeniusPurchasingTransactionDocument {
  PurchaseOrderTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.vendor,
    required this.purchaseOrder,
    this.boldFont,
    this.showShippingInfo = true,
    this.showTerms = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final PurchaseOrderVendor vendor;
  final PurchaseOrderData purchaseOrder;
  final PdfFont? boldFont;
  final bool showShippingInfo;
  final bool showTerms;

  PurchaseOrderErpAdapter get _adapter =>
      PurchaseOrderErpAdapter(
        company: company,
        vendor: vendor,
      );

  ErpDocumentContext get erpContext =>
      _adapter.adapt(purchaseOrder);

  ErpCalculationResult get erpCalculation {
    final context = erpContext;
    return const ErpCalculationService().calculate(
      _adapter.calculationRequest(
        purchaseOrder,
        context,
      ),
    );
  }

  @override
  GeniusErpFamilyPlan createFamilyPlan() {
    final context = erpContext;
    final calculation = const ErpCalculationService().calculate(
      _adapter.calculationRequest(
        purchaseOrder,
        context,
      ),
    );

    final shipping = purchaseOrder.shippingInfo;
    final shippingInstructions = shipping == null
        ? null
        : config.isRTL
            ? (shipping.instructionsAr ?? shipping.instructions)
            : (shipping.instructions ?? shipping.instructionsAr);
    final shippingNotes = shipping == null
        ? null
        : [
            if (shipping.contactPerson != null)
              '${config.isRTL ? 'جهة الاتصال' : 'Contact'}: '
                  '${shipping.contactPerson}',
            if (shipping.phone != null)
              '${config.isRTL ? 'الهاتف' : 'Phone'}: ${shipping.phone}',
            if (shippingInstructions != null &&
                shippingInstructions.isNotEmpty)
              '${config.isRTL ? 'تعليمات' : 'Instructions'}: '
                  '$shippingInstructions',
          ].join('\n');

    return GeniusErpFamilyPlan(
      document: context,
      calculation: calculation,
      company: company,
      title: 'Purchase Order',
      titleAr: 'أمر شراء',
      primaryParty: context.recipient,
      primaryPartyTitle: 'Vendor',
      primaryPartyTitleAr: 'المورد',
      addresses: [
        GeniusErpAddressSection(
          title: 'Vendor Address',
          titleAr: 'عنوان المورد',
          address: context.billingAddress,
        ),
        if (showShippingInfo)
          GeniusErpAddressSection(
            title: 'Shipping Address',
            titleAr: 'عنوان الشحن',
            address: context.shippingAddress,
          ),
      ],
      detailFields: [
        if (purchaseOrder.expectedDeliveryDate != null)
          GeniusErpDetailField(
            label: 'Expected Delivery',
            labelAr: 'التسليم المتوقع',
            value: config.formatter.formatDate(
              purchaseOrder.expectedDeliveryDate,
            ),
            valueKind: GeniusPdfValueKind.date,
          ),
        if (purchaseOrder.paymentTerms != null)
          GeniusErpDetailField(
            label: 'Payment Terms',
            labelAr: 'شروط الدفع',
            value: config.isRTL
                ? (purchaseOrder.paymentTermsAr ??
                    purchaseOrder.paymentTerms!)
                : purchaseOrder.paymentTerms!,
          ),
        GeniusErpDetailField(
          label: 'Status',
          labelAr: 'الحالة',
          value: purchaseOrder.status,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      ],
      notes: [
        if (purchaseOrder.notes != null)
          purchaseOrder.notes!,
        if (showShippingInfo &&
            shippingNotes != null &&
            shippingNotes.isNotEmpty)
          shippingNotes,
      ].join('\n\n'),
      notesAr: purchaseOrder.notesAr,
      terms:
          showTerms ? purchaseOrder.termsAndConditions : null,
      termsAr: showTerms
          ? purchaseOrder.termsAndConditionsAr
          : null,
      signatures: const [
        GeniusErpSignatureSpec(
          title: 'Prepared By',
          titleAr: 'أعده',
        ),
        GeniusErpSignatureSpec(
          title: 'Approved By',
          titleAr: 'اعتمده',
        ),
        GeniusErpSignatureSpec(
          title: 'Received By Vendor',
          titleAr: 'استلمه المورد',
        ),
      ],
      slotPolicies: const {
        GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
          estimatedHeight: 140,
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
        fileName: 'po_${purchaseOrder.poNumber}.pdf',
      );
    } catch (error, stackTrace) {
      return GeniusPdfFailure.fromException(
        error,
        stackTrace,
      );
    }
  }
}
