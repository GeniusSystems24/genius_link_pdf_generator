
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusCrmCustomer customer() => const GeniusCrmCustomer(
      customerId: 'CUST-LATIN-001',
      name: 'Genius Customer',
      nameAr: 'عميل جينيس',
      email: 'finance@example.com',
      phone: '+966500001111',
      address: 'Riyadh, Saudi Arabia',
      addressAr: 'الرياض، المملكة العربية السعودية',
      contacts: [
        GeniusCrmContact(
          contactId: 'CONT-001',
          name: 'Ahmed Contact',
          nameAr: 'أحمد جهة الاتصال',
          email: 'ahmed@example.com',
          phone: '+966500002222',
        ),
      ],
    );

void main() {
  const service = GeniusCrmService();

  test('Arabic notes stay separate from Latin email and phone', () {
    final report = service.customerProfile(customer());

    expect(report.subtitle, 'CUST-LATIN-001');
    expect(report.rows.single.cells['email'], 'ahmed@example.com');
    expect(report.rows.single.cells['phone'], '+966500002222');
    expect(
      report.rows.single.cells['name'],
      isA<GeniusErpPackLocalizedValue>(),
    );
  });

  test('pipeline totals reconcile value and weighted amount by stage', () {
    final report = service.pipelineReport([
      GeniusCrmOpportunity(
        opportunityId: 'OPP-1',
        customerId: 'CUST-1',
        title: 'Opportunity One',
        createdAt: DateTime(2026, 1, 1),
        expectedCloseDate: DateTime(2026, 10, 1),
        value: ErpMoney.fromAmount(
          1000,
          currency: ErpCurrency.sar,
        ),
        stage: GeniusCrmOpportunityStage.proposal,
        probabilityPercent: 50,
      ),
      GeniusCrmOpportunity(
        opportunityId: 'OPP-2',
        customerId: 'CUST-2',
        title: 'Opportunity Two',
        createdAt: DateTime(2026, 1, 1),
        expectedCloseDate: DateTime(2026, 10, 1),
        value: ErpMoney.fromAmount(
          2000,
          currency: ErpCurrency.sar,
        ),
        stage: GeniusCrmOpportunityStage.proposal,
        probabilityPercent: 25,
      ),
    ]);

    final proposalRow = report.rows.firstWhere(
      (row) => row.cells['stage'] == 'proposal',
    );
    expect(proposalRow.cells['count'], 2);
    expect(proposalRow.cells['amount'], 3000);
    expect(proposalRow.cells['weighted'], 1000);
  });

  test('long activity history remains sorted and complete', () {
    final activities = List.generate(
      500,
      (index) => GeniusCrmActivity(
        activityId: 'ACT-$index',
        customerId: 'CUST-LATIN-001',
        occurredAt: DateTime(2026, 1, 1)
            .add(Duration(minutes: index)),
        type: index.isEven
            ? GeniusCrmActivityType.call
            : GeniusCrmActivityType.visit,
        subject: 'Activity $index',
        subjectAr: 'نشاط $index',
        notes: 'Long history note $index',
        notesAr: 'ملاحظة سجل عربية $index',
      ),
    );

    final report =
        service.customerHistory(customer(), activities);
    expect(report.rows, hasLength(500));
    expect(report.rows.first.cells['reference'], 'ACT-499');
    expect(report.rows.last.cells['reference'], 'ACT-0');
  });

  test('multi-page proposal calculation stays outside renderer', () {
    final proposal = GeniusCrmProposal(
      proposalNumber: 'PROP-2026-001',
      customer: customer(),
      issueDate: DateTime(2026, 9, 4),
      validUntil: DateTime(2026, 10, 4),
      lines: List.generate(
        250,
        (index) => GeniusCrmProposalLine(
          lineId: 'LINE-${index + 1}',
          description: 'Proposal item ${index + 1}',
          descriptionAr: 'بند عرض ${index + 1}',
          quantity: 2,
          unit: ErpUnit.each,
          unitPrice: ErpMoney.fromAmount(
            100,
            currency: ErpCurrency.sar,
          ),
          discountPercent: 10,
        ),
      ),
    );

    expect(proposal.total!.toDouble(), 45000);
    expect(service.proposal(proposal).rows, hasLength(250));
  });

  test('presentation primitives stay printable without chart dependency', () {
    final report = service.presentationOverview(
      metrics: const [
        GeniusCrmMetric(
          id: 'm1',
          label: 'Open Leads',
          value: '12',
        ),
      ],
      stages: [
        GeniusCrmStageStatus(
          stage: GeniusCrmOpportunityStage.proposal,
          label: 'Proposal',
          count: 3,
          amount: ErpMoney.fromAmount(
            5000,
            currency: ErpCurrency.sar,
          ),
        ),
      ],
      timeline: [
        GeniusCrmTimelineEntry(
          reference: 'ACT-1',
          timestamp: DateTime(2026, 9, 4),
          title: 'Visit',
        ),
      ],
      contacts: [
        GeniusCrmContactBlock(
          partyId: 'CUST-1',
          partyName: 'Customer',
          contacts: customer().contacts,
        ),
      ],
      attachments: const [
        GeniusCrmAttachmentReference(
          reference: 'ATT-1',
          label: 'Proposal attachment',
        ),
      ],
    );

    expect(report.rows, hasLength(5));
  });
}
