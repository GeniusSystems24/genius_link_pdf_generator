
import '../../../../domain/erp/erp.dart';

enum GeniusCrmLeadStatus {
  newLead,
  contacted,
  qualified,
  disqualified,
  converted,
}

enum GeniusCrmOpportunityStage {
  prospecting,
  qualification,
  proposal,
  negotiation,
  won,
  lost,
}

enum GeniusCrmActivityType {
  call,
  visit,
  email,
  meeting,
  task,
  note,
}

enum GeniusCrmConfidentiality {
  none,
  draft,
  confidential,
}

class GeniusCrmContact {
  const GeniusCrmContact({
    required this.contactId,
    required this.name,
    this.nameAr,
    this.jobTitle,
    this.jobTitleAr,
    this.email,
    this.phone,
    this.mobile,
    this.notes,
    this.notesAr,
  });

  final String contactId;
  final String name;
  final String? nameAr;
  final String? jobTitle;
  final String? jobTitleAr;

  /// Structured LTR value even inside RTL documents.
  final String? email;

  /// Structured LTR value even inside RTL documents.
  final String? phone;

  /// Structured LTR value even inside RTL documents.
  final String? mobile;
  final String? notes;
  final String? notesAr;
}

class GeniusCrmCustomer {
  const GeniusCrmCustomer({
    required this.customerId,
    required this.name,
    this.nameAr,
    this.taxId,
    this.email,
    this.phone,
    this.address,
    this.addressAr,
    this.industry,
    this.industryAr,
    this.accountManager,
    this.accountManagerAr,
    this.contacts = const [],
    this.notes,
    this.notesAr,
  });

  final String customerId;
  final String name;
  final String? nameAr;
  final String? taxId;
  final String? email;
  final String? phone;
  final String? address;
  final String? addressAr;
  final String? industry;
  final String? industryAr;
  final String? accountManager;
  final String? accountManagerAr;
  final List<GeniusCrmContact> contacts;
  final String? notes;
  final String? notesAr;
}

class GeniusCrmLead {
  const GeniusCrmLead({
    required this.leadId,
    required this.name,
    required this.createdAt,
    this.nameAr,
    this.company,
    this.companyAr,
    this.email,
    this.phone,
    this.source,
    this.sourceAr,
    this.owner,
    this.ownerAr,
    this.status = GeniusCrmLeadStatus.newLead,
    this.estimatedValue,
    this.notes,
    this.notesAr,
  });

  final String leadId;
  final String name;
  final String? nameAr;
  final DateTime createdAt;
  final String? company;
  final String? companyAr;
  final String? email;
  final String? phone;
  final String? source;
  final String? sourceAr;
  final String? owner;
  final String? ownerAr;
  final GeniusCrmLeadStatus status;
  final ErpMoney? estimatedValue;
  final String? notes;
  final String? notesAr;
}

class GeniusCrmOpportunity {
  const GeniusCrmOpportunity({
    required this.opportunityId,
    required this.customerId,
    required this.title,
    required this.createdAt,
    required this.expectedCloseDate,
    required this.value,
    this.titleAr,
    this.stage = GeniusCrmOpportunityStage.prospecting,
    this.probabilityPercent = 0,
    this.owner,
    this.ownerAr,
    this.notes,
    this.notesAr,
  }) : assert(
          probabilityPercent >= 0 && probabilityPercent <= 100,
        );

  final String opportunityId;
  final String customerId;
  final String title;
  final String? titleAr;
  final DateTime createdAt;
  final DateTime expectedCloseDate;
  final ErpMoney value;
  final GeniusCrmOpportunityStage stage;
  final double probabilityPercent;
  final String? owner;
  final String? ownerAr;
  final String? notes;
  final String? notesAr;

  ErpMoney get weightedValue =>
      value.multiply(probabilityPercent / 100);
}

class GeniusCrmActivity {
  const GeniusCrmActivity({
    required this.activityId,
    required this.customerId,
    required this.occurredAt,
    required this.type,
    required this.subject,
    this.subjectAr,
    this.contact,
    this.owner,
    this.ownerAr,
    this.durationMinutes,
    this.outcome,
    this.outcomeAr,
    this.notes,
    this.notesAr,
  });

  final String activityId;
  final String customerId;
  final DateTime occurredAt;
  final GeniusCrmActivityType type;
  final String subject;
  final String? subjectAr;
  final GeniusCrmContact? contact;
  final String? owner;
  final String? ownerAr;
  final int? durationMinutes;
  final String? outcome;
  final String? outcomeAr;
  final String? notes;
  final String? notesAr;
}

class GeniusCrmProposalLine {
  const GeniusCrmProposalLine({
    required this.lineId,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.descriptionAr,
    this.discountPercent = 0,
    this.notes,
    this.notesAr,
  })  : assert(quantity >= 0),
        assert(discountPercent >= 0 && discountPercent <= 100);

