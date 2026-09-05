
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

/// Manufacturing + Quality report preparation service for Sprint S18.
///
/// All calculations, status/tolerance evaluation and hierarchy preparation
/// happen before PDF drawing.
class GeniusManufacturingQualityService {
  const GeniusManufacturingQualityService();

  GeniusErpPackReportData billOfMaterials(
    List<GeniusManufacturingMaterialNode> materials, {
    String title = 'Bill of Materials (BOM)',
    String titleAr = 'قائمة المواد (BOM)',
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
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
          id: 'scrap',
          title: 'Scrap %',
          titleAr: 'هالك %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned Qty',
          titleAr: 'الكمية المخططة',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Batch / Serial',
          titleAr: 'دفعة / تسلسلي',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final material in materials)
          GeniusErpPackReportRow(
            cells: {
              'item': material.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value:
                    '${_indent(material.level)}${material.itemName}',
                valueAr:
                    '${_indent(material.level)}'
                    '${material.itemNameAr ?? material.itemName}',
              ),
              'qty': material.quantity,
              'unit': material.unit.code,
              'scrap': material.scrapPercent,
              'planned': material.plannedQuantity,
              'trace': _trace(
                material.batch?.batchNumber,
                material.serials
                    .map((value) => value.serialNumber)
                    .toList(),
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData productionOrder(
    GeniusProductionOrderData order,
  ) {
    return GeniusErpPackReportData(
      title: 'Production Order',
      titleAr: 'أمر إنتاج',
      subtitle: order.orderNumber,
      subtitleAr: order.orderNumber,
      details: [
        _field(
          'Product',
          'المنتج',
          '${order.productCode} — ${order.productName}',
          valueAr:
              '${order.productCode} — '
              '${order.productNameAr ?? order.productName}',
        ),
        _field(
          'Planned Qty',
          'الكمية المخططة',
          '${order.quantity} ${order.unit.code}',
        ),
        _field(
          'Actual Qty',
          'الكمية الفعلية',
          '${order.actualQuantity} ${order.unit.code}',
        ),
        _field(
          'Completion %',
          'نسبة الإنجاز %',
          order.completionPercent.toStringAsFixed(2),
        ),
        _field(
          'Status',
          'الحالة',
          order.status.name,
        ),
        _field(
          'Planned Start',
          'البداية المخططة',
          _date(order.plannedStart),
        ),
        _field(
          'Planned End',
          'النهاية المخططة',
          _date(order.plannedEnd),
        ),
        if (order.warehouse != null)
          _field(
            'Warehouse',
            'المستودع',
            order.warehouse!,
          ),
        if (order.workCenter != null)
          _field(
            'Work Center',
            'مركز العمل',
            order.workCenter!,
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
          id: 'operation',
          title: 'Operation',
          titleAr: 'العملية',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'workCenter',
          title: 'Work Center',
          titleAr: 'مركز العمل',
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned h',
          titleAr: 'مخطط س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual h',
          titleAr: 'فعلي س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final operation in order.operations)
          GeniusErpPackReportRow(
            cells: {
              'seq': operation.sequence,
              'operation': GeniusErpPackLocalizedValue(
                value:
                    '${operation.code} — ${operation.name}',
                valueAr:
                    '${operation.code} — '
                    '${operation.nameAr ?? operation.name}',
              ),
              'workCenter': operation.workCenter ?? '',
              'planned': operation.plannedHours,
              'actual': operation.actualHours,
              'status': operation.status.name,
            },
          ),
      ],
      notes: order.notes,
      notesAr: order.notesAr,
    );
  }

  GeniusErpPackReportData workOrder(
    GeniusProductionOrderData order,
  ) =>
      routingTraveler(order).withTitle(
        'Work Order',
        titleAr: 'أمر عمل',
      );

  GeniusErpPackReportData jobCard(
    GeniusProductionOrderData order,
  ) =>
      routingTraveler(order).withTitle(
        'Job Card',
        titleAr: 'بطاقة عمل',
      );

  GeniusErpPackReportData materialRequirement(
    List<GeniusManufacturingMaterialRequirement> materials,
  ) {
    return GeniusErpPackReportData(
      title: 'Material Requirement',
      titleAr: 'احتياج المواد',
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
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'required',
          title: 'Required',
          titleAr: 'المطلوب',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'issued',
          title: 'Issued',
          titleAr: 'المصروف',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'returned',
          title: 'Returned',
          titleAr: 'المرتجع',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'remaining',
          title: 'Remaining',
          titleAr: 'المتبقي',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
      ],
      rows: [
        for (final value in materials)
          GeniusErpPackReportRow(
            cells: {
              'item': value.material.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: value.material.itemName,
                valueAr: value.material.itemNameAr,
              ),
              'required': value.requiredQuantity,
              'issued': value.issuedQuantity,
              'returned': value.returnedQuantity,
              'remaining': value.remainingQuantity,
              'unit': value.material.unit.code,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData materialIssue(
    List<GeniusManufacturingMaterialMovement> values,
  ) =>
      _movementReport(
        values,
        title: 'Material Issue',
        titleAr: 'صرف مواد',
      );

  GeniusErpPackReportData materialReturn(
    List<GeniusManufacturingMaterialMovement> values,
  ) =>
      _movementReport(
        values,
        title: 'Material Return',
        titleAr: 'إرجاع مواد',
      );

  GeniusErpPackReportData productionReceipt(
    List<GeniusManufacturingMaterialMovement> values,
  ) =>
      _movementReport(
        values,
        title: 'Production Receipt',
        titleAr: 'استلام إنتاج',
      );

  GeniusErpPackReportData routingTraveler(
    GeniusProductionOrderData order,
  ) {
    return GeniusErpPackReportData(
      title: 'Routing / Traveler',
      titleAr: 'مسار / بطاقة تشغيل',
      subtitle: order.orderNumber,
      subtitleAr: order.orderNumber,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'seq',
          title: 'Seq',
          titleAr: 'تسلسل',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'operation',
          title: 'Operation',
          titleAr: 'العملية',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'workCenter',
          title: 'Work Center',
          titleAr: 'مركز العمل',
        ),
        GeniusErpPackReportColumn(
          id: 'machine',
          title: 'Machine',
          titleAr: 'الآلة',
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned h',
          titleAr: 'مخطط س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual h',
          titleAr: 'فعلي س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'variance',
          title: 'Variance h',
          titleAr: 'فرق س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final operation in order.operations)
          GeniusErpPackReportRow(
            cells: {
              'seq': operation.sequence,
              'code': operation.code,
              'operation': GeniusErpPackLocalizedValue(
                value: operation.name,
                valueAr: operation.nameAr,
              ),
              'workCenter': operation.workCenter ?? '',
              'machine': operation.machine ?? '',
              'planned': operation.plannedHours,
              'actual': operation.actualHours,
              'variance': operation.hourVariance,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData machineOperationReport(
    List<GeniusManufacturingMachineEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Machine Operation Report',
      titleAr: 'تقرير تشغيل الآلات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'operation',
          title: 'Operation',
          titleAr: 'العملية',
        ),
        GeniusErpPackReportColumn(
          id: 'machine',
          title: 'Machine',
          titleAr: 'الآلة',
        ),
        GeniusErpPackReportColumn(
          id: 'setup',
          title: 'Setup h',
          titleAr: 'إعداد س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'run',
          title: 'Run h',
          titleAr: 'تشغيل س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'downtime',
          title: 'Downtime h',
          titleAr: 'توقف س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'order': entry.orderNumber,
              'operation': entry.operationCode,
              'machine': entry.machineCode,
              'setup': entry.setupHours,
              'run': entry.runHours,
              'downtime': entry.downtimeHours,
              'reason': GeniusErpPackLocalizedValue(
                value: entry.reason ?? '',
                valueAr: entry.reasonAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData laborReport(
    List<GeniusManufacturingLaborEntry> entries,
  ) {
    final total = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.hours,
    );
    return GeniusErpPackReportData(
      title: 'Labor Report',
      titleAr: 'تقرير العمالة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'operation',
          title: 'Operation',
          titleAr: 'العملية',
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'hours',
          title: 'Hours',
          titleAr: 'الساعات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'order': entry.orderNumber,
              'operation': entry.operationCode,
              'employee': GeniusErpPackLocalizedValue(
                value:
                    '${entry.employeeId} — ${entry.employeeName}',
                valueAr:
                    '${entry.employeeId} — '
                    '${entry.employeeNameAr ?? entry.employeeName}',
              ),
              'hours': entry.hours,
            },
          ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'date': '',
            'order': '',
            'operation': '',
            'employee': 'Total',
            'hours': total,
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData scrapReport(
    List<GeniusManufacturingScrapEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Scrap Report',
      titleAr: 'تقرير الهالك',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
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
          id: 'batch',
          title: 'Batch',
          titleAr: 'الدفعة',
        ),
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'order': entry.orderNumber,
              'item': entry.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: entry.itemName,
                valueAr: entry.itemNameAr,
              ),
              'qty': entry.quantity,
              'unit': entry.unit.code,
              'batch': entry.batch?.batchNumber ?? '',
              'reason': GeniusErpPackLocalizedValue(
                value: entry.reason,
                valueAr: entry.reasonAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData workInProgress(
    List<GeniusManufacturingWipEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Work in Progress',
      titleAr: 'الإنتاج تحت التشغيل',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'product',
          title: 'Product',
          titleAr: 'المنتج',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned',
          titleAr: 'المخطط',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'completed',
          title: 'Completed',
          titleAr: 'المنجز',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'remaining',
          title: 'Remaining',
          titleAr: 'المتبقي',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'progress',
          title: 'Progress %',
          titleAr: 'الإنجاز %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'operation',
          title: 'Current Operation',
          titleAr: 'العملية الحالية',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'order': entry.orderNumber,
              'product': GeniusErpPackLocalizedValue(
                value:
                    '${entry.productCode} — ${entry.productName}',
                valueAr:
                    '${entry.productCode} — '
                    '${entry.productNameAr ?? entry.productName}',
              ),
              'planned': entry.plannedQuantity,
              'completed': entry.completedQuantity,
              'remaining': entry.remainingQuantity,
              'progress': entry.completionPercent,
              'operation': GeniusErpPackLocalizedValue(
                value: entry.currentOperation,
                valueAr: entry.currentOperationAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData productionVariance(
    List<GeniusManufacturingVariance> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Production Variance',
      titleAr: 'انحراف الإنتاج',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'metric',
          title: 'Metric',
          titleAr: 'المؤشر',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'planned',
          title: 'Planned',
          titleAr: 'المخطط',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual',
          titleAr: 'الفعلي',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'variance',
          title: 'Variance',
          titleAr: 'الانحراف',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'variancePercent',
          title: 'Variance %',
          titleAr: 'الانحراف %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'order': entry.orderNumber,
              'metric': GeniusErpPackLocalizedValue(
                value: entry.metric,
                valueAr: entry.metricAr,
              ),
              'planned': entry.planned,
              'actual': entry.actual,
              'variance': entry.variance,
              'variancePercent': entry.variancePercent,
              'unit': entry.unit ?? '',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData qualityInspection(
    GeniusQualityInspection inspection,
  ) {
    return GeniusErpPackReportData(
      title: 'Quality Inspection',
      titleAr: 'فحص الجودة',
      subtitle: inspection.inspectionNumber,
      subtitleAr: inspection.inspectionNumber,
      details: [
        _field(
          'Stage',
          'المرحلة',
          inspection.stage.name,
        ),
        _field(
          'Date',
          'التاريخ',
          _date(inspection.date),
        ),
        _field(
          'Subject',
          'موضوع الفحص',
          '${inspection.subjectCode} — ${inspection.subjectName}',
          valueAr:
              '${inspection.subjectCode} — '
              '${inspection.subjectNameAr ?? inspection.subjectName}',
        ),
        if (inspection.orderNumber != null)
          _field(
            'Order',
            'الأمر',
            inspection.orderNumber!,
          ),
        if (inspection.supplier != null)
          _field(
            'Supplier',
            'المورد',
            inspection.supplier!,
            valueAr: inspection.supplierAr,
          ),
        if (inspection.batch != null)
          _field(
            'Batch',
            'الدفعة',
            inspection.batch!.batchNumber,
          ),
        _field(
          'Overall',
          'النتيجة',
          _status(inspection.overallStatus),
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
          id: 'tolerance',
          title: 'Tolerance',
          titleAr: 'التفاوت',
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
              'tolerance': '',
              'status': _status(item.status),
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
              'tolerance': measurement.toleranceText,
              'status': _status(measurement.status),
              'comment': '',
            },
          ),
      ],
      notes: _signOffNotes(inspection.signOffs),
      notesAr: _signOffNotes(inspection.signOffs, isRtl: true),
    );
  }

  GeniusErpPackReportData incomingInspection(
    GeniusQualityInspection inspection,
  ) =>
      qualityInspection(inspection).withTitle(
        'Incoming Inspection',
        titleAr: 'فحص وارد',
      );

  GeniusErpPackReportData inProcessInspection(
    GeniusQualityInspection inspection,
  ) =>
      qualityInspection(inspection).withTitle(
        'In-process Inspection',
        titleAr: 'فحص أثناء التشغيل',
      );

  GeniusErpPackReportData finalInspection(
    GeniusQualityInspection inspection,
  ) =>
      qualityInspection(inspection).withTitle(
        'Final Inspection',
        titleAr: 'الفحص النهائي',
      );

  GeniusErpPackReportData nonConformanceReport(
    GeniusQualityNcr ncr,
  ) {
    return GeniusErpPackReportData(
      title: 'Non-Conformance Report (NCR)',
      titleAr: 'تقرير عدم المطابقة (NCR)',
      subtitle: ncr.ncrNumber,
      subtitleAr: ncr.ncrNumber,
      details: [
        _field('Date', 'التاريخ', _date(ncr.date)),
        _field(
          'Subject',
          'الموضوع',
          ncr.subject,
          valueAr: ncr.subjectAr,
        ),
        if (ncr.orderNumber != null)
          _field('Order', 'الأمر', ncr.orderNumber!),
        if (ncr.batch != null)
          _field('Batch', 'الدفعة', ncr.batch!.batchNumber),
        _field('Status', 'الحالة', _status(ncr.status)),
        if (ncr.owner != null)
          _field('Owner', 'المسؤول', ncr.owner!),
        if (ncr.dueDate != null)
          _field('Due Date', 'تاريخ الاستحقاق', _date(ncr.dueDate!)),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Non-Conformance',
          titleAr: 'عدم المطابقة',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'disposition',
          title: 'Disposition',
          titleAr: 'الإجراء',
          flexFactor: 2,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'description': GeniusErpPackLocalizedValue(
              value: ncr.description,
              valueAr: ncr.descriptionAr,
            ),
            'disposition': GeniusErpPackLocalizedValue(
              value: ncr.disposition ?? '',
              valueAr: ncr.dispositionAr,
            ),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData correctivePreventiveAction(
    GeniusQualityCapa capa,
  ) {
    return GeniusErpPackReportData(
      title: 'Corrective / Preventive Action (CAPA)',
      titleAr: 'إجراء تصحيحي / وقائي (CAPA)',
      subtitle: capa.capaNumber,
      subtitleAr: capa.capaNumber,
      details: [
        _field('Date', 'التاريخ', _date(capa.date)),
        if (capa.owner != null)
          _field('Owner', 'المسؤول', capa.owner!),
        if (capa.dueDate != null)
          _field('Due Date', 'الاستحقاق', _date(capa.dueDate!)),
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
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'section': 'Problem',
            'content': GeniusErpPackLocalizedValue(
              value: capa.problem,
              valueAr: capa.problemAr,
            ),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'section': 'Root Cause',
            'content': GeniusErpPackLocalizedValue(
              value: capa.rootCause,
              valueAr: capa.rootCauseAr,
            ),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'section': 'Corrective Action',
            'content': GeniusErpPackLocalizedValue(
              value: capa.correctiveAction,
              valueAr: capa.correctiveActionAr,
            ),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'section': 'Preventive Action',
            'content': GeniusErpPackLocalizedValue(
              value: capa.preventiveAction,
              valueAr: capa.preventiveActionAr,
            ),
          },
        ),
      ],
      notes: _signOffNotes(capa.signOffs),
      notesAr: _signOffNotes(capa.signOffs, isRtl: true),
    );
  }

  GeniusErpPackReportData certificateOfAnalysis(
    GeniusQualityCoaData coa,
  ) {
    return GeniusErpPackReportData(
      title: 'Certificate of Analysis (COA)',
      titleAr: 'شهادة تحليل (COA)',
      subtitle: coa.certificateNumber,
      subtitleAr: coa.certificateNumber,
      details: [
        _field('Date', 'التاريخ', _date(coa.date)),
        _field(
          'Item',
          'الصنف',
          '${coa.itemCode} — ${coa.itemName}',
          valueAr:
              '${coa.itemCode} — ${coa.itemNameAr ?? coa.itemName}',
        ),
        if (coa.batch != null)
          _field('Batch', 'الدفعة', coa.batch!.batchNumber),
        if (coa.manufacturingDate != null)
          _field(
            'Manufacturing Date',
            'تاريخ الإنتاج',
            _date(coa.manufacturingDate!),
          ),
        if (coa.expiryDate != null)
          _field(
            'Expiry Date',
            'تاريخ الصلاحية',
            _date(coa.expiryDate!),
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Test',
          titleAr: 'الفحص',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Name',
          titleAr: 'الاسم',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'spec',
          title: 'Specification',
          titleAr: 'المواصفة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'result',
          title: 'Result',
          titleAr: 'النتيجة',
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final result in coa.results)
          GeniusErpPackReportRow(
            cells: {
              'code': result.testCode,
              'name': GeniusErpPackLocalizedValue(
                value: result.testName,
                valueAr: result.testNameAr,
              ),
              'spec': GeniusErpPackLocalizedValue(
                value: result.specification,
                valueAr: result.specificationAr,
              ),
              'result': GeniusErpPackLocalizedValue(
                value: result.result,
                valueAr: result.resultAr,
              ),
              'status': _status(result.status),
            },
          ),
      ],
      notes: _signOffNotes(coa.signOffs),
      notesAr: _signOffNotes(coa.signOffs, isRtl: true),
    );
  }

  GeniusErpPackReportData qualityChecklist(
    List<GeniusQualityChecklistItem> items, {
    String title = 'Quality Checklist',
    String titleAr = 'قائمة تحقق الجودة',
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
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
              'status': _status(item.status),
              'comment': GeniusErpPackLocalizedValue(
                value: item.comment ?? '',
                valueAr: item.commentAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData auditForm(
    GeniusQualityAuditData audit,
  ) {
    return qualityChecklist(
      audit.checklist,
      title: 'Audit Form',
      titleAr: 'نموذج تدقيق',
    ).copyWithMeta(
      subtitle: audit.auditNumber,
      subtitleAr: audit.auditNumber,
      details: [
        _field('Date', 'التاريخ', _date(audit.date)),
        _field(
          'Area',
          'المنطقة',
          audit.area,
          valueAr: audit.areaAr,
        ),
        if (audit.auditor != null)
          _field(
            'Auditor',
            'المدقق',
            audit.auditor!,
            valueAr: audit.auditorAr,
          ),
      ],
      notes: audit.notes,
      notesAr: audit.notesAr,
    );
  }

  GeniusErpPackReportData calibrationRecord(
    GeniusQualityCalibrationRecord record,
  ) {
    final base = measurementReport(
      record.measurements,
      title: 'Calibration Record',
      titleAr: 'سجل معايرة',
    );

    return base.copyWithMeta(
      subtitle: record.recordNumber,
      subtitleAr: record.recordNumber,
      details: [
        _field('Date', 'التاريخ', _date(record.date)),
        _field(
          'Instrument',
          'الأداة',
          '${record.instrumentCode} — ${record.instrumentName}',
          valueAr:
              '${record.instrumentCode} — '
              '${record.instrumentNameAr ?? record.instrumentName}',
        ),
        if (record.standardReference != null)
          _field(
            'Standard',
            'المرجع',
            record.standardReference!,
          ),
        if (record.nextDueDate != null)
          _field(
            'Next Due',
            'الاستحقاق القادم',
            _date(record.nextDueDate!),
          ),
        _field(
          'Result',
          'النتيجة',
          _status(record.result),
        ),
      ],
      notes: _signOffNotes(record.signOffs),
      notesAr: _signOffNotes(record.signOffs, isRtl: true),
    );
  }

  GeniusErpPackReportData measurementReport(
    List<GeniusQualityMeasurement> values, {
    String title = 'Measurement Report',
    String titleAr = 'تقرير القياسات',
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'measurement',
          title: 'Measurement',
          titleAr: 'القياس',
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
          id: 'tolerance',
          title: 'Tolerance',
          titleAr: 'التفاوت',
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final value in values)
          GeniusErpPackReportRow(
            cells: {
              'code': value.code,
              'measurement': GeniusErpPackLocalizedValue(
                value: value.name,
                valueAr: value.nameAr,
              ),
              'spec': GeniusErpPackLocalizedValue(
                value: value.specification ?? '',
                valueAr: value.specificationAr,
              ),
              'value':
                  '${value.value.toStringAsFixed(3)} ${value.unit ?? ''}',
              'tolerance': value.toleranceText,
              'status': _status(value.status),
            },
          ),
      ],
    );
  }

  GeniusManufacturingNestedTableData nestedOperationMaterialTable(
    GeniusProductionOrderData order,
  ) {
    const columns = [
      GeniusErpPackReportColumn(
        id: 'code',
        title: 'Code',
        titleAr: 'الرمز',
      ),
      GeniusErpPackReportColumn(
        id: 'description',
        title: 'Description',
        titleAr: 'الوصف',
        flexFactor: 3,
      ),
      GeniusErpPackReportColumn(
        id: 'qty',
        title: 'Qty / Hours',
        titleAr: 'الكمية / الساعات',
        kind: GeniusErpPackReportColumnKind.number,
      ),
      GeniusErpPackReportColumn(
        id: 'unit',
        title: 'Unit',
        titleAr: 'الوحدة',
      ),
      GeniusErpPackReportColumn(
        id: 'status',
        title: 'Status',
        titleAr: 'الحالة',
      ),
    ];

    return GeniusManufacturingNestedTableData(
      title: 'Operations & Materials',
      titleAr: 'العمليات والمواد',
      columns: columns,
      sections: [
        for (final operation in order.operations)
          GeniusManufacturingNestedTableSection(
            title:
                '${operation.sequence}. ${operation.code} — '
                '${operation.name}',
            titleAr:
                '${operation.sequence}. ${operation.code} — '
                '${operation.nameAr ?? operation.name}',
            level: 0,
            rows: [
              {
                'code': operation.code,
                'description': GeniusErpPackLocalizedValue(
                  value: operation.name,
                  valueAr: operation.nameAr,
                ),
                'qty': operation.plannedHours,
                'unit': 'h',
                'status': operation.status.name,
              },
              for (final requirement in operation.materials)
                {
                  'code': requirement.material.itemCode,
                  'description': GeniusErpPackLocalizedValue(
                    value: requirement.material.itemName,
                    valueAr: requirement.material.itemNameAr,
                  ),
                  'qty': requirement.requiredQuantity,
                  'unit': requirement.material.unit.code,
                  'status': _trace(
                    requirement.material.batch?.batchNumber,
                    requirement.material.serials
                        .map((value) => value.serialNumber)
                        .toList(),
                  ),
                },
            ],
          ),
      ],
    );
  }

  GeniusErpPackReportData _movementReport(
    List<GeniusManufacturingMaterialMovement> values, {
    required String title,
    required String titleAr,
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'order',
          title: 'Order',
          titleAr: 'الأمر',
        ),
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
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
          id: 'location',
          title: 'Warehouse / Location',
          titleAr: 'المستودع / الموقع',
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Batch / Serial',
          titleAr: 'دفعة / تسلسلي',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final value in values)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(value.date),
              'document': value.documentNumber,
              'order': value.orderNumber,
              'item': value.itemCode,
              'description': GeniusErpPackLocalizedValue(
                value: value.itemName,
                valueAr: value.itemNameAr,
              ),
              'qty': value.quantity,
              'unit': value.unit.code,
              'location': [
                if (value.warehouse != null) value.warehouse!,
                if (value.location != null) value.location!,
              ].join(' / '),
              'trace': _trace(
                value.batch?.batchNumber,
                value.serials
                    .map((item) => item.serialNumber)
                    .toList(),
              ),
            },
          ),
      ],
    );
  }

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

  String _indent(int level) =>
      List.filled(level, '  ').join();

  String _status(GeniusQualityStatus value) =>
      switch (value) {
        GeniusQualityStatus.notChecked => 'NOT CHECKED',
        GeniusQualityStatus.pass => 'PASS',
        GeniusQualityStatus.fail => 'FAIL',
        GeniusQualityStatus.warning => 'WARNING',
        GeniusQualityStatus.notApplicable => 'N/A',
      };

  String _trace(
    String? batch,
    List<String> serials,
  ) =>
      [
        if (batch != null && batch.isNotEmpty) 'Batch $batch',
        if (serials.isNotEmpty) 'Serial ${serials.join(', ')}',
      ].join(' · ');

  String? _signOffNotes(
    List<GeniusQualitySignOff> signOffs, {
    bool isRtl = false,
  }) {
    if (signOffs.isEmpty) return null;
    return signOffs
        .map(
          (value) =>
              '${isRtl ? (value.roleAr ?? value.role) : value.role}: '
              '${isRtl ? (value.nameAr ?? value.name) : value.name} '
              '(${_status(value.status)}) '
              '${value.signedAt.toIso8601String()}',
        )
        .join('\n');
  }
}

/// S18-only convenience extension that preserves the shared report model while
/// allowing metadata replacement without modifying S12/S13 public API.
extension GeniusManufacturingReportMetadata on GeniusErpPackReportData {
  GeniusErpPackReportData copyWithMeta({
    String? subtitle,
    String? subtitleAr,
    List<GeniusErpDetailField>? details,
    String? notes,
    String? notesAr,
  }) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        subtitle: subtitle ?? this.subtitle,
        subtitleAr: subtitleAr ?? this.subtitleAr,
        columns: columns,
        rows: rows,
        details: details ?? this.details,
        notes: notes ?? this.notes,
        notesAr: notesAr ?? this.notesAr,
      );
}
