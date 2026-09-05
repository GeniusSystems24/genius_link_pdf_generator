
import '../core/directionality.dart';
import '../template_engine_vnext/template_engine_vnext.dart';
import 'designer_models.dart';

class GeniusPdfDesignerValidationResult {
  const GeniusPdfDesignerValidationResult(this.messages);

  final List<String> messages;
  bool get isValid => messages.isEmpty;
}

class GeniusPdfDesignerAuthoringController {
  const GeniusPdfDesignerAuthoringController();

  GeniusPdfDesignerDocumentState select(
    GeniusPdfDesignerDocumentState state,
    String? elementId,
  ) =>
      state.copyWith(
        selectedElementId: elementId,
        clearSelection: elementId == null,
        revision: state.revision + 1,
      );

  GeniusPdfDesignerDocumentState setDirectionMode(
    GeniusPdfDesignerDocumentState state,
    GeniusPdfDesignerDirectionMode mode,
  ) =>
      state.copyWith(
        directionMode: mode,
        revision: state.revision + 1,
      );

  GeniusPdfDesignerDocumentState setPageProfile(
    GeniusPdfDesignerDocumentState state,
    String pageProfileId,
  ) {
    if (pageProfileId.trim().isEmpty) {
      throw ArgumentError('pageProfileId cannot be empty.');
    }
    return state.copyWith(
      pageProfileId: pageProfileId,
      revision: state.revision + 1,
    );
  }

  GeniusPdfDesignerDocumentState setSampleData(
    GeniusPdfDesignerDocumentState state,
    Map<String, Object?> sampleData,
  ) =>
      state.copyWith(
        sampleData: Map.unmodifiable(sampleData),
        revision: state.revision + 1,
      );

  GeniusPdfDesignerDocumentState setLocalization(
    GeniusPdfDesignerDocumentState state,
    Map<String, String> localization,
  ) =>
      state.copyWith(
        localization: Map.unmodifiable(localization),
        revision: state.revision + 1,
      );

  /// S25-T12/T13 — add tables/sections through safe schema elements.
  GeniusPdfDesignerDocumentState addElement(
    GeniusPdfDesignerDocumentState state,
    GeniusPdfTemplateElement element, {
    String? parentId,
    GeniusPdfDesignerDropPosition position =
        GeniusPdfDesignerDropPosition.inside,
    String? siblingId,
  }) {
    final elements = _insert(
      state.schema.elements,
      element,
      parentId: parentId,
      position: position,
      siblingId: siblingId,
    );
    return _withElements(
      state,
      elements,
      selectedElementId: element.id,
    );
  }

  GeniusPdfDesignerDocumentState removeElement(
    GeniusPdfDesignerDocumentState state,
    String elementId,
  ) {
    final result = _remove(state.schema.elements, elementId);
    return _withElements(
      state,
      result,
      clearSelection: state.selectedElementId == elementId,
    );
  }

  /// S25-T02 drag/drop reordering.
  GeniusPdfDesignerDocumentState moveElement(
    GeniusPdfDesignerDocumentState state, {
    required String elementId,
    String? targetParentId,
    String? siblingId,
    GeniusPdfDesignerDropPosition position =
        GeniusPdfDesignerDropPosition.inside,
  }) {
    final found = _find(state.schema.elements, elementId);
    if (found == null) {
      throw StateError('Element `$elementId` was not found.');
    }
    var elements = _remove(state.schema.elements, elementId);
    elements = _insert(
      elements,
      found,
      parentId: targetParentId,
      siblingId: siblingId,
      position: position,
    );
    return _withElements(
      state,
      elements,
      selectedElementId: elementId,
    );
  }

