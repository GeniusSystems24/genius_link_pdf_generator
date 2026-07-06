import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/app/controllers/theme_controller.dart';

void main() {
  test('theme controller toggles between dark and light modes', () {
    final controller = ThemeController();

    expect(controller.value, ThemeMode.dark);
    controller.toggleTheme();
    expect(controller.value, ThemeMode.light);
    controller.setDark();
    expect(controller.value, ThemeMode.dark);
    controller.setLight();
    expect(controller.value, ThemeMode.light);
  });
}
