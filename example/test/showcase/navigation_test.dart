import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/app/localization/showcase_localizations.dart';
import 'package:genius_pdf_example/app/navigation/showcase_catalog.dart';
import 'package:genius_pdf_example/app/navigation/showcase_navigation.dart';

void main() {
  test('navigation is built from the showcase catalog', () {
    final sections = ShowcaseNavigation.build(
      ShowcaseCatalog.destinations,
      ShowcaseL10n(Locale("ar")),
    );
    expect(sections, isNotEmpty);
    expect(sections.first.items, isNotEmpty);
  });

  test('advanced section is conditional on advanced destinations', () {
    final advanced = ShowcaseCatalog.destinations
        .where((item) => item.group == ShowcaseGroup.advanced)
        .toList();
    final sections = ShowcaseNavigation.build(
      ShowcaseCatalog.destinations,
      ShowcaseL10n(Locale("ar")),
    );

    if (advanced.isEmpty) {
      expect(
        sections.any((section) => section.title == 'Advanced & optional'),
        isFalse,
      );
    } else {
      expect(
        sections.any((section) => section.title == 'Advanced & optional'),
        isTrue,
      );
    }
  });
}
