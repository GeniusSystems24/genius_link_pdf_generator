
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

const kg = ErpUnit(
  code: 'KG',
  name: 'Kilogram',
  nameAr: 'كيلوجرام',
  precision: 3,
);
const meter = ErpUnit(
  code: 'M',
  name: 'Meter',
  nameAr: 'متر',
  precision: 3,
);

GeniusManufacturingMaterialNode material({
  required String id,
  required int level,
  required ErpUnit unit,
  double quantity = 2,
}) =>
    GeniusManufacturingMaterialNode(
      id: id,
      itemCode: 'MAT-$id',
      itemName: 'Material $id',
      itemNameAr: 'مادة $id',
      quantity: quantity,
      unit: unit,
      level: level,
      parentId: level == 0 ? null : 'ROOT',
      scrapPercent: 5,
      batch: const ErpBatchInfo(
        batchNumber: 'BATCH-01',
      ),
      serials: const [
        ErpSerialInfo(serialNumber: 'SERIAL-001'),
      ],
    );

GeniusProductionOrderData productionOrder({
  int operations = 4,
}) {
  final baseMaterial = material(
    id: 'ROOT',
    level: 0,
    unit: kg,
  );

  return GeniusProductionOrderData(
    orderNumber: 'PO-2026-001',
    productCode: 'FG-001',
    productName: 'Finished Good',
    productNameAr: 'منتج نهائي',
    quantity: 100,
    actualQuantity: 60,
    unit: ErpUnit.each,
    plannedStart: DateTime(2026, 9, 1),
    plannedEnd: DateTime(2026, 9, 30),
    operations: List.generate(
      operations,
      (index) => GeniusManufacturingOperation(
        sequence: index + 1,
        code: 'OP-${(index + 1).toString().padLeft(3, '0')}',
        name: index == 0
            ? 'Very long routing operation with technical Latin CODE-AX9'
            : 'Operation ${index + 1}',
        nameAr: index == 0
            ? 'عملية تصنيع عربية طويلة مع الرمز CODE-AX9'
            : 'عملية ${index + 1}',
        plannedHours: 2 + index.toDouble(),
        actualHours: 2.5 + index.toDouble(),
        workCenter: 'WC-${index % 3}',
        machine: 'MC-${index % 4}',
        materials: [
          GeniusManufacturingMaterialRequirement(
            material: baseMaterial,
            requiredQuantity: 2 + index.toDouble(),
            issuedQuantity: 1,
          ),
        ],
      ),
    ),
    materials: [
      GeniusManufacturingMaterialRequirement(
        material: baseMaterial,
        requiredQuantity: 10,
        issuedQuantity: 8,
        returnedQuantity: 1,
      ),
    ],
  );
}

void main() {
  const service = GeniusManufacturingQualityService();

  test('multi-level BOM retains structural hierarchy and mixed units', () {
    final values = [
      material(id: 'ROOT', level: 0, unit: kg),
      material(id: 'CHILD-A', level: 1, unit: meter),
      material(id: 'CHILD-B', level: 2, unit: ErpUnit.each),
    ];

    final report = service.billOfMaterials(values);

    expect(report.rows, hasLength(3));
    expect(report.rows[0].cells['unit'], 'KG');
    expect(report.rows[1].cells['unit'], 'M');
    expect(report.rows[2].cells['unit'], 'EA');
    expect(values[2].level, 2);
  });

  test('BOM scrap planning is calculated before rendering', () {
    final value = material(
      id: 'SCRAP',
      level: 0,
      unit: kg,
      quantity: 10,
    );

    expect(value.plannedQuantity, 10.5);
  });

  test('long routing is supported without a separate layout engine', () {
    final order = productionOrder(operations: 120);
    final report = service.routingTraveler(order);

    expect(report.rows, hasLength(120));
    expect(
      report.rows.first.cells['operation'],
      isA<GeniusErpPackLocalizedValue>(),
    );
  });

  test('nested operation/material table produces grouped sections', () {
    final nested = service.nestedOperationMaterialTable(
      productionOrder(operations: 8),
    );

    expect(nested.sections, hasLength(8));
    expect(nested.sections.first.rows.length, 2);
    expect(nested.columns, isNotEmpty);
  });

  test('measurement tolerance produces pass/fail semantic status', () {
    const pass = GeniusQualityMeasurement(
      code: 'M1',
      name: 'Length',
      value: 10,
      minimum: 9.5,
      maximum: 10.5,
      unit: 'mm',
    );
    const fail = GeniusQualityMeasurement(
      code: 'M2',
      name: 'Width',
      value: 12,
      minimum: 9.5,
      maximum: 10.5,
      unit: 'mm',
    );

    expect(pass.status, GeniusQualityStatus.pass);
    expect(fail.status, GeniusQualityStatus.fail);
    expect(pass.toleranceText, contains('9.500'));
  });

  test('inspection fails when a required checklist or measurement fails', () {
    final inspection = GeniusQualityInspection(
      inspectionNumber: 'QI-1',
      date: DateTime(2026, 9, 4),
      subjectCode: 'ITEM-1',
      subjectName: 'Technical Item',
      subjectNameAr: 'صنف فني',
      stage: GeniusQualityInspectionStage.finalInspection,
      checklist: const [
        GeniusQualityChecklistItem(
          code: 'CHK-1',
          label: 'Visual',
          status: GeniusQualityStatus.pass,
        ),
      ],
      measurements: const [
        GeniusQualityMeasurement(
          code: 'DIM-1',
          name: 'Dimension',
          value: 15,
          maximum: 10,
        ),
      ],
    );

    expect(inspection.overallStatus, GeniusQualityStatus.fail);
    final report = service.finalInspection(inspection);
    expect(report.title, 'Final Inspection');
  });

  test('multi-page checklist preparation supports large item count', () {
    final report = service.qualityChecklist(
      List.generate(
        500,
        (index) => GeniusQualityChecklistItem(
          code: 'CHK-$index',
          label: 'Checklist item $index',
          labelAr: 'بند تحقق $index',
          status: index % 7 == 0
              ? GeniusQualityStatus.fail
              : GeniusQualityStatus.pass,
          comment: index == 0
              ? 'Very long technical comment intended to wrap'
              : null,
          commentAr: index == 0
              ? 'ملاحظة فنية عربية طويلة مخصصة لاختبار الالتفاف'
              : null,
        ),
      ),
    );

    expect(report.rows, hasLength(500));
  });

  test('batch and serial traceability stay intact', () {
    final nested = service.nestedOperationMaterialTable(
      productionOrder(),
    );

    final trace =
        nested.sections.first.rows.last['status'].toString();
    expect(trace, contains('BATCH-01'));
    expect(trace, contains('SERIAL-001'));
  });
}
