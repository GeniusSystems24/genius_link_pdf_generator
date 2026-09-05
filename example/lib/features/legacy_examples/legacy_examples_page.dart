import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart' hide TextDirection;
import 'package:super_core/super_core.dart';

import '../../app/localization/showcase_localizations.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../app/settings/showcase_settings.dart';
import '../../shared/presentation/widgets/full_screen_pdf_viewer.dart';
import '../../shared/presentation/widgets/pdf_workbench.dart';
import '../../shared/presentation/widgets/showcase_page.dart';
import 'legacy_example_registry.dart';

class LegacyExamplesPage extends StatefulWidget {
  const LegacyExamplesPage({super.key, required this.destination});
  final ShowcaseDestination destination;

  @override
  State<LegacyExamplesPage> createState() => _LegacyExamplesPageState();
}

class _LegacyExamplesPageState extends State<LegacyExamplesPage> {
  String _selectedId = LegacyExampleRegistry.examples.first.id;
  String _group = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final groups = <String>{for (final item in LegacyExampleRegistry.examples) item.group}.toList()..sort();
    final query = _query.trim().toLowerCase();
    final visible = LegacyExampleRegistry.examples.where((item) {
      if (_group != 'All' && item.group != _group) return false;
      if (query.isEmpty) return true;
      return item.title.toLowerCase().contains(query) ||
          item.titleAr.contains(_query.trim()) ||
          item.description.toLowerCase().contains(query);
    }).toList();
    final selected = LegacyExampleRegistry.examples.firstWhere(
      (item) => item.id == _selectedId,
      orElse: () => visible.isNotEmpty ? visible.first : LegacyExampleRegistry.examples.first,
    );

    return ShowcasePage(
      title: l10n.destinationTitle(widget.destination.id, widget.destination.title),
      description: l10n.destinationDescription(widget.destination.id, widget.destination.description),
      icon: widget.destination.icon,
      children: [
        ShowcaseSection(
          title: l10n.tr('Previous example catalog'),
          subtitle: l10n.tr('All previous examples are represented here except S00-S26 verification screens.'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.tr('Search previous examples'),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: context.superTheme.spacing.space2),
              Wrap(
                spacing: context.superTheme.spacing.space1,
                runSpacing: context.superTheme.spacing.space1,
                children: [
                  ChoiceChip(
                    label: Text(l10n.tr('All')),
                    selected: _group == 'All',
                    onSelected: (_) => setState(() => _group = 'All'),
                  ),
                  for (final group in groups)
                    ChoiceChip(
                      label: Text(l10n.tr(group)),
                      selected: _group == group,
                      onSelected: (_) => setState(() => _group = group),
                    ),
                ],
              ),
              SizedBox(height: context.superTheme.spacing.space3),
              _ExampleList(
                items: visible,
                selectedId: selected.id,
                onSelected: (id) => setState(() => _selectedId = id),
              ),
            ],
          ),
        ),
        ShowcaseSection(
          key: ValueKey(selected.id),
          title: l10n.exampleTitle(selected.title, selected.titleAr),
          subtitle: l10n.isArabic ? selected.descriptionAr : selected.description,
          child: _LegacyExampleBody(example: selected),
        ),
      ],
    );
  }
}

class _ExampleList extends StatelessWidget {
  const _ExampleList({required this.items, required this.selectedId, required this.onSelected});
  final List<LegacyExampleDefinition> items;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    if (items.isEmpty) return Text(l10n.tr('No matching examples.'));
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 360),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) => Hairline(color: t.border),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.id == selectedId;
          return ListTile(
            selected: selected,
            leading: Icon(_iconFor(item.mode)),
            title: Text(l10n.exampleTitle(item.title, item.titleAr)),
            subtitle: Text(l10n.tr(item.group)),
            trailing: selected ? const Icon(Icons.check_circle_outline) : const Icon(Icons.chevron_right),
            onTap: () => onSelected(item.id),
          );
        },
      ),
    );
  }

  IconData _iconFor(LegacyExampleMode mode) => switch (mode) {
    LegacyExampleMode.builder => Icons.picture_as_pdf_outlined,
    LegacyExampleMode.bytes => Icons.description_outlined,
    LegacyExampleMode.reference => Icons.link_outlined,
  };
}

