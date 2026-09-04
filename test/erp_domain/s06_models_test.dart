
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  group('S06 shared domain models', () {
    test('ErpMoney value semantics and currency precision', () {
      const a = ErpMoney.fromMinorUnits(
        1569750,
        currency: ErpCurrency.sar,
      );
      const b = ErpMoney.fromMinorUnits(
        1569750,
        currency: ErpCurrency.sar,
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.toDouble(), 15697.5);

      final kwd = ErpMoney.fromAmount(
        12.3456,
        currency: ErpCurrency.kwd,
      );
      expect(kwd.minorUnits, 12346);
      expect(kwd.toDouble(), 12.346);
    });

    test('address roles/contact metadata preserve optional nulls', () {
      const party = ErpParty(
        id: 'C1',
        name: 'Customer',
        addresses: [
          ErpAddress(
            role: ErpAddressRole.billing,
            city: 'Riyadh',
            countryCode: 'SA',
          ),
        ],
        contacts: [
          ErpContactMetadata(email: 'customer@example.com'),
        ],
      );

      expect(
        party.addressFor(ErpAddressRole.billing)?.city,
        'Riyadh',
      );
      expect(party.contacts.first.phone, isNull);
      expect(party.taxIdentity, isNull);
    });

    test('Quotation/PO/Invoice share ErpDocumentContext', () {
      const org = ErpOrganization(
        id: 'ORG',
        legalName: 'Genius Systems',
      );

      ErpDocumentContext context(ErpDocumentKind kind) =>
          ErpDocumentContext(
            organization: org,
            identity: ErpDocumentIdentity(
              kind: kind,
              number: '${kind.name}-1',
              issueDate: DateTime(2026, 9, 4),
            ),
            documentCurrency: ErpCurrency.sar,
          );

      expect(
        context(ErpDocumentKind.quotation).runtimeType,
        ErpDocumentContext,
      );
      expect(
        context(ErpDocumentKind.purchaseOrder).runtimeType,
        ErpDocumentContext,
      );
      expect(
        context(ErpDocumentKind.invoice).runtimeType,
        ErpDocumentContext,
      );
    });

    test('approval/signature/attachment metadata are reusable', () {
      final approval = ErpApproval(
        stage: 'Finance',
        status: ErpApprovalStatus.approved,
        decidedAt: DateTime(2026, 9, 4),
      );
      const signature = ErpSignature(
        signerName: 'Manager',
        digest: 'sha256:demo',
      );
      final attachment = ErpAttachment(
        id: 'A1',
        name: 'terms.pdf',
        uri: Uri.parse('file:///terms.pdf'),
      );

      expect(approval.status, ErpApprovalStatus.approved);
      expect(signature.digest, 'sha256:demo');
      expect(attachment.uri, isNotNull);
    });
  });
}
