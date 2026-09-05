import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

/// Semantic visual intent used by the template catalog components.
enum TemplateCatalogTone { primary, info, success, warning, danger, neutral }

/// Immutable category information consumed by [TemplateCategorySelector].
class TemplateCategoryItem {
  const TemplateCategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.count,
    required this.tone,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int count;
  final TemplateCatalogTone tone;
}

/// Top-level introduction and catalog configuration for a template showcase.
class TemplateCatalogPageHeader extends StatelessWidget {
  const TemplateCatalogPageHeader({
    super.key,
    required this.title,
    required this.description,
    required this.templateCount,
    required this.categoryCount,
    required this.isRtl,
    required this.onRtlChanged,
  });

  final String title;
  final String description;
  final int templateCount;
  final int categoryCount;
  final bool isRtl;
  final ValueChanged<bool>? onRtlChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final theme = context.superTheme;
    final typography = context.superTextTheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: spacing.cardPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 780;
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _ToneIcon(
                      icon: Icons.description_outlined,
                      tone: TemplateCatalogTone.primary,
                      size: 46,
                    ),
                    SizedBox(width: spacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(title, style: typography.headlineSm),
                          SizedBox(height: spacing.space1),
                          Text(
                            'genius_link_pdf_generator showcase',
                            style: typography.labelMd.copyWith(color: theme.fg3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.space4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Text(
                    description,
                    style: typography.body.copyWith(
                      color: theme.fg2,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: spacing.space4),
                Wrap(
                  spacing: spacing.space2,
                  runSpacing: spacing.space2,
                  children: <Widget>[
                    _MetricChip(
                      icon: Icons.dashboard_customize_outlined,
                      label: '$categoryCount categories',
                    ),
                    _MetricChip(
                      icon: Icons.picture_as_pdf_outlined,
                      label: '$templateCount templates',
                    ),
                    const _MetricChip(
                      icon: Icons.translate_rounded,
                      label: 'LTR + RTL',
                    ),
                  ],
                ),
              ],
            );

            final languageControl = _DirectionControl(
              isRtl: isRtl,
              onChanged: onRtlChanged,
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  intro,
                  SizedBox(height: spacing.space4),
                  languageControl,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: intro),
                SizedBox(width: spacing.space6),
                SizedBox(width: 270, child: languageControl),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Responsive category switcher backed by an external [TabController].
class TemplateCategorySelector extends StatelessWidget {
  const TemplateCategorySelector({
    super.key,
    required this.controller,
    required this.categories,
  });

  final TabController controller;
  final List<TemplateCategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(spacing.space2),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
          unselectedLabelColor: context.superTheme.fg2,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: spacing.cardBorderRadius,
          ),
          labelPadding: EdgeInsets.zero,
          tabs: <Widget>[
            for (final item in categories)
              _CategoryTab(item: item),
          ],
        ),
      ),
    );
  }
}

/// Introductory summary for the currently selected template category.
class TemplateCategoryOverview extends StatelessWidget {
  const TemplateCategoryOverview({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.tone,
    required this.templateCount,
  });

  final String title;
  final String description;
  final IconData icon;
  final TemplateCatalogTone tone;
  final int templateCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final theme = context.superTheme;
    final typography = context.superTextTheme;

