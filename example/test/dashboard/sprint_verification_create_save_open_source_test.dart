import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const pages = <String>[
    'example/lib/features/dashboard/presentation/pages/s00_baseline_regression_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s01_directionality_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s02_components_rtl_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s03_flow_layout_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s04_data_grid_vnext_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s05_formatting_theme_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s06_erp_domain_calculation_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s07_erp_semantic_components_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s08_erp_document_families_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s09_migrated_transaction_templates_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s10_template_family_consolidation_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s11_print_profiles_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s12_sales_erp_pack_verification_page.dart',
    'example/lib/features/dashboard/presentation/pages/s13_purchasing_erp_pack_verification_page.dart',
  ];

  test('S00..S13 verification pages expose create-save-open', () {
    for (final path in pages) {
      final source = File(path).readAsStringSync();

      expect(
        source,
        contains('CreateSaveOpenPdfButton('),
        reason: path,
      );
      expect(
        source,
        contains('onCreate: _'),
        reason: path,
      );
      expect(
        source,
        contains("create_save_open_pdf_button.dart"),
        reason: path,
      );
    }
  });

  test('shared button creates fresh bytes then saves and opens', () {
    final source = File(
      'example/lib/shared/presentation/widgets/'
      'create_save_open_pdf_button.dart',
    ).readAsStringSync();

    expect(source, contains('final bytes = await widget.onCreate();'));
    expect(source, contains('demoDocuments.saveAndOpen('));
    expect(source, contains('DemoStorageLocation.temporary'));
    expect(source, contains("Create → Save → Open"));
  });
}
