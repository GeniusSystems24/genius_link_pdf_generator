
import '../../../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';
import '../../../../infrastructure/printing/profiles/print_profiles.dart';
import '../shared/erp_pack_shared.dart';
import 'asset_models.dart';
import 'project_models.dart';

/// Standard Asset-label profiles layered over the S11 profile engine.
class GeniusAssetLabelProfiles {
  const GeniusAssetLabelProfiles._();

  /// Durable single 70×35mm asset tag.
  static GeniusPdfPrintProfile durableSingle() =>
      GeniusPdfPrintProfile.customLabel(
        width: 70 * GeniusPdfPrintProfile.pointsPerMillimeter,
        height: 35 * GeniusPdfPrintProfile.pointsPerMillimeter,
      );

  /// A4 sheet of 3×8 compact labels.
  static GeniusPdfPrintProfile compactSheet() =>
      GeniusPdfPrintProfile.labelSheet(
        columns: 3,
        rows: 8,
        labelWidth: 63 * GeniusPdfPrintProfile.pointsPerMillimeter,
        labelHeight: 32 * GeniusPdfPrintProfile.pointsPerMillimeter,
        horizontalGap: 2 * GeniusPdfPrintProfile.pointsPerMillimeter,
        verticalGap: 1 * GeniusPdfPrintProfile.pointsPerMillimeter,
      );
}

/// Fixed Assets + Projects preparation/calculation service for Sprint S19.
///
/// PDF document classes only consume the reports returned by this service.
/// Depreciation/project financial calculations never run inside rendering code.
class GeniusAssetsProjectsService {
  const GeniusAssetsProjectsService();