    return Container(
      padding: spacing.cardPadding,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border.all(color: theme.border),
        borderRadius: spacing.cardBorderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ToneIcon(icon: icon, tone: tone, size: 44),
          SizedBox(width: spacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text(title, style: typography.titleMd)),
                    _CountBadge(count: templateCount),
                  ],
                ),
                SizedBox(height: spacing.space2),
                Text(
                  description,
                  style: typography.bodySm.copyWith(
                    color: theme.fg2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable card for one runnable template example.
class TemplateDemoCard extends StatelessWidget {
  const TemplateDemoCard({
    super.key,
    required this.title,
    required this.secondaryTitle,
    required this.description,
    required this.icon,
    required this.tone,
    required this.busy,
    required this.enabled,
    required this.onGenerate,
  });

  final String title;
  final String secondaryTitle;
  final String description;
  final IconData icon;
  final TemplateCatalogTone tone;
  final bool busy;
  final bool enabled;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final theme = context.superTheme;
    final typography = context.superTextTheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onGenerate : null,
        child: Padding(
          padding: spacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ToneIcon(icon: icon, tone: tone, size: 42),
                  SizedBox(width: spacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: typography.titleMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: spacing.space1),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            secondaryTitle,
                            style: typography.bodySm.copyWith(color: theme.fg3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.space4),
              Expanded(
                child: Text(
                  description,
                  style: typography.bodySm.copyWith(
                    color: theme.fg2,
                    height: 1.45,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: spacing.space3),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: enabled ? onGenerate : null,
                  icon: busy
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: Text(busy ? 'Generating…' : 'Generate PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline feedback panel for generation progress, success, or failure.
class TemplateGenerationStatus extends StatelessWidget {
  const TemplateGenerationStatus({
    super.key,
    required this.title,
    required this.message,
    required this.tone,
    this.onDismiss,
  });

  final String title;
  final String message;
  final TemplateCatalogTone tone;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final semantic = _resolveTone(context, tone);

    return Container(
      padding: spacing.cardPadding,
      decoration: BoxDecoration(
        color: semantic.subtle,
        border: Border.all(color: semantic.border),
        borderRadius: spacing.cardBorderRadius,
      ),
      child: Row(
        children: <Widget>[
          Icon(_toneIcon(tone), color: semantic.solid),
          SizedBox(width: spacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: context.superTextTheme.titleMd.copyWith(
                    color: semantic.onSubtle,
                  ),
                ),
                SizedBox(height: spacing.space1),
                Text(
                  message,
                  style: context.superTextTheme.bodySm.copyWith(
                    color: semantic.onSubtle,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null) ...<Widget>[
            SizedBox(width: spacing.space2),
            IconButton(
              tooltip: 'Dismiss',
              onPressed: onDismiss,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _DirectionControl extends StatelessWidget {
  const _DirectionControl({
    required this.isRtl,
    required this.onChanged,
  });

  final bool isRtl;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final theme = context.superTheme;

    return Container(
      padding: spacing.cardPadding,
      decoration: BoxDecoration(
        color: theme.bg,
        borderRadius: spacing.cardBorderRadius,
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Document direction', style: context.superTextTheme.titleMd),
          SizedBox(height: spacing.space1),
          Text(
            'Switch the generated sample between RTL and LTR content.',
            style: context.superTextTheme.bodySm.copyWith(color: theme.fg2),
          ),
          SizedBox(height: spacing.space3),
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(
                value: true,
                icon: Icon(Icons.format_textdirection_r_to_l_rounded),
                label: Text('RTL'),
              ),
              ButtonSegment<bool>(
                value: false,
                icon: Icon(Icons.format_textdirection_l_to_r_rounded),
                label: Text('LTR'),
              ),
            ],
            selected: <bool>{isRtl},
            onSelectionChanged: onChanged == null
                ? null
                : (selection) {
                    if (selection.isNotEmpty) onChanged!(selection.first);
                  },
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({required this.item});

  final TemplateCategoryItem item;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final defaultColor = context.superTheme.fg2;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space3,
        vertical: spacing.space2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(item.icon, size: 18),
          SizedBox(width: spacing.space2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(item.title, style: context.superTextTheme.labelMd),
              Text(
                '${item.count} templates',
                style: context.superTextTheme.labelSm.copyWith(
                  color: defaultColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final theme = context.superTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space3,
        vertical: spacing.space2,
      ),
      decoration: BoxDecoration(
        color: theme.bg,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: theme.fg2),
          SizedBox(width: spacing.space2),
          Text(label, style: context.superTextTheme.labelMd),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space2,
        vertical: spacing.space1,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count templates',
        style: context.superTextTheme.labelSm.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({
    required this.icon,
    required this.tone,
    required this.size,
  });

  final IconData icon;
  final TemplateCatalogTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final semantic = _resolveTone(context, tone);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: semantic.subtle,
        border: Border.all(color: semantic.border),
        borderRadius: context.superTheme.spacing.cardBorderRadius,
      ),
      child: Icon(icon, color: semantic.solid, size: size * .48),
    );
  }
}

SuperSemanticColor _resolveTone(
  BuildContext context,
  TemplateCatalogTone tone,
) {
  final colors = SuperSemanticColors.of(context);
  return switch (tone) {
    TemplateCatalogTone.primary => colors.accent,
    TemplateCatalogTone.info => colors.info,
    TemplateCatalogTone.success => colors.success,
    TemplateCatalogTone.warning => colors.warning,
    TemplateCatalogTone.danger => colors.danger,
    TemplateCatalogTone.neutral => colors.neutral,
  };
}

IconData _toneIcon(TemplateCatalogTone tone) => switch (tone) {
      TemplateCatalogTone.success => Icons.check_circle_outline_rounded,
      TemplateCatalogTone.warning => Icons.warning_amber_rounded,
      TemplateCatalogTone.danger => Icons.error_outline_rounded,
      TemplateCatalogTone.info => Icons.info_outline_rounded,
      TemplateCatalogTone.primary => Icons.auto_awesome_outlined,
      TemplateCatalogTone.neutral => Icons.circle_outlined,
    };
