import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/dashboard_home.dart';
import 'package:genius_pdf_example/dashboard_layout.dart';
import 'package:genius_pdf_example/screens/components_demo_screen.dart';
import 'package:genius_pdf_example/screens/printing_demo_screen.dart';
import 'package:genius_pdf_example/theme/app_theme.dart';

void main() {
  test('legacy example imports remain available', () {
    expect(const DashboardLayout(), isA<DashboardLayout>());
    expect(
      DashboardHome(onNavigate: (_) {}),
      isA<DashboardHome>(),
    );
    expect(const ComponentsDemoScreen(), isA<ComponentsDemoScreen>());
    expect(const PrintingDemoScreen(), isA<PrintingDemoScreen>());
    expect(AppTheme.lightTheme, isNotNull);
  });
}
