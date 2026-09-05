// ignore_for_file: sort_constructors_first

import 'dart:convert';

import '../core/directionality.dart';
import 'template_elements.dart';

enum GeniusPdfTemplateState {
  draft,
  published,
  retired,
}

class GeniusPdfTemplateValidationIssue {
  const GeniusPdfTemplateValidationIssue({
    required this.path,
    required this.message,
    this.code = 'invalid',
  });

  final String path;
  final String message;
  final String code;

  @override
  String toString() => '$path: $message [$code]';
}

class GeniusPdfTemplateValidationResult {
  const GeniusPdfTemplateValidationResult(this.issues);

  final List<GeniusPdfTemplateValidationIssue> issues;
  bool get isValid => issues.isEmpty;
}

class GeniusPdfTemplateSchemaException implements Exception {
  const GeniusPdfTemplateSchemaException(
    this.message, {
    this.issues = const [],
  });

  final String message;
  final List<GeniusPdfTemplateValidationIssue> issues;

  @override
  String toString() {
    if (issues.isEmpty) return 'GeniusPdfTemplateSchemaException: $message';
    return 'GeniusPdfTemplateSchemaException: $message\n'
        '${issues.map((item) => ' - $item').join('\n')}';
  }
}

/// S22-T01 explicit versioned, renderer-independent schema.
class GeniusPdfTemplateSchema {
  const GeniusPdfTemplateSchema({
    required this.templateId,
    required this.templateVersion,
    required this.name,
    required this.elements,
    this.schemaVersion = currentSchemaVersion,
    this.pack = 'default',
    this.variant = 'default',
    this.locale,
    this.country,
    this.organization,
    this.branch,
    this.effectiveFrom,
    this.effectiveTo,
    this.state = GeniusPdfTemplateState.draft,
    this.direction = GeniusPdfDirection.auto,
    this.family,
    this.extendsTemplateId,
    this.components = const {},
    this.styles = const {},
    this.metadata = const {},
  });

  static const int currentSchemaVersion = 2;

  final int schemaVersion;
  final String templateId;
  final int templateVersion;
  final String name;
  final String pack;
  final String variant;
  final String? locale;
  final String? country;
  final String? organization;
  final String? branch;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final GeniusPdfTemplateState state;
  final GeniusPdfDirection direction;

  /// S22-T31 document-family binding, stored as a logical family name.
  final String? family;

  /// S22-T28 inheritance/composition.
  final String? extendsTemplateId;

  /// S22-T29 named reusable components.
  final Map<String, GeniusPdfTemplateElement> components;

  /// S22-T30 style inheritance.
  final Map<String, GeniusPdfTemplateStyle> styles;

  final List<GeniusPdfTemplateElement> elements;
  final Map<String, Object?> metadata;

