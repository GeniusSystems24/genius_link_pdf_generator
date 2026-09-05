// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S18ManufacturingQualityPackVerificationPage.
enum S18ManufacturingQualityPackScenario {
  bom,
  productionOrder,
  workOrder,
  jobCard,
  materialRequirement,
  materialIssue,
  materialReturn,
  productionReceipt,
  routing,
  machineOperation,
  labor,
  scrap,
  wip,
  variance,
  qualityInspection,
  incomingInspection,
  inProcessInspection,
  finalInspection,
  ncr,
  capa,
  coa,
  qualityChecklist,
  audit,
  calibration,
  nestedTables,
}

/// Executes one focused S18 verification scenario.
class S18ManufacturingQualityPackRunner {
  S18ManufacturingQualityPackRunner({
    required GeniusPdfConfig baseConfig,
    required S18ManufacturingQualityPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S18ManufacturingQualityPackScenario _scenario;
bool _rtl = false;
  final int _rowCount = 1;
static const _kg = ErpUnit(
    code: 'KG',
    name: 'Kilogram',
    nameAr: 'كيلوجرام',
    precision: 3,
  );
  static const _meter = ErpUnit(
    code: 'M',
    name: 'Meter',
    nameAr: 'متر',
    precision: 3,
  );


  GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S18ManufacturingQualityPackScenario value) => switch (value) {
        S18ManufacturingQualityPackScenario.bom => 'Bill of Materials',
        S18ManufacturingQualityPackScenario.productionOrder => 'Production Order',
        S18ManufacturingQualityPackScenario.workOrder => 'Work Order',
        S18ManufacturingQualityPackScenario.jobCard => 'Job Card',
        S18ManufacturingQualityPackScenario.materialRequirement => 'Material Requirement',
        S18ManufacturingQualityPackScenario.materialIssue => 'Material Issue',
        S18ManufacturingQualityPackScenario.materialReturn => 'Material Return',
        S18ManufacturingQualityPackScenario.productionReceipt => 'Production Receipt',
        S18ManufacturingQualityPackScenario.routing => 'Routing / Traveler',
        S18ManufacturingQualityPackScenario.machineOperation => 'Machine Operation',
        S18ManufacturingQualityPackScenario.labor => 'Labor Report',
        S18ManufacturingQualityPackScenario.scrap => 'Scrap Report',
        S18ManufacturingQualityPackScenario.wip => 'Work in Progress',
        S18ManufacturingQualityPackScenario.variance => 'Production Variance',
        S18ManufacturingQualityPackScenario.qualityInspection => 'Quality Inspection',
        S18ManufacturingQualityPackScenario.incomingInspection => 'Incoming Inspection',
        S18ManufacturingQualityPackScenario.inProcessInspection => 'In-process Inspection',
        S18ManufacturingQualityPackScenario.finalInspection => 'Final Inspection',
        S18ManufacturingQualityPackScenario.ncr => 'NCR',
        S18ManufacturingQualityPackScenario.capa => 'CAPA',
        S18ManufacturingQualityPackScenario.coa => 'Certificate of Analysis',
        S18ManufacturingQualityPackScenario.qualityChecklist => 'Quality Checklist',
        S18ManufacturingQualityPackScenario.audit => 'Audit Form',
        S18ManufacturingQualityPackScenario.calibration => 'Calibration Record',
        S18ManufacturingQualityPackScenario.nestedTables => 'Nested Operation / Material Tables',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} renders with the real S18 API in '
      '${_rtl ? 'RTL' : 'LTR'} using $_rowCount prepared row(s). '
      'Technical Latin codes/SKU/machine/batch/serial values remain LTR, '
      'Arabic labels/descriptions follow RTL, multi-level hierarchy and mixed '
      'units remain intact, and long/multi-page tables do not overlap.';

  GeniusManufacturingMaterialNode _material(
    int index, {
    int? level,
  }) {
    final effectiveLevel = level ?? index % 4;
    return GeniusManufacturingMaterialNode(
      id: 'MAT-$index',
      itemCode: 'MAT-${(index + 1).toString().padLeft(5, '0')}',
      itemName: index == 0
          ? 'Very long technical material description CODE-AX9 for wrapping'
          : 'Material ${index + 1}',
      itemNameAr: index == 0
          ? 'وصف مادة فنية عربي طويل مع الرمز CODE-AX9 للتحقق من الالتفاف'
          : 'مادة ${index + 1}',
      quantity: 1.25 + index % 7,
      unit: index % 3 == 0
          ? _kg
          : index % 3 == 1
              ? _meter
              : ErpUnit.each,
      level: effectiveLevel,
      parentId: effectiveLevel == 0 ? null : 'MAT-${index ~/ 2}',
      scrapPercent: index % 5 == 0 ? 5 : 0,
      batch: ErpBatchInfo(
        batchNumber: 'BATCH-${index % 12}',
        expiryDate: DateTime(2027, 12, 31),
      ),
      serials: [
        ErpSerialInfo(
          serialNumber: 'SN-${100000 + index}',
        ),
      ],
      notes: 'Material traceability note ${index + 1}',
      notesAr: 'ملاحظة تتبع المادة ${index + 1}',
    );
  }

  GeniusManufacturingOperation _operation(int index) {
    final material = _material(index, level: 0);
    return GeniusManufacturingOperation(
      sequence: index + 1,
      code: 'OP-${(index + 1).toString().padLeft(4, '0')}',
      name: index == 0
          ? 'Very long routing operation with machine and setup instructions'
          : 'Operation ${index + 1}',
      nameAr: index == 0
          ? 'عملية تصنيع عربية طويلة مع تعليمات تشغيل وإعداد الآلة'
          : 'عملية ${index + 1}',
      plannedHours: 1.5 + index % 5,
      actualHours: 1.75 + index % 5,
      laborHours: 1.25 + index % 4,
      workCenter: 'WC-${index % 5}',
      machine: 'MC-${index % 8}',
      status: index % 7 == 0
          ? GeniusManufacturingStatus.inProgress
          : GeniusManufacturingStatus.planned,
      materials: [
        GeniusManufacturingMaterialRequirement(
          material: material,
          requiredQuantity: 2 + index % 4,
          issuedQuantity: 1 + index % 2,
          returnedQuantity: index % 6 == 0 ? 0.25 : 0,
        ),
      ],
      instructions:
          'Follow routing sequence, verify machine setup and record actual hours.',
      instructionsAr:
          'اتبع تسلسل التشغيل وتحقق من إعداد الآلة وسجل الساعات الفعلية.',
    );
  }

  GeniusProductionOrderData _order(int count) =>
      GeniusProductionOrderData(
        orderNumber: 'PROD-2026-001',
        productCode: 'FG-LATIN-001',
        productName: 'Finished Good with long technical name',
        productNameAr: 'منتج نهائي باسم فني عربي طويل',
        quantity: 500,
        actualQuantity: 325,
        unit: ErpUnit.each,
        plannedStart: DateTime(2026, 9, 1),
        plannedEnd: DateTime(2026, 9, 30),
        status: GeniusManufacturingStatus.inProgress,
        operations: List.generate(count, _operation),
        materials: List.generate(
          count,
          (index) => GeniusManufacturingMaterialRequirement(
            material: _material(index),
            requiredQuantity: 5 + index % 7,
            issuedQuantity: 4 + index % 5,
            returnedQuantity: index % 8 == 0 ? 0.5 : 0,
          ),
        ),
        batch: const ErpBatchInfo(
          batchNumber: 'FG-BATCH-001',
        ),
        serials: const [
          ErpSerialInfo(serialNumber: 'FG-SERIAL-001'),
        ],
        warehouse: 'WH-PRODUCTION',
        workCenter: 'WC-MAIN',
        notes:
            'Production order note with optional long content for pagination.',
        notesAr:
            'ملاحظة أمر إنتاج بمحتوى عربي طويل اختياري لاختبار ترقيم الصفحات.',
        signOffs: [
          GeniusQualitySignOff(
            role: 'Production Supervisor',
            roleAr: 'مشرف الإنتاج',
            name: 'Supervisor 01',
            nameAr: 'المشرف 01',
            signedAt: DateTime(2026, 9, 4, 9),
          ),
        ],
      );

  List<GeniusManufacturingMaterialMovement> _movements(int count) =>
      List.generate(
        count,
        (index) => GeniusManufacturingMaterialMovement(
          documentNumber: 'MAT-MOV-${index + 1}',
          date: DateTime(2026, 9, (index % 28) + 1),
          orderNumber: 'PROD-2026-${index % 5 + 1}',
          itemCode: 'MAT-${index + 1}',
          itemName: 'Movement Material ${index + 1}',
          itemNameAr: 'مادة حركة ${index + 1}',
          quantity: 1.25 + index % 5,
          unit: index.isEven ? _kg : ErpUnit.each,
          warehouse: 'WH-${index % 3 + 1}',
          location: 'LOC-${index % 20}',
          batch: ErpBatchInfo(
            batchNumber: 'BATCH-${index % 10}',
            expiryDate: DateTime(2027, 12, 31),
          ),
          serials: [
            ErpSerialInfo(
              serialNumber: 'SERIAL-${10000 + index}',
            ),
          ],
          notes: 'Movement note',
          notesAr: 'ملاحظة حركة',
        ),
      );

  GeniusQualityInspection _inspection(
    int count, {
    GeniusQualityInspectionStage stage =
        GeniusQualityInspectionStage.general,
  }) =>
      GeniusQualityInspection(
        inspectionNumber: 'QI-2026-001',
        date: DateTime(2026, 9, 4),
        subjectCode: 'ITEM-CODE-AX9',
        subjectName: 'Technical Finished Product',
        subjectNameAr: 'منتج فني نهائي',
        stage: stage,
        orderNumber: 'PROD-2026-001',
        supplier: stage == GeniusQualityInspectionStage.incoming
            ? 'Supplier International LLC'
            : null,
        supplierAr: stage == GeniusQualityInspectionStage.incoming
            ? 'المورد الدولي'
            : null,
        batch: const ErpBatchInfo(
          batchNumber: 'BATCH-QA-001',
        ),
        serials: const [
          ErpSerialInfo(serialNumber: 'SERIAL-QA-001'),
        ],
        checklist: List.generate(
          count,
          (index) => GeniusQualityChecklistItem(
            code: 'CHK-${index + 1}',
            label: index == 0
                ? 'Very long visual and functional quality checklist item'
                : 'Checklist item ${index + 1}',
            labelAr: index == 0
                ? 'بند تحقق جودة عربي طويل للفحص المرئي والوظيفي'
                : 'بند تحقق ${index + 1}',
            status: index % 9 == 0
                ? GeniusQualityStatus.warning
                : GeniusQualityStatus.pass,
            comment: index == 0
                ? 'Long comment intended to verify wrapping on multiple pages.'
                : null,
            commentAr: index == 0
                ? 'ملاحظة عربية طويلة للتحقق من التفاف النص عبر الصفحات.'
                : null,
          ),
        ),
        measurements: List.generate(
          count.clamp(1, 50).toInt(),
          (index) => GeniusQualityMeasurement(
            code: 'MEAS-${index + 1}',
            name: 'Dimension ${index + 1}',
            nameAr: 'بُعد ${index + 1}',
            value: 10 + (index % 5) * 0.1,
            specification: 'Nominal 10.0 mm',
            specificationAr: 'القيمة الاسمية 10.0 مم',
            minimum: 9.5,
            maximum: 10.5,
            unit: 'mm',
          ),
        ),
        signOffs: [
          GeniusQualitySignOff(
            role: 'Inspector',
            roleAr: 'المفتش',
            name: 'Inspector 01',
            nameAr: 'المفتش 01',
            signedAt: DateTime(2026, 9, 4, 12),
          ),
        ],
        notes: 'Quality inspection notes.',
        notesAr: 'ملاحظات فحص الجودة.',
      );

  Future<Uint8List> generate() async {
    const service = GeniusManufacturingQualityService();
    final config = _config;
    final count = _rowCount;
    final order = _order(count);
    final movements = _movements(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S18ManufacturingQualityPackScenario.bom:
        document = GeniusBillOfMaterialsDocument(
          config,
          report: service.billOfMaterials(
            List.generate(count, _material),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.productionOrder:
        document = GeniusProductionOrderDocument(
          config,
          report: service.productionOrder(order),
        );
        break;
      case S18ManufacturingQualityPackScenario.workOrder:
        document = GeniusWorkOrderDocument(
          config,
          report: service.workOrder(order),
        );
        break;
      case S18ManufacturingQualityPackScenario.jobCard:
        document = GeniusJobCardDocument(
          config,
          report: service.jobCard(order),
        );
        break;
      case S18ManufacturingQualityPackScenario.materialRequirement:
        document = GeniusMaterialRequirementDocument(
          config,
          report: service.materialRequirement(order.materials),
        );
        break;
      case S18ManufacturingQualityPackScenario.materialIssue:
        document = GeniusMaterialIssueDocument(
          config,
          report: service.materialIssue(movements),
        );
        break;
      case S18ManufacturingQualityPackScenario.materialReturn:
        document = GeniusMaterialReturnDocument(
          config,
          report: service.materialReturn(movements),
        );
        break;
      case S18ManufacturingQualityPackScenario.productionReceipt:
        document = GeniusProductionReceiptDocument(
          config,
          report: service.productionReceipt(movements),
        );
        break;
      case S18ManufacturingQualityPackScenario.routing:
        document = GeniusRoutingTravelerDocument(
          config,
          report: service.routingTraveler(order),
        );
        break;
      case S18ManufacturingQualityPackScenario.machineOperation:
        document = GeniusMachineOperationReportDocument(
          config,
          report: service.machineOperationReport(
            List.generate(
              count,
              (index) => GeniusManufacturingMachineEntry(
                date: DateTime(2026, 9, (index % 28) + 1),
                orderNumber: 'PROD-2026-${index % 5 + 1}',
                operationCode: 'OP-${index % 20 + 1}',
                machineCode: 'MC-${index % 8 + 1}',
                runHours: 5 + index % 4,
                setupHours: 0.5,
                downtimeHours: index % 10 == 0 ? 1.25 : 0,
                reason: index % 10 == 0
                    ? 'Preventive maintenance'
                    : null,
                reasonAr: index % 10 == 0
                    ? 'صيانة وقائية'
                    : null,
              ),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.labor:
        document = GeniusLaborReportDocument(
          config,
          report: service.laborReport(
            List.generate(
              count,
              (index) => GeniusManufacturingLaborEntry(
                date: DateTime(2026, 9, (index % 28) + 1),
                orderNumber: 'PROD-2026-${index % 5 + 1}',
                operationCode: 'OP-${index % 20 + 1}',
                employeeId: 'EMP-${index % 50 + 1}',
                employeeName: 'Operator ${index % 50 + 1}',
                employeeNameAr: 'مشغل ${index % 50 + 1}',
                hours: 7.5 + index % 3 * 0.25,
              ),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.scrap:
        document = GeniusScrapReportDocument(
          config,
          report: service.scrapReport(
            List.generate(
              count,
              (index) => GeniusManufacturingScrapEntry(
                date: DateTime(2026, 9, (index % 28) + 1),
                orderNumber: 'PROD-2026-${index % 5 + 1}',
                itemCode: 'MAT-${index + 1}',
                itemName: 'Scrap Item ${index + 1}',
                itemNameAr: 'صنف هالك ${index + 1}',
                quantity: 0.25 + index % 3,
                unit: _kg,
                reason: 'Dimensional defect',
                reasonAr: 'عيب أبعاد',
                batch: ErpBatchInfo(
                  batchNumber: 'BATCH-${index % 10}',
                ),
              ),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.wip:
        document = GeniusWorkInProgressDocument(
          config,
          report: service.workInProgress(
            List.generate(
              count,
              (index) => GeniusManufacturingWipEntry(
                orderNumber: 'PROD-${index + 1}',
                productCode: 'FG-${index + 1}',
                productName: 'Product ${index + 1}',
                productNameAr: 'منتج ${index + 1}',
                plannedQuantity: 100,
                completedQuantity: 25 + index % 75,
                currentOperation: 'Assembly OP-${index % 10}',
                currentOperationAr: 'تجميع OP-${index % 10}',
              ),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.variance:
        document = GeniusProductionVarianceDocument(
          config,
          report: service.productionVariance(
            List.generate(
              count,
              (index) => GeniusManufacturingVariance(
                orderNumber: 'PROD-${index % 5 + 1}',
                metric: 'Operation Hours ${index + 1}',
                metricAr: 'ساعات العملية ${index + 1}',
                planned: 10 + index % 5,
                actual: 11.25 + index % 6,
                unit: 'h',
              ),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.qualityInspection:
        document = GeniusQualityInspectionDocument(
          config,
          report: service.qualityInspection(
            _inspection(count),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.incomingInspection:
        document = GeniusIncomingInspectionDocument(
          config,
          report: service.incomingInspection(
            _inspection(
              count,
              stage: GeniusQualityInspectionStage.incoming,
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.inProcessInspection:
        document = GeniusInProcessInspectionDocument(
          config,
          report: service.inProcessInspection(
            _inspection(
              count,
              stage: GeniusQualityInspectionStage.inProcess,
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.finalInspection:
        document = GeniusFinalInspectionDocument(
          config,
          report: service.finalInspection(
            _inspection(
              count,
              stage: GeniusQualityInspectionStage.finalInspection,
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.ncr:
        document = GeniusNonConformanceReportDocument(
          config,
          report: service.nonConformanceReport(
            GeniusQualityNcr(
              ncrNumber: 'NCR-2026-001',
              date: DateTime(2026, 9, 4),
              subject: 'Out-of-tolerance dimension CODE-AX9',
              subjectAr: 'بُعد خارج التفاوت CODE-AX9',
              description:
                  'Measured dimension exceeded the approved upper tolerance.',
              descriptionAr:
                  'تجاوز القياس الحد الأعلى للتفاوت المعتمد.',
              orderNumber: 'PROD-2026-001',
              batch: const ErpBatchInfo(
                batchNumber: 'BATCH-QA-001',
              ),
              disposition: 'Rework and re-inspect',
              dispositionAr: 'إعادة تشغيل ثم إعادة الفحص',
              owner: 'Quality Manager',
              dueDate: DateTime(2026, 9, 10),
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.capa:
        document = GeniusCorrectivePreventiveActionDocument(
          config,
          report: service.correctivePreventiveAction(
            GeniusQualityCapa(
              capaNumber: 'CAPA-2026-001',
              date: DateTime(2026, 9, 4),
              problem: 'Repeated dimensional variation',
              problemAr: 'تكرار انحراف الأبعاد',
              rootCause: 'Fixture wear',
              rootCauseAr: 'تآكل أداة التثبيت',
              correctiveAction: 'Replace fixture and re-qualify',
              correctiveActionAr: 'استبدال أداة التثبيت وإعادة التأهيل',
              preventiveAction: 'Add periodic fixture inspection',
              preventiveActionAr: 'إضافة فحص دوري لأداة التثبيت',
              owner: 'Quality Manager',
              dueDate: DateTime(2026, 9, 30),
              signOffs: [
                GeniusQualitySignOff(
                  role: 'Quality Manager',
                  roleAr: 'مدير الجودة',
                  name: 'Manager 01',
                  nameAr: 'المدير 01',
                  signedAt: DateTime(2026, 9, 4, 14),
                ),
              ],
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.coa:
        document = GeniusCertificateOfAnalysisDocument(
          config,
          report: service.certificateOfAnalysis(
            GeniusQualityCoaData(
              certificateNumber: 'COA-2026-001',
              date: DateTime(2026, 9, 4),
              itemCode: 'FG-LATIN-001',
              itemName: 'Finished Technical Product',
              itemNameAr: 'منتج فني نهائي',
              batch: const ErpBatchInfo(
                batchNumber: 'BATCH-COA-001',
              ),
              manufacturingDate: DateTime(2026, 9, 1),
              expiryDate: DateTime(2027, 9, 1),
              results: List.generate(
                count.clamp(1, 100).toInt(),
                (index) => GeniusQualityCoaResult(
                  testCode: 'TEST-${index + 1}',
                  testName: 'Test ${index + 1}',
                  testNameAr: 'فحص ${index + 1}',
                  specification: 'SPEC-${index + 1}: 9.5–10.5',
                  specificationAr: 'المواصفة ${index + 1}: 9.5–10.5',
                  result: '10.${index % 5}',
                  status: GeniusQualityStatus.pass,
                ),
              ),
              signOffs: [
                GeniusQualitySignOff(
                  role: 'Laboratory',
                  roleAr: 'المختبر',
                  name: 'Lab Analyst',
                  nameAr: 'محلل المختبر',
                  signedAt: DateTime(2026, 9, 4, 15),
                ),
              ],
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.qualityChecklist:
        document = GeniusQualityChecklistDocument(
          config,
          report: service.qualityChecklist(
            _inspection(count).checklist,
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.audit:
        document = GeniusQualityAuditFormDocument(
          config,
          report: service.auditForm(
            GeniusQualityAuditData(
              auditNumber: 'AUD-2026-001',
              date: DateTime(2026, 9, 4),
              area: 'Production Line A',
              areaAr: 'خط الإنتاج أ',
              auditor: 'Internal Auditor',
              auditorAr: 'المدقق الداخلي',
              checklist: _inspection(count).checklist,
              notes:
                  'Audit uses the same checklist primitives as inspections.',
              notesAr:
                  'يستخدم التدقيق نفس مكونات قوائم التحقق المستخدمة في الفحص.',
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.calibration:
        document = GeniusCalibrationRecordDocument(
          config,
          report: service.calibrationRecord(
            GeniusQualityCalibrationRecord(
              recordNumber: 'CAL-2026-001',
              date: DateTime(2026, 9, 4),
              instrumentCode: 'CALIPER-AX9',
              instrumentName: 'Digital Caliper',
              instrumentNameAr: 'قدمة رقمية',
              result: GeniusQualityStatus.pass,
              standardReference: 'ISO-REF-AX9',
              nextDueDate: DateTime(2027, 3, 4),
              measurements: _inspection(count).measurements,
              signOffs: [
                GeniusQualitySignOff(
                  role: 'Calibration Technician',
                  roleAr: 'فني المعايرة',
                  name: 'Technician 01',
                  nameAr: 'الفني 01',
                  signedAt: DateTime(2026, 9, 4, 11),
                ),
              ],
            ),
          ),
        );
        break;
      case S18ManufacturingQualityPackScenario.nestedTables:
        document = GeniusManufacturingNestedTableDocument(
          config,
          data: service.nestedOperationMaterialTable(order),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }
}


Future<Uint8List> buildS18BomVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.bom,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18ProductionOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.productionOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18WorkOrderVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.workOrder,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18JobCardVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.jobCard,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18MaterialRequirementVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.materialRequirement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18MaterialIssueVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.materialIssue,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18MaterialReturnVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.materialReturn,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18ProductionReceiptVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.productionReceipt,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18RoutingVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.routing,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18MachineOperationVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.machineOperation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18LaborVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.labor,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18ScrapVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.scrap,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18WipVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.wip,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18VarianceVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.variance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18QualityInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.qualityInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18IncomingInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.incomingInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18InProcessInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.inProcessInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18FinalInspectionVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.finalInspection,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18NcrVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.ncr,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18CapaVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.capa,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18CoaVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.coa,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18QualityChecklistVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.qualityChecklist,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18AuditVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.audit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18CalibrationVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.calibration,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS18NestedTablesVerificationPdf(GeniusPdfConfig config) {
  final runner = S18ManufacturingQualityPackRunner(
    baseConfig: config,
    scenario: S18ManufacturingQualityPackScenario.nestedTables,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
