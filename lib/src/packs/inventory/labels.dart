
import '../../printing/profiles/print_profiles.dart';
import 'models.dart';

GeniusPdfPrintProfile _inventoryDefaultLabelProfile() =>
    GeniusPdfPrintProfile.customLabel(
      width: 210,
      height: 120,
    );

List<GeniusPdfLabelData> _inventoryLabelData(
  List<GeniusInventoryLabelRecord> records, {
  required String kind,
}) =>
    [
      for (final record in records)
        GeniusPdfLabelData(
          title: record.itemName,
          titleAr: record.itemNameAr,
          sku: record.itemCode,
          batch: record.batch,
          serial: record.serial,
          expiry: record.expiryDate,
          barcodeData: record.itemCode,
          qrData: record.qrData,
          customFields: {
            'Type': kind,
            if (record.shelf != null) 'Shelf': record.shelf!,
            if (record.location != null)
              'Location': record.location!,
            if (record.price != null)
              'Price': record.price.toString(),
          },
        ),
    ];

/// S15-T20 — Item Label.
class GeniusInventoryItemLabelDocument
    extends GeniusPdfLabelPrintDocument {
  GeniusInventoryItemLabelDocument({
    required super.config,
    required List<GeniusInventoryLabelRecord> records,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _inventoryDefaultLabelProfile(), labels: _inventoryLabelData(records, kind: 'Item'));
}

/// S15-T21 — Shelf Label.
class GeniusShelfLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusShelfLabelDocument({
    required super.config,
    required List<GeniusInventoryLabelRecord> records,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _inventoryDefaultLabelProfile(), labels: _inventoryLabelData(records, kind: 'Shelf'));
}

/// S15-T22 — Batch Label.
class GeniusBatchLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusBatchLabelDocument({
    required super.config,
    required List<GeniusInventoryLabelRecord> records,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _inventoryDefaultLabelProfile(), labels: _inventoryLabelData(records, kind: 'Batch'));
}

/// S15-T23 — Serial Label.
class GeniusSerialLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusSerialLabelDocument({
    required super.config,
    required List<GeniusInventoryLabelRecord> records,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _inventoryDefaultLabelProfile(), labels: _inventoryLabelData(records, kind: 'Serial'));
}

/// S15-T24 — Location Label.
class GeniusLocationLabelDocument
    extends GeniusPdfLabelPrintDocument {
  GeniusLocationLabelDocument({
    required super.config,
    required List<GeniusInventoryLabelRecord> records,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? _inventoryDefaultLabelProfile(), labels: _inventoryLabelData(records, kind: 'Location'));
}
