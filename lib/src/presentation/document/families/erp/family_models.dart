
import '../../components/components.dart';
import '../../../../core/directionality.dart';
import '../../../../core/pdf_config.dart';
import '../../../../domain/erp/erp.dart';
import '../../../../domain/models/pdf_image.dart';

/// S08 document-family categories.
enum GeniusErpDocumentFamilyKind {
  transaction,
  statement,
  voucher,
  analyticalReport,
  operationalForm,
  register,
  thermalReceipt,
  label,
  certificate,
}

/// Standard reusable slots shared by S08 families.
enum GeniusErpFamilySlot {
  header,
  identity,
  parties,
  references,
  body,
  summary,
  notesTerms,
  approvalsSignatures,
  attachmentsCodes,
  footer,
}

/// Page-flow behavior for a family slot.
enum GeniusErpSlotBreakPolicy {
  /// Render in the current flow; break only when the family knows a minimum
  /// estimated height cannot fit.
  auto,

  /// Force a new page before this slot.
  pageBefore,

  /// Keep the slot together when its estimated height cannot fit.
  keepTogether,

  /// Do not perform pre-render page-break checks.
  none,
}

/// Placement of a custom section relative to a standard slot.
enum GeniusErpCustomSectionPosition {
  before,
  after,
}

/// Logical page variant known to family rendering.
enum GeniusErpPageVariant {
  first,
  middle,
  last,
  single,
}

/// Code type for the shared attachments/codes slot.
enum GeniusErpCodeKind {
  qr,
  barcode,
}

/// Hook phase that never exposes PdfPage/PdfGraphics internals.
enum GeniusErpFamilyHookPhase {
  beforeDocument,
  afterDocument,
  beforeSlot,
  afterSlot,
}

/// One module-neutral print profile.
///
/// A profile can alter page size, orientation, margins or other package config
/// before the family is built. S11 can add the package's standardized profile
/// catalog without changing the S08 hook contract.
class GeniusErpPrintProfile {
  const GeniusErpPrintProfile({
    required this.id,
    required this.apply,
    this.description,
  });

  final String id;
  final String? description;
  final GeniusPdfConfig Function(GeniusPdfConfig config) apply;
}

/// Page-break/direction policy for one slot.
class GeniusErpSlotPolicy {
  const GeniusErpSlotPolicy({
    this.breakPolicy = GeniusErpSlotBreakPolicy.auto,
    this.direction = GeniusPdfDirection.auto,
    this.estimatedHeight = 80,
    this.spacingAfter = 10,
  })  : assert(estimatedHeight >= 0),
        assert(spacingAfter >= 0);

  final GeniusErpSlotBreakPolicy breakPolicy;

  /// Slot-level direction override. `auto` inherits the family/document.
  final GeniusPdfDirection direction;

  /// Minimum planning estimate used only for pre-break decisions.
  final double estimatedHeight;

  /// Applied only when a slot actually renders.
  final double spacingAfter;
}

/// Immutable metadata delivered to before/after hooks.
///
/// The context deliberately contains no PdfPage/PdfGraphics/renderer object.
class GeniusErpFamilyHookContext {
  const GeniusErpFamilyHookContext({
    required this.familyKind,
    required this.phase,
    required this.document,
    required this.calculation,
    this.slot,
    required this.pageIndex,
  });

  final GeniusErpDocumentFamilyKind familyKind;
  final GeniusErpFamilyHookPhase phase;
  final ErpDocumentContext document;
  final ErpCalculationResult? calculation;
  final GeniusErpFamilySlot? slot;
  final int pageIndex;
}

typedef GeniusErpFamilyHook = void Function(
  GeniusErpFamilyHookContext context,
);

/// Context passed to custom/replacement component factories.
///
/// It exposes package-level domain/config/direction contracts only.
class GeniusErpFamilyComponentContext {
  const GeniusErpFamilyComponentContext({
    required this.familyKind,
    required this.slot,
    required this.config,
    required this.directionality,
    required this.document,
    required this.calculation,
  });

  final GeniusErpDocumentFamilyKind familyKind;
  final GeniusErpFamilySlot slot;
  final GeniusPdfConfig config;
  final GeniusPdfDirectionality directionality;
  final ErpDocumentContext document;
  final ErpCalculationResult? calculation;
}

typedef GeniusErpSlotComponentFactory = GeniusPdfErpComponent? Function(
  GeniusErpFamilyComponentContext context,
);

/// Custom section inserted before/after a standard slot.
class GeniusErpCustomSection {
  const GeniusErpCustomSection({
    required this.id,
    required this.slot,
    required this.position,
    required this.builder,
    this.policy = const GeniusErpSlotPolicy(),
  });

  final String id;
  final GeniusErpFamilySlot slot;
  final GeniusErpCustomSectionPosition position;
  final GeniusErpSlotComponentFactory builder;
  final GeniusErpSlotPolicy policy;
}

/// First/last-page replacement contract.
///
/// Header replacement is applied only to the first-page header slot; footer
/// replacement is applied to the final footer slot after all body flow is
/// complete. No physical renderer internals are exposed to the caller.
class GeniusErpPageVariants {
  const GeniusErpPageVariants({
    this.firstPageHeader,
    this.lastPageFooter,
  });

