import 'package:flutter/material.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';
import '../localization/showcase_localizations.dart';
import 'showcase_catalog.dart';

abstract final class ShowcaseNavigation {
  static List<SuperNavSection<String>> build(
    List<ShowcaseDestination> destinations,
    ShowcaseL10n l10n,
  ) {
    final byId = {for (final item in destinations) item.id: item};

    SuperNavNode<String> leaf(String id) {
      final item = byId[id]!;
      final title = l10n.destinationTitle(item.id, item.title);
      final description = l10n.destinationDescription(item.id, item.description);
      return SuperNavNode<String>(
        id: item.id,
        label: Text(title),
        leadingIcon: Icon(item.icon),
        value: item.id,
        keywords: <String>[
          title.toLowerCase(),
          description.toLowerCase(),
          item.title.toLowerCase(),
          item.description.toLowerCase(),
          ...item.keywords,
          ...item.api.map((e) => e.toLowerCase()),
        ],
      );
    }

    SuperNavNode<String> group(
      String id,
      String title,
      IconData icon,
      List<String> children,
    ) => SuperNavNode<String>(
      id: id,
      label: Text(l10n.tr(title)),
      leadingIcon: Icon(icon),
      keywords: <String>[title.toLowerCase(), l10n.tr(title).toLowerCase()],
      children: children.where(byId.containsKey).map(leaf).toList(),
    );

    final advanced = destinations
        .where((e) => e.group == ShowcaseGroup.advanced)
        .map((e) => e.id)
        .toList();

    return <SuperNavSection<String>>[
      SuperNavSection<String>(
        title: l10n.tr('Start'),
        items: [leaf('dashboard'), leaf('getting-started')],
      ),
      SuperNavSection<String>(
        title: l10n.tr('Build PDFs'),
        items: [
          group('authoring-group', 'Authoring', Icons.edit_document, [
            'document-builder', 'configuration',
          ]),
          group('content-group', 'Content & layout', Icons.view_quilt_outlined, [
            'typography', 'directionality', 'headers-footers',
            'tables-reports', 'media', 'reusable-components',
          ]),
          group('documents-group', 'Reports & templates', Icons.article_outlined, [
            'report-composer', 'custom-reports', 'templates', 'business-documents',
          ]),
        ],
      ),
      SuperNavSection<String>(
        title: l10n.tr('Workflows'),
        items: [
          group('delivery-group', 'Preview & delivery', Icons.send_outlined, [
            'preview', 'delivery',
          ]),
          leaf('pdf-operations'),
          group('scale-group', 'Scale & queues', Icons.layers_outlined, [
            'background-generation', 'batch-generation', 'job-queues',
          ]),
        ],
      ),
      SuperNavSection<String>(
        title: l10n.tr('Previous examples'),
        items: [leaf('previous-examples')],
      ),
      SuperNavSection<String>(
        title: l10n.tr('Integration'),
        items: [leaf('architecture-di'), leaf('testing')],
      ),
      if (advanced.isNotEmpty)
        SuperNavSection<String>(
          title: l10n.tr('Advanced & optional'),
          items: [
            group(
              'advanced-group',
              'Package modules',
              Icons.extension_outlined,
              advanced,
            ),
          ],
        ),
    ];
  }
}
