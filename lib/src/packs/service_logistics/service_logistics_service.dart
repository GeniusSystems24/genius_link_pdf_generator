
import '../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';
import '../../printing/profiles/print_profiles.dart';
import '../manufacturing_quality/manufacturing_quality.dart';
import '../shared/erp_pack_shared.dart';
import 'service_logistics_models.dart';

/// S20-T32 — standardized label/thermal profile hooks.
///
/// S20 does not create a second profile engine; all helpers return S11 public
/// profiles so calibration and physical geometry remain centralized.
class GeniusServiceLogisticsPrintProfiles {
  const GeniusServiceLogisticsPrintProfiles._();

  static GeniusPdfPrintProfile shippingLabel() =>
      GeniusPdfPrintProfile.customLabel(
        width: 100 * GeniusPdfPrintProfile.pointsPerMillimeter,
        height: 150 * GeniusPdfPrintProfile.pointsPerMillimeter,
      );

  static GeniusPdfPrintProfile palletLabel() =>
      GeniusPdfPrintProfile.customLabel(
        width: 100 * GeniusPdfPrintProfile.pointsPerMillimeter,
        height: 75 * GeniusPdfPrintProfile.pointsPerMillimeter,
      );

  static GeniusPdfPrintProfile shippingLabelSheet() =>
      GeniusPdfPrintProfile.labelSheet(
        columns: 2,
        rows: 4,
        labelWidth: 98 * GeniusPdfPrintProfile.pointsPerMillimeter,
        labelHeight: 67 * GeniusPdfPrintProfile.pointsPerMillimeter,
        horizontalGap: 2 * GeniusPdfPrintProfile.pointsPerMillimeter,
        verticalGap: 2 * GeniusPdfPrintProfile.pointsPerMillimeter,
      );

  static GeniusPdfPrintProfile thermal58() =>
      GeniusPdfPrintProfile.thermal58();

  static GeniusPdfPrintProfile thermal80() =>
      GeniusPdfPrintProfile.thermal80();
}

/// Maintenance, Service & Logistics preparation service for Sprint S20.
class GeniusServiceLogisticsService {
  const GeniusServiceLogisticsService();

  GeniusErpPackReportData serviceOrder(
    GeniusServiceOrderData order,
  ) =>
      _serviceOrderReport(
        order,
        title: 'Service Order',
        titleAr: 'أمر خدمة',
      );

  GeniusErpPackReportData maintenanceWorkOrder(
    GeniusServiceOrderData order,
  ) =>
      _serviceOrderReport(
        order,
        title: 'Maintenance Work Order',
        titleAr: 'أمر عمل صيانة',
      );

