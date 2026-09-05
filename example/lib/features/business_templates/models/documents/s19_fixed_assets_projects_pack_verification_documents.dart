// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S19FixedAssetsProjectsPackVerificationPage.
enum S19FixedAssetsProjectsPackScenario {
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

/// Executes one focused S19 verification scenario.
class S19FixedAssetsProjectsPackRunner {
  S19FixedAssetsProjectsPackRunner({
    required GeniusPdfConfig baseConfig,
    required S19FixedAssetsProjectsPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S19FixedAssetsProjectsPackScenario _scenario;
bool _rtl = false;
  final bool _compactSheet = false;
  final int _rowCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S19FixedAssetsProjectsPackScenario value) => switch (value) {
        S19FixedAssetsProjectsPackScenario.assetCard => 'Asset Card',
        S19FixedAssetsProjectsPackScenario.assetRegister => 'Asset Register',
        S19FixedAssetsProjectsPackScenario.assetLabel => 'Asset Label',
        S19FixedAssetsProjectsPackScenario.assetTransfer => 'Asset Transfer',
        S19FixedAssetsProjectsPackScenario.assetAssignment => 'Asset Assignment',
        S19FixedAssetsProjectsPackScenario.assetReturn => 'Asset Return',
        S19FixedAssetsProjectsPackScenario.assetDisposal => 'Asset Disposal',
        S19FixedAssetsProjectsPackScenario.depreciation => 'Depreciation Report',
        S19FixedAssetsProjectsPackScenario.assetMaintenance => 'Asset Maintenance',
        S19FixedAssetsProjectsPackScenario.assetCount => 'Asset Count',
        S19FixedAssetsProjectsPackScenario.assetMovement => 'Asset Movement',
        S19FixedAssetsProjectsPackScenario.projectSummary => 'Project Summary',
        S19FixedAssetsProjectsPackScenario.projectBudget => 'Project Budget',
        S19FixedAssetsProjectsPackScenario.projectCost => 'Project Cost',
        S19FixedAssetsProjectsPackScenario.projectProfitability => 'Project Profitability',
        S19FixedAssetsProjectsPackScenario.projectTimesheet => 'Project Timesheet',
        S19FixedAssetsProjectsPackScenario.projectExpense => 'Project Expense',
        S19FixedAssetsProjectsPackScenario.milestone => 'Milestone Report',
        S19FixedAssetsProjectsPackScenario.progress => 'Progress Report',
        S19FixedAssetsProjectsPackScenario.completionCertificate => 'Completion Certificate',
        S19FixedAssetsProjectsPackScenario.projectBilling => 'Project Billing',
        S19FixedAssetsProjectsPackScenario.resourceUtilization => 'Resource Utilization',
        S19FixedAssetsProjectsPackScenario.projectPurchasing => 'Project Purchasing',
        S19FixedAssetsProjectsPackScenario.multiPeriodFinancials => 'Multi-period Financials',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S19 public API in '
      '${_rtl ? 'RTL' : 'LTR'}. Asset tags, serials and project codes remain '
      'structured Latin runs. Arabic names/locations follow RTL. '
      'Long/multi-page rows do not overlap. Depreciation reconciles '
      'cost = accumulated depreciation + NBV. '
      '${_scenario == S19FixedAssetsProjectsPackScenario.assetLabel ? (_compactSheet ? 'A compact label sheet is used.' : 'A durable single-label profile is used.') : ''}';

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

  Future<Uint8List> generate() async {
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
      case S19FixedAssetsProjectsPackScenario.assetCard:
        document = GeniusAssetCardDocument(
          config,
          report: service.assetCard(assets.first),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetRegister:
        document = GeniusAssetRegisterDocument(
          config,
          report: service.assetRegister(assets),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetLabel:
        document = GeniusAssetLabelDocument(
          config: config,
          profile: _compactSheet
              ? GeniusAssetLabelProfiles.compactSheet()
              : GeniusAssetLabelProfiles.durableSingle(),
          assets: assets,
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetTransfer:
        document = GeniusAssetTransferDocument(
          config,
          report: service.assetTransfer(
            _movement(GeniusAssetMovementKind.transfer, 0),
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetAssignment:
        document = GeniusAssetAssignmentDocument(
          config,
          report: service.assetAssignment(
            _movement(GeniusAssetMovementKind.assignment, 0),
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetReturn:
        document = GeniusAssetReturnDocument(
          config,
          report: service.assetReturn(
            _movement(GeniusAssetMovementKind.returnToStore, 0),
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.assetDisposal:
        document = GeniusAssetDisposalDocument(
          config,
          report: service.assetDisposal(
            _movement(GeniusAssetMovementKind.disposal, 0),
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.depreciation:
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
      case S19FixedAssetsProjectsPackScenario.assetMaintenance:
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
      case S19FixedAssetsProjectsPackScenario.assetCount:
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
      case S19FixedAssetsProjectsPackScenario.assetMovement:
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
      case S19FixedAssetsProjectsPackScenario.projectSummary:
        document = GeniusProjectSummaryDocument(
          config,
          report: service.projectSummary(project),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.projectBudget:
        document = GeniusProjectBudgetDocument(
          config,
          report: service.projectBudget(budgets),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.projectCost:
        document = GeniusProjectCostDocument(
          config,
          report: service.projectCost(costs),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.projectProfitability:
        document = GeniusProjectProfitabilityDocument(
          config,
          report: service.projectProfitability(
            costs: costs,
            billing: billing,
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.projectTimesheet:
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
      case S19FixedAssetsProjectsPackScenario.projectExpense:
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
      case S19FixedAssetsProjectsPackScenario.milestone:
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
      case S19FixedAssetsProjectsPackScenario.progress:
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
      case S19FixedAssetsProjectsPackScenario.completionCertificate:
        document = GeniusProjectCompletionCertificateDocument(
          config,
          report: service.completionCertificate(
            project,
            completionDate: DateTime(2026, 12, 31),
            completionReference: 'CERT-PRJ-2026-001',
          ),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.projectBilling:
        document = GeniusProjectBillingDocument(
          config,
          report: service.projectBilling(billing),
        );
        break;
      case S19FixedAssetsProjectsPackScenario.resourceUtilization:
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
      case S19FixedAssetsProjectsPackScenario.projectPurchasing:
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
      case S19FixedAssetsProjectsPackScenario.multiPeriodFinancials:
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
}


Future<Uint8List> buildS19AssetCardVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetCard,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetRegisterVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetRegister,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetTransferVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetTransfer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetAssignmentVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetAssignment,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetReturnVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetReturn,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetDisposalVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetDisposal,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19DepreciationVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.depreciation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetMaintenanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetMaintenance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetCountVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetCount,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19AssetMovementVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.assetMovement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectBudgetVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectBudget,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectCostVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectCost,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectProfitabilityVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectProfitability,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectTimesheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectTimesheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectExpenseVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectExpense,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19MilestoneVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.milestone,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProgressVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.progress,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19CompletionCertificateVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.completionCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectBillingVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectBilling,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ResourceUtilizationVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.resourceUtilization,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19ProjectPurchasingVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.projectPurchasing,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS19MultiPeriodFinancialsVerificationPdf(GeniusPdfConfig config) {
  final runner = S19FixedAssetsProjectsPackRunner(
    baseConfig: config,
    scenario: S19FixedAssetsProjectsPackScenario.multiPeriodFinancials,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
