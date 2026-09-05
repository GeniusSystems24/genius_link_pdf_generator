/// Stable package-owned API for Genius Link PDF Generator.
///
/// Unlike the legacy all-in-one entrypoint, this library does not re-export
/// Syncfusion, printing, sharing, AI, or experimental v2 packages. Existing
/// applications may continue importing `genius_link_pdf_generator.dart`.
library;

export 'src/core/pdf_config.dart';
export 'src/core/pdf_formatter.dart';
export 'src/core/pdf_theme.dart';
export 'src/core/pdf_print_theme.dart';
export 'src/components/models/pdf_styles.dart';
export 'src/core/directionality.dart';
export 'src/core/pdf_assets.dart';
export 'src/core/pdf_logger.dart';
export 'src/domain/financial/financial.dart';
export 'src/domain/erp/erp.dart';
export 'src/components/erp/erp_components.dart';
export 'src/families/erp/erp_families.dart';
export 'src/models/pdf_image.dart';
export 'src/models/pdf_result.dart';
export 'src/domain/models/pdf_delivery.dart';
export 'src/domain/models/pdf_operations.dart';
export 'src/application/contracts/pdf_generation_ports.dart';
export 'src/application/contracts/pdf_document_processor.dart';
export 'src/composition/genius_pdf_composition_root.dart';
export 'src/builders/pdf_document_builder.dart';
export 'src/public/genius_pdf_client.dart';
export 'src/presentation/views/pdf_preview.dart';
export 'src/presentation/controllers/genius_pdf_controller.dart';
export 'src/public/genius_pdf_preview_controller.dart';
export 'src/families/erp/existing_template_family_registry.dart';
export 'src/printing/profiles/print_profiles.dart';
export 'src/packs/erp_packs.dart';
export 'src/template_engine_vnext/template_engine_vnext.dart';
export 'src/compliance/compliance.dart';
export 'src/quality/quality.dart';
export 'src/template_designer/template_designer.dart';
export 'src/industry_packs/industry_pack_api.dart';
