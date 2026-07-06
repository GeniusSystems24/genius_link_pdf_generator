/// Stable package-owned API for Genius Link PDF Generator.
///
/// Unlike the legacy all-in-one entrypoint, this library does not re-export
/// Syncfusion, printing, sharing, AI, or experimental v2 packages. Existing
/// applications may continue importing `genius_link_pdf_generator.dart`.
library;

export 'src/core/pdf_config.dart';
export 'src/core/pdf_assets.dart';
export 'src/core/pdf_logger.dart';
export 'src/core/financial/financial.dart';
export 'src/models/pdf_image.dart';
export 'src/models/pdf_result.dart';
export 'src/domain/models/pdf_delivery.dart';
export 'src/domain/models/pdf_operations.dart';
export 'src/application/contracts/pdf_generation_ports.dart';
export 'src/application/contracts/pdf_document_processor.dart';
export 'src/composition/genius_pdf_composition_root.dart';
export 'src/builders/pdf_document_builder.dart';
export 'src/public/genius_pdf_client.dart';
export 'src/widgets/pdf_preview.dart';
export 'src/presentation/controllers/genius_pdf_controller.dart';
export 'src/public/genius_pdf_preview_controller.dart';
