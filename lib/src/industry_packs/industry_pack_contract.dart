
import '../compliance/compliance.dart';
import '../template_engine_vnext/template_engine_vnext.dart';

class GeniusPdfIndustryVersionRange {
  const GeniusPdfIndustryVersionRange({
    required this.minimumCore,
    this.maximumCoreExclusive,
  });

  final String minimumCore;
  final String? maximumCoreExclusive;

  bool supports(String coreVersion) {
    final current = _parse(coreVersion);
    final minimum = _parse(minimumCore);
    if (_compare(current, minimum) < 0) return false;
    final maximum = maximumCoreExclusive;
    if (maximum != null &&
        _compare(current, _parse(maximum)) >= 0) {
      return false;
    }
    return true;
  }

  List<int> _parse(String value) {
    final normalized = value.split('+').first.split('-').first;
    final parts = normalized.split('.');
    if (parts.length < 3) {
      throw FormatException(
        'Expected semantic version x.y.z; got `$value`.',
      );
    }
    return [
      for (final part in parts.take(3))
        int.tryParse(part) ??
            (throw FormatException(
              'Invalid semantic version `$value`.',
            )),
    ];
  }

  int _compare(List<int> a, List<int> b) {
    for (var index = 0; index < 3; index++) {
      final value = a[index].compareTo(b[index]);
      if (value != 0) return value;
    }
    return 0;
  }
}

/// S26-T03 — declares a plugin-owned model namespace/extension contract.
///
/// The core library does not define regulated healthcare/education entities;
/// external plugins register the model keys they provide.
class GeniusPdfIndustryDomainExtension {
  const GeniusPdfIndustryDomainExtension({
    required this.namespace,
    required this.modelKeys,
    this.description,
  });

  final String namespace;
  final List<String> modelKeys;
  final String? description;
}

/// S26-T04 — optional compliance integration without embedding country law.
class GeniusPdfIndustryComplianceHook {
  const GeniusPdfIndustryComplianceHook({
    required this.profileId,
    this.required = false,
  });

  final String profileId;
  final bool required;
}

/// S26-T02 package/plugin manifest.
class GeniusPdfIndustryPackManifest {
  const GeniusPdfIndustryPackManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.coreCompatibility,
    required this.templateIds,
    this.description,
    this.requiresCorePacks = const [],
    this.domainExtensions = const [],
    this.complianceHooks = const [],
    this.capabilities = const {},
  });

  final String id;
  final String name;
  final String version;
  final String? description;
  final GeniusPdfIndustryVersionRange coreCompatibility;
  final List<String> templateIds;
  final List<String> requiresCorePacks;
  final List<GeniusPdfIndustryDomainExtension> domainExtensions;
  final List<GeniusPdfIndustryComplianceHook> complianceHooks;
  final Map<String, bool> capabilities;

  void validateForCore(String coreVersion) {
    if (id.trim().isEmpty || name.trim().isEmpty) {
      throw StateError('Industry pack id/name cannot be empty.');
    }
    if (!coreCompatibility.supports(coreVersion)) {
      throw StateError(
        'Industry pack `$id` v$version is not compatible '
        'with core $coreVersion.',
      );
    }
    if (templateIds.length != templateIds.toSet().length) {
      throw StateError(
        'Industry pack `$id` contains duplicate template IDs.',
      );
    }
  }
}

/// S26-T01 package/plugin boundary.
///
/// Industry plugins expose manifests/templates and optional compliance profile
/// references only. They do not reach renderer internals.
abstract interface class GeniusPdfIndustryPack {
  GeniusPdfIndustryPackManifest get manifest;

  List<GeniusPdfTemplateSchema> templates();

  /// Optional runtime compliance profiles supplied by the host/plugin.
  ///
  /// Built-in shell packs return an empty list; jurisdiction rules must be
  /// provided explicitly by a country/tenant plugin.
  List<GeniusPdfComplianceProfile> complianceProfiles() => const [];
}

class GeniusPdfIndustryPackRegistry {
  GeniusPdfIndustryPackRegistry({
    this.coreVersion = '4.0.0',
  });

  final String coreVersion;
  final Map<String, GeniusPdfIndustryPack> _packs = {};

  void register(GeniusPdfIndustryPack pack) {
    pack.manifest.validateForCore(coreVersion);
    if (_packs.containsKey(pack.manifest.id)) {
      throw StateError(
        'Industry pack `${pack.manifest.id}` is already registered.',
      );
    }
    _packs[pack.manifest.id] = pack;
  }

  GeniusPdfIndustryPack? find(String id) => _packs[id];

  List<GeniusPdfIndustryPackManifest> get manifests =>
      List.unmodifiable([
        for (final pack in _packs.values) pack.manifest,
      ]);

  List<GeniusPdfTemplateSchema> allTemplates() =>
      List.unmodifiable([
        for (final pack in _packs.values) ...pack.templates(),
      ]);

  GeniusPdfTemplateRegistry buildTemplateRegistry() {
    final registry = GeniusPdfTemplateRegistry();
    for (final template in allTemplates()) {
      registry.register(template);
    }
    return registry;
  }
}
