import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/app/routing/dashboard_destination_registry.dart';

void main() {

  test('S10 and S11 destinations are registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's10_template_family_consolidation',
      ),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's11_print_profiles',
      ),
      isTrue,
    );
  });



  test('S08 and S09 ERP destinations are registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's08_erp_document_families',
      ),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's09_migrated_transaction_templates',
      ),
      isTrue,
    );
  });



  test('S07 ERP Semantic Components destination is registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's07_erp_semantic_components',
      ),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.titleFor(
        's07_erp_semantic_components',
      ),
      'S07 ERP Semantic Components',
    );
  });



  test('S06 ERP Domain destination is registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations.any(
        (item) => item.id == 's06_erp_domain_calculation',
      ),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.titleFor(
        's06_erp_domain_calculation',
      ),
      'S06 ERP Domain & Calculations',
    );
  });


  test('S05 Formatting & Theme destination is registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations
          .any((item) => item.id == 's05_formatting_theme'),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.titleFor('s05_formatting_theme'),
      'S05 Formatting & Theme',
    );
  });


  test('S04 DataGrid vNext destination is registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations
          .any((item) => item.id == 's04_data_grid_vnext'),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.titleFor('s04_data_grid_vnext'),
      'S04 DataGrid vNext',
    );
  });



  test('S03 flow layout destination is registered', () {
    expect(
      DashboardDestinationRegistry.primaryDestinations
          .any((item) => item.id == 's03_flow_layout'),
      isTrue,
    );
    expect(
      DashboardDestinationRegistry.titleFor('s03_flow_layout'),
      'S03 Flow Layout',
    );
  });


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