  GeniusErpPackReportData assetCard(
    GeniusFixedAsset asset,
  ) {
    return GeniusErpPackReportData(
      title: 'Asset Card',
      titleAr: 'بطاقة أصل',
      subtitle: asset.assetTag,
      subtitleAr: asset.assetTag,
      details: [
        _field('Asset ID', 'رقم الأصل', asset.assetId),
        _field('Asset Tag', 'وسم الأصل', asset.assetTag),
        _field(
          'Name',
          'الاسم',
          asset.name,
          valueAr: asset.nameAr,
        ),
        if (asset.serialNumber != null)
          _field(
            'Serial Number',
            'الرقم التسلسلي',
            asset.serialNumber!,
          ),
        if (asset.category != null)
          _field(
            'Category',
            'الفئة',
            asset.category!,
            valueAr: asset.categoryAr,
          ),
        _field(
          'Acquisition Date',
          'تاريخ الاقتناء',
          _date(asset.acquisitionDate),
        ),
        _field(
          'In Service',
          'تاريخ بدء الاستخدام',
          _date(asset.inServiceDate),
        ),
        _field(
          'Acquisition Cost',
          'تكلفة الاقتناء',
          _money(asset.acquisitionCost),
        ),
        _field(
          'Residual Value',
          'القيمة المتبقية',
          _money(asset.residualValue),
        ),
        _field(
          'Useful Life (months)',
          'العمر الإنتاجي (شهر)',
          asset.usefulLifeMonths.toString(),
        ),
        if (asset.location != null)
          _field(
            'Location',
            'الموقع',
            asset.location!,
            valueAr: asset.locationAr,
          ),
        if (asset.department != null)
          _field(
            'Department',
            'القسم',
            asset.department!,
            valueAr: asset.departmentAr,
          ),
        if (asset.custodian != null)
          _field(
            'Custodian',
            'العهدة',
            asset.custodian!,
            valueAr: asset.custodianAr,
          ),
        _field('Status', 'الحالة', asset.status.name),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'property',
          title: 'Property',
          titleAr: 'الخاصية',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Value',
          titleAr: 'القيمة',
          flexFactor: 3,
        ),
      ],
      rows: [
        if (asset.manufacturer != null)
          GeniusErpPackReportRow(
            cells: {
              'property': 'Manufacturer',
              'value': asset.manufacturer,
            },
          ),
        if (asset.model != null)
          GeniusErpPackReportRow(
            cells: {
              'property': 'Model',
              'value': asset.model,
            },
          ),
      ],
      notes: asset.notes,
      notesAr: asset.notesAr,
    );
  }

  GeniusErpPackReportData assetRegister(
    List<GeniusFixedAsset> assets,
  ) {
    return GeniusErpPackReportData(
      title: 'Asset Register',
      titleAr: 'سجل الأصول',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'tag',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Asset',
          titleAr: 'الأصل',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'serial',
          title: 'Serial',
          titleAr: 'التسلسلي',
        ),
        GeniusErpPackReportColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'الفئة',
        ),
        GeniusErpPackReportColumn(
          id: 'location',
          title: 'Location',
          titleAr: 'الموقع',
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final asset in assets)
          GeniusErpPackReportRow(
            cells: {
              // Tag and serial remain independent structured runs.
              'tag': asset.assetTag,
              'name': GeniusErpPackLocalizedValue(
                value: asset.name,
                valueAr: asset.nameAr,
              ),
              'serial': asset.serialNumber ?? '',
              'category': GeniusErpPackLocalizedValue(
                value: asset.category ?? '',
                valueAr: asset.categoryAr,
              ),
              'location': GeniusErpPackLocalizedValue(
                value: asset.location ?? '',
                valueAr: asset.locationAr,
              ),
              'cost': asset.acquisitionCost.toDouble(),
              'status': asset.status.name,
            },
          ),
      ],
    );
  }

  /// S19-T03/T24/T25 — maps Asset data to the S11 label engine.
  GeniusPdfLabelData assetLabelData(
    GeniusFixedAsset asset,
  ) =>
      GeniusPdfLabelData(
        title: asset.name,
        titleAr: asset.nameAr,
        sku: asset.assetTag,
        serial: asset.serialNumber,
        barcodeData: asset.assetTag,
        qrData: 'asset:${asset.assetId};tag:${asset.assetTag}',
        customFields: {
          if (asset.category != null) 'Category': asset.category!,
          if (asset.location != null) 'Location': asset.location!,
          if (asset.custodian != null) 'Custodian': asset.custodian!,
        },
      );

  GeniusErpPackReportData assetMovement(
    GeniusAssetMovement movement,
  ) {
    final title = switch (movement.kind) {
      GeniusAssetMovementKind.transfer => 'Asset Transfer',
      GeniusAssetMovementKind.assignment => 'Asset Assignment',
      GeniusAssetMovementKind.returnToStore => 'Asset Return',
      GeniusAssetMovementKind.disposal => 'Asset Disposal',
      GeniusAssetMovementKind.countAdjustment => 'Asset Count Adjustment',
      GeniusAssetMovementKind.maintenance => 'Asset Maintenance Movement',
      GeniusAssetMovementKind.acquisition => 'Asset Acquisition',
    };
    final titleAr = switch (movement.kind) {
      GeniusAssetMovementKind.transfer => 'نقل أصل',
      GeniusAssetMovementKind.assignment => 'تسليم أصل',
      GeniusAssetMovementKind.returnToStore => 'إرجاع أصل',
      GeniusAssetMovementKind.disposal => 'استبعاد أصل',
      GeniusAssetMovementKind.countAdjustment => 'تسوية جرد أصل',
      GeniusAssetMovementKind.maintenance => 'حركة صيانة أصل',
      GeniusAssetMovementKind.acquisition => 'اقتناء أصل',
    };

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle: movement.reference,
      subtitleAr: movement.reference,
      details: [
        _field('Date', 'التاريخ', _date(movement.date)),
        _field('Asset Tag', 'وسم الأصل', movement.asset.assetTag),
        _field(
          'Asset',
          'الأصل',
          movement.asset.name,
          valueAr: movement.asset.nameAr,
        ),
        if (movement.fromLocation != null)
          _field(
            'From Location',
            'من موقع',
            movement.fromLocation!,
            valueAr: movement.fromLocationAr,
          ),
        if (movement.toLocation != null)
          _field(
            'To Location',
            'إلى موقع',
            movement.toLocation!,
            valueAr: movement.toLocationAr,
          ),
        if (movement.fromCustodian != null)
          _field(
            'From Custodian',
            'من عهدة',
            movement.fromCustodian!,
            valueAr: movement.fromCustodianAr,
          ),
        if (movement.toCustodian != null)
          _field(
            'To Custodian',
            'إلى عهدة',
            movement.toCustodian!,
            valueAr: movement.toCustodianAr,
          ),
        if (movement.disposalProceeds != null)
          _field(
            'Disposal Proceeds',
            'متحصلات الاستبعاد',
            _money(movement.disposalProceeds!),
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'notes',
          title: 'Notes',
          titleAr: 'ملاحظات',
          flexFactor: 3,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'reason': GeniusErpPackLocalizedValue(
              value: movement.reason ?? '',
              valueAr: movement.reasonAr,
            ),
            'notes': GeniusErpPackLocalizedValue(
              value: movement.notes ?? '',
              valueAr: movement.notesAr,
            ),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData assetTransfer(
    GeniusAssetMovement movement,
  ) =>
      assetMovement(_requireMovement(
        movement,
        GeniusAssetMovementKind.transfer,
      ));

  GeniusErpPackReportData assetAssignment(
    GeniusAssetMovement movement,
  ) =>
      assetMovement(_requireMovement(
        movement,
        GeniusAssetMovementKind.assignment,
      ));

  GeniusErpPackReportData assetReturn(
    GeniusAssetMovement movement,
  ) =>
      assetMovement(_requireMovement(
        movement,
        GeniusAssetMovementKind.returnToStore,
      ));

  GeniusErpPackReportData assetDisposal(
    GeniusAssetMovement movement,
  ) =>
      assetMovement(_requireMovement(
        movement,
        GeniusAssetMovementKind.disposal,
      ));

  GeniusAssetMovement _requireMovement(
    GeniusAssetMovement movement,
    GeniusAssetMovementKind expected,
  ) {
    if (movement.kind != expected) {
      throw ArgumentError(
        'Expected movement kind ${expected.name}; '
        'got ${movement.kind.name}.',
      );
    }
    return movement;
  }

  /// S19-T08/T26 — creates a deterministic monthly depreciation schedule.
  GeniusAssetDepreciationResult calculateDepreciation(
    GeniusFixedAsset asset, {
    required DateTime asOf,
    GeniusAssetDepreciationMethod method =
        GeniusAssetDepreciationMethod.straightLine,
    double decliningAnnualRatePercent = 20,
  }) {
    if (asset.acquisitionCost.currency != asset.residualValue.currency) {
      throw ArgumentError(
        'Asset cost and residual value must use the same currency.',
      );
    }
    if (asOf.isBefore(asset.inServiceDate)) {
      return GeniusAssetDepreciationResult(
        asset: asset,
        asOf: asOf,
        method: method,
        lines: const [],
        accumulatedDepreciation:
            ErpMoney.zero(asset.acquisitionCost.currency),
        netBookValue: asset.acquisitionCost,
      );
    }
    if (decliningAnnualRatePercent < 0) {
      throw ArgumentError.value(
        decliningAnnualRatePercent,
        'decliningAnnualRatePercent',
      );
    }

    final currency = asset.acquisitionCost.currency;
    final residual = asset.residualValue.toDouble();
    final cost = asset.acquisitionCost.toDouble();
    final depreciableBase = cost - residual;
    if (depreciableBase < -0.000001) {
      throw ArgumentError(
        'Residual value cannot exceed acquisition cost.',
      );
    }

    final serviceMonths = _inclusiveMonths(
      asset.inServiceDate,
      asOf,
    ).clamp(0, asset.usefulLifeMonths);

    var closing = cost;
    var accumulated = 0.0;
    final lines = <GeniusAssetDepreciationLine>[];

    for (var index = 0; index < serviceMonths; index++) {
      final periodStart = _addMonths(
        DateTime(
          asset.inServiceDate.year,
          asset.inServiceDate.month,
          1,
        ),
        index,
      );
      final next = _addMonths(periodStart, 1);
      final periodEnd = next.subtract(const Duration(days: 1));
      final opening = closing;

      double charge;
      if (method == GeniusAssetDepreciationMethod.straightLine) {
        charge = asset.usefulLifeMonths == 0
            ? 0
            : depreciableBase / asset.usefulLifeMonths;
      } else {
        final monthlyRate =
            decliningAnnualRatePercent / 100 / 12;
        charge = opening * monthlyRate;
      }

      final maxCharge = (opening - residual).clamp(
        0.0,
        double.infinity,
      );
      if (charge > maxCharge) charge = maxCharge;
      if (charge < 0) charge = 0;

      closing = opening - charge;
      accumulated += charge;

      lines.add(
        GeniusAssetDepreciationLine(
          periodIndex: index + 1,
          periodStart: periodStart,
          periodEnd: periodEnd,
          openingBookValue: ErpMoney.fromAmount(
            opening,
            currency: currency,
          ),
          depreciation: ErpMoney.fromAmount(
            charge,
            currency: currency,
          ),
          accumulatedDepreciation: ErpMoney.fromAmount(
            accumulated,
            currency: currency,
          ),
          closingBookValue: ErpMoney.fromAmount(
            closing,
            currency: currency,
          ),
        ),
      );
    }

    final accumulatedMoney = ErpMoney.fromAmount(
      accumulated,
      currency: currency,
    );
    final netBookValue = asset.acquisitionCost - accumulatedMoney;

    return GeniusAssetDepreciationResult(
      asset: asset,
      asOf: asOf,
      method: method,
      lines: lines,
      accumulatedDepreciation: accumulatedMoney,
      netBookValue: netBookValue,
    );
  }

  GeniusErpPackReportData depreciationReport(
    List<GeniusAssetDepreciationResult> values,
  ) {
    return GeniusErpPackReportData(
      title: 'Depreciation Report',
      titleAr: 'تقرير الإهلاك',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'tag',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'asset',
          title: 'Asset',
          titleAr: 'الأصل',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'accumulated',
          title: 'Accumulated Dep.',
          titleAr: 'مجمع الإهلاك',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'nbv',
          title: 'Net Book Value',
          titleAr: 'صافي القيمة الدفترية',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'reconciles',
          title: 'Reconciles',
          titleAr: 'متطابق',
        ),
      ],
      rows: [
        for (final value in values)
          GeniusErpPackReportRow(
            cells: {
              'tag': value.asset.assetTag,
              'asset': GeniusErpPackLocalizedValue(
                value: value.asset.name,
                valueAr: value.asset.nameAr,
              ),
              'cost': value.asset.acquisitionCost.toDouble(),
              'accumulated':
                  value.accumulatedDepreciation.toDouble(),
              'nbv': value.netBookValue.toDouble(),
              'reconciles': value.reconciles ? 'Yes' : 'No',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData assetMaintenanceReport(
    List<GeniusAssetMaintenanceEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Asset Maintenance Report',
      titleAr: 'تقرير صيانة الأصول',
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
          id: 'tag',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Maintenance',
          titleAr: 'الصيانة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'vendor',
          title: 'Vendor',
          titleAr: 'المورد',
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
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
              'tag': entry.asset.assetTag,
              'description': GeniusErpPackLocalizedValue(
                value: entry.description,
                valueAr: entry.descriptionAr,
              ),
              'vendor': GeniusErpPackLocalizedValue(
                value: entry.vendor ?? '',
                valueAr: entry.vendorAr,
              ),
              'cost': entry.cost?.toDouble() ?? 0,
              'nextDue': entry.nextDueDate == null
                  ? ''
                  : _date(entry.nextDueDate!),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData assetCount(
    List<GeniusAssetCountEntry> entries,
  ) {
    final found = entries.where((entry) => entry.found).length;
    return GeniusErpPackReportData(
      title: 'Asset Count',
      titleAr: 'جرد الأصول',
      details: [
        _field('Expected', 'المتوقع', entries.length.toString()),
        _field('Found', 'الموجود', found.toString()),
        _field(
          'Missing',
          'المفقود',
          (entries.length - found).toString(),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'tag',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'asset',
          title: 'Asset',
          titleAr: 'الأصل',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'found',
          title: 'Found',
          titleAr: 'موجود',
        ),
        GeniusErpPackReportColumn(
          id: 'location',
          title: 'Count Location',
          titleAr: 'موقع الجرد',
        ),
        GeniusErpPackReportColumn(
          id: 'condition',
          title: 'Condition',
          titleAr: 'الحالة',
        ),
        GeniusErpPackReportColumn(
          id: 'countedAt',
          title: 'Counted At',
          titleAr: 'وقت الجرد',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'tag': entry.asset.assetTag,
              'asset': GeniusErpPackLocalizedValue(
                value: entry.asset.name,
                valueAr: entry.asset.nameAr,
              ),
              'found': entry.found ? 'Yes' : 'No',
              'location': GeniusErpPackLocalizedValue(
                value: entry.location ?? '',
                valueAr: entry.locationAr,
              ),
              'condition': GeniusErpPackLocalizedValue(
                value: entry.condition ?? '',
                valueAr: entry.conditionAr,
              ),
              'countedAt': entry.countedAt.toIso8601String(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData assetMovementReport(
    List<GeniusAssetMovement> movements,
  ) {
    return GeniusErpPackReportData(
      title: 'Asset Movement Report',
      titleAr: 'تقرير حركة الأصول',
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
          id: 'tag',
          title: 'Asset Tag',
          titleAr: 'وسم الأصل',
        ),
        GeniusErpPackReportColumn(
          id: 'kind',
          title: 'Movement',
          titleAr: 'الحركة',
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
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final movement in movements)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(movement.date),
              'reference': movement.reference,
              'tag': movement.asset.assetTag,
              'kind': movement.kind.name,
              'from': GeniusErpPackLocalizedValue(
                value: movement.fromLocation ??
                    movement.fromCustodian ??
                    '',
                valueAr: movement.fromLocationAr ??
                    movement.fromCustodianAr,
              ),
              'to': GeniusErpPackLocalizedValue(
                value:
                    movement.toLocation ?? movement.toCustodian ?? '',
                valueAr:
                    movement.toLocationAr ?? movement.toCustodianAr,
              ),
              'reason': GeniusErpPackLocalizedValue(
                value: movement.reason ?? '',
                valueAr: movement.reasonAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData projectSummary(
    GeniusProject project,
  ) {
    return GeniusErpPackReportData(
      title: 'Project Summary',
      titleAr: 'ملخص المشروع',
      subtitle: project.projectCode,
      subtitleAr: project.projectCode,
      details: [
        _field(
          'Project',
          'المشروع',
          project.name,
          valueAr: project.nameAr,
        ),
        _field(
          'Project Code',
          'رمز المشروع',
          project.projectCode,
        ),
        _field(
          'Start Date',
          'تاريخ البداية',
          _date(project.startDate),
        ),
        if (project.endDate != null)
          _field(
            'End Date',
            'تاريخ النهاية',
            _date(project.endDate!),
          ),
        if (project.customer != null)
          _field(
            'Customer',
            'العميل',
            project.customer!,
            valueAr: project.customerAr,
          ),
        if (project.manager != null)
          _field(
            'Manager',
            'المدير',
            project.manager!,
            valueAr: project.managerAr,
          ),
        _field(
          'Status',
          'الحالة',
          project.status.name,
        ),
        _field(
          'Currency',
          'العملة',
          project.currency.code,
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 4,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'description': GeniusErpPackLocalizedValue(
              value: project.description ?? '',
              valueAr: project.descriptionAr,
            ),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData projectBudget(
    List<GeniusProjectBudgetLine> lines,
  ) {
    final total = _sumMoney(
      lines.map((line) => line.amount).toList(),
    );
    return GeniusErpPackReportData(
      title: 'Project Budget',
      titleAr: 'ميزانية المشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'period',
          title: 'Period',
          titleAr: 'الفترة',
        ),
        GeniusErpPackReportColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'الفئة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Budget',
          titleAr: 'الميزانية',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final line in lines)
          GeniusErpPackReportRow(
            cells: {
              'project': line.projectCode,
              'period': line.period ?? '',
              'category': GeniusErpPackLocalizedValue(
                value: line.category,
                valueAr: line.categoryAr,
              ),
              'amount': line.amount.toDouble(),
            },
          ),
        if (total != null)
          GeniusErpPackReportRow(
            isTotal: true,
            cells: {
              'project': '',
              'period': '',
              'category': 'Total',
              'amount': total.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData projectCost(
    List<GeniusProjectCostEntry> entries,
  ) {
    final total = _sumMoney(
      entries.map((entry) => entry.amount).toList(),
    );
    return GeniusErpPackReportData(
      title: 'Project Cost',
      titleAr: 'تكلفة المشروع',
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
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'الفئة',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'reference': entry.reference,
              'project': entry.projectCode,
              'category': GeniusErpPackLocalizedValue(
                value: entry.category,
                valueAr: entry.categoryAr,
              ),
              'description': GeniusErpPackLocalizedValue(
                value: entry.description ?? '',
                valueAr: entry.descriptionAr,
              ),
              'amount': entry.amount.toDouble(),
            },
          ),
        if (total != null)
          GeniusErpPackReportRow(
            isTotal: true,
            cells: {
              'date': '',
              'reference': '',
              'project': '',
              'category': '',
              'description': 'Total',
              'amount': total.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData projectProfitability({
    required List<GeniusProjectCostEntry> costs,
    required List<GeniusProjectBillingEntry> billing,
  }) {
    final cost = _sumMoney(
      costs.map((entry) => entry.amount).toList(),
    );
    final revenue = _sumMoney(
      billing.map((entry) => entry.amount).toList(),
    );

    if (cost == null && revenue == null) {
      return _empty(
        'Project Profitability',
        'ربحية المشروع',
      );
    }

    final currency = (cost ?? revenue!).currency;
    final safeCost = cost ?? ErpMoney.zero(currency);
    final safeRevenue = revenue ?? ErpMoney.zero(currency);
    _sameCurrency(currency, safeCost);
    _sameCurrency(currency, safeRevenue);
    final profit = safeRevenue - safeCost;
    final marginPercent = safeRevenue.toDouble() == 0
        ? 0
        : profit.toDouble() / safeRevenue.toDouble() * 100;

    return GeniusErpPackReportData(
      title: 'Project Profitability',
      titleAr: 'ربحية المشروع',
      details: [
        _field('Revenue', 'الإيراد', _money(safeRevenue)),
        _field('Cost', 'التكلفة', _money(safeCost)),
        _field('Profit', 'الربح', _money(profit)),
        _field(
          'Margin %',
          'هامش الربح %',
          marginPercent.toStringAsFixed(2),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'metric',
          title: 'Metric',
          titleAr: 'المؤشر',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'metric': 'Revenue',
            'amount': safeRevenue.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'metric': 'Cost',
            'amount': safeCost.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'metric': 'Profit',
            'amount': profit.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData projectTimesheet(
    List<GeniusProjectTimesheetEntry> entries,
  ) {
    final totalHours = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.hours,
    );
    return GeniusErpPackReportData(
      title: 'Project Timesheet',
      titleAr: 'سجل ساعات المشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'resource',
          title: 'Resource',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'task',
          title: 'Task',
          titleAr: 'المهمة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'hours',
          title: 'Hours',
          titleAr: 'الساعات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Calculated Cost',
          titleAr: 'التكلفة المحسوبة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'project': entry.projectCode,
              'resource': GeniusErpPackLocalizedValue(
                value:
                    '${entry.resourceId} — ${entry.resourceName}',
                valueAr:
                    '${entry.resourceId} — '
                    '${entry.resourceNameAr ?? entry.resourceName}',
              ),
              'task': GeniusErpPackLocalizedValue(
                value: entry.task ?? '',
                valueAr: entry.taskAr,
              ),
              'hours': entry.hours,
              'cost': entry.hourlyCost == null
                  ? 0
                  : entry.hourlyCost!
                      .multiply(entry.hours)
                      .toDouble(),
            },
          ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'date': '',
            'project': '',
            'resource': '',
            'task': 'Total Hours',
            'hours': totalHours,
            'cost': '',
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData projectExpenseReport(
    List<GeniusProjectExpenseEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Project Expense Report',
      titleAr: 'تقرير مصروفات المشروع',
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
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'approved',
          title: 'Approved',
          titleAr: 'معتمد',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'reference': entry.reference,
              'project': entry.projectCode,
              'description': GeniusErpPackLocalizedValue(
                value: entry.description,
                valueAr: entry.descriptionAr,
              ),
              'employee': GeniusErpPackLocalizedValue(
                value: entry.employee ?? '',
                valueAr: entry.employeeAr,
              ),
              'amount': entry.amount.toDouble(),
              'approved': entry.approved ? 'Yes' : 'No',
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData milestoneReport(
    List<GeniusProjectMilestone> milestones,
  ) {
    return GeniusErpPackReportData(
      title: 'Milestone Report',
      titleAr: 'تقرير المعالم',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Milestone',
          titleAr: 'المعلم',
        ),
        GeniusErpPackReportColumn(
          id: 'title',
          title: 'Title',
          titleAr: 'العنوان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'due',
          title: 'Due',
          titleAr: 'الاستحقاق',
        ),
        GeniusErpPackReportColumn(
          id: 'progress',
          title: 'Progress %',
          titleAr: 'التقدم %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'notes',
          title: 'Notes',
          titleAr: 'ملاحظات',
          flexFactor: 3,
        ),
      ],
      rows: [
        for (final milestone in milestones)
          GeniusErpPackReportRow(
            cells: {
              'project': milestone.projectCode,
              'code': milestone.code,
              'title': GeniusErpPackLocalizedValue(
                value: milestone.title,
                valueAr: milestone.titleAr,
              ),
              'due': _date(milestone.dueDate),
              'progress': milestone.progressPercent,
              'notes': GeniusErpPackLocalizedValue(
                value: milestone.notes ?? '',
                valueAr: milestone.notesAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData progressReport(
    List<GeniusProjectProgressEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Progress Report',
      titleAr: 'تقرير تقدم المشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'progress',
          title: 'Progress %',
          titleAr: 'التقدم %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'summary',
          title: 'Summary',
          titleAr: 'الملخص',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'risks',
          title: 'Risks',
          titleAr: 'المخاطر',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'next',
          title: 'Next Steps',
          titleAr: 'الخطوات القادمة',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'project': entry.projectCode,
              'progress': entry.progressPercent,
              'summary': GeniusErpPackLocalizedValue(
                value: entry.summary,
                valueAr: entry.summaryAr,
              ),
              'risks': GeniusErpPackLocalizedValue(
                value: entry.risks ?? '',
                valueAr: entry.risksAr,
              ),
              'next': GeniusErpPackLocalizedValue(
                value: entry.nextSteps ?? '',
                valueAr: entry.nextStepsAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData completionCertificate(
    GeniusProject project, {
    required DateTime completionDate,
    String? completionReference,
    String? completionNotes,
    String? completionNotesAr,
  }) {
    return GeniusErpPackReportData(
      title: 'Completion Certificate',
      titleAr: 'شهادة إكمال مشروع',
      subtitle: completionReference ?? project.projectCode,
      subtitleAr: completionReference ?? project.projectCode,
      details: [
        _field(
          'Project Code',
          'رمز المشروع',
          project.projectCode,
        ),
        _field(
          'Project',
          'المشروع',
          project.name,
          valueAr: project.nameAr,
        ),
        _field(
          'Completion Date',
          'تاريخ الإكمال',
          _date(completionDate),
        ),
        if (project.customer != null)
          _field(
            'Customer',
            'العميل',
            project.customer!,
            valueAr: project.customerAr,
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'statement',
          title: 'Completion Statement',
          titleAr: 'بيان الإكمال',
          flexFactor: 4,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'statement': GeniusErpPackLocalizedValue(
              value:
                  completionNotes ??
                  'The project scope has been completed.',
              valueAr:
                  completionNotesAr ??
                  'تم إكمال نطاق المشروع.',
            ),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData projectBilling(
    List<GeniusProjectBillingEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Project Billing',
      titleAr: 'فوترة المشروع',
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
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'customer',
          title: 'Customer',
          titleAr: 'العميل',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Billing',
          titleAr: 'الفوترة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'reference': entry.reference,
              'project': entry.projectCode,
              'customer': GeniusErpPackLocalizedValue(
                value: entry.customer ?? '',
                valueAr: entry.customerAr,
              ),
              'description': GeniusErpPackLocalizedValue(
                value: entry.description ?? '',
                valueAr: entry.descriptionAr,
              ),
              'amount': entry.amount.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData resourceUtilization(
    List<GeniusProjectResourceUtilization> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Resource Utilization',
      titleAr: 'استغلال موارد المشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'resource',
          title: 'Resource',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'available',
          title: 'Available h',
          titleAr: 'متاح س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'used',
          title: 'Used h',
          titleAr: 'مستخدم س',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'utilization',
          title: 'Utilization %',
          titleAr: 'الاستغلال %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'project': entry.projectCode,
              'resource': GeniusErpPackLocalizedValue(
                value:
                    '${entry.resourceId} — ${entry.resourceName}',
                valueAr:
                    '${entry.resourceId} — '
                    '${entry.resourceNameAr ?? entry.resourceName}',
              ),
              'available': entry.availableHours,
              'used': entry.usedHours,
              'utilization': entry.utilizationPercent,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData projectPurchasingReport(
    List<GeniusProjectPurchaseEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Project Purchasing Report',
      titleAr: 'تقرير مشتريات المشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'PO / Reference',
          titleAr: 'أمر الشراء / المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'supplier',
          title: 'Supplier',
          titleAr: 'المورد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'reference': entry.reference,
              'project': entry.projectCode,
              'supplier': GeniusErpPackLocalizedValue(
                value: entry.supplier,
                valueAr: entry.supplierAr,
              ),
              'description': GeniusErpPackLocalizedValue(
                value: entry.description ?? '',
                valueAr: entry.descriptionAr,
              ),
              'amount': entry.amount.toDouble(),
            },
          ),
      ],
    );
  }

  /// S19-T27 — period reconciliation for Budget/Cost/Billing.
  List<GeniusProjectFinancialPeriod> projectFinancialsByPeriod({
    required ErpCurrency currency,
    required List<GeniusProjectBudgetLine> budgets,
    required List<GeniusProjectCostEntry> costs,
    required List<GeniusProjectBillingEntry> billing,
  }) {
    final budgetByPeriod = <String, ErpMoney>{};
    final costByPeriod = <String, ErpMoney>{};
    final revenueByPeriod = <String, ErpMoney>{};
    final periods = <String>{};

    void add(
      Map<String, ErpMoney> target,
      String period,
      ErpMoney amount,
    ) {
      _sameCurrency(currency, amount);
      periods.add(period);
      target[period] =
          (target[period] ?? ErpMoney.zero(currency)) + amount;
    }

    for (final line in budgets) {
      add(
        budgetByPeriod,
        line.period ?? 'UNSPECIFIED',
        line.amount,
      );
    }
    for (final entry in costs) {
      add(costByPeriod, entry.period, entry.amount);
    }
    for (final entry in billing) {
      add(revenueByPeriod, entry.period, entry.amount);
    }

    final ordered = periods.toList()..sort();
    return [
      for (final period in ordered)
        GeniusProjectFinancialPeriod(
          period: period,
          budget:
              budgetByPeriod[period] ?? ErpMoney.zero(currency),
          cost: costByPeriod[period] ?? ErpMoney.zero(currency),
          revenue:
              revenueByPeriod[period] ?? ErpMoney.zero(currency),
        ),
    ];
  }

  GeniusErpPackReportData multiPeriodProjectFinancials(
    List<GeniusProjectFinancialPeriod> periods,
  ) {
    return GeniusErpPackReportData(
      title: 'Multi-period Project Financials',
      titleAr: 'البيانات المالية متعددة الفترات للمشروع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'period',
          title: 'Period',
          titleAr: 'الفترة',
        ),
        GeniusErpPackReportColumn(
          id: 'budget',
          title: 'Budget',
          titleAr: 'الميزانية',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'cost',
          title: 'Cost',
          titleAr: 'التكلفة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'revenue',
          title: 'Revenue',
          titleAr: 'الإيراد',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'profit',
          title: 'Profit',
          titleAr: 'الربح',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'variance',
          title: 'Budget Variance',
          titleAr: 'انحراف الميزانية',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final period in periods)
          GeniusErpPackReportRow(
            cells: {
              'period': period.period,
              'budget': period.budget.toDouble(),
              'cost': period.cost.toDouble(),
              'revenue': period.revenue.toDouble(),
              'profit': period.profit.toDouble(),
              'variance': period.budgetVariance.toDouble(),
            },
          ),
      ],
    );
  }

  int _inclusiveMonths(
    DateTime start,
    DateTime end,
  ) {
    if (end.isBefore(start)) return 0;
    final months =
        (end.year - start.year) * 12 + end.month - start.month;
    return months + 1;
  }

  DateTime _addMonths(
    DateTime value,
    int months,
  ) {
    final raw = value.month - 1 + months;
    final year = value.year + raw ~/ 12;
    final month = raw % 12 + 1;
    return DateTime(year, month, 1);
  }

  ErpMoney? _sumMoney(
    List<ErpMoney> values,
  ) {
    if (values.isEmpty) return null;
    final currency = values.first.currency;
    var total = ErpMoney.zero(currency);
    for (final value in values) {
      _sameCurrency(currency, value);
      total = total + value;
    }
    return total;
  }

  void _sameCurrency(
    ErpCurrency currency,
    ErpMoney value,
  ) {
    if (value.currency != currency) {
      throw ArgumentError(
        'S19 financial calculations require one currency.',
      );
    }
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

  String _money(ErpMoney value) =>
      '${value.toDouble().toStringAsFixed(value.currency.precision)} '
      '${value.currency.code}';

  GeniusErpPackReportData _empty(
    String title,
    String titleAr,
  ) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        columns: const [
          GeniusErpPackReportColumn(
            id: 'message',
            title: 'Result',
            titleAr: 'النتيجة',
          ),
        ],
        rows: const [
          GeniusErpPackReportRow(
            cells: {'message': 'No data'},
          ),
        ],
      );
}