  /// S25-T14/T15 — conditions and expressions.
  GeniusPdfDesignerDocumentState updateElement(
    GeniusPdfDesignerDocumentState state,
    String elementId, {
    Map<String, Object?>? config,
    String? visibleWhen,
    bool clearVisibleWhen = false,
    String? repeatPath,
    bool clearRepeatPath = false,
    String? style,
    bool clearStyle = false,
    GeniusPdfDirection? direction,
    GeniusPdfTemplateValueDirection? valueDirection,
  }) {
    final elements = _map(
      state.schema.elements,
      (element) {
        if (element.id != elementId) return element;
        return GeniusPdfTemplateElement(
          id: element.id,
          type: element.type,
          config: config ?? element.config,
          children: element.children,
          style: clearStyle ? null : style ?? element.style,
          direction: direction ?? element.direction,
          valueDirection: valueDirection ?? element.valueDirection,
          visibleWhen: clearVisibleWhen
              ? null
              : visibleWhen ?? element.visibleWhen,
          repeatPath:
              clearRepeatPath ? null : repeatPath ?? element.repeatPath,
          componentRef: element.componentRef,
        );
      },
    );
    return _withElements(
      state,
      elements,
      selectedElementId: elementId,
    );
  }

  /// S25-T16 — subtemplates.
  GeniusPdfDesignerDocumentState addSubTemplate(
    GeniusPdfDesignerDocumentState state, {
    required String id,
    required String templateId,
    String? variant,
    String? parentId,
  }) =>
      addElement(
        state,
        GeniusPdfTemplateElement.subTemplate(
          id: id,
          templateId: templateId,
          variant: variant,
        ),
        parentId: parentId,
      );

  /// S25-T17 — named components.
  GeniusPdfDesignerDocumentState setNamedComponent(
    GeniusPdfDesignerDocumentState state,
    String name,
    GeniusPdfTemplateElement component,
  ) {
    final schema = _copySchema(
      state.schema,
      components: {
        ...state.schema.components,
        name: component,
      },
    );
    return state.copyWith(
      schema: schema,
      revision: state.revision + 1,
    );
  }

  /// S25-T18 — style editor / inheritance.
  GeniusPdfDesignerDocumentState setStyle(
    GeniusPdfDesignerDocumentState state,
    String name,
    GeniusPdfTemplateStyle style,
  ) {
    final schema = _copySchema(
      state.schema,
      styles: {
        ...state.schema.styles,
        name: style,
      },
    );
    return state.copyWith(
      schema: schema,
      revision: state.revision + 1,
    );
  }

  GeniusPdfDesignerValidationResult validate(
    GeniusPdfDesignerDocumentState state,
  ) {
    final messages = <String>[];
    final schemaResult =
        const GeniusPdfTemplateSchemaValidator().validate(state.schema);
    messages.addAll(
      schemaResult.issues.map((issue) => issue.toString()),
    );

    final ids = <String>{};
    void visit(GeniusPdfTemplateElement element) {
      if (!ids.add(element.id)) {
        messages.add('Duplicate designer element id `${element.id}`.');
      }
      if (element.repeatPath != null &&
          element.repeatPath!.trim().isEmpty) {
        messages.add(
          'Element `${element.id}` has an empty repeatPath.',
        );
      }
      for (final child in element.children) {
        visit(child);
      }
    }

    for (final element in state.schema.elements) {
      visit(element);
    }
    return GeniusPdfDesignerValidationResult(
      List.unmodifiable(messages),
    );
  }

  GeniusPdfDesignerDocumentState withValidation(
    GeniusPdfDesignerDocumentState state,
  ) {
    final result = validate(state);
    return state.copyWith(
      validationMessages: result.messages,
      revision: state.revision + 1,
    );
  }

