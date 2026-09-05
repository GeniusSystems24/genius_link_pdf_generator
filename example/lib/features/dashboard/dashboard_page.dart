import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import '../../app/localization/showcase_localizations.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../shared/presentation/widgets/showcase_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.catalog, required this.onOpen});
  final List<ShowcaseDestination> catalog;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final featuredIds = <String>[
      'getting-started', 'tables-reports', 'templates',
      'pdf-operations', 'job-queues', 'directionality',
    ];
    final featured = featuredIds
        .map((id) => catalog.where((e) => e.id == id).firstOrNull)
        .whereType<ShowcaseDestination>()
        .toList();

    return ShowcasePage(
      title: 'genius_link_pdf_generator',
      description: l10n.isArabic
          ? 'أمثلة تفاعلية لتوليد ومعاينة وتسليم ومعالجة ملفات PDF باستخدام واجهة الحزمة الحالية.'
          : 'Interactive examples for generating, previewing, delivering and processing PDFs with the current package API.',
      icon: Icons.picture_as_pdf_outlined,
      api: const ['v4 showcase', 'RTL/LTR', 'templates', 'operations', 'background jobs'],
      children: [
        ShowcaseSection(
          title: l10n.tr('Explore the package'),
          subtitle: l10n.tr(
            'Focused entry points — the complete feature tree remains in the sidebar.',
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1100 ? 3 : width >= 700 ? 2 : 1;
              final gap = context.superTheme.spacing.space3;
              final cardWidth = columns == 1
                  ? width
                  : (width - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final item in featured)
                    SizedBox(
                      width: cardWidth,
                      child: _FeatureCard(
                        item: item,
                        onOpen: () => onOpen(item.id),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        ShowcaseSection(
          title: l10n.tr('Capability summary'),
          child: _CapabilitySummary(catalog: catalog),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item, required this.onOpen});
  final ShowcaseDestination item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final l10n = ShowcaseL10n.of(context);
    return Material(
      color: t.inputBg,
      borderRadius: t.spacing.borderRadiusCard,
      child: InkWell(
        onTap: onOpen,
        borderRadius: t.spacing.borderRadiusCard,
        child: Padding(
          padding: t.spacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: t.spacing.space3),
              Text(
                l10n.destinationTitle(item.id, item.title),
                style: context.superTextTheme.heading,
              ),
              SizedBox(height: t.spacing.space1),
              Text(
                l10n.destinationDescription(item.id, item.description),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.superTextTheme.caption.copyWith(color: t.fg2),
              ),
              SizedBox(height: t.spacing.space3),
              Row(
                children: [
                  Text(
                    l10n.tr('Open example'),
                    style: context.superTextTheme.label.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_back
                        : Icons.arrow_forward,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilitySummary extends StatelessWidget {
  const _CapabilitySummary({required this.catalog});
  final List<ShowcaseDestination> catalog;

  @override
  Widget build(BuildContext context) {
    final counts = <ShowcaseGroup, int>{};
    for (final item in catalog) {
      counts.update(item.group, (v) => v + 1, ifAbsent: () => 1);
    }
    return Wrap(
      spacing: context.superTheme.spacing.space2,
      runSpacing: context.superTheme.spacing.space2,
      children: [
        for (final entry in counts.entries)
          Chip(label: Text('${_groupName(context, entry.key)} • ${entry.value}')),
      ],
    );
  }

  String _groupName(BuildContext context, ShowcaseGroup group) {
    final l10n = ShowcaseL10n.of(context);
    final english = switch (group) {
      ShowcaseGroup.start => 'Start',
      ShowcaseGroup.authoring => 'Authoring',
      ShowcaseGroup.content => 'Content',
      ShowcaseGroup.documents => 'Documents',
      ShowcaseGroup.delivery => 'Delivery',
      ShowcaseGroup.operations => 'Operations',
      ShowcaseGroup.scale => 'Scale',
      ShowcaseGroup.integration => 'Integration',
      ShowcaseGroup.advanced => 'Advanced',
    };
    if (!l10n.isArabic) return english;
    return switch (group) {
      ShowcaseGroup.start => 'البداية',
      ShowcaseGroup.authoring => 'الإنشاء',
      ShowcaseGroup.content => 'المحتوى',
      ShowcaseGroup.documents => 'المستندات',
      ShowcaseGroup.delivery => 'التسليم',
      ShowcaseGroup.operations => 'العمليات',
      ShowcaseGroup.scale => 'التوسع',
      ShowcaseGroup.integration => 'التكامل',
      ShowcaseGroup.advanced => 'متقدم',
    };
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
