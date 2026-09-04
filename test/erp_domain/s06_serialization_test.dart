
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('serialization is an explicit boundary adapter', () {
    final identity = ErpDocumentIdentity(
      kind: ErpDocumentKind.invoice,
      number: 'INV-2026-001',
      issueDate: DateTime(2026, 9, 4),
      status: ErpDocumentStatus.posted,
      uuid: 'uuid-1',
    );

    final map = ErpDomainSerialization.documentIdentityToMap(identity);
    final restored = ErpDomainSerialization.documentIdentityFromMap(map);
    expect(restored, identity);
  });
}
