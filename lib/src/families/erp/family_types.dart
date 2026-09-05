
import 'family_document.dart';
import 'family_models.dart';

/// S08-T01 — generic transaction family.
///
/// S09 Quotation/PurchaseOrder/TaxInvoice extend this exact class.
class GeniusErpTransactionDocument extends GeniusErpDocumentFamily {
  GeniusErpTransactionDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.transaction,
        );
}

/// S08-T02 — generic account/customer/vendor statement family.
class GeniusErpStatementDocument extends GeniusErpDocumentFamily {
  GeniusErpStatementDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.statement,
        );
}

/// S08-T03 — generic voucher family.
class GeniusErpVoucherDocument extends GeniusErpDocumentFamily {
  GeniusErpVoucherDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.voucher,
        );
}

/// S08-T04 — generic analytical-report family.
class GeniusErpAnalyticalReport extends GeniusErpDocumentFamily {
  GeniusErpAnalyticalReport(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.analyticalReport,
        );
}

/// S08-T05 — generic operational-form family.
class GeniusErpOperationalForm extends GeniusErpDocumentFamily {
  GeniusErpOperationalForm(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.operationalForm,
        );
}

/// S08-T06 — generic register/listing family.
class GeniusErpRegisterDocument extends GeniusErpDocumentFamily {
  GeniusErpRegisterDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.register,
        );
}

/// S08-T07 — thermal-receipt structural family.
///
/// The actual standardized 58/80mm print profiles belong to S11; S08 provides
/// the family + profile hook now.
class GeniusErpThermalReceipt extends GeniusErpDocumentFamily {
  GeniusErpThermalReceipt(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.thermalReceipt,
        );
}

/// S08-T08 — label structural family.
///
/// Label-sheet/profile specialization is intentionally deferred to S11.
class GeniusErpLabelDocument extends GeniusErpDocumentFamily {
  GeniusErpLabelDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.label,
        );
}

/// S08-T09 — certificate document family.
class GeniusErpCertificateDocument extends GeniusErpDocumentFamily {
  GeniusErpCertificateDocument(
    super.config, {
    super.plan,
    super.directionality,
    super.themeOverride,
    super.printProfile,
  }) : super(
          familyKind: GeniusErpDocumentFamilyKind.certificate,
        );
}