  final GeniusErpSlotComponentFactory? firstPageHeader;
  final GeniusErpSlotComponentFactory? lastPageFooter;
}

/// Generic labeled field shown with document-family identity/details.
class GeniusErpDetailField {
  const GeniusErpDetailField({
    required this.label,
    required this.value,
    this.labelAr,
    this.valueKind = GeniusPdfValueKind.plainText,
  });

  final String label;
  final String? labelAr;
  final String value;
  final GeniusPdfValueKind valueKind;
}

/// Named address section used by transaction and operational families.
class GeniusErpAddressSection {
  const GeniusErpAddressSection({
    required this.title,
    required this.address,
    this.titleAr,
  });

  final String title;
  final String? titleAr;
  final ErpAddress? address;
}

/// Signature placeholder specification.
class GeniusErpSignatureSpec {
  const GeniusErpSignatureSpec({
    required this.title,
    this.titleAr,
    this.showDate = false,
  });

  final String title;
  final String? titleAr;
  final bool showDate;
}

/// QR/image code specification for the attachments/codes slot.
///
/// [image] is preserved as supplied and is never mirrored in RTL. When [image]
/// is absent, [data] is rendered through `GeniusPdfQRCodeGenerator`.
class GeniusErpCodeSpec {
  const GeniusErpCodeSpec({
    this.data,
    this.image,
    this.kind = GeniusErpCodeKind.qr,
    this.barcodeType = GeniusBarcodeType.code128,
    this.caption,
    this.captionAr,
    this.size = 80,
  }) : assert(size > 0);

  final String? data;
  final GeniusPdfImage? image;

  /// Whether [data] is rendered as QR or as a barcode.
  final GeniusErpCodeKind kind;

  /// Barcode symbology used when [kind] is [GeniusErpCodeKind.barcode].
  final GeniusBarcodeType barcodeType;

  final String? caption;
  final String? captionAr;
  final double size;

  bool get isEmpty => data == null && image == null;
}

/// Complete high-level plan consumed by every generic ERP family.
///
/// Slots can be replaced or extended without subclassing renderer internals.
class GeniusErpFamilyPlan {
  const GeniusErpFamilyPlan({
    required this.document,
    this.calculation,
    this.company,
    required this.title,
    this.titleAr,
    this.primaryParty,
    this.primaryPartyTitle = 'Party',
    this.primaryPartyTitleAr = 'الطرف',
    this.secondaryParty,
    this.secondaryPartyTitle = 'Secondary Party',
    this.secondaryPartyTitleAr = 'الطرف الآخر',
    this.addresses = const [],
    this.detailFields = const [],
    this.notes,
    this.notesAr,
    this.terms,
    this.termsAr,
    this.amountInWords,
    this.amountInWordsAr,
    this.signatures = const [],
    this.code,
    this.footerText,
    this.footerTextAr,
    this.slotPolicies = const {},
    this.replacements = const {},
    this.customSections = const [],
    this.pageVariants = const GeniusErpPageVariants(),
    this.hooks = const [],
    this.showLineDiscount = true,
    this.showLineTax = true,
    this.showSummary = true,
    this.showApprovals = true,
    this.showAttachments = true,
  });

  final ErpDocumentContext document;
  final ErpCalculationResult? calculation;

  /// Existing report-header company metadata, including logos.
  final GeniusPdfCompanyInfo? company;

  final String title;
  final String? titleAr;

  final ErpParty? primaryParty;
  final String primaryPartyTitle;
  final String primaryPartyTitleAr;
  final ErpParty? secondaryParty;
  final String secondaryPartyTitle;
  final String secondaryPartyTitleAr;

  final List<GeniusErpAddressSection> addresses;
  final List<GeniusErpDetailField> detailFields;

  final String? notes;
  final String? notesAr;
  final String? terms;
  final String? termsAr;

  /// Audited/localized amount-in-words prose supplied by the adapter/app.
  final String? amountInWords;
  final String? amountInWordsAr;

  final List<GeniusErpSignatureSpec> signatures;
  final GeniusErpCodeSpec? code;

  final String? footerText;
  final String? footerTextAr;

  final Map<GeniusErpFamilySlot, GeniusErpSlotPolicy> slotPolicies;

  /// Replace a standard slot with a semantic component.
  final Map<GeniusErpFamilySlot, GeniusErpSlotComponentFactory> replacements;

  final List<GeniusErpCustomSection> customSections;
  final GeniusErpPageVariants pageVariants;
  final List<GeniusErpFamilyHook> hooks;

  final bool showLineDiscount;
  final bool showLineTax;
  final bool showSummary;
  final bool showApprovals;
  final bool showAttachments;

  GeniusErpSlotPolicy policyFor(GeniusErpFamilySlot slot) =>
      slotPolicies[slot] ?? const GeniusErpSlotPolicy();
}

/// Adapter boundary from application/legacy data into S06 shared ERP data.
///
/// S08 families are module-neutral because they consume this shared domain,
/// not Sales/Purchases/Accounting module-specific classes.
abstract class GeniusErpDocumentAdapter<T> {
  const GeniusErpDocumentAdapter();

  ErpDocumentContext adapt(T source);

  ErpCalculationRequest calculationRequest(
    T source,
    ErpDocumentContext document,
  ) =>
      ErpCalculationRequest.fromContext(document);
}
