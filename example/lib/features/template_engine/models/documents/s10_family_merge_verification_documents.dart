// Generated from the former aggregate verification page.

import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates the S10 template-family audit document.
class S10FamilyAuditDocument extends GeniusPdfDocumentBuilder {
  S10FamilyAuditDocument(super.config);

  @override
  void build() {
    newPage();
    addLine(
      config.isRTL
          ? 'تدقيق عائلات القوالب — S10'
          : 'Template Family Audit — S10',
      font: config.headerFont,
      topMargin: 4,
    );
    addLine(
      config.isRTL
          ? 'يجب أن يبقى تعيين العائلات ثابتاً ولا يعتمد على اتجاه الصفحة.'
          : 'Family classification must be stable and independent of page direction.',
      topMargin: 4,
    );
    addHorizontalLine(spacing: 8);

    for (final registration
        in GeniusErpExistingTemplateFamilyRegistry.all) {
      addLine(
        '${registration.templateType} → ${registration.familyKind.name}',
        font: config.smallFont,
        topMargin: 3,
      );
    }
  }
}

Future<Uint8List> buildS10FamilyAuditVerificationPdf(GeniusPdfConfig config) async {
  final document = S10FamilyAuditDocument(config);
  try {
    return Uint8List.fromList(document.generate());
  } finally {
    document.dispose();
  }
}
