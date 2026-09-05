
import '../../printing/profiles/print_profiles.dart';
import 'models.dart';

GeniusPdfPrintProfile _retailLabelProfile() =>
    GeniusPdfPrintProfile.customLabel(
      width: 210,
      height: 120,
    );

List<GeniusPdfLabelData> _retailLabels(
  List<GeniusPosRetailLabel> labels, {
  required String kind,
}) =>
    [
      for (final label in labels)
        GeniusPdfLabelData(
          title: label.itemName,
          titleAr: label.itemNameAr,
          sku: label.itemCode,
          barcodeData: label.itemCode,
          qrData: label.qrData,
          customFields: {
            'Type': kind,
            'Price': label.price.toString(),
            if (label.oldPrice != null)
              'Old Price': label.oldPrice.toString(),
            if (label.promotion != null)
              'Promotion': label.promotion!,
            if (label.promotionAr != null)
              'Promotion AR': label.promotionAr!,
          },
        ),
    ];

/// S16-T13 — Barcode label.
class GeniusRetailBarcodeLabelDocument
    extends GeniusPdfLabelPrintDocument {
  GeniusRetailBarcodeLabelDocument({
    required super.config,
    required List<GeniusPosRetailLabel> labels,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _retailLabelProfile(), labels: _retailLabels(labels, kind: 'Barcode'));
}

/// S16-T14 — Price label.
class GeniusRetailPriceLabelDocument
    extends GeniusPdfLabelPrintDocument {
  GeniusRetailPriceLabelDocument({
    required super.config,
    required List<GeniusPosRetailLabel> labels,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _retailLabelProfile(), labels: _retailLabels(labels, kind: 'Price'));
}

/// S16-T15 — Promotion label.
class GeniusRetailPromotionLabelDocument
    extends GeniusPdfLabelPrintDocument {
  GeniusRetailPromotionLabelDocument({
    required super.config,
    required List<GeniusPosRetailLabel> labels,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _retailLabelProfile(), labels: _retailLabels(labels, kind: 'Promotion'));
}