  GeniusErpPackReportData _serviceOrderReport(
    GeniusServiceOrderData order, {
    required String title,
    required String titleAr,
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle: order.orderNumber,
      subtitleAr: order.orderNumber,
      details: [
        _field(
          'Opened',
          'فتح في',
          order.openedAt.toIso8601String(),
        ),
        _field(
          'Subject',
          'موضوع الخدمة',
          '${order.subjectCode} — ${order.subjectName}',
          valueAr:
              '${order.subjectCode} — '
              '${order.subjectNameAr ?? order.subjectName}',
        ),
        if (order.customer != null)
          _field(
            'Customer',
            'العميل',
            order.customer!,
            valueAr: order.customerAr,
          ),
        if (order.assetTag != null)
          _field(
            'Asset Tag',
            'وسم الأصل',
            order.assetTag!,
          ),
        if (order.serialNumber != null)
          _field(
            'Serial',
            'التسلسلي',
            order.serialNumber!,
          ),
        if (order.location != null)
          _field(
            'Location',
            'الموقع',
            order.location!,
            valueAr: order.locationAr,
          ),
        _field('Status', 'الحالة', order.status.name),
        if (order.priority != null)
          _field('Priority', 'الأولوية', order.priority!),
        if (order.scheduledAt != null)
          _field(
            'Scheduled',
            'مجدول',
            order.scheduledAt!.toIso8601String(),
          ),
        if (order.technician != null)
          ..._personFields(
            order.technician!,
            prefix: 'Technician',
            prefixAr: 'الفني',
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'section',
          title: 'Section',
          titleAr: 'القسم',
        ),
        GeniusErpPackReportColumn(
          id: 'content',
          title: 'Content',
          titleAr: 'المحتوى',
          flexFactor: 4,
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        if (order.problem != null)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Problem',
              'content': GeniusErpPackLocalizedValue(
                value: order.problem!,
                valueAr: order.problemAr,
              ),
              'status': '',
            },
          ),
        if (order.requestedWork != null)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Requested Work',
              'content': GeniusErpPackLocalizedValue(
                value: order.requestedWork!,
                valueAr: order.requestedWorkAr,
              ),
              'status': '',
            },
          ),
        for (final item in order.checklist)
          GeniusErpPackReportRow(
            cells: {
              'section': item.code,
              'content': GeniusErpPackLocalizedValue(
                value: item.label,
                valueAr: item.labelAr,
              ),
              'status': item.status.name,
            },
          ),
        for (final attachment in order.attachments)
          GeniusErpPackReportRow(
            cells: {
              'section': attachment.isPhoto
                  ? 'Photo'
                  : 'Attachment',
              'content': GeniusErpPackLocalizedValue(
                value:
                    '${attachment.reference} — ${attachment.label}',
                valueAr:
                    '${attachment.reference} — '
                    '${attachment.labelAr ?? attachment.label}',
              ),
              'status': attachment.uri ?? '',
            },
          ),
      ],
      notes: order.notes,
      notesAr: order.notesAr,
    );
  }

  GeniusErpPackReportData preventiveMaintenanceSchedule(
    List<GeniusPreventiveMaintenanceEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Preventive Maintenance Schedule',
      titleAr: 'جدول الصيانة الوقائية',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'schedule',
          title: 'Schedule',
          titleAr: 'الجدول',
        ),
        GeniusErpPackReportColumn(
          id: 'subject',
          title: 'Subject',
          titleAr: 'الموضوع',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'asset',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'location',
          title: 'Location',
          titleAr: 'الموقع',
        ),
        GeniusErpPackReportColumn(
          id: 'last',
          title: 'Last Completed',
          titleAr: 'آخر تنفيذ',
        ),
        GeniusErpPackReportColumn(
          id: 'next',
          title: 'Next Due',
          titleAr: 'الاستحقاق القادم',
        ),
        GeniusErpPackReportColumn(
          id: 'frequency',
          title: 'Frequency Days',
          titleAr: 'التكرار بالأيام',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'technician',
          title: 'Technician',
          titleAr: 'الفني',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'schedule': entry.scheduleCode,
              'subject': GeniusErpPackLocalizedValue(
                value:
                    '${entry.subjectCode} — ${entry.subjectName}',
                valueAr:
                    '${entry.subjectCode} — '
                    '${entry.subjectNameAr ?? entry.subjectName}',
              ),
              'asset': entry.assetTag ?? '',
              'location': GeniusErpPackLocalizedValue(
                value: entry.location ?? '',
                valueAr: entry.locationAr,
              ),
              'last': entry.lastCompletedAt == null
                  ? ''
                  : _date(entry.lastCompletedAt!),
              'next': _date(entry.nextDueDate),
              'frequency': entry.frequencyDays,
              'technician': entry.assignedTechnician == null
                  ? ''
                  : GeniusErpPackLocalizedValue(
                      value:
                          '${entry.assignedTechnician!.id} — '
                          '${entry.assignedTechnician!.name}',
                      valueAr:
                          '${entry.assignedTechnician!.id} — '
                          '${entry.assignedTechnician!.nameAr ?? entry.assignedTechnician!.name}',
                    ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData maintenanceChecklist(
    String reference,
    List<GeniusServiceChecklistItem> items,
  ) {
    return GeniusErpPackReportData(
      title: 'Maintenance Checklist',
      titleAr: 'قائمة تحقق الصيانة',
      subtitle: reference,
      subtitleAr: reference,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'check',
          title: 'Check',
          titleAr: 'الفحص',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'required',
          title: 'Required',
          titleAr: 'إلزامي',
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
        GeniusErpPackReportColumn(
          id: 'comment',
          title: 'Comment',
          titleAr: 'ملاحظة',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final item in items)
          GeniusErpPackReportRow(
            cells: {
              'code': item.code,
              'check': GeniusErpPackLocalizedValue(
                value: item.label,
                valueAr: item.labelAr,
              ),
              'required': item.required ? 'Yes' : 'No',
              'status': item.status.name,
              'comment': GeniusErpPackLocalizedValue(
                value: item.comment ?? '',
                valueAr: item.commentAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData technicianReport(
    List<GeniusTechnicianReportEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Technician Report',
      titleAr: 'تقرير الفني',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Service Order',
          titleAr: 'أمر الخدمة',
        ),
        GeniusErpPackReportColumn(
          id: 'technician',
          title: 'Technician',
          titleAr: 'الفني',
        ),
        GeniusErpPackReportColumn(
          id: 'started',
          title: 'Started',
          titleAr: 'البداية',
        ),
        GeniusErpPackReportColumn(
          id: 'finished',
          title: 'Finished',
          titleAr: 'النهاية',
        ),
        GeniusErpPackReportColumn(
          id: 'hours',
          title: 'Labor h',
          titleAr: 'ساعات العمل',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'diagnosis',
          title: 'Diagnosis',
          titleAr: 'التشخيص',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'work',
          title: 'Work Performed',
          titleAr: 'العمل المنفذ',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'geo',
          title: 'Geo / Time',
          titleAr: 'الموقع / الوقت',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'order': entry.serviceOrderNumber,
              'technician': GeniusErpPackLocalizedValue(
                value:
                    '${entry.technician.id} — ${entry.technician.name}',
                valueAr:
                    '${entry.technician.id} — '
                    '${entry.technician.nameAr ?? entry.technician.name}',
              ),
              'started': entry.startedAt.toIso8601String(),
              'finished': entry.finishedAt.toIso8601String(),
              'hours': entry.laborHours ??
                  entry.finishedAt
                          .difference(entry.startedAt)
                          .inMinutes /
                      60.0,
              'diagnosis': GeniusErpPackLocalizedValue(
                value: entry.diagnosis ?? '',
                valueAr: entry.diagnosisAr,
              ),
              'work': GeniusErpPackLocalizedValue(
                value: entry.workPerformed,
                valueAr: entry.workPerformedAr,
              ),
              'geo': _geo(entry.metadata),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData serviceCompletionReport(
    GeniusServiceOrderData order, {
    required GeniusTechnicianReportEntry technicianReport,
    List<GeniusServiceSparePartUsage> parts = const [],
    List<GeniusDeliveryProofSignature> signatures = const [],
  }) {
    return GeniusErpPackReportData(
      title: 'Service Completion Report',
      titleAr: 'تقرير إكمال الخدمة',
      subtitle: order.orderNumber,
      subtitleAr: order.orderNumber,
      details: [
        _field(
          'Completed At',
          'اكتملت في',
          (order.completedAt ?? technicianReport.finishedAt)
              .toIso8601String(),
        ),
        ..._personFields(
          technicianReport.technician,
          prefix: 'Technician',
          prefixAr: 'الفني',
        ),
        _field(
          'Work Performed',
          'العمل المنفذ',
          technicianReport.workPerformed,
          valueAr: technicianReport.workPerformedAr,
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Type',
          titleAr: 'النوع',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description / Signer',
          titleAr: 'الوصف / الموقع',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'proof',
          title: 'Proof',
          titleAr: 'الإثبات',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final part in parts)
          GeniusErpPackReportRow(
            cells: {
              'type': 'Spare Part',
              'reference': part.partCode,
              'description': GeniusErpPackLocalizedValue(
                value: part.partName,
                valueAr: part.partNameAr,
              ),
              'qty': part.quantity,
              'proof': part.serialNumber ??
                  part.batchNumber ??
                  '',
            },
          ),
        for (final signature in signatures)
          GeniusErpPackReportRow(
            cells: {
              'type': 'Signature',
              'reference': signature.signatureReference ?? '',
              'description': GeniusErpPackLocalizedValue(
                value: signature.signerName,
                valueAr: signature.signerNameAr,
              ),
              'qty': '',
              'proof':
                  '${signature.signedAt.toIso8601String()} '
                  '${_geo(signature.metadata)}',
            },
          ),
      ],
      notes: technicianReport.notes ?? order.notes,
      notesAr: technicianReport.notesAr ?? order.notesAr,
    );
  }

  GeniusErpPackReportData sparePartsUsage(
    List<GeniusServiceSparePartUsage> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Spare Parts Usage',
      titleAr: 'استخدام قطع الغيار',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Service Order',
          titleAr: 'أمر الخدمة',
        ),
        GeniusErpPackReportColumn(
          id: 'part',
          title: 'Part Code',
          titleAr: 'رمز القطعة',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Part',
          titleAr: 'القطعة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Serial / Batch',
          titleAr: 'تسلسلي / دفعة',
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'order': entry.serviceOrderNumber,
              'part': entry.partCode,
              'description': GeniusErpPackLocalizedValue(
                value: entry.partName,
                valueAr: entry.partNameAr,
              ),
              'qty': entry.quantity,
              'unit': entry.unit.code,
              'trace': [
                if (entry.serialNumber != null)
                  'S:${entry.serialNumber}',
                if (entry.batchNumber != null)
                  'B:${entry.batchNumber}',
              ].join(' · '),
              'cost': entry.totalCost?.toDouble() ?? 0,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData warrantyReport(
    List<GeniusServiceWarrantyEntry> entries, {
    DateTime? asOf,
  }) {
    final effectiveDate = asOf ?? DateTime.now();
    return GeniusErpPackReportData(
      title: 'Warranty Report',
      titleAr: 'تقرير الضمان',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Warranty',
          titleAr: 'الضمان',
        ),
        GeniusErpPackReportColumn(
          id: 'subject',
          title: 'Subject',
          titleAr: 'الموضوع',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'serial',
          title: 'Serial',
          titleAr: 'التسلسلي',
        ),
        GeniusErpPackReportColumn(
          id: 'customer',
          title: 'Customer',
          titleAr: 'العميل',
        ),
        GeniusErpPackReportColumn(
          id: 'start',
          title: 'Start',
          titleAr: 'البداية',
        ),
        GeniusErpPackReportColumn(
          id: 'end',
          title: 'End',
          titleAr: 'النهاية',
        ),
        GeniusErpPackReportColumn(
          id: 'coverage',
          title: 'Coverage',
          titleAr: 'التغطية',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'active',
          title: 'Active',
          titleAr: 'ساري',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'reference': entry.reference,
              'subject': GeniusErpPackLocalizedValue(
                value:
                    '${entry.subjectCode} — ${entry.subjectName ?? ''}',
                valueAr:
                    '${entry.subjectCode} — '
                    '${entry.subjectNameAr ?? entry.subjectName ?? ''}',
              ),
              'serial': entry.serialNumber ?? '',
              'customer': GeniusErpPackLocalizedValue(
                value: entry.customer ?? '',
                valueAr: entry.customerAr,
              ),
              'start': _date(entry.startDate),
              'end': _date(entry.endDate),
              'coverage': GeniusErpPackLocalizedValue(
                value: entry.coverage ?? '',
                valueAr: entry.coverageAr,
              ),
              'active': entry.activeAt(effectiveDate) ? 'Yes' : 'No',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData inspectionReport(
    GeniusServiceInspectionData inspection,
  ) {
    return GeniusErpPackReportData(
      title: 'Inspection Report',
      titleAr: 'تقرير فحص',
      subtitle: inspection.inspectionNumber,
      subtitleAr: inspection.inspectionNumber,
      details: [
        _field('Date', 'التاريخ', _date(inspection.date)),
        _field(
          'Subject',
          'الموضوع',
          '${inspection.subjectCode} — ${inspection.subjectName}',
          valueAr:
              '${inspection.subjectCode} — '
              '${inspection.subjectNameAr ?? inspection.subjectName}',
        ),
        if (inspection.serviceOrderNumber != null)
          _field(
            'Service Order',
            'أمر الخدمة',
            inspection.serviceOrderNumber!,
          ),
        if (inspection.inspector != null)
          ..._personFields(
            inspection.inspector!,
            prefix: 'Inspector',
            prefixAr: 'المفتش',
          ),
        _field(
          'Overall',
          'النتيجة',
          inspection.overallStatus.name,
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'check',
          title: 'Check / Measurement',
          titleAr: 'الفحص / القياس',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'spec',
          title: 'Specification',
          titleAr: 'المواصفة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Value',
          titleAr: 'القيمة',
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
        GeniusErpPackReportColumn(
          id: 'comment',
          title: 'Comment',
          titleAr: 'ملاحظة',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final item in inspection.checklist)
          GeniusErpPackReportRow(
            cells: {
              'code': item.code,
              'check': GeniusErpPackLocalizedValue(
                value: item.label,
                valueAr: item.labelAr,
              ),
              'spec': '',
              'value': '',
              'status': item.status.name,
              'comment': GeniusErpPackLocalizedValue(
                value: item.comment ?? '',
                valueAr: item.commentAr,
              ),
            },
          ),
        for (final measurement in inspection.measurements)
          GeniusErpPackReportRow(
            cells: {
              'code': measurement.code,
              'check': GeniusErpPackLocalizedValue(
                value: measurement.name,
                valueAr: measurement.nameAr,
              ),
              'spec': GeniusErpPackLocalizedValue(
                value: measurement.specification ?? '',
                valueAr: measurement.specificationAr,
              ),
              'value':
                  '${measurement.value.toStringAsFixed(3)} '
                  '${measurement.unit ?? ''}',
              'status': measurement.status.name,
              'comment': measurement.toleranceText,
            },
          ),
        for (final attachment in inspection.attachments)
          GeniusErpPackReportRow(
            cells: {
              'code': attachment.reference,
              'check': GeniusErpPackLocalizedValue(
                value: attachment.label,
                valueAr: attachment.labelAr,
              ),
              'spec': attachment.isPhoto ? 'Photo' : 'Attachment',
              'value': '',
              'status': '',
              'comment': attachment.uri ?? '',
            },
          ),
      ],
      notes: inspection.notes,
      notesAr: inspection.notesAr,
    );
  }

  GeniusErpPackReportData calibrationServiceHistory(
    List<GeniusServiceHistoryEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Calibration / Service History',
      titleAr: 'سجل المعايرة / الخدمة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'subject',
          title: 'Subject',
          titleAr: 'الموضوع',
        ),
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Event',
          titleAr: 'الحدث',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'technician',
          title: 'Technician',
          titleAr: 'الفني',
        ),
        GeniusErpPackReportColumn(
          id: 'nextDue',
          title: 'Next Due',
          titleAr: 'الاستحقاق القادم',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'reference': entry.reference,
              'subject': entry.subjectCode,
              'type': entry.eventType,
              'description': GeniusErpPackLocalizedValue(
                value: entry.description,
                valueAr: entry.descriptionAr,
              ),
              'technician': entry.technician == null
                  ? ''
                  : GeniusErpPackLocalizedValue(
                      value:
                          '${entry.technician!.id} — '
                          '${entry.technician!.name}',
                      valueAr:
                          '${entry.technician!.id} — '
                          '${entry.technician!.nameAr ?? entry.technician!.name}',
                    ),
              'nextDue': entry.nextDueDate == null
                  ? ''
                  : _date(entry.nextDueDate!),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData shipmentDocument(
    GeniusShipmentData shipment,
  ) =>
      _shipmentReport(
        shipment,
        title: 'Shipment Document',
        titleAr: 'مستند شحنة',
      );

  GeniusErpPackReportData packingList(
    GeniusShipmentData shipment,
  ) =>
      _shipmentReport(
        shipment,
        title: 'Packing List',
        titleAr: 'قائمة تعبئة',
        packingVariant: true,
      );

  GeniusErpPackReportData dispatchNote(
    GeniusShipmentData shipment,
  ) =>
      _shipmentReport(
        shipment,
        title: 'Dispatch Note',
        titleAr: 'إشعار إرسال',
      );

  GeniusErpPackReportData waybill(
    GeniusShipmentData shipment,
  ) =>
      _shipmentReport(
        shipment,
        title: 'Waybill',
        titleAr: 'بوليصة نقل',
      );

  GeniusErpPackReportData _shipmentReport(
    GeniusShipmentData shipment, {
    required String title,
    required String titleAr,
    bool packingVariant = false,
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle: shipment.trackingNumber,
      subtitleAr: shipment.trackingNumber,
      details: [
        _field(
          'Shipment Number',
          'رقم الشحنة',
          shipment.shipmentNumber,
        ),
        _field(
          'Tracking Number',
          'رقم التتبع',
          shipment.trackingNumber,
        ),
        _field(
          'Ship Date',
          'تاريخ الشحن',
          _date(shipment.shipDate),
        ),
        _field(
          'Route',
          'المسار',
          shipment.route.routeCode,
        ),
        if (shipment.route.origin != null)
          _field(
            'Origin',
            'المنشأ',
            shipment.route.origin!,
            valueAr: shipment.route.originAr,
          ),
        if (shipment.route.destination != null)
          _field(
            'Destination',
            'الوجهة',
            shipment.route.destination!,
            valueAr: shipment.route.destinationAr,
          ),
        if (shipment.shipper != null)
          _field(
            'Shipper',
            'المرسل',
            shipment.shipper!,
            valueAr: shipment.shipperAr,
          ),
        if (shipment.shipperAddress != null)
          _field(
            'Shipper Address',
            'عنوان المرسل',
            shipment.shipperAddress!,
            valueAr: shipment.shipperAddressAr,
          ),
        if (shipment.consignee != null)
          _field(
            'Consignee',
            'المرسل إليه',
            shipment.consignee!,
            valueAr: shipment.consigneeAr,
          ),
        if (shipment.consigneeAddress != null)
          _field(
            'Consignee Address',
            'عنوان المرسل إليه',
            shipment.consigneeAddress!,
            valueAr: shipment.consigneeAddressAr,
          ),
        if (shipment.carrier != null)
          _field(
            'Carrier',
            'الناقل',
            shipment.carrier!,
            valueAr: shipment.carrierAr,
          ),
        if (shipment.vehicle != null)
          ..._vehicleFields(shipment.vehicle!),
        if (shipment.driver != null)
          ..._personFields(
            shipment.driver!,
            prefix: 'Driver',
            prefixAr: 'السائق',
          ),
        _field(
          'Packages',
          'الطرود',
          shipment.totalPackages.toString(),
        ),
        _field(
          'Weight',
          'الوزن',
          shipment.totalWeight.toStringAsFixed(3),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
        GeniusErpPackReportColumn(
          id: 'packages',
          title: 'Packages',
          titleAr: 'الطرود',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'weight',
          title: 'Weight',
          titleAr: 'الوزن',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Batch / Serial',
          titleAr: 'دفعة / تسلسلي',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'notes',
          title: 'Notes',
          titleAr: 'ملاحظات',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final item in shipment.items)
          GeniusErpPackReportRow(
            cells: {
              'item': item.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: item.description,
                valueAr: item.descriptionAr,
              ),
              'qty': item.quantity,
              'unit': item.unit.code,
              'packages': item.packageCount,
              'weight': item.weight ?? 0,
              'trace': [
                if (item.batchNumber != null)
                  'B:${item.batchNumber}',
                if (item.serialNumbers.isNotEmpty)
                  'S:${item.serialNumbers.join(',')}',
              ].join(' · '),
              'notes': GeniusErpPackLocalizedValue(
                value: packingVariant
                    ? (item.notes ?? '')
                    : (item.notes ?? ''),
                valueAr: item.notesAr,
              ),
            },
          ),
      ],
      notes: shipment.notes,
      notesAr: shipment.notesAr,
    );
  }

  GeniusErpPackReportData manifest(
    GeniusShipmentData shipment,
  ) {
    return GeniusErpPackReportData(
      title: 'Manifest',
      titleAr: 'بيان شحن',
      subtitle: shipment.trackingNumber,
      subtitleAr: shipment.trackingNumber,
      details: [
        _field(
          'Route Code',
          'رمز المسار',
          shipment.route.routeCode,
        ),
        _field(
          'Shipment',
          'الشحنة',
          shipment.shipmentNumber,
        ),
        _field(
          'Tracking',
          'التتبع',
          shipment.trackingNumber,
        ),
        _field(
          'Stops',
          'التوقفات',
          shipment.stops.length.toString(),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'seq',
          title: 'Seq',
          titleAr: 'تسلسل',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'stop',
          title: 'Stop',
          titleAr: 'التوقف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Name / Address',
          titleAr: 'الاسم / العنوان',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned',
          titleAr: 'المخطط',
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual',
          titleAr: 'الفعلي',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'geo',
          title: 'Geo / Time',
          titleAr: 'الموقع / الوقت',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final stop in shipment.stops)
          GeniusErpPackReportRow(
            cells: {
              'seq': stop.sequence,
              'stop': stop.stopCode,
              'name': GeniusErpPackLocalizedValue(
                value:
                    '${stop.name}'
                    '${stop.address == null ? '' : ' — ${stop.address}'}',
                valueAr:
                    '${stop.nameAr ?? stop.name}'
                    '${stop.addressAr == null ? '' : ' — ${stop.addressAr}'}',
              ),
              'planned': stop.plannedArrival?.toIso8601String() ?? '',
              'actual': stop.actualArrival?.toIso8601String() ?? '',
              'reference': stop.reference ?? '',
              'geo': _geo(stop.metadata),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData tripSheet(
    GeniusTripData trip,
  ) =>
      _tripReport(
        trip,
        title: 'Trip Sheet',
        titleAr: 'ورقة رحلة',
      );

  GeniusErpPackReportData tripReport(
    GeniusTripData trip,
  ) =>
      _tripReport(
        trip,
        title: 'Trip Report',
        titleAr: 'تقرير رحلة',
      );

  GeniusErpPackReportData _tripReport(
    GeniusTripData trip, {
    required String title,
    required String titleAr,
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle: trip.tripNumber,
      subtitleAr: trip.tripNumber,
      details: [
        _field(
          'Route',
          'المسار',
          trip.route.routeCode,
        ),
        _field(
          'Departure',
          'المغادرة',
          trip.departureAt.toIso8601String(),
        ),
        if (trip.returnAt != null)
          _field(
            'Return',
            'العودة',
            trip.returnAt!.toIso8601String(),
          ),
        ..._vehicleFields(trip.vehicle),
        ..._personFields(
          trip.driver,
          prefix: 'Driver',
          prefixAr: 'السائق',
        ),
        if (trip.distance != null)
          _field(
            'Distance',
            'المسافة',
            trip.distance!.toStringAsFixed(2),
          ),
        if (trip.fuelQuantity != null)
          _field(
            'Fuel',
            'الوقود',
            '${trip.fuelQuantity!.toStringAsFixed(2)} '
            '${trip.fuelUnit ?? ''}',
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'seq',
          title: 'Seq',
          titleAr: 'تسلسل',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'stop',
          title: 'Stop',
          titleAr: 'التوقف',
        ),
        GeniusErpPackReportColumn(
          id: 'address',
          title: 'Address',
          titleAr: 'العنوان',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned',
          titleAr: 'المخطط',
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual',
          titleAr: 'الفعلي',
        ),
      ],
      rows: [
        for (final stop in trip.stops)
          GeniusErpPackReportRow(
            cells: {
              'seq': stop.sequence,
              'stop': GeniusErpPackLocalizedValue(
                value: '${stop.stopCode} — ${stop.name}',
                valueAr:
                    '${stop.stopCode} — ${stop.nameAr ?? stop.name}',
              ),
              'address': GeniusErpPackLocalizedValue(
                value: stop.address ?? '',
                valueAr: stop.addressAr,
              ),
              'planned': stop.plannedArrival?.toIso8601String() ?? '',
              'actual': stop.actualArrival?.toIso8601String() ?? '',
            },
          ),
      ],
      notes: trip.notes,
      notesAr: trip.notesAr,
    );
  }

  /// S20-T32 QA helper showing that S20 uses S11 label/thermal profiles.
  GeniusErpPackReportData printProfileMatrix() {
    final profiles = <String, GeniusPdfPrintProfile>{
      'Shipping Label': GeniusServiceLogisticsPrintProfiles.shippingLabel(),
      'Pallet Label': GeniusServiceLogisticsPrintProfiles.palletLabel(),
      'Shipping Label Sheet':
          GeniusServiceLogisticsPrintProfiles.shippingLabelSheet(),
      'Thermal 58mm': GeniusServiceLogisticsPrintProfiles.thermal58(),
      'Thermal 80mm': GeniusServiceLogisticsPrintProfiles.thermal80(),
    };

    return GeniusErpPackReportData(
      title: 'Service / Logistics Print Profile Matrix',
      titleAr: 'مصفوفة ملفات طباعة الخدمة / اللوجستيات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'profile',
          title: 'Profile',
          titleAr: 'ملف الطباعة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'kind',
          title: 'Kind',
          titleAr: 'النوع',
        ),
        GeniusErpPackReportColumn(
          id: 'label',
          title: 'Label',
          titleAr: 'ملصق',
        ),
        GeniusErpPackReportColumn(
          id: 'thermal',
          title: 'Thermal',
          titleAr: 'حراري',
        ),
      ],
      rows: [
        for (final entry in profiles.entries)
          GeniusErpPackReportRow(
            cells: {
              'profile': entry.key,
              'kind': entry.value.kind.name,
              'label': entry.value.isLabel ? 'Yes' : 'No',
              'thermal': entry.value.isThermal ? 'Yes' : 'No',
            },
          ),
      ],
    );
  }

  /// S20-T18 — Shipping Label mapped to the S11 label engine.
  GeniusPdfLabelData shippingLabelData(
    GeniusShipmentData shipment,
  ) =>
      GeniusPdfLabelData(
        title: shipment.consignee ?? 'Shipment',
        titleAr: shipment.consigneeAr,
        sku: shipment.trackingNumber,
        barcodeData: shipment.trackingNumber,
        qrData:
            'shipment:${shipment.shipmentNumber};'
            'tracking:${shipment.trackingNumber}',
        customFields: {
          'Shipment': shipment.shipmentNumber,
          'Route': shipment.route.routeCode,
          if (shipment.consigneeAddress != null)
            'To': shipment.consigneeAddress!,
          'Packages': shipment.totalPackages.toString(),
        },
      );

  /// S20-T19 — Pallet Label.
  GeniusPdfLabelData palletLabelData({
    required String palletNumber,
    required GeniusShipmentData shipment,
    int? packageCount,
    double? weight,
  }) =>
      GeniusPdfLabelData(
        title: 'Pallet $palletNumber',
        titleAr: 'منصة $palletNumber',
        sku: palletNumber,
        barcodeData: palletNumber,
        qrData:
            'pallet:$palletNumber;'
            'shipment:${shipment.shipmentNumber}',
        customFields: {
          'Tracking': shipment.trackingNumber,
          'Route': shipment.route.routeCode,
          if (packageCount != null)
            'Packages': packageCount.toString(),
          if (weight != null)
            'Weight': weight.toStringAsFixed(3),
        },
      );

  GeniusErpPackReportData containerList(
    List<GeniusLogisticsContainerEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Container List',
      titleAr: 'قائمة الحاويات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'container',
          title: 'Container',
          titleAr: 'الحاوية',
        ),
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Type',
          titleAr: 'النوع',
        ),
        GeniusErpPackReportColumn(
          id: 'seal',
          title: 'Seal',
          titleAr: 'الختم',
        ),
        GeniusErpPackReportColumn(
          id: 'shipment',
          title: 'Shipment',
          titleAr: 'الشحنة',
        ),
        GeniusErpPackReportColumn(
          id: 'pallets',
          title: 'Pallets',
          titleAr: 'المنصات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'packages',
          title: 'Packages',
          titleAr: 'الطرود',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'weight',
          title: 'Weight',
          titleAr: 'الوزن',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'notes',
          title: 'Notes',
          titleAr: 'ملاحظات',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'container': entry.containerNumber,
              'type': entry.containerType,
              'seal': entry.sealNumber ?? '',
              'shipment': entry.shipmentNumber,
              'pallets': entry.palletCount,
              'packages': entry.packageCount,
              'weight': entry.weight ?? 0,
              'notes': GeniusErpPackLocalizedValue(
                value: entry.notes ?? '',
                valueAr: entry.notesAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData freightSummary(
    List<GeniusFreightSummaryEntry> entries,
  ) {
    final totals = <String, double>{};
    for (final entry in entries) {
      final code = entry.amount.currency.code;
      totals[code] =
          (totals[code] ?? 0) + entry.amount.toDouble();
    }

    return GeniusErpPackReportData(
      title: 'Freight Summary',
      titleAr: 'ملخص الشحن',
      details: [
        for (final entry in totals.entries)
          _field(
            'Total ${entry.key}',
            'إجمالي ${entry.key}',
            entry.value.toStringAsFixed(2),
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'shipment',
          title: 'Shipment',
          titleAr: 'الشحنة',
        ),
        GeniusErpPackReportColumn(
          id: 'charge',
          title: 'Charge',
          titleAr: 'الرسم',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'carrier',
          title: 'Carrier',
          titleAr: 'الناقل',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'currency',
          title: 'Currency',
          titleAr: 'العملة',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'shipment': entry.shipmentNumber,
              'charge': GeniusErpPackLocalizedValue(
                value: entry.chargeType,
                valueAr: entry.chargeTypeAr,
              ),
              'carrier': GeniusErpPackLocalizedValue(
                value: entry.carrier ?? '',
                valueAr: entry.carrierAr,
              ),
              'reference': entry.reference ?? '',
              'amount': entry.amount.toDouble(),
              'currency': entry.amount.currency.code,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData proofOfDelivery(
    GeniusProofOfDeliveryData pod,
  ) {
    return GeniusErpPackReportData(
      title: 'Proof of Delivery',
      titleAr: 'إثبات تسليم',
      subtitle: pod.deliveryNumber,
      subtitleAr: pod.deliveryNumber,
      details: [
        _field(
          'Shipment',
          'الشحنة',
          pod.shipment.shipmentNumber,
        ),
        _field(
          'Tracking',
          'التتبع',
          pod.shipment.trackingNumber,
        ),
        _field(
          'Delivered At',
          'وقت التسليم',
          pod.deliveredAt.toIso8601String(),
        ),
        _field(
          'Recipient',
          'المستلم',
          pod.recipientName,
          valueAr: pod.recipientNameAr,
        ),
        if (pod.condition != null)
          _field(
            'Condition',
            'حالة التسليم',
            pod.condition!,
            valueAr: pod.conditionAr,
          ),
        if (pod.metadata != null)
          _field(
            'Geo / Time',
            'الموقع / الوقت',
            _geo(pod.metadata),
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Proof Type',
          titleAr: 'نوع الإثبات',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'person',
          title: 'Person / Attachment',
          titleAr: 'الشخص / المرفق',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'time',
          title: 'Time',
          titleAr: 'الوقت',
        ),
        GeniusErpPackReportColumn(
          id: 'geo',
          title: 'Geo',
          titleAr: 'الموقع',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final signature in pod.signatures)
          GeniusErpPackReportRow(
            cells: {
              'type': 'Signature',
              'reference': signature.signatureReference ?? '',
              'person': GeniusErpPackLocalizedValue(
                value: signature.signerName,
                valueAr: signature.signerNameAr,
              ),
              'time': signature.signedAt.toIso8601String(),
              'geo': _geo(signature.metadata),
            },
          ),
        for (final attachment in pod.attachments)
          GeniusErpPackReportRow(
            cells: {
              'type': attachment.isPhoto ? 'Photo' : 'Attachment',
              'reference': attachment.reference,
              'person': GeniusErpPackLocalizedValue(
                value: attachment.label,
                valueAr: attachment.labelAr,
              ),
              'time': attachment.capturedAt?.toIso8601String() ?? '',
              'geo': attachment.uri ?? '',
            },
          ),
      ],
      notes: pod.notes,
      notesAr: pod.notesAr,
    );
  }

  List<GeniusErpDetailField> _personFields(
    GeniusServicePersonIdentity person, {
    required String prefix,
    required String prefixAr,
  }) =>
      [
        _field('$prefix ID', '$prefixAr - الرمز', person.id),
        _field(
          prefix,
          prefixAr,
          person.name,
          valueAr: person.nameAr,
        ),
        if (person.role != null)
          _field(
            '$prefix Role',
            'دور $prefixAr',
            person.role!,
            valueAr: person.roleAr,
          ),
        if (person.phone != null)
          _field(
            '$prefix Phone',
            'هاتف $prefixAr',
            person.phone!,
          ),
        if (person.licenseNumber != null)
          _field(
            '$prefix License',
            'رخصة $prefixAr',
            person.licenseNumber!,
          ),
      ];

  List<GeniusErpDetailField> _vehicleFields(
    GeniusLogisticsVehicleIdentity vehicle,
  ) =>
      [
        _field(
          'Vehicle ID',
          'رمز المركبة',
          vehicle.vehicleId,
        ),
        if (vehicle.plateNumber != null)
          _field(
            'Plate',
            'اللوحة',
            vehicle.plateNumber!,
          ),
        if (vehicle.trailerNumber != null)
          _field(
            'Trailer',
            'المقطورة',
            vehicle.trailerNumber!,
          ),
        if (vehicle.capacity != null)
          _field(
            'Capacity',
            'السعة',
            '${vehicle.capacity!.toStringAsFixed(2)} '
            '${vehicle.capacityUnit ?? ''}',
          ),
      ];

  GeniusErpDetailField _field(
    String label,
    String labelAr,
    String value, {
    String? valueAr,
  }) =>
      GeniusErpDetailField(
        label: label,
        labelAr: labelAr,
        value: valueAr == null ? value : '$value / $valueAr',
      );

  String _date(DateTime value) =>
      value.toIso8601String().split('T').first;

  String _geo(GeniusGeoTimeMetadata? metadata) {
    if (metadata == null) return '';
    final parts = <String>[
      metadata.timestamp.toIso8601String(),
      if (metadata.coordinateText.isNotEmpty)
        metadata.coordinateText,
      if (metadata.locationName != null)
        metadata.locationName!,
      if (metadata.timeZone != null) metadata.timeZone!,
    ];
    return parts.join(' · ');
  }
}
