
import '../builders/pdf_document_builder.dart';
import '../core/directionality.dart';
import 'safe_expression_engine.dart';
import 'template_elements.dart';
import 'template_registry.dart';
import 'template_schema.dart';

class GeniusPdfResolvedStyle {
  const GeniusPdfResolvedStyle(this.values);
  final Map<String, Object?> values;
}

class GeniusPdfResolvedTemplateElement {
  const GeniusPdfResolvedTemplateElement({
    required this.id,
    required this.type,
    required this.config,
    required this.direction,
    required this.valueDirection,
    this.style = const GeniusPdfResolvedStyle({}),
    this.children = const [],
    this.sourceItem,
  });

  final String id;
  final GeniusPdfTemplateElementType type;
  final Map<String, Object?> config;
  final GeniusPdfDirection direction;
  final GeniusPdfTemplateValueDirection valueDirection;
  final GeniusPdfResolvedStyle style;
  final List<GeniusPdfResolvedTemplateElement> children;
  final Object? sourceItem;
}

class GeniusPdfResolvedTemplate {
  const GeniusPdfResolvedTemplate({
    required this.schema,
    required this.elements,
  });

  final GeniusPdfTemplateSchema schema;
  final List<GeniusPdfResolvedTemplateElement> elements;
}

/// Logical-family binding. The schema stores only a family key; runtime
/// applications map it to their actual document family implementation.
abstract interface class GeniusPdfDocumentFamilyBinding {
  String get familyKey;
}

/// Renderer hook registered by runtime code for one element type.
///
/// This keeps serialized schema independent from Syncfusion/PDF classes.
abstract interface class GeniusPdfTemplateElementRenderer {
  GeniusPdfTemplateElementType get type;

  void render(
    GeniusPdfDocumentBuilder document,
    GeniusPdfResolvedTemplateElement element,
  );
}

/// S22 composition + safe-expression runtime.
///
/// It resolves inheritance, named components, style inheritance, subtemplates,
/// visibility, bounded repeats and direction inheritance. It does not store
/// renderer objects in the serialized schema.
class GeniusPdfTemplateEngine {
  GeniusPdfTemplateEngine({
    required this.registry,
    this.expressionEngine = const GeniusPdfSafeExpressionEngine(),
    this.maxRepeatItems = 10000,
  }) : assert(maxRepeatItems > 0);

  final GeniusPdfTemplateRegistry registry;
  final GeniusPdfSafeExpressionEngine expressionEngine;
  final int maxRepeatItems;

  GeniusPdfResolvedTemplate resolve(
    GeniusPdfTemplateSchema schema, {
    Map<String, Object?> context = const {},
    Map<String, String> localization = const {},
    GeniusPdfTemplateScope scope = const GeniusPdfTemplateScope(),
  }) {
    final inherited = _inherit(schema, scope);
    final styles = _resolveStyles(inherited.styles);
    final elements = _resolveElements(
      inherited,
      inherited.elements,
      context,
      localization,
      styles,
      inherited.direction,
      scope,
      <String>{inherited.templateId},
    );
    return GeniusPdfResolvedTemplate(
      schema: inherited,
      elements: elements,
    );
  }

  GeniusPdfTemplateSchema _inherit(
    GeniusPdfTemplateSchema schema,
    GeniusPdfTemplateScope scope,
  ) {
    final parentId = schema.extendsTemplateId;
    if (parentId == null || parentId.isEmpty) {
      return schema;
    }

    final parent = registry.resolve(
      TemplateId(parentId),
      scope: scope,
      includeDraft: schema.state == GeniusPdfTemplateState.draft,
    );
    if (parent == null) {
      throw StateError(
        'Parent template `$parentId` was not found.',
      );
    }

    final inheritedParent = _inherit(parent, scope);
    return GeniusPdfTemplateSchema(
      schemaVersion: schema.schemaVersion,
      templateId: schema.templateId,
      templateVersion: schema.templateVersion,
      name: schema.name,
      pack: schema.pack,
      variant: schema.variant,
      locale: schema.locale ?? inheritedParent.locale,
      country: schema.country ?? inheritedParent.country,
      organization:
          schema.organization ?? inheritedParent.organization,
      branch: schema.branch ?? inheritedParent.branch,
      effectiveFrom:
          schema.effectiveFrom ?? inheritedParent.effectiveFrom,
      effectiveTo: schema.effectiveTo ?? inheritedParent.effectiveTo,
      state: schema.state,
      direction: schema.direction == GeniusPdfDirection.auto
          ? inheritedParent.direction
          : schema.direction,
      family: schema.family ?? inheritedParent.family,
      extendsTemplateId: null,
      components: {
        ...inheritedParent.components,
        ...schema.components,
      },
      styles: {
        ...inheritedParent.styles,
        ...schema.styles,
      },
      elements: [
        ...inheritedParent.elements,
        ...schema.elements,
      ],
      metadata: {
        ...inheritedParent.metadata,
        ...schema.metadata,
      },
    );
  }

