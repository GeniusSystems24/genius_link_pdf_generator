import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/app/routing/dashboard_destination_registry.dart';

void main() {
  test('dashboard primary destination identifiers are unique', () {
    final ids = DashboardDestinationRegistry.primaryDestinations
        .map((destination) => destination.id)
        .toList();

    expect(ids.toSet().length, ids.length);
    expect(ids, containsAll(<String>[
      'dashboard',
      's00_baseline',
      'components',
      'templates',
      'printing',
      'sharing',
      'job_manager',
    ]));
  });

  test('nested destinations resolve to their parent title', () {
    expect(DashboardDestinationRegistry.titleFor('s00_baseline'), 'S00 Baseline');
    expect(DashboardDestinationRegistry.titleFor('grid_qrcode'), 'Components');
    expect(DashboardDestinationRegistry.titleFor('sales'), 'Business Templates');
    expect(DashboardDestinationRegistry.titleFor('advanced'), 'Advanced Features');
  });
}