  Map<String, Object?> toMap() => {
        'schemaVersion': schemaVersion,
        'templateId': templateId,
        'templateVersion': templateVersion,
        'name': name,
        'pack': pack,
        'variant': variant,
        if (locale != null) 'locale': locale,
        if (country != null) 'country': country,
        if (organization != null) 'organization': organization,
        if (branch != null) 'branch': branch,
        if (effectiveFrom != null)
          'effectiveFrom': effectiveFrom!.toIso8601String(),
        if (effectiveTo != null)
          'effectiveTo': effectiveTo!.toIso8601String(),
        'state': state.name,
        'direction': direction.name,
        if (family != null) 'family': family,
        if (extendsTemplateId != null)
          'extendsTemplateId': extendsTemplateId,
        'components': {
          for (final entry in components.entries)
            entry.key: entry.value.toMap(),
        },
        'styles': {
          for (final entry in styles.entries)
            entry.key: entry.value.toMap(),
        },
        'elements': [for (final element in elements) element.toMap()],
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  String toJson() => jsonEncode(toMap());

  factory GeniusPdfTemplateSchema.fromMap(
    Map<String, Object?> raw,
  ) {
    final migrated = const GeniusPdfTemplateSchemaMigrator().migrate(raw);
    final stateName = migrated['state']?.toString() ?? 'draft';
    final state = GeniusPdfTemplateState.values
        .where((value) => value.name == stateName)
        .firstOrNull;
    if (state == null) {
      throw GeniusPdfTemplateSchemaException(
        'Unknown template state `$stateName`.',
      );
    }

    final directionName =
        migrated['direction']?.toString() ?? 'auto';
    final direction = GeniusPdfDirection.values
        .where((value) => value.name == directionName)
        .firstOrNull;
    if (direction == null) {
      throw GeniusPdfTemplateSchemaException(
        'Unknown direction `$directionName`.',
      );
    }

    final componentsRaw =
        migrated['components'] as Map? ?? const {};
    final stylesRaw = migrated['styles'] as Map? ?? const {};
    final elementsRaw =
        migrated['elements'] as List? ?? const [];

    late final GeniusPdfTemplateSchema schema;
    try {
      schema = GeniusPdfTemplateSchema(
        schemaVersion:
            (migrated['schemaVersion'] as num).toInt(),
        templateId: migrated['templateId']?.toString() ?? '',
        templateVersion:
            (migrated['templateVersion'] as num?)?.toInt() ?? 1,
        name: migrated['name']?.toString() ?? '',
        pack: migrated['pack']?.toString() ?? 'default',
        variant: migrated['variant']?.toString() ?? 'default',
        locale: migrated['locale'] as String?,
        country: migrated['country'] as String?,
        organization: migrated['organization'] as String?,
        branch: migrated['branch'] as String?,
        effectiveFrom: _parseDate(migrated['effectiveFrom']),
        effectiveTo: _parseDate(migrated['effectiveTo']),
        state: state,
        direction: direction,
        family: migrated['family'] as String?,
        extendsTemplateId:
            migrated['extendsTemplateId'] as String?,
        components: {
          for (final entry in componentsRaw.entries)
            entry.key.toString():
                GeniusPdfTemplateElement.fromMap(
              Map<String, Object?>.from(entry.value as Map),
            ),
        },
        styles: {
          for (final entry in stylesRaw.entries)
            entry.key.toString():
                GeniusPdfTemplateStyle.fromMap(
              Map<String, Object?>.from(entry.value as Map),
            ),
        },
        elements: [
          for (final element in elementsRaw)
            GeniusPdfTemplateElement.fromMap(
              Map<String, Object?>.from(element as Map),
            ),
        ],
        metadata: Map<String, Object?>.from(
          migrated['metadata'] as Map? ?? const {},
        ),
      );
    } on ArgumentError catch (error) {
      throw GeniusPdfTemplateSchemaException(
        'Invalid template element: $error',
      );
    }

    final result = const GeniusPdfTemplateSchemaValidator().validate(schema);
    if (!result.isValid) {
      throw GeniusPdfTemplateSchemaException(
        'Template schema validation failed.',
        issues: result.issues,
      );
    }
    return schema;
  }

  factory GeniusPdfTemplateSchema.fromJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) {
      throw const GeniusPdfTemplateSchemaException(
        'Template JSON root must be an object.',
      );
    }
    return GeniusPdfTemplateSchema.fromMap(
      Map<String, Object?>.from(decoded),
    );
  }

  static DateTime? _parseDate(Object? value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}

/// S22-T02/T04/T50 schema migration + old-map compatibility.
///
/// Legacy/current maps without `schemaVersion` are treated as v1. Migration
/// never mutates the caller's map.
class GeniusPdfTemplateSchemaMigrator {
  const GeniusPdfTemplateSchemaMigrator();

  Map<String, Object?> migrate(
    Map<String, Object?> input,
  ) {
    var current = _deepCopyMap(input);
    var version =
        (current['schemaVersion'] as num?)?.toInt() ?? 1;

    if (version < 1) {
      throw const GeniusPdfTemplateSchemaException(
        'schemaVersion must be >= 1.',
      );
    }
    if (version > GeniusPdfTemplateSchema.currentSchemaVersion) {
      throw GeniusPdfTemplateSchemaException(
        'Unsupported future schemaVersion $version.',
      );
    }

    while (version < GeniusPdfTemplateSchema.currentSchemaVersion) {
      switch (version) {
        case 1:
          current = _migrateV1ToV2(current);
          version = 2;
          break;
        default:
          throw GeniusPdfTemplateSchemaException(
            'No migration registered from schema $version.',
          );
      }
    }
    current['schemaVersion'] = version;
    return current;
  }

  Map<String, Object?> _migrateV1ToV2(
    Map<String, Object?> source,
  ) {
    final result = _deepCopyMap(source);
    result['schemaVersion'] = 2;
    result['templateVersion'] ??= 1;
    result['pack'] ??= 'default';
    result['variant'] ??= 'default';
    result['state'] ??= 'draft';
    result['direction'] ??= 'auto';
    result['components'] ??= <String, Object?>{};
    result['styles'] ??= <String, Object?>{};
    result['metadata'] ??= <String, Object?>{};

    // Current definitions that used `items` become the v2 `elements` list.
    if (result['elements'] == null && result['items'] is List) {
      result['elements'] = result.remove('items');
    }
    result['elements'] ??= <Object?>[];
    return result;
  }

  Map<String, Object?> _deepCopyMap(
    Map<String, Object?> source,
  ) =>
      Map<String, Object?>.from(
        jsonDecode(jsonEncode(source)) as Map,
      );
}

/// Explicit old-definition adapter. Existing legacy classes/exports remain
/// untouched; callers can migrate their map representation into vNext.
class GeniusPdfLegacyTemplateAdapter {
  const GeniusPdfLegacyTemplateAdapter();

  GeniusPdfTemplateSchema fromCurrentDefinition(
    Map<String, Object?> definition,
  ) =>
      GeniusPdfTemplateSchema.fromMap(definition);
}

