
import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';
import '../printing/printing.dart';
import 'compliance_models.dart';
import 'compliance_profile.dart';

/// Manual/diagnostic enterprise metadata document.
///
/// It renders metadata and compliance validation through the real PDF builder.
/// Cryptographic signing/timestamping remain integration contracts because
/// keys/certificates/HSM/remote providers are environment-specific.
class GeniusPdfComplianceDiagnosticsDocument
    extends GeniusPdfDocumentBuilder {
  GeniusPdfComplianceDiagnosticsDocument(
    GeniusPdfConfig config, {
    required this.profile,
    required this.metadata,
    required this.documentData,
  }) : super(config);

  final GeniusPdfComplianceProfile profile;
  final GeniusPdfEnterpriseDocumentMetadata metadata;
  final Map<String, Object?> documentData;

  /// Applies the shared watermark component to the underlying PDF.
  void addWatermark(GeniusPdfWatermark watermark) {
    watermark.applyToDocument(document);
  }

  @override
  void build() {
    profile.copyPolicy.validate(
      metadata.copyKind,
      reason: metadata.copyReason,
    );
    final validation = profile.validate(documentData);

    newPage();
    addLine(
      'Compliance Profile ${profile.id} v${profile.version}',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine(
      'country=${profile.country ?? '*'} '
      'tenant=${profile.tenant ?? '*'} '
      'effective=${profile.effectiveFrom.toIso8601String()}',
    );
    addLine(
      'copyKind=${metadata.copyKind.name} '
      'fingerprint=${metadata.fingerprint.fingerprint}',
    );
    addLine(
      'uuid=${metadata.fingerprint.uuid}',
    );
    addLine(
      'generated=${metadata.generation.generatedAt.toIso8601String()} '
      'generator=${metadata.generation.generatorVersion} '
      'documentVersion=${metadata.generation.documentVersion}',
    );
    addLine(
      'source=${metadata.sourceAudit.sourceSystem}/'
      '${metadata.sourceAudit.transactionType}/'
      '${metadata.sourceAudit.transactionId}',
    );
    if (metadata.documentHash != null) {
      addLine(
        'hash=${metadata.documentHash!.algorithm}:'
        '${metadata.documentHash!.value}',
      );
    }
    addLine(
      'businessApprovals=${metadata.approvals.length} '
      'cryptographicSignatures=${metadata.signatures.length} '
      'attachments=${metadata.attachments.length}',
    );
    addSpace(8);

    addLine(
      validation.isValid
          ? 'Compliance validation: PASS'
          : 'Compliance validation: FAIL',
      font: config.boldFont,
    );
    for (final issue in validation.issues) {
      addLine(issue.toString());
    }

    addSpace(8);
    addLine('Source references', font: config.boldFont);
    for (final reference in profile.sourceReferences) {
      addLine(reference);
    }

    switch (metadata.copyKind) {
      case GeniusPdfCopyKind.original:
        break;
      case GeniusPdfCopyKind.copy:
        if (profile.copyPolicy.markCopies) {
          addWatermark(
            GeniusPdfWatermark.draft(
              config: config,
              text: config.isRTL ? 'نسخة' : 'COPY',
            ),
          );
        }
        break;
      case GeniusPdfCopyKind.reprint:
        if (profile.copyPolicy.markReprints) {
          addWatermark(
            GeniusPdfWatermark.draft(
              config: config,
              text: config.isRTL ? 'إعادة طباعة' : 'REPRINT',
            ),
          );
        }
        break;
    }
  }
}
