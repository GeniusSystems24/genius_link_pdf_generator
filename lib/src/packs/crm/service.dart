
import '../../domain/erp/erp.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

import '../../families/erp/erp_families.dart';
/// Sprint S21 CRM report preparation/calculation service.
class GeniusCrmService {
  const GeniusCrmService();

  GeniusErpPackReportData customerProfile(
    GeniusCrmCustomer customer,
  ) {
    return GeniusErpPackReportData(
      title: 'Customer Profile',
      titleAr: 'ملف العميل',
      subtitle: customer.customerId,
      subtitleAr: customer.customerId,
      details: [
        _field(
          'Customer',
          'العميل',
          customer.name,
          valueAr: customer.nameAr,
        ),
        if (customer.taxId != null)
          _field('Tax ID', 'الرقم الضريبي', customer.taxId!),
        if (customer.email != null)
          _field('Email', 'البريد الإلكتروني', customer.email!),
        if (customer.phone != null)
          _field('Phone', 'الهاتف', customer.phone!),
        if (customer.address != null)
          _field(
            'Address',
            'العنوان',
            customer.address!,
            valueAr: customer.addressAr,
          ),
        if (customer.industry != null)
          _field(
            'Industry',
            'القطاع',
            customer.industry!,
            valueAr: customer.industryAr,
          ),
        if (customer.accountManager != null)
          _field(
            'Account Manager',
            'مدير الحساب',
            customer.accountManager!,
            valueAr: customer.accountManagerAr,
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'id',
          title: 'Contact ID',
          titleAr: 'رمز جهة الاتصال',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Contact',
          titleAr: 'جهة الاتصال',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'job',
          title: 'Job Title',
          titleAr: 'المسمى',
        ),
        GeniusErpPackReportColumn(
          id: 'email',
          title: 'Email',
          titleAr: 'البريد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'phone',
          title: 'Phone',
          titleAr: 'الهاتف',
        ),
      ],
      rows: [
        for (final contact in customer.contacts)
          GeniusErpPackReportRow(
            cells: {
              'id': contact.contactId,
              'name': GeniusErpPackLocalizedValue(
                value: contact.name,
                valueAr: contact.nameAr,
              ),
              'job': GeniusErpPackLocalizedValue(
                value: contact.jobTitle ?? '',
                valueAr: contact.jobTitleAr,
              ),
              'email': contact.email ?? '',
              'phone': contact.phone ?? contact.mobile ?? '',
            },
          ),
      ],
      notes: customer.notes,
      notesAr: customer.notesAr,
    );
  }

