
import 'compliance_profile.dart';

/// Compliance profile registry with tenant/country/version/effective-date
/// selection. No jurisdiction is built in.
class GeniusPdfComplianceRegistry {
  final List<GeniusPdfCompliancePlugin> _plugins = [];

  void register(
    GeniusPdfCompliancePlugin plugin,
  ) {
    final profile = plugin.profile;
    if (profile.id.trim().isEmpty) {
      throw ArgumentError('Compliance profile id cannot be empty.');
    }
    if (profile.version.trim().isEmpty) {
      throw ArgumentError(
        'Compliance profile version cannot be empty.',
      );
    }
    if (profile.sourceReferences.isEmpty) {
      throw ArgumentError(
        'Compliance profiles must cite implementation source references.',
      );
    }
    if (profile.effectiveTo != null &&
        profile.effectiveTo!.isBefore(profile.effectiveFrom)) {
      throw ArgumentError(
        'effectiveTo cannot precede effectiveFrom.',
      );
    }

    final duplicate = _plugins.any((item) {
      final value = item.profile;
      return value.id == profile.id &&
          value.version == profile.version &&
          value.country == profile.country &&
          value.tenant == profile.tenant &&
          value.effectiveFrom == profile.effectiveFrom;
    });
    if (duplicate) {
      throw StateError(
        'Duplicate compliance profile ${profile.id} '
        '${profile.version}.',
      );
    }
    _plugins.add(plugin);
  }

  GeniusPdfComplianceProfile? resolve({
    required DateTime at,
    String? country,
    String? tenant,
    String? id,
  }) {
    final candidates = _plugins
        .map((item) => item.profile)
        .where((profile) {
      if (id != null && profile.id != id) return false;
      if (!profile.activeAt(at)) return false;
      if (profile.country != null &&
          profile.country != country) {
        return false;
      }
      if (profile.tenant != null &&
          profile.tenant != tenant) {
        return false;
      }
      return true;
    }).toList();

    candidates.sort((a, b) {
      int score(GeniusPdfComplianceProfile profile) {
        var value = 0;
        if (profile.country != null) value += 10;
        if (profile.tenant != null) value += 100;
        return value;
      }

      final byScope = score(b).compareTo(score(a));
      if (byScope != 0) return byScope;
      return b.effectiveFrom.compareTo(a.effectiveFrom);
    });

    return candidates.isEmpty ? null : candidates.first;
  }

  List<GeniusPdfComplianceProfile> get profiles =>
      List.unmodifiable(
        _plugins.map((item) => item.profile),
      );
}
