
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S18Scenario {
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

class S18ManufacturingQualityPackVerificationPage
    extends StatefulWidget {
  const S18ManufacturingQualityPackVerificationPage({super.key});

  @override
  State<S18ManufacturingQualityPackVerificationPage> createState() =>
      _S18ManufacturingQualityPackVerificationPageState();
}

class _S18ManufacturingQualityPackVerificationPageState
    extends State<S18ManufacturingQualityPackVerificationPage> {
  _S18Scenario _scenario = _S18Scenario.productionOrder;
  bool _rtl = false;
  int _rowCount = 1;
  late Future<Uint8List> _pdf;

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

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S18Scenario value) => switch (value) {
        _S18Scenario.bom => 'Bill of Materials',
        _S18Scenario.productionOrder => 'Production Order',
        _S18Scenario.workOrder => 'Work Order',
        _S18Scenario.jobCard => 'Job Card',
        _S18Scenario.materialRequirement => 'Material Requirement',
        _S18Scenario.materialIssue => 'Material Issue',
        _S18Scenario.materialReturn => 'Material Return',
        _S18Scenario.productionReceipt => 'Production Receipt',
        _S18Scenario.routing => 'Routing / Traveler',
        _S18Scenario.machineOperation => 'Machine Operation',
        _S18Scenario.labor => 'Labor Report',
        _S18Scenario.scrap => 'Scrap Report',
        _S18Scenario.wip => 'Work in Progress',
        _S18Scenario.variance => 'Production Variance',
        _S18Scenario.qualityInspection => 'Quality Inspection',
        _S18Scenario.incomingInspection => 'Incoming Inspection',
        _S18Scenario.inProcessInspection => 'In-process Inspection',
        _S18Scenario.finalInspection => 'Final Inspection',
        _S18Scenario.ncr => 'NCR',
        _S18Scenario.capa => 'CAPA',
        _S18Scenario.coa => 'Certificate of Analysis',
        _S18Scenario.qualityChecklist => 'Quality Checklist',
        _S18Scenario.audit => 'Audit Form',
        _S18Scenario.calibration => 'Calibration Record',
        _S18Scenario.nestedTables => 'Nested Operation / Material Tables',
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

  Future<Uint8List> _generate() async {
    const service = GeniusManufacturingQualityService();
    final config = _config;
    final count = _rowCount;
    final order = _order(count);
    final movements = _movements(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S18Scenario.bom:
        document = GeniusBillOfMaterialsDocument(
          config,
          report: service.billOfMaterials(
            List.generate(count, _material),
          ),
        );
        break;
      case _S18Scenario.productionOrder:
        document = GeniusProductionOrderDocument(
          config,
          report: service.productionOrder(order),
        );
        break;
      case _S18Scenario.workOrder:
        document = GeniusWorkOrderDocument(
          config,
          report: service.workOrder(order),
        );
        break;
      case _S18Scenario.jobCard:
        document = GeniusJobCardDocument(
          config,
          report: service.jobCard(order),
        );
        break;
      case _S18Scenario.materialRequirement:
        document = GeniusMaterialRequirementDocument(
          config,
          report: service.materialRequirement(order.materials),
        );
        break;
      case _S18Scenario.materialIssue:
        document = GeniusMaterialIssueDocument(
          config,
          report: service.materialIssue(movements),
        );
        break;
      case _S18Scenario.materialReturn:
        document = GeniusMaterialReturnDocument(
          config,
          report: service.materialReturn(movements),
        );
        break;
      case _S18Scenario.productionReceipt:
        document = GeniusProductionReceiptDocument(
          config,
          report: service.productionReceipt(movements),
        );
        break;
      case _S18Scenario.routing:
        document = GeniusRoutingTravelerDocument(
          config,
          report: service.routingTraveler(order),
        );
        break;
      case _S18Scenario.machineOperation:
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
      case _S18Scenario.labor:
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
      case _S18Scenario.scrap:
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
      case _S18Scenario.wip:
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
      case _S18Scenario.variance:
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
      case _S18Scenario.qualityInspection:
        document = GeniusQualityInspectionDocument(
          config,
          report: service.qualityInspection(
            _inspection(count),
          ),
        );
        break;
      case _S18Scenario.incomingInspection:
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
      case _S18Scenario.inProcessInspection:
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
      case _S18Scenario.finalInspection:
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
      case _S18Scenario.ncr:
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
      case _S18Scenario.capa:
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
      case _S18Scenario.coa:
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
      case _S18Scenario.qualityChecklist:
        document = GeniusQualityChecklistDocument(
          config,
          report: service.qualityChecklist(
            _inspection(count).checklist,
          ),
        );
        break;
      case _S18Scenario.audit:
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
      case _S18Scenario.calibration:
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
      case _S18Scenario.nestedTables:
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
                    'Sprint S18 — Manufacturing & Quality Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 330,
                        child: DropdownButtonFormField<_S18Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S18Scenario.values)
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
                          ButtonSegment(value: 500, label: Text('500')),
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
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's18_manufacturing_quality_pack.pdf',
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
