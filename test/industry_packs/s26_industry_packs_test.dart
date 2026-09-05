
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('built-in industry manifests are compatible with 4.0.0', () {
    final registry = GeniusPdfBuiltInIndustryPacks.registry();

    expect(registry.manifests, hasLength(5));
    for (final manifest in registry.manifests) {
      expect(
        () => manifest.validateForCore('4.0.0'),
        returnsNormally,
      );
      expect(manifest.templateIds, isNotEmpty);
    }
  });

  test('retail requires POS instead of duplicating core POS', () {
    const pack = GeniusPdfRetailIndustryPack();
    expect(pack.manifest.requiresCorePacks, contains('pos'));
    expect(pack.manifest.capabilities['duplicatesCorePos'], isFalse);
    expect(
      pack.templates().first.metadata['extendsCorePack'],
      'pos',
    );
  });

  test('restaurant exposes KOT table kitchen and delivery variants', () {
    const pack = GeniusPdfRestaurantIndustryPack();
    final ids = pack.templates().map((item) => item.templateId).toSet();

    expect(ids, contains('restaurant.kot'));
    expect(ids, contains('restaurant.table-ticket'));
    expect(ids, contains('restaurant.kitchen-section'));
    expect(ids, contains('restaurant.delivery-receipt'));
  });

  test('construction pack exposes progress BOQ property and billing', () {
    const pack = GeniusPdfConstructionRealEstateIndustryPack();
    final ids = pack.templates().map((item) => item.templateId).toSet();

    expect(ids, contains('construction.progress-certificate'));
    expect(ids, contains('construction.boq-report'));
    expect(ids, contains('real-estate.property-unit-document'));
    expect(ids, contains('construction.project-billing-extension'));
  });

  test('healthcare/education keeps regulated domain outside core', () {
    const pack = GeniusPdfHealthcareEducationShellPack();

    expect(
      pack.manifest.capabilities['genericReportShellsOnly'],
      isTrue,
    );
    expect(
      pack.manifest.capabilities['regulatedDomainModelsInCore'],
      isFalse,
    );
    expect(pack.manifest.domainExtensions, hasLength(2));
  });

  test('mobility/distribution/hospitality reuses core families', () {
    const pack = GeniusPdfMobilityDistributionHospitalityPack();

    expect(pack.manifest.capabilities['reusesCoreFamilies'], isTrue);
    expect(
      pack.manifest.requiresCorePacks,
      contains('service_logistics'),
    );
  });

  test('version compatibility rejects a future major core', () {
    const range = GeniusPdfIndustryVersionRange(
      minimumCore: '4.0.0',
      maximumCoreExclusive: '5.0.0',
    );
    expect(range.supports('4.9.9'), isTrue);
    expect(range.supports('5.0.0'), isFalse);
  });
}
