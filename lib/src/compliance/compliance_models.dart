
import '../printing/profiles/print_profile.dart' show GeniusPdfCopyKind;

/// S23-T05 original/copy/reprint policy.
class GeniusPdfCopyPolicy {
  const GeniusPdfCopyPolicy({
    this.allowCopy = true,
    this.allowReprint = true,
    this.markCopies = true,
    this.markReprints = true,
    this.requireReasonForReprint = true,
  });

  final bool allowCopy;
  final bool allowReprint;
  final bool markCopies;
  final bool markReprints;
  final bool requireReasonForReprint;

  void validate(
    GeniusPdfCopyKind kind, {
    String? reason,
  }) {
    if (kind == GeniusPdfCopyKind.copy && !allowCopy) {
      throw StateError('Copy generation is disabled by policy.');
    }
    if (kind == GeniusPdfCopyKind.reprint && !allowReprint) {
      throw StateError('Reprint generation is disabled by policy.');
    }
    if (kind == GeniusPdfCopyKind.reprint &&
        requireReasonForReprint &&
        (reason == null || reason.trim().isEmpty)) {
      throw ArgumentError(
        'A reprint reason is required by policy.',
      );
    }
  }
}

/// S23-T06 business approval is deliberately not a cryptographic signature.
class GeniusPdfBusinessApproval {
  const GeniusPdfBusinessApproval({
    required this.approvalId,
    required this.approverId,
    required this.approverName,
    required this.approvedAt,
    required this.status,
    this.approverNameAr,
    this.role,
    this.roleAr,
    this.comment,
    this.commentAr,
  });

  final String approvalId;
  final String approverId;
  final String approverName;
  final String? approverNameAr;
  final String? role;
  final String? roleAr;
  final DateTime approvedAt;
  final String status;
  final String? comment;
  final String? commentAr;
}

/// S23-T07 signing metadata. It describes a cryptographic signing operation;
/// it does not claim that a business approval itself is a signature.
class GeniusPdfSigningMetadata {
  const GeniusPdfSigningMetadata({
    required this.signatureId,
    required this.signerId,
    required this.signerDisplayName,
    required this.algorithm,
    required this.signedAt,
    this.certificateSubject,
    this.certificateIssuer,
    this.certificateSerialNumber,
    this.certificateThumbprint,
    this.timestampAuthority,
    this.timestampTokenReference,
  });

  final String signatureId;
  final String signerId;
  final String signerDisplayName;
  final String algorithm;
  final DateTime signedAt;
  final String? certificateSubject;
  final String? certificateIssuer;
  final String? certificateSerialNumber;
  final String? certificateThumbprint;
  final String? timestampAuthority;
  final String? timestampTokenReference;
}

/// S23-T08 certificate-signature integration boundary.
///
/// Implementations live outside the base compliance layer so private keys,
/// HSMs, OS certificate stores, remote signing services and vendors are not
/// hard-coded into templates.
abstract interface class GeniusPdfCertificateSignatureProvider {
  Future<GeniusPdfSigningMetadata> sign({
    required List<int> documentBytes,
    required String documentFingerprint,
    Map<String, Object?> metadata = const {},
  });
}

/// S23-T09 timestamp integration boundary.
abstract interface class GeniusPdfTimestampProvider {
  Future<GeniusPdfTimestampResult> timestamp({
    required String hashAlgorithm,
    required String documentHash,
  });
}

class GeniusPdfTimestampResult {
  const GeniusPdfTimestampResult({
    required this.authority,
    required this.timestamp,
    required this.tokenReference,
  });

  final String authority;
  final DateTime timestamp;
  final String tokenReference;
}

/// S23-T10 document hash metadata. Hash computation is supplied by a
/// cryptographic provider rather than a weak built-in placeholder.
class GeniusPdfDocumentHashMetadata {
  const GeniusPdfDocumentHashMetadata({
    required this.algorithm,
    required this.value,
  });

  final String algorithm;
  final String value;
}

abstract interface class GeniusPdfDocumentHashProvider {
  Future<GeniusPdfDocumentHashMetadata> hash(
    List<int> documentBytes,
  );
}

/// S23-T11 UUID/document fingerprint metadata.
class GeniusPdfDocumentFingerprint {
  const GeniusPdfDocumentFingerprint({
    required this.uuid,
    required this.fingerprint,
  });

