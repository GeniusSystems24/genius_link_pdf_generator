import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Navigation Item Model
class NavItem {
  final String id;
  final String title;
  final IconData icon;
  final List<Color>? gradient;
  final List<NavItem>? children;
  final bool isExpanded;

  const NavItem({
    required this.id,
    required this.title,
    required this.icon,
    this.gradient,
    this.children,
    this.isExpanded = false,
  });

  NavItem copyWith({bool? isExpanded}) {
    return NavItem(
      id: id,
      title: title,
      icon: icon,
      gradient: gradient,
      children: children,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// Dashboard Sidebar Navigation
class DashboardSidebar extends StatefulWidget {
  final String selectedId;
  final Function(String) onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const DashboardSidebar({
    super.key,
    required this.selectedId,
    required this.onItemSelected,
    this.isCollapsed = false,
    required this.onToggleCollapse,
  });

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  final List<NavItem> _navItems = [
    const NavItem(
      id: 'dashboard',
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      gradient: AppColors.primaryGradient,
    ),
    NavItem(
      id: 'components',
      title: 'Components',
      icon: Icons.widgets_rounded,
      gradient: AppColors.infoGradient,
      children: [
        const NavItem(
          id: 'data_grid',
          title: 'Data Grid',
          icon: Icons.table_chart_rounded,
        ),
        const NavItem(
          id: 'rich_text',
          title: 'Rich Text',
          icon: Icons.text_fields_rounded,
        ),
        const NavItem(
          id: 'info_box',
          title: 'Info Box',
          icon: Icons.info_rounded,
        ),
        const NavItem(
          id: 'headers',
          title: 'Headers',
          icon: Icons.article_rounded,
        ),
        const NavItem(
          id: 'summary',
          title: 'Summary',
          icon: Icons.calculate_rounded,
        ),
      ],
    ),
    NavItem(
      id: 'charts',
      title: 'Charts',
      icon: Icons.bar_chart_rounded,
      gradient: AppColors.successGradient,
      children: [
        const NavItem(
          id: 'bar_chart',
          title: 'Bar Chart',
          icon: Icons.bar_chart_rounded,
        ),
        const NavItem(
          id: 'line_chart',
          title: 'Line Chart',
          icon: Icons.show_chart_rounded,
        ),
        const NavItem(
          id: 'pie_chart',
          title: 'Pie Chart',
          icon: Icons.pie_chart_rounded,
        ),
        const NavItem(
          id: 'area_chart',
          title: 'Area Chart',
          icon: Icons.area_chart_rounded,
        ),
      ],
    ),
    NavItem(
      id: 'templates',
      title: 'Templates',
      icon: Icons.description_rounded,
      gradient: AppColors.purpleGradient,
      children: [
        const NavItem(
          id: 'invoices',
          title: 'Invoices',
          icon: Icons.receipt_long_rounded,
        ),
        const NavItem(
          id: 'financial',
          title: 'Financial',
          icon: Icons.account_balance_rounded,
        ),
        const NavItem(
          id: 'sales',
          title: 'Sales Docs',
          icon: Icons.shopping_cart_rounded,
        ),
        const NavItem(
          id: 'hr',
          title: 'HR Reports',
          icon: Icons.people_rounded,
        ),
      ],
    ),
    const NavItem(
      id: 'barcodes',
      title: 'Barcodes & QR',
      icon: Icons.qr_code_rounded,
      gradient: AppColors.cyanGradient,
    ),
    const NavItem(
      id: 'security',
      title: 'Security',
      icon: Icons.security_rounded,
      gradient: AppColors.errorGradient,
    ),
    const NavItem(
      id: 'export',
      title: 'Export',
      icon: Icons.file_download_rounded,
      gradient: AppColors.cyanGradient,
    ),
    const NavItem(
      id: 'printing',
      title: 'Printing',
      icon: Icons.print_rounded,
      gradient: AppColors.orangeGradient,
    ),
    const NavItem(
      id: 'sharing',
      title: 'Sharing',
      icon: Icons.share_rounded,
      gradient: AppColors.tealGradient,
    ),
    const NavItem(
      id: 'ai_features',
      title: 'AI Features',
      icon: Icons.smart_toy_rounded,
      gradient: AppColors.warningGradient,
    ),
    const NavItem(
      id: 'advanced',
      title: 'Advanced',
      icon: Icons.auto_awesome_rounded,
      gradient: AppColors.pinkGradient,
    ),
  ];

  Set<String> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 260, end: 72).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isCollapsed) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(DashboardSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedItems.contains(id)) {
        _expandedItems.remove(id);
      } else {
        _expandedItems.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            border: Border(
              right: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(isDark),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: _navItems
                      .map((item) => _buildNavItem(item, isDark))
                      .toList(),
                ),
              ),
              _buildFooter(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    final isCollapsed = _widthAnimation.value < 150;

    return Container(
      padding: EdgeInsets.all(isCollapsed ? 12 : 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isCollapsed ? 40 : 44,
            height: isCollapsed ? 40 : 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.white,
              size: isCollapsed ? 20 : 24,
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Genius PDF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Text(
                    'v2.3.3+1',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(NavItem item, bool isDark) {
    final isCollapsed = _widthAnimation.value < 150;
    final isSelected = widget.selectedId == item.id ||
        (item.children?.any((c) => widget.selectedId == c.id) ?? false);
    final isExpanded = _expandedItems.contains(item.id);
    final hasChildren = item.children != null && item.children!.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 12,
            vertical: 2,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (hasChildren && !isCollapsed) {
                  _toggleExpanded(item.id);
                } else {
                  widget.onItemSelected(item.id);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? 12 : 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.transparent,
                  gradient: isSelected && item.gradient != null
                      ? LinearGradient(
                          colors: [
                            item.gradient!.first.withOpacity(0.15),
                            item.gradient!.last.withOpacity(0.05),
                          ],
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    _buildIcon(item, isSelected, isCollapsed),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? (item.gradient?.first ?? AppColors.primary)
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                      if (hasChildren)
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded && !isCollapsed)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: item.children!
                  .map((child) => _buildChildNavItem(child, isDark))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildChildNavItem(NavItem item, bool isDark) {
    final isSelected = widget.selectedId == item.id;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 12, top: 2, bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => widget.onItemSelected(item.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: 10),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(NavItem item, bool isSelected, bool isCollapsed) {
    if (item.gradient != null && isSelected) {
      return Container(
        width: isCollapsed ? 36 : 32,
        height: isCollapsed ? 36 : 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: item.gradient!),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: item.gradient!.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          item.icon,
          size: isCollapsed ? 18 : 16,
          color: Colors.white,
        ),
      );
    }

    return Icon(
      item.icon,
      size: isCollapsed ? 24 : 20,
      color: isSelected
          ? (item.gradient?.first ?? AppColors.primary)
          : (Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary),
    );
  }

  Widget _buildFooter(bool isDark) {
    final isCollapsed = _widthAnimation.value < 150;

    return Container(
      padding: EdgeInsets.all(isCollapsed ? 8 : 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildThemeToggle(isDark, isCollapsed),
          const SizedBox(height: 8),
          _buildCollapseButton(isDark, isCollapsed),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark, bool isCollapsed) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => themeController.toggleTheme(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 20,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Text(
                  isDark ? 'Light Mode' : 'Dark Mode',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapseButton(bool isDark, bool isCollapsed) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onToggleCollapse,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              AnimatedRotation(
                turns: isCollapsed ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Text(
                  'Collapse',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
