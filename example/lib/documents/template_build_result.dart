import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

class TemplateBuildResult {
  final Uint8List bytes;
  final TemplateDefinition template;

  const TemplateBuildResult({
    required this.bytes,
    required this.template,
  });
}
