
import 'compliance_models.dart';

class GeniusPdfComplianceIssue {
  const GeniusPdfComplianceIssue({
    required this.code,
    required this.field,
    required this.message,
  });

  final String code;
  final String field;
  final String message;

  @override
  String toString() => '$field: $message [$code]';
}

class GeniusPdfComplianceValidationResult {
  const GeniusPdfComplianceValidationResult(this.issues);

  final List<GeniusPdfComplianceIssue> issues;
  bool get isValid => issues.isEmpty;
}

typedef GeniusPdfComplianceRequiredFieldHook =
    List<GeniusPdfComplianceIssue> Function(
      Map<String, Object?> document,
    );

typedef GeniusPdfStructuredQrPayloadHook =
    Map<String, Object?> Function(
      Map<String, Object?> document,
    );

/// S23-T01 compliance abstraction.
///
/// The base package defines hooks and lifecycle metadata only. Jurisdiction
/// rules belong to explicit country/tenant plugins.
class GeniusPdfComplianceProfile {
  const GeniusPdfComplianceProfile({
    required this.id,
    required this.version,
    required this.effectiveFrom,
    required this.sourceReferences,
    this.country,
    this.tenant,
    this.effectiveTo,
    this.requiredFieldHooks = const [],
    this.qrPayloadHooks = const [],
    this.copyPolicy = const GeniusPdfCopyPolicy(),
    this.archiveProfile,
    this.securityPolicyId,
    this.metadata = const {},
  });

  final String id;

  /// Profile/ruleset version, independent from package version.
  final String version;

  final String? country;
  final String? tenant;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  /// Official/legal/contractual source references used by the implementing
  /// plugin. They must be reviewed and updated by implementers when rules
  /// change; the base package cannot guarantee current jurisdiction law.
  final List<String> sourceReferences;

  final List<GeniusPdfComplianceRequiredFieldHook>
      requiredFieldHooks;
  final List<GeniusPdfStructuredQrPayloadHook> qrPayloadHooks;
  final GeniusPdfCopyPolicy copyPolicy;
  final GeniusPdfArchiveProfile? archiveProfile;
  final String? securityPolicyId;
  final Map<String, String> metadata;

  bool activeAt(DateTime value) {
    if (value.isBefore(effectiveFrom)) return false;
    if (effectiveTo != null && value.isAfter(effectiveTo!)) {
      return false;
    }
    return true;
  }

  GeniusPdfComplianceValidationResult validate(
    Map<String, Object?> document,
  ) {
    final issues = <GeniusPdfComplianceIssue>[];
    for (final hook in requiredFieldHooks) {
      issues.addAll(hook(document));
    }
    return GeniusPdfComplianceValidationResult(
      List.unmodifiable(issues),
    );
  }

  List<Map<String, Object?>> buildQrPayloads(
    Map<String, Object?> document,
  ) =>
      [
        for (final hook in qrPayloadHooks)
          Map.unmodifiable(hook(document)),
      ];
}

/// S23-T02/T20 country/tenant plugin contract.
///
/// A plugin supplies a profile; the core package contains no country tax law,
/// invoice mandate, QR law, signature mandate or retention period.
abstract interface class GeniusPdfCompliancePlugin {
  GeniusPdfComplianceProfile get profile;
}

class GeniusPdfDeclarativeCompliancePlugin
    implements GeniusPdfCompliancePlugin {
  const GeniusPdfDeclarativeCompliancePlugin(this.profile);

  @override
  final GeniusPdfComplianceProfile profile;
}
