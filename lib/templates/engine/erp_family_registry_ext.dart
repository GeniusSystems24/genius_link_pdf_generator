
import '../../src/presentation/document/families/erp/erp_families.dart';
import 'registry.dart';

/// S10 bridge between the generic template engine registry and ERP families.
///
/// `TemplateRegistry` continues storing template-engine definitions. This
/// extension adds package-owned family metadata without changing the existing
/// JSON/schema behavior of `TemplateRegistry`.
extension GeniusErpTemplateRegistryExtension on TemplateRegistry {
  /// Family classification for a public template class name.
  GeniusErpDocumentFamilyKind? erpFamilyForTypeName(String templateType) =>
      GeniusErpExistingTemplateFamilyRegistry.kindForTypeName(templateType);

  /// Snapshot of all package-owned ERP family mappings.
  List<GeniusErpExistingTemplateFamilyRegistration>
      get erpFamilyRegistrations =>
          List.unmodifiable(GeniusErpExistingTemplateFamilyRegistry.all);

  /// Whether a set of public template type names is completely mapped.
  bool coversErpTemplateTypes(Iterable<String> templateTypes) =>
      GeniusErpExistingTemplateFamilyRegistry.coversAll(templateTypes);
}
