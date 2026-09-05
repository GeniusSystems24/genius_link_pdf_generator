
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S26 plugin contract has manifest/domain/compliance/version boundaries', () {
    final source = File(
      'lib/src/industry_packs/industry_pack_contract.dart',
    ).readAsStringSync();

    for (final marker in [
      'GeniusPdfIndustryPack',
      'GeniusPdfIndustryPackManifest',
      'GeniusPdfIndustryDomainExtension',
      'GeniusPdfIndustryComplianceHook',
      'GeniusPdfIndustryVersionRange',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S26 healthcare/education uses external plugin model namespaces', () {
    final source = File(
      'lib/src/industry_packs/industry_packs.dart',
    ).readAsStringSync();

    expect(source, contains('plugin.healthcare'));
    expect(source, contains('plugin.education'));
    expect(source, contains('regulatedDomainModelsInCore'));
    expect(source, contains("'regulatedDomainModelsInCore': false"));
  });

  test('S26 reuses POS/service/logistics/transaction families', () {
    final source = File(
      'lib/src/industry_packs/industry_packs.dart',
    ).readAsStringSync();

    expect(source, contains("'extendsCorePack': 'pos'"));
    expect(source, contains('service_logistics'));
    expect(source, contains('transaction-family'));
  });
}