  Map<String, GeniusPdfResolvedStyle> _resolveStyles(
    Map<String, GeniusPdfTemplateStyle> styles,
  ) {
    final resolved = <String, GeniusPdfResolvedStyle>{};
    final active = <String>{};

    GeniusPdfResolvedStyle visit(String name) {
      final cached = resolved[name];
      if (cached != null) return cached;
      final style = styles[name];
      if (style == null) {
        throw StateError('Unknown style `$name`.');
      }
      if (!active.add(name)) {
        throw StateError(
          'Circular style inheritance at `$name`.',
        );
      }

      final values = <String, Object?>{};
      if (style.parent != null) {
        values.addAll(visit(style.parent!).values);
      }
      values.addAll(style.values);
      active.remove(name);

      final value = GeniusPdfResolvedStyle(
        Map.unmodifiable(values),
      );
      resolved[name] = value;
      return value;
    }

    for (final name in styles.keys) {
      visit(name);
    }
    return resolved;
  }

  List<GeniusPdfResolvedTemplateElement> _resolveElements(
    GeniusPdfTemplateSchema schema,
    List<GeniusPdfTemplateElement> elements,
    Map<String, Object?> context,
    Map<String, String> localization,
    Map<String, GeniusPdfResolvedStyle> styles,
    GeniusPdfDirection inheritedDirection,
    GeniusPdfTemplateScope scope,
    Set<String> templateStack,
  ) {
    final output = <GeniusPdfResolvedTemplateElement>[];

    for (final source in elements) {
      final direction =
          source.direction == GeniusPdfDirection.auto
              ? inheritedDirection
              : source.direction;

      if (source.visibleWhen != null) {
        final visible = expressionEngine.evaluate(
          source.visibleWhen!,
          context,
          localization: localization,
        );
        if (!_truthy(visible)) continue;
      }

      if (source.repeatPath != null) {
        final repeated = expressionEngine.resolvePath(
          source.repeatPath!,
          context,
        );
        if (repeated == null) continue;
        if (repeated is! Iterable) {
          throw StateError(
            'repeatPath `${source.repeatPath}` did not resolve to a list.',
          );
        }

        var index = 0;
        for (final item in repeated) {
          if (index >= maxRepeatItems) {
            throw StateError(
              'Template repeat exceeded maxRepeatItems=$maxRepeatItems.',
            );
          }
          final itemContext = <String, Object?>{
            ...context,
            r'$index': index,
            r'$item': item,
            if (item is Map)
              ...Map<String, Object?>.from(item),
          };
          output.addAll(
            _resolveOne(
              schema,
              source,
              itemContext,
              localization,
              styles,
              direction,
              scope,
              templateStack,
              sourceItem: item,
              idSuffix: '[$index]',
            ),
          );
          index++;
        }
        continue;
      }

      output.addAll(
        _resolveOne(
          schema,
          source,
          context,
          localization,
          styles,
          direction,
          scope,
          templateStack,
        ),
      );
    }
    return output;
  }

  List<GeniusPdfResolvedTemplateElement> _resolveOne(
    GeniusPdfTemplateSchema schema,
    GeniusPdfTemplateElement source,
    Map<String, Object?> context,
    Map<String, String> localization,
    Map<String, GeniusPdfResolvedStyle> styles,
    GeniusPdfDirection direction,
    GeniusPdfTemplateScope scope,
    Set<String> templateStack, {
    Object? sourceItem,
    String idSuffix = '',
  }) {
    if (source.type == GeniusPdfTemplateElementType.component) {
      final name = source.componentRef!;
      final component = schema.components[name];
      if (component == null) {
        throw StateError(
          'Unknown named component `$name`.',
        );
      }

      final componentDirection =
          component.direction == GeniusPdfDirection.auto
              ? direction
              : component.direction;

      return _resolveOne(
        schema,
        component,
        context,
        localization,
        styles,
        componentDirection,
        scope,
        templateStack,
        sourceItem: sourceItem,
        idSuffix: '$idSuffix@$name',
      );
    }

    if (source.type == GeniusPdfTemplateElementType.subTemplate) {
      final templateId = source.config['templateId']?.toString() ?? '';
      if (templateId.isEmpty) {
        throw StateError(
          'SubTemplate `${source.id}` has no templateId.',
        );
      }
      if (templateStack.contains(templateId)) {
        throw StateError(
          'Circular subtemplate composition: '
          '${[...templateStack, templateId].join(' -> ')}',
        );
      }

      final variant = source.config['variant']?.toString();
      final childScope = GeniusPdfTemplateScope(
        variant: variant ?? scope.variant,
        locale: scope.locale,
        country: scope.country,
        organization: scope.organization,
        branch: scope.branch,
        at: scope.at,
      );
      final child = registry.resolve(
        TemplateId(templateId),
        scope: childScope,
        includeDraft: schema.state == GeniusPdfTemplateState.draft,
      );
      if (child == null) {
        throw StateError(
          'SubTemplate `$templateId` was not found.',
        );
      }

      final nextStack = {...templateStack, templateId};
      final inheritedChild = _inherit(child, childScope);
      final childStyles = _resolveStyles({
        ...schema.styles,
        ...inheritedChild.styles,
      });
      return _resolveElements(
        inheritedChild,
        inheritedChild.elements,
        context,
        localization,
        childStyles,
        inheritedChild.direction == GeniusPdfDirection.auto
            ? direction
            : inheritedChild.direction,
        childScope,
        nextStack,
      );
    }

    final config = <String, Object?>{
      for (final entry in source.config.entries)
        entry.key: entry.key.endsWith('Expression') &&
                entry.value is String
            ? expressionEngine.evaluate(
                entry.value as String,
                context,
                localization: localization,
              )
            : _resolveConfigValue(
                entry.value,
                context,
                localization,
              ),
    };

    final style = source.style == null
        ? const GeniusPdfResolvedStyle({})
        : styles[source.style!] ??
            (throw StateError(
              'Unknown style `${source.style}`.',
            ));

    final children = _resolveElements(
      schema,
      source.children,
      context,
      localization,
      styles,
      direction,
      scope,
      templateStack,
    );

    return [
      GeniusPdfResolvedTemplateElement(
        id: '${source.id}$idSuffix',
        type: source.type,
        config: Map.unmodifiable(config),
        direction: direction,
        valueDirection: source.valueDirection,
        style: style,
        children: children,
        sourceItem: sourceItem,
      ),
    ];
  }

