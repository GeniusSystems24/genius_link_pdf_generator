import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/text_typography/models/documents/s01_directionality_verification_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/verification_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S01 example for Logical Geometry.
class S01LogicalGeometryVerificationExampleScreen extends StatelessWidget {
  const S01LogicalGeometryVerificationExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerificationExampleDetailScreen(
      sprint: 'S01 Directionality',
      title: pdfLocalization.logicalGeometry,
      description: pdfLocalization.s01LogicalGeometryVerify,
      apiName: 'buildS01LogicalGeometryVerificationPdf',
      icon: Icons.swap_horiz_outlined,
      generator: buildS01LogicalGeometryVerificationPdf,
      fileName: 's01_directionality_logical_geometry.pdf',
      usageCode: r'''Future<Uint8List> buildS01LogicalGeometryVerificationPdf(GeniusPdfConfig config) async {
  final direction = config.textDirection == TextDirection.rtl
      ? GeniusPdfDirection.rtl
      : GeniusPdfDirection.ltr;
  final directionality = GeniusPdfDirectionality(
    localeDirection: direction,
    documentDirection: direction,
    templateDirection: GeniusPdfDirection.auto,
    componentDirection: GeniusPdfDirection.auto,
    elementDirection: GeniusPdfDirection.auto,
  );
  final builder = S01DirectionalityDocument(
    config: config,
    directionality: directionality,
    scenario: S01DirectionalityScenario.logicalGeometry,
    valueKind: GeniusPdfValueKind.money,
  );
  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}''',
    );
  }
}
