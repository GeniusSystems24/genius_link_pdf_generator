
import '../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';
import 'erp_pack_models.dart';

/// Central S12/S13 transaction calculation adapter.
///
/// No pack renderer performs arithmetic. Inclusive-tax normalization,
/// discounts, charges, taxes, currency conversion, paid/due and negative
/// return behavior are resolved here, then delegated to S06.
class GeniusErpPackCalculationService {
  const GeniusErpPackCalculationService({
    this.service = const ErpCalculationService(),
  });

  final ErpCalculationService service;

  ErpCalculationResult calculate(
    GeniusErpPackTransactionRequest request,
  ) {
    final lines = request.taxMode == GeniusErpPackTaxMode.inclusive
        ? _normalizeInclusiveLines(request)
        : request.document.lineItems;

    return service.calculate(
      ErpCalculationRequest(
        currency: request.document.documentCurrency,
        lineItems: lines,
        documentDiscounts: request.documentDiscounts,
        documentCharges: request.documentCharges,
        documentTaxes: request.documentTaxes,
        paidAmount: request.paidAmount,
        baseCurrency: request.document.baseCurrency,
        exchangeRate: request.document.exchangeRate,
        config: ErpCalculationConfig(
          allowZeroQuantity: request.allowNegativeValues,
          allowNegativeQuantity: request.allowNegativeValues,
          allowNegativeUnitPrice: request.allowNegativeValues,
          allowNegativeGrandTotal: request.allowNegativeValues,
        ),
      ),
    );
  }

  List<ErpLineItem> _normalizeInclusiveLines(
    GeniusErpPackTransactionRequest request,
  ) {
    final documentTaxes = request.documentTaxes;

    if (documentTaxes.any((tax) => tax.compound)) {
      throw ArgumentError(
        'Inclusive pack tax mode does not support compound document taxes.',
      );
    }

    return request.document.lineItems.map((line) {
      if (line.taxes.any((tax) => tax.compound)) {
        throw ArgumentError(
          'Inclusive pack tax mode does not support compound line taxes '
          '(${line.id}).',
        );
      }

      final rate = line.taxes.fold<double>(
            0,
            (sum, tax) => sum + tax.ratePercent,
          ) +
          documentTaxes.fold<double>(
            0,
            (sum, tax) => sum + tax.ratePercent,
          );

      if (rate == 0) return line;
      if (rate <= -100) {
        throw ArgumentError(
          'Inclusive tax rate must be greater than -100% (${line.id}).',
        );
      }

      final netPrice =
          line.unitPrice.toDouble() / (1 + rate / 100);

      return ErpLineItem(
        id: line.id,
        description: line.description,
        descriptionAr: line.descriptionAr,
        sku: line.sku,
        quantity: line.quantity,
        unitPrice: ErpMoney.fromAmount(
          netPrice,
          currency: line.unitPrice.currency,
        ),
        discounts: line.discounts,
        charges: line.charges,
        taxes: line.taxes,
        batch: line.batch,
        serials: line.serials,
        notes: line.notes,
        metadata: {
          ...line.metadata,
          'packTaxMode': 'inclusive',
          'inclusiveUnitPrice': line.unitPrice.toDouble(),
        },
      );
    }).toList(growable: false);
  }
}

/// Shared aging calculator for customer/supplier open items.
class GeniusErpAgingService {
  const GeniusErpAgingService();

  GeniusErpAgingResult calculate(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
  }) {
    if (items.isEmpty) {
      throw ArgumentError.value(
        items,
        'items',
        'At least one open item is required to determine currency.',
      );
    }

    final currency = items.first.amount.currency;
    var current = ErpMoney.zero(currency);
    var days1To30 = ErpMoney.zero(currency);
    var days31To60 = ErpMoney.zero(currency);
    var days61To90 = ErpMoney.zero(currency);
    var over90 = ErpMoney.zero(currency);

    for (final item in items) {
      if (item.amount.currency != currency) {
        throw ArgumentError(
          'Aging input must use one currency per calculation.',
        );
      }

      final outstanding = item.outstanding;
      if (outstanding.isZero) continue;

      final overdueDays = asOf.difference(item.dueDate).inDays;

      if (overdueDays <= 0) {
        current = current + outstanding;
      } else if (overdueDays <= 30) {
        days1To30 = days1To30 + outstanding;
      } else if (overdueDays <= 60) {
        days31To60 = days31To60 + outstanding;
      } else if (overdueDays <= 90) {
        days61To90 = days61To90 + outstanding;
      } else {
        over90 = over90 + outstanding;
      }
    }

    return GeniusErpAgingResult(
      currency: currency,
      current: current,
      days1To30: days1To30,
      days31To60: days31To60,
      days61To90: days61To90,
      over90: over90,
    );
  }
}

extension GeniusErpPackTransactionPlanning
    on GeniusErpPackTransactionRequest {
  /// Creates the shared S08 family plan after S06 calculation is complete.
  GeniusErpFamilyPlan toFamilyPlan({
    required String title,
    String? titleAr,
    String primaryPartyTitle = 'Party',
    String primaryPartyTitleAr = 'الطرف',
    bool showLineDiscount = true,
    bool showLineTax = true,
    List<ErpCharge> additionalCharges = const [],
  }) {
    final effective = additionalCharges.isEmpty
        ? this
        : copyWith(
            documentCharges: [
              ...documentCharges,
              ...additionalCharges,
            ],
          );

    final calculation =
        const GeniusErpPackCalculationService().calculate(effective);

    final addresses = <GeniusErpAddressSection>[
      if (document.billingAddress != null)
        GeniusErpAddressSection(
          title: 'Billing Address',
          titleAr: 'عنوان الفاتورة',
          address: document.billingAddress,
        ),
      if (document.shippingAddress != null)
        GeniusErpAddressSection(
          title: 'Shipping Address',
          titleAr: 'عنوان الشحن',
          address: document.shippingAddress,
        ),
    ];

    return GeniusErpFamilyPlan(
      document: document,
      calculation: calculation,
      company: company,
      title: title,
      titleAr: titleAr,
      primaryParty: document.recipient,
      primaryPartyTitle: primaryPartyTitle,
      primaryPartyTitleAr: primaryPartyTitleAr,
      addresses: addresses,
      detailFields: GeniusErpPackMetadata.transactionDetails(effective),
      notes: document.notes,
      notesAr: document.metadata['notesAr'] is String
          ? document.metadata['notesAr'] as String
          : null,
      terms: paymentTerms ?? document.terms,
      termsAr: document.metadata['termsAr'] is String
          ? document.metadata['termsAr'] as String
          : null,
      signatures: signatures,
      showLineDiscount: showLineDiscount,
      showLineTax: showLineTax,
      showSummary: showSummary,
      showApprovals: showApprovals,
      showAttachments: showAttachments,
      slotPolicies: const {
        GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
          estimatedHeight: 140,
        ),
        GeniusErpFamilySlot.approvalsSignatures:
            GeniusErpSlotPolicy(
          breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
          estimatedHeight: 88,
        ),
      },
    );
  }
}
