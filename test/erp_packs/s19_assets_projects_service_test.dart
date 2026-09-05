
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusFixedAsset asset({
  String tag = 'AST-LATIN-001',
  String? serial = 'SN-ABC-2026-001',
}) =>
    GeniusFixedAsset(
      assetId: 'ASSET-001',
      assetTag: tag,
      name: 'Production Machine',
      nameAr: 'آلة إنتاج',
      serialNumber: serial,
      category: 'Machinery',
      categoryAr: 'آلات',
      acquisitionDate: DateTime(2025, 1, 1),
      inServiceDate: DateTime(2025, 1, 1),
      acquisitionCost: ErpMoney.fromAmount(
        13000,
        currency: ErpCurrency.sar,
      ),
      residualValue: ErpMoney.fromAmount(
        1000,
        currency: ErpCurrency.sar,
      ),
      usefulLifeMonths: 24,
      location: 'PLANT-A',
      locationAr: 'المصنع أ',
      custodian: 'Engineer 01',
      custodianAr: 'المهندس 01',
    );

void main() {
  const service = GeniusAssetsProjectsService();

  test('asset tag and serial stay structured beside Arabic name', () {
    final report = service.assetRegister([asset()]);

    expect(report.rows.single.cells['tag'], 'AST-LATIN-001');
    expect(report.rows.single.cells['serial'], 'SN-ABC-2026-001');
    expect(
      report.rows.single.cells['name'],
      isA<GeniusErpPackLocalizedValue>(),
    );
  });

  test('asset label uses S11 structured label values', () {
    final label = service.assetLabelData(asset());

    expect(label.sku, 'AST-LATIN-001');
    expect(label.serial, 'SN-ABC-2026-001');
    expect(label.barcodeData, 'AST-LATIN-001');
    expect(label.titleAr, 'آلة إنتاج');
  });

  test('depreciation reconciles cost = accumulated + NBV', () {
    final result = service.calculateDepreciation(
      asset(),
      asOf: DateTime(2025, 12, 31),
    );

    expect(result.lines, hasLength(12));
    expect(result.accumulatedDepreciation.toDouble(), 6000);
    expect(result.netBookValue.toDouble(), 7000);
    expect(result.reconciles, isTrue);

    final report = service.depreciationReport([result]);
    expect(report.rows.single.cells['reconciles'], 'Yes');
  });

  test('depreciation respects residual floor after useful life', () {
    final result = service.calculateDepreciation(
      asset(),
      asOf: DateTime(2030, 1, 1),
    );

    expect(result.lines, hasLength(24));
    expect(result.netBookValue.toDouble(), 1000);
    expect(result.accumulatedDepreciation.toDouble(), 12000);
    expect(result.reconciles, isTrue);
  });

  test('multi-period project financials reconcile independently', () {
    final periods = service.projectFinancialsByPeriod(
      currency: ErpCurrency.sar,
      budgets: [
        GeniusProjectBudgetLine(
          projectCode: 'PRJ-AR-001',
          category: 'Labor',
          amount: ErpMoney.fromAmount(
            10000,
            currency: ErpCurrency.sar,
          ),
          period: '2026-08',
        ),
        GeniusProjectBudgetLine(
          projectCode: 'PRJ-AR-001',
          category: 'Labor',
          amount: ErpMoney.fromAmount(
            12000,
            currency: ErpCurrency.sar,
          ),
          period: '2026-09',
        ),
      ],
      costs: [
        GeniusProjectCostEntry(
          projectCode: 'PRJ-AR-001',
          date: DateTime(2026, 8, 15),
          reference: 'COST-001',
          category: 'Labor',
          amount: ErpMoney.fromAmount(
            7000,
            currency: ErpCurrency.sar,
          ),
        ),
        GeniusProjectCostEntry(
          projectCode: 'PRJ-AR-001',
          date: DateTime(2026, 9, 15),
          reference: 'COST-002',
          category: 'Labor',
          amount: ErpMoney.fromAmount(
            9000,
            currency: ErpCurrency.sar,
          ),
        ),
      ],
      billing: [
        GeniusProjectBillingEntry(
          projectCode: 'PRJ-AR-001',
          date: DateTime(2026, 8, 25),
          reference: 'INV-001',
          amount: ErpMoney.fromAmount(
            11000,
            currency: ErpCurrency.sar,
          ),
        ),
        GeniusProjectBillingEntry(
          projectCode: 'PRJ-AR-001',
          date: DateTime(2026, 9, 25),
          reference: 'INV-002',
          amount: ErpMoney.fromAmount(
            15000,
            currency: ErpCurrency.sar,
          ),
        ),
      ],
    );

    expect(periods, hasLength(2));
    expect(periods.first.period, '2026-08');
    expect(periods.first.profit.toDouble(), 4000);
    expect(periods.first.budgetVariance.toDouble(), 3000);
    expect(periods.last.profit.toDouble(), 6000);
  });

  test('long milestone notes are preserved for wrapping', () {
    final longNote = List.filled(
      80,
      'Long milestone narrative for wrapping and multi-page QA.',
    ).join(' ');
    final report = service.milestoneReport([
      GeniusProjectMilestone(
        projectCode: 'PRJ-ENG-2026-001',
        code: 'MS-LATIN-001',
        title: 'Commissioning',
        titleAr: 'التشغيل',
        dueDate: DateTime(2026, 12, 1),
        progressPercent: 75,
        notes: longNote,
        notesAr: List.filled(30, 'ملاحظة معلم عربية طويلة').join(' '),
      ),
    ]);

    final value =
        report.rows.single.cells['notes'] as GeniusErpPackLocalizedValue;
    expect(value.value, longNote);
    expect(value.valueAr, isNotEmpty);
  });

  test('Arabic project name never replaces structured project code', () {
    final report = service.projectSummary(
      GeniusProject(
        projectCode: 'PRJ-LATIN-AX9',
        name: 'ERP Upgrade',
        nameAr: 'ترقية نظام الموارد',
        startDate: DateTime(2026, 1, 1),
        currency: ErpCurrency.sar,
      ),
    );

    expect(report.subtitle, 'PRJ-LATIN-AX9');
    expect(
      report.details.any(
        (field) => field.value.contains('PRJ-LATIN-AX9'),
      ),
      isTrue,
    );
  });
}
