
import 'package:flutter/material.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

import 'package:genius_pdf_example/app/navigation/example_navigation_catalog.dart';

/// Compatibility wrapper for older example code that instantiated
/// [DashboardSidebar] directly.
///
/// New application code should compose [SuperNavigationSidebar] in the host
/// layout instead.
class DashboardSidebar extends StatefulWidget {
  const DashboardSidebar({
    super.key,
    required this.selectedId,
    required this.onItemSelected,
    this.isCollapsed = false,
    required this.onToggleCollapse,
  });

  final String selectedId;
  final ValueChanged<String> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  late final SuperNavigationSidebarController<String> _controller;

  @override
  void initState() {
    super.initState();
    _controller = SuperNavigationSidebarController<String>(
      sections: ExampleNavigationCatalog.sections,
      active: widget.selectedId,
      collapsed: widget.isCollapsed,
    );
  }

  @override
  void didUpdateWidget(covariant DashboardSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _controller.navigate(widget.selectedId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperNavigationSidebar<String>(
      controller: _controller,
      mode: widget.isCollapsed
          ? SuperNavSidebarMode.rail
          : SuperNavSidebarMode.expanded,
      allowSearchView: true,
      favoritable: true,
      onNavigate: (node) {
        final id = node.value;
        if (id != null) widget.onItemSelected(id);
      },
    );
  }
}