  List<GeniusPdfTemplateElement> _insert(
    List<GeniusPdfTemplateElement> source,
    GeniusPdfTemplateElement element, {
    String? parentId,
    String? siblingId,
    required GeniusPdfDesignerDropPosition position,
  }) {
    if (parentId == null && siblingId == null) {
      return [...source, element];
    }

    var inserted = false;
    List<GeniusPdfTemplateElement> walk(
      List<GeniusPdfTemplateElement> items,
    ) {
      final output = <GeniusPdfTemplateElement>[];
      for (final item in items) {
        if (siblingId == item.id &&
            position == GeniusPdfDesignerDropPosition.before) {
          output.add(element);
          inserted = true;
        }

        var current = item;
        if (parentId == item.id &&
            position == GeniusPdfDesignerDropPosition.inside) {
          current = _copyElement(
            item,
            children: [...item.children, element],
          );
          inserted = true;
        } else if (item.children.isNotEmpty) {
          current = _copyElement(
            item,
            children: walk(item.children),
          );
        }
        output.add(current);

        if (siblingId == item.id &&
            position == GeniusPdfDesignerDropPosition.after) {
          output.add(element);
          inserted = true;
        }
      }
      return output;
    }

    final result = walk(source);
    if (!inserted) {
      throw StateError(
        'Designer drop target was not found '
        '(parent=$parentId, sibling=$siblingId).',
      );
    }
    return result;
  }

  List<GeniusPdfTemplateElement> _remove(
    List<GeniusPdfTemplateElement> source,
    String id,
  ) =>
      [
        for (final item in source)
          if (item.id != id)
            _copyElement(
              item,
              children: _remove(item.children, id),
            ),
      ];

  GeniusPdfTemplateElement? _find(
    List<GeniusPdfTemplateElement> source,
    String id,
  ) {
    for (final item in source) {
      if (item.id == id) return item;
      final child = _find(item.children, id);
      if (child != null) return child;
    }
    return null;
  }

  List<GeniusPdfTemplateElement> _map(
    List<GeniusPdfTemplateElement> source,
    GeniusPdfTemplateElement Function(
      GeniusPdfTemplateElement element,
    ) mapper,
  ) =>
      [
        for (final item in source)
          mapper(
            _copyElement(
              item,
              children: _map(item.children, mapper),
            ),
          ),
      ];

  GeniusPdfTemplateElement _copyElement(
    GeniusPdfTemplateElement source, {
    List<GeniusPdfTemplateElement>? children,
  }) =>
      GeniusPdfTemplateElement(
        id: source.id,
        type: source.type,
        config: source.config,
        children: children ?? source.children,
        style: source.style,
        direction: source.direction,
        valueDirection: source.valueDirection,
        visibleWhen: source.visibleWhen,
        repeatPath: source.repeatPath,
        componentRef: source.componentRef,
      );

  GeniusPdfDesignerDocumentState _withElements(
    GeniusPdfDesignerDocumentState state,
    List<GeniusPdfTemplateElement> elements, {
    String? selectedElementId,
    bool clearSelection = false,
  }) {
    final schema = _copySchema(
      state.schema,
      elements: elements,
    );
    return state.copyWith(
      schema: schema,
      selectedElementId: selectedElementId,
      clearSelection: clearSelection,
      revision: state.revision + 1,
    );
  }

  GeniusPdfTemplateSchema _copySchema(
    GeniusPdfTemplateSchema source, {
    List<GeniusPdfTemplateElement>? elements,
    Map<String, GeniusPdfTemplateElement>? components,
    Map<String, GeniusPdfTemplateStyle>? styles,
  }) =>
      GeniusPdfTemplateSchema(
        schemaVersion: source.schemaVersion,
        templateId: source.templateId,
        templateVersion: source.templateVersion,
        name: source.name,
        pack: source.pack,
        variant: source.variant,
        locale: source.locale,
        country: source.country,
        organization: source.organization,
        branch: source.branch,
        effectiveFrom: source.effectiveFrom,
        effectiveTo: source.effectiveTo,
        state: source.state,
        direction: source.direction,
        family: source.family,
        extendsTemplateId: source.extendsTemplateId,
        components: components ?? source.components,
        styles: styles ?? source.styles,
        elements: elements ?? source.elements,
        metadata: source.metadata,
      );
}
