import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors, TextDirection;
import 'package:super_core/super_core.dart';

import '../../app/dependencies/example_dependencies.dart';
import '../../app/localization/showcase_localizations.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../app/settings/showcase_settings.dart';
import '../../shared/presentation/widgets/showcase_page.dart';
import 'package_module_registry.dart';

class PackageModulePage extends StatelessWidget {
  const PackageModulePage({super.key, required this.destination});

  final ShowcaseDestination destination;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final examples = PackageModuleRegistry.forModule(destination.id);

    return ShowcasePage(
      title: l10n.destinationTitle(destination.id, destination.title),
      description: l10n.destinationDescription(
        destination.id,
        destination.description,
      ),
      icon: destination.icon,
      api: destination.api,
      children: [
        ShowcaseSection(
          title: l10n.tr('Package module examples'),
          subtitle: l10n.tr(
            'Every example shown below has its own Generate action.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DirectionNotice(),
              SizedBox(height: context.superTheme.spacing.space3),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = context.superTheme.spacing.space3;
                  final columns = constraints.maxWidth >= 1100
                      ? 3
                      : constraints.maxWidth >= 720
                      ? 2
                      : 1;
                  final cardWidth = columns == 1
                      ? constraints.maxWidth
                      : (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final example in examples)
                        SizedBox(
                          width: cardWidth,
                          child: _ModuleExampleCard(
                            destination: destination,
                            example: example,
                          ),
                        ),
                    ],
                  );
                },
              ),
              if (examples.isEmpty)
                Text(
                  l10n.isArabic
                      ? 'لا توجد أمثلة مسجلة لهذه الوحدة في الكتالوج الحالي.'
                      : 'No examples are registered for this module in the current showcase catalog.',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DirectionNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final settings = ShowcaseSettings.of(context);
    final value = settings.textDirection == TextDirection.rtl ? 'RTL' : 'LTR';
    final t = context.superTheme;
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.borderRadiusCard,
      ),
      child: Row(
        children: [
          const Icon(Icons.format_textdirection_l_to_r_outlined),
          SizedBox(width: t.spacing.space2),
          Expanded(
            child: Text(
              '${l10n.tr('Direction')}: $value — '
              '${l10n.tr('The selected text direction is also used as the default direction for newly generated showcase documents.')}',
              style: context.superTextTheme.caption.copyWith(color: t.fg2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleExampleCard extends StatefulWidget {
  const _ModuleExampleCard({required this.destination, required this.example});

  final ShowcaseDestination destination;
  final PackageModuleExample example;

  @override
  State<_ModuleExampleCard> createState() => _ModuleExampleCardState();
}

class _ModuleExampleCardState extends State<_ModuleExampleCard> {
  bool _busy = false;

  Future<void> _generate() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = ShowcaseL10n.of(context);
    final settings = ShowcaseSettings.of(context);
    try {
      final moduleTitle = l10n.destinationTitle(
        widget.destination.id,
        widget.destination.title,
      );
      final exampleTitle = l10n.exampleTitle(
        widget.example.title,
        widget.example.titleAr,
      );
      final config = geniusPdfConfig.copyWith(
        textDirection: settings.textDirection,
      );
      final result = await geniusPdfClient.generate(
        builder: _PackageModuleExampleDocument(
          config,
          moduleTitle: moduleTitle,
          exampleTitle: exampleTitle,
          moduleId: widget.destination.id,
          api: widget.destination.api,
        ),
        fileName: '${widget.destination.id}_${widget.example.id}.pdf',
        runInBackground: false,
      );

      final bytes = result.when<Uint8List?>(
        onSuccess: (value) => value.bytes,
        onFailure: (failure) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          }
          return null;
        },
      );
      if (!mounted || bytes == null) return;
      await _showPreview(bytes, exampleTitle);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showPreview(Uint8List bytes, String title) async {
    final l10n = ShowcaseL10n.of(context);
    await showDialog<void>(
      context: context,
      builder: (context) {
        final size = MediaQuery.sizeOf(context);
        final width = math.min(1100.0, size.width * 0.94);
        final height = math.min(820.0, size.height * 0.90);
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.tr('Close'),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: GeniusPdfPreviewWidget(
                    pdfData: bytes,
                    height: height - 58,
                    canChangeOrientation: true,
                    canChangePageFormat: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final l10n = ShowcaseL10n.of(context);
    final title = l10n.exampleTitle(
      widget.example.title,
      widget.example.titleAr,
    );
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.borderRadiusCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.destination.icon, size: 20),
              SizedBox(width: t.spacing.space2),
              Expanded(
                child: Text(
                  title,
                  style: context.superTextTheme.heading,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.space2),
          Text(
            '${l10n.tr('Module')}: '
            '${l10n.destinationTitle(widget.destination.id, widget.destination.title)}',
            style: context.superTextTheme.caption.copyWith(color: t.fg2),
          ),
          SizedBox(height: t.spacing.space3),
          SuperButton(
            label: _busy ? l10n.tr('Generating…') : l10n.tr('Generate'),
            icon: _busy
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bolt_outlined),
            onPressed: _busy ? null : _generate,

            // fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _PackageModuleExampleDocument extends GeniusPdfDocumentBuilder {
  _PackageModuleExampleDocument(
    super.config, {
    required this.moduleTitle,
    required this.exampleTitle,
    required this.moduleId,
    required this.api,
  });

  final String moduleTitle;
  final String exampleTitle;
  final String moduleId;
  final List<String> api;

  @override
  void build() {
    addHeader(title: moduleTitle);
    addLine(exampleTitle);
    addSpace(12);
    addLine(
      config.isRTL
          ? 'تم توليد هذا المثال من شاشة وحدات الحزمة باستخدام إعدادات الاتجاه الحالية.'
          : 'This example was generated from the Package Modules showcase using the current direction settings.',
    );
    addSpace(12);
    addLine('Module ID: $moduleId');
    if (api.isNotEmpty) {
      addSpace(8);
      addLine('API: ${api.join(', ')}');
    }
    addFooter(
      userName: config.isRTL ? 'تطبيق الأمثلة' : 'Example app',
      showPageNumber: true,
    );
  }
}
