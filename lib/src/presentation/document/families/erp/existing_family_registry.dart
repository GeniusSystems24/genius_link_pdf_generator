
import '../../builders/pdf_document_builder.dart';
import 'family_models.dart';

/// Immutable mapping between a public template type and its S08 ERP family.
class GeniusErpExistingTemplateFamilyRegistration {
  const GeniusErpExistingTemplateFamilyRegistration({
    required this.templateType,
    required this.familyKind,
    required this.sprint,
    this.notes,
  });

  final String templateType;
  final GeniusErpDocumentFamilyKind familyKind;
  final String sprint;
  final String? notes;
}

/// Central family map for all package-owned business templates.
///
/// S10 uses this registry as the audit source for the "no current template
/// outside a family" invariant. The actual template classes also inherit the
/// mapped S08 family; this registry is not a substitute for inheritance.
class GeniusErpExistingTemplateFamilyRegistry {
  const GeniusErpExistingTemplateFamilyRegistry._();

  static const List<GeniusErpExistingTemplateFamilyRegistration> all = [
    // S09 transaction migration.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'QuotationTemplate',
      familyKind: GeniusErpDocumentFamilyKind.transaction,
      sprint: 'S09',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'PurchaseOrderTemplate',
      familyKind: GeniusErpDocumentFamilyKind.transaction,
      sprint: 'S09',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'TaxInvoiceTemplate',
      familyKind: GeniusErpDocumentFamilyKind.transaction,
      sprint: 'S09',
    ),

    // S10 financial reports.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'BalanceSheetTemplate',
      familyKind: GeniusErpDocumentFamilyKind.analyticalReport,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'BudgetReportTemplate',
      familyKind: GeniusErpDocumentFamilyKind.analyticalReport,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'CashFlowTemplate',
      familyKind: GeniusErpDocumentFamilyKind.analyticalReport,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'IncomeStatementTemplate',
      familyKind: GeniusErpDocumentFamilyKind.analyticalReport,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'TrialBalanceTemplate',
      familyKind: GeniusErpDocumentFamilyKind.register,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'CustomerStatementTemplate',
      familyKind: GeniusErpDocumentFamilyKind.statement,
      sprint: 'S10',
    ),

    // S10 HR / operational.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'AttendanceReportTemplate',
      familyKind: GeniusErpDocumentFamilyKind.register,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'EmployeeReportTemplate',
      familyKind: GeniusErpDocumentFamilyKind.register,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'LeaveReportTemplate',
      familyKind: GeniusErpDocumentFamilyKind.register,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'PayslipTemplate',
      familyKind: GeniusErpDocumentFamilyKind.operationalForm,
      sprint: 'S10',
    ),

    // S10 inventory / delivery.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'InventoryReportTemplate',
      familyKind: GeniusErpDocumentFamilyKind.register,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'DeliveryNoteTemplate',
      familyKind: GeniusErpDocumentFamilyKind.operationalForm,
      sprint: 'S10',
    ),

    // Current credit/debit note convenience template.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'CreditNoteTemplate',
      familyKind: GeniusErpDocumentFamilyKind.transaction,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'DebitNoteTemplate',
      familyKind: GeniusErpDocumentFamilyKind.transaction,
      sprint: 'S10',
      notes: 'typedef of CreditNoteTemplate',
    ),

    // Voucher family. All concrete voucher classes inherit
    // GeniusPdfVoucherTemplate -> GeniusErpVoucherDocument.
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'AccountingEntryVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'BankDepositVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'BankWithdrawalVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'BillPaymentVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'GiftVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'InventoryVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'ModernVoucherTemplate',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
      notes: 'abstract modern voucher convenience base',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'PaymentVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'PurchaseReturnVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'PurchaseVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'ReceiptVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'RemittanceIncomingVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'RemittanceOutgoingVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'SalesReturnVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'SalesVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'TaxVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
    GeniusErpExistingTemplateFamilyRegistration(
      templateType: 'TransferVoucher',
      familyKind: GeniusErpDocumentFamilyKind.voucher,
      sprint: 'S10',
    ),
  ];

  static GeniusErpExistingTemplateFamilyRegistration? forTypeName(
    String templateType,
  ) {
    for (final registration in all) {
      if (registration.templateType == templateType) {
        return registration;
      }
    }
    return null;
  }

  static GeniusErpDocumentFamilyKind? kindForTypeName(
    String templateType,
  ) =>
      forTypeName(templateType)?.familyKind;

  static GeniusErpDocumentFamilyKind? kindForBuilder(
    GeniusPdfDocumentBuilder builder,
  ) =>
      kindForTypeName(builder.runtimeType.toString());

  static List<GeniusErpExistingTemplateFamilyRegistration> byFamily(
    GeniusErpDocumentFamilyKind family,
  ) =>
      all
          .where((registration) => registration.familyKind == family)
          .toList(growable: false);

  /// Returns true when every [templateTypes] entry is present in this map.
  static bool coversAll(Iterable<String> templateTypes) =>
      templateTypes.every((name) => forTypeName(name) != null);
}
