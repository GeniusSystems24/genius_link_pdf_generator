
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../presentation/document/components/models/security_models.dart';
import '../document_operations/pdf_security_service.dart';

/// S23-T17 high-level enterprise security policy.
///
/// This maps directly to the existing GeniusPdfSecuritySettings and delegates
/// application to GeniusPdfSecurityService. It does not replace or fork the
/// current security implementation.
class GeniusPdfEnterpriseSecurityPolicy {
  const GeniusPdfEnterpriseSecurityPolicy({
    this.enabled = false,
    this.userPassword,
    this.ownerPassword,
    this.encryptionLevel = GeniusPdfEncryptionLevel.aes256,
    this.permissions = const GeniusPdfPermissions(),
    this.encryptMetadata = true,
  });

  final bool enabled;
  final String? userPassword;
  final String? ownerPassword;
  final GeniusPdfEncryptionLevel encryptionLevel;
  final GeniusPdfPermissions permissions;
  final bool encryptMetadata;

  GeniusPdfSecuritySettings toSecuritySettings() {
    if (!enabled) {
      return const GeniusPdfSecuritySettings();
    }
    if ((userPassword == null || userPassword!.isEmpty) &&
        (ownerPassword == null || ownerPassword!.isEmpty)) {
      throw StateError(
        'Enabled enterprise security requires a user or owner password.',
      );
    }
    return GeniusPdfSecuritySettings(
      userPassword: userPassword,
      ownerPassword: ownerPassword,
      encryptionLevel: encryptionLevel,
      permissions: permissions,
      encryptMetadata: encryptMetadata,
    );
  }

  /// S23-T18 keeps the current service as the execution path.
  void apply(PdfDocument document) {
    if (!enabled) return;
    GeniusPdfSecurityService.applySecurity(
      document,
      toSecuritySettings(),
    );
  }
}
