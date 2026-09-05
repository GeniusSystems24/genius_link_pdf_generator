import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';
import '../localization/showcase_localizations.dart';
import '../navigation/showcase_catalog.dart';
import '../navigation/showcase_navigation.dart';
import '../settings/showcase_settings.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/showcase/showcase_page_factory.dart';

class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({
    super.key,
    required this.catalog,
    required this.themeMode,
    required this.locale,
    required this.textDirectionMode,
    required this.onCycleTheme,
    required this.onToggleLocale,
    required this.onTextDirectionChanged,
  });

  final List<ShowcaseDestination> catalog;
  final ThemeMode themeMode;
  final Locale locale;
  final ShowcaseTextDirectionMode textDirectionMode;
  final VoidCallback onCycleTheme;
  final VoidCallback onToggleLocale;
  final ValueChanged<ShowcaseTextDirectionMode> onTextDirectionChanged;

  @override
  State<ShowcaseShell> createState() => _ShowcaseShellState();
}

class _ShowcaseShellState extends State<ShowcaseShell> {
  SuperNavigationSidebarController<String>? _navigation;
  String _active = 'dashboard';
  String? _navigationLanguage;
  SuperNavSidebarMode? _lastMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureLocalizedNavigation();
  }

  @override
  void didUpdateWidget(covariant ShowcaseShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catalog != widget.catalog || oldWidget.locale != widget.locale) {
      _navigationLanguage = null;
      _ensureLocalizedNavigation();
    }
  }

  void _ensureLocalizedNavigation() {
    final l10n = ShowcaseL10n.of(context);
    final language = l10n.locale.languageCode;
    if (_navigation != null && _navigationLanguage == language) return;

    final old = _navigation;
    _navigation = SuperNavigationSidebarController<String>(
      sections: ShowcaseNavigation.build(widget.catalog, l10n),
      active: _active,
    );
    _navigationLanguage = language;
    old?.dispose();
  }

  @override
  void dispose() {
    _navigation?.dispose();
    super.dispose();
  }

  void _syncMode(SuperNavSidebarMode mode) {
    if (_lastMode == mode) return;
    _lastMode = mode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final navigation = _navigation;
      if (navigation == null) return;
      if (mode == SuperNavSidebarMode.expanded) {
        navigation.collapsed = false;
      } else if (mode == SuperNavSidebarMode.rail) {
        navigation.collapsed = true;
      } else {
        navigation.closeDrawer();
      }
    });
  }

  void _go(String id) {
    setState(() => _active = id);
    _navigation?.navigate(id);
  }

  @override
  Widget build(BuildContext context) {
    _ensureLocalizedNavigation();
    final navigation = _navigation!;
    final l10n = ShowcaseL10n.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final mode = const SuperNavSidebarBreakpoints().modeFor(
          constraints.maxWidth,
        );
        _syncMode(mode);

        final sidebar = SuperNavigationSidebar<String>(
          controller: navigation,
          mode: mode,
          showPaneToggle: true,
          allowSearchView: true,
          searchViewMode: mode == SuperNavSidebarMode.drawer
              ? SuperNavigationSearchViewMode.sheet
              : SuperNavigationSearchViewMode.dialog,
          favoritable: true,
          header: (context, collapsed) => _BrandHeader(collapsed: collapsed),
          onNavigate: (node) {
            final value = node.value;
            if (value != null) setState(() => _active = value);
          },
        );

        final page = _currentPage();
        final actions = <Widget>[
          _LanguageButton(
            locale: widget.locale,
            onPressed: widget.onToggleLocale,
          ),
          _DirectionButton(
            mode: widget.textDirectionMode,
            onChanged: widget.onTextDirectionChanged,
          ),
          _ThemeButton(mode: widget.themeMode, onPressed: widget.onCycleTheme),
        ];

        if (mode == SuperNavSidebarMode.drawer) {
          return Stack(
            children: [
              Positioned.fill(
                child: Scaffold(
                  appBar: SuperAppBar(
                    leading: IconButton(
                      tooltip: l10n.tr('Navigation'),
                      onPressed: navigation.openDrawer,
                      icon: const Icon(Icons.menu),
                    ),
                    title: Text(l10n.tr('Genius PDF Showcase')),
                    subtitle: Text(
                      l10n.destinationTitle(
                        _currentDestination.id,
                        _currentDestination.title,
                      ),
                    ),
                    actions: actions,
                  ),
                  body: page,
                ),
              ),
              Positioned.fill(child: sidebar),
            ],
          );
        }

        return Scaffold(
          body: Row(
            children: [
              sidebar,
              Expanded(
                child: Column(
                  children: [
                    SuperAppBar(
                      automaticallyImplyLeading: false,
                      title: Text(l10n.tr('Genius PDF Showcase')),
                      subtitle: Text(
                        l10n.destinationTitle(
                          _currentDestination.id,
                          _currentDestination.title,
                        ),
                      ),
                      actions: actions,
                    ),
                    Expanded(child: page),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ShowcaseDestination get _currentDestination => widget.catalog.firstWhere(
    (e) => e.id == _active,
    orElse: () => widget.catalog.first,
  );

  Widget _currentPage() {
    final destination = _currentDestination;
    if (destination.kind == ShowcasePageKind.dashboard) {
      return DashboardPage(catalog: widget.catalog, onOpen: _go);
    }
    return ShowcasePageFactory.build(destination);
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: t.spacing.borderRadiusMd,
          ),
          child: Text(
            'PDF',
            style: context.superTextTheme.label.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (!collapsed) ...[
          SizedBox(width: t.spacing.space2),
          Flexible(
            child: Text(
              'genius_link_pdf_generator',
              overflow: TextOverflow.ellipsis,
              style: context.superTextTheme.label.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.locale, required this.onPressed});

  final Locale locale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    return IconButton(
      tooltip: l10n.tr('Language'),
      onPressed: onPressed,
      icon: Text(
        locale.languageCode == 'ar' ? 'EN' : 'AR',
        style: context.superTextTheme.label.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({required this.mode, required this.onChanged});

  final ShowcaseTextDirectionMode mode;
  final ValueChanged<ShowcaseTextDirectionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final icon = switch (mode) {
      ShowcaseTextDirectionMode.automatic => Icons.swap_horiz_rounded,
      ShowcaseTextDirectionMode.ltr => Icons.format_textdirection_l_to_r_rounded,
      ShowcaseTextDirectionMode.rtl => Icons.format_textdirection_r_to_l_rounded,
    };
    final value = switch (mode) {
      ShowcaseTextDirectionMode.automatic => l10n.tr('Automatic'),
      ShowcaseTextDirectionMode.ltr => l10n.tr('Left to right'),
      ShowcaseTextDirectionMode.rtl => l10n.tr('Right to left'),
    };
    return PopupMenuButton<ShowcaseTextDirectionMode>(
      tooltip: '${l10n.tr('Text direction')}: $value',
      initialValue: mode,
      onSelected: onChanged,
      icon: Icon(icon),
      itemBuilder: (context) => [
        for (final option in ShowcaseTextDirectionMode.values)
          PopupMenuItem<ShowcaseTextDirectionMode>(
            value: option,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: option == mode
                      ? const Icon(Icons.check_rounded, size: 18)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(switch (option) {
                  ShowcaseTextDirectionMode.automatic => l10n.tr('Automatic'),
                  ShowcaseTextDirectionMode.ltr => l10n.tr('Left to right'),
                  ShowcaseTextDirectionMode.rtl => l10n.tr('Right to left'),
                }),
              ],
            ),
          ),
      ],
    );
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({required this.mode, required this.onPressed});
  final ThemeMode mode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final icon = switch (mode) {
      ThemeMode.system => Icons.brightness_auto_outlined,
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
    };
    return IconButton(
      tooltip: '${l10n.tr('Theme')}: ${mode.name}',
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
