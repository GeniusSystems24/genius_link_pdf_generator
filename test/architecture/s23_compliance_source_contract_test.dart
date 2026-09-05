
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S23 delegates security to existing GeniusPdfSecurityService', () {
    final source = File(
      'lib/src/compliance/enterprise_security_policy.dart',
    ).readAsStringSync();

    expect(source, contains('GeniusPdfSecurityService.applySecurity'));
    expect(source, contains('GeniusPdfSecuritySettings'));
    expect(source, isNot(contains('PdfEncryptionAlgorithm.')));
  });

  test('S23 base profile contains no country-specific law', () {
    final source = File(
      'lib/src/compliance/compliance_profile.dart',
    ).readAsStringSync();

    expect(source, contains('GeniusPdfCompliancePlugin'));
    expect(source, contains('sourceReferences'));
    expect(source, isNot(contains('VAT rate')));
    expect(source, isNot(contains('tax law requires')));
  });

  test('approval and cryptographic signature models are separate', () {
    final source = File(
      'lib/src/compliance/compliance_models.dart',
    ).readAsStringSync();

    expect(source, contains('class GeniusPdfBusinessApproval'));
    expect(source, contains('class GeniusPdfSigningMetadata'));
    expect(
      source,
      contains('GeniusPdfCertificateSignatureProvider'),
    );
    expect(source, contains('GeniusPdfTimestampProvider'));
    expect(source, contains('GeniusPdfDocumentHashProvider'));
  });
}
