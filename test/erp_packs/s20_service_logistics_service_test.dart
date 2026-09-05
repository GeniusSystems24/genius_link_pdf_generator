
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

const driver = GeniusServicePersonIdentity(
  id: 'DRV-LATIN-001',
  name: 'Driver One',
  nameAr: 'السائق الأول',
  role: 'Driver',
  roleAr: 'سائق',
  licenseNumber: 'LIC-AX9-2026',
);

const vehicle = GeniusLogisticsVehicleIdentity(
  vehicleId: 'VEH-001',
  plateNumber: 'ABC-1234',
  trailerNumber: 'TRL-009',
);

GeniusShipmentData shipment({
  int stopCount = 3,
  int itemCount = 4,
}) =>
    GeniusShipmentData(
      shipmentNumber: 'SHP-2026-001',
      trackingNumber: 'TRK-LATIN-AX9-0001',
      shipDate: DateTime(2026, 9, 4),
      route: const GeniusLogisticsRouteReference(
        routeCode: 'ROUTE-RUH-JED-01',
        origin: 'Riyadh',
        originAr: 'الرياض',
        destination: 'Jeddah',
        destinationAr: 'جدة',
      ),
      shipper: 'Genius Warehouse',
      shipperAr: 'مستودع جينيس',
      consignee: 'Arabic Customer',
      consigneeAr: 'العميل العربي',
      consigneeAddress: 'Building 12, Jeddah, Saudi Arabia',
      consigneeAddressAr:
          'مبنى 12، جدة، المملكة العربية السعودية',
      vehicle: vehicle,
      driver: driver,
      stops: List.generate(
        stopCount,
        (index) => GeniusLogisticsRouteStop(
          sequence: index + 1,
          stopCode: 'STOP-${index + 1}',
          name: 'Stop ${index + 1}',
          nameAr: 'توقف ${index + 1}',
          address: 'Address ${index + 1}',
          addressAr: 'عنوان ${index + 1}',
          plannedArrival: DateTime(2026, 9, 4, 8 + index),
          metadata: GeniusGeoTimeMetadata(
            timestamp: DateTime(2026, 9, 4, 8 + index),
            latitude: 24.7136 + index / 100,
            longitude: 46.6753 + index / 100,
            timeZone: '+03:00',
          ),
          reference: 'REF-STOP-${index + 1}',
        ),
      ),
      items: List.generate(
        itemCount,
        (index) => GeniusShipmentItem(
          itemCode: 'SKU-LATIN-${index + 1}',
          description: index == 0
              ? List.filled(
                  20,
                  'Long shipment item description for wrapping.',
                ).join(' ')
              : 'Shipment Item ${index + 1}',
          descriptionAr: index == 0
              ? List.filled(20, 'وصف صنف شحنة عربي طويل للتحقق من التفاف النص').join(' ')
              : 'صنف شحنة ${index + 1}',
          quantity: 2 + index.toDouble(),
          unit: ErpUnit.each,
          packageCount: 1 + index % 3,
          weight: 3.5 + index,
          weightUnit: 'kg',
          batchNumber: 'BATCH-${index + 1}',
          serialNumbers: ['SN-${index + 1}'],
        ),
      ),
    );

void main() {
  const service = GeniusServiceLogisticsService();

  test('multi-stop manifest keeps every route stop', () {
    final report = service.manifest(
      shipment(stopCount: 120),
    );

    expect(report.rows, hasLength(120));
    expect(report.rows.first.cells['stop'], 'STOP-1');
    expect(report.rows.last.cells['stop'], 'STOP-120');
  });

  test('long shipment items stay intact for wrapping', () {
    final data = shipment(itemCount: 100);
    final report = service.shipmentDocument(data);

    expect(report.rows, hasLength(100));
    expect(
      report.rows.first.cells['description'],
      isA<GeniusErpPackLocalizedValue>(),
    );
    final localized = report.rows.first.cells['description']
        as GeniusErpPackLocalizedValue;
    expect(localized.value.length, greaterThan(200));
  });

  test('Arabic address stays separate from Latin tracking number', () {
    final data = shipment();
    final report = service.shipmentDocument(data);

    expect(report.subtitle, 'TRK-LATIN-AX9-0001');
    expect(
      report.details.any(
        (field) =>
            field.value.contains('مبنى 12') &&
            field.value.contains('Building 12'),
      ),
      isTrue,
    );
  });

  test('shipping/pallet labels reuse tracking and pallet codes', () {
    final data = shipment();
    final shipping = service.shippingLabelData(data);
    final pallet = service.palletLabelData(
      palletNumber: 'PALLET-AX9-01',
      shipment: data,
      packageCount: 12,
      weight: 42.5,
    );

    expect(shipping.sku, 'TRK-LATIN-AX9-0001');
    expect(shipping.barcodeData, 'TRK-LATIN-AX9-0001');
    expect(pallet.sku, 'PALLET-AX9-01');
    expect(pallet.customFields['Tracking'], 'TRK-LATIN-AX9-0001');
  });

  test('S20 exposes label and both thermal profile hooks', () {
    expect(
      GeniusServiceLogisticsPrintProfiles.shippingLabel().kind,
      GeniusPdfPrintProfileKind.customLabel,
    );
    expect(
      GeniusServiceLogisticsPrintProfiles.palletLabel().kind,
      GeniusPdfPrintProfileKind.customLabel,
    );
    expect(
      GeniusServiceLogisticsPrintProfiles.thermal58().kind,
      GeniusPdfPrintProfileKind.thermal58,
    );
    expect(
      GeniusServiceLogisticsPrintProfiles.thermal80().kind,
      GeniusPdfPrintProfileKind.thermal80,
    );
  });

  test('proof of delivery carries signatures geo and photo references', () {
    final data = shipment();
    final pod = GeniusProofOfDeliveryData(
      deliveryNumber: 'POD-2026-001',
      shipment: data,
      deliveredAt: DateTime(2026, 9, 4, 16),
      recipientName: 'Receiver One',
      recipientNameAr: 'المستلم الأول',
      metadata: GeniusGeoTimeMetadata(
        timestamp: DateTime(2026, 9, 4, 16),
        latitude: 21.4858,
        longitude: 39.1925,
        timeZone: '+03:00',
      ),
      signatures: [
        GeniusDeliveryProofSignature(
          signerName: 'Receiver One',
          signerNameAr: 'المستلم الأول',
          signedAt: DateTime(2026, 9, 4, 16),
          signatureReference: 'SIG-POD-001',
        ),
      ],
      attachments: [
        const GeniusServiceAttachmentReference(
          reference: 'PHOTO-POD-001',
          label: 'Delivery photo',
          labelAr: 'صورة التسليم',
          uri: 'attachment://PHOTO-POD-001',
          isPhoto: true,
        ),
      ],
    );

    final report = service.proofOfDelivery(pod);
    expect(report.rows, hasLength(2));
    expect(report.rows.first.cells['reference'], 'SIG-POD-001');
    expect(report.rows.last.cells['reference'], 'PHOTO-POD-001');
  });
}