  GeniusErpPackReportData leadReport(
    List<GeniusCrmLead> leads,
  ) {
    return GeniusErpPackReportData(
      title: 'Lead Report',
      titleAr: 'تقرير العملاء المحتملين',
      columns: const [
        GeniusErpPackReportColumn(id: 'id', title: 'Lead', titleAr: 'العميل المحتمل'),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Name',
          titleAr: 'الاسم',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(id: 'contact', title: 'Contact', titleAr: 'التواصل', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'source', title: 'Source', titleAr: 'المصدر'),
        GeniusErpPackReportColumn(id: 'owner', title: 'Owner', titleAr: 'المسؤول'),
        GeniusErpPackReportColumn(id: 'status', title: 'Status', titleAr: 'الحالة'),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Estimated',
          titleAr: 'المتوقع',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final lead in leads)
          GeniusErpPackReportRow(
            cells: {
              'id': lead.leadId,
              'name': GeniusErpPackLocalizedValue(
                value: lead.name,
                valueAr: lead.nameAr,
              ),
              'contact': [
                if (lead.email != null) lead.email!,
                if (lead.phone != null) lead.phone!,
              ].join(' · '),
              'source': GeniusErpPackLocalizedValue(
                value: lead.source ?? '',
                valueAr: lead.sourceAr,
              ),
              'owner': GeniusErpPackLocalizedValue(
                value: lead.owner ?? '',
                valueAr: lead.ownerAr,
              ),
              'status': lead.status.name,
              'value': lead.estimatedValue?.toDouble() ?? 0,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData opportunityReport(
    List<GeniusCrmOpportunity> opportunities,
  ) {
    return GeniusErpPackReportData(
      title: 'Opportunity Report',
      titleAr: 'تقرير الفرص',
      columns: const [
        GeniusErpPackReportColumn(id: 'id', title: 'Opportunity', titleAr: 'الفرصة'),
        GeniusErpPackReportColumn(id: 'customer', title: 'Customer', titleAr: 'العميل'),
        GeniusErpPackReportColumn(id: 'title', title: 'Title', titleAr: 'العنوان', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'stage', title: 'Stage', titleAr: 'المرحلة'),
        GeniusErpPackReportColumn(
          id: 'probability',
          title: 'Probability %',
          titleAr: 'الاحتمال %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Value',
          titleAr: 'القيمة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'weighted',
          title: 'Weighted',
          titleAr: 'المرجحة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(id: 'close', title: 'Expected Close', titleAr: 'الإغلاق المتوقع'),
      ],
      rows: [
        for (final item in opportunities)
          GeniusErpPackReportRow(
            cells: {
              'id': item.opportunityId,
              'customer': item.customerId,
              'title': GeniusErpPackLocalizedValue(
                value: item.title,
                valueAr: item.titleAr,
              ),
              'stage': item.stage.name,
              'probability': item.probabilityPercent,
              'value': item.value.toDouble(),
              'weighted': item.weightedValue.toDouble(),
              'close': _date(item.expectedCloseDate),
            },
          ),
      ],
    );
  }

  /// S21-T18 — deterministic pipeline totals by stage.
  GeniusErpPackReportData pipelineReport(
    List<GeniusCrmOpportunity> opportunities,
  ) {
    if (opportunities.isEmpty) {
      return const GeniusErpPackReportData(
        title: 'Pipeline Report',
        titleAr: 'تقرير مسار المبيعات',
        columns: [
          GeniusErpPackReportColumn(id: 'stage', title: 'Stage', titleAr: 'المرحلة'),
          GeniusErpPackReportColumn(id: 'count', title: 'Count', titleAr: 'العدد'),
          GeniusErpPackReportColumn(id: 'amount', title: 'Amount', titleAr: 'القيمة'),
          GeniusErpPackReportColumn(id: 'weighted', title: 'Weighted', titleAr: 'المرجحة'),
        ],
        rows: [],
      );
    }

    final currency = opportunities.first.value.currency;
    final counts = <GeniusCrmOpportunityStage, int>{};
    final amounts = <GeniusCrmOpportunityStage, ErpMoney>{};
    final weighted = <GeniusCrmOpportunityStage, ErpMoney>{};

    for (final item in opportunities) {
      if (item.value.currency != currency) {
        throw ArgumentError(
          'Pipeline totals require one document currency.',
        );
      }
      counts[item.stage] = (counts[item.stage] ?? 0) + 1;
      amounts[item.stage] =
          (amounts[item.stage] ?? ErpMoney.zero(currency)) + item.value;
      weighted[item.stage] =
          (weighted[item.stage] ?? ErpMoney.zero(currency)) +
              item.weightedValue;
    }

    return GeniusErpPackReportData(
      title: 'Pipeline Report',
      titleAr: 'تقرير مسار المبيعات',
      columns: const [
        GeniusErpPackReportColumn(id: 'stage', title: 'Stage', titleAr: 'المرحلة'),
        GeniusErpPackReportColumn(
          id: 'count',
          title: 'Count',
          titleAr: 'العدد',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'القيمة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'weighted',
          title: 'Weighted',
          titleAr: 'المرجحة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final stage in GeniusCrmOpportunityStage.values)
          GeniusErpPackReportRow(
            cells: {
              'stage': stage.name,
              'count': counts[stage] ?? 0,
              'amount': (amounts[stage] ?? ErpMoney.zero(currency)).toDouble(),
              'weighted': (weighted[stage] ?? ErpMoney.zero(currency)).toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData activityReport(
    List<GeniusCrmActivity> activities,
  ) =>
      _activities(
        'Activity Report',
        'تقرير الأنشطة',
        activities,
      );

  GeniusErpPackReportData visitReport(
    List<GeniusCrmActivity> activities,
  ) =>
      _activities(
        'Visit Report',
        'تقرير الزيارات',
        activities
            .where((item) => item.type == GeniusCrmActivityType.visit)
            .toList(),
      );

  GeniusErpPackReportData callReport(
    List<GeniusCrmActivity> activities,
  ) =>
      _activities(
        'Call Report',
        'تقرير المكالمات',
        activities
            .where((item) => item.type == GeniusCrmActivityType.call)
            .toList(),
      );

  GeniusErpPackReportData _activities(
    String title,
    String titleAr,
    List<GeniusCrmActivity> activities,
  ) {
    final ordered = [...activities]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(id: 'time', title: 'Time', titleAr: 'الوقت'),
        GeniusErpPackReportColumn(id: 'id', title: 'Activity', titleAr: 'النشاط'),
        GeniusErpPackReportColumn(id: 'type', title: 'Type', titleAr: 'النوع'),
        GeniusErpPackReportColumn(id: 'subject', title: 'Subject', titleAr: 'الموضوع', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'contact', title: 'Contact', titleAr: 'جهة الاتصال', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'owner', title: 'Owner', titleAr: 'المسؤول'),
        GeniusErpPackReportColumn(id: 'outcome', title: 'Outcome', titleAr: 'النتيجة', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'notes', title: 'Notes', titleAr: 'ملاحظات', flexFactor: 3),
      ],
      rows: [
        for (final item in ordered)
          GeniusErpPackReportRow(
            cells: {
              'time': item.occurredAt.toIso8601String(),
              'id': item.activityId,
              'type': item.type.name,
              'subject': GeniusErpPackLocalizedValue(
                value: item.subject,
                valueAr: item.subjectAr,
              ),
              'contact': item.contact == null
                  ? ''
                  : GeniusErpPackLocalizedValue(
                      value: [
                        item.contact!.name,
                        if (item.contact!.email != null) item.contact!.email!,
                        if (item.contact!.phone != null) item.contact!.phone!,
                      ].join(' · '),
                      valueAr: [
                        item.contact!.nameAr ?? item.contact!.name,
                        if (item.contact!.email != null) item.contact!.email!,
                        if (item.contact!.phone != null) item.contact!.phone!,
                      ].join(' · '),
                    ),
              'owner': GeniusErpPackLocalizedValue(
                value: item.owner ?? '',
                valueAr: item.ownerAr,
              ),
              'outcome': GeniusErpPackLocalizedValue(
                value: item.outcome ?? '',
                valueAr: item.outcomeAr,
              ),
              'notes': GeniusErpPackLocalizedValue(
                value: item.notes ?? '',
                valueAr: item.notesAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData customerHistory(
    GeniusCrmCustomer customer,
    List<GeniusCrmActivity> activities,
  ) {
    final history = activities
        .where((item) => item.customerId == customer.customerId)
        .map(
          (item) => GeniusCrmTimelineEntry(
            reference: item.activityId,
            timestamp: item.occurredAt,
            title: item.subject,
            titleAr: item.subjectAr,
            description: item.outcome ?? item.notes,
            descriptionAr: item.outcomeAr ?? item.notesAr,
            actor: item.owner,
            actorAr: item.ownerAr,
          ),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return GeniusErpPackReportData(
      title: 'Customer History',
      titleAr: 'سجل العميل',
      subtitle: customer.customerId,
      subtitleAr: customer.customerId,
      details: [
        _field(
          'Customer',
          'العميل',
          customer.name,
          valueAr: customer.nameAr,
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(id: 'time', title: 'Time', titleAr: 'الوقت'),
        GeniusErpPackReportColumn(id: 'reference', title: 'Reference', titleAr: 'المرجع'),
        GeniusErpPackReportColumn(id: 'event', title: 'Event', titleAr: 'الحدث', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'actor', title: 'Actor', titleAr: 'المنفذ'),
        GeniusErpPackReportColumn(id: 'description', title: 'Description', titleAr: 'الوصف', flexFactor: 3),
      ],
      rows: [
        for (final item in history)
          GeniusErpPackReportRow(
            cells: {
              'time': item.timestamp.toIso8601String(),
              'reference': item.reference,
              'event': GeniusErpPackLocalizedValue(
                value: item.title,
                valueAr: item.titleAr,
              ),
              'actor': GeniusErpPackLocalizedValue(
                value: item.actor ?? '',
                valueAr: item.actorAr,
              ),
              'description': GeniusErpPackLocalizedValue(
                value: item.description ?? '',
                valueAr: item.descriptionAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData proposal(
    GeniusCrmProposal proposal,
  ) {
    return GeniusErpPackReportData(
      title: proposal.title ?? 'Proposal',
      titleAr: proposal.titleAr ?? 'عرض',
      subtitle: proposal.proposalNumber,
      subtitleAr: proposal.proposalNumber,
      details: [
        _field(
          'Customer',
          'العميل',
          proposal.customer.name,
          valueAr: proposal.customer.nameAr,
        ),
        _field('Issue Date', 'تاريخ الإصدار', _date(proposal.issueDate)),
        _field('Valid Until', 'صالح حتى', _date(proposal.validUntil)),
        if (proposal.total != null)
          _field(
            'Total',
            'الإجمالي',
            '${proposal.total!.toDouble().toStringAsFixed(proposal.total!.currency.precision)} '
            '${proposal.total!.currency.code}',
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(id: 'line', title: 'Line', titleAr: 'السطر'),
        GeniusErpPackReportColumn(id: 'description', title: 'Description', titleAr: 'الوصف', flexFactor: 3),
        GeniusErpPackReportColumn(id: 'qty', title: 'Qty', titleAr: 'الكمية', kind: GeniusErpPackReportColumnKind.number),
        GeniusErpPackReportColumn(id: 'unit', title: 'Unit', titleAr: 'الوحدة'),
        GeniusErpPackReportColumn(id: 'price', title: 'Unit Price', titleAr: 'سعر الوحدة', kind: GeniusErpPackReportColumnKind.money),
        GeniusErpPackReportColumn(id: 'discount', title: 'Discount %', titleAr: 'الخصم %', kind: GeniusErpPackReportColumnKind.number),
        GeniusErpPackReportColumn(id: 'net', title: 'Net', titleAr: 'الصافي', kind: GeniusErpPackReportColumnKind.money),
        GeniusErpPackReportColumn(id: 'notes', title: 'Notes', titleAr: 'ملاحظات', flexFactor: 2),
      ],
      rows: [
        for (final line in proposal.lines)
          GeniusErpPackReportRow(
            cells: {
              'line': line.lineId,
              'description': GeniusErpPackLocalizedValue(
                value: line.description,
                valueAr: line.descriptionAr,
              ),
              'qty': line.quantity,
              'unit': line.unit.code,
              'price': line.unitPrice.toDouble(),
              'discount': line.discountPercent,
              'net': line.net.toDouble(),
              'notes': GeniusErpPackLocalizedValue(
                value: line.notes ?? '',
                valueAr: line.notesAr,
              ),
            },
          ),
      ],
      notes: proposal.terms,
      notesAr: proposal.termsAr,
    );
  }

  GeniusErpPackReportData contractSummary(
    GeniusCrmContractSummary contract,
  ) {
    return GeniusErpPackReportData(
      title: contract.title ?? 'Contract Summary',
      titleAr: contract.titleAr ?? 'ملخص العقد',
      subtitle: contract.contractNumber,
      subtitleAr: contract.contractNumber,
      details: [
        _field(
          'Customer',
          'العميل',
          contract.customer.name,
          valueAr: contract.customer.nameAr,
        ),
        _field(
          'Effective From',
          'ساري من',
          _date(contract.effectiveFrom),
        ),
        if (contract.effectiveTo != null)
          _field(
            'Effective To',
            'ساري حتى',
            _date(contract.effectiveTo!),
          ),
        if (contract.status != null)
          _field(
            'Status',
            'الحالة',
            contract.status!,
            valueAr: contract.statusAr,
          ),
        if (contract.value != null)
          _field(
            'Value',
            'القيمة',
            '${contract.value!.toDouble().toStringAsFixed(contract.value!.currency.precision)} '
            '${contract.value!.currency.code}',
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(id: 'section', title: 'Section', titleAr: 'القسم'),
        GeniusErpPackReportColumn(id: 'content', title: 'Content', titleAr: 'المحتوى', flexFactor: 4),
      ],
      rows: [
        if (contract.scope != null)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Scope',
              'content': GeniusErpPackLocalizedValue(
                value: contract.scope!,
                valueAr: contract.scopeAr,
              ),
            },
          ),
        if (contract.renewalTerms != null)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Renewal',
              'content': GeniusErpPackLocalizedValue(
                value: contract.renewalTerms!,
                valueAr: contract.renewalTermsAr,
              ),
            },
          ),
        for (final reference in contract.references)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Reference',
              'content': reference,
            },
          ),
        for (final attachment in contract.attachments)
          GeniusErpPackReportRow(
            cells: {
              'section': 'Attachment',
              'content': GeniusErpPackLocalizedValue(
                value: '${attachment.reference} — ${attachment.label}',
                valueAr:
                    '${attachment.reference} — ${attachment.labelAr ?? attachment.label}',
              ),
            },
          ),
      ],
    );
  }

  /// S21-T11..T15 presentation model combined in printable rows.
  GeniusErpPackReportData presentationOverview({
    required List<GeniusCrmMetric> metrics,
    required List<GeniusCrmStageStatus> stages,
    required List<GeniusCrmTimelineEntry> timeline,
    required List<GeniusCrmContactBlock> contacts,
    required List<GeniusCrmAttachmentReference> attachments,
  }) {
    return GeniusErpPackReportData(
      title: 'CRM Presentation Overview',
      titleAr: 'نظرة عرض إدارة العملاء',
      columns: const [
        GeniusErpPackReportColumn(id: 'kind', title: 'Kind', titleAr: 'النوع'),
        GeniusErpPackReportColumn(id: 'reference', title: 'Reference', titleAr: 'المرجع'),
        GeniusErpPackReportColumn(id: 'label', title: 'Label', titleAr: 'البيان', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'value', title: 'Value / Status', titleAr: 'القيمة / الحالة', flexFactor: 2),
        GeniusErpPackReportColumn(id: 'details', title: 'Details', titleAr: 'التفاصيل', flexFactor: 3),
      ],
      rows: [
        for (final metric in metrics)
          GeniusErpPackReportRow(
            cells: {
              'kind': 'Metric',
              'reference': metric.id,
              'label': GeniusErpPackLocalizedValue(
                value: metric.label,
                valueAr: metric.labelAr,
              ),
              'value': GeniusErpPackLocalizedValue(
                value: metric.value,
                valueAr: metric.valueAr,
              ),
              'details': [
                if (metric.delta != null) 'delta=${metric.delta}',
                if (metric.status != null) 'status=${metric.status}',
              ].join(' · '),
            },
          ),
        for (final stage in stages)
          GeniusErpPackReportRow(
            cells: {
              'kind': 'Stage',
              'reference': stage.stage.name,
              'label': GeniusErpPackLocalizedValue(
                value: stage.label,
                valueAr: stage.labelAr,
              ),
              'value': '${stage.count}',
              'details':
                  '${stage.amount.toDouble().toStringAsFixed(stage.amount.currency.precision)} '
                  '${stage.amount.currency.code}'
                  '${stage.isCurrent ? ' · CURRENT' : ''}',
            },
          ),
        for (final item in timeline)
          GeniusErpPackReportRow(
            cells: {
              'kind': 'Timeline',
              'reference': item.reference,
              'label': GeniusErpPackLocalizedValue(
                value: item.title,
                valueAr: item.titleAr,
              ),
              'value': item.timestamp.toIso8601String(),
              'details': GeniusErpPackLocalizedValue(
                value: item.description ?? '',
                valueAr: item.descriptionAr,
              ),
            },
          ),
        for (final block in contacts)
          GeniusErpPackReportRow(
            cells: {
              'kind': 'Contact Block',
              'reference': block.partyId,
              'label': GeniusErpPackLocalizedValue(
                value: block.partyName,
                valueAr: block.partyNameAr,
              ),
              'value': '${block.contacts.length} contacts',
              'details': GeniusErpPackLocalizedValue(
                value: block.address ?? '',
                valueAr: block.addressAr,
              ),
            },
          ),
        for (final attachment in attachments)
          GeniusErpPackReportRow(
            cells: {
              'kind': 'Attachment',
              'reference': attachment.reference,
              'label': GeniusErpPackLocalizedValue(
                value: attachment.label,
                valueAr: attachment.labelAr,
              ),
              'value': attachment.mediaType ?? '',
              'details': attachment.uri ?? '',
            },
          ),
      ],
    );
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
}
