import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Minimal Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `minimal_header_example_screen.dart` and displayed as **Dart usage code**.
class MinimalHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  MinimalHeaderDemoBuilder(super.config);
  /// Extended company info with more details
  /// Info groups for structured header content
  @override
  void build() {
    _buildMinimalHeader();
  }

  void _buildMinimalHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'بسيط - Minimal' : 'Minimal Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader.simple(
        config: config,
        title: 'Quick Summary',
        titleAr: 'ملخص سريع',
        subtitle: 'Generated Report',
        subtitleAr: 'تقرير مولد',
        date: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.minimal(
          accentColor: const Color(0xFF424242),
        ),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Simple header with just title, subtitle, and date. No company details. '
      'Ideal for internal reports or quick summaries.',
      'رأس بسيط يحتوي فقط على العنوان والعنوان الفرعي والتاريخ. بدون تفاصيل الشركة. '
      'مثالي للتقارير الداخلية أو الملخصات السريعة.',
    );
  }

  void _addExplanation(String en, String ar) {
    addLine(
      config.isRTL ? ar : en,
      font: baseFont,
      brush: PdfBrushes.darkGray,
    );
  }
}
