
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S20Scenario {
  serviceOrder,
  maintenanceWorkOrder,
  preventiveSchedule,
  maintenanceChecklist,
  technicianReport,
  serviceCompletion,
  spareParts,
  warranty,
  inspection,
  serviceHistory,
  shipment,
  packingList,
  dispatchNote,
  waybill,
  manifest,
  tripSheet,
  tripReport,
  shippingLabel,
  palletLabel,
  containerList,
  freightSummary,
  proofOfDelivery,
  profileMatrix,
}

class S20MaintenanceServiceLogisticsPackVerificationPage
    extends StatefulWidget {
  const S20MaintenanceServiceLogisticsPackVerificationPage({
    super.key,
  });

  @override
  State<S20MaintenanceServiceLogisticsPackVerificationPage>
      createState() =>
          _S20MaintenanceServiceLogisticsPackVerificationPageState();
}

class _S20MaintenanceServiceLogisticsPackVerificationPageState
    extends State<S20MaintenanceServiceLogisticsPackVerificationPage> {
  _S20Scenario _scenario = _S20Scenario.shipment;
  bool _rtl = false;
  bool _labelSheet = false;
  int _rowCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S20Scenario value) => switch (value) {
        _S20Scenario.serviceOrder => 'Service Order',
        _S20Scenario.maintenanceWorkOrder => 'Maintenance Work Order',
        _S20Scenario.preventiveSchedule => 'Preventive Schedule',
        _S20Scenario.maintenanceChecklist => 'Maintenance Checklist',
        _S20Scenario.technicianReport => 'Technician Report',
        _S20Scenario.serviceCompletion => 'Service Completion',
        _S20Scenario.spareParts => 'Spare Parts Usage',
        _S20Scenario.warranty => 'Warranty Report',
        _S20Scenario.inspection => 'Inspection Report',
        _S20Scenario.serviceHistory => 'Calibration / Service History',
        _S20Scenario.shipment => 'Shipment Document',
        _S20Scenario.packingList => 'Packing List',
        _S20Scenario.dispatchNote => 'Dispatch Note',
        _S20Scenario.waybill => 'Waybill',
        _S20Scenario.manifest => 'Manifest',
        _S20Scenario.tripSheet => 'Trip Sheet',
        _S20Scenario.tripReport => 'Trip Report',
        _S20Scenario.shippingLabel => 'Shipping Label',
        _S20Scenario.palletLabel => 'Pallet Label',
        _S20Scenario.containerList => 'Container List',
        _S20Scenario.freightSummary => 'Freight Summary',
        _S20Scenario.proofOfDelivery => 'Proof of Delivery',
        _S20Scenario.profileMatrix => 'Label / Thermal Profile Matrix',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses S20 public APIs in '
      '${_rtl ? 'RTL' : 'LTR'}. Arabic addresses/descriptions follow RTL '
      'while tracking numbers, route codes, vehicle IDs, plates, serials and '
      'signature references remain structured. Multi-stop/long-item tables '
      'paginate without overlap. Shipping/Pallet labels reuse S11 label '
      'geometry; Profile Matrix must show custom label plus thermal58/80.';

  GeniusServicePersonIdentity _technician(int index) =>
      GeniusServicePersonIdentity(
        id: 'TECH-${index + 1}',
        name: 'Technician ${index + 1}',
        nameAr: 'الفني ${index + 1}',
        role: 'Field Technician',
        roleAr: 'فني ميداني',
        phone: '+96650000${index.toString().padLeft(4, '0')}',
        email: 'tech$index@example.com',
        licenseNumber: 'LIC-TECH-${1000 + index}',
      );

  List<GeniusServiceChecklistItem> _checklist(int count) =>
      List.generate(
        count,
        (index) => GeniusServiceChecklistItem(
          code: 'CHK-${index + 1}',
          label: index == 0
              ? 'Very long preventive maintenance inspection checklist item'
              : 'Maintenance check ${index + 1}',
          labelAr: index == 0
              ? 'بند تحقق صيانة وقائية عربي طويل للتحقق من التفاف النص'
              : 'فحص صيانة ${index + 1}',
          status: index % 11 == 0
              ? GeniusQualityStatus.warning
              : GeniusQualityStatus.pass,
          comment: index == 0
              ? 'Long checklist comment used to verify wrapping.'
              : null,
          commentAr: index == 0
              ? 'ملاحظة تحقق عربية طويلة لاختبار التفاف النص.'
              : null,
        ),
      );

  GeniusServiceOrderData _serviceOrder(int count) =>
      GeniusServiceOrderData(
        orderNumber: 'SVC-2026-001',
        openedAt: DateTime(2026, 9, 4, 8),
        subjectCode: 'ASSET-LATIN-AX9',
        subjectName: 'Industrial Compressor',
        subjectNameAr: 'ضاغط صناعي',
        customer: 'Genius Customer',
        customerAr: 'عميل جينيس',
        assetTag: 'AST-LATIN-001',
        serialNumber: 'SN-LATIN-AX9-001',
        location: 'Riyadh Plant',
        locationAr: 'مصنع الرياض',
        problem:
            'Intermittent pressure drop during production peak load.',
        problemAr:
            'انخفاض متقطع في الضغط أثناء ذروة حمل الإنتاج.',
        requestedWork:
            'Inspect compressor, verify pressure system and replace worn parts.',
        requestedWorkAr:
            'فحص الضاغط والتحقق من نظام الضغط واستبدال الأجزاء المستهلكة.',
        status: GeniusServiceOrderStatus.inProgress,
        priority: 'High',
        technician: _technician(0),
        scheduledAt: DateTime(2026, 9, 4, 9),
        completedAt: DateTime(2026, 9, 4, 14),
        checklist: _checklist(count.clamp(1, 100).toInt()),
        attachments: [
          GeniusServiceAttachmentReference(
            reference: 'PHOTO-SVC-001',
            label: 'Before service photo',
            labelAr: 'صورة قبل الخدمة',
            uri: 'attachment://PHOTO-SVC-001',
            isPhoto: true,
            capturedAt: DateTime(2026, 9, 4, 9),
          ),
        ],
        notes: 'Service order note.',
        notesAr: 'ملاحظة أمر خدمة.',
      );

  List<GeniusServiceSparePartUsage> _parts(int count) =>
      List.generate(
        count,
        (index) => GeniusServiceSparePartUsage(
          serviceOrderNumber: 'SVC-2026-001',
          partCode: 'PART-${index + 1}',
          partName: 'Spare Part ${index + 1}',
          partNameAr: 'قطعة غيار ${index + 1}',
          quantity: 1 + index % 4,
          unit: ErpUnit.each,
          serialNumber: index % 3 == 0 ? 'SP-SN-${index + 1}' : null,
          batchNumber: 'SP-BATCH-${index % 8 + 1}',
          unitCost: ErpMoney.fromAmount(
            25 + index,
            currency: ErpCurrency.sar,
          ),
        ),
      );

  GeniusLogisticsVehicleIdentity get _vehicle =>
      const GeniusLogisticsVehicleIdentity(
        vehicleId: 'VEH-LATIN-001',
        plateNumber: 'ABC-1234',
        trailerNumber: 'TRL-009',
        make: 'Genius Truck',
        model: 'GT-2026',
        capacity: 18000,
        capacityUnit: 'kg',
      );

  GeniusServicePersonIdentity get _driver =>
      const GeniusServicePersonIdentity(
        id: 'DRV-LATIN-001',
        name: 'Driver One',
        nameAr: 'السائق الأول',
        role: 'Driver',
        roleAr: 'سائق',
        phone: '+966500001111',
        licenseNumber: 'LIC-DRV-AX9',
      );

  GeniusShipmentData _shipment(int count) => GeniusShipmentData(
        shipmentNumber: 'SHP-2026-001',
        trackingNumber: 'TRK-LATIN-AX9-0001',
        shipDate: DateTime(2026, 9, 4),
        route: const GeniusLogisticsRouteReference(
          routeCode: 'ROUTE-RUH-JED-01',
          routeName: 'Riyadh to Jeddah',
          routeNameAr: 'الرياض إلى جدة',
          origin: 'Riyadh',
          originAr: 'الرياض',
          destination: 'Jeddah',
          destinationAr: 'جدة',
          externalReference: 'EXT-ROUTE-AX9',
        ),
        status: GeniusLogisticsStatus.inTransit,
        shipper: 'Genius Warehouse',
        shipperAr: 'مستودع جينيس',
        consignee: 'Arabic Customer',
        consigneeAr: 'العميل العربي',
        shipperAddress:
            'Industrial Area, Riyadh, Saudi Arabia',
        shipperAddressAr:
            'المدينة الصناعية، الرياض، المملكة العربية السعودية',
        consigneeAddress:
            'Building 12, Logistics District, Jeddah, Saudi Arabia',
        consigneeAddressAr:
            'مبنى 12، حي الخدمات اللوجستية، جدة، المملكة العربية السعودية',
        carrier: 'Genius Logistics',
        carrierAr: 'جينيس للخدمات اللوجستية',
        vehicle: _vehicle,
        driver: _driver,
        stops: List.generate(
          count,
          (index) => GeniusLogisticsRouteStop(
            sequence: index + 1,
            stopCode: 'STOP-${index + 1}',
            name: 'Delivery Stop ${index + 1}',
            nameAr: 'محطة تسليم ${index + 1}',
            address:
                'Long delivery address ${index + 1}, Road ${index % 20}',
            addressAr:
                'عنوان تسليم عربي طويل ${index + 1}، الطريق ${index % 20}',
            plannedArrival:
                DateTime(2026, 9, 4, 8).add(Duration(minutes: index * 45)),
            actualArrival: index % 3 == 0
                ? DateTime(2026, 9, 4, 8)
                    .add(Duration(minutes: index * 47))
                : null,
            metadata: GeniusGeoTimeMetadata(
              timestamp: DateTime(2026, 9, 4, 8)
                  .add(Duration(minutes: index * 45)),
              latitude: 24.7136 - index / 1000,
              longitude: 46.6753 - index / 1000,
              locationName: 'Stop ${index + 1}',
              locationNameAr: 'محطة ${index + 1}',
              timeZone: '+03:00',
            ),
            reference: 'REF-STOP-${index + 1}',
            notes: 'Stop note ${index + 1}',
            notesAr: 'ملاحظة محطة ${index + 1}',
          ),
        ),
        references: const [
          'SO-2026-001',
          'DN-2026-001',
        ],
        items: List.generate(
          count,
          (index) => GeniusShipmentItem(
            itemCode: 'SKU-LATIN-${index + 1}',
            description: index == 0
                ? List.filled(
                    18,
                    'Long shipment item description for wrapping verification.',
                  ).join(' ')
                : 'Shipment item ${index + 1}',
            descriptionAr: index == 0
                ? List.filled(18, 'وصف صنف شحنة عربي طويل للتحقق من التفاف النص').join(' ')
                : 'صنف شحنة ${index + 1}',
            quantity: 2 + index % 5,
            unit: ErpUnit.each,
            packageCount: 1 + index % 3,
            weight: 4.25 + index % 7,
            weightUnit: 'kg',
            batchNumber: 'BATCH-${index % 10 + 1}',
            serialNumbers: ['SERIAL-${10000 + index}'],
            notes: index == 0 ? 'Handle with care' : null,
            notesAr: index == 0 ? 'يرجى التعامل بحذر' : null,
          ),
        ),
        attachments: [
          GeniusServiceAttachmentReference(
            reference: 'PHOTO-LOAD-001',
            label: 'Loading photo',
            labelAr: 'صورة التحميل',
            uri: 'attachment://PHOTO-LOAD-001',
            isPhoto: true,
          ),
        ],
        notes: 'Shipment notes.',
        notesAr: 'ملاحظات الشحنة.',
      );

  GeniusTripData _trip(int count) => GeniusTripData(
        tripNumber: 'TRIP-2026-001',
        route: _shipment(count).route,
        departureAt: DateTime(2026, 9, 4, 6),
        returnAt: DateTime(2026, 9, 5, 18),
        vehicle: _vehicle,
        driver: _driver,
        shipmentNumbers: const [
          'SHP-2026-001',
          'SHP-2026-002',
        ],
        stops: _shipment(count).stops,
        openingOdometer: 100000,
        closingOdometer: 101100,
        fuelQuantity: 280,
        fuelUnit: 'L',
        notes: 'Multi-stop route verification.',
        notesAr: 'التحقق من رحلة متعددة المحطات.',
      );

  GeniusServiceInspectionData _inspection(int count) =>
      GeniusServiceInspectionData(
        inspectionNumber: 'INS-SVC-2026-001',
        date: DateTime(2026, 9, 4),
        subjectCode: 'ASSET-LATIN-AX9',
        subjectName: 'Industrial Compressor',
        subjectNameAr: 'ضاغط صناعي',
        serviceOrderNumber: 'SVC-2026-001',
        inspector: _technician(1),
        checklist: _checklist(count.clamp(1, 100).toInt()),
        measurements: List.generate(
          count.clamp(1, 50).toInt(),
          (index) => GeniusQualityMeasurement(
            code: 'MEAS-${index + 1}',
            name: 'Pressure ${index + 1}',
            nameAr: 'ضغط ${index + 1}',
            value: 9.8 + (index % 4) * 0.1,
            specification: '9.5–10.5 bar',
            specificationAr: '9.5–10.5 بار',
            minimum: 9.5,
            maximum: 10.5,
            unit: 'bar',
          ),
        ),
        attachments: [
          GeniusServiceAttachmentReference(
            reference: 'PHOTO-INS-001',
            label: 'Inspection photo',
            labelAr: 'صورة الفحص',
            uri: 'attachment://PHOTO-INS-001',
            isPhoto: true,
          ),
        ],
      );

  Future<Uint8List> _generate() async {
    const service = GeniusServiceLogisticsService();
    final config = _config;
    final count = _rowCount;
    final order = _serviceOrder(count);
    final shipment = _shipment(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S20Scenario.serviceOrder:
        document = GeniusServiceOrderDocument(
          config,
          report: service.serviceOrder(order),
        );
        break;
      case _S20Scenario.maintenanceWorkOrder:
        document = GeniusMaintenanceWorkOrderDocument(
          config,
          report: service.maintenanceWorkOrder(order),
        );
        break;
      case _S20Scenario.preventiveSchedule:
        document = GeniusPreventiveMaintenanceScheduleDocument(
          config,
          report: service.preventiveMaintenanceSchedule(
            List.generate(
              count,
              (index) => GeniusPreventiveMaintenanceEntry(
                scheduleCode: 'PM-${index + 1}',
                subjectCode: 'ASSET-${index + 1}',
                subjectName: 'Scheduled Asset ${index + 1}',
                subjectNameAr: 'أصل مجدول ${index + 1}',
                assetTag: 'AST-${index + 1}',
                location: 'Plant ${index % 4 + 1}',
                locationAr: 'المصنع ${index % 4 + 1}',
                nextDueDate: DateTime(2026, 10, index % 28 + 1),
                frequencyDays: 90,
                lastCompletedAt: DateTime(2026, 7, 1),
                assignedTechnician: _technician(index % 5),
                checklist: _checklist(3),
              ),
            ),
          ),
        );
        break;
      case _S20Scenario.maintenanceChecklist:
        document = GeniusMaintenanceChecklistDocument(
          config,
          report: service.maintenanceChecklist(
            'SVC-2026-001',
            _checklist(count),
          ),
        );
        break;
      case _S20Scenario.technicianReport:
        document = GeniusTechnicianReportDocument(
          config,
          report: service.technicianReport(
            List.generate(
              count,
              (index) => GeniusTechnicianReportEntry(
                serviceOrderNumber: 'SVC-${index + 1}',
                technician: _technician(index % 10),
                startedAt: DateTime(2026, 9, 4, 8),
                finishedAt: DateTime(2026, 9, 4, 13),
                diagnosis: 'Pressure-control wear',
                diagnosisAr: 'تآكل في التحكم بالضغط',
                workPerformed:
                    'Inspected, adjusted and verified operating pressure.',
                workPerformedAr:
                    'تم الفحص والضبط والتحقق من ضغط التشغيل.',
                laborHours: 5,
                metadata: GeniusGeoTimeMetadata(
                  timestamp: DateTime(2026, 9, 4, 13),
                  latitude: 24.7136,
                  longitude: 46.6753,
                  timeZone: '+03:00',
                ),
              ),
            ),
          ),
        );
        break;
      case _S20Scenario.serviceCompletion:
        final technician = GeniusTechnicianReportEntry(
          serviceOrderNumber: order.orderNumber,
          technician: _technician(0),
          startedAt: DateTime(2026, 9, 4, 9),
          finishedAt: DateTime(2026, 9, 4, 14),
          workPerformed:
              'Completed maintenance and final functional verification.',
          workPerformedAr:
              'تم إكمال الصيانة والتحقق الوظيفي النهائي.',
          laborHours: 5,
        );
        document = GeniusServiceCompletionReportDocument(
          config,
          report: service.serviceCompletionReport(
            order,
            technicianReport: technician,
            parts: _parts(count),
            signatures: [
              GeniusDeliveryProofSignature(
                signerName: 'Service Receiver',
                signerNameAr: 'مستلم الخدمة',
                signedAt: DateTime(2026, 9, 4, 14),
                signatureReference: 'SIG-SVC-001',
              ),
            ],
          ),
        );
        break;
      case _S20Scenario.spareParts:
        document = GeniusSparePartsUsageDocument(
          config,
          report: service.sparePartsUsage(_parts(count)),
        );
        break;
      case _S20Scenario.warranty:
        document = GeniusWarrantyReportDocument(
          config,
          report: service.warrantyReport(
            List.generate(
              count,
              (index) => GeniusServiceWarrantyEntry(
                reference: 'WAR-${index + 1}',
                subjectCode: 'ASSET-${index + 1}',
                subjectName: 'Warranty Asset ${index + 1}',
                subjectNameAr: 'أصل ضمان ${index + 1}',
                customer: 'Customer ${index % 10 + 1}',
                customerAr: 'العميل ${index % 10 + 1}',
                serialNumber: 'SN-WAR-${index + 1}',
                startDate: DateTime(2026, 1, 1),
                endDate: DateTime(2027, 1, 1),
                coverage: 'Parts and labor',
                coverageAr: 'قطع الغيار والعمل',
              ),
            ),
            asOf: DateTime(2026, 9, 4),
          ),
        );
        break;
      case _S20Scenario.inspection:
        document = GeniusServiceInspectionReportDocument(
          config,
          report: service.inspectionReport(_inspection(count)),
        );
        break;
      case _S20Scenario.serviceHistory:
        document = GeniusCalibrationServiceHistoryDocument(
          config,
          report: service.calibrationServiceHistory(
            List.generate(
              count,
              (index) => GeniusServiceHistoryEntry(
                reference: 'HIST-${index + 1}',
                date: DateTime(2026, 9, index % 28 + 1),
                subjectCode: 'ASSET-${index % 20 + 1}',
                eventType: index.isEven ? 'Service' : 'Calibration',
                description: 'History event ${index + 1}',
                descriptionAr: 'حدث سجل ${index + 1}',
                serviceOrderNumber: 'SVC-${index + 1}',
                technician: _technician(index % 5),
                measurements: _inspection(1).measurements,
                nextDueDate: DateTime(2027, 3, 1),
              ),
            ),
          ),
        );
        break;
      case _S20Scenario.shipment:
        document = GeniusShipmentDocument(
          config,
          report: service.shipmentDocument(shipment),
        );
        break;
      case _S20Scenario.packingList:
        document = GeniusLogisticsPackingListDocument(
          config,
          report: service.packingList(shipment),
        );
        break;
      case _S20Scenario.dispatchNote:
        document = GeniusDispatchNoteDocument(
          config,
          report: service.dispatchNote(shipment),
        );
        break;
      case _S20Scenario.waybill:
        document = GeniusWaybillDocument(
          config,
          report: service.waybill(shipment),
        );
        break;
      case _S20Scenario.manifest:
        document = GeniusManifestDocument(
          config,
          report: service.manifest(shipment),
        );
        break;
      case _S20Scenario.tripSheet:
        document = GeniusTripSheetDocument(
          config,
          report: service.tripSheet(_trip(count)),
        );
        break;
      case _S20Scenario.tripReport:
        document = GeniusTripReportDocument(
          config,
          report: service.tripReport(_trip(count)),
        );
        break;
      case _S20Scenario.shippingLabel:
        document = GeniusShippingLabelDocument(
          config: config,
          profile: _labelSheet
              ? GeniusServiceLogisticsPrintProfiles.shippingLabelSheet()
              : GeniusServiceLogisticsPrintProfiles.shippingLabel(),
          shipments: List.generate(
            count.clamp(1, 20).toInt(),
            (_) => shipment,
          ),
        );
        break;
      case _S20Scenario.palletLabel:
        document = GeniusPalletLabelDocument(
          config: config,
          profile: GeniusServiceLogisticsPrintProfiles.palletLabel(),
          pallets: List.generate(
            count.clamp(1, 20).toInt(),
            (index) => GeniusPalletLabelRequest(
              palletNumber: 'PALLET-${index + 1}',
              shipment: shipment,
              packageCount: 10 + index,
              weight: 150 + index * 5,
            ),
          ),
        );
        break;
      case _S20Scenario.containerList:
        document = GeniusContainerListDocument(
          config,
          report: service.containerList(
            List.generate(
              count,
              (index) => GeniusLogisticsContainerEntry(
                containerNumber: 'CONT-${index + 1}',
                containerType: index.isEven ? '40HC' : '20GP',
                shipmentNumber: 'SHP-${index % 10 + 1}',
                sealNumber: 'SEAL-${1000 + index}',
                palletCount: 10 + index % 10,
                packageCount: 120 + index,
                weight: 5000 + index * 10,
                weightUnit: 'kg',
                notes: index == 0 ? 'Container note' : null,
                notesAr: index == 0 ? 'ملاحظة حاوية' : null,
              ),
            ),
          ),
        );
        break;
      case _S20Scenario.freightSummary:
        document = GeniusFreightSummaryDocument(
          config,
          report: service.freightSummary(
            List.generate(
              count,
              (index) => GeniusFreightSummaryEntry(
                shipmentNumber: 'SHP-${index % 10 + 1}',
                chargeType: 'Freight Charge ${index % 4 + 1}',
                chargeTypeAr: 'رسم شحن ${index % 4 + 1}',
                amount: ErpMoney.fromAmount(
                  100 + index,
                  currency: index % 5 == 0
                      ? ErpCurrency.usd
                      : ErpCurrency.sar,
                ),
                carrier: 'Carrier ${index % 3 + 1}',
                carrierAr: 'الناقل ${index % 3 + 1}',
                reference: 'FRT-${index + 1}',
              ),
            ),
          ),
        );
        break;
      case _S20Scenario.proofOfDelivery:
        document = GeniusProofOfDeliveryDocument(
          config,
          report: service.proofOfDelivery(
            GeniusProofOfDeliveryData(
              deliveryNumber: 'POD-2026-001',
              shipment: shipment,
              deliveredAt: DateTime(2026, 9, 5, 15),
              recipientName: 'Receiver One',
              recipientNameAr: 'المستلم الأول',
              condition: 'Delivered in good condition',
              conditionAr: 'تم التسليم بحالة جيدة',
              metadata: GeniusGeoTimeMetadata(
                timestamp: DateTime(2026, 9, 5, 15),
                latitude: 21.4858,
                longitude: 39.1925,
                locationName: 'Jeddah',
                locationNameAr: 'جدة',
                timeZone: '+03:00',
              ),
              signatures: [
                GeniusDeliveryProofSignature(
                  signerName: 'Receiver One',
                  signerNameAr: 'المستلم الأول',
                  role: 'Consignee',
                  roleAr: 'المستلم',
                  signedAt: DateTime(2026, 9, 5, 15),
                  signatureReference: 'SIG-POD-001',
                  metadata: GeniusGeoTimeMetadata(
                    timestamp: DateTime(2026, 9, 5, 15),
                    latitude: 21.4858,
                    longitude: 39.1925,
                    timeZone: '+03:00',
                  ),
                ),
                GeniusDeliveryProofSignature(
                  signerName: 'Driver One',
                  signerNameAr: 'السائق الأول',
                  role: 'Driver',
                  roleAr: 'السائق',
                  signedAt: DateTime(2026, 9, 5, 15, 2),
                  signatureReference: 'SIG-POD-DRV-001',
                ),
              ],
              attachments: [
                GeniusServiceAttachmentReference(
                  reference: 'PHOTO-POD-001',
                  label: 'Delivery photo',
                  labelAr: 'صورة التسليم',
                  uri: 'attachment://PHOTO-POD-001',
                  isPhoto: true,
                  capturedAt: DateTime(2026, 9, 5, 15),
                ),
              ],
              notes:
                  'POD verifies signatures, geo/time and photo references.',
              notesAr:
                  'يتحقق إثبات التسليم من التوقيعات والموقع والوقت والصور.',
            ),
          ),
        );
        break;
      case _S20Scenario.profileMatrix:
        document = GeniusServiceLogisticsProfileMatrixDocument(
          config,
          report: service.printProfileMatrix(),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  void _refresh() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S20 — Maintenance, Service & Logistics Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 340,
                        child: DropdownButtonFormField<_S20Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S20Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 50, label: Text('50')),
                          ButtonSegment(value: 200, label: Text('200')),
                        ],
                        selected: {_rowCount},
                        onSelectionChanged: (value) {
                          _rowCount = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Shipping label sheet'),
                        selected: _labelSheet,
                        onSelected: (value) {
                          _labelSheet = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's20_maintenance_service_logistics_pack.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
