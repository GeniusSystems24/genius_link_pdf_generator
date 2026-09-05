
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusPdfComplianceProfile profile({
  String? country,
  String? tenant,
  DateTime? effectiveFrom,
}) =>
    GeniusPdfComplianceProfile(
      id: 'compliance.demo',
      version: '2026.1',
      country: country,
      tenant: tenant,
      effectiveFrom: effectiveFrom ?? DateTime(2026, 1, 1),
      sourceReferences: const [
        'OFFICIAL-SOURCE-REFERENCE-REQUIRED-BY-IMPLEMENTER',
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
            },
      ],
    );

void main() {
  test('required-field and structured QR hooks are explicit', () {
    final value = profile();

    expect(value.validate(const {}).isValid, isFalse);
    expect(
      value.validate(
        const {'documentNumber': 'INV-1'},
      ).isValid,
      isTrue,
    );
    expect(
      value.buildQrPayloads(
        const {
          'documentNumber': 'INV-1',
          'total': 115,
        },
      ).single['documentNumber'],
      'INV-1',
    );
  });

  test('copy/reprint policy enforces reason only for reprint', () {
    const policy = GeniusPdfCopyPolicy();
    expect(
      () => policy.validate(GeniusPdfCopyKind.original),
      returnsNormally,
    );
    expect(
      () => policy.validate(GeniusPdfCopyKind.copy),
      returnsNormally,
    );
    expect(
      () => policy.validate(GeniusPdfCopyKind.reprint),
      throwsArgumentError,
    );
    expect(
      () => policy.validate(
        GeniusPdfCopyKind.reprint,
        reason: 'Customer requested duplicate',
      ),
      returnsNormally,
    );
  });

  test('business approval is separate from signing metadata', () {
    final approval = GeniusPdfBusinessApproval(
      approvalId: 'APP-1',
      approverId: 'USER-1',
      approverName: 'Manager',
      approvedAt: DateTime(2026, 9, 4),
      status: 'approved',
    );
    final signature = GeniusPdfSigningMetadata(
      signatureId: 'SIG-1',
      signerId: 'CERT-SUBJECT-1',
      signerDisplayName: 'Digital Signer',
      algorithm: 'external-provider',
      signedAt: DateTime(2026, 9, 4),
    );

    expect(approval.runtimeType, isNot(signature.runtimeType));
  });

  test('compliance registry resolves tenant over country over generic', () {
    final registry = GeniusPdfComplianceRegistry();
    registry.register(
      GeniusPdfDeclarativeCompliancePlugin(profile()),
    );
    registry.register(
      GeniusPdfDeclarativeCompliancePlugin(
        profile(country: 'XX'),
      ),
    );
    registry.register(
      GeniusPdfDeclarativeCompliancePlugin(
        profile(country: 'XX', tenant: 'TENANT-1'),
      ),
    );

    final resolved = registry.resolve(
      at: DateTime(2026, 9, 4),
      country: 'XX',
      tenant: 'TENANT-1',
    );
    expect(resolved!.tenant, 'TENANT-1');
  });

  test('enterprise security maps to existing settings without replacement', () {
    const disabled = GeniusPdfEnterpriseSecurityPolicy();
    expect(disabled.toSecuritySettings().isEncrypted, isFalse);

    const protected = GeniusPdfEnterpriseSecurityPolicy(
      enabled: true,
      ownerPassword: 'owner-password',
      permissions: GeniusPdfPermissions(
        allowPrinting: true,
        allowCopying: false,
      ),
    );
    final settings = protected.toSecuritySettings();
    expect(settings.isEncrypted, isTrue);
    expect(settings.permissions.allowCopying, isFalse);
  });

  test('archive metadata exposes capabilities without claiming PDF/A', () {
    const archive = GeniusPdfArchiveProfile(
      id: 'archive-contract',
      version: '1',
      capabilities: GeniusPdfArchiveCapabilities(
        supportsXmp: true,
        supportsEmbeddedAttachments: true,
        requiresEmbeddedFonts: true,
      ),
    );

    expect(archive.capabilities.supportsXmp, isTrue);
    expect(
      archive.capabilities.supportsEmbeddedAttachments,
      isTrue,
    );
  });

  test('country profile version/effective date is explicit', () {
    final value = profile(
      country: 'XX',
      effectiveFrom: DateTime(2026, 7, 1),
    );
    expect(value.version, '2026.1');
    expect(value.activeAt(DateTime(2026, 6, 30)), isFalse);
    expect(value.activeAt(DateTime(2026, 7, 1)), isTrue);
    expect(value.sourceReferences, isNotEmpty);
  });
}
