
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../src/components/components.dart';
import '../src/core/directionality.dart';
import '../src/core/pdf_config.dart';
import '../src/domain/erp/erp.dart';
import '../src/domain/financial/financial.dart';
import '../src/families/erp/erp_families.dart';
import '../src/models/pdf_result.dart';
import 'erp_legacy_shared.dart';

import '../src/packs/sales/sales_documents.dart';
/// Quotation item model.
///
/// Kept for source compatibility. S09 adapts this model into [ErpLineItem]
/// before rendering/calculation.
class QuotationItem {
  const QuotationItem({
    required this.itemNumber,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.unit,
    this.descriptionAr,
    this.discount = 0,
    this.tax = 0,
  });

  final int itemNumber;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discount;
  final double tax;

  /// Legacy compatibility getter.
  double get subtotal => quantity * unitPrice;

  /// Legacy compatibility getter. New template rendering uses S06.
  double get total => subtotal - discount + tax;

  /// Legacy string getter retained for source compatibility.
  String get lineTotal => total.toStringAsFixed(2);
}

/// Customer information for quotation.
class QuotationCustomer {
  const QuotationCustomer({
    required this.name,
    this.nameAr,
    this.address,
    this.addressAr,
    this.phone,
    this.email,
    this.vatNumber,
  });

  final String name;
  final String? nameAr;
  final String? address;
  final String? addressAr;
  final String? phone;
  final String? email;
  final String? vatNumber;
}

/// Quotation data model.
///
/// Aggregate totals delegate to the shared S06 calculation service through the
/// S09 compatibility adapter instead of duplicating template calculations.
class QuotationData {
  const QuotationData({
    required this.quotationNumber,
    required this.quotationDate,
    required this.validUntil,
    required this.customer,
    required this.items,
    this.status = 'Draft',
    this.statusAr = 'مسودة',
    this.currency = 'SAR',
    this.notes,
    this.notesAr,
    this.terms,
    this.termsAr,
  });

  final String quotationNumber;
  final DateTime quotationDate;
  final DateTime validUntil;
  final QuotationCustomer customer;
  final List<QuotationItem> items;
  final String status;
  final String statusAr;
  final String currency;
  final String? notes;
  final String? notesAr;
  final String? terms;
  final String? termsAr;

  ErpCalculationResult get _calculation =>
      QuotationErpAdapter.calculateData(this);

  double get subTotal => _calculation.subtotal.toDouble();
  double get totalDiscount =>
      _calculation.lineDiscountTotal.toDouble();
  double get totalTax => _calculation.taxTotal.toDouble();
  double get grandTotal => _calculation.grandTotal.toDouble();
}

/// S09 compatibility adapter from legacy quotation models to S06.
///
/// The adapter is public so applications can migrate data incrementally without
/// changing the existing [QuotationTemplate] constructor immediately.
class QuotationErpAdapter extends GeniusErpDocumentAdapter<QuotationData> {
  const QuotationErpAdapter({
    required this.company,
  });

  final GeniusPdfCompanyInfo company;

  static ErpCurrency currencyOf(QuotationData source) =>
      GeniusErpLegacyCompatibility.currency(source.currency);

  static List<ErpLineItem> lineItemsOf(QuotationData source) {
    final currency = currencyOf(source);

    return source.items.map((item) {
      final gross = item.quantity * item.unitPrice;
      final taxableBase = gross - item.discount;
      final inferredTaxRate = item.tax == 0 || taxableBase == 0
          ? 0.0
          : item.tax / taxableBase * 100;

      return ErpLineItem(
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
        taxes: item.tax == 0
            ? const []
            : [
                ErpTaxLine(
                  code: 'LEGACY-TAX',
                  name: 'Tax',
                  nameAr: 'الضريبة',
                  ratePercent: inferredTaxRate,
                ),
              ],
      );
    }).toList(growable: false);
  }

  static ErpCalculationResult calculateData(QuotationData source) {
    return const ErpCalculationService().calculate(
      ErpCalculationRequest(
        currency: GeniusErpLegacyCompatibility.currency(
          source.currency,
        ),
        lineItems: lineItemsOf(source),
      ),
    );
  }

  @override
  ErpDocumentContext adapt(QuotationData source) {
    final party = GeniusErpLegacyCompatibility.party(
      id: source.customer.vatNumber,
      name: source.customer.name,
      nameAr: source.customer.nameAr,
      taxNumber: source.customer.vatNumber,
      address: source.customer.address,
      addressAr: source.customer.addressAr,
      phone: source.customer.phone,
      email: source.customer.email,
      addressRole: ErpAddressRole.billing,
    );

    return ErpDocumentContext(
      organization:
          GeniusErpLegacyCompatibility.organization(company),
      identity: ErpDocumentIdentity(
        kind: ErpDocumentKind.quotation,
        number: source.quotationNumber,
        issueDate: source.quotationDate,
        status: _documentStatus(source.status),
      ),
      recipient: party,
      billingAddress:
          party.addressFor(ErpAddressRole.billing),
      documentCurrency: currencyOf(source),
      lineItems: lineItemsOf(source),
      notes: source.notes,
      terms: source.terms,
      metadata: {
        'validUntil': source.validUntil,
        'statusAr': source.statusAr,
        'notesAr': source.notesAr,
        'termsAr': source.termsAr,
      },
    );
  }