  final String lineId;
  final String description;
  final String? descriptionAr;
  final double quantity;
  final ErpUnit unit;
  final ErpMoney unitPrice;
  final double discountPercent;
  final String? notes;
  final String? notesAr;

  ErpMoney get gross => unitPrice.multiply(quantity);

  ErpMoney get discount =>
      gross.multiply(discountPercent / 100);

  ErpMoney get net => gross - discount;
}

class GeniusCrmProposal {
  const GeniusCrmProposal({
    required this.proposalNumber,
    required this.customer,
    required this.issueDate,
    required this.validUntil,
    required this.lines,
    this.title,
    this.titleAr,
    this.terms,
    this.termsAr,
    this.references = const [],
    this.attachments = const [],
    this.confidentiality = GeniusCrmConfidentiality.none,
  });

  final String proposalNumber;
  final GeniusCrmCustomer customer;
  final DateTime issueDate;
  final DateTime validUntil;
  final List<GeniusCrmProposalLine> lines;
  final String? title;
  final String? titleAr;
  final String? terms;
  final String? termsAr;
  final List<String> references;
  final List<GeniusCrmAttachmentReference> attachments;
  final GeniusCrmConfidentiality confidentiality;

  ErpMoney? get total {
    if (lines.isEmpty) return null;
    final currency = lines.first.unitPrice.currency;
    var value = ErpMoney.zero(currency);
    for (final line in lines) {
      if (line.unitPrice.currency != currency) {
        throw StateError(
          'Proposal lines must use one document currency.',
        );
      }
      value = value + line.net;
    }
    return value;
  }
}

class GeniusCrmContractSummary {
  const GeniusCrmContractSummary({
    required this.contractNumber,
    required this.customer,
    required this.effectiveFrom,
    this.effectiveTo,
    this.title,
    this.titleAr,
    this.status,
    this.statusAr,
    this.value,
    this.scope,
    this.scopeAr,
    this.renewalTerms,
    this.renewalTermsAr,
    this.references = const [],
    this.attachments = const [],
    this.confidentiality = GeniusCrmConfidentiality.confidential,
  });

  final String contractNumber;
  final GeniusCrmCustomer customer;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final String? title;
  final String? titleAr;
  final String? status;
  final String? statusAr;
  final ErpMoney? value;
  final String? scope;
  final String? scopeAr;
  final String? renewalTerms;
  final String? renewalTermsAr;
  final List<String> references;
  final List<GeniusCrmAttachmentReference> attachments;
  final GeniusCrmConfidentiality confidentiality;
}

/// S21-T11 — printable metric-card primitive.
class GeniusCrmMetric {
  const GeniusCrmMetric({
    required this.id,
    required this.label,
    required this.value,
    this.labelAr,
    this.valueAr,
    this.delta,
    this.status,
  });

  final String id;
  final String label;
  final String? labelAr;
  final String value;
  final String? valueAr;
  final double? delta;
  final String? status;
}

/// S21-T12 — text/status stage visualization that does not depend on charts.
class GeniusCrmStageStatus {
  const GeniusCrmStageStatus({
    required this.stage,
    required this.label,
    required this.count,
    required this.amount,
    this.labelAr,
    this.isCurrent = false,
  });

  final GeniusCrmOpportunityStage stage;
  final String label;
  final String? labelAr;
  final int count;
  final ErpMoney amount;
  final bool isCurrent;
}

/// S21-T13 — reusable timeline/history primitive.
class GeniusCrmTimelineEntry {
  const GeniusCrmTimelineEntry({
    required this.reference,
    required this.timestamp,
    required this.title,
    this.titleAr,
    this.description,
    this.descriptionAr,
    this.actor,
    this.actorAr,
  });

  final String reference;
  final DateTime timestamp;
  final String title;
  final String? titleAr;
  final String? description;
  final String? descriptionAr;
  final String? actor;
  final String? actorAr;
}

/// S21-T14 — normalized party/contact block.
class GeniusCrmContactBlock {
  const GeniusCrmContactBlock({
    required this.partyId,
    required this.partyName,
    this.partyNameAr,
    this.contacts = const [],
    this.address,
    this.addressAr,
  });

  final String partyId;
  final String partyName;
  final String? partyNameAr;
  final List<GeniusCrmContact> contacts;
  final String? address;
  final String? addressAr;
}

/// S21-T15 — attachment/reference list item.
class GeniusCrmAttachmentReference {
  const GeniusCrmAttachmentReference({
    required this.reference,
    required this.label,
    this.labelAr,
    this.uri,
    this.mediaType,
    this.createdAt,
  });

  final String reference;
  final String label;
  final String? labelAr;
  final String? uri;
  final String? mediaType;
  final DateTime? createdAt;
}
