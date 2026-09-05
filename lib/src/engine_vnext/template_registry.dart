
import 'dart:convert';

import 'template_schema.dart';

class TemplateId {
  const TemplateId(this.value);
  final String value;

  @override
  bool operator ==(Object other) =>
      other is TemplateId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class TemplateVersion implements Comparable<TemplateVersion> {
  const TemplateVersion(this.value) : assert(value >= 1);
  final int value;

  @override
  int compareTo(TemplateVersion other) =>
      value.compareTo(other.value);

  @override
  String toString() => '$value';
}

class TemplatePack {
  const TemplatePack({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;
}

/// S22-T35..T41 registry selection scope.
class GeniusPdfTemplateScope {
  const GeniusPdfTemplateScope({
    this.variant,
    this.locale,
    this.country,
    this.organization,
    this.branch,
    this.at,
  });

  final String? variant;
  final String? locale;
  final String? country;
  final String? organization;
  final String? branch;
  final DateTime? at;
}

class GeniusPdfTemplateHistoryEntry {
  const GeniusPdfTemplateHistoryEntry({
    required this.templateId,
    required this.templateVersion,
    required this.checksum,
    required this.state,
    required this.recordedAt,
    required this.snapshot,
  });

  final TemplateId templateId;
  final TemplateVersion templateVersion;
  final String checksum;
  final GeniusPdfTemplateState state;
  final DateTime recordedAt;
  final Map<String, Object?> snapshot;
}

/// In-memory registry abstraction with deterministic fallback and history.
///
/// Persistence is intentionally left to callers; the registry stores only
/// renderer-independent schema maps.
class GeniusPdfTemplateRegistry {
  GeniusPdfTemplateRegistry({
    this.clock = DateTime.now,
  });

  final DateTime Function() clock;

  final Map<String, List<GeniusPdfTemplateSchema>> _templates = {};
  final Map<String, List<GeniusPdfTemplateHistoryEntry>> _history = {};

  void register(
    GeniusPdfTemplateSchema schema, {
    bool replaceSameVersion = false,
  }) {
    final validation =
        const GeniusPdfTemplateSchemaValidator().validate(schema);
    if (!validation.isValid) {
      throw GeniusPdfTemplateSchemaException(
        'Cannot register invalid template.',
        issues: validation.issues,
      );
    }

    final list =
        _templates.putIfAbsent(schema.templateId, () => []);
    final existingIndex = list.indexWhere(
      (item) =>
          item.templateVersion == schema.templateVersion &&
          item.pack == schema.pack &&
          item.variant == schema.variant &&
          item.locale == schema.locale &&
          item.country == schema.country &&
          item.organization == schema.organization &&
          item.branch == schema.branch,
    );

    if (existingIndex >= 0 && !replaceSameVersion) {
      throw StateError(
        'Template ${schema.templateId} v${schema.templateVersion} '
        'already exists for the same scope.',
      );
    }

    if (existingIndex >= 0) {
      list[existingIndex] = schema;
    } else {
      list.add(schema);
    }

    list.sort(
      (a, b) => b.templateVersion.compareTo(a.templateVersion),
    );
    _record(schema);
  }

  GeniusPdfTemplateSchema? resolve(
    TemplateId id, {
    GeniusPdfTemplateScope scope = const GeniusPdfTemplateScope(),
    bool includeDraft = false,
  }) {
    final candidates = [
      ...?_templates[id.value],
    ].where((schema) {
      if (!includeDraft &&
          schema.state != GeniusPdfTemplateState.published) {
        return false;
      }
      final at = scope.at ?? clock();
      if (schema.effectiveFrom != null &&
          at.isBefore(schema.effectiveFrom!)) {
        return false;
      }
      if (schema.effectiveTo != null &&
          at.isAfter(schema.effectiveTo!)) {
        return false;
      }
      return _scopeCompatible(schema, scope);
    }).toList();

    candidates.sort((a, b) {
      final score = _score(b, scope).compareTo(_score(a, scope));
      if (score != 0) return score;
      return b.templateVersion.compareTo(a.templateVersion);
    });

    return candidates.isEmpty ? null : candidates.first;
  }

  /// S22-T41 fallback hierarchy:
  /// Branch > Organization > Country > Locale > Variant > generic.
  int _score(
    GeniusPdfTemplateSchema schema,
    GeniusPdfTemplateScope scope,
  ) {
    var score = 0;
    if (schema.variant != 'default' &&
        schema.variant == scope.variant) {
      score += 1;
    }
    if (schema.locale != null &&
        schema.locale == scope.locale) {
      score += 10;
    }
    if (schema.country != null &&
        schema.country == scope.country) {
      score += 100;
    }
    if (schema.organization != null &&
        schema.organization == scope.organization) {
      score += 1000;
    }
    if (schema.branch != null &&
        schema.branch == scope.branch) {
      score += 10000;
    }
    return score;
  }

  bool _scopeCompatible(
    GeniusPdfTemplateSchema schema,
    GeniusPdfTemplateScope scope,
  ) {
    bool compatible(String? value, String? wanted) =>
        value == null || value == wanted;

    return (schema.variant == 'default' ||
            schema.variant == (scope.variant ?? 'default')) &&
        compatible(schema.locale, scope.locale) &&
        compatible(schema.country, scope.country) &&
        compatible(schema.organization, scope.organization) &&
        compatible(schema.branch, scope.branch);
  }

  List<GeniusPdfTemplateHistoryEntry> history(
    TemplateId id,
  ) =>
      List.unmodifiable(_history[id.value] ?? const []);

  /// S22-T43 history/checksum/rollback.
  GeniusPdfTemplateSchema rollback(
    TemplateId id, {
    required String checksum,
  }) {
    final history = _history[id.value] ?? const [];
    final entry = history
        .where((item) => item.checksum == checksum)
        .firstOrNull;
    if (entry == null) {
      throw StateError(
        'No history snapshot with checksum `$checksum`.',
      );
    }

    final schema = GeniusPdfTemplateSchema.fromMap(
      Map<String, Object?>.from(entry.snapshot),
    );
    register(schema, replaceSameVersion: true);
    return schema;
  }

  void _record(GeniusPdfTemplateSchema schema) {
    final map = schema.toMap();
    final canonical = _canonicalJson(map);
    final checksum = _fnv1a64(canonical);
    final entry = GeniusPdfTemplateHistoryEntry(
      templateId: TemplateId(schema.templateId),
      templateVersion:
          TemplateVersion(schema.templateVersion),
      checksum: checksum,
      state: schema.state,
      recordedAt: clock(),
      snapshot: Map<String, Object?>.from(
        jsonDecode(jsonEncode(map)) as Map,
      ),
    );
    _history
        .putIfAbsent(schema.templateId, () => [])
        .add(entry);
  }

  String _canonicalJson(Object? value) {
    Object? normalize(Object? input) {
      if (input is Map) {
        final keys = input.keys.map((key) => key.toString()).toList()
          ..sort();
        return {
          for (final key in keys)
            key: normalize(input[key]),
        };
      }
      if (input is List) {
        return [for (final item in input) normalize(item)];
      }
      return input;
    }

    return jsonEncode(normalize(value));
  }

  String _fnv1a64(String source) {
    var hash = 0xcbf29ce484222325;
    const prime = 0x100000001b3;
    const mask = 0xffffffffffffffff;
    for (final unit in utf8.encode(source)) {
      hash ^= unit;
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