  final String uuid;
  final String fingerprint;
}

abstract interface class GeniusPdfFingerprintProvider {
  Future<GeniusPdfDocumentFingerprint> create({
    required String documentType,
    required String sourceReference,
    required DateTime generatedAt,
  });
}

/// S23-T12 renderer-neutral XMP metadata abstraction.
class GeniusPdfXmpMetadata {
  const GeniusPdfXmpMetadata({
    this.title,
    this.author,
    this.subject,
    this.keywords = const [],
    this.language,
    this.documentId,
    this.instanceId,
    this.custom = const {},
  });

  final String? title;
  final String? author;
  final String? subject;
  final List<String> keywords;
  final String? language;
  final String? documentId;
  final String? instanceId;
  final Map<String, String> custom;
}

/// S23-T13 embedded-attachment request/hook data.
class GeniusPdfEmbeddedAttachment {
  const GeniusPdfEmbeddedAttachment({
    required this.name,
    required this.mediaType,
    required this.bytesProviderKey,
    this.description,
    this.relationship = 'Data',
  });

  final String name;
  final String mediaType;

  /// Logical lookup key. The profile never serializes file bytes/provider
  /// objects into the template/compliance definition.
  final String bytesProviderKey;

  final String? description;
  final String relationship;
}

abstract interface class GeniusPdfAttachmentBytesProvider {
  Future<List<int>> load(String key);
}

/// S23-T14 archive profile capability flags.
class GeniusPdfArchiveCapabilities {
  const GeniusPdfArchiveCapabilities({
    this.supportsXmp = false,
    this.supportsEmbeddedAttachments = false,
    this.requiresEmbeddedFonts = false,
    this.requiresColorProfile = false,
    this.supportsEncryption = true,
    this.supportsDigitalSignatures = true,
  });

  final bool supportsXmp;
  final bool supportsEmbeddedAttachments;
  final bool requiresEmbeddedFonts;
  final bool requiresColorProfile;
  final bool supportsEncryption;
  final bool supportsDigitalSignatures;
}

class GeniusPdfArchiveProfile {
  const GeniusPdfArchiveProfile({
    required this.id,
    required this.version,
    required this.capabilities,
    this.description,
  });

  final String id;
  final String version;
  final GeniusPdfArchiveCapabilities capabilities;
  final String? description;
}

/// S23-T15 source transaction/audit metadata.
class GeniusPdfSourceAuditMetadata {
  const GeniusPdfSourceAuditMetadata({
    required this.sourceSystem,
    required this.transactionType,
    required this.transactionId,
    required this.eventId,
    this.userId,
    this.correlationId,
    this.revision,
    this.extra = const {},
  });

  final String sourceSystem;
  final String transactionType;
  final String transactionId;
  final String eventId;
  final String? userId;
  final String? correlationId;
  final String? revision;
  final Map<String, String> extra;
}

/// S23-T16 generation timestamp/version.
class GeniusPdfGenerationMetadata {
  const GeniusPdfGenerationMetadata({
    required this.generatedAt,
    required this.generatorVersion,
    required this.documentVersion,
    this.schemaVersion,
    this.templateId,
    this.templateVersion,
  });

  final DateTime generatedAt;
  final String generatorVersion;
  final String documentVersion;
  final int? schemaVersion;
  final String? templateId;
  final int? templateVersion;
}

/// Combined metadata envelope used by archival/compliance integrations.
class GeniusPdfEnterpriseDocumentMetadata {
  const GeniusPdfEnterpriseDocumentMetadata({
    required this.generation,
    required this.sourceAudit,
    required this.fingerprint,
    this.documentHash,
    this.xmp,
    this.approvals = const [],
    this.signatures = const [],
    this.attachments = const [],
    this.copyKind = GeniusPdfCopyKind.original,
    this.copyReason,
  });

  final GeniusPdfGenerationMetadata generation;
  final GeniusPdfSourceAuditMetadata sourceAudit;
  final GeniusPdfDocumentFingerprint fingerprint;
  final GeniusPdfDocumentHashMetadata? documentHash;
  final GeniusPdfXmpMetadata? xmp;
  final List<GeniusPdfBusinessApproval> approvals;
  final List<GeniusPdfSigningMetadata> signatures;
  final List<GeniusPdfEmbeddedAttachment> attachments;
  final GeniusPdfCopyKind copyKind;
  final String? copyReason;
}
