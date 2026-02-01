import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../../main.dart' show geniusPdfConfig;

class NewTemplatesDemoBuild {
  final GeniusPdfDocumentBuilder builder;
  final String fileName;

  const NewTemplatesDemoBuild({
    required this.builder,
    required this.fileName,
  });
}

GeniusPdfConfig createNewTemplatesDemoConfig({required bool isRtl}) {
  return GeniusPdfConfig(
    baseFontBytes: geniusPdfConfig.assets.primaryFont,
    baseFontSize: 10,
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}
