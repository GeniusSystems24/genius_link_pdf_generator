// ignore_for_file: sort_constructors_first

import '../../../core/directionality.dart';

enum GeniusPdfTemplateElementType {
  component,
  section,
  pageBreak,
  barcode,
  qrCode,
  signature,
  summary,
  metric,
  chart,
  attachment,
  stamp,
  label,
  group,
  subTemplate,
}

enum GeniusPdfTemplateValueDirection {
  inherit,
  auto,
  ltr,
  rtl,
}

/// Renderer-independent style data.
///
/// Only JSON-safe values are accepted by validation. No renderer-specific
/// object can enter serialized templates.
class GeniusPdfTemplateStyle {
  const GeniusPdfTemplateStyle({
    this.parent,
    this.values = const {},
  });

  final String? parent;
  final Map<String, Object?> values;

  Map<String, Object?> toMap() => {
        if (parent != null) 'parent': parent,
        'values': values,
      };

  factory GeniusPdfTemplateStyle.fromMap(
    Map<String, Object?> map,
  ) {
    return GeniusPdfTemplateStyle(
      parent: map['parent'] as String?,
      values: Map<String, Object?>.from(
        map['values'] as Map? ?? const {},
      ),
    );
  }
}

/// S22 serialized element.
///
/// `config` is data only. `children` enables Section/Group composition.
/// `repeatPath` is a bounded data loop evaluated by the safe engine.
class GeniusPdfTemplateElement {
  const GeniusPdfTemplateElement({
    required this.id,
    required this.type,
    this.config = const {},
    this.children = const [],
    this.style,
    this.direction = GeniusPdfDirection.auto,
    this.valueDirection = GeniusPdfTemplateValueDirection.inherit,
    this.visibleWhen,
    this.repeatPath,
    this.componentRef,
  });

  final String id;
  final GeniusPdfTemplateElementType type;
  final Map<String, Object?> config;
  final List<GeniusPdfTemplateElement> children;
  final String? style;
  final GeniusPdfDirection direction;
  final GeniusPdfTemplateValueDirection valueDirection;
  final String? visibleWhen;
  final String? repeatPath;
  final String? componentRef;

