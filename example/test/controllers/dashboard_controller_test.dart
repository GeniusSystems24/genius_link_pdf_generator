import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/controllers/dashboard_controller.dart';

void main() {
  test('dashboard controller changes destination and sidebar state', () {
    final controller = DashboardController();
    var notifications = 0;
    controller.addListener(() => notifications++);

    expect(controller.selectedId, 'dashboard');
    expect(controller.isSidebarCollapsed, isFalse);

    controller.select('printing');
    controller.toggleSidebar();

    expect(controller.selectedId, 'printing');
    expect(controller.isSidebarCollapsed, isTrue);
    expect(notifications, 2);
  });
}
