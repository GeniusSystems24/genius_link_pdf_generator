import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Result returned by a dedicated report-template example builder.
///
/// The wrapper keeps the generated document builder together with the file name
/// used by the explicit Open PDF action.
class TemplateExampleBuild {
  const TemplateExampleBuild({
    required this.builder,
    required this.fileName,
  });

  final GeniusPdfDocumentBuilder builder;
  final String fileName;
}
