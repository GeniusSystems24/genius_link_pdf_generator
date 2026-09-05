
import '../shared/erp_pack_shared.dart';
import 'inventory_models.dart';

/// S15 deterministic inventory report preparation service.
class GeniusInventoryService {
  const GeniusInventoryService();

  GeniusErpPackReportData movementDocument(
    List<GeniusInventoryMovementLine> lines, {
    required GeniusInventoryMovementKind kind,
  }) {
    final filtered = lines
        .where((line) => line.kind == kind)
        .toList(growable: false);

    final titles = switch (kind) {
      GeniusInventoryMovementKind.receipt =>
        ('Stock Receipt', 'استلام مخزون'),
      GeniusInventoryMovementKind.issue =>
        ('Stock Issue', 'صرف مخزون'),
      GeniusInventoryMovementKind.stockTransfer =>
        ('Stock Transfer', 'تحويل مخزون'),
      GeniusInventoryMovementKind.warehouseTransfer =>
        ('Warehouse Transfer', 'تحويل مستودع'),
      GeniusInventoryMovementKind.adjustment =>
        ('Stock Adjustment', 'تسوية مخزون'),
    };

    return GeniusErpPackReportData(
      title: titles.$1,
      titleAr: titles.$2,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
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
          id: 'from',
          title: 'From',
          titleAr: 'من',
        ),
        GeniusErpPackReportColumn(
          id: 'to',
          title: 'To',
          titleAr: 'إلى',
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Batch / Serial / Expiry',
          titleAr: 'دفعة / تسلسلي / صلاحية',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final line in filtered)
          GeniusErpPackReportRow(
            cells: {
              'item': line.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: line.itemName,
                valueAr: line.itemNameAr,
              ),
              'qty': line.quantity,
              'unit': line.unit.code,
              'from': _place(
                line.sourceWarehouse,
                line.sourceLocation,
              ),
              'to': _place(
                line.destinationWarehouse,
                line.destinationLocation,
              ),
              'trace': line.traceabilityText,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData stockCount(
    List<GeniusInventoryCountLine> lines, {
    bool cycleCount = false,
  }) {
    return GeniusErpPackReportData(
      title: cycleCount ? 'Cycle Count' : 'Stock Count',
      titleAr: cycleCount ? 'جرد دوري' : 'جرد المخزون',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'warehouse',
          title: 'Warehouse',
          titleAr: 'المستودع',
        ),
        GeniusErpPackReportColumn(
          id: 'location',
          title: 'Location',
          titleAr: 'الموقع',
        ),
        GeniusErpPackReportColumn(
          id: 'system',
          title: 'System',
          titleAr: 'النظام',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'counted',
          title: 'Counted',
          titleAr: 'المعدود',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'variance',
          title: 'Variance',
          titleAr: 'الفرق',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final line in lines)
          GeniusErpPackReportRow(
            cells: {
              'item': line.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: line.itemName,
                valueAr: line.itemNameAr,
              ),
              'warehouse': line.warehouse ?? '',
              'location': line.location ?? '',
              'system': line.systemQuantity,
              'counted': line.countedQuantity,
              'variance': line.variance,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData countReconciliation(
    List<GeniusInventoryCountLine> lines,
  ) {
    final variance = lines
        .where((line) => line.variance != 0)
        .toList(growable: false);

    return stockCount(variance).withTitle(
      'Count Variance / Reconciliation',
      titleAr: 'تسوية فروقات الجرد',
    );
  }

  GeniusErpPackReportData itemCard(
    List<GeniusInventoryMovementLine> lines, {
    required String itemCode,
  }) =>
      stockLedger(
        lines.where((line) => line.itemCode == itemCode).toList(),
      ).withTitle(
        'Item Card — $itemCode',
        titleAr: 'بطاقة صنف — $itemCode',
      );

  GeniusErpPackReportData stockLedger(
    List<GeniusInventoryMovementLine> lines,
  ) {
    var running = 0.0;

    return GeniusErpPackReportData(
      title: 'Stock Ledger',
      titleAr: 'دفتر حركة المخزون',
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
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'movement',
          title: 'Movement',
          titleAr: 'الحركة',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unit',
          title: 'Unit',
          titleAr: 'الوحدة',
        ),
        GeniusErpPackReportColumn(
          id: 'trace',
          title: 'Traceability',
          titleAr: 'التتبع',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final line in lines)
          GeniusErpPackReportRow(
            cells: {
              'date': line.date.toIso8601String().split('T').first,
              'document': line.documentNumber,
              'item': line.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: line.itemName,
                valueAr: line.itemNameAr,
              ),
              'movement': _signedMovement(line),
              'balance': running += _signedMovement(line),
              'unit': line.baseUnit?.code ?? line.unit.code,
              'trace': line.traceabilityText,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData stockValuation(
    List<GeniusInventoryStockPosition> positions,
  ) {
    return GeniusErpPackReportData(
      title: 'Stock Valuation',
      titleAr: 'تقييم المخزون',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'On Hand',
          titleAr: 'المتوفر',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'unitCost',
          title: 'Unit Cost',
          titleAr: 'تكلفة الوحدة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Value',
          titleAr: 'القيمة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final position in positions)
          GeniusErpPackReportRow(
            cells: {
              'item': position.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: position.itemName,
                valueAr: position.itemNameAr,
              ),
              'qty': position.onHand,
              'unitCost': position.unitCost.toDouble(),
              'value': position.stockValue.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData stockAvailability(
    List<GeniusInventoryStockPosition> positions,
  ) =>
      _positionReport(
        positions,
        title: 'Stock Availability',
        titleAr: 'توفر المخزون',
      );

  GeniusErpPackReportData reorderReport(
    List<GeniusInventoryStockPosition> positions,
  ) =>
      _positionReport(
        positions.where((item) => item.needsReorder).toList(),
        title: 'Reorder Report',
        titleAr: 'تقرير إعادة الطلب',
      );

  GeniusErpPackReportData minMaxReport(
    List<GeniusInventoryStockPosition> positions,
  ) =>
      _positionReport(
        positions
            .where(
              (item) => item.belowMinimum || item.aboveMaximum,
            )
            .toList(),
        title: 'Min / Max Report',
        titleAr: 'تقرير الحد الأدنى / الأعلى',
      );

  GeniusErpPackReportData slowDeadStock(
    List<GeniusInventoryStockPosition> positions, {
    required DateTime asOf,
    int slowAfterDays = 90,
    int deadAfterDays = 180,
  }) {
    return GeniusErpPackReportData(
      title: 'Slow / Dead Stock',
      titleAr: 'المخزون البطيء / الراكد',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'الصنف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'available',
          title: 'Available',
          titleAr: 'المتاح',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'last',
          title: 'Last Movement',
          titleAr: 'آخر حركة',
        ),
        GeniusErpPackReportColumn(
          id: 'days',
          title: 'Days',
          titleAr: 'الأيام',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final position in positions)
          if (_ageDays(position, asOf) >= slowAfterDays)
            GeniusErpPackReportRow(
              cells: {
                'item': position.itemCode,
                'name': GeniusErpPackLocalizedValue(
                  value: position.itemName,
                  valueAr: position.itemNameAr,
                ),
                'available': position.available,
                'last': position.lastMovementAt
                        ?.toIso8601String()
                        .split('T')
                        .first ??
                    '',
                'days': _ageDays(position, asOf),
                'status': _ageDays(position, asOf) >= deadAfterDays
                    ? 'Dead'
                    : 'Slow',
              },
            ),
      ],
    );
  }

  GeniusErpPackReportData batchReport(
    List<GeniusInventoryTraceabilityRecord> records,
  ) =>
      traceabilityReport(
        records.where((record) => record.batch != null).toList(),
        title: 'Batch Report',
        titleAr: 'تقرير الدفعات',
      );

  GeniusErpPackReportData serialReport(
    List<GeniusInventoryTraceabilityRecord> records,
  ) =>
      traceabilityReport(
        records.where((record) => record.serial != null).toList(),
        title: 'Serial Report',
        titleAr: 'تقرير الأرقام التسلسلية',
      );

  GeniusErpPackReportData expiryReport(
    List<GeniusInventoryTraceabilityRecord> records,
  ) =>
      traceabilityReport(
        records.where((record) => record.expiryDate != null).toList(),
        title: 'Expiry Report',
        titleAr: 'تقرير الصلاحية',
      );

  GeniusErpPackReportData traceabilityReport(
    List<GeniusInventoryTraceabilityRecord> records, {
    required String title,
    required String titleAr,
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
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'batch',
          title: 'Batch',
          titleAr: 'الدفعة',
        ),
        GeniusErpPackReportColumn(
          id: 'serial',
          title: 'Serial',
          titleAr: 'التسلسلي',
        ),
        GeniusErpPackReportColumn(
          id: 'expiry',
          title: 'Expiry',
          titleAr: 'الصلاحية',
        ),
        GeniusErpPackReportColumn(
          id: 'place',
          title: 'Warehouse / Location',
          titleAr: 'المستودع / الموقع',
        ),
        GeniusErpPackReportColumn(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final record in records)
          GeniusErpPackReportRow(
            cells: {
              'item': record.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: record.itemName,
                valueAr: record.itemNameAr,
              ),
              'batch': record.batch ?? '',
              'serial': record.serial ?? '',
              'expiry': record.expiryDate
                      ?.toIso8601String()
                      .split('T')
                      .first ??
                  '',
              'place': _place(record.warehouse, record.location),
              'qty': record.quantity ?? '',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData _positionReport(
    List<GeniusInventoryStockPosition> positions, {
    required String title,
    required String titleAr,
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
          id: 'name',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'warehouse',
          title: 'Warehouse',
          titleAr: 'المستودع',
        ),
        GeniusErpPackReportColumn(
          id: 'onHand',
          title: 'On Hand',
          titleAr: 'المتوفر',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'reserved',
          title: 'Reserved',
          titleAr: 'المحجوز',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'available',
          title: 'Available',
          titleAr: 'المتاح',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'min',
          title: 'Min',
          titleAr: 'أدنى',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'max',
          title: 'Max',
          titleAr: 'أعلى',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final position in positions)
          GeniusErpPackReportRow(
            cells: {
              'item': position.itemCode,
              'name': GeniusErpPackLocalizedValue(
                value: position.itemName,
                valueAr: position.itemNameAr,
              ),
              'warehouse': position.warehouse ?? '',
              'onHand': position.onHand,
              'reserved': position.reserved,
              'available': position.available,
              'min': position.minimum,
              'max': position.maximum ?? '',
            },
          ),
      ],
    );
  }

  double _signedMovement(GeniusInventoryMovementLine line) =>
      switch (line.kind) {
        GeniusInventoryMovementKind.receipt =>
          line.effectiveBaseQuantity,
        GeniusInventoryMovementKind.issue =>
          -line.effectiveBaseQuantity,
        GeniusInventoryMovementKind.stockTransfer => 0,
        GeniusInventoryMovementKind.warehouseTransfer => 0,
        GeniusInventoryMovementKind.adjustment =>
          line.effectiveBaseQuantity,
      };

  int _ageDays(
    GeniusInventoryStockPosition position,
    DateTime asOf,
  ) {
    final last = position.lastMovementAt;
    if (last == null) return 999999;
    final value = asOf.difference(last).inDays;
    return value < 0 ? 0 : value;
  }

  String _place(String? warehouse, String? location) =>
      [
        if (warehouse != null && warehouse.isNotEmpty) warehouse,
        if (location != null && location.isNotEmpty) location,
      ].join(' / ');
}
