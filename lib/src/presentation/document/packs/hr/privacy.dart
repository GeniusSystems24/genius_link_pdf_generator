
import '../shared/erp_pack_shared.dart';
import 'models.dart';

/// Variant context supplied to role-specific printable hooks.
class GeniusHrPrintableVariantContext {
  const GeniusHrPrintableVariantContext({
    required this.role,
    required this.policy,
  });

  final GeniusHrPrintableRole role;
  final GeniusHrPrintPolicy policy;
}

/// Role hook invoked after a report is prepared and before PDF rendering.
typedef GeniusHrPrintableVariantHook = GeniusErpPackReportData Function(
  GeniusErpPackReportData report,
  GeniusHrPrintableVariantContext context,
);

/// S17 privacy/security policy.
///
/// Visibility, masking, watermark/confidential marker and role variants are
/// explicit and opt-in. The service never silently exposes a field that is not
/// in [visibleFields] when a restrictive set is supplied.
class GeniusHrPrintPolicy {
  const GeniusHrPrintPolicy({
    this.role = GeniusHrPrintableRole.hr,
    this.visibleFields = const {},
    this.maskedFields = const {
      GeniusHrField.nationalId,
      GeniusHrField.passport,
      GeniusHrField.bankAccount,
      GeniusHrField.iban,
    },
    this.maskKeepLast = 4,
    this.confidential = true,
    this.watermarkText,
    this.watermarkTextAr,
    this.variantHooks = const {},
  }) : assert(maskKeepLast >= 0);

  final GeniusHrPrintableRole role;

  /// Empty means "use role defaults". Non-empty means explicit allow-list.
  final Set<GeniusHrField> visibleFields;
  final Set<GeniusHrField> maskedFields;
  final int maskKeepLast;
  final bool confidential;
  final String? watermarkText;
  final String? watermarkTextAr;
  final Map<GeniusHrPrintableRole, GeniusHrPrintableVariantHook> variantHooks;

  bool isVisible(GeniusHrField field) {
    if (visibleFields.isNotEmpty) {
      return visibleFields.contains(field);
    }

    return switch (role) {
      GeniusHrPrintableRole.employee => !{
          GeniusHrField.bankAccount,
          GeniusHrField.loanBalance,
        }.contains(field),
      GeniusHrPrintableRole.manager => !{
          GeniusHrField.bankAccount,
          GeniusHrField.iban,
          GeniusHrField.loanBalance,
        }.contains(field),
      GeniusHrPrintableRole.hr => true,
      GeniusHrPrintableRole.payroll => true,
      GeniusHrPrintableRole.auditor => true,
    };
  }

  String? protect(
    GeniusHrField field,
    String? value,
  ) {
    if (!isVisible(field)) return null;
    if (value == null || value.isEmpty) return value;
    if (!maskedFields.contains(field)) return value;
    return maskIdentifier(value, keepLast: maskKeepLast);
  }

  GeniusErpPackReportData applyVariant(
    GeniusErpPackReportData report,
  ) {
    final hook = variantHooks[role];
    if (hook == null) return report;
    return hook(
      report,
      GeniusHrPrintableVariantContext(
        role: role,
        policy: this,
      ),
    );
  }

  static String maskIdentifier(
    String value, {
    int keepLast = 4,
  }) {
    if (value.isEmpty) return value;
    if (keepLast <= 0) {
      return List.filled(value.length, '•').join();
    }
    if (value.length <= keepLast) {
      return List.filled(value.length, '•').join();
    }

    final visible = value.substring(value.length - keepLast);
    final hidden = List.filled(value.length - keepLast, '•').join();
    return '$hidden$visible';
  }
}
