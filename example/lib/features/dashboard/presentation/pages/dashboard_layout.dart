// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/app/routing/dashboard_destination_registry.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'dart:ui'; // For ImageFilter

/// Modern Dashboard Layout with Glassmorphism and Smooth Navigation
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key, this.controller});

  final DashboardController? controller;

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  late final DashboardController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? DashboardController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _onItemSelected(String id) => _controller.select(id);

  void _toggleSidebar() => _controller.toggleSidebar();

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
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
                selectedId: _controller.selectedId,
                onItemSelected: _onItemSelected,
                isCollapsed: _controller.isSidebarCollapsed,
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
                              key: ValueKey(_controller.selectedId),
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
      _DrawerItem('s02_components_rtl', 'S02 Components RTL', Icons.compare_arrows_rounded),
      _DrawerItem('s03_flow_layout', 'S03 Flow Layout', Icons.view_stream_rounded),
      _DrawerItem('s04_data_grid_vnext', 'S04 DataGrid vNext', Icons.table_chart_rounded),
      _DrawerItem('s05_formatting_theme', 'S05 Formatting & Theme', Icons.format_paint_rounded),
      _DrawerItem('s06_erp_domain_calculation', 'S06 ERP Domain & Calculations', Icons.calculate_rounded),
      _DrawerItem('s07_erp_semantic_components', 'S07 ERP Semantic Components', Icons.widgets_rounded),
      _DrawerItem('s08_erp_document_families', 'S08 ERP Document Families', Icons.account_tree_rounded),
      _DrawerItem('s09_migrated_transaction_templates', 'S09 Migrated Transaction Templates', Icons.description_rounded),
      _DrawerItem('s10_template_family_consolidation', 'S10 Template Family Consolidation', Icons.hub_rounded),
      _DrawerItem('s11_print_profiles', 'S11 Print Profiles', Icons.print_rounded),
      _DrawerItem('s13_purchasing_erp_pack', 'S13 Purchasing ERP Pack', Icons.shopping_cart_rounded),
      _DrawerItem('s14_accounting_finance_pack', 'S14 Accounting & Finance Pack', Icons.account_balance_rounded),
      _DrawerItem('s15_inventory_wms_pack', 'S15 Inventory & WMS Pack', Icons.inventory_2_rounded),
      _DrawerItem('s16_pos_retail_pack', 'S16 POS & Retail Pack', Icons.point_of_sale_rounded),
      _DrawerItem('s17_hr_payroll_pack', 'S17 HR & Payroll Pack', Icons.people_alt_rounded),
      _DrawerItem('s18_manufacturing_quality_pack', 'S18 Manufacturing & Quality Pack', Icons.precision_manufacturing_rounded),
      _DrawerItem('s19_fixed_assets_projects_pack', 'S19 Fixed Assets & Projects Pack', Icons.business_center_rounded),
      _DrawerItem('s20_maintenance_service_logistics_pack', 'S20 Maintenance, Service & Logistics Pack', Icons.local_shipping_rounded),
      _DrawerItem('s21_crm_pack', 'S21 CRM Pack', Icons.people_rounded),
      _DrawerItem('s22_template_engine_vnext', 'S22 Template Engine vNext', Icons.settings_rounded),
      _DrawerItem('s23_compliance_signing_archival', 'S23 Compliance, Signing & Archival', Icons.security_rounded),
      _DrawerItem('s24_performance_regression', 'S24 Performance & Regression', Icons.speed_rounded),
      _DrawerItem('s25_template_designer', 'S25 Template Designer', Icons.design_services_rounded),
      _DrawerItem('s26_industry_packs', 'S26 Industry / Plugin Packs', Icons.extension_rounded),
      _DrawerItem('s12_sales_erp_pack', 'S12 Sales ERP Pack', Icons.point_of_sale_rounded),
      _DrawerItem('s01_directionality', 'S01 Directionality', Icons.swap_horiz_rounded),
      _DrawerItem('s00_baseline', 'S00 Baseline', Icons.fact_check_rounded),
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
                      'v4.0.0',
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
                final isSelected = _controller.selectedId == item.id ||
                    (_controller.selectedId.startsWith(item.id.split('_').first) &&
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
          if (_controller.selectedId != 'dashboard')
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

  String _getTitle() =>
      DashboardDestinationRegistry.titleFor(_controller.selectedId);

  Widget _buildContent() => DashboardDestinationRegistry.build(
        _controller.selectedId,
        onNavigate: _onItemSelected,
      );
}

class _DrawerItem {
  final String id;
  final String title;
  final IconData icon;

  _DrawerItem(this.id, this.title, this.icon);
}
