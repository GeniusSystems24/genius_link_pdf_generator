
import '../../components/components.dart';
import '../../core/directionality.dart';
import '../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';

/// Tax input semantics for S12/S13 transaction packs.
enum GeniusErpPackTaxMode {
  /// Unit prices are net; taxes are added by S06.
  exclusive,

  /// Unit prices include the configured non-compound line taxes.
  ///
  /// The shared pack calculation layer normalizes inclusive prices to net
  /// before delegating all arithmetic/rounding to `ErpCalculationService`.
  inclusive,
}

/// Shared transaction request consumed by Sales and Purchasing packs.
///
/// The request contains domain inputs only. Rendering code never calculates
/// discounts, charges, taxes, currency conversion, payment state or return
/// totals.
class GeniusErpPackTransactionRequest {
  const GeniusErpPackTransactionRequest({
    required this.document,
    this.company,
    this.documentDiscounts = const [],
    this.documentCharges = const [],
    this.documentTaxes = const [],
    this.paidAmount,
    this.taxMode = GeniusErpPackTaxMode.exclusive,
    this.allowNegativeValues = false,
    this.paymentTerms,
    this.expectedDelivery,
    this.warehouse,
    this.site,
    this.extraDetails = const [],
    this.signatures = const [],
    this.showSummary = true,
    this.showApprovals = true,
    this.showAttachments = true,
  });

  final ErpDocumentContext document;

  /// Optional presentation company metadata (logo/header details).
  final GeniusPdfCompanyInfo? company;

  final List<ErpDiscount> documentDiscounts;
  final List<ErpCharge> documentCharges;
  final List<ErpTaxLine> documentTaxes;
  final ErpMoney? paidAmount;
  final GeniusErpPackTaxMode taxMode;

  /// Enables negative quantity/unit-price/grand-total paths used by returns.
  final bool allowNegativeValues;

  final String? paymentTerms;
  final DateTime? expectedDelivery;
  final String? warehouse;
  final String? site;
  final List<GeniusErpDetailField> extraDetails;
  final List<GeniusErpSignatureSpec> signatures;
  final bool showSummary;
  final bool showApprovals;
  final bool showAttachments;

  GeniusErpPackTransactionRequest copyWith({
    ErpDocumentContext? document,
    GeniusPdfCompanyInfo? company,
    List<ErpDiscount>? documentDiscounts,
    List<ErpCharge>? documentCharges,
    List<ErpTaxLine>? documentTaxes,
    ErpMoney? paidAmount,
    GeniusErpPackTaxMode? taxMode,
    bool? allowNegativeValues,
    String? paymentTerms,
    DateTime? expectedDelivery,
    String? warehouse,
    String? site,
    List<GeniusErpDetailField>? extraDetails,
    List<GeniusErpSignatureSpec>? signatures,
    bool? showSummary,
    bool? showApprovals,
    bool? showAttachments,
  }) =>
      GeniusErpPackTransactionRequest(
        document: document ?? this.document,
        company: company ?? this.company,
        documentDiscounts:
            documentDiscounts ?? this.documentDiscounts,
        documentCharges: documentCharges ?? this.documentCharges,
        documentTaxes: documentTaxes ?? this.documentTaxes,
        paidAmount: paidAmount ?? this.paidAmount,
        taxMode: taxMode ?? this.taxMode,
        allowNegativeValues:
            allowNegativeValues ?? this.allowNegativeValues,
        paymentTerms: paymentTerms ?? this.paymentTerms,
        expectedDelivery:
            expectedDelivery ?? this.expectedDelivery,
        warehouse: warehouse ?? this.warehouse,
        site: site ?? this.site,
        extraDetails: extraDetails ?? this.extraDetails,
        signatures: signatures ?? this.signatures,
        showSummary: showSummary ?? this.showSummary,
        showApprovals: showApprovals ?? this.showApprovals,
        showAttachments:
            showAttachments ?? this.showAttachments,
      );
}

/// Shared report-column semantic kind.
enum GeniusErpPackReportColumnKind {
  text,
  number,
  money,
}

/// One reusable report column.
class GeniusErpPackReportColumn {
  const GeniusErpPackReportColumn({
    required this.id,
    required this.title,
    this.titleAr,
    this.kind = GeniusErpPackReportColumnKind.text,
    this.width,
    this.flexFactor = 1,
  }) : assert(width == null || width > 0);

  final String id;
  final String title;
  final String? titleAr;
  final GeniusErpPackReportColumnKind kind;
  final double? width;
  final int flexFactor;
}

/// Localized report-cell value resolved only at render time.
class GeniusErpPackLocalizedValue {
  const GeniusErpPackLocalizedValue({
    required this.value,
    this.valueAr,
  });

  final String value;
  final String? valueAr;

  String resolve({required bool isRtl}) =>
      isRtl ? (valueAr ?? value) : value;
}

/// One report row. Calculated values are supplied before rendering.
class GeniusErpPackReportRow {
  const GeniusErpPackReportRow({
    required this.cells,
    this.isTotal = false,
  });

  final Map<String, Object?> cells;
  final bool isTotal;
}

/// Family-neutral register/statement/analytical report payload.
class GeniusErpPackReportData {
  const GeniusErpPackReportData({
    required this.title,
    required this.columns,
    required this.rows,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.details = const [],
    this.notes,
    this.notesAr,
  });

