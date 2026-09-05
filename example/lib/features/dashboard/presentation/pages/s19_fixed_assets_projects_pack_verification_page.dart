
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S19Scenario {
  assetCard,
  assetRegister,
  assetLabel,
  assetTransfer,
  assetAssignment,
  assetReturn,
  assetDisposal,
  depreciation,
  assetMaintenance,
  assetCount,
  assetMovement,
  projectSummary,
  projectBudget,
  projectCost,
  projectProfitability,
  projectTimesheet,
  projectExpense,
  milestone,
  progress,
  completionCertificate,
  projectBilling,
  resourceUtilization,
  projectPurchasing,
  multiPeriodFinancials,
}

class S19FixedAssetsProjectsPackVerificationPage extends StatefulWidget {
  const S19FixedAssetsProjectsPackVerificationPage({super.key});

  @override
  State<S19FixedAssetsProjectsPackVerificationPage> createState() =>
      _S19FixedAssetsProjectsPackVerificationPageState();
}

class _S19FixedAssetsProjectsPackVerificationPageState
    extends State<S19FixedAssetsProjectsPackVerificationPage> {
  _S19Scenario _scenario = _S19Scenario.depreciation;
  bool _rtl = false;
  bool _compactSheet = false;
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

  String _label(_S19Scenario value) => switch (value) {
        _S19Scenario.assetCard => 'Asset Card',
        _S19Scenario.assetRegister => 'Asset Register',
        _S19Scenario.assetLabel => 'Asset Label',
        _S19Scenario.assetTransfer => 'Asset Transfer',
        _S19Scenario.assetAssignment => 'Asset Assignment',
        _S19Scenario.assetReturn => 'Asset Return',
        _S19Scenario.assetDisposal => 'Asset Disposal',
        _S19Scenario.depreciation => 'Depreciation Report',
        _S19Scenario.assetMaintenance => 'Asset Maintenance',
        _S19Scenario.assetCount => 'Asset Count',
        _S19Scenario.assetMovement => 'Asset Movement',
        _S19Scenario.projectSummary => 'Project Summary',
        _S19Scenario.projectBudget => 'Project Budget',
        _S19Scenario.projectCost => 'Project Cost',
        _S19Scenario.projectProfitability => 'Project Profitability',
        _S19Scenario.projectTimesheet => 'Project Timesheet',
        _S19Scenario.projectExpense => 'Project Expense',
        _S19Scenario.milestone => 'Milestone Report',
        _S19Scenario.progress => 'Progress Report',
        _S19Scenario.completionCertificate => 'Completion Certificate',
        _S19Scenario.projectBilling => 'Project Billing',
        _S19Scenario.resourceUtilization => 'Resource Utilization',
        _S19Scenario.projectPurchasing => 'Project Purchasing',
        _S19Scenario.multiPeriodFinancials => 'Multi-period Financials',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S19 public API in '
      '${_rtl ? 'RTL' : 'LTR'}. Asset tags, serials and project codes remain '
      'structured Latin runs. Arabic names/locations follow RTL. '
      'Long/multi-page rows do not overlap. Depreciation reconciles '
      'cost = accumulated depreciation + NBV. '
      '${_scenario == _S19Scenario.assetLabel ? (_compactSheet ? 'A compact label sheet is used.' : 'A durable single-label profile is used.') : ''}';

  GeniusFixedAsset _asset(int index) => GeniusFixedAsset(
        assetId: 'ASSET-${index + 1}',
        assetTag: 'AST-${(index + 1).toString().padLeft(6, '0')}',
        name: index == 0
            ? 'Industrial Production Machine with long model description'
            : 'Asset ${index + 1}',
        nameAr: index == 0
            ? 'آلة إنتاج صناعية باسم ووصف طويل'
            : 'الأصل ${index + 1}',
        serialNumber: 'SN-LATIN-${100000 + index}',
        category: 'Machinery',
        categoryAr: 'آلات',
        acquisitionDate: DateTime(2024 + index % 2, 1, 1),
        inServiceDate: DateTime(2024 + index % 2, 2, 1),
        acquisitionCost: ErpMoney.fromAmount(
          12000 + index * 25,
          currency: ErpCurrency.sar,
        ),
        residualValue: ErpMoney.fromAmount(
          1000,
          currency: ErpCurrency.sar,
        ),
        usefulLifeMonths: 60,
        location: 'PLANT-${index % 4 + 1}',
        locationAr: 'المصنع ${index % 4 + 1}',
        department: 'Operations',
        departmentAr: 'العمليات',
        custodian: 'Custodian ${index % 20 + 1}',
        custodianAr: 'مسؤول العهدة ${index % 20 + 1}',
        manufacturer: 'Genius Industrial',
        model: 'MODEL-AX9-${index % 5}',
        notes: index == 0
            ? 'Optional asset note used to verify long text wrapping.'
            : null,
        notesAr: index == 0
            ? 'ملاحظة أصل عربية اختيارية للتحقق من التفاف النص.'
            : null,
      );

  GeniusAssetMovement _movement(
    GeniusAssetMovementKind kind,
    int index,
  ) =>
      GeniusAssetMovement(
        reference: 'MOV-${kind.name.toUpperCase()}-${index + 1}',
        asset: _asset(index),
        date: DateTime(2026, 9, (index % 28) + 1),
        kind: kind,
        fromLocation: 'WH-A',
        fromLocationAr: 'المستودع أ',
        toLocation: 'SITE-B',
        toLocationAr: 'الموقع ب',
        fromCustodian: 'Custodian A',
        fromCustodianAr: 'مسؤول العهدة أ',
        toCustodian: 'Custodian B',
        toCustodianAr: 'مسؤول العهدة ب',
        reason: 'Operational reassignment',
        reasonAr: 'إعادة توزيع تشغيلي',
        disposalProceeds:
            kind == GeniusAssetMovementKind.disposal
                ? ErpMoney.fromAmount(
                    2500,
                    currency: ErpCurrency.sar,
                  )
                : null,
        notes: 'Movement note ${index + 1}',
        notesAr: 'ملاحظة حركة ${index + 1}',
      );

  GeniusProject _project() => GeniusProject(
        projectCode: 'PRJ-LATIN-ERP-2026-001',
        name: 'Enterprise ERP Transformation Program',
        nameAr: 'برنامج التحول لنظام موارد المؤسسة',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        currency: ErpCurrency.sar,
        customer: 'Genius Customer',
        customerAr: 'عميل جينيس',
        manager: 'Project Manager',
        managerAr: 'مدير المشروع',
        description:
            'A bilingual project used to verify structured codes, long financial reports and multi-period calculations.',
        descriptionAr:
            'مشروع ثنائي اللغة للتحقق من الرموز والبيانات المالية متعددة الفترات.',
      );

  List<GeniusProjectBudgetLine> _budgets(int count) => List.generate(
        count,
        (index) => GeniusProjectBudgetLine(
          projectCode: _project().projectCode,
          category: 'Budget Category ${index % 8 + 1}',
          categoryAr: 'فئة ميزانية ${index % 8 + 1}',
          amount: ErpMoney.fromAmount(
            1000 + index * 10,
            currency: ErpCurrency.sar,
          ),
          period:
              '2026-${((index % 12) + 1).toString().padLeft(2, '0')}',
        ),
      );

  List<GeniusProjectCostEntry> _costs(int count) => List.generate(
        count,
        (index) => GeniusProjectCostEntry(
          projectCode: _project().projectCode,
          date: DateTime(2026, index % 12 + 1, index % 28 + 1),
          reference: 'COST-${index + 1}',
          category: 'Implementation',
          categoryAr: 'تنفيذ',
          amount: ErpMoney.fromAmount(
            700 + index * 8,
            currency: ErpCurrency.sar,
          ),
          vendor: 'Vendor ${index % 5 + 1}',
          vendorAr: 'المورد ${index % 5 + 1}',
          description: index == 0
              ? 'Long project cost description intended to wrap cleanly across a DataGrid cell.'
              : 'Project cost ${index + 1}',
          descriptionAr: index == 0
              ? 'وصف تكلفة مشروع عربي طويل للتحقق من التفاف النص داخل الجدول.'
              : 'تكلفة مشروع ${index + 1}',
        ),
      );

  List<GeniusProjectBillingEntry> _billing(int count) => List.generate(
        count,
        (index) => GeniusProjectBillingEntry(
          projectCode: _project().projectCode,
          date: DateTime(2026, index % 12 + 1, 20),
          reference: 'INV-PROJ-${index + 1}',
          amount: ErpMoney.fromAmount(
            1200 + index * 12,
            currency: ErpCurrency.sar,
          ),
          customer: 'Genius Customer',
          customerAr: 'عميل جينيس',
          description: 'Milestone billing ${index + 1}',
          descriptionAr: 'فوترة معلم ${index + 1}',
        ),
      );

  Future<Uint8List> _generate() async {
    const service = GeniusAssetsProjectsService();
    final config = _config;
    final count = _rowCount;
    final assets = List.generate(count, _asset);
    final project = _project();
    final budgets = _budgets(count);
    final costs = _costs(count);
    final billing = _billing(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S19Scenario.assetCard:
        document = GeniusAssetCardDocument(
          config,
          report: service.assetCard(assets.first),
        );
        break;
      case _S19Scenario.assetRegister:
        document = GeniusAssetRegisterDocument(
          config,
          report: service.assetRegister(assets),
        );
        break;
      case _S19Scenario.assetLabel:
        document = GeniusAssetLabelDocument(
          config: config,
          profile: _compactSheet
              ? GeniusAssetLabelProfiles.compactSheet()
              : GeniusAssetLabelProfiles.durableSingle(),
          assets: assets,
        );
        break;
      case _S19Scenario.assetTransfer:
        document = GeniusAssetTransferDocument(
          config,
          report: service.assetTransfer(
            _movement(GeniusAssetMovementKind.transfer, 0),
          ),
        );
        break;
      case _S19Scenario.assetAssignment:
        document = GeniusAssetAssignmentDocument(
          config,
          report: service.assetAssignment(
            _movement(GeniusAssetMovementKind.assignment, 0),
          ),
        );
        break;
      case _S19Scenario.assetReturn:
        document = GeniusAssetReturnDocument(
          config,
          report: service.assetReturn(
            _movement(GeniusAssetMovementKind.returnToStore, 0),
          ),
        );
        break;
      case _S19Scenario.assetDisposal:
        document = GeniusAssetDisposalDocument(
          config,
          report: service.assetDisposal(
            _movement(GeniusAssetMovementKind.disposal, 0),
          ),
        );
        break;
      case _S19Scenario.depreciation:
        final results = [
          for (final asset in assets)
            service.calculateDepreciation(
              asset,
              asOf: DateTime(2026, 9, 30),
            ),
        ];
        document = GeniusAssetDepreciationReportDocument(
          config,
          report: service.depreciationReport(results),
        );
        break;
      case _S19Scenario.assetMaintenance:
        document = GeniusAssetMaintenanceReportDocument(
          config,
          report: service.assetMaintenanceReport(
            List.generate(
              count,
              (index) => GeniusAssetMaintenanceEntry(
                reference: 'MNT-${index + 1}',
                asset: assets[index],
                date: DateTime(2026, 9, index % 28 + 1),
                description: 'Preventive maintenance ${index + 1}',
                descriptionAr: 'صيانة وقائية ${index + 1}',
                vendor: 'Maintenance Vendor',
                vendorAr: 'مورد الصيانة',
                cost: ErpMoney.fromAmount(
                  250 + index,
                  currency: ErpCurrency.sar,
                ),
                nextDueDate: DateTime(2027, 3, 1),
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.assetCount:
        document = GeniusAssetCountDocument(
          config,
          report: service.assetCount(
            List.generate(
              count,
              (index) => GeniusAssetCountEntry(
                asset: assets[index],
                countedAt: DateTime(2026, 9, 4, 10),
                found: index % 12 != 0,
                location: 'COUNT-ZONE-${index % 4 + 1}',
                locationAr: 'منطقة الجرد ${index % 4 + 1}',
                condition: index % 5 == 0 ? 'Needs Service' : 'Good',
                conditionAr: index % 5 == 0 ? 'يحتاج صيانة' : 'جيد',
                countedBy: 'Counter 01',
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.assetMovement:
        document = GeniusAssetMovementReportDocument(
          config,
          report: service.assetMovementReport(
            List.generate(
              count,
              (index) => _movement(
                GeniusAssetMovementKind.values[
                    index % GeniusAssetMovementKind.values.length],
                index,
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.projectSummary:
        document = GeniusProjectSummaryDocument(
          config,
          report: service.projectSummary(project),
        );
        break;
      case _S19Scenario.projectBudget:
        document = GeniusProjectBudgetDocument(
          config,
          report: service.projectBudget(budgets),
        );
        break;
      case _S19Scenario.projectCost:
        document = GeniusProjectCostDocument(
          config,
          report: service.projectCost(costs),
        );
        break;
      case _S19Scenario.projectProfitability:
        document = GeniusProjectProfitabilityDocument(
          config,
          report: service.projectProfitability(
            costs: costs,
            billing: billing,
          ),
        );
        break;
      case _S19Scenario.projectTimesheet:
        document = GeniusProjectTimesheetDocument(
          config,
          report: service.projectTimesheet(
            List.generate(
              count,
              (index) => GeniusProjectTimesheetEntry(
                projectCode: project.projectCode,
                date: DateTime(2026, 9, index % 28 + 1),
                resourceId: 'RES-${index % 25 + 1}',
                resourceName: 'Consultant ${index % 25 + 1}',
                resourceNameAr: 'مستشار ${index % 25 + 1}',
                hours: 7.5 + (index % 4) * 0.25,
                task: 'Implementation Work ${index + 1}',
                taskAr: 'أعمال تنفيذ ${index + 1}',
                hourlyCost: ErpMoney.fromAmount(
                  150,
                  currency: ErpCurrency.sar,
                ),
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.projectExpense:
        document = GeniusProjectExpenseReportDocument(
          config,
          report: service.projectExpenseReport(
            List.generate(
              count,
              (index) => GeniusProjectExpenseEntry(
                projectCode: project.projectCode,
                date: DateTime(2026, 9, index % 28 + 1),
                reference: 'EXP-${index + 1}',
                description: 'Project expense ${index + 1}',
                descriptionAr: 'مصروف مشروع ${index + 1}',
                amount: ErpMoney.fromAmount(
                  100 + index,
                  currency: ErpCurrency.sar,
                ),
                employee: 'Employee ${index % 20 + 1}',
                employeeAr: 'الموظف ${index % 20 + 1}',
                approved: index % 9 != 0,
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.milestone:
        document = GeniusProjectMilestoneReportDocument(
          config,
          report: service.milestoneReport(
            List.generate(
              count,
              (index) => GeniusProjectMilestone(
                projectCode: project.projectCode,
                code: 'MS-${index + 1}',
                title: 'Milestone ${index + 1}',
                titleAr: 'المعلم ${index + 1}',
                dueDate: DateTime(2026, index % 12 + 1, 20),
                progressPercent: (index % 11) * 10,
                notes: index == 0
                    ? List.filled(
                        20,
                        'Long milestone notes for wrapping verification.',
                      ).join(' ')
                    : 'Milestone note',
                notesAr: index == 0
                    ? List.filled(20, 'ملاحظات معلم عربية طويلة للتحقق من التفاف النص').join(' ')
                    : 'ملاحظة معلم',
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.progress:
        document = GeniusProjectProgressReportDocument(
          config,
          report: service.progressReport(
            List.generate(
              count,
              (index) => GeniusProjectProgressEntry(
                projectCode: project.projectCode,
                date: DateTime(2026, 9, index % 28 + 1),
                progressPercent: (index % 101).toDouble(),
                summary: 'Progress summary ${index + 1}',
                summaryAr: 'ملخص التقدم ${index + 1}',
                risks: 'Risk ${index % 5 + 1}',
                risksAr: 'مخاطرة ${index % 5 + 1}',
                nextSteps: 'Next step ${index + 1}',
                nextStepsAr: 'الخطوة القادمة ${index + 1}',
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.completionCertificate:
        document = GeniusProjectCompletionCertificateDocument(
          config,
          report: service.completionCertificate(
            project,
            completionDate: DateTime(2026, 12, 31),
            completionReference: 'CERT-PRJ-2026-001',
          ),
        );
        break;
      case _S19Scenario.projectBilling:
        document = GeniusProjectBillingDocument(
          config,
          report: service.projectBilling(billing),
        );
        break;
      case _S19Scenario.resourceUtilization:
        document = GeniusProjectResourceUtilizationDocument(
          config,
          report: service.resourceUtilization(
            List.generate(
              count,
              (index) => GeniusProjectResourceUtilization(
                projectCode: project.projectCode,
                resourceId: 'RES-${index + 1}',
                resourceName: 'Resource ${index + 1}',
                resourceNameAr: 'المورد ${index + 1}',
                availableHours: index == 0 ? 0 : 160,
                usedHours: index == 0 ? 0 : 120 + index % 30,
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.projectPurchasing:
        document = GeniusProjectPurchasingReportDocument(
          config,
          report: service.projectPurchasingReport(
            List.generate(
              count,
              (index) => GeniusProjectPurchaseEntry(
                projectCode: project.projectCode,
                date: DateTime(2026, 9, index % 28 + 1),
                reference: 'PO-PRJ-${index + 1}',
                supplier: 'Supplier ${index % 8 + 1}',
                supplierAr: 'المورد ${index % 8 + 1}',
                amount: ErpMoney.fromAmount(
                  500 + index * 5,
                  currency: ErpCurrency.sar,
                ),
                description: 'Project purchase ${index + 1}',
                descriptionAr: 'شراء للمشروع ${index + 1}',
              ),
            ),
          ),
        );
        break;
      case _S19Scenario.multiPeriodFinancials:
        final periods = service.projectFinancialsByPeriod(
          currency: ErpCurrency.sar,
          budgets: budgets,
          costs: costs,
          billing: billing,
        );
        document = GeniusProjectMultiPeriodFinancialDocument(
          config,
          report: service.multiPeriodProjectFinancials(periods),
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
                    'Sprint S19 — Fixed Assets & Projects Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: DropdownButtonFormField<_S19Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S19Scenario.values)
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
                        label: const Text('Compact label sheet'),
                        selected: _compactSheet,
                        onSelected: (value) {
                          _compactSheet = value;
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
                        fileName: 's19_fixed_assets_projects_pack.pdf',
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
