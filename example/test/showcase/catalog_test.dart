import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/app/navigation/showcase_catalog.dart';

void main() {
  test('showcase destination identifiers are unique', () {
    final ids = ShowcaseCatalog.destinations.map((item) => item.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('core package workflows remain discoverable', () {
    final ids = ShowcaseCatalog.destinations.map((item) => item.id).toSet();
    expect(
      ids,
      containsAll(<String>{
        'dashboard',
        'getting-started',
        'document-builder',
        'configuration',
        'typography',
        'directionality',
        'headers-footers',
        'tables-reports',
        'media',
        'reusable-components',
        'templates',
        'business-documents',
        'preview',
        'delivery',
        'pdf-operations',
        'background-generation',
        'batch-generation',
        'job-queues',
        'architecture-di',
        'testing',
      }),
    );
  });

  test('every destination has developer-facing metadata', () {
    for (final item in ShowcaseCatalog.destinations) {
      expect(item.id.trim(), isNotEmpty, reason: 'id');
      expect(item.title.trim(), isNotEmpty, reason: item.id);
      expect(item.description.trim(), isNotEmpty, reason: item.id);
    }
  });
}
