
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S21Scenario {
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

class S21CrmPackVerificationPage extends StatefulWidget {
  const S21CrmPackVerificationPage({super.key});

  @override
  State<S21CrmPackVerificationPage> createState() =>
      _S21CrmPackVerificationPageState();
}

class _S21CrmPackVerificationPageState
    extends State<S21CrmPackVerificationPage> {
  _S21Scenario _scenario = _S21Scenario.pipeline;
  GeniusCrmConfidentiality _confidentiality =
      GeniusCrmConfidentiality.none;
  bool _rtl = false;
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

  String _label(_S21Scenario value) => switch (value) {
        _S21Scenario.customer => 'Customer Profile',
        _S21Scenario.lead => 'Lead Report',
        _S21Scenario.opportunity => 'Opportunity Report',
        _S21Scenario.pipeline => 'Pipeline Report',
        _S21Scenario.activity => 'Activity Report',
        _S21Scenario.visit => 'Visit Report',
        _S21Scenario.call => 'Call Report',
        _S21Scenario.history => 'Customer History',
        _S21Scenario.proposal => 'Proposal',
        _S21Scenario.contract => 'Contract Summary',
        _S21Scenario.presentation => 'Presentation Primitives',
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

  Future<Uint8List> _generate() async {
    const service = GeniusCrmService();
    final config = _config;
    final count = _rowCount;
    final opportunities = _opportunities(count);
    final activities = _activities(count);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S21Scenario.customer:
        document = GeniusCustomerProfileDocument(
          config,
          report: service.customerProfile(_customer()),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.lead:
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
      case _S21Scenario.opportunity:
        document = GeniusOpportunityReportDocument(
          config,
          report: service.opportunityReport(opportunities),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.pipeline:
        document = GeniusPipelineReportDocument(
          config,
          report: service.pipelineReport(opportunities),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.activity:
        document = GeniusActivityReportDocument(
          config,
          report: service.activityReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.visit:
        document = GeniusVisitReportDocument(
          config,
          report: service.visitReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.call:
        document = GeniusCallReportDocument(
          config,
          report: service.callReport(activities),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.history:
        document = GeniusCustomerHistoryDocument(
          config,
          report: service.customerHistory(
            _customer(),
            activities,
          ),
          confidentiality: _confidentiality,
        );
        break;
      case _S21Scenario.proposal:
        final proposal = _proposal(count);
        document = GeniusProposalDocument(
          config,
          report: service.proposal(proposal),
          confidentiality: proposal.confidentiality,
        );
        break;
      case _S21Scenario.contract:
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
      case _S21Scenario.presentation:
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

  void _refresh() {
    setState(() => _pdf = _generate());
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
                    'Sprint S21 — CRM Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 260,
                        child: DropdownButtonFormField<_S21Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S21Scenario.values)
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
                      SizedBox(
                        width: 190,
                        child: DropdownButtonFormField<GeniusCrmConfidentiality>(
                          initialValue: _confidentiality,
                          decoration: const InputDecoration(
                            labelText: 'Watermark',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value
                                in GeniusCrmConfidentiality.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(value.name),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _confidentiality = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 50, label: Text('50')),
                          ButtonSegment(value: 250, label: Text('250')),
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
                        fileName: 's21_crm_pack.pdf',
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
                    return const Center(child: CircularProgressIndicator());
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