  Object? _resolveConfigValue(
    Object? value,
    Map<String, Object?> context,
    Map<String, String> localization,
  ) {
    if (value is String) {
      if (value.startsWith('expr:')) {
        return expressionEngine.evaluate(
          value.substring(5),
          context,
          localization: localization,
        );
      }
      if (value.startsWith('i18n:')) {
        final key = value.substring(5);
        return localization[key] ?? key;
      }
      return value;
    }
    if (value is List) {
      return [
        for (final item in value)
          _resolveConfigValue(item, context, localization),
      ];
    }
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): _resolveConfigValue(
            entry.value,
            context,
            localization,
          ),
      };
    }
    return value;
  }

  bool _truthy(Object? value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.isNotEmpty;
    if (value is Iterable) return value.isNotEmpty;
    return true;
  }
}

/// Runtime dispatcher for applications that want real element renderers.
///
/// The engine enforces that only resolved elements reach these handlers.
/// Unknown/unregistered element types produce an explicit error.
class GeniusPdfTemplateRendererRegistry {
  GeniusPdfTemplateRendererRegistry(
    Iterable<GeniusPdfTemplateElementRenderer> renderers,
  ) : _renderers = {
          for (final renderer in renderers)
            renderer.type: renderer,
        };

  final Map<GeniusPdfTemplateElementType,
      GeniusPdfTemplateElementRenderer> _renderers;

  void render(
    GeniusPdfDocumentBuilder document,
    GeniusPdfResolvedTemplate template,
  ) {
    for (final element in template.elements) {
      _renderElement(document, element);
    }
  }

  void _renderElement(
    GeniusPdfDocumentBuilder document,
    GeniusPdfResolvedTemplateElement element,
  ) {
    final renderer = _renderers[element.type];
    if (renderer == null) {
      throw StateError(
        'No runtime renderer registered for '
        '${element.type.name}.',
      );
    }
    renderer.render(document, element);
    for (final child in element.children) {
      _renderElement(document, child);
    }
  }
}

/// Manual-acceptance diagnostics document for S22.
///
/// It renders the fully resolved schema, inherited direction, component/style
/// results and element config through the real PDF builder. It intentionally
/// does not pretend a Chart/Barcode/etc. visual renderer exists when the host
/// has not registered one.
class GeniusPdfTemplateDiagnosticsDocument
    extends GeniusPdfDocumentBuilder {
  GeniusPdfTemplateDiagnosticsDocument(
    super.config, {
    required this.template,
  });

  final GeniusPdfResolvedTemplate template;

  @override
  void build() {
    newPage();
    addLine(
      'Template ${template.schema.templateId} '
      'v${template.schema.templateVersion} '
      'schema=${template.schema.schemaVersion}',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine(
      'pack=${template.schema.pack} '
      'variant=${template.schema.variant} '
      'family=${template.schema.family ?? '-'} '
      'direction=${template.schema.direction.name}',
    );
    addSpace(8);
    _writeElements(template.elements, 0);
  }

  void _writeElements(
    List<GeniusPdfResolvedTemplateElement> elements,
    int level,
  ) {
    for (final element in elements) {
      final prefix = List.filled(level, '  ').join();
      addLine(
        '$prefix${element.id} :: ${element.type.name} '
        'dir=${element.direction.name} '
        'valueDir=${element.valueDirection.name}',
      );
      if (element.config.isNotEmpty) {
        addLine(
          '$prefix  ${element.config}',
          font: config.smallFont,
        );
      }
      if (element.style.values.isNotEmpty) {
        addLine(
          '$prefix  style=${element.style.values}',
          font: config.smallFont,
        );
      }
      if (element.children.isNotEmpty) {
        _writeElements(element.children, level + 1);
      }
    }
  }
}