  final String title;
  final String? titleAr;
  final String? subtitle;
  final String? subtitleAr;
  final List<GeniusErpPackReportColumn> columns;
  final List<GeniusErpPackReportRow> rows;
  final List<GeniusErpDetailField> details;
  final String? notes;
  final String? notesAr;

  GeniusErpPackReportData withTitle(
    String title, {
    String? titleAr,
  }) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        subtitle: subtitle,
        subtitleAr: subtitleAr,
        columns: columns,
        rows: rows,
        details: details,
        notes: notes,
        notesAr: notesAr,
      );
}

/// Open receivable/payable item used by customer/supplier aging.
class GeniusErpOpenItem {
  const GeniusErpOpenItem({
    required this.partyId,
    required this.partyName,
    required this.documentNumber,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    this.partyNameAr,
    this.paidAmount,
  });

  final String partyId;
  final String partyName;
  final String? partyNameAr;
  final String documentNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final ErpMoney amount;
  final ErpMoney? paidAmount;

  ErpMoney get outstanding =>
      amount - (paidAmount ?? ErpMoney.zero(amount.currency));
}

/// Aging bucket result.
class GeniusErpAgingBucket {
  const GeniusErpAgingBucket({
    required this.label,
    required this.labelAr,
    required this.amount,
  });

  final String label;
  final String labelAr;
  final ErpMoney amount;
}

/// Generic customer/supplier aging result.
class GeniusErpAgingResult {
  const GeniusErpAgingResult({
    required this.currency,
    required this.current,
    required this.days1To30,
    required this.days31To60,
    required this.days61To90,
    required this.over90,
  });

  final ErpCurrency currency;
  final ErpMoney current;
  final ErpMoney days1To30;
  final ErpMoney days31To60;
  final ErpMoney days61To90;
  final ErpMoney over90;

  ErpMoney get total =>
      current + days1To30 + days31To60 + days61To90 + over90;

  List<GeniusErpAgingBucket> get buckets => [
        GeniusErpAgingBucket(
          label: 'Current',
          labelAr: 'حالي',
          amount: current,
        ),
        GeniusErpAgingBucket(
          label: '1-30 days',
          labelAr: '1-30 يوم',
          amount: days1To30,
        ),
        GeniusErpAgingBucket(
          label: '31-60 days',
          labelAr: '31-60 يوم',
          amount: days31To60,
        ),
        GeniusErpAgingBucket(
          label: '61-90 days',
          labelAr: '61-90 يوم',
          amount: days61To90,
        ),
        GeniusErpAgingBucket(
          label: 'Over 90 days',
          labelAr: 'أكثر من 90 يوم',
          amount: over90,
        ),
      ];
}

/// Shared metadata helpers used by Sales and Purchasing packs.
class GeniusErpPackMetadata {
  const GeniusErpPackMetadata._();

  static List<GeniusErpDetailField> transactionDetails(
    GeniusErpPackTransactionRequest request,
  ) {
    final fields = <GeniusErpDetailField>[
      GeniusErpDetailField(
        label: 'Tax Mode',
        labelAr: 'وضع الضريبة',
        value: request.taxMode.name,
        valueKind: GeniusPdfValueKind.customIdentifier,
      ),
    ];

    if (request.paymentTerms != null &&
        request.paymentTerms!.trim().isNotEmpty) {
      fields.add(
        GeniusErpDetailField(
          label: 'Payment Terms',
          labelAr: 'شروط الدفع',
          value: request.paymentTerms!,
        ),
      );
    }

    if (request.expectedDelivery != null) {
      fields.add(
        GeniusErpDetailField(
          label: 'Expected Delivery',
          labelAr: 'التسليم المتوقع',
          value: request.expectedDelivery!
              .toIso8601String()
              .split('T')
              .first,
          valueKind: GeniusPdfValueKind.date,
        ),
      );
    }

    if (request.warehouse != null &&
        request.warehouse!.trim().isNotEmpty) {
      fields.add(
        GeniusErpDetailField(
          label: 'Warehouse',
          labelAr: 'المستودع',
          value: request.warehouse!,
        ),
      );
    }

    if (request.site != null && request.site!.trim().isNotEmpty) {
      fields.add(
        GeniusErpDetailField(
          label: 'Site',
          labelAr: 'الموقع',
          value: request.site!,
        ),
      );
    }

    final rate = request.document.exchangeRate;
    if (rate != null) {
      fields.add(
        GeniusErpDetailField(
          label: 'Exchange Rate',
          labelAr: 'سعر الصرف',
          value: rate.rate.toStringAsFixed(6),
          valueKind: GeniusPdfValueKind.number,
        ),
      );
    }

    final print = request.document.printMetadata;
    if (print != null) {
      if (print.copyLabel != null &&
          print.copyLabel!.trim().isNotEmpty) {
        fields.add(
          GeniusErpDetailField(
            label: 'Copy',
            labelAr: 'النسخة',
            value: print.copyLabel!,
          ),
        );
      }
      if (print.copyNumber != null) {
        fields.add(
          GeniusErpDetailField(
            label: 'Copy Number',
            labelAr: 'رقم النسخة',
            value: print.copyNumber.toString(),
            valueKind: GeniusPdfValueKind.number,
          ),
        );
      }
    }

    fields.addAll(request.extraDetails);
    return fields;
  }
}