  factory GeniusPdfTemplateElement.component({
    required String id,
    required String componentRef,
    Map<String, Object?> config = const {},
    GeniusPdfDirection direction = GeniusPdfDirection.auto,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.component,
        componentRef: componentRef,
        config: config,
        direction: direction,
      );

  factory GeniusPdfTemplateElement.section({
    required String id,
    List<GeniusPdfTemplateElement> children = const [],
    String? style,
    String? visibleWhen,
    String? repeatPath,
    GeniusPdfDirection direction = GeniusPdfDirection.auto,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.section,
        children: children,
        style: style,
        visibleWhen: visibleWhen,
        repeatPath: repeatPath,
        direction: direction,
      );

  factory GeniusPdfTemplateElement.pageBreak({
    required String id,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.pageBreak,
      );

  factory GeniusPdfTemplateElement.barcode({
    required String id,
    required String valueExpression,
    String? captionExpression,
    GeniusPdfTemplateValueDirection valueDirection =
        GeniusPdfTemplateValueDirection.ltr,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.barcode,
        valueDirection: valueDirection,
        config: {
          'valueExpression': valueExpression,
          if (captionExpression != null)
            'captionExpression': captionExpression,
        },
      );

  factory GeniusPdfTemplateElement.qrCode({
    required String id,
    required String valueExpression,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.qrCode,
        valueDirection: GeniusPdfTemplateValueDirection.ltr,
        config: {'valueExpression': valueExpression},
      );

  factory GeniusPdfTemplateElement.signature({
    required String id,
    String? signerExpression,
    String? roleExpression,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.signature,
        config: {
          if (signerExpression != null)
            'signerExpression': signerExpression,
          if (roleExpression != null) 'roleExpression': roleExpression,
        },
      );

  factory GeniusPdfTemplateElement.summary({
    required String id,
    required List<Map<String, Object?>> items,
    String? style,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.summary,
        style: style,
        config: {'items': items},
      );

  factory GeniusPdfTemplateElement.metric({
    required String id,
    required String label,
    required String valueExpression,
    String? labelKey,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.metric,
        config: {
          'label': label,
          if (labelKey != null) 'labelKey': labelKey,
          'valueExpression': valueExpression,
        },
      );

  factory GeniusPdfTemplateElement.chart({
    required String id,
    required String chartType,
    required String dataPath,
    String? fallbackTableComponent,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.chart,
        config: {
          'chartType': chartType,
          'dataPath': dataPath,
          if (fallbackTableComponent != null)
            'fallbackTableComponent': fallbackTableComponent,
        },
      );

  factory GeniusPdfTemplateElement.attachment({
    required String id,
    required String referenceExpression,
    String? labelExpression,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.attachment,
        config: {
          'referenceExpression': referenceExpression,
          if (labelExpression != null)
            'labelExpression': labelExpression,
        },
      );

  factory GeniusPdfTemplateElement.stamp({
    required String id,
    required String textExpression,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.stamp,
        config: {'textExpression': textExpression},
      );

  factory GeniusPdfTemplateElement.label({
    required String id,
    required String label,
    required String valueExpression,
    GeniusPdfTemplateValueDirection valueDirection =
        GeniusPdfTemplateValueDirection.auto,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.label,
        valueDirection: valueDirection,
        config: {
          'label': label,
          'valueExpression': valueExpression,
        },
      );

  factory GeniusPdfTemplateElement.group({
    required String id,
    required List<GeniusPdfTemplateElement> children,
    String? repeatPath,
    String? visibleWhen,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.group,
        children: children,
        repeatPath: repeatPath,
        visibleWhen: visibleWhen,
      );

  factory GeniusPdfTemplateElement.subTemplate({
    required String id,
    required String templateId,
    String? variant,
  }) =>
      GeniusPdfTemplateElement(
        id: id,
        type: GeniusPdfTemplateElementType.subTemplate,
        config: {
          'templateId': templateId,
          if (variant != null) 'variant': variant,
        },
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.name,
        if (config.isNotEmpty) 'config': config,
        if (children.isNotEmpty)
          'children': [for (final child in children) child.toMap()],
        if (style != null) 'style': style,
        'direction': direction.name,
        'valueDirection': valueDirection.name,
        if (visibleWhen != null) 'visibleWhen': visibleWhen,
        if (repeatPath != null) 'repeatPath': repeatPath,
        if (componentRef != null) 'componentRef': componentRef,
      };

  factory GeniusPdfTemplateElement.fromMap(
    Map<String, Object?> map,
  ) {
    final rawType = map['type'];
    final type = GeniusPdfTemplateElementType.values
        .where((value) => value.name == rawType)
        .firstOrNull;
    if (type == null) {
      throw ArgumentError.value(
        rawType,
        'type',
        'Unknown template element type.',
      );
    }

    final rawDirection = map['direction']?.toString() ?? 'auto';
    final direction = GeniusPdfDirection.values
        .where((value) => value.name == rawDirection)
        .firstOrNull;
    if (direction == null) {
      throw ArgumentError.value(
        rawDirection,
        'direction',
        'Expected auto/ltr/rtl.',
      );
    }

    final rawValueDirection =
        map['valueDirection']?.toString() ?? 'inherit';
    final valueDirection = GeniusPdfTemplateValueDirection.values
        .where((value) => value.name == rawValueDirection)
        .firstOrNull;
    if (valueDirection == null) {
      throw ArgumentError.value(
        rawValueDirection,
        'valueDirection',
      );
    }

    final childrenRaw = map['children'] as List? ?? const [];
    return GeniusPdfTemplateElement(
      id: map['id']?.toString() ?? '',
      type: type,
      config: Map<String, Object?>.from(
        map['config'] as Map? ?? const {},
      ),
      children: [
        for (final child in childrenRaw)
          GeniusPdfTemplateElement.fromMap(
            Map<String, Object?>.from(child as Map),
          ),
      ],
      style: map['style'] as String?,
      direction: direction,
      valueDirection: valueDirection,
      visibleWhen: map['visibleWhen'] as String?,
      repeatPath: map['repeatPath'] as String?,
      componentRef: map['componentRef'] as String?,
    );
  }
}
