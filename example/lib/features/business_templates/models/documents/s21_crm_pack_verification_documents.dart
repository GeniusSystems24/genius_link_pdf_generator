// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S21CrmPackVerificationPage.
enum S21CrmPackScenario {
  customer,
  lead,
  opportunity,
  pipeline,
  activity,
  visit,
  call,
  history,
  proposal,
  contract,
  presentation,
}

/// Executes one focused S21 verification scenario.
class S21CrmPackRunner {
  S21CrmPackRunner({
    required GeniusPdfConfig baseConfig,
    required S21CrmPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S21CrmPackScenario _scenario;
final GeniusCrmConfidentiality _confidentiality =
      GeniusCrmConfidentiality.none;
  bool _rtl = false;
  final int _rowCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S21CrmPackScenario value) => switch (value) {
        S21CrmPackScenario.customer => 'Customer Profile',
        S21CrmPackScenario.lead => 'Lead Report',
        S21CrmPackScenario.opportunity => 'Opportunity Report',
        S21CrmPackScenario.pipeline => 'Pipeline Report',
        S21CrmPackScenario.activity => 'Activity Report',
        S21CrmPackScenario.visit => 'Visit Report',
        S21CrmPackScenario.call => 'Call Report',
        S21CrmPackScenario.history => 'Customer History',
        S21CrmPackScenario.proposal => 'Proposal',
        S21CrmPackScenario.contract => 'Contract Summary',
        S21CrmPackScenario.presentation => 'Presentation Primitives',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S21 public API in '
      '${_rtl ? 'RTL' : 'LTR'} with ${_confidentiality.name} watermark policy. '
      'Arabic notes/names follow RTL while emails, phones, CRM IDs and proposal '
      'numbers remain structured. Pipeline totals reconcile and large activity/'
      'proposal datasets paginate without overlap.';

  GeniusCrmCustomer _customer() => const GeniusCrmCustomer(
        customerId: 'CUST-LATIN-001',
        name: 'Genius Enterprise Customer',
        nameAr: 'عميل جينيس المؤسسي',
        taxId: 'TAX-310000000000003',
        email: 'finance@example.com',
        phone: '+966500001111',
        address: 'Riyadh, Saudi Arabia',
        addressAr: 'الرياض، المملكة العربية السعودية',
        industry: 'Enterprise Services',
        industryAr: 'الخدمات المؤسسية',
        accountManager: 'Account Manager 01',
        accountManagerAr: 'مدير الحساب 01',
        contacts: [
          GeniusCrmContact(
            contactId: 'CONT-001',
            name: 'Ahmed Contact',
            nameAr: 'أحمد جهة الاتصال',
            jobTitle: 'Finance Manager',
            jobTitleAr: 'مدير المالية',
            email: 'ahmed@example.com',
            phone: '+966500002222',
            notes: 'Prefers email follow-up.',
            notesAr: 'يفضل المتابعة عبر البريد الإلكتروني.',
          ),
        ],
      );

  List<GeniusCrmOpportunity> _opportunities(int count) => List.generate(
        count,
        (index) => GeniusCrmOpportunity(
          opportunityId: 'OPP-${index + 1}',
          customerId: _customer().customerId,
          title: 'ERP Opportunity ${index + 1}',
          titleAr: 'فرصة نظام موارد ${index + 1}',
          createdAt: DateTime(2026, 1, 1),
          expectedCloseDate: DateTime(2026, 10, index % 28 + 1),
          value: ErpMoney.fromAmount(
            1000 + index * 25,
            currency: ErpCurrency.sar,
          ),
          stage: GeniusCrmOpportunityStage.values[
              index % GeniusCrmOpportunityStage.values.length],
          probabilityPercent: (index % 11) * 10,
          owner: 'Sales ${index % 8 + 1}',
          ownerAr: 'المبيعات ${index % 8 + 1}',
        ),
      );

  List<GeniusCrmActivity> _activities(int count) => List.generate(
        count,
        (index) => GeniusCrmActivity(
          activityId: 'ACT-${index + 1}',
          customerId: _customer().customerId,
          occurredAt: DateTime(2026, 9, 1)
              .add(Duration(minutes: index * 30)),
          type: index.isEven
              ? GeniusCrmActivityType.call
              : GeniusCrmActivityType.visit,
          subject: index == 0
              ? 'Long CRM activity subject for wrapping verification'
              : 'Activity ${index + 1}',
          subjectAr: index == 0
              ? 'موضوع نشاط إدارة عملاء عربي طويل للتحقق من التفاف النص'
              : 'نشاط ${index + 1}',
          contact: _customer().contacts.first,
          owner: 'Owner ${index % 5 + 1}',
          ownerAr: 'المسؤول ${index % 5 + 1}',
          outcome: 'Follow-up required',
          outcomeAr: 'تحتاج متابعة',
          notes: index == 0
              ? List.filled(15, 'Long activity history note.').join(' ')
              : 'Activity note',
          notesAr: index == 0
              ? List.filled(15, 'ملاحظة سجل نشاط عربية طويلة.').join(' ')
              : 'ملاحظة نشاط',
        ),
      );

  GeniusCrmProposal _proposal(int count) => GeniusCrmProposal(
        proposalNumber: 'PROP-LATIN-2026-001',
        customer: _customer(),
        issueDate: DateTime(2026, 9, 4),
        validUntil: DateTime(2026, 10, 4),
        title: 'Enterprise ERP Proposal',
        titleAr: 'عرض نظام موارد مؤسسي',
        confidentiality: _confidentiality,
        lines: List.generate(
          count,
          (index) => GeniusCrmProposalLine(
            lineId: 'LINE-${index + 1}',
            description: index == 0
                ? List.filled(
                    8,
                    'Long proposal item description for wrapping.',
                  ).join(' ')
                : 'Proposal item ${index + 1}',
            descriptionAr: index == 0
                ? List.filled(
                    8,
                    'وصف بند عرض عربي طويل للتحقق من الالتفاف.',
                  ).join(' ')
                : 'بند العرض ${index + 1}',
            quantity: 2,
            unit: ErpUnit.each,
            unitPrice: ErpMoney.fromAmount(
              100,
              currency: ErpCurrency.sar,
            ),
            discountPercent: 10,
          ),
        ),
        terms: 'Proposal terms and optional long commercial notes.',
        termsAr: 'شروط العرض وملاحظات تجارية عربية اختيارية.',
      );

  Future<Uint8List> generate() async {
    const service = GeniusCrmService();
    final config = _config;
    final count = _rowCount;
    final opportunities = _opportunities(count);
    final activities = _activities(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S21CrmPackScenario.customer:
        document = GeniusCustomerProfileDocument(
          config,
          report: service.customerProfile(_customer()),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.lead:
        document = GeniusLeadReportDocument(
          config,
          report: service.leadReport(
            List.generate(
              count,
              (index) => GeniusCrmLead(
                leadId: 'LEAD-${index + 1}',
                name: 'Lead ${index + 1}',
                nameAr: 'عميل محتمل ${index + 1}',
                createdAt: DateTime(2026, 9, 1),
                company: 'Company ${index + 1}',
                companyAr: 'شركة ${index + 1}',
                email: 'lead$index@example.com',
                phone: '+9665${(10000000 + index)}',
                source: 'Campaign',
                sourceAr: 'حملة',
                owner: 'Sales 01',
                ownerAr: 'المبيعات 01',
                status: GeniusCrmLeadStatus.values[
                    index % GeniusCrmLeadStatus.values.length],
                estimatedValue: ErpMoney.fromAmount(
                  500 + index,
                  currency: ErpCurrency.sar,
                ),
              ),
            ),
          ),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.opportunity:
        document = GeniusOpportunityReportDocument(
          config,
          report: service.opportunityReport(opportunities),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.pipeline:
        document = GeniusPipelineReportDocument(
          config,
          report: service.pipelineReport(opportunities),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.activity:
        document = GeniusActivityReportDocument(
          config,
          report: service.activityReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.visit:
        document = GeniusVisitReportDocument(
          config,
          report: service.visitReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.call:
        document = GeniusCallReportDocument(
          config,
          report: service.callReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.history:
        document = GeniusCustomerHistoryDocument(
          config,
          report: service.customerHistory(
            _customer(),
            activities,
          ),
          confidentiality: _confidentiality,
        );
        break;
      case S21CrmPackScenario.proposal:
        final proposal = _proposal(count);
        document = GeniusProposalDocument(
          config,
          report: service.proposal(proposal),
          confidentiality: proposal.confidentiality,
        );
        break;
      case S21CrmPackScenario.contract:
        final contract = GeniusCrmContractSummary(
          contractNumber: 'CONTRACT-LATIN-001',
          customer: _customer(),
          effectiveFrom: DateTime(2026, 1, 1),
          effectiveTo: DateTime(2026, 12, 31),
          title: 'ERP Service Contract',
          titleAr: 'عقد خدمات نظام الموارد',
          status: 'Active',
          statusAr: 'ساري',
          value: ErpMoney.fromAmount(
            125000,
            currency: ErpCurrency.sar,
          ),
          scope: List.filled(
            10,
            'Long contract scope statement.',
          ).join(' '),
          scopeAr: List.filled(
            10,
            'بيان نطاق عقد عربي طويل.',
          ).join(' '),
          references: const ['REF-001', 'REF-002'],
          attachments: const [
            GeniusCrmAttachmentReference(
              reference: 'ATT-001',
              label: 'Terms',
              labelAr: 'الشروط',
            ),
          ],
          confidentiality: _confidentiality,
        );
        document = GeniusContractSummaryDocument(
          config,
          report: service.contractSummary(contract),
          confidentiality: contract.confidentiality,
        );
        break;
      case S21CrmPackScenario.presentation:
        document = GeniusCrmPresentationOverviewDocument(
          config,
          report: service.presentationOverview(
            metrics: const [
              GeniusCrmMetric(
                id: 'open-leads',
                label: 'Open Leads',
                labelAr: 'العملاء المحتملون المفتوحون',
                value: '42',
                status: 'good',
              ),
            ],
            stages: [
              GeniusCrmStageStatus(
                stage: GeniusCrmOpportunityStage.proposal,
                label: 'Proposal',
                labelAr: 'عرض',
                count: opportunities.length,
                amount: opportunities.isEmpty
                    ? ErpMoney.zero(ErpCurrency.sar)
                    : opportunities
                        .map((item) => item.value)
                        .reduce((a, b) => a + b),
                isCurrent: true,
              ),
            ],
            timeline: [
              for (final item in activities.take(10))
                GeniusCrmTimelineEntry(
                  reference: item.activityId,
                  timestamp: item.occurredAt,
                  title: item.subject,
                  titleAr: item.subjectAr,
                  description: item.notes,
                  descriptionAr: item.notesAr,
                ),
            ],
            contacts: [
              GeniusCrmContactBlock(
                partyId: _customer().customerId,
                partyName: _customer().name,
                partyNameAr: _customer().nameAr,
                contacts: _customer().contacts,
                address: _customer().address,
                addressAr: _customer().addressAr,
              ),
            ],
            attachments: const [
              GeniusCrmAttachmentReference(
                reference: 'ATT-CRM-001',
                label: 'CRM attachment',
                labelAr: 'مرفق إدارة العملاء',
              ),
            ],
          ),
          confidentiality: _confidentiality,
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }
}


Future<Uint8List> buildS21CustomerVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.customer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21LeadVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.lead,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21OpportunityVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.opportunity,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21PipelineVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.pipeline,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21ActivityVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.activity,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21VisitVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.visit,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21CallVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.call,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21HistoryVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.history,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21ProposalVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.proposal,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21ContractVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.contract,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS21PresentationVerificationPdf(GeniusPdfConfig config) {
  final runner = S21CrmPackRunner(
    baseConfig: config,
    scenario: S21CrmPackScenario.presentation,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