class GeniusPdfTemplateSchemaValidator {
  const GeniusPdfTemplateSchemaValidator();

  GeniusPdfTemplateValidationResult validate(
    GeniusPdfTemplateSchema schema,
  ) {
    final issues = <GeniusPdfTemplateValidationIssue>[];

    if (schema.schemaVersion !=
        GeniusPdfTemplateSchema.currentSchemaVersion) {
      issues.add(
        GeniusPdfTemplateValidationIssue(
          path: 'schemaVersion',
          code: 'unsupported_version',
          message:
              'Expected ${GeniusPdfTemplateSchema.currentSchemaVersion}; '
              'got ${schema.schemaVersion}.',
        ),
      );
    }
    if (schema.templateId.trim().isEmpty) {
      issues.add(
        const GeniusPdfTemplateValidationIssue(
          path: 'templateId',
          message: 'TemplateId cannot be empty.',
        ),
      );
    }
    if (schema.templateVersion < 1) {
      issues.add(
        const GeniusPdfTemplateValidationIssue(
          path: 'templateVersion',
          message: 'TemplateVersion must be >= 1.',
        ),
      );
    }
    if (schema.name.trim().isEmpty) {
      issues.add(
        const GeniusPdfTemplateValidationIssue(
          path: 'name',
          message: 'Template name cannot be empty.',
        ),
      );
    }
    if (schema.effectiveFrom != null &&
        schema.effectiveTo != null &&
        schema.effectiveTo!.isBefore(schema.effectiveFrom!)) {
      issues.add(
        const GeniusPdfTemplateValidationIssue(
          path: 'effectiveTo',
          message: 'EffectiveTo cannot be before EffectiveFrom.',
        ),
      );
    }

    final ids = <String>{};
    void validateElement(
      GeniusPdfTemplateElement element,
      String path,
    ) {
      if (element.id.trim().isEmpty) {
        issues.add(
          GeniusPdfTemplateValidationIssue(
            path: '$path.id',
            message: 'Element id cannot be empty.',
          ),
        );
      } else if (!ids.add(element.id)) {
        issues.add(
          GeniusPdfTemplateValidationIssue(
            path: '$path.id',
            code: 'duplicate_id',
            message: 'Duplicate element id `${element.id}`.',
          ),
        );
      }

      if (element.type == GeniusPdfTemplateElementType.component &&
          (element.componentRef == null ||
              element.componentRef!.trim().isEmpty)) {
        issues.add(
          GeniusPdfTemplateValidationIssue(
            path: '$path.componentRef',
            message: 'Component requires componentRef.',
          ),
        );
      }

      if (element.type ==
              GeniusPdfTemplateElementType.subTemplate &&
          (element.config['templateId'] == null ||
              element.config['templateId'].toString().trim().isEmpty)) {
        issues.add(
          GeniusPdfTemplateValidationIssue(
            path: '$path.config.templateId',
            message: 'SubTemplate requires templateId.',
          ),
        );
      }

      _validateJsonSafe(
        element.config,
        '$path.config',
        issues,
      );

      for (var index = 0;
          index < element.children.length;
          index++) {
        validateElement(
          element.children[index],
          '$path.children[$index]',
        );
      }
    }

    for (var index = 0;
        index < schema.elements.length;
        index++) {
      validateElement(
        schema.elements[index],
        'elements[$index]',
      );
    }
    for (final entry in schema.components.entries) {
      validateElement(
        entry.value,
        'components.${entry.key}',
      );
    }
    for (final entry in schema.styles.entries) {
      _validateJsonSafe(
        entry.value.values,
        'styles.${entry.key}.values',
        issues,
      );
    }
    _validateJsonSafe(schema.metadata, 'metadata', issues);

    return GeniusPdfTemplateValidationResult(issues);
  }

  void _validateJsonSafe(
    Object? value,
    String path,
    List<GeniusPdfTemplateValidationIssue> issues,
  ) {
    if (value == null ||
        value is String ||
        value is num ||
        value is bool) {
      return;
    }
    if (value is List) {
      for (var index = 0; index < value.length; index++) {
        _validateJsonSafe(
          value[index],
          '$path[$index]',
          issues,
        );
      }
      return;
    }
    if (value is Map) {
      for (final entry in value.entries) {
        if (entry.key is! String) {
          issues.add(
            GeniusPdfTemplateValidationIssue(
              path: path,
              code: 'non_string_key',
              message: 'Serialized maps require String keys.',
            ),
          );
          continue;
        }
        _validateJsonSafe(
          entry.value,
          '$path.${entry.key}',
          issues,
        );
      }
      return;
    }

    issues.add(
      GeniusPdfTemplateValidationIssue(
        path: path,
        code: 'renderer_object_not_allowed',
        message:
            'Only JSON-safe primitives/lists/maps are allowed; '
            'found ${value.runtimeType}.',
      ),
    );
  }
}
