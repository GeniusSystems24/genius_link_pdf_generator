// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/dashboard_sidebar.dart';
import 'dashboard_home.dart';
import 'screens/components_demo_screen.dart';
import 'screens/templates_demo_screen.dart';
import 'screens/new_templates_demo_screen.dart';
import 'screens/template_engine_demo_screen.dart';
import 'screens/security_demo_screen.dart';
import 'screens/export_demo_screen.dart';
import 'screens/printing_demo_screen.dart';
import 'screens/sharing_demo_screen.dart';
import 'screens/ai_features_demo_screen.dart';
import 'screens/v2_architecture_demo_screen.dart';
import 'screens/barcode_demo_screen.dart';
import 'screens/examples_showcase_screen.dart';
import 'screens/job_manager_demo_screen.dart';
import 'screens/custom_report_screen.dart';
import 'screens/modern_vouchers_demo_screen.dart';
import 'dart:ui'; // For ImageFilter

/// Modern Dashboard Layout with Glassmorphism and Smooth Navigation
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  String _selectedId = 'dashboard';
  bool _sidebarCollapsed = false;

  void _onItemSelected(String id) {
    setState(() => _selectedId = id);
  }

  void _toggleSidebar() {
    setState(() => _sidebarCollapsed = !_sidebarCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile =
        screenWidth < 1024; // Increased breakpoint for tablet support

    if (isMobile) {
      return _buildMobileLayout(isDark);
    }

    return _buildDesktopLayout(isDark);
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        children: [
          // Background Gradient Orbs (Optional for extra flair)
          if (isDark) ...[
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],

          Row(
            children: [
              DashboardSidebar(
                selectedId: _selectedId,
                onItemSelected: _onItemSelected,
                isCollapsed: _sidebarCollapsed,
                onToggleCollapse: _toggleSidebar,
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(isDark),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBg : AppColors.lightBg,
                        ),
                        child: ClipRect(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.02, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: KeyedSubtree(
                              key: ValueKey(_selectedId),
                              child: _buildContent(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : AppColors.lightSurface.withValues(alpha: 0.8),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded,
                color: isDark ? AppColors.darkText : AppColors.lightText),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getTitle(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            onPressed: () => themeController.toggleTheme(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: _buildMobileDrawer(isDark),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildMobileDrawer(bool isDark) {
    final items = [
      _DrawerItem('dashboard', 'Dashboard', Icons.dashboard_rounded),
      _DrawerItem('components', 'Components', Icons.widgets_rounded),
      _DrawerItem('grid_qrcode', 'Grid+QR', Icons.qr_code_rounded),
      _DrawerItem('grid_infobox', 'Grid+Info', Icons.view_agenda_rounded),
      _DrawerItem('grid_watermark', 'Grid+Watermark', Icons.water_drop_rounded),
      _DrawerItem('grid_richtext', 'Grid+RichText', Icons.format_quote_rounded),
      _DrawerItem('templates', 'Templates', Icons.description_rounded),
      _DrawerItem('templates_demo', 'Templates Demo', Icons.view_quilt_rounded),
      _DrawerItem('modern_vouchers', 'Modern Vouchers', Icons.verified_rounded),
      _DrawerItem(
          'new_templates', 'Business Templates', Icons.auto_awesome_rounded),
      _DrawerItem('template_engine', 'Template Engine', Icons.tune_rounded),
      _DrawerItem('barcodes', 'Barcodes & QR', Icons.qr_code_2_rounded),
      _DrawerItem('security', 'Security', Icons.security_rounded),
      _DrawerItem('examples', 'Examples', Icons.auto_awesome_mosaic_rounded),
      _DrawerItem('export', 'Export', Icons.file_download_rounded),
      _DrawerItem('printing', 'Printing', Icons.print_rounded),
      _DrawerItem('sharing', 'Sharing', Icons.share_rounded),
      _DrawerItem('ai_features', 'AI Features', Icons.smart_toy_rounded),
      _DrawerItem('advanced', 'Advanced', Icons.auto_awesome_rounded),
      _DrawerItem(
          'v2_architecture', 'V2 Architecture', Icons.account_tree_rounded),
      _DrawerItem('job_manager', 'Job Manager', Icons.work_history_rounded),
      _DrawerItem('custom_report', 'Custom Report', Icons.post_add_rounded),
    ];

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Genius PDF',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'v2.3.3+1',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = _selectedId == item.id ||
                    (_selectedId.startsWith(item.id.split('_').first) &&
                        item.id != 'dashboard');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkText
                                : AppColors.lightText),
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemSelected(item.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightSurface.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_selectedId != 'dashboard')
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkCard : AppColors.lightCard,
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: () => _onItemSelected('dashboard'),
                tooltip: 'Back to Dashboard',
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTitle(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildSearchBar(isDark),
          const SizedBox(width: 20),
          _buildNotificationButton(isDark),
          const SizedBox(width: 12),
          _buildProfileButton(isDark),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      width: 320,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(
            Icons.search_rounded,
            size: 20,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search features, templates...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBg : AppColors.lightBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Text(
              '⌘K',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(bool isDark) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            size: 22,
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget _buildProfileButton(bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'GP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_selectedId) {
      case 'dashboard':
        return 'Dashboard';
      case 'components':
      case 'data_grid':
      case 'rich_text':
      case 'info_box':
      case 'headers':
      case 'summary':
      case 'grid_qrcode':
      case 'grid_infobox':
      case 'grid_watermark':
      case 'grid_richtext':
        return 'Components';
      case 'templates':
      case 'templates_demo':
      case 'invoices':
        return 'Templates';
      case 'new_templates':
        return 'Business Templates';
      case 'template_engine':
        return 'Template Engine';
      case 'financial':
      case 'sales':
      case 'hr':
        return 'Business Templates';
      case 'barcodes':
        return 'Barcodes & QR';
      case 'security':
        return 'Security';
      case 'export':
        return 'Export';
      case 'printing':
        return 'Printing';
      case 'sharing':
        return 'Sharing';
      case 'ai_features':
        return 'AI Features';
      case 'advanced':
      case 'v2_architecture':
        return 'Advanced Features';
      case 'examples':
        return 'Examples';
      case 'job_manager':
        return 'Job Manager';
      case 'custom_report':
        return 'Custom Report';
      case 'modern_vouchers':
        return 'Modern Vouchers';
      default:
        return 'Genius PDF';
    }
  }

  Widget _buildContent() {
    switch (_selectedId) {
      case 'dashboard':
        return DashboardHome(onNavigate: _onItemSelected);

      // Components
      case 'components':
      case 'data_grid':
        return const ComponentsDemoScreen(initialTab: 0);
      case 'rich_text':
        return const ComponentsDemoScreen(initialTab: 1);
      case 'info_box':
        return const ComponentsDemoScreen(initialTab: 2);
      case 'headers':
        return const ComponentsDemoScreen(initialTab: 3);
      case 'summary':
        return const ComponentsDemoScreen(initialTab: 4);
      case 'grid_qrcode':
        return const ComponentsDemoScreen(initialTab: 5);
      case 'grid_infobox':
        return const ComponentsDemoScreen(initialTab: 6);
      case 'grid_watermark':
        return const ComponentsDemoScreen(initialTab: 7);
      case 'grid_richtext':
        return const ComponentsDemoScreen(initialTab: 8);

      // Templates
      case 'templates':
      case 'templates_demo':
      case 'invoices':
        return const TemplatesDemoScreen(initialTab: 0);
      case 'new_templates':
        return const NewTemplatesDemoScreen(initialTab: 0);
      case 'template_engine':
        return const TemplateEngineDemoScreen();
      case 'financial':
        return const NewTemplatesDemoScreen(initialTab: 0);
      case 'sales':
        return const NewTemplatesDemoScreen(initialTab: 1);
      case 'hr':
        return const NewTemplatesDemoScreen(initialTab: 2);

      // Barcodes & QR Codes
      case 'barcodes':
        return const BarcodeDemoScreen();

      // Other Features
      case 'security':
        return const SecurityDemoScreen();
      case 'export':
        return const ExportDemoScreen();
      case 'printing':
        return const PrintingDemoScreen();
      case 'sharing':
        return const SharingDemoScreen();
      case 'ai_features':
        return const AiFeaturesDemoScreen();
      case 'advanced':
      case 'v2_architecture':
        return const V2ArchitectureDemoScreen();
      case 'examples':
        return const ExamplesShowcaseScreen();
      case 'job_manager':
        return const JobManagerDemoScreen();
      case 'custom_report':
        return const CustomReportScreen();
      case 'modern_vouchers':
        return const ModernVouchersDemoScreen();

      default:
        return DashboardHome(onNavigate: _onItemSelected);
    }
  }
}

class _DrawerItem {
  final String id;
  final String title;
  final IconData icon;

  _DrawerItem(this.id, this.title, this.icon);
}
