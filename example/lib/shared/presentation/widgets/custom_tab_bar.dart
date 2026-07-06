import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<CustomTabItem> tabs;
  final bool isDark;
  final bool isScrollable;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.isDark,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        labelColor: AppColors.primary,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }

  Widget _buildTab(CustomTabItem tab) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: tab.gradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(tab.icon, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(tab.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class CustomTabItem {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  CustomTabItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
