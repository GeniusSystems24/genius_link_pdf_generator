
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S23Scenario {
  original,
  copy,
  reprint,
  missingRequiredField,
  countryTenantFallback,
  securityPolicy,
  archiveMetadata,
}

class S23ComplianceSigningArchivalVerificationPage
    extends StatefulWidget {
  const S23ComplianceSigningArchivalVerificationPage({
    super.key,
  });

  @override
  State<S23ComplianceSigningArchivalVerificationPage>
      createState() =>
          _S23ComplianceSigningArchivalVerificationPageState();
}

class _S23ComplianceSigningArchivalVerificationPageState
    extends State<S23ComplianceSigningArchivalVerificationPage> {
  _S23Scenario _scenario = _S23Scenario.original;
  bool _rtl = false;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(_S23Scenario value) => switch (value) {
        _S23Scenario.original => 'Original',
        _S23Scenario.copy => 'Copy',
        _S23Scenario.reprint => 'Reprint',
        _S23Scenario.missingRequiredField => 'Required-field Failure',
        _S23Scenario.countryTenantFallback => 'Country / Tenant Registry',
        _S23Scenario.securityPolicy => 'Existing Security Adapter',
        _S23Scenario.archiveMetadata => 'Archive / Audit Metadata',
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

  Future<Uint8List> _generate() async {
    var profile = _profile();
    var kind = GeniusPdfCopyKind.original;
    final data = <String, Object?>{
      'documentNumber': 'INV-LATIN-2026-001',
      'total': 1150,
      'currency': 'SAR',
      'customer': _rtl ? 'عميل عربي' : 'English Customer',
    };

    switch (_scenario) {
      case _S23Scenario.original:
        kind = GeniusPdfCopyKind.original;
        break;
      case _S23Scenario.copy:
        kind = GeniusPdfCopyKind.copy;
        break;
      case _S23Scenario.reprint:
        kind = GeniusPdfCopyKind.reprint;
        break;
      case _S23Scenario.missingRequiredField:
        data.remove('documentNumber');
        break;
      case _S23Scenario.countryTenantFallback:
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
      case _S23Scenario.securityPolicy:
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
      case _S23Scenario.archiveMetadata:
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

  void _refresh() {
    setState(() => _pdf = _generate());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S23 — Compliance, Signing, Audit & Archival',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<_S23Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S23Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's23_compliance_signing_archival.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                  const SizedBox(height: 8),
                  const Text(
                    'Legal note: jurisdiction-specific rules are not '
                    'hard-coded here. Implementing plugins must be reviewed '
                    'against official sources when deployed or updated.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
