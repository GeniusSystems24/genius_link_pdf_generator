
import '../../domain/erp/erp.dart';

/// Project lifecycle state.
enum GeniusProjectStatus {
  planned,
  active,
  onHold,
  completed,
  cancelled,
}

/// Core project summary model.
class GeniusProject {
  const GeniusProject({
    required this.projectCode,
    required this.name,
    required this.startDate,
    required this.currency,
    this.nameAr,
    this.endDate,
    this.customer,
    this.customerAr,
    this.manager,
    this.managerAr,
    this.status = GeniusProjectStatus.active,
    this.description,
    this.descriptionAr,
    this.metadata = const {},
  });

  /// Structured Latin/bilingual-safe project identifier.
  final String projectCode;
  final String name;
  final String? nameAr;
  final DateTime startDate;
  final DateTime? endDate;
  final ErpCurrency currency;
  final String? customer;
  final String? customerAr;
  final String? manager;
  final String? managerAr;
  final GeniusProjectStatus status;
  final String? description;
  final String? descriptionAr;
  final Map<String, Object?> metadata;
}

/// Project budget line.
class GeniusProjectBudgetLine {
  const GeniusProjectBudgetLine({
    required this.projectCode,
    required this.category,
    required this.amount,
    this.categoryAr,
    this.period,
    this.notes,
    this.notesAr,
  });

  final String projectCode;
  final String category;
  final String? categoryAr;
  final ErpMoney amount;

  /// Optional period key such as 2026-09.
  final String? period;
  final String? notes;
  final String? notesAr;
}

/// Project cost transaction.
class GeniusProjectCostEntry {
  const GeniusProjectCostEntry({
    required this.projectCode,
    required this.date,
    required this.reference,
    required this.category,
    required this.amount,
    this.categoryAr,
    this.vendor,
    this.vendorAr,
    this.description,
    this.descriptionAr,
  });

  final String projectCode;
  final DateTime date;
  final String reference;
  final String category;
  final String? categoryAr;
  final ErpMoney amount;
  final String? vendor;
  final String? vendorAr;
  final String? description;
  final String? descriptionAr;

  String get period =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}

/// Project billing/revenue transaction.
class GeniusProjectBillingEntry {
  const GeniusProjectBillingEntry({
    required this.projectCode,
    required this.date,
    required this.reference,
    required this.amount,
    this.customer,
    this.customerAr,
    this.description,
    this.descriptionAr,
  });

  final String projectCode;
  final DateTime date;
  final String reference;
  final ErpMoney amount;
  final String? customer;
  final String? customerAr;
  final String? description;
  final String? descriptionAr;

  String get period =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}

/// Project timesheet line.
class GeniusProjectTimesheetEntry {
  const GeniusProjectTimesheetEntry({
    required this.projectCode,
    required this.date,
    required this.resourceId,
    required this.resourceName,
    required this.hours,
    this.resourceNameAr,
    this.task,
    this.taskAr,
    this.hourlyCost,
    this.notes,
    this.notesAr,
  }) : assert(hours >= 0);

  final String projectCode;
  final DateTime date;
  final String resourceId;
  final String resourceName;
  final String? resourceNameAr;
  final double hours;
  final String? task;
  final String? taskAr;
  final ErpMoney? hourlyCost;
  final String? notes;
  final String? notesAr;
}

/// Project expense line.
class GeniusProjectExpenseEntry {
  const GeniusProjectExpenseEntry({
    required this.projectCode,
    required this.date,
    required this.reference,
    required this.description,
    required this.amount,
    this.descriptionAr,
    this.employee,
    this.employeeAr,
    this.approved = true,
  });

  final String projectCode;
  final DateTime date;
  final String reference;
  final String description;
  final String? descriptionAr;
  final ErpMoney amount;
  final String? employee;
  final String? employeeAr;
  final bool approved;
}

/// Project milestone.
class GeniusProjectMilestone {
  const GeniusProjectMilestone({
    required this.projectCode,
    required this.code,
    required this.title,
    required this.dueDate,
    this.titleAr,
    this.completedAt,
    this.progressPercent = 0,
    this.notes,
    this.notesAr,
  }) : assert(progressPercent >= 0 && progressPercent <= 100);

  final String projectCode;
  final String code;
  final String title;
  final String? titleAr;
  final DateTime dueDate;
  final DateTime? completedAt;
  final double progressPercent;
  final String? notes;
  final String? notesAr;

  bool get completed => completedAt != null || progressPercent >= 100;
}

/// Project progress snapshot.
class GeniusProjectProgressEntry {
  const GeniusProjectProgressEntry({
    required this.projectCode,
    required this.date,
    required this.progressPercent,
    required this.summary,
    this.summaryAr,
    this.risks,
    this.risksAr,
    this.nextSteps,
    this.nextStepsAr,
  }) : assert(progressPercent >= 0 && progressPercent <= 100);

  final String projectCode;
  final DateTime date;
  final double progressPercent;
  final String summary;
  final String? summaryAr;
  final String? risks;
  final String? risksAr;
  final String? nextSteps;
  final String? nextStepsAr;
}

/// Project resource-utilization row.
class GeniusProjectResourceUtilization {
  const GeniusProjectResourceUtilization({
    required this.projectCode,
    required this.resourceId,
    required this.resourceName,
    required this.availableHours,
    required this.usedHours,
    this.resourceNameAr,
  })  : assert(availableHours >= 0),
        assert(usedHours >= 0);

  final String projectCode;
  final String resourceId;
  final String resourceName;
  final String? resourceNameAr;
  final double availableHours;
  final double usedHours;

  double get utilizationPercent =>
      availableHours == 0 ? 0 : usedHours / availableHours * 100;
}

/// Project purchasing row.
class GeniusProjectPurchaseEntry {
  const GeniusProjectPurchaseEntry({
    required this.projectCode,
    required this.date,
    required this.reference,
    required this.supplier,
    required this.amount,
    this.supplierAr,
    this.description,
    this.descriptionAr,
  });

  final String projectCode;
  final DateTime date;
  final String reference;
  final String supplier;
  final String? supplierAr;
  final ErpMoney amount;
  final String? description;
  final String? descriptionAr;
}

/// Multi-period project financial result — S19-T27.
class GeniusProjectFinancialPeriod {
  const GeniusProjectFinancialPeriod({
    required this.period,
    required this.budget,
    required this.cost,
    required this.revenue,
  });

  final String period;
  final ErpMoney budget;
  final ErpMoney cost;
  final ErpMoney revenue;

  ErpMoney get profit => revenue - cost;
  ErpMoney get budgetVariance => budget - cost;
}