  @override
  ErpCalculationRequest calculationRequest(
    QuotationData source,
    ErpDocumentContext document,
  ) =>
      ErpCalculationRequest.fromContext(document);

  static ErpDocumentStatus _documentStatus(String status) {
    return switch (status.trim().toLowerCase()) {
      'issued' || 'sent' => ErpDocumentStatus.issued,
      'approved' || 'accepted' => ErpDocumentStatus.approved,
      'cancelled' || 'canceled' => ErpDocumentStatus.cancelled,
      'voided' => ErpDocumentStatus.voided,
      _ => ErpDocumentStatus.draft,
    };
  }
}

/// A professional quotation template migrated to the S08 Transaction family.
///
/// The public constructor remains source-compatible with the pre-S09 template.
/// Identity, party, item table, calculation summary, terms, QR and signatures
/// are now supplied to the shared family plan.
class QuotationTemplate extends GeniusSalesTransactionDocument {
  QuotationTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.quotation,
    this.boldFont,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final QuotationData quotation;
  final PdfFont? boldFont;

  /// Report ID for QR code URL.
  final String? reportId;

  /// User who printed the report.
  final String? printedBy;

  /// Whether to show QR code with report link.
  final bool showQRCode;

  /// Whether to show signature areas.
  final bool showSignatures;

  /// Whether to show notes section.
  final bool showNotes;

  /// Custom notes to display.
  final String? notes;
  final String? notesAr;

  QuotationErpAdapter get _adapter =>
      QuotationErpAdapter(company: company);

  ErpDocumentContext get erpContext =>
      _adapter.adapt(quotation);

  ErpCalculationResult get erpCalculation =>
      const ErpCalculationService().calculate(
        _adapter.calculationRequest(
          quotation,
          erpContext,
        ),
      );

  @override
  GeniusErpFamilyPlan createFamilyPlan() {
    final context = erpContext;
    final calculation = const ErpCalculationService().calculate(
      _adapter.calculationRequest(
        quotation,
        context,
      ),
    );

    final effectiveNotes = notes ??
        (config.isRTL
            ? (notesAr ?? quotation.notesAr ?? quotation.notes)
            : (quotation.notes ?? notesAr ?? quotation.notesAr));

    return GeniusErpFamilyPlan(
      document: context,
      calculation: calculation,
      company: company,
      title: 'Quotation',
      titleAr: 'عرض سعر',
      primaryParty: context.recipient,
      primaryPartyTitle: 'Bill To',
      primaryPartyTitleAr: 'فاتورة إلى',
      addresses: [
        GeniusErpAddressSection(
          title: 'Billing Address',
          titleAr: 'عنوان الفوترة',
          address: context.billingAddress,
        ),
      ],
      detailFields: [
        GeniusErpDetailField(
          label: 'Valid Until',
          labelAr: 'صالح حتى',
          value: config.formatter.formatDate(
            quotation.validUntil,
          ),
          valueKind: GeniusPdfValueKind.date,
        ),
        GeniusErpDetailField(
          label: 'Status',
          labelAr: 'الحالة',
          value: config.isRTL
              ? quotation.statusAr
              : quotation.status,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
        GeniusErpDetailField(
          label: 'Currency',
          labelAr: 'العملة',
          value: quotation.currency,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
      ],
      notes: showNotes ? effectiveNotes : null,
      notesAr: showNotes ? (notesAr ?? quotation.notesAr) : null,
      terms: quotation.terms,
      termsAr: quotation.termsAr,
      signatures: showSignatures
          ? const [
              GeniusErpSignatureSpec(
                title: 'Authorized Signature',
                titleAr: 'التوقيع المعتمد',
              ),
              GeniusErpSignatureSpec(
                title: 'Customer Acceptance',
                titleAr: 'موافقة العميل',
              ),
            ]
          : const [],
      code: showQRCode && reportId != null
          ? GeniusErpCodeSpec(
              data: 'https://localhost:443/report/$reportId',
              caption: 'ID: $reportId',
              captionAr: 'ID: $reportId',
            )
          : null,
      footerText: printedBy == null
          ? null
          : 'Printed by $printedBy',
      footerTextAr: printedBy == null
          ? null
          : 'طبع بواسطة $printedBy',
      slotPolicies: const {
        GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.auto,
          estimatedHeight: 120,
        ),
        GeniusErpFamilySlot.approvalsSignatures:
            GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
          estimatedHeight: 90,
        ),
      },
    );
  }

  /// Generates a result while validating the shared S06 calculation input.
  ///
  /// The signature is intentionally unchanged for compatibility. The legacy
  /// [validationContext] remains accepted; calculation ownership now belongs
  /// to S06.
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
        fileName:
            'quotation_${quotation.quotationNumber}.pdf',
      );
    } catch (error, stackTrace) {
      return GeniusPdfFailure.fromException(
        error,
        stackTrace,
      );
    }
  }
}
