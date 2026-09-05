
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';

import 'package:genius_pdf_example/app/navigation/example_navigation_catalog.dart';
import 'package:genius_pdf_example/app/routing/dashboard_destination_registry.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/controllers/dashboard_controller.dart';

import 'package:genius_pdf_example/app/controllers/locale_controller.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  late final DashboardController _dashboard;
  late final SuperNavigationSidebarController<String> _navigation;

  @override
  void initState() {
    super.initState();
    _dashboard = DashboardController();
    _navigation = SuperNavigationSidebarController<String>(
      sections: ExampleNavigationCatalog.sections,
      active: 'dashboard',
      expanded: <String>{'group_getting_started'},
    );
  }

  @override
  void dispose() {
    _navigation.dispose();
    _dashboard.dispose();
    super.dispose();
  }

  void _activate(String id) {
    if (!_navigation.navigate(id)) return;
    _dashboard.select(id);
  }

  void _handleSidebarNavigation(SuperNavNode<String> node) {
    final id = node.value;
    if (id == null) return;
    _dashboard.select(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _dashboard,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final mode = const SuperNavSidebarBreakpoints().modeFor(
                constraints.maxWidth,
              );
              final page = DashboardDestinationRegistry.build(
                _dashboard.selectedId,
                onNavigate: _activate,
              );
      
              if (mode == SuperNavSidebarMode.drawer) {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(child: _buildScaffold(page, mode)),
                    Positioned.fill(
                      child: SuperNavigationSidebar<String>(
                        controller: _navigation,
                        mode: mode,
                        allowSearchView: true,
                        searchViewMode: SuperNavigationSearchViewMode.sheet,
                        favoritable: true,
                        aggregateBadges: true,
                        onNavigate: _handleSidebarNavigation,
                      ),
                    ),
                  ],
                );
              }
      
              return Row(
                children: <Widget>[
                  SuperNavigationSidebar<String>(
                    controller: _navigation,
                    mode: mode,
                    showPaneToggle: true,
                    allowSearchView: true,
                    searchViewMode: SuperNavigationSearchViewMode.dialog,
                    favoritable: true,
                    aggregateBadges: true,
                    onNavigate: _handleSidebarNavigation,
                  ),
                  Expanded(child: _buildScaffold(page, mode)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScaffold(Widget page, SuperNavSidebarMode mode) {
    final title = DashboardDestinationRegistry.titleFor(_dashboard.selectedId);
    final typography = context.superTextTheme;

    return Scaffold(
      appBar: AppBar(
        leading: mode == SuperNavSidebarMode.drawer
            ? IconButton(
                tooltip: pdfLocalization.openNavigation,
                onPressed: _navigation.openDrawer,
                icon: const Icon(Icons.menu_rounded),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: typography.titleMd),
            if (_dashboard.selectedId != 'dashboard')
              Text(
                pdfLocalization.geniusLinkPdfGeneratorExamples,
                style: typography.caption,
              ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: pdfLocalization.searchExamples,
            onPressed: () => showSuperNavigationSearchView<String>(
              context,
              controller: _navigation,
              mode: mode == SuperNavSidebarMode.drawer
                  ? SuperNavigationSearchViewMode.sheet
                  : SuperNavigationSearchViewMode.dialog,
              onPick: (id) => _activate(id),
            ),
            icon: const Icon(Icons.search_rounded),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController,
            builder: (context, themeMode, child) {
              final dark = themeMode == ThemeMode.dark;
              return IconButton(
                tooltip: dark ? pdfLocalization.useLightTheme : pdfLocalization.useDarkTheme,
                onPressed: themeController.toggleTheme,
                icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              );
            },
          ),
          ValueListenableBuilder<Locale>(
            valueListenable: localeController,
            builder: (context, locale, child) {
              final isArabic = locale.languageCode == 'ar';
              return IconButton(
                tooltip: isArabic
                    ? pdfLocalization.switchToEnglish
                    : pdfLocalization.switchToArabic,
                onPressed: localeController.toggleLanguage,
                icon: const Icon(Icons.language_rounded),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: page,
    );
  }
}
