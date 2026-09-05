import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused Long / Multi-page Baseline S00 regression example.
class S00LongContentDemoBuilder extends GeniusPdfDocumentBuilder {
  S00LongContentDemoBuilder(super.config);

  @override
  void build() {
    newPage();
    for (var i = 0; i < 90; i++) {
      addLine(
        config.isRTL
            ? '${i + 1}. هذا نص عربي طويل للتحقق من تدفق الصفحات — '
                'SKU-AR-ENG-001 — INV-2026-000123'
            : '${i + 1}. Long baseline content for page-flow verification — '
                'SKU-AR-ENG-001 — INV-2026-000123',
        topMargin: i == 0 ? 0 : 5,
      );
    }
  }
}