class _LegacyExampleBody extends StatelessWidget {
  const _LegacyExampleBody({required this.example});
  final LegacyExampleDefinition example;

  @override
  Widget build(BuildContext context) {
    final settings = ShowcaseSettings.of(context);
    final config = LegacyExampleRegistry.configFor(settings.textDirection);

    return switch (example.mode) {
      LegacyExampleMode.builder => PdfWorkbench(
          builderFactory: () => LegacyExampleRegistry.buildDocument(example.id, config: config),
          fileName: 'legacy_${example.id.replaceAll('-', '_')}',
        ),
      LegacyExampleMode.bytes => _LegacyBytesWorkbench(example: example, config: config),
      LegacyExampleMode.reference => _LegacyReference(example: example),
    };
  }
}

class _LegacyBytesWorkbench extends StatefulWidget {
  const _LegacyBytesWorkbench({required this.example, required this.config});
  final LegacyExampleDefinition example;
  final GeniusPdfConfig config;

  @override
  State<_LegacyBytesWorkbench> createState() => _LegacyBytesWorkbenchState();
}

class _LegacyBytesWorkbenchState extends State<_LegacyBytesWorkbench> {
  Uint8List? _bytes;
  bool _busy = false;
  String? _error;

  Future<void> _generate() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final bytes = LegacyExampleRegistry.buildBytes(widget.example.id, config: widget.config);
      if (mounted) setState(() => _bytes = bytes);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: t.spacing.space2,
          runSpacing: t.spacing.space2,
          children: [
            SuperButton(
              label: _busy ? l10n.tr('Generating…') : l10n.tr('Generate'),
              icon: const Icon(Icons.bolt),
              onPressed: _busy ? null : _generate,
            ),
            if (_bytes != null)
              SuperButton(
                label: l10n.tr('Full screen'),
                variant: SuperButtonVariant.secondary,
                icon: const Icon(Icons.fullscreen_outlined),
                onPressed: () => showFullScreenPdfViewer(
                  context,
                  bytes: _bytes!,
                  title: l10n.exampleTitle(widget.example.title, widget.example.titleAr),
                ),
              ),
          ],
        ),
        if (_error != null) ...[
          SizedBox(height: t.spacing.space2),
          Text(_error!, style: context.superTextTheme.body.copyWith(color: Theme.of(context).colorScheme.error)),
        ],
        if (_bytes != null) ...[
          SizedBox(height: t.spacing.space3),
          SizedBox(
            height: 620,
            child: GeniusPdfPreviewWidget(
              pdfData: _bytes!,
              height: 620,
              canChangeOrientation: true,
              canChangePageFormat: false,
            ),
          ),
        ],
      ],
    );
  }
}

class _LegacyReference extends StatelessWidget {
  const _LegacyReference({required this.example});
  final LegacyExampleDefinition example;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.borderRadiusCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history_edu_outlined, color: t.fg2),
          SizedBox(width: t.spacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tr('Preserved previous screen'), style: context.superTextTheme.label),
                SizedBox(height: t.spacing.space1),
                Text(
                  l10n.tr('The previous implementation source is preserved outside example/lib so it remains inspectable without reintroducing obsolete dependencies.'),
                  style: context.superTextTheme.body.copyWith(color: t.fg2),
                ),
                if (example.currentCoverage != null) ...[
                  SizedBox(height: t.spacing.space2),
                  Text('${l10n.tr('Current coverage')}: ${example.currentCoverage}', style: context.superTextTheme.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
