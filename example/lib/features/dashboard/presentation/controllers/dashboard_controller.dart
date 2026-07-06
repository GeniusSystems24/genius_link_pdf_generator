import 'package:flutter/foundation.dart';

final class DashboardController extends ChangeNotifier {
  DashboardController({String initialDestination = 'dashboard'})
      : _selectedId = initialDestination;

  String _selectedId;
  bool _sidebarCollapsed = false;

  String get selectedId => _selectedId;
  bool get isSidebarCollapsed => _sidebarCollapsed;

  void select(String destinationId) {
    if (_selectedId == destinationId) return;
    _selectedId = destinationId;
    notifyListeners();
  }

  void toggleSidebar() {
    _sidebarCollapsed = !_sidebarCollapsed;
    notifyListeners();
  }

  void showDashboard() => select('dashboard');
}
