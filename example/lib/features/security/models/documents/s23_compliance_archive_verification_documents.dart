// Generated from the former aggregate verification page.
// The runner contains generation logic only; presentation lives in
// focused example screens.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S23ComplianceSigningArchivalVerificationPage.
enum S23ComplianceSigningArchivalScenario {
  original,
  copy,
  reprint,
  missingRequiredField,
  countryTenantFallback,
  securityPolicy,
  archiveMetadata,
}

/// Executes one focused S23 verification scenario.
class S23ComplianceSigningArchivalRunner {
  S23ComplianceSigningArchivalRunner({
    required GeniusPdfConfig baseConfig,
    required S23ComplianceSigningArchivalScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S23ComplianceSigningArchivalScenario _scenario;
bool _rtl = false;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S23ComplianceSigningArchivalScenario value) => switch (value) {
        S23ComplianceSigningArchivalScenario.original => 'Original',
        S23ComplianceSigningArchivalScenario.copy => 'Copy',
        S23ComplianceSigningArchivalScenario.reprint => 'Reprint',
        S23ComplianceSigningArchivalScenario.missingRequiredField => 'Required-field Failure',
        S23ComplianceSigningArchivalScenario.countryTenantFallback => 'Country / Tenant Registry',
        S23ComplianceSigningArchivalScenario.securityPolicy => 'Existing Security Adapter',
        S23ComplianceSigningArchivalScenario.archiveMetadata => 'Archive / Audit Metadata',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses S23 public contracts in '
      '${_rtl ? 'RTL' : 'LTR'}. Compliance validation is explicit, copy/'
      'reprint marks follow policy, business approvals stay separate from '
      'cryptographic signatures, and no page claims a country law or a '
      'digital signature that was not supplied by an external provider.';

  GeniusPdfComplianceProfile _profile({
    String? country,
    String? tenant,
  }) =>
      GeniusPdfComplianceProfile(
        id: 'demo.enterprise.compliance',
        version: '2026.1',
        country: country,
        tenant: tenant,
        effectiveFrom: DateTime(2026, 1, 1),
        sourceReferences: const [
          'OFFICIAL-SOURCE-REFERENCE-MUST-BE-MAINTAINED-BY-PLUGIN',
        ],
        requiredFieldHooks: [
          (document) => document['documentNumber'] == null
              ? const [
                  GeniusPdfComplianceIssue(
                    code: 'required',
                    field: 'documentNumber',
                    message: 'Document number is required.',
                  ),
                ]
              : const [],
        ],
        qrPayloadHooks: [
          (document) => {
                'documentNumber': document['documentNumber'],
                'total': document['total'],
                'currency': document['currency'],
              },
        ],
        copyPolicy: const GeniusPdfCopyPolicy(),
        archiveProfile: const GeniusPdfArchiveProfile(
          id: 'demo-archive-capabilities',
          version: '1',
          capabilities: GeniusPdfArchiveCapabilities(
            supportsXmp: true,
            supportsEmbeddedAttachments: true,
            requiresEmbeddedFonts: true,
            supportsEncryption: false,
          ),
        ),
        securityPolicyId: 'enterprise-read-only',
      );

  GeniusPdfEnterpriseDocumentMetadata _metadata(
    GeniusPdfCopyKind kind,
  ) =>
      GeniusPdfEnterpriseDocumentMetadata(
        generation: GeniusPdfGenerationMetadata(
          generatedAt: DateTime(2026, 9, 4, 12),
          generatorVersion: '4.0.0',
          documentVersion: '1',
          schemaVersion: 2,
          templateId: 'demo.invoice',
          templateVersion: 2,
        ),
        sourceAudit: const GeniusPdfSourceAuditMetadata(
          sourceSystem: 'ERP',
          transactionType: 'invoice',
          transactionId: 'INV-LATIN-2026-001',
          eventId: 'AUDIT-0001',
          userId: 'USER-001',
          correlationId: 'CORR-001',
        ),
        fingerprint: const GeniusPdfDocumentFingerprint(
          uuid: '550e8400-e29b-41d4-a716-446655440000',
          fingerprint: 'FP-LATIN-DEMO-001',
        ),
        documentHash: const GeniusPdfDocumentHashMetadata(
          algorithm: 'EXTERNAL-SHA-256',
          value: 'HASH-SUPPLIED-BY-EXTERNAL-PROVIDER',
        ),
        xmp: const GeniusPdfXmpMetadata(
          title: 'ERP Compliance Verification',
          author: 'Genius Link PDF Generator',
          language: 'ar-SA/en-US',
          documentId: 'INV-LATIN-2026-001',
        ),
        approvals: [
          GeniusPdfBusinessApproval(
            approvalId: 'APP-001',
            approverId: 'USER-MGR-01',
            approverName: 'Finance Manager',
            approverNameAr: 'مدير المالية',
            approvedAt: DateTime(2026, 9, 4, 10),
            status: 'approved',
          ),
        ],
        signatures: [
          GeniusPdfSigningMetadata(
            signatureId: 'SIG-META-001',
            signerId: 'CERT-SUBJECT-001',
            signerDisplayName: 'External Digital Signer',
            algorithm: 'external-provider',
            signedAt: DateTime(2026, 9, 4, 11),
            certificateSubject: 'CN=DEMO',
            certificateIssuer: 'External CA',
            timestampAuthority: 'External TSA',
            timestampTokenReference: 'TST-001',
          ),
        ],
        attachments: const [
          GeniusPdfEmbeddedAttachment(
            name: 'source.xml',
            mediaType: 'application/xml',
            bytesProviderKey: 'attachment/source.xml',
            description: 'Source transaction payload reference',
          ),
        ],
        copyKind: kind,
        copyReason: kind == GeniusPdfCopyKind.reprint
            ? 'Manual verification reprint'
            : null,
      );

  Future<Uint8List> generate() async {
    var profile = _profile();
    var kind = GeniusPdfCopyKind.original;
    final data = <String, Object?>{
      'documentNumber': 'INV-LATIN-2026-001',
      'total': 1150,
      'currency': 'SAR',
      'customer': _rtl ? 'عميل عربي' : 'English Customer',
    };

    switch (_scenario) {
      case S23ComplianceSigningArchivalScenario.original:
        kind = GeniusPdfCopyKind.original;
        break;
      case S23ComplianceSigningArchivalScenario.copy:
        kind = GeniusPdfCopyKind.copy;
        break;
      case S23ComplianceSigningArchivalScenario.reprint:
        kind = GeniusPdfCopyKind.reprint;
        break;
      case S23ComplianceSigningArchivalScenario.missingRequiredField:
        data.remove('documentNumber');
        break;
      case S23ComplianceSigningArchivalScenario.countryTenantFallback:
        final registry = GeniusPdfComplianceRegistry();
        registry.register(
          GeniusPdfDeclarativeCompliancePlugin(
            _profile(),
          ),
        );
        registry.register(
          GeniusPdfDeclarativeCompliancePlugin(
            _profile(country: 'XX'),
          ),
        );
        registry.register(
          GeniusPdfDeclarativeCompliancePlugin(
            _profile(country: 'XX', tenant: 'TENANT-1'),
          ),
        );
        profile = registry.resolve(
              at: DateTime(2026, 9, 4),
              country: 'XX',
              tenant: 'TENANT-1',
            ) ??
            profile;
        data['resolvedScope'] =
            '${profile.country}/${profile.tenant}';
        break;
      case S23ComplianceSigningArchivalScenario.securityPolicy:
        const security = GeniusPdfEnterpriseSecurityPolicy(
          enabled: true,
          ownerPassword: 'owner-password',
          permissions: GeniusPdfPermissions(
            allowPrinting: true,
            allowCopying: false,
            allowModifying: false,
          ),
        );
        final settings = security.toSecuritySettings();
        data['security'] =
            'encrypted=${settings.isEncrypted}; '
            'copy=${settings.permissions.allowCopying}; '
            'modify=${settings.permissions.allowModifying}';
        break;
      case S23ComplianceSigningArchivalScenario.archiveMetadata:
        data['archive'] =
            'xmp=${profile.archiveProfile?.capabilities.supportsXmp}; '
            'attachments=${profile.archiveProfile?.capabilities.supportsEmbeddedAttachments}; '
            'embeddedFonts=${profile.archiveProfile?.capabilities.requiresEmbeddedFonts}';
        break;
    }

    final document = GeniusPdfComplianceDiagnosticsDocument(
      _config,
      profile: profile,
      metadata: _metadata(kind),
      documentData: data,
    );
    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }
}

Future<Uint8List> buildS23OriginalVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.original,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23CopyVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.copy,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23ReprintVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.reprint,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23MissingRequiredFieldVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.missingRequiredField,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23CountryTenantFallbackVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.countryTenantFallback,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23SecurityPolicyVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.securityPolicy,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS23ArchiveMetadataVerificationPdf(GeniusPdfConfig config) {
  final runner = S23ComplianceSigningArchivalRunner(
    baseConfig: config,
    scenario: S23ComplianceSigningArchivalScenario.archiveMetadata,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
